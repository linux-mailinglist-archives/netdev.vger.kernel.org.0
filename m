Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB25E973A
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiIZAa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiIZAaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2093.outbound.protection.outlook.com [40.107.237.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CE322BEB;
        Sun, 25 Sep 2022 17:30:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwCjauJMZAN68KzIzYKZ1MQU0xj6S4vbOPgA1Y5kFHHSXjT4QAsM8OPubkO/FPLlqZb1mP23os/cH9ynLhUja1gIPoP13iQd3FHiI3dofyjmkmvcRnL4LRcQv/aFL9wvvXbdZOW7PMOkKrmXhNflfzqhJ3SEXjRpD81Fh1AalFQbmrsBusSrLrc/fOp3Iv8b481iKASEJ7q4xCqOXUbqw8/OYnaUpuLqsgvPOE+sG8wTNGc+JQ3ijzQKZTYk9F3Dl5D2UuaayN4OMwJXIG9eVGe/6KU6xBR7PZPhV7uMBKqhTFXpIw9b5qv2EQv+GJYU80KvJR+10VkGs6utR+HNlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0c8wNJsp1ue06+XveUThFK29wEf2+TwqK+jWrEvygo=;
 b=ayyo2lzxsDwdfDs+rtTOszI36sUJOuw3Rthvfy3DwXZ78wlHH8S88yka+dLnSH6IO9OQfFF70Je7gkVK9g3XCZkQI6utx0ozVgNTUjYFl3iCuH3TlNR6dH8OA9WLT68mshoYyrj5GNgyvUk3D5RTptsIVZZ8U4YPBAqGqxwPVSBLLvny2asLNQiRpa2IffEbZYib1wztLUt2Mh/5UU6U7VhPVhx0xW/FPG1J543KnKnOKPLiJ2WLXxgylCy9zUvOrNdOW8embKrIbdIQGG+UemE//GsRCBjbCOYpVmJgBkNRzwPCsK5dWynbiVVxl1+cDyRFmPuUBywTjubgV1u1aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0c8wNJsp1ue06+XveUThFK29wEf2+TwqK+jWrEvygo=;
 b=Zcktaq4BHs7Fy2RJ1j8ShqJKW7eVulC9Jr6Amqqsm+PsSwnJqw1FEI+P/OQGBvv2C+NtXLujmylittc7begdVpCrDd/I+SA05Y8Pu8U8Os0/x+0jRPX6tmOxeqc/NxuSh04fjfYyfZlbii7oMy2PPX7mU3sBxbD7S4POzSXQSuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6062.namprd10.prod.outlook.com
 (2603:10b6:8:b7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 01/14] net: mscc: ocelot: expose ocelot wm functions
Date:   Sun, 25 Sep 2022 17:29:15 -0700
Message-Id: <20220926002928.2744638-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: f12891e9-c8a1-48e1-271a-08da9f564893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fh65UwbIIfkLh+EfAI3tbz68Clq3i4cOXVVOTPhvd1rg5QJsx/gJ968eLZ/HpkvgmCZ/UZzFRe7O9p/zN+ICHQeQGN5Vbdm68cCEhn/3CgN4uLMfZ2v8QEP6/ip5b8EvARKDmVResX6+cWPnmNDXZs2qUoQ2qbDFw8kJ23GE9UeM5VMi3KcCNU5gwruVw3gxT5Fa+slmMArSsiW2Ywjx96noeYBv7si4x2gmsCd1Y+URdcA/jFQ5uYLLf6X22LdfFRQuBpl8LW+H3zLrFlYZQp5DyuvN8tu5r82i0Y1/r29PBXXXMlMCej1HnRIESLKoQBX0iINJPOi16FRdBu1Ed+qqjfaoNzdAYb0SUB1iaNpdkR6g0Zoe7kxMUKjgvH//X8CItQaH65Mh4jY9yyF2sXO9ZDu1gKLW9CDqzjpZYJbg41p8cy7lzf+VUBHUorzkPwoE6c+NIIcSpaPe5Q11D68grl+mRbcR0G/bk98I4DnWAddDkMNLiOccsKv2h7KWxaGbjcdxS8qDyCveeAwupOzykW+gdxjQoQE2uU2zePRk4B+rMVMt5FnJE3JCIKslMfSx9cn8FVFv7MAiJYTLwXAy8D3mopXViKzH9KGGjcm85/RAmbKNKiUcU5CbV7ZQGnf30nPdZF+qYQrvbzSMgSq6X6vhcy25FDrpIsmxTqSRBGG5npoyM8RilvDzVwXvoy3jpLZ10hG52w6kKYBLHmI409hTAqHV7C5CiNRT4yzXyNf6HoK+18+9TjZ1JKssQwOAfFNhLhwbbNxx/7/tSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39830400003)(136003)(451199015)(66556008)(66476007)(478600001)(8676002)(4326008)(66946007)(316002)(6486002)(54906003)(38100700002)(38350700002)(2616005)(1076003)(186003)(86362001)(26005)(6506007)(6512007)(52116002)(83380400001)(36756003)(8936002)(44832011)(7416002)(2906002)(5660300002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qa/2bIdZTSIehx2xrp+ROKwGZPuJ3sUvMAwLOp6fGD7Y83zSposFYL4RSS4z?=
 =?us-ascii?Q?7mB8B3wUZj/dSDJUUSNzWqajx/VrhlwOBNkQUYQxto7bXXYtLizBLfSmgG4j?=
 =?us-ascii?Q?cEJKMmY60WTZczSHc+88oZhu3oO/06OSXlirjin7OWw/MIRK/x1ogbzZmhMF?=
 =?us-ascii?Q?VJ1pertS0rRm//Bq5kZZXsy7o/7J6bVrrsE0YCXYx0m5+EgGkLGNRY8CWd/F?=
 =?us-ascii?Q?t65rEFrJoqiGWNjejQrufj/FM6EinheiQ2js+KmkncV5BkAC4/FBKuVnIQOy?=
 =?us-ascii?Q?Hp4M9HlnryAB78v9rksHD2rlIVGKTEqUszzo8E5i00kgvSQP80WBulXKT+vf?=
 =?us-ascii?Q?nq3ey6i0HczeBPcjzi6Wu/ExVupL9xh4hIVqG1284TkCfS16MMbRB88Neqi8?=
 =?us-ascii?Q?UL0TWJL50ooQ5QxoeOaYv+czzr/bJ324wC6Wcd7SV3l/iw04UQNCYpMBtFmG?=
 =?us-ascii?Q?acL7hk9AXVo9BB/jNU/dU6Ewwlr+9r3BSmHUBCfAOPCO8scnvczjVKgu9uzM?=
 =?us-ascii?Q?ffR3parnAtjC2FzGE6lh3mgau1hSfhNCFZKdwekk02WrYH1s05f/L49QPQXp?=
 =?us-ascii?Q?kRiHaTJ+MkvCQ/HckL10Bj8aoHyFAICf/eFNoyqXQbW3XEcznISEQ+eWrWLZ?=
 =?us-ascii?Q?ReJBjsI3JhiY0vYjbypA/+k0wEvQVdXOS4jtdgDFesTYMATrQPg8t5I+CFTB?=
 =?us-ascii?Q?3smdJGdVpy7h7LJ+wlXLNlRyse6EKavcpR7DtrMFDdGOPRNBI3jlnPkNlOsF?=
 =?us-ascii?Q?mqLzDE0uMH+uOlNOxRidzcBLD4TRLincomyq5amXD7t5W1xPv8xa34d8i47D?=
 =?us-ascii?Q?jzRlbJj1A9gCf5/T474x4NTBSdTuX8SgWoT51eUR7yanhZUf4dw6dc6DTdnx?=
 =?us-ascii?Q?Ig28d5qWw7KaRByDjNggCnTsNwjqMdWu3KbhQVwaTnJ5wQU9Vv81kis0GiW2?=
 =?us-ascii?Q?08FYlDxA0rmgGNA33eqFumCeoZt8FF/mfCBJcUqoGsg5QumKWwyZzFzupvRe?=
 =?us-ascii?Q?LgG/kSm4NigNMYJi8DgK930ciiiw44fWhQhGJSI6wIzT6bSSMoF5eAwcfTBw?=
 =?us-ascii?Q?yNPdnfthEdICbpSIotnafbKl1CMqyjoKZ+mwZnqZtAo7SdU4yt2W2vlsEPC4?=
 =?us-ascii?Q?EdYrcSIpoCPH2VpOEDJD0PRae5oHjX8tXOYnWTsbDrIyw41Y41g1Nhf4QDqk?=
 =?us-ascii?Q?m9T/g3ZXI42K0PSKQ8a9scZ8lb4lQYq1loDQl+WF4cMRjJSDnmqUBvEk4htH?=
 =?us-ascii?Q?jtE1lMR8f0boeYLSRevgIMAN6JlK8NtpgEwbkzN/a18g7U0SNiqUvVtehREL?=
 =?us-ascii?Q?8V+zjHikh4YNnNdDnogCPXKa3D7Mu0CZglhxGINbqRFW7gWAbyS3Ow9FpvPy?=
 =?us-ascii?Q?PFD4ShD2HT1KQkm0i5i4Tdlwc5Kjo9Wr6O40YJzcVR1dteFE1v8PYHar/WD4?=
 =?us-ascii?Q?ZW6FCoAgEdoTRAsmVm8RcW6MavliDvu1vM9MyKCRzii8qgHsfaZtUGr6Nx0I?=
 =?us-ascii?Q?ctT3Ti8yai8dPNNzEBNt+MduN0jAMsXEHNlnqnKVOW+eVBRry4ZJxeJp7bP4?=
 =?us-ascii?Q?E1dUplOQfuMK7tA80WfKSA5f2n+WJe+otnkiPbSj7KdY6TEAyMWa1D/9qJE4?=
 =?us-ascii?Q?h2gmGgqzWihTfj8JD5OKEEY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12891e9-c8a1-48e1-271a-08da9f564893
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:16.7453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrEQB5ykCuuI/aTqe48R0WneSVxMp3bYTgB67iKxjw3MzRq80Lf6ndWYrx9UFjbPPx2ccp5Cr56w+Wc2QtJLmeXgoAwCzo1FQXb2t2jSGGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6062
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1 - v3:
    * No changes since previous RFC

---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6f22aea08a64..bac0ee9126f8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -234,34 +234,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 967ba30ea636..55bbd5319128 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1145,6 +1145,11 @@ void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
 void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

