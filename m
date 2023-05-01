Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23DE6F3295
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjEAPKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjEAPKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:10:31 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2112.outbound.protection.outlook.com [40.107.95.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BA21A1
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:09:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIlye3TpB/j2DDGwEgKBhwB6q1NMEPB2rsFlE2N39+PUEXhHl8zjtBEoXZZmHfhJpblj9M5fNk+s2yRjEC5lmf8OkAgXNCi3uy6nl9yKU3lSok46RE0l4i7I2vOJ+8J5SO+2826sObj1CUzTFpfJ5eOQj/QgPBcRECDImmtYczEz/oE5eaTShS/NsBrtdhqxaskbk97NOdQdDCGdJejl6g+cTgq53ux7LjHdFKwRpyRoyBoDelsHduGsgO0PY7uMdTiedLrtZ/TaJzsfsWCqoBTEd9lzQH120RdQO5LQi52882Bj3IZy9zULOUmOMsRlGYfgzOSfCMsOPiwod22Dxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyPLGYVDjP2GJdWq/s0j1ESTGMFWQxBrXsb0N1rdX5Q=;
 b=L4Z14YoA0Ua0pzFL6eEjg3NfxF11TMN4RMyW8MyiIcwGDYjFgH1gzWbOQIW+MPaWPUXnAKGeFDBYD7sqmfNOZ0JvdJcGViOrZ1Jqq3fBtzp10SHeD56Q2XEKa/G8q7nlyG0hhk9g8timCy9o9j7uUiqb+WBm9hx2i0h4e+21/weNMgxlzZYlXtFNQZGhab6+93W7LMGkuGodzWQGDlR/pLYFDDm+oJmHUDNDoU945XcaDNzf9kJxBuuCWER8bz+sE4UQfSfc/fxuM4cZIuA3pNUhgIotqHx//zBRS1l/G9YmvqaVX/0A0Qkl0lKn0romkkmkyoOMPxoU8xDf8ZIdHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyPLGYVDjP2GJdWq/s0j1ESTGMFWQxBrXsb0N1rdX5Q=;
 b=fjXnVOT+W2jNccEYLFEp80mKH0HFIP8Lx8tehKq4CXJCpM3xlI6sVPYCxtH2Kxzv37MnQ4l2tuV093yGWhXW7otyyIvPc2g0d+dzG6ejXT1jXG6qTTYUe43wgIjg00/tM4AOPRjdPG6urNEZCyBZM0bo0okvv6t5nj/QoOpPNBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5059.namprd13.prod.outlook.com (2603:10b6:a03:36e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:09:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:09:46 +0000
Date:   Mon, 1 May 2023 17:09:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 08/10] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
Message-ID: <ZE/WNDdm2Q13KfEi@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-9-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-9-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P195CA0042.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: 024fe23f-db89-4acb-cf26-08db4a5619ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQ6dIPn47CRuvVureH22XhAhqixm2VlnwgTmhNicOaeaAn1dW5aBzjuQkh5CWW1H+oS+u4afNPrv33EDEh2euh/ooW25SRx3+S4czQ5gQhutZQ3Z0e8tJKe+0uChLrJ4e1JR30cNMJvX1O6KIPy743Fw2SCdwoxA1KBCdsxGGEWyrtxtIgfqEvRvDwGgc9csyT2/cYINKuvUyIxYciniFbeGVJf89ybJhnubYLsoHATcC0XROhsUtQGe4G5hLZSRQRlJSJC0X19eXelnDyhlrGDOSX7N2A7UvWVh3FLkkBZ5ltSHp1sC//j8H0iuFSn3mEmqPs48Z5bcdjhlm3OZ28URIKQfhr2V31KT5/9Yb5zcFpj/m+MpLSyzCScPhdggjW2mwuxCVKPgCkrVis7Nhfk7Fn/DIf2QRVWwVCQO+pSHXG8GgGTB5ILZ77OL2zAu4+zqnVZAdwtFPeek+zpZ8Wtf9JNobNRhsUUEv9VvbmycgJuzSYZzaZySbSMGORjhDldVLkZLVY/+Y2H9rVRstDaIfjup1HjYBmmu8T/98Dch4TX8fyY/sM5oawcdMwOk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(366004)(396003)(376002)(346002)(451199021)(86362001)(83380400001)(6486002)(6666004)(2616005)(6506007)(6512007)(186003)(44832011)(4744005)(2906002)(36756003)(5660300002)(38100700002)(66476007)(66556008)(4326008)(66946007)(6916009)(41300700001)(8676002)(8936002)(316002)(478600001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R1U4MEQU0olPC9T0Jekh6uHwQPOQw6D8NFNM7aflShlXVLl00og1E6xMDId4?=
 =?us-ascii?Q?ZwdpRDxpVxzJx6HfmDwhzTZxiB5LJSc0EJbm4p8reggoo9SaHyIBLODv0/pe?=
 =?us-ascii?Q?sloXdiIxN6vbT0clTuzW7ik8cbbjgEtyq6EB22r5Gz4jBDL2e7U9QH9/bjoH?=
 =?us-ascii?Q?W5wJVDPkuFpD2Z2FVfAMLlS2juOFccrwr+ViFiPzrSwtay6HNbqmEUXbrV4l?=
 =?us-ascii?Q?ayXKc0j9rcsvzJNFfKVHXsZGrn1RzSxAKNl3sSzviZ3Grl2+QAvk4OIkpRhb?=
 =?us-ascii?Q?uqrDbMvp3tTb2H6Xbz3l8YuJ2S6Eaqm8aGflUzZbibtubMJLKIYo2Q5IKHP3?=
 =?us-ascii?Q?zOVXydluNwY1UuvTOE6AmV5mpSbnbeZpK3n2/14L1z3TbHSq94fBk099fnaG?=
 =?us-ascii?Q?19njZBJ7T6pT5wc/h/LkQzI87KwM7t6OUP2mcGnWikWejHccZ4ZASG8yovRX?=
 =?us-ascii?Q?vXul8QoisCmK3kEjDPyyFxYG+bpWUZXVLUw4n/dH9fUgAk+XrurNVYb7ELc4?=
 =?us-ascii?Q?xQv4HhOhJQYcQqmilATbUY3bSbpK1qCIyt3tCkER2L5C0cBBcrOdUghYzKyp?=
 =?us-ascii?Q?eGffxCBVnZ1fSQf9uNXPrmeaoldAdu0zP0acyz8jCvDS/YBkYvBEi90uxlQi?=
 =?us-ascii?Q?HEuHwWL53lFGE7FquNMN0Aw4rb8ESeH+g097Stx0jF9gIjl2G8sZHVSUos0Z?=
 =?us-ascii?Q?i9uxuvXcKvVGpnH+u8OI2FYyWGgSxGUY1GsFReP8NL6MbHv49ZNSWV4BopjP?=
 =?us-ascii?Q?8LWtgyWUK9NO+gZa3kZN2TYmqDOvwKtnnUevh7+cBvteTNMITXx8SqGCQPeY?=
 =?us-ascii?Q?ZXeaN7Gh4Rxnj77LR49aTq8+2SAIruPFktc+xUIc4taxb9PNcAcjQ1bUR2Vw?=
 =?us-ascii?Q?8S0pb0Ex51ZUetlHvuFBa6zWR/YnSXVWkAcpzu4k77OhkLrH4L0C973JUXet?=
 =?us-ascii?Q?3T/mYK3dS3HlGUp2tBp+Z5dFoNh1wUCjqhzzJEUk0qhxOfqZA/3EQlCtHYdX?=
 =?us-ascii?Q?cTf1nexbwy0EmiQREE5OF0uYXk3HuHnkN9sPQucuYTk2LYo+xjtBJTi/dV4R?=
 =?us-ascii?Q?CEdPQwE5M9X1gElBGunydkn2fYfbeiBkU6xmtEkZd7AGO6m5JSRpNcBUKUNT?=
 =?us-ascii?Q?qVJTjDQa3NRZrNvkai/xZ5S/kJoIsbtyknayB9IqgZUJRidIDsdypnsFjeR1?=
 =?us-ascii?Q?jcpETydxEQQFQ570JU99pwt53B9kHohdfvSW5hs0zoCEYXFC/6No4fhQyIwb?=
 =?us-ascii?Q?wOkTN6Nc71VXkflRvC4Y/VIq19GwoksIQM7tFGOFdWJMBDxRB4zPVKjCCXzZ?=
 =?us-ascii?Q?uRVD79u7PXXIh6GA3+RlHGOtxMACXOTogZZ682cdYbBdbz/dsYgYdYxPiuVe?=
 =?us-ascii?Q?3vUGLwOvMmEHw8XM7h9mmMk5TGKqy1OGi2QxHI22aAX2TixOEAgCmBaR6muu?=
 =?us-ascii?Q?y6VoKo9Afu15wuwCifrJsnNmm5OiBKkLznuLsdPa7Wjq90qYSNTIqQMMGyfx?=
 =?us-ascii?Q?Wibe6VYls4tzqAFpckubaQLwHu05fvVsismaUeCL5B3ELLTIwo0CgsES7YEJ?=
 =?us-ascii?Q?jr+HAO7nffLthP7MAB1LVqrQoDW/6cbZPqruc2UhmrM/rWAkhkijXYsYvsSy?=
 =?us-ascii?Q?hEU6IE0Ayspop0LDoE5O+5BelKq/IeO8LbZrqa0mhV+1aP0VUMoS25M2foph?=
 =?us-ascii?Q?SyiFTw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024fe23f-db89-4acb-cf26-08db4a5619ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:09:46.3288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iJ5er9/msZbfWgC1tHMpE6ZT38ptbVGdlcrggJ/qN29WumLP9IApPndLp6vwgNVJeoTEgBHmPBCgsKa1P6VWpBtlwlH2XeoUw954k9YGIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:26:00PM -0700, Shannon Nelson wrote:
> This is the vDPA device support, where we advertise that we can
> support the virtio queues and deal with the configuration work
> through the pds_core's adminq.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

