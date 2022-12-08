Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E436473C8
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiLHQCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiLHQBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:01:55 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2138.outbound.protection.outlook.com [40.107.95.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BC19B29D
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:01:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCho5U9ce2O+/wf8+ZvvIJqe6wj9h/0SJ+/pNUemutEjn63RXU1o2OJoLz+D6643/EdLnZ5yVDjUfYcUFpIHkkq9p6Wh1pMoETej0S97emeZKKvaoNy15IOfvLAxn36XyO3/FVBG7PRvrZ7Fdb0xtp7HcqfFM0eRaCGHcjcXeXaeX4WIewLZu0C5OwXha5dYoRjNQlt+86Gq3vcryjYXKpZq+vFvgKspI5m5r1/IxbsdUmyFgB+CiJ6iu6tIP9VMWgCKGkf9ZHCKzBiJgJIJPdwxb/zY1Am27/03bsmrlymuTctUxgHiHHflriSaaQKDwOawXuYYKhGOZO40u0z2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXvVMAGVeZFKZX3jSiUIOL5yx9j7ExEgO2b9MFIs1Gc=;
 b=AaTpmOoLppJJVuCLS+A5SGf4Yof/2E6aiJIYHJxChrcrSkhm+/Dfn+rabW1Bz1f09qU4gNQ6ToEHkn5oyxG1QarqYwI0YbEb7VkgUSi9ipCZdHY9fncDKYnlVmI6dbiX/ccf3XSXhp8YLLLPp/UWpO4YskD9lS2DSK+lKiQxcbF/iBJ4FICdizxiIXwN7fvJYE4wCue0lxeLH1n5KUKdUgjtza9cWu2p5LgWl0UjNI0ZzS/4H+VYzQA3tJmDvQCu8M19ZEdM7Z/HMuMvF/VJl/cb+PuFNY5RZ61O0mrk2u/XDpaDyCKnvDmrA8DDUUB5DqpNsS0BgQJ2fs9LeNg4rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXvVMAGVeZFKZX3jSiUIOL5yx9j7ExEgO2b9MFIs1Gc=;
 b=gGcEmWnL6cICWt0wIeEpJH6i8ksjOW4LYtt0KtvPdyMT1ta3o8RftH70yn2rtUATjB4KMyNkF8hEy65QzaoEgQvzs+7tqLkSPTSNnuQTMWbxRhlv10bxbPAuah1b66ihzqmXJNcQ4tZC2B6LfhqpSQUEHuEbzj+Xybq3XnhLGVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5483.namprd13.prod.outlook.com (2603:10b6:303:181::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:01:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 16:01:48 +0000
Date:   Thu, 8 Dec 2022 17:01:42 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jiang.wang@bytedance.com,
        john.fastabend@gmail.com, jakub@cloudflare.com, andrii@kernel.org
Subject: Re: [PATCH net] af_unix: call proto_unregister() in the error path
 in af_unix_init()
Message-ID: <Y5IKZiSCNv34EJSI@corigine.com>
References: <20221208150158.2396166-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208150158.2396166-1-yangyingliang@huawei.com>
X-ClientProxiedBy: AM3PR03CA0062.eurprd03.prod.outlook.com
 (2603:10a6:207:5::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5483:EE_
X-MS-Office365-Filtering-Correlation-Id: 6edf895f-8cb1-4043-3d10-08dad93582da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AW9SfIO/YfhRKBFvgiDcq5jcfOfPnv+8YkiR8sD0l8/55yiAQWU5lLutkCNf2ComS1GGnD5qVKF4bAHVg+Y1UbrxgsJ/5r5GRm+AEJVwnWnyD7AJQ1pq0g+cTQdRqFdEjvASXroK/D2DeCk/PK8o/Ikk7yImtPouwe4B9OE2NP8C42qiXXTscpts/aEA9ImZ1S91sYLQtfY8xyL3b1c6xvrpiqWQOx35J6hlOb7odQFf6r1R2XTWQ6+vDzfaBnLgUdkGL97dgPWs2SWDpwSr+dpDHwwmRko0Hp+i5/sPMqHB2cvoGLb0O6OuQjBBgjP+hDpBWwE6L3xb5m7Z8TEsuBFaBdN7NBv8sybCNo+7X3HOYRjI0mrnfCXeMUzlCIP2pzdnJHKK0NY058QUdUaIfgVTiLA1liXdg6NbQXUeBSEJycSFIPKX6lvBQRvsfd3cJoDs/69rvIqutVzM8EBADOcqXEBjlMpj3islOGIgWOYaaEzWvUOLmepmDcFU68RMakf2gPzujF5lOq6dEIvSnaCj+uQUhUyrBq5UQ/L7kxTgMcp2PrIqnjF8zAeVPVLUEJ0yp3/YjXFZP1i9oLRhhfqxcQOShwB4hCfQiYbqtUomy1UtHBnRZfXkmz6wX1Pijg4Kv2x1x/4iwRt8wKrMWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(376002)(396003)(346002)(366004)(451199015)(4744005)(5660300002)(86362001)(66556008)(7416002)(8936002)(44832011)(4326008)(2906002)(41300700001)(478600001)(8676002)(186003)(6512007)(6666004)(6506007)(6916009)(6486002)(66946007)(316002)(66476007)(2616005)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?26Kb8YQtvCUilycTlfQPy8yoc6tfin4X3UhRJAW4BnDPxHw8HEwbB66a+Nni?=
 =?us-ascii?Q?o4yYyRJ9YRQDRDVbyDA2c7TOiwPUhasyi/g+6I8LdIi5Gut9RoIcSkhphU2D?=
 =?us-ascii?Q?MvKOzG5bCppZWWijoYs0kBwC3wPqs0omDzRJ+vo/cmB0RPJZ9pXwZ8ioCPLU?=
 =?us-ascii?Q?Gh+yQufJ7msx6JZ5OyMB5At4+sRNbB/h0RHWwwDuS/tL9xpWaqNhBuEHXwTg?=
 =?us-ascii?Q?Y+seO1XljjYOT6mM0cdQaLyJ37okI6PEtwi9P9zTwvttFkPUhFKorT2Vhcmk?=
 =?us-ascii?Q?LCQewtuHA+5SJ51/9I/4IHBNOLALUO4K31RRJ9m0lCIc+CvWvloBfOajWR+1?=
 =?us-ascii?Q?3KKophxfhXlq/qmGNcTh3eYnTiH6A9gq/YVWfdlsTHHv4zbqyYSp6b5o4FLZ?=
 =?us-ascii?Q?GxYkGHhWLBEIOiqh+5aHPY7pvdQ359ROVA95thItiD1iAYmfNPrUzfGzkF+b?=
 =?us-ascii?Q?F8hJS+0v3SixlCKjBZNrK2QZX3b6F31Z/rkD2Dya9GsUCnvONhknnK58VDPM?=
 =?us-ascii?Q?X+nb8DSE7WYGzM04/9nwUA92KWoKTuX7fEYJA+kbHiKPKyeDuCBz5XyHAf+b?=
 =?us-ascii?Q?M/iTt3sYubLm070Q7YMz2A3A4Jx9VKixUDMDGrROAXoAyWOlqtpq8Vq/7rr9?=
 =?us-ascii?Q?zbcL42uENzWe/cGTSznxoY+CKSL7CdB9D/TpkvllFW5R8XjayhikRFKxJ91Y?=
 =?us-ascii?Q?xK9JVK/R4tXG7c4a0EKbzpKGMAsdG7vuN6zh0m6fKpQjywVqPSoaa9OMMgS5?=
 =?us-ascii?Q?YYBKtsFjMLP3tOEcb57AVBP2rq1R00Pm0JpnLj3j17V3fBAOAhkQUZ38ltlF?=
 =?us-ascii?Q?Q9arr5jeDiDZ+DGOnpLQl5f05Ffy2FldBtOucdDPY0yes3asI0QaxkQyq6s6?=
 =?us-ascii?Q?nQrLDgIKMe57xLr3YQhqhEuRLGs3X6dIAOUVZd82mbNTdh0E23Iy6vEx5UwS?=
 =?us-ascii?Q?mRMXeitu7VRFlUb4+ZndFQdZTiNRYNcaV723F1PZ5Hq4oLvssDodHKoFGfSr?=
 =?us-ascii?Q?NyReb8lsZDna/JB5K4yLe615PJveAoP65lQfb6hhe3F4e0VmwCZgsRWinn7c?=
 =?us-ascii?Q?E2PhwBHrx3tOfTEVEfv8BHeIvfQEff/5sa8A5CcL4z8FN6u0UKMP8XUzg5nI?=
 =?us-ascii?Q?Cg0Ae0JwXGhOLZtJHdmWOcj45Enn8jGxo+/ehh/sOWPHJZ1ia4vWTRdPW5mU?=
 =?us-ascii?Q?PfS3D+N6IgmON0I9vZrX5DBXY8ZzKUckf0e2Q0uDXWjp9mWCTWGoAVZgg9rK?=
 =?us-ascii?Q?bGv/ak5YCg0Oa4HprmPZtENWw+zP2xiL5rlUogVXfQe4fIZmNZJyjryNc3Dh?=
 =?us-ascii?Q?MenuBi2o7qiEpfHF59S27ljdLRvTKztiCdghVf60Z3nbma6DhLFdw+cMhsV3?=
 =?us-ascii?Q?p42DHh+/vR6JfKwTDMUjGOMKbUBjZK7yQaxcUnwNFJQyBUo6gtbQDO4KS5x9?=
 =?us-ascii?Q?Km0wiqZ0nbzv07m+eLR7Et9NkU+SztoPqFkKChnuIXLug/iwiNRko7sqah2D?=
 =?us-ascii?Q?ClqFcAZNwh+wB3yOV+AGdELkqkOtwBWAKE3WhNseiAc01Gsrjp6QzBfWPxV1?=
 =?us-ascii?Q?MAl9iNIjYqnx0ZjcgB4qVZs4QXbkclK1jDrNrVy+0NrUsI52IyUYhNqvQZKv?=
 =?us-ascii?Q?Zx3XMfBPgecQisVpjb1eAPaqWPr1YFwB4sUvT6Gh8u84FEOwHg4dFj6/+c7M?=
 =?us-ascii?Q?j53kKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edf895f-8cb1-4043-3d10-08dad93582da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:01:48.3180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Nj+g2k6f5/WdvekmskDUfV+2SBmXFHhz0o+qZHeoeqCoBRpjkedZzGJL+CeCknFEFvSoCJ8/f6wDB5hJaSbaI4ndYIEWBe4Tl8ZzqGEimo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 11:01:58PM +0800, Yang Yingliang wrote:
> If register unix_stream_proto returns error, unix_dgram_proto needs
> be unregistered.
> 
> Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
