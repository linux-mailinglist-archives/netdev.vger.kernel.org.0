Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD0598885
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344565AbiHRQR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344457AbiHRQRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4BABD099;
        Thu, 18 Aug 2022 09:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdwAyxSclAcwJyr39CSvtZ0ifKg+NHVIBiH3fOoiORZnY6UMsF4MUi/z5DIMAY/7D9RQSyiTFxzzNuTM0mD2bEnbwAVLgAj1SaP8z7YbDxaSCrD5dj/nplXeeS3RweORyOzrp4F7UEhOEPPf3wY6KBXis4iYEZe8gZubLnO1HaCbR9fYso6sGJFN40tMtRdUWZ6Dw86qxiJnzM/z38/YPjmR9EfVQJLA1F3hYkh52ktv5mSqk9D9DRu2GOnJT8D714uwhtB73CYPL7oeYWbJGM4kVJWQ2gqllGUlM7xLsOsW51ET9n7ShsNMFJJAuSagHYLKfBVIiOrB9nwBxaqvqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYvIu+eD8xuwaZeeIpqrGKTF6KIS03fE1xK9b/GiHNM=;
 b=QQApD4lsLZTg/BMNb/d9khk3mrQgJyB7fqmJ2Mar237c7nNy6LCRNB6yAJzeZ1p6pdJFfZWshtLMGiGeAV3hbUn8zXSS/GqJORQaBnbC0Lg9iTD1LP+1oTbJHeovtmb99G2/uf7caDAJDnhSQPcATVyaxJCGLM6iknCSeq7B6o1bxndpA6/5bLUSTGnEgUimkJQu+W5WkhsUY1nra6WlKY1g6elu/CGYn/ccU6ULi6AjkKj21E3Ff9coOBpXs7V43vrwWjI5xy0pL3IK8zCy+9HQ9hS7/3BN8KhzTt+RGXiJQKpNMindHTzRT7zvnHjQR5Gq42l+GxI1i8/AyIa6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYvIu+eD8xuwaZeeIpqrGKTF6KIS03fE1xK9b/GiHNM=;
 b=ZSLgaAivPBO91uOZWt/5tAtGHJAHY0ptrTWZgwryfKmZKK7qnlZuc3hlK+v8n7vVmjTACTFSKQF4DIPnXdoS89lO/AcZLMe3/NEaXW2wc6MBM3268lBoOxRSbP8FwyrIcrFNmXJlDR0A6Hi2uyro5gZM0ZKqFyz0FIg5X92t7B6Uib6/P1IeHJRNqZSPXY8YwV+cko1+9UB7HwQImBI2lmrwFaaMuy1PipCnS+faO85+H1Qh8jj6tob5SGZHfvH9ND2tfAqofXmx15h7mlx68lnWUEf96zeS/K2SBB8pdAwuik1TRJn6KAThBQ3Dd4op2o7EJhe/5BlVYrBXdkXlNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 02/25] net: fman: Convert to SPDX identifiers
