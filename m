Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB084B3D0E
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbiBMTNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:13:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237927AbiBMTNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:13:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2133.outbound.protection.outlook.com [40.107.236.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3047593BC;
        Sun, 13 Feb 2022 11:13:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBpDUHPy0jqPLNN4qgJioGfs+4e8HpIHnhURuJX99asZwAYspsEo3aDRugi6dpszzCmo8d4QBqwc4Fhe5SrfA/KIYw5h0tJLhwwdUHapd4FGdTGj445wCNOs0xhqwT+XCbUnNXfhO0sc2WJEeZdp/VonWdcCaJUeiTB+qluUpfLC9A4JgPtaGhnTeumhvfDNvIjCKn+FnSk2+f3X42BCyF/UmEdAG5kPMe/PLQNy6ItcDKv+n1G9edTUC8eIJX1bSqI0cL/rkYdP60GQsqbmYgRS7IEZU1m7UFEhzNJnLj0nmOKRtgtDF/Ym9kl5yjBdkP7psPtVfHsKqwF+ea9Hcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5VZeZLsIGqRGKTJuhtykj1JlNQTe0Ojr+G1AalvZ+A=;
 b=VgjpL+hKSDb97n8dlDz7ni6xXu2YkB209Nc/c/NxKL9puXf/PAnvk3VIhceXW9tWoCRSOB1VNtacbwyLU5j2q/JEMP4kKKBjAIZ+QsdSDSqGs2eyIYucBoc/oJmLhLgaCUHZ8xLAFRkkQXkivJtYq8w8H/1RPE3GHLdcRGbCcyUQYFWzrcinfgu9x7Tf4mQWBgdOaxs0CwXUhFYZ83LwUqROod1QlPWS07NQXUIQr4ZJTYJ/JO8QOKXTBdKqrHmjC9sAqeTn+g2b5CAY+vMsFJZHrZxbAS9tKSY5erw0dnityZJ+MvYg/Uy/s280AUL04vaR2nLNqdt06pAedQt+LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5VZeZLsIGqRGKTJuhtykj1JlNQTe0Ojr+G1AalvZ+A=;
 b=zN0Tkd/LccFY3i/XivnfOy91RQ7C2Le7mu+JbTyaHc62k/LsbP1R18hQtbUCTA2b+Z4u2RMEjdGiUIij4icsdD5MeOT5b0UJwDv75DP11aQKSE6AmhtlHNZDSrjuO2aOT6nFQheI04iJcIZgMAYSAo7gXozOhI7Kc7Ov+A8+nbE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3315.namprd10.prod.outlook.com
 (2603:10b6:408:c8::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 19:13:07 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Sun, 13 Feb 2022
 19:13:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v7 net-next 2/4] net: ocelot: align macros for consistency
Date:   Sun, 13 Feb 2022 11:12:52 -0800
Message-Id: <20220213191254.1480765-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220213191254.1480765-1-colin.foster@in-advantage.com>
References: <20220213191254.1480765-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3372135a-1ff8-4242-96ec-08d9ef24dca2
X-MS-TrafficTypeDiagnostic: BN8PR10MB3315:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB33159A26CAF794EB0D4A09E9A4329@BN8PR10MB3315.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TiU6tfO6bVvZOZK/hnfP3gWGQ3Ug17VDN/3zUTY99JNQf35Nna2BKI0oJkLXd3zZ10mJ+2l3chge7NiE9mgAbHE1sde9pSJ92vxgMjbTYcpFFAI5vnffD/vphtCIZz7d4YJfTSuEUxCbS6oEaoHpvNWh/jue62yjFr4xi+Ek4/AGKQdb7Kejjq7DQvQAGf6BqMu/MzYGH7xXy34on3wjbEt43ZiZwsYklyVz0RiYVYvSp+1tWhyJZ8RIAJ26yqQC1fBd5LcylFwvISRf8A3jumDZfCF0yAaSo1wCLnLxwSVk6FDIOGyjVYyBZK1ng7zBEkEURoRW6yBKhB9yDgdMHDJmSK9uZhahWzaj6tp8up8V8ANAtp/IH8qm4OMV9DWUpyAM57WJAkNdFjajmYdcHGBrAh5vMueekqYoXxjQ1QaAyiRT8TLd5Fff7axVpRK8QQOGvapqpUV/oIMXPhn2rPeH5iTcCreEqUyRcwFBVFyJZ54Isj9tlI3oYLgsmUL7CCm71OLiXI5jSMTS1SzCLSe34XpHlan87Hhs8wakuCWo/DmLt56UlwljirJxkpjPAxX17n+8S171JsscutUcZJhjivipiAP8pEfLMBKW6ORTi1ATmpnBLwKRpsxn2YNR9MO8bsLAj1bfXFFMm8hQqNgsiSIxKA9+mLrVNp+2G5lRYITReEIRzQI1WLDMbXZMvjKRmHnh50thBwPs5TS7AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(376002)(39830400003)(346002)(396003)(26005)(186003)(2616005)(508600001)(6486002)(6512007)(66556008)(66476007)(38100700002)(4326008)(66946007)(44832011)(1076003)(38350700002)(5660300002)(8676002)(36756003)(83380400001)(52116002)(6506007)(86362001)(6666004)(8936002)(2906002)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4xr7Pqb3LtmMBM1QiFvkdzdEoRX2XPuEof+4ke6LJ91tPPbLiYnuNtJNsv9/?=
 =?us-ascii?Q?dQVMQt1smsnO35QJ5cgmRBYPdVlCFpeqh2r4saJ654UqegnWgvxaI6KxZZEo?=
 =?us-ascii?Q?ZtVt2FLxV5ZGnL2YFPgCG9ny1wLx8OmD6fHrvaLE0cmyOzUi6oVElqy3wikk?=
 =?us-ascii?Q?8suv8XkiOVSgr+AMBN11MNHFEQnmWNcMyB3dY3Rq9xR+0oIJSzeXusHqPBA2?=
 =?us-ascii?Q?+/992RhYFXnqE23RUTXR5s+ElOUrX83GqkGjr9wwxSVC3pUDGZvhbCgnc1Lz?=
 =?us-ascii?Q?KvF/b/DkXZHbJZSq5ndwyRqoI4zBvFAPCoPowjSbgOtvIg2vKnn5PffTRoXB?=
 =?us-ascii?Q?Y9116J+1I0+ZthqJmR89gs5bDj4dqY9Q4CcinkYa2CyWqeHSEpXctEl8kXMk?=
 =?us-ascii?Q?408LglKe/LJJYRABPplLIyk7Im4NYw69BkyLsc529Yb/0U+mPgYTMvMUgHmq?=
 =?us-ascii?Q?NGpYpeI9mMaT0x8GIoTxB8uOVgCxyfvajphfUZ8M1CakD1izVAift/uWBYBR?=
 =?us-ascii?Q?8BXdPLNHY/PiaK+/32Tg7O24soClVyGx+w3ZrojZ86fvmuVv0ir0ZjwHR6Rx?=
 =?us-ascii?Q?bShkk8YYsR7/hrrHP1i5O/F7DWLdCFQaJ6uC+n+zsrXpojb6qksU0ERC7OFU?=
 =?us-ascii?Q?0vqfdhlFSSDzQPnpoXDjYTqChyiUVDrCHl/BVnGdRfOO/AE8wPWR59CgPnAo?=
 =?us-ascii?Q?MoQD7VcQZW5jeITbWBno+VNXAERQ02U5mzV0hfJ5y2CkCgEc0xXMPXBNLY4v?=
 =?us-ascii?Q?piAHuJMdjNCAhqaAkE/xhyfhU3NPCB1/vuo0tQt0E/Acc/wIyvcC0LXRtN1w?=
 =?us-ascii?Q?Xx3Iy6uiu+FnVckePH0meNElvdkeokcHdnPXeYjtJRRuhnfZfGjcjlWoLLFM?=
 =?us-ascii?Q?uQZ0QdaI90tnEutAZnkb1ZwbmFWq41EmQObqwIXHPcY/iETj73SQAhJ9GVEJ?=
 =?us-ascii?Q?4IzjNPBtgd1h5tIrrLNcF0RxVt72qqzhyRxXF/LYu8H9vgAc2qkYvXRG0Ftn?=
 =?us-ascii?Q?X1p07yuxJRGWbIZ4SpMmQBjW68rlK180bEJjPzSammEwSskIk1HPrcz0s/r3?=
 =?us-ascii?Q?fX0sWzpa3cIhNbpoz3C9nveoaMsg9fUfMjieU7V39gEuYxetnPbC78pkjXjI?=
 =?us-ascii?Q?mYcrHuriFsxeIm27uF9EJs333GGsS3bnM3WqTO7YgaNkUUhraVDoKt3KjoPI?=
 =?us-ascii?Q?wzQ2V2udRvCCAhW5rj6ErN5nkiqmSHdiVQpKNupi/dtsHNSQHlNU43+9LYvS?=
 =?us-ascii?Q?KPx/rZqHJl779LxTUgG3JB3vJ0IY8OANhQ4jHX8VqsG2scYyAIHyntRj3zin?=
 =?us-ascii?Q?txw3eZokZDGjjyd5tBEYmcXAuS6WMmqNzMCKM8JI5X18mX24YBduOA+8ESlO?=
 =?us-ascii?Q?9SVd/94L1DmxWTohjYCmfR6i/A1ol1oTgnz5bC2QI8zmRv6m85Fo4XeYh1St?=
 =?us-ascii?Q?z//Z/zsefvjBUl2k2eyWgJCf2IDKdlYwfO+dQ1vrdEFdUr6fHEG1XudbIfOK?=
 =?us-ascii?Q?YxcmmlAILCH4xnOm7fpwJrJdF07MnfpII27f7qRmtRp4kalUGNYe9JKfXqau?=
 =?us-ascii?Q?da2rX4hcvzy8k7HpSkXvyxYl3ciBnw1SHpYvny8lq1vmdDI6Qr/gzWwDpHF3?=
 =?us-ascii?Q?nO09d3ZbDcLqgmx//CMKjoFIni9vl7JE3JyiQGCjW9mFObq1ZGNfLwzZSlj7?=
 =?us-ascii?Q?LB7awA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3372135a-1ff8-4242-96ec-08d9ef24dca2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 19:13:05.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7bEBNJAIBFEiycxDiIk4V2hMID+0FfkHngK5+z1BHfTRAIXzoi1jEFhUuMBI4Bv7PZekwr0F2h20E23NuplEOFRjlgr4OoOe5JcxrvvgtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3315
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

