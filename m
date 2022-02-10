Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654D34B0457
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 05:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiBJEPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 23:15:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiBJEPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 23:15:37 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D2F273A;
        Wed,  9 Feb 2022 20:15:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3VBYf7+ru4CoJhH8EPOJOS/HzNCp2LPqinJ60+J7X3V73dy0FKd48OgxRU9C2PFejEjFIXE0PXsmzn5taH4AgoRuhjzj3lPhUkP3xtSgLYGyeWjaaAxV+z09FDJltS56LGu3icpHsCAm0RX5jWTdPZOB0GQ7YmhFis6V8b6TNcAfiC7pXYOOEqvtwdLUQGfAz7OD+RVyFYMm5W571/Bzm4Rv88tYA35GAid4CqC9KnR035ETo/j/43ce91ywjtnL24kRZZHA4pGpZMO0PCwH2AbMboh3jTfELh6jCgSH7yTVdGWHsLcvG7dsWcpjzrR/PYup3X0tVJVIJr80M3nww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5VZeZLsIGqRGKTJuhtykj1JlNQTe0Ojr+G1AalvZ+A=;
 b=EsGSLNmgA3+9EsDmW8LGMrGHdFdsD8SkqqchX2Oxq8WhaAgBc/f/PvBebUNtXDQ1cO7LcXssPS6mH/JfWRLlGot0QU1NTIRUva4n81Aii3sae9ldyAfk0LYEXvop4la4sziXY6PePFITODBfa+IJ/aCtsUjw5qv77oMzek1UZaiNXsYQcGCIjuQ83ie1Hm6kWJLXhT2tG+JEudP1ucUYhRZd1eFGXuWKtTv86HoVJyj9dH/h7TwHT6A0LD57WKZfII/XHLU4ctieGWJU+pARrynHh+BWxjoiwU/j9AZcJoKXg4tG27gU8KaHfwykqSaGG5DPts+fFCDeexfgCB1tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5VZeZLsIGqRGKTJuhtykj1JlNQTe0Ojr+G1AalvZ+A=;
 b=Kmt+MDg5ybZIN7yrKjSJdg7m3qahRMRPlA+vYcanZQ8uxdF3q9XUU3jslBO782FNXVivNTxXVsxbSMmEbme8aNQPYJK4PY+lXJslPHlC47roExmqnVfBdbQpMF4027SsDIdAk1TdMFzMvhxlcgutYzbEtSJXMZAE4iw8/6ztZqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN7PR10MB2564.namprd10.prod.outlook.com (2603:10b6:406:c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 04:15:36 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4%3]) with mapi id 15.20.4951.017; Thu, 10 Feb 2022
 04:15:36 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v6 net-next 3/5] net: ocelot: align macros for consistency
