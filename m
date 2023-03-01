Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4586A6B27
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 11:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCAK52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 05:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCAK51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 05:57:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C40E199C5;
        Wed,  1 Mar 2023 02:57:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnXITJHA1jSS+zSdqlaJ16C/4RPRB51u+bTu3otV5vU50WN3/+beo/hISMZ4wr+LqHwXQGd+9Vx2Ml9jRNCXVFM7Qh6REB35Gv4QvyM3fkcNIR5WGnOdNQSfQsk8Dsd0s+7iy9ATIaaQdKSafCZOcjxyCOh+ydEsyWGFimrxHCicjcZJS1FVcOYANE2PmAh9VMFqeAIl9N8LzanJGK4yYWlMeIyZbQG7LAffoU6hUDQ+u/zi+WFBIrtwGp+a825TZq0Xch0d99+cIJ74kHEMMHrk2DGspIKODM1tphq3lzF0ygfq4AC+iUt5rGwYxw7kSS1+LExekniGiihRqfpHPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whc4FP1khjhQqKvKa1AZKrKRbgcghoZtcCiMttyMosQ=;
 b=UoLxzdhzXXPUFIAkBhc8zg6+xGx6UsiEK8BWZjDN4j9IwhRN9uTPEdPdlZlJzrYHn9Xy85aA+v16GHjjjK90ZaN7fjMcq8MPUSthZNncAh/tv2GNPlpu3bbnEp1zY4aTR5jqhCsv97pYAth9S4wdJ6c2OtWxv+Uz8C4cxr9rGCJmXhb04RoHOFS9p5F7SoJxMvLiS4UrMoefEfep6FpRsosnnonciAG3DW4ZNmBv+nkiVDRw1JhC6FQX2rbbRt8gqK+ibmWLthrMowTPejwGNa+u48kAsTfJfuCo/SpOBeeSNNnClCfQvely6FvGhzRn/e1BBo6yM5TcuYNd3ttYmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whc4FP1khjhQqKvKa1AZKrKRbgcghoZtcCiMttyMosQ=;
 b=HGZkzJEJlYXtn+2yiLdRrmaXr+q5ydi4SYd0xpX+9XrUNLNdvUQSXcGleO07BWCcVV3aJ9xtwN1/Ij6lTCGM7K602B5l79EIyD6RlqihgWCXMFtKiEIMRcHiA/flDP7bQ126mAJ/YUH3GD4O6l99py+e4s2rVykySYyGkQVaTyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4117.namprd13.prod.outlook.com (2603:10b6:208:260::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 10:57:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 10:57:23 +0000
Date:   Wed, 1 Mar 2023 11:57:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] rtlwifi: rtl8192se: Remove some unused variables
Message-ID: <Y/8vjN8hcMU85bkC@corigine.com>
References: <20230301030534.2102-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301030534.2102-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AM8P191CA0013.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: ca5fdae9-2a30-42c9-6140-08db1a43bc84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2/yKvOn85qf1FHhqRipH4rwVdUvs02ZFU4xHcP0TYxOGwTL67PBFme3+xLQoMlUDJq70+k3+kA9k1eg6HSNtyoSxXzqZzj2AAzvy/FW/NQvFV5GVLCXThMiXtML9Zsi7j+Wx/+gnY4RMUJdXnJBDaW9wrM3VPxpLyfWh4+1BqnkEy17i0Lzugj0bGEi+CK/fMXrSeO1uljrMC8pP3cCQIAXG/WaZOQGblgra+1Q/hwxzuzfEf3UQ/vjyKiEx3F3XWCjdMnd4MyxJp69IXR6dIzJ8XyeIkjRYnFs0ububkPyjj3brUlIMwtjOgcW5DNf3yOcY7FXYQHcoyhDVibZRMKyODRNCLjVcfQbg3W+5xjNVeL43HRD1XNazyp1iASPJKVaPxv7eQHM2qVl1paBC53fXx7ifZcuVD9dRFzxpN5Qc7mIdlO/eK+sZF0lkLhDC0XFyztHRYp5AWaT22HROEBtlOwNelZX8rlKjrFHGfLxaoHw6Zio3GMOKjWxEkdyDWVv1vRKhdGFtUTrcAF79YQPwTYncGBnYv6OYmR34R8kS0aUdi/Z6h6tzroS+MFbkZEW4sIFfaGPg82Mpard1WZyw4g2YL4TYxyxs0sOarW1s4WVZzIPluyc0/kmEXLNqNYO4qi8TZWFxvhRRANFZXXD1+2m/5NhWNl36fLD0F85TI4qJXXbIP8QkO9l6iL6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(136003)(366004)(376002)(346002)(451199018)(38100700002)(86362001)(36756003)(2906002)(44832011)(4744005)(7416002)(41300700001)(66946007)(66556008)(66476007)(6916009)(8676002)(4326008)(8936002)(5660300002)(6666004)(2616005)(6512007)(6506007)(186003)(83380400001)(478600001)(316002)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UrscYoJWHaDTh6FI75gHPVQD/DvWupU6fIwzxgctChzPuGB8rq8LN7h8Whpe?=
 =?us-ascii?Q?yNwlARI7az0tck/Ru8HayVJL3cCc0+pmtY/NFHjztRoEMMREDLe+FrEBGFqe?=
 =?us-ascii?Q?dEUtPoFx9eGOxm0tthKPqa9EN8Nqe8For7Sn4DNs6f7MSn39Oz+g2o5uNdvh?=
 =?us-ascii?Q?KDHU3Y2mH111sPEJUvn0Z24y5oIa2FaLZeqpxZC2Xl0AXFe2hu9ebBTNMlmR?=
 =?us-ascii?Q?qmeLfZjgGtF/NIUR1X1+XpQbE0W87vJcztJ4QCkBeDU5DpQG5693ip7Q94va?=
 =?us-ascii?Q?ZhbM0OEo1+H1pSv6cPKa8w2I13pgliqkTX4qQc6/BrJh3KB4jeumGJ/l1yof?=
 =?us-ascii?Q?n/ZZqAAnG4EMelAhBJz3zCujQQpaHVNUemhPBA/fZJZcysuuDX48HTd3+VHH?=
 =?us-ascii?Q?jdeDNEw8KdzTiAmElyo9f5ACkHA5PQEUPbf/+Sgtd43rAnfPm8LJWgvvTFUI?=
 =?us-ascii?Q?IOkO1ocAV7+soOVsDERZe0CMh4llNXS2ZDvbXl/9+7E2iuandbFpoeft0WZM?=
 =?us-ascii?Q?jB3hMeGsXyeqDcGSgd2Jmig8gSFof1m1XEQeEUhdaCQNmcqSdj+f9seei7kY?=
 =?us-ascii?Q?Xl3w9EnqijAWNajsG96/Fdzpkb6mxkSw7YlV9gHpWslUNyrbD3lNCdRm8458?=
 =?us-ascii?Q?/h1wSDkA0vDVqO9RFYRhKR+nL3/nalADboOh5boDsElOukptcVkpeeFZuI/W?=
 =?us-ascii?Q?yfw0sgtr9YReSrcaG/LbHbRw4cMH1Qwlu6Og26An0dsWLjU0tp4EjIEIF6ai?=
 =?us-ascii?Q?qy+R4u5oIYwvn5onxAVD01ZFJ7nHq9QxeILP9PJxwpE6Vby/9KAObeATIZdp?=
 =?us-ascii?Q?3jfXiBIa8KKn9tlY2oWGTIQAgsHtoEyX/koNqAoQPiIyK+KC0MarctAE7oCN?=
 =?us-ascii?Q?Q5gptrS5q7aMj5UUOiWghMjoIvEhPbc4QL99JUdiYENVy1IWaumSvgg9Stuo?=
 =?us-ascii?Q?1o1Pilk/R4ASTfXqF4C0O9c0JbSp2nq+Z5OAlI9WJHryZwVLvwj+EYqBST9u?=
 =?us-ascii?Q?VciRjv2vpTRZTFxMhHlz+DrpHq0NGiS6ekoJAEr+8QP6Lp7nNUnMVSs/xCFr?=
 =?us-ascii?Q?/JXrwVUcFGTlTXOap3Lvx6KeDnWVAsO/o6Ct3xSWHox3UZFmW5mOrZLLpLnL?=
 =?us-ascii?Q?uIIvwAM3GPT1cFa2OFcCjmjJexf5mBfSaQZ8FWB3SJ1wW3PkV5deIGdaSRtd?=
 =?us-ascii?Q?SDDACQQ8IS0AQcAtNl7akOLIvy0fwtUx2uvI/4Q8sp/mOUfMK50JikawOapF?=
 =?us-ascii?Q?uOVOrpzqc6eYKd6Ca9hqZzIPr9WfStAhVkiJzDCsfBHwLNgLEMYygXM5XJjT?=
 =?us-ascii?Q?+9ViHud/6EQhIqF143fZkB3k1IRqc3Xh/Z3X+uqw8mMOYtw5lV7fTyzBJRdm?=
 =?us-ascii?Q?SCyufifyjQjB/OEQo6g1jnveQJZotJQ4rVbIr6aO49BscsTN9aN9TA3rDuig?=
 =?us-ascii?Q?SC2dsZdsqCNCbFM08tAeyZXrBtcuudsabvFeDivpxaBSV4E4lx6HX1UYlKXQ?=
 =?us-ascii?Q?nDdT4clriX7sBni83oxa34jBimG/20a3ZNYBL8136FGJb1nbeoMT30hZtLLK?=
 =?us-ascii?Q?1sSZCqdUgq/VBaUR6tXrjn2ivxm07C3TZ3xBtkYLtBtNDAF/pG8EtDdFCGVz?=
 =?us-ascii?Q?sb6/vMzyX2NPFdNMMMdkk4xoQte/+EEtlC2eP6cngVjg3whJSVrdPwRh4vWQ?=
 =?us-ascii?Q?xRWH+g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5fdae9-2a30-42c9-6140-08db1a43bc84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 10:57:23.2542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AW/Tnckl8kRyDCfSVMWWkRoGZ3pkmu7xP9Ua+z6zJN95Xm/3b+uRme+otCnHCaSJOd/xQQLRvV0VTvQRyoMYAeWW/LsO+9PPFrHXhs1Girk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4117
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 11:05:34AM +0800, Jiapeng Chong wrote:
> Variable bcntime_cfg, bcn_cw and bcn_ifs are not effectively used, so
> delete it.
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning:
> variable 'bcntime_cfg' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