Date:   Thu, 18 Aug 2022 12:16:26 -0400
Message-Id: <20220818161649.2058728-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fdf7e97-6a9d-4eec-1d85-08da81351a5a
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jhsykia+PfVB/5vrxQyaTm4AjWidflJONEVmDR+Ge27Q71agIBQpBbf4i1qt1E3aqbCnsj1L9s28T4QFb8kKqz4Hhguk5iEHOX0nNplqcuGbcNtyknFZBqX6LNCa1nKJMvsbaOpTJtIe9/CQ3W8O5SfYrB+cruagsqZ7q7ev4CBNztPOs2Y1OzaBBq84iThCH3HNCTJJL7sYbPpO6Dl+lCozVv8Guasv88WC6zNKB+ZVbKreEkpcIzycjalQySGC+OuBkImm1ei+Dl1VgrFixrGT4WZTawNblaDjIu30RommY4oFYtLQJCmzIB8T/hH2jqD1m3gtBivH3s2cQzHcl2jnRvPPSPAx/v23pqKqERDxrryqHIksadFUkGLMJvJZ/5H3qPeJUqRGamt7p96NWZ9sDPMONKv5CWzX37akZU2bvfPYkB+ba7ZDOfynxS5EvFoAQtP2hlzeB4fGP69AJ2Q0avQ2D3zXrtB4FvjchtVp2o4/KoTciob4UaaZ/43ppK95RUngLnmmy29k6yLtTUhFA5MSZVUgQFNzWH2EZ6xZY/nKS5/DTzjh8YcbZz4le2D+tIwXbOajNG/aOlZP6fqEnHQuijTpxk3AyZXAwl36KZI/gAO63JXlC/1Nj6G5d3UxAO0mWcKYBBrPslh6rIQDIhN1kDp8H8xkCXOFURv7n1ysZX2o2qn4PlhDINlRtk1MvSmH/nDPKm1dk+jxuSwNOhrPaOjeF+973GMVQT5o7Re7gtaxtf2olaD6cU/l+XYrvo5kH9WATB5YbP5xpQgfqc0AQlZgX5fpRB/RtWY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(30864003)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002)(2004002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qEZPHqCK61PqRy82pjO8NFzIbtoFrcWOkAajj0tfFhO4fLr6sZAfafhGXm34?=
 =?us-ascii?Q?aQxsyJExfLvE/KsWHDKrBp8JvN5b98qxA0PrmqEo4/1SQzZ0MeVqhBqJ6KC0?=
 =?us-ascii?Q?NyPMuwcTuv/haiQsKkFxQc5kcWslXYDn51Pp3HpEh7F6aB+ME+2nH6Ny1sHi?=
 =?us-ascii?Q?G+6Hwc543WAZb5QBQvXHF3nnbt6w6IJqkKZHKMDwO3ji6rMVAyPrV1Q00780?=
 =?us-ascii?Q?Wo4RcGb/KECdFGL/QJh27KuAdK3IQO/9tPPFUkeNRFY+CTFfQTrR7OLnC0Ue?=
 =?us-ascii?Q?IuuaQWP03YPOS6RCTBbzwpdHCt3qkGHV1K3T4fsUfdigy+q2S8xWAEf9jVVp?=
 =?us-ascii?Q?Mm+/viTaZqbzLhczrThiF0GCUUpmPA6Ymck6baqSkQr43QXnn9HcO8AyzD66?=
 =?us-ascii?Q?001Bh4srrIVpJpDGerfwcIBMWSUV3gomNh9V35kjSfVmd7+uOaI6jdP7yZBX?=
 =?us-ascii?Q?DeQDIZOKOaL43yOcN765dvzdMfoQ4EsrexvgalT9DTwMuvTkyHLSrB3dvCQH?=
 =?us-ascii?Q?/rBfs1bHyCsRLo1ZfMDESr576t/5PwCqjn07uEOX1VHuVkGVPQADMcnvAaqC?=
 =?us-ascii?Q?eOf6PeA/twAtufG1nDjrUnpGklMjuiEROehdvlXlLhaJ7fGD1oBHbt+K3pRP?=
 =?us-ascii?Q?13UvzOvN4Os80rUtU+y0+zXkTHjBfExs/JiNVzpO9HczYT9jkSWr7mhueAf6?=
 =?us-ascii?Q?YSAirTx2Bxw0ZcCC92WQpWIgqHBFaC250fad+B2xSaz/BdHL4j39QkvefpM3?=
 =?us-ascii?Q?finnZ8iFEMwXThwr3qs6ZKVrwnKK5YWnrYwVmw5pZZy++2hOvESxcl64qyHT?=
 =?us-ascii?Q?tKxfHyELXM1XykRWOUMLsfUmVn4hbyB71M1NKsm9l0kUQsUEYYmwnEN4IupE?=
 =?us-ascii?Q?SH/074vuCsGSOtWFZVBUjLDeucFlmNoUAqKwvr303UhDNJawLapCCapZ7GQd?=
 =?us-ascii?Q?ULEwMQR+hCYQ8Yd/B1R+whGwI3Q4jQm5Aongw+Ls3EHzjtf8YYLkpie5J3S6?=
 =?us-ascii?Q?EpBZ4IO01IFwHeNVHf+lpS4DZnsTV8zVMTxQMQckfro3Awt2UFHeS9x6yOSE?=
 =?us-ascii?Q?42SAGAHnkC5Nl2Zvd1orD0SdlagtNaZWDLYQY5TUx+DTN+LFWLM0dbYLNCk0?=
 =?us-ascii?Q?7SjirgmyW3fVnaeb+GIiPrOCSvKgTM3RGVUFERWgh8+JTXgeWj8skB35u1EN?=
 =?us-ascii?Q?zwxcp+T4x8jlr/luiRd6bs78ajJzB6oZz0fKvRc+AfUqyVM5BUSVbDe6144J?=
 =?us-ascii?Q?0n5eKQVDCJXNvQ316fvyzALUP7W0mKFeuJ6+rLUV+O0xCo80R5bsqR99CHvV?=
 =?us-ascii?Q?W/3v5yZ2MDugDtSuAZowTU1KlfF542rgLwV/DI39GB2FmVeEva7P76+dFPsu?=
 =?us-ascii?Q?D7x3sFVNqOyPicaYnCKvZYHVjmcwuPA8NqMzka8RfDe++d2fzqrmriYBUV6Y?=
 =?us-ascii?Q?QM+ng/xw6jmRfLK/sNNUIUuktW8T1kuWXPE0cRE4rxLGfieRU8ywUR8zdIOP?=
 =?us-ascii?Q?uBRNR/a2omF9+zhtSeCFoX6z0GcvV1zGp+5cSshBu2oT+8Bzh5i3cCS28OZO?=
 =?us-ascii?Q?Lo0OErCYKmlEscVPawpZRduzh1V7RpiLFx4Wzgk4nK6TS2Aj9N6w/PSMgkFh?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdf7e97-6a9d-4eec-1d85-08da81351a5a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:10.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UDSQIRBvaZfg6Q2ifpuwXib2JbpQrQDpYGPSFM1H+NVsSw4hY/PUWVEKE7N1PQWvLV/ofn3cfUVsteCe9b+OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the license text of files in the fman directory to use
SPDX license identifiers instead.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/fman.c    | 31 ++----------------
 drivers/net/ethernet/freescale/fman/fman.h    | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_dtsec.h  | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_keygen.c | 29 +----------------
 .../net/ethernet/freescale/fman/fman_keygen.h | 29 +----------------
 .../net/ethernet/freescale/fman/fman_memac.c  | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_memac.h  | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_muram.c  | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_muram.h  | 32 ++-----------------
 .../net/ethernet/freescale/fman/fman_port.c   | 29 +----------------
 .../net/ethernet/freescale/fman/fman_port.h   | 29 +----------------
 drivers/net/ethernet/freescale/fman/fman_sp.c | 29 +----------------
 drivers/net/ethernet/freescale/fman/fman_sp.h | 28 +---------------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 31 ++----------------
 .../net/ethernet/freescale/fman/fman_tgec.h   | 31 ++----------------
 drivers/net/ethernet/freescale/fman/mac.c     | 32 ++-----------------
 drivers/net/ethernet/freescale/fman/mac.h     | 32 ++-----------------
 18 files changed, 33 insertions(+), 515 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 8f0db61cb1f6..9d85fb136e34 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -1,34 +1,7 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  * Copyright 2020 NXP
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index f2ede1360f03..2ea575a46675 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -1,34 +1,7 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  * Copyright 2020 NXP
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #ifndef __FM_H
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 1950a8936bc0..a39d57347d59 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index 68512c3bd6e5..3c26b97f8ced 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -1,33 +1,6 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #ifndef __DTSEC_H
diff --git a/drivers/net/ethernet/freescale/fman/fman_keygen.c b/drivers/net/ethernet/freescale/fman/fman_keygen.c
index e1bdfed16134..e73f6ef3c6ee 100644
--- a/drivers/net/ethernet/freescale/fman/fman_keygen.c
+++ b/drivers/net/ethernet/freescale/fman/fman_keygen.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
  * Copyright 2017 NXP
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of NXP nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY NXP ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL NXP BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/fman_keygen.h b/drivers/net/ethernet/freescale/fman/fman_keygen.h
index c4640de3f4cb..2cb0df453074 100644
--- a/drivers/net/ethernet/freescale/fman/fman_keygen.h
+++ b/drivers/net/ethernet/freescale/fman/fman_keygen.h
@@ -1,33 +1,6 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
  * Copyright 2017 NXP
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of NXP nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY NXP ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL NXP BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #ifndef __KEYGEN_H
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 2216b7f51d26..d47e5d282143 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index 3820f7a22983..702df2aa43f9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -1,33 +1,6 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #ifndef __MEMAC_H
diff --git a/drivers/net/ethernet/freescale/fman/fman_muram.c b/drivers/net/ethernet/freescale/fman/fman_muram.c
index 7ad317e622bc..f557d68e5b76 100644
--- a/drivers/net/ethernet/freescale/fman/fman_muram.c
+++ b/drivers/net/ethernet/freescale/fman/fman_muram.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #include "fman_muram.h"
diff --git a/drivers/net/ethernet/freescale/fman/fman_muram.h b/drivers/net/ethernet/freescale/fman/fman_muram.h
index 453bf849eee1..3643af61bae2 100644
--- a/drivers/net/ethernet/freescale/fman/fman_muram.h
+++ b/drivers/net/ethernet/freescale/fman/fman_muram.h
@@ -1,34 +1,8 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
+
 #ifndef __FM_MURAM_EXT
 #define __FM_MURAM_EXT
 
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index 4c9d05c45c03..ab90fe2bee5e 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
  * Copyright 2008 - 2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/fman_port.h b/drivers/net/ethernet/freescale/fman/fman_port.h
index 82f12661a46d..4917fe8f0617 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.h
+++ b/drivers/net/ethernet/freescale/fman/fman_port.h
@@ -1,33 +1,6 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
  * Copyright 2008 - 2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #ifndef __FMAN_PORT_H
diff --git a/drivers/net/ethernet/freescale/fman/fman_sp.c b/drivers/net/ethernet/freescale/fman/fman_sp.c
index 248f5bcca468..0fac60aa5283 100644
--- a/drivers/net/ethernet/freescale/fman/fman_sp.c
+++ b/drivers/net/ethernet/freescale/fman/fman_sp.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
  * Copyright 2008 - 2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #include "fman_sp.h"
diff --git a/drivers/net/ethernet/freescale/fman/fman_sp.h b/drivers/net/ethernet/freescale/fman/fman_sp.h
index 820b7f63088f..a62dd21c81f1 100644
--- a/drivers/net/ethernet/freescale/fman/fman_sp.h
+++ b/drivers/net/ethernet/freescale/fman/fman_sp.h
@@ -1,32 +1,6 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
  * Copyright 2008 - 2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #ifndef __FM_SP_H
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 311c1906e044..a3c6576dd99d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -1,33 +1,6 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index b28b20b26148..8df90054495c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -1,33 +1,6 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
 /*
- * Copyright 2008-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote products
- *       derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #ifndef __TGEC_H
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 39ae965cd4f6..2b3c6cbefef6 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -1,32 +1,6 @@
-/* Copyright 2008-2015 Freescale Semiconductor, Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index daa285a9b8b2..909faf5fa2fe 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -1,32 +1,6 @@
-/* Copyright 2008-2015 Freescale Semiconductor, Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
+/*
+ * Copyright 2008 - 2015 Freescale Semiconductor Inc.
  */
 
 #ifndef __MAC_H
-- 
2.35.1.1320.gc452695387.dirty

