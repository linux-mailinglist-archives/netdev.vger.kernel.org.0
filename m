Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3DF53976A
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347568AbiEaT7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbiEaT7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:59:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C6E60052;
        Tue, 31 May 2022 12:59:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2KfFDJ52Bq4gC1a0MHNyoU+8sJWRblRl5/Y9zuVZ97b60M1KIA+cgxUGX4Hs7xj7C55ixWdk1eQXSFFkuB5bQ8V5QFmyEVkzZpEdQa0MleRBKiBT+an8FaXRuBw/Fp6u9Z96dCUQOQ3odMHi9WYq3CzPitYCSJkThE9I0p/5deUqm5nJ6etABu6W3QCMPZh2DEiyGNRpj9mzEBdYveqWTK8R/KLCmauQcGOH8+1BLPGlKwkZ1pNRcwZ1tgiMR8j/YNMZ2APri12xaRWg0J0bntz3wgzQ6uKuMdQrwVHpLL5tbFwaSIFIyKqqvbdEB/QWLi2I044f8uJqvEfnSonuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFFiVc3z3oa09sMrpNC0EwHzT/YrqXPKFtVLUM1yg2w=;
 b=nrKpCVMbca5zNMJ/tjNhNGpp0mI4O0XO8qbFwdXfMn4iWcBCoPvRortSBFQ2fHRrB49H/Hq6GFXM9cWU5oyOC9yIW4NlELLKG3Z8pQuTNtPSuRTMJ8W41vvhczS+h2vvKxsgPVf4aKfCbqCOTHcDxVqw92PBQBqUcx8VIWvGXpk0pb1Cyv1XpnKUZmdKM7OcIvRS4Q/kKU1fl1JcvR9GmdimNyOis0tlozpXvlj7NDgj+HmY/CPE/3x5AE6ieq5ht51wTUbVDIMy/QSAkVbHcOLV9lZBhJysvzhqXS26MbSCwR9A9KVdCC9zClLOP+QIZaJdzZjW0WaQXLs5X2VHrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFFiVc3z3oa09sMrpNC0EwHzT/YrqXPKFtVLUM1yg2w=;
 b=TeXq/AwKS6CnT2acTDyATIexvtVKfgqiyaQaKu9t/lsd5FnZKCTdKqs9MIBY1fuAh7GKA25vDBpHp8I+l31xuxsRK5SCpll4ha4fH1WgvK4VP17ksK7VZ2DYjUN4ySTC73Bs7GQOIhZ1G78Gov+Qlym3AxboWDveNab4j417EK5xDwq1AfMwbwa2iieL/DnQ+yj4h+fDqg9PxNyaOiTkDTDc2oklm4iRMdfxG5K0YIFInORFVuFwQzaaY4U1LKjPTICSrp8F9heCs1rC1KKTxX7YjtaXDG8aOaJcF8X8pgRV/EFhV8X88w7R41MTzWW5NSMh0/+7DYeEZjeiVz4FvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7309.eurprd03.prod.outlook.com (2603:10a6:102:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:59:03 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 19:59:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 1/4] net: fman: Convert to SPDX identifiers