Date:   Wed,  9 Feb 2022 20:13:43 -0800
Message-Id: <20220210041345.321216-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210041345.321216-1-colin.foster@in-advantage.com>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a30a696d-aa05-46f3-954f-08d9ec4bfd08
X-MS-TrafficTypeDiagnostic: BN7PR10MB2564:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2564CCE5A789A1B629013BA5A42F9@BN7PR10MB2564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/y0SZ5Dn98uUwrlLrWA3Xeka0xMXQA82x2lKkzdSvuwCG2xZuHHcAMZrJ7J8Okwbq4XolrOoYj5c/BeVEapMYz1UIMMycsyFg1j/dNxeWBkYjfsHBg6TMRvLr1sNMyDiYBfbz3xtpAfiTYWS0rzw7IT9RJUk9l+it/Wf1H5ZPPhkgAGhRQdkJnhV+0QUsMKLlV1LIwoVXodWL/lTUutACSlUiNGmnjtS+0v3nutTxnTzl+BWNhIw+rLoClATI0DKIr+gKDK4W2mdbbqmm+Fyjl08m7DHhVOgROkcPe1JFulMCCS59wtj6e3wg2lox3CHQXbdBTzgCsG4wIQzIvuCjP9Aegs2136ZsfpW49vGpp9co25Jjl+E6+tHDlmHOkbH49cgPGASfZJE+9JEX7F0nNPu5T8QiVCZDSM1CWCIjMuMSXf8vV5UINc0H/BTwCG3q3g6p1N9+AoNLx/xIccC8SAo6vxqirNnhXhr7NEIPT+i9R2mrzvZLAFnscnwdNw8BARQQB/E/KmgYocPCfEXV9gZ+bzewlFsn3BIdxsFWfMO3/gWd39vElX3IHPaPLxuUb17ThuzNyrlj2D4XfdzRhbDe1NoTQ1f8rLmU/ut2QFhntRQD1z2PNzqesvsa/VQYqkUp+Yxe8dyK5ucjnduz0PrnRlzqMjFqpxVjmx7lboVziob/c13nFm5gXKf3LCIXsnGOWscy18W/4/ebWi5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(42606007)(366004)(39830400003)(396003)(376002)(136003)(316002)(66946007)(86362001)(508600001)(8676002)(38350700002)(8936002)(4326008)(38100700002)(2616005)(54906003)(66476007)(66556008)(5660300002)(26005)(44832011)(6486002)(6512007)(2906002)(6506007)(6666004)(83380400001)(36756003)(52116002)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GJIIes15F3thn95N08V8c00NCE37O/gquOreOZJx5OiDGW+yYe/aGvf8CN//?=
 =?us-ascii?Q?56oP7C1wxiMzK0mtP2dFHdPcb+4q3IhyLLnlXSU1FnGr6izJdVOPvNOzUJFX?=
 =?us-ascii?Q?yDxTb4BmZRpSX0wTgRL+WBoQ5EDeGVSKA95BPauoJ2NtKQaEwYRMqax371jC?=
 =?us-ascii?Q?9SkgqFqenUYpc3BMRdLjUTSmhUW70gkKtqPxBdHXAJygYCVloj0Aqi+dcf8a?=
 =?us-ascii?Q?j2gwvcVAl7wlT8BFXIAcU6sA4kDNORRzFWcaU0CKvEcgW3SXuQ+Ldv2CRTre?=
 =?us-ascii?Q?YoLKW3eqXesJNtQuktiZ/qmof2r/1J+ccy18/RGeKNCV/p9OlRpF/T9ZK9zE?=
 =?us-ascii?Q?N5FQmp1U+0Pnpc8sW6/ozdDiQhkjofJ41vnLmFUQg/C3GbflvDTTou5MPAFS?=
 =?us-ascii?Q?vlW1tuIrSAB2kIc/+xnkEW2E39ew1oEHca2+zMhxyF3qQEkQI5q8o3Ok4Wig?=
 =?us-ascii?Q?GLRtnT2JvmAbEZGZwyMKNSNhmDk3/ai/AxXLMUjJWYAAqe/PwNh9lQfAyNm1?=
 =?us-ascii?Q?JaxFiRMyYqqeZzO4o0Wab/YDm3HyNTJVoTmHz+yTWLsc++SCB8i+Ni8PTsjv?=
 =?us-ascii?Q?CXrCaD7Q/3js4mHvB1lSUFaVIXOCm9liTpF/s9GIUii4txZkMd1KYBirDEXf?=
 =?us-ascii?Q?hOvNWRvl95DY3SvheV10Mrj8COHDnZFfwH9Q/cnsVox/vf8IOanJjHStpoyZ?=
 =?us-ascii?Q?UWhIKGbmq/4FcBJloO8Z7vAaT7eZ3d7LYbXyL7cMiuseVjBvbsN787Bk/Tcu?=
 =?us-ascii?Q?/d9WTfyZaFtVR+ERsjCzlY3OT4MuclDktoDv+bZ/i79o8C7XDU9fphwJ0SmF?=
 =?us-ascii?Q?8NWv6u/qbO0c/vnfsq5v8Lx9JUzucSbgoY53YhK91UaAKzXFNl0UHofFZhIq?=
 =?us-ascii?Q?kSHJ6PMyTJjXotKxajsDa/xk21f3OP5EpFkvhXWqE4cnRBuSFNObZ0M76DmA?=
 =?us-ascii?Q?sS+TUdplaRLg3zmN5eQmDTbuDYXR2JGgw92obtCUvD1lmwA941Os3dJT3kkr?=
 =?us-ascii?Q?kACh7wCU9eapnp4AIxitvPsMR6rMXOZJIKalZnHp/zYeNtEyXb2a95UKYQ9w?=
 =?us-ascii?Q?q31tO/DiuCFUSYEvOj98fjIUfMC2KGWh4FrE5z2ptACv/zRwsnYh5qQGa0+G?=
 =?us-ascii?Q?1JdxXq6Cq/Bd+EIISqg4BdmV3Vp5VOBm+PmPDYvdDEWRy5etaBzxp6p4OyIj?=
 =?us-ascii?Q?Gf/HZrwqr8YPLbHWmTwyt+9ZaRwBoXbMOuSdWKMAdrsKJMAPqmJmz2yQ3ohj?=
 =?us-ascii?Q?unnnpWuh9DhrVxDOwDFB9whgtytlIB3LbIXg0LdJ445njxUQDqNPkEpNYlYe?=
 =?us-ascii?Q?UoruQVab2PoSh0jMI/ZjNztMM3nePoan8xLmXpA24ecg3bzjoLAFZo8F/yjn?=
 =?us-ascii?Q?cxrDGaLlFYckpR2gpwynL//GxjS3JrgcjgsCVtmxj1qwr9Xb5N/LYpvzA8vc?=
 =?us-ascii?Q?5jNcjR8pjMqJc2vw8AsaqrnaigRCL49Ta7Ulcu32Cmwcj4RM6soiInnXs8yG?=
 =?us-ascii?Q?OCCr3y5bf8YDt5iaa3mGYY7FlInrpOjB+Te212k4MI/1adu8q8kr1p0W9mFl?=
 =?us-ascii?Q?nH7Dwd9BcHSy7ZbuGhORj1386sLHSRFw6x+YfjbvyHkzi/6U4tUgDkVMjDoV?=
 =?us-ascii?Q?grGFm9EELsKIC471wNiDPHJZ25N7kmcgxseDkCsehAJIb3+xWqkWj3wS1R1m?=
 =?us-ascii?Q?qkkT1w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30a696d-aa05-46f3-954f-08d9ec4bfd08
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:15:36.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5p8XGTJcVLxlMD7w2pC5d8PjM+N3W+ror4TyxO3uo17k+zCB3VJI12XO7iSawTWDkCxuyCACYTM4PN93bpAo6FIYrpIBoOvQUIR5bXBk4yA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2564
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
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

