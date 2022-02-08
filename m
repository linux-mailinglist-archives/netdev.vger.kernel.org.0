Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4834AD0FD
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbiBHFda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347015AbiBHErA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:47:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2125.outbound.protection.outlook.com [40.107.244.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B5CC0401E5;
        Mon,  7 Feb 2022 20:46:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hb2knJKjyS4GGvNAOmtJYvNR+w9juW+UfsC8AJrxY6POI8hRx8wkIQlPK4PofwcW0c4jgFFK8e4DB8/E9Jg882jaiUeW03vHg4b9W3VfULjtvJPOY9PhlGc63S2ueuo8Ii2x59PRQSWBUzTnYiB+b5DM36jElQafBKaGGzjLmKPBZVD3q9fdW0KQd2KX6WnuTQUJD65k5vq7b8lWjQe5xBts1T16DajU6ixb7y7SIqlPW7jcGiTsB+tUBc/zSBoJTQLIi33lRJGs/3FqfuHc+L2P1ncJnCgZaEBA3TElkLodhmSH4Zl9OjF20p2UwvaYRWFGOymOEPsZkyWmsipoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMiOnOSz3IyVWPX0xUP/G3tVqPywZ/OKkq0FH3v0e+8=;
 b=VXVrPsVT47yZSOIHescfh7wLWIyPMSdfUg+16xBonLjjTR5vVrVlFIHQvEPZgYNFgwY99a7mbE+9yoa1BStL3frrpE79oDy4hnwYs9SlTi3pI7Xf1qv4rRjM9Iw0FPuc51T1pJr+3ks5x/3MB9PYDVE/mg+bZ/gEK+7aAlNuSPWaMyga6DDycQ79J1mGxcC31Ltdols/jBpDk/QGkf3pMFuaLI1gTzyBmnZ0YNpgvlIfb/uiJn8SieNh8FKrZtqfZwLHn6iy52cHFRCecMvKm7JhCW/Co59Przi56cxzJAMbskB9iPtBUJ9YalJFkiv3EKwDfDG4/mhIJGZdLng3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMiOnOSz3IyVWPX0xUP/G3tVqPywZ/OKkq0FH3v0e+8=;
 b=UfXTRzFM2Hbv1zMvnVTIPP01cq+c5s//eXkIov2JRK+Z8QS7OcBFsHFZQvuQZTKVcE/5k05sU9uhh9qmKyYE+5BjgAsY4oXSO6+QZk0LcO4z7iN307I1fYMynVokrxdV2IQVwdQ7f5Qmz/CGV5grOIXvGgz7yr4mVjTzzgkCJyE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4394.namprd10.prod.outlook.com
 (2603:10b6:5:221::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 04:46:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 04:46:55 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 1/3] net: ocelot: align macros for consistency
Date:   Mon,  7 Feb 2022 20:46:42 -0800
Message-Id: <20220208044644.359951-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220208044644.359951-1-colin.foster@in-advantage.com>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0090.namprd17.prod.outlook.com
 (2603:10b6:300:c2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b365d5-1b05-4194-7597-08d9eabe0803
X-MS-TrafficTypeDiagnostic: DM6PR10MB4394:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4394D7D5DE9B316462C23E6EA42D9@DM6PR10MB4394.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ax6gc72gH0hAvRIfNaf3vs9X4FeLCDevKgAJsPaa5Oxl8CSnVCz4AixJmgIDm+IfgB918BFkAhYDa7lPyEnh+IWUhVe3YkfTlq1fcAk24iP7d5oOHcDf3qOvJUMrMVFQHyetnkYmAhDYIcmhiRfuh99lbJR0lEo9JA3HQJ1Jlg0z53xffGbbMF2nO1+QLUK3RgSeLdNJaTAuxK+PWt4RjTJypVj82EO8D6FvfTX3A78ps7P5T7zl/WYZ+Efu7HL/Kv2qUkQfdjjrepdfpKcDlZBbKQhKgqs890dhsByID9jGU+ZWx9VThqVFMPPQLtLKUB4hD1e4Lbr5V2iVNpDy1OPXhVnSOAHcgfla3CY7y0rXs06FF8hQx16pp0Ih6IQRdlFseXa4hxd8HsEHXeHk6wECx9tGYoy3jam0qNOp8oGH99FDhfCkPByOq22I7aRBEdWBfTmJ5Tnwvu54Ao0uiFaY3pBRAn6twBZ1UMtZu+P3O2X3MeESLyLOnE3AuDsyrg5YYcHi3/PEPnuzOnwpneiqvXlfCQDFAssINAgM8khPPVvBS0byjVV/4Uep5kDws5q92443J/OLdUkV7+PEVhTbmV41kbQ70DZfUrKDtQf2prcfapvRglpT9mfs2+wG74y71OEnJxMp3Ws5Ko2XrVGORnJU8FUubEDjP7r3Wr8ZH0FGC+bSj6sJ9M11MI4l/TvcQtTic25QPUJ7P89Y9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(376002)(39830400003)(42606007)(136003)(366004)(52116002)(1076003)(186003)(6486002)(6506007)(508600001)(86362001)(26005)(36756003)(2616005)(6666004)(6512007)(54906003)(83380400001)(5660300002)(66946007)(8936002)(2906002)(4326008)(66556008)(8676002)(66476007)(38350700002)(44832011)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sXENp4CzzMvZVmuxd+fff+QbrrgYVqgroWBwbE4KLzIn+DKDgEm36hqOO1L3?=
 =?us-ascii?Q?JMMiNcEBuegkV5aXUSWp6RHuZgzAdnYU5iSAHs2wZcoizZ47MBbJDQeyhaHC?=
 =?us-ascii?Q?zHQr2KyrSUrhWTGXmnlmQvh8SK8uTmSzGc2j3UDJwHf2r9XIHHmbbkNc1M91?=
 =?us-ascii?Q?eFg/m2gBQytWwH6EHTuh3tTFHLYttueqEHCKBxVURQZ82RefSgDtaFh5z47S?=
 =?us-ascii?Q?LUonjOePH/Y64akmG31ILpypkOWIhtZ9pC482S3bpbGi7XOFV4jXY2ZyrH+6?=
 =?us-ascii?Q?i5UN2e4IvUcpgocQzEhi1EE1TLa9yD3EQW9t11VTKuDAeCTfXaJ9BpwjBH1Q?=
 =?us-ascii?Q?58wd9vUlu+9b3uh3x6hAiFMS0mseiqeg+b5Qx69TGkuz8HLguGHC+ygs8WXy?=
 =?us-ascii?Q?EfAZO4D3yJSm5kpebXEu4VwtPH5prLLJpcbz0vhXoYBJ9tJKEXAwg/efqr8M?=
 =?us-ascii?Q?5Ng+E+3MxfQedA7CBQfRv9S8xwNxxVUMZuyipUR71A3uxe8GXx9i/C1bMUFM?=
 =?us-ascii?Q?rWfG/RVZX9w7XaTyhBFu5pUg4708m/7jZUZUgt7isx48xRQzn74wpT9/hWb+?=
 =?us-ascii?Q?vqIjH+nIM2wbYNdCEne19ACpzxUTQMMRk5kMiDXbVADizZWlEBIqZAyTUn9G?=
 =?us-ascii?Q?tw4y42PZpns7qcm+nI0IAk1d8l5TLYvLZR2gvyReA/MtY0g/zG1OoC8P6ZIc?=
 =?us-ascii?Q?hPvGqrU39s2M+QoxcIUFB+yM0Ol/jiMsFoBVBqRoDpDlzjMRK6x5F+yIs2yM?=
 =?us-ascii?Q?xmgpOcU6ca7IdMww610VeXJTk20PHUojwJgAIxubw4DJT5mukAJ/IftAJY+x?=
 =?us-ascii?Q?ktWUy/p3NuzC1+kSIczZxJJCJJCqeX/fUYHz8Lk4JgXmn4En/NyfVED6+kjd?=
 =?us-ascii?Q?mVP3lB36x501POqRrzWU88L4CR8apGhfS8h6k7DvBuDcPNrvyaCriRWklUXm?=
 =?us-ascii?Q?Sa4PxcB001pn9svaMOSwYHnChhGXHMj3Hc+i+W7jtU3NMoCH5y4igct+8Wpo?=
 =?us-ascii?Q?2Yf9vaEOMXUiY1fVbl9223B8yWUpIOkpi4B40BWYDtG3+VlkrgciKxbPHLoR?=
 =?us-ascii?Q?HvjSnk0LryqpmqmPes1rHJtm9YCB5iVqbhDGe07NZx0ZYy8qD3gS2xmhFqFA?=
 =?us-ascii?Q?pvbMfj3+0wcyfR8thBquhHXg2OAS3E/KgC6JMW5kQAcqEXtj++tkRCUNnJ5u?=
 =?us-ascii?Q?L9fk0uxqZFWeHf13+0xY27K4cKfhmm7MOGJ+438DJ6vgqxIxjmxQcCTpuSfH?=
 =?us-ascii?Q?6mk4+r67/HwEibR79XcK6wHqJtxoqtiLtKUfxr2Gyb3Ln118cph4q1cPS4Uq?=
 =?us-ascii?Q?7NZGUN91FIA7WKv4jb8jYNaIkrLXpsNBXPzNUV4oNAGUoxG6zVfiCM8e6v1D?=
 =?us-ascii?Q?hS6s2wCLg4bcaEo4M9GxVZRuEiUWpZssaeGNRUVePK7iItVTKzTAeuJc/kWn?=
 =?us-ascii?Q?Xhi9bIRiAQbPg30/8CIDxH69gtX6ou5gmbUz+zlFsujRiQeQ3mMSatvxF0Dz?=
 =?us-ascii?Q?yv/Bd+x9h6NGPP5Or5FZN8w5Bobty1hynozuz0GLUDfqCzUZeFz7rTc1H3NX?=
 =?us-ascii?Q?rdwpbkjOr9bQ4wFxh7WcCy7QK1QETbyrz6V8Da7LFEsX9dRHwcDcXzi8ykKs?=
 =?us-ascii?Q?VFa7MJbZt3AsDLLTBQWs5U/frso4YzYwmzr78Km7L4ob2IyEq1Z6KbybfR0J?=
 =?us-ascii?Q?ZMHDTc9D/lHybYqCHZXXXbmk3AU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b365d5-1b05-4194-7597-08d9eabe0803
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:46:55.0016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dznHMM0A6hoYH7bScXoJNl7NeaMGbsQpdsz68DKlKNW/MGyJPRKINtQNGRM2QpqcHMD4/4Y3stKWqox6AFytA0O3gfi85+BF8m6BNt+bdhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4394
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the ocelot.h file, several read / write macros were split across
multiple lines, while others weren't. Split all macros that exceed the 80
character column width and match the style of the rest of the file.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/ocelot.h | 44 ++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 62cd61d4142e..14a6f4de8e1f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -744,25 +744,39 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
-#define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-#define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
-#define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
-#define ocelot_read(ocelot, reg) __ocelot_read_ix(ocelot, reg, 0)
-
-#define ocelot_write_ix(ocelot, val, reg, gi, ri) __ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-#define ocelot_write_gix(ocelot, val, reg, gi) __ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi))
-#define ocelot_write_rix(ocelot, val, reg, ri) __ocelot_write_ix(ocelot, val, reg, reg##_RSZ * (ri))
+#define ocelot_read_ix(ocelot, reg, gi, ri) \
+	__ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_read_gix(ocelot, reg, gi) \
+	__ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
+#define ocelot_read_rix(ocelot, reg, ri) \
+	__ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
+#define ocelot_read(ocelot, reg) \
+	__ocelot_read_ix(ocelot, reg, 0)
+
+#define ocelot_write_ix(ocelot, val, reg, gi, ri) \
+	__ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_write_gix(ocelot, val, reg, gi) \
+	__ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi))
+#define ocelot_write_rix(ocelot, val, reg, ri) \
+	__ocelot_write_ix(ocelot, val, reg, reg##_RSZ * (ri))
 #define ocelot_write(ocelot, val, reg) __ocelot_write_ix(ocelot, val, reg, 0)
 
-#define ocelot_rmw_ix(ocelot, val, m, reg, gi, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-#define ocelot_rmw_gix(ocelot, val, m, reg, gi) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi))
-#define ocelot_rmw_rix(ocelot, val, m, reg, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_RSZ * (ri))
+#define ocelot_rmw_ix(ocelot, val, m, reg, gi, ri) \
+	__ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_rmw_gix(ocelot, val, m, reg, gi) \
+	__ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi))
+#define ocelot_rmw_rix(ocelot, val, m, reg, ri) \
+	__ocelot_rmw_ix(ocelot, val, m, reg, reg##_RSZ * (ri))
 #define ocelot_rmw(ocelot, val, m, reg) __ocelot_rmw_ix(ocelot, val, m, reg, 0)
 
-#define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
-#define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
-#define ocelot_fields_write(ocelot, id, reg, val) regmap_fields_write((ocelot)->regfields[(reg)], (id), (val))
-#define ocelot_fields_read(ocelot, id, reg, val) regmap_fields_read((ocelot)->regfields[(reg)], (id), (val))
+#define ocelot_field_write(ocelot, reg, val) \
+	regmap_field_write((ocelot)->regfields[(reg)], (val))
+#define ocelot_field_read(ocelot, reg, val) \
+	regmap_field_read((ocelot)->regfields[(reg)], (val))
+#define ocelot_fields_write(ocelot, id, reg, val) \
+	regmap_fields_write((ocelot)->regfields[(reg)], (id), (val))
+#define ocelot_fields_read(ocelot, id, reg, val) \
+	regmap_fields_read((ocelot)->regfields[(reg)], (id), (val))
 
 #define ocelot_target_read_ix(ocelot, target, reg, gi, ri) \
 	__ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-- 
2.25.1

