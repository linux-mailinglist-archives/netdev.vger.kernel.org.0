Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FD8397611
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhFAPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 11:08:58 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:21694 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhFAPIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 11:08:55 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151Ex6Sr005548;
        Tue, 1 Jun 2021 15:06:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 38wm1ur4wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 15:06:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6Hh7Gbuua/+W0SmdlCWdKDOIqaG9edXq2tsq2LbN0H1bNS1We0TS2G6HnB+FfEngEj1IxbtdSCgSWMUBsbZqDmDPlPQAWPfCAsJDGx4/WUDmlUj/oJZnHEYedkO+cnE12NGiTy0vxKxshSNgeCZruyDDH0F1EnCeHbC8dNxR1WNZSlFIsJ4DOD411X/w8Ni5x5dRwYzaY5zK6LT6c9PtP5wqcTcAXF97yxRWmfkXaQKYbgf0Cb+zdFm5xQWjcCKJhsd4uL9iINC4pfzyofPuONlzpbHT7vk0MnqfKnLJVJCFW4tJ2Am5P+w061kmvbNli0JVLDngUcxk0fg+u3asw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx+ldw+/qOAhxKJKkWB4MqBvYER4J9ua7GGWoJCtBxw=;
 b=AP8QKBEVNaLrXrmACRb5E6AFJtTK91+Tfh79bJGE0gVIbbr7XVqlyYJe29kf1vUsGdE4HPloWvpjxNSQxrujrjYfurZ4NweweOPxXygsl0d6uYqn1Q7DPrMrrLPvGQJ099euAkowyRMqOfHcvlYiRd+S0VY8iGNI1LD3AktSwX26HkAODv+ZCYM2WxFL19C6aYTR+A6asJk9PaHlrSjaKUO1k+3rYJeaLc3+BorFIwU523Sg8UtbKJIrW7GbPzm+RkZrQibLq3xev4VbaOGG8Ex6CZr0GUKTT6bUEuLnNLT7LniJ5a95st+VGFUd5FICa8dsfDsilEM/34PS4Q8jYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx+ldw+/qOAhxKJKkWB4MqBvYER4J9ua7GGWoJCtBxw=;
 b=CzVom/umfHpLwg3HsfXQLlBRZCy+DsTHnQJ2ovv7+tP89rzRSl+gywkjaMBuuC1jR4U5ru9ljhY1FbuCDb94qW2/HuL7nIsH5kiTyIMrmBRrWGsUIoeqtpEaeK/NrrwACgSTUGt5QWtOilKnTJyniJFoOEkXPPGHTaED1wRMdtg=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3223.namprd11.prod.outlook.com (2603:10b6:a03:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Tue, 1 Jun
 2021 15:06:40 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 15:06:40 +0000
From:   Yanfei Xu <yanfei.xu@windriver.com>
To:     daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] bpf: avoid unnecessary IPI in bpf_flush_icache
Date:   Tue,  1 Jun 2021 23:06:24 +0800
Message-Id: <20210601150625.37419-1-yanfei.xu@windriver.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR02CA0199.apcprd02.prod.outlook.com
 (2603:1096:201:20::11) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp1.wrs.com (60.247.85.82) by HK2PR02CA0199.apcprd02.prod.outlook.com (2603:1096:201:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 15:06:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a946e84-3ff1-49fb-a170-08d9250edbcb
X-MS-TrafficTypeDiagnostic: BYAPR11MB3223:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3223294D41C580381513157FE43E9@BYAPR11MB3223.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VohWfpjf81xi7f3lztJl7lSkRHnE5EcrNvNNmDiwV74DAhOHyB89u1Wj4FuZxauB2YUp4l3D60I3uOK4DILxhudUgBB4++/Mhf78kbIb+mD95S5wWjmPVM5g9DWb6t0mKa4qAYmOF71k5IGSokU+IVuE+gTPuxptMoCVs/W9bsIJK1qBKeAxhwe38DV9o3DIM40G7/o0eRRAi2gbc24BWTLQi3ZaZqilrLobxEAaBK+noEYVmRxfNaY71DY5pGObbhLuYFCMCZoHNN982QzgfcUGWu+SDzv+oPiB6dJ7qwJVMj45ssur5tgm/8Ko0Kj9uGz1Zh0Z0t8NAm1MLKiH8jXCYO8b0l1CX3Ru2gtevZz0beFT1CdGixyXu4Q0HA4P9HJ0XxN8/OVxJkHDY6/1ULeypvHVUV/H18cN6yqRbwMaDfMi4rOuvuqOrojdk6IUECuM7xC6BgbkfpsZb0TXls+ugfhSjcgWEmOIcSW0ejF+qkihis8O1LwW8qdo28bi3KMLwM1S27ienslAURgWDl4FLoXWuOzjO55sM+W7VTzD+2n5rDJvjHIZkIk5huhZRqAdWftdSxrEMc6PcNVyV7W0ciZ1qw7YHwGXkO1sv6LvgxqV7u7787j4lJG/6I80NtwZj/fjaI7j37Hj4CTt/te1EWCIHKZI0+Xe805nHxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(86362001)(44832011)(5660300002)(66556008)(2616005)(498600001)(83380400001)(6486002)(2906002)(36756003)(1076003)(16526019)(7416002)(4326008)(52116002)(26005)(6666004)(8676002)(66476007)(66946007)(38100700002)(8936002)(38350700002)(4744005)(186003)(6512007)(921005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1Qj4hhR2XL3Hursyf6KbQIlodTCj4AC8k8IjktZSnMzR4nRKU3rwtw9L/veF?=
 =?us-ascii?Q?JHrKwPCw4Cc3vpbdAYNhWK1tS7rEXmr3sHgQRGmAmIaqXI+FuPBMT4oyrBqH?=
 =?us-ascii?Q?9zdRMRUIhMgtXctGNLPvIGUhxK+xBKFAXO5ccPxfa14sjSr6GvfcuhmWYsMX?=
 =?us-ascii?Q?+Ps6Fcu6HTkr8mbVSprPRewyHBKOUM5DkrwdvFzjF39fS79WJ8EIte1w76Zv?=
 =?us-ascii?Q?Olx90xH+Plu7dk3zmHcu5AClUYwD981qNlwiycsdnZZHj2ifz1UqkXdAXkRZ?=
 =?us-ascii?Q?RzQvEUPgpUA7J8WFEvsP58aZ2qXNNvKpyw/yN4YJRt9JaQ3gE01bzbuj+5Vz?=
 =?us-ascii?Q?d3Vg98kTTmGg3rocxSJF2aWb/p2Q17QRcnys8BJGmFuWoea+VZbekNtTM3hI?=
 =?us-ascii?Q?ooeAi6Fvt4Ri5IzaUSdf+/xEBtgqc1ed/1wlmv4qVvRBL3DzbE3xD/KTi9hx?=
 =?us-ascii?Q?OxL0PpIun5ASuoMoc32XhlKRSELAhE2uuBJG4LkPN3qnBK3nDFzBT3CB087k?=
 =?us-ascii?Q?Pf1S0m2K6oGb1gvjcHpRZA1Bi24gPVXCgQDvtbBTl5yCbzyMmDzqvJzUeefC?=
 =?us-ascii?Q?iqBYhs3sXUHDK30w7Aq5+Pu4U6S2Nyq1RGOrIepvdjcFW4dckM6S+bqNK52f?=
 =?us-ascii?Q?LRhPuYm2lCFYaE6K3NQDBbNwunYWXiI9j2qu32/U9hNbNUq8PQYh0FMTTIiE?=
 =?us-ascii?Q?7HuHT8euukcdfsL/fntD35q3mv5svdZbsY5jIDdB1bcbG4QlA8Dw3aNan2p0?=
 =?us-ascii?Q?H+VQ7SPMD7kINDYfz2P6yBCWJVT6PHjZS9AlGqt+m6UWpSdOa+GfmXVaTEl6?=
 =?us-ascii?Q?sr5j5vKe0EFvbFrB09Fq6LZbBfuysOmmqOMmUc9uLRJYptMxScx7cMnnlmI9?=
 =?us-ascii?Q?iZCI+YZYBic7mfrThdqriZFnDLffe7uj2g7uGoO8NdCwLXKEetS9fvvVqG8q?=
 =?us-ascii?Q?gvesZNwwJb2u6qLDGs8j9kNvCXW3DZnF5JRLGHvjnlLlEUdFrzh4Tv6ZVuob?=
 =?us-ascii?Q?yDF1pCrhmNzjDF+Y83SdaRsbUBBdJkfm5RFbZUYoR7LWisC/iUXFTWirOiuh?=
 =?us-ascii?Q?bz2sbZHn8izHOd49Hg5udIYZ+CV+JBJ35zenITsFAAMwOO84j1dr/pCvQwdz?=
 =?us-ascii?Q?4tiu3IMx5fBm6D71qcwdyvVqWjUZyToEaTb1Zg7iVmTIRPjPgFQYFFFrgLU7?=
 =?us-ascii?Q?hi8YjiuMth1DELyTJGynmPxMC1MlyyuIO6nedLsXqK19Ex+FufchcMCDqAfy?=
 =?us-ascii?Q?UmHKnB4r3ZPwNyPC8Mjyk9o95hscBhZA1SLmX2kB6YTcnij9FQ+kNsXvh1h7?=
 =?us-ascii?Q?HKLn3VnTrimtMltn0NuvBEmp?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a946e84-3ff1-49fb-a170-08d9250edbcb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 15:06:40.0958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lW9whUnBbNFdSB3EoH1VU0i95Grk06/y7M5hwpuf3peuydrSnEsElPFSQN+zXoHbS/ghnpnh8d1KqxZxjX+a7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3223
X-Proofpoint-ORIG-GUID: rOeolTfwNytlviSd4TaIj6hOQgszPpoe
X-Proofpoint-GUID: rOeolTfwNytlviSd4TaIj6hOQgszPpoe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_07:2021-06-01,2021-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 malwarescore=0
 mlxscore=0 mlxlogscore=671 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When looking at the IPI counts in /proc/interrupts, there are always 
IPI1 happened on isolated cpus, even if the cpus had been idle with 
nohz. However, we should bother these cpus as less as possible.

The IPI1 were raised by flush_icache_range in bpf_int_jit_compile(). 
Futher, the calling of it was introduced in 3b8c9f1cdfc5("arm64: 
IPI each CPU after invalidating the I-cache for kernel mappings"), 
then I found the bpf case seems no need this operation. But I'm not 
sure, and still learning the JIT codes meanwhile. If I am wrong, 
please fix me, many thanks!

Yanfei Xu (1):
  bpf: avoid unnecessary IPI in bpf_flush_icache

 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.27.0

