Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF34968EB
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 01:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiAVA47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 19:56:59 -0500
Received: from mail-bn8nam08on2114.outbound.protection.outlook.com ([40.107.100.114]:63832
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229457AbiAVA46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 19:56:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3OlRgJWRiGIfXO1c1YtCVdEiEBmf7HxfH6ewbhr877RLANDPRmV6JPiZBfhU5PFnXhjwRXN+yJkKo/HGZTHDnGtZUVxUNliML5prLtgFr0mRVmC60JP1VbPQHsEPDZ3SJOsZAVObr5tYynfFbWIfZ1XgWPzc2ONwuGUrK3PMcEk5/k9WTy+bUj3bqmXL+Zo01f2O3NQreHKpoB5+OvxuLBEwPKIQ2EZ5XSQw5WVgVr+Z78Vsx6UxzA6iMEYeJ47yKDTXkxp8i5kYzEAD+R25S5WQrOKjiQa338bNw16ieRwAB057VnzNTtzlWX1wpzhsJPIDS6JFqF/+A5OvJjwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csOGeUerndB/exQwBHTXHTvA3zR/xmGXpFV4dZIU2wQ=;
 b=WhEIMsyhOG70zWOuk1uSNIzYt3SJL6skFzlE+1vhsGZ+efQdAvvuTriI0Vy8x4zSQwiaAzCloNNmE/da75VroEZJaL9GTh4OHahc1z9ia+WIp9QbfAaqUvMPv4UXNg7Fy95wIs/rgJwzbWOwb+BbjtMFXiAaAJMaAmUNt5jz+9LQhFM5l+1UO2zUUYlzMGaY/O0FLQzIgxZz7OHzIMzbKilk2fZjAxZFNIlKArc6XzVzq4cMdo62DIP6ElSTgtDr82KPTUuR6DWHQzH8GKeJZiDhvLz3+U7EedEJweksNz2p2GgczB2LfAyjaYa4AXiF8wXU5O2CBsWURFtOvpHVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csOGeUerndB/exQwBHTXHTvA3zR/xmGXpFV4dZIU2wQ=;
 b=rV1v+7Hc5lN5mrIlZPZN95ll9aTK8iSgFop0ZrMUgtidcb7t3DGJLDCTomtQ48/aNp1XBov7y7gfenF+07Swfn033lQnrDzl0QogvoXP0nlnjIoxaTI5em0t3i9TKymbs/izLbmzArG+5AGBTxZf6X75pmqx1K1xBXxJ8K2A/2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4022.namprd10.prod.outlook.com
 (2603:10b6:610:9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Sat, 22 Jan
 2022 00:56:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4888.014; Sat, 22 Jan 2022
 00:56:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [net RFC v1 0/1] Fix NULL pointer dereference in page_pool
Date:   Fri, 21 Jan 2022 16:56:43 -0800
Message-Id: <20220122005644.802352-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:300:95::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30ce11d3-6d89-49b1-c4a6-08d9dd421642
X-MS-TrafficTypeDiagnostic: CH2PR10MB4022:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB40227BBEE64E46689CB2DA94A45C9@CH2PR10MB4022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R+vJo7dz34uFzwGnDuDWhHc9Z92CGv027799U84gADJWXqzpxSwHIlbHRP56Aijge95pCni+/lTiZF+p3PNKILodeZfI9nmn9aG2FIvjtoUrb4b2DIFQusvmXksy1ybCsAUZ6O7m3kFaWmAnBavF2AXeF/+ON2s7iE1mwzOn9hgBayuM2UBGAb+E8mhco9E0mmE3IGVOIKNtRa3zdZuuJ2QEmg1hL5SY56udCOYMyQad7WjPMzBfxccFu5CKdbZtNc6QIx5AmF+fWBW4r2Ch1v/1Es5dt+RXH9XMNHQ5Ja3YUGLyOG0L2oEHsDOVGTmO6/KDCoRb4iAE6WmqIPz3ApTl/286O3YbZZ49Ucx4T4cithwct6flKUAoL79RPqqF6heLdRDiatIZP2GaAuva4AxZev6J6ikTT5O5TvHG+BiWl1hU1Zp/eZrdjnlVcUIMduoXiSPUILkR9E+LQvkO6nHFzW1OKnnOSROwQpoJRFapg/pAxCbY+URgh8GcF2DppZoB5k4uD6mHbh6IzLAoTPOQUi7qAS9WA7C6STllTRAQ25wNRg2XGX6qIsKOlARzUpQO+AHbQiqH2YSChj1CRYa0YRad5dzdD/7QjYqe7sXqTZ8pVMdOjlJYQhgsJmzFvGVgJlErJOFmPVaZVrpfOF6/j12IWhdCGhcTz84KVhf5dSUO16Ujp56l77dHhT/BFesNqIOVhI2KIoDtpbDwVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(42606007)(39830400003)(376002)(366004)(136003)(346002)(396003)(2616005)(52116002)(2906002)(44832011)(6486002)(186003)(316002)(8676002)(6512007)(26005)(54906003)(8936002)(66946007)(66556008)(4326008)(66476007)(6666004)(4744005)(83380400001)(5660300002)(86362001)(38350700002)(38100700002)(6506007)(1076003)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C0MSiNsITuz7Y0YO7jfZ5P2AMzOhZBwiRhM1gIfceVj+ZXCOMLGwueN3QAYj?=
 =?us-ascii?Q?rJm/hDyH07rFTPzJDCXJw5rJO+ddJtXvDL7/fGTbmGeSAD/+Pf3xKyir0BzM?=
 =?us-ascii?Q?Hqe3QFdDNb20wbJJ6482xoeQZV/Tp8lJvINF28eQE0GwhWlleSIly0tDZhSp?=
 =?us-ascii?Q?4CfC8XH5/3fC5DSgbqTUnGTR+gik+NbfoKU4FkN5C/Kt/TQMcV6XgnpaZV/o?=
 =?us-ascii?Q?mf+KNiLf4cb7122ft/WypKa2JxbpmtJ17FxNKUNsDJ2J3Ds0HaVtLeJzhvpI?=
 =?us-ascii?Q?VnrPpx11ydF/V3a9+18MZqQOG7kBsCywgOA1x2jBYNiHXWff38FxlipNp49/?=
 =?us-ascii?Q?yXYmh4ZNhr4dvw+bCtlbrECFqP5HRl64rBWWcVW7S3+WnfYgEBdQdo4emhIF?=
 =?us-ascii?Q?Syx3g5xTCHpjngvx2/UpisAKC5GAHfcX6/gGx/FOkSLXaht19QNgO20HwGmJ?=
 =?us-ascii?Q?wMgQUURqWGpuDbSsUUpdqgb9vLoSFeaOL7Fo5ZQqIhZ0BdxcCwiLtJ3Xiyhd?=
 =?us-ascii?Q?1BBaOm/MiWHZBqLrMI5NMt3EdfK9w7XJVVzbmW0CyYJFWsKDohWf71DoIkLj?=
 =?us-ascii?Q?uoF4ZpXwuqJoLAe20bOEMnovJ2020bgQNYfPYdeGs+e4lJjYR5mGPAzBfMPx?=
 =?us-ascii?Q?GhjNsFVruMsDxI9i6gxR1Wo69MgEZtLpS5sWTVaN5n2VFTeLuYevjoqHp+mn?=
 =?us-ascii?Q?Rb4xvJZDEFITthAK96Y0vXdCo39WUkFWOFeL2JE8kiTbS+rk7fdpy2rmfZYM?=
 =?us-ascii?Q?4t2pauYZE42yi/lCjyDPSJEiarsV2bf4AQy727KDnjJTZwwrXnDBVlSzJnyf?=
 =?us-ascii?Q?mDllrAsEsawmjDUzVlEh55Gh4f4yeFg8558O0FkwVg+5tw0LXg3xHgVhgGjl?=
 =?us-ascii?Q?UxsUd8HAMo5fesQlAN30e02M5Rv1PrPYjHTRkk/Vm9wfH4KIfd0aIbCTNtoE?=
 =?us-ascii?Q?YoDTek2mIt4pYOI9pc4VQn7V4EPl+zU3/rpCEL7yB7wtJUn78U2TrJn7wp1y?=
 =?us-ascii?Q?v3wE30eJgu33j3sXtncCrXijYJVWVBlE3MVv/zXzGN9sx2BzLyxWdhnq64lE?=
 =?us-ascii?Q?34eGZePG4kERF4RSazLslK8ujGa3fEaPYt5NRO8/jWl4eOLlGP4aB4uSSH5i?=
 =?us-ascii?Q?Hf4a1RFjZp5TW6dixVEBbAfYSwQHplKs3t8WIG5dGCOQFGyEgGENi50Pkb6n?=
 =?us-ascii?Q?vPre9h3No7djRhqNySVrW33hCSDa7RBLvMZwPqNwPLkR90idjSvdauh5HrnB?=
 =?us-ascii?Q?qdL5WffN6VoZds7bp85x0gXm9xbOkM7LM36v3yAw5r7Tpdi//0wcwXcWM5aN?=
 =?us-ascii?Q?uL4Uz9kZAO1kG1RJ22aDfK1Al91/hmh7vdxn2gQMm/ymAsutQLuvP16nmVRD?=
 =?us-ascii?Q?C3rfJrz1iMIowZ/GzJHsSU0OJLV0YwznY1bomnID9CQmpPHUTR1UgRi5fooU?=
 =?us-ascii?Q?1ktlnzrukIXmBkmGkNKQ99dCLvZGrRt7idgiU0/iWy4e6Bec2KcgvLXNUvzi?=
 =?us-ascii?Q?LcGZ7kcDC7EGOJGPG2TXbRppcU/zJ/ycwhgfzvQWcD64aiE15MXRsQfgP4wS?=
 =?us-ascii?Q?9OaPNobalIauPG/8sf9PL8jXziNbXcDFzrD7EeGeihLsnVZxtTdaVJfHwK6J?=
 =?us-ascii?Q?yg31RsnqgZdKaCZKpR6Oc7oxt4FNcyQ9f+v9MFbY1+7qIfuebV3EDhxtQ9sh?=
 =?us-ascii?Q?bAQfxA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ce11d3-6d89-49b1-c4a6-08d9dd421642
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 00:56:56.3971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6bYoowf37FopHv4deTvw1oIBsM/mYblV+kneUnnaA06xzM3Thr1JctU2/P7S7hNwPJBHdmif9pEjnS18AggueAIbIDP+I5CMLghfDTxGwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm not sure if there's something wrong with my config, but as soon as I
run "ip link set eth0 up" I would get a crash that would invoke a
seemingly endless memory dump.

git bisect led me to the page_pool, where there isn't the existence of
page_pool_params inside of the pool. Therefore the check of
if (pool->p.init_callback) would cause a crash.

I have some out-of-tree patches currently, so I'm not sure if my case is
valid. Specifically the MTU of cpsw_new has been updated to 1520 to
account for my setup (beaglebone with eth0 as the CPU port of a DSA).
I'm also not familiar with much of net/core.

If it is valid that page_pool might not have page_pool_params in a DSA
scenario, then hopefully this patch is sufficient. If it isn't valid and
something I'm doing is invoking a memory issue - then I've got my work
cut out for me :-)


Colin Foster (1):
  page_pool: fix NULL dereference crash

 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.25.1