Date:   Tue, 31 May 2022 15:58:47 -0400
Message-Id: <20220531195851.1592220-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220531195851.1592220-1-sean.anderson@seco.com>
References: <20220531195851.1592220-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0113.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1242912e-6660-49b1-c01d-08da434002b7
X-MS-TrafficTypeDiagnostic: PA4PR03MB7309:EE_
X-Microsoft-Antispam-PRVS: <PA4PR03MB7309806E215BA6E8F6B8348496DC9@PA4PR03MB7309.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7AwPR8rh0R12FgWre85YC9HKXH6b2iVouz/ULTTIfZ0Fewkcw/QYG19215aX8W+A7sr7fzAu797G6msqTH/dvOoeOVQiLoTcNIiJB9cJVcw9DKqYD/DyAcWAGAYDGdpo2tsRHqbLJ+J09pFuz98oor/JppZ+xkzzr1TzDsSeQeo+RiLwNHV2pyK+DH61rzmIhks2O4yprTdYqzg9fWW/v7Gf984UIvWzbRDFiTa5e3Nsb54o0zx3fhr2vk1QHZZn6qS4HC+oIZuwR3la59Y/YmkPnohl9Myhoqx2XW5b0JU1k6mJO8yPYxwMbn0rn6W8dgJItGAczS1C1aJlGZso0hHVNwdrV7R+fgiYtnrdZd9L9MZvKZ85frgSMZ5nva7WXt5N19JilCVnuF6V+R+juzOaBAl6I07qGeG9reRgFIOQUveTI7zLlzqS0yRasQxSxkSVH08fA7aDzFlXV1T1qMV6wjzvW0sOihWNfD688ajwkJDEgVfklK2L3B3X9c6k3K0+XDoC5nh9z5u2QrCIuW7k7f5/HARQSsUgyZ89lZJAflRJSP0/hmaSVHOu5kKISBuXfu7H1HAOVUhP1fNQhADtWWuKWzH5ip4n/5gtcCtiWbpDkOzkojE/eDm99qatM5Aa5vmj/TL0zoGvEVGvHtaGxQO+syye6ffNCPNx91skqrhwXxcwMCKrJBy0kVaKlhz0nodTt1UEq7yG3dvtX5ErgBrL6KwkjbPINsppnAdcmqseuLUIeBgfnBts/rSCR6QOUfpnrYb4289mgnmA7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(1076003)(107886003)(2616005)(38350700002)(110136005)(54906003)(36756003)(316002)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(8936002)(508600001)(6506007)(86362001)(6486002)(52116002)(44832011)(5660300002)(30864003)(6512007)(26005)(6666004)(2906002)(2004002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?46fvNMjE7fVOOXdwbHoygXGmI5iqh8Dx4UIXPdMfersRzbduCWnYIhJ46eBr?=
 =?us-ascii?Q?BGOdczQCvlEoJiTgWrDn+YjU48kcAXtJMwhU3D+/Z1GtWFVWx+bm50Cqmj+D?=
 =?us-ascii?Q?/l+b/zRheuOzjjTVzSRsdbuQdlGq1m0QfiS3HiFmtUrfxNoJlRpdaLZa0WcV?=
 =?us-ascii?Q?T2RJNDgH8/w+quUeyVGBk91ppfU5JsCfo51f3iVfRe3HjJQDFXcYtaRpiwnu?=
 =?us-ascii?Q?wz+0qDIdVla4uKdh6JZxmybZq1IOS1tCTnUlQ+Ot0n2IwSk0Rc3ncj1NeKyC?=
 =?us-ascii?Q?saUUJwIGJPEU74vZCfk2FHwDlCvv715jzINS4tdrRd26LRYtp/h03qAVN9t8?=
 =?us-ascii?Q?6WybMDef9IO1EMFtEoiO6iJ/YW4Tf78bcm9SFNiLBR07d1nhrfbVG/s43UFo?=
 =?us-ascii?Q?zyVgQmfw2CQ1nJ8eCvGfVOepgatYJzjWCvjxONepjcoT/wkBcKIVcfqSfXtG?=
 =?us-ascii?Q?Do+UfXNvqxp9Sl+jouyjI+Eka/+TM2V+TiQ37YzMd1YsJVABQHosh+rgaSKX?=
 =?us-ascii?Q?HkJGMqLmJN3vBlFcxAztuMCmYUk05NGlmNVZanLiup41emPRUiXa3zkGNPug?=
 =?us-ascii?Q?NAXfAWyt9hSSihP0k0b0lq8jkMbFPcVZo/Qlf6PiM7pasiQaDM+57qnuXzSH?=
 =?us-ascii?Q?9MoN4ADdBIvnwm0PEdpfDC8AotS86jiwLQRZQ1EksOEdTACdhIMH6bFX1/Dl?=
 =?us-ascii?Q?ggnr0BeMjDDvaSn1diHkiA+SSfUr0M+9RzbLDOzpE1V8JfAYWlYj3y0THY38?=
 =?us-ascii?Q?Ec7or2G4m9WEOMa7fLzS3G45DkZN6ZNUYLYIDj7AvmQHB8Ko3zihamJsQ+R6?=
 =?us-ascii?Q?hEZmNP4HDTRz5P+cq/FSHKsrhhV/rvbllB5VB/5bO5iJcE/33LkeC0XKG7qY?=
 =?us-ascii?Q?wd2zFN0Baf91SE4mU7fpXMITc9jw0l2rb+aODw9oca9NFAvhEB0Gp9VayspH?=
 =?us-ascii?Q?TOpyuiC9Mh0jQtmggsoKQpCgsMtb+DCb7ndXbDlgn4liIu+Wu05lWjBjQSnd?=
 =?us-ascii?Q?yC15wjB1lv5WNvOzw2BzW4NZiv6b4+A76PtOAypHRptAX5n7AQ+sqtMJlh2R?=
 =?us-ascii?Q?QnEjxES2dLPOjEBXB15O/LxdPfByJxFc4q1xVBb9z2SIO2ePnihN4R1WFHTk?=
 =?us-ascii?Q?iBLDpAfBiUFvPcJPEklfHT5Zj/aPKHyh28mHRGjaPpGYwa1FFpd3gzAa1Sqh?=
 =?us-ascii?Q?dXPR50svlhN0fWz7oPOWeadddpCMIPQUAQcjQuzAxM5kW43JZTwUOvzifT56?=
 =?us-ascii?Q?EmV8nuT4sf6wg/UJWV2sDiamF+6RltqigqOnAgUX1sLocjCdAk9YAKCUlIqP?=
 =?us-ascii?Q?VKYBiVsRoj+1DjXw/UAAJK0VsO/nUYVV8dLA46DZsQ0sAeUp9YRtxmjUutOH?=
 =?us-ascii?Q?GCh80jaAildJAJALnb4lwYoRSo+QDlQmIQBlaDcKD9RXjviQh7VRQjr8AGKt?=
 =?us-ascii?Q?D5yEMUZGTrIZWjtw26PJT7XHoMvXF1t6uR/7nPAF48LnC4nuvw4mQ7kYudfw?=
 =?us-ascii?Q?Ge9fpSdUBylkBKSBkn8CiFKfe9Ufy640MLQAVHKOXQFKZRRsXqFIeq71J8tQ?=
 =?us-ascii?Q?yiXjTIAnoE1T3sZnNjhZwm67ycis7IJpYCQpKaINSppliLmWNLIDgU3+yo/s?=
 =?us-ascii?Q?Y0q9zDTDdOVjG8eTF57gn5cAXwMcSd+Z9hQ+BXi7ofQCZrkKwvJbNAi5wIY9?=
 =?us-ascii?Q?6J59xtWjeQqAXXCZb7YcMu1jluxjeViQk23WO+1FmZGcS1C0yWEk4ZS3kySG?=
 =?us-ascii?Q?BR2QW3H6YqtR7OFMHUa1DX8fgH+oOo4=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1242912e-6660-49b1-c01d-08da434002b7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:59:03.1879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDbZ4stJI5ueHs4BO7eMwKO2h+zVJo0wODfrOnyR0qAv4dn8kQYEAocUlkxBs72q95zFx9mrJkNfaCfIZeARZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the license text of files in the fman directory to use
SPDX license identifiers instead.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

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
index ce0a121580f6..56c65c43c7f6 100644
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
index bce3c9398887..38badacfdada 100644
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
index 5149d96ec2c1..86f3b74ada03 100644
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
index 62f42921933d..8b2b4fb411ec 100644
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
index b2c671ec0ce7..e1d62a7df367 100644
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
index 41946b16f6c7..49930a5f2991 100644
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
index 3bfd1062b386..3b4ecde09bba 100644
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
index 824a81a9f350..1ea5fd32f689 100644
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

