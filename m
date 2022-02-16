Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0FB4B8B75
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiBPOc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:32:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbiBPOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:53 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA82A9E15
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d55cENHzLDxXCrMAo2ekjvwvagKJ7CJL7lWCjHbr/fYqCskgCKQmaLRlam1ZUH0Dz+l+n6c1qtAl7bvEq4Jixq2Lm1J+67oj8+RhKLwb89ar9AEUsRQzgYMm6Ave7LD3B4210xRXPhRI1XrjZYwknsuwPdBf0HkkvA+zGrBpNi3zhaWYvNSKmP94OAiKhIrWY8RhEhJou5ky/TkQMaLLY82qi/8Sqac6r/uBhxQ8zZDdlFERN4+9qoeYdBkac0r9E/amqzD8TDE9aSSf+6qq8vCyVwwnqHVDtKXT5bHvvmYgC9Tg0dkGz54Sp1zoG6N7O5WzEmYlbmYQnYhU5SEIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKEY8qj3eRpU8oBl9qiOUoTz4c8cmt0ivSsQqewHLBw=;
 b=Z5f954qUf1PVCbVknZ4i0bzXugjbNqyIC2UFE6/0lVhNp7SPEIOyXrU5h0FY1hitdmLrEVtOa9FaIkgESz9voo7/j6eT6/LtPpsEaadFNdxo2ANRIi79QGCz6sC5mjdG5nN+x4G+MPxjpAuinJunVXD3KMSr8h1ijHfx08UsfsPBpXn7d1nmQhHWNi4nBA0Bitmh+LiNM+8rGQaKS8oTprALjcpbsh+/tBL3uipGu/orAp1u9GgMmGrUo62MhY427PlxnQ85HFarW3lRM9tM16tiq0ctjLsBE9XEFqqs9Xvw9Kv6ZJcVq63Ebzj4b90z+m4D3MYvJE/DN2IbI+mKQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKEY8qj3eRpU8oBl9qiOUoTz4c8cmt0ivSsQqewHLBw=;
 b=o0dZ/XDWaSj5hy3j/A3uiFrW72mEe4pVNfSjFFa/uMwECwC0BOsdvziWt/StSKTW1f1nOMf9MsF+o5RNc3fwSvUaOi51OAdq+dxzOo0CGRPCSVaA2fNhkCltWOKpH4YgyU4uH4KDtwx8M2vVMHwjBb4abMdIXrUcORRs50FMyvM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 02/11] net: mscc: ocelot: consolidate cookie allocation for private VCAP rules
Date:   Wed, 16 Feb 2022 16:30:05 +0200
Message-Id: <20220216143014.2603461-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81c3a5d0-2cf9-4f8c-b242-08d9f1592df3
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB681524D35FFE3FB5DA312F84E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQJ1KirbsjCk3sd8BxKK96Gh5OZJ8NsteOIOu87eMzdVkaXUSHt0gNNJynbr9TliNaGKlEbT+4yQSSxjfvDyoBOZUsgMQU0WmZwCoE8naIzK+pT2N2hGVQlTzEfyT/68oIny7gJCYIEVnhhcfDa7zUviYGAfQcGZed8gRWswNTxzVhQTPMnw0FIIumOA+Mvepq0ED+UvKneu86O+K+8qqTCYoMT87K0UW/g1470+2LtcvbLo3xbW54SiD5UU1a26LUMcK7yW96j2wOu03P0glnBR6lng0QF5Z1Q3uBl99fbHB6FHX2Z+PZhJPg0mMY87UoJrz87JIAen3Mr4iAW965jxXOEBZ5meH4jtwAj144wa0A0Ggr6h1sOyMGxcONYz0zayCRJHyxy/n2gSGyUPHnkySO3nRJ4sN/Z+KqywpAMCOCwLeaP7d4fLnZkt782vLB9/6p4qZO57KxtDP7RkEKlceLgP8cGlII3ghCOdlHbUiY9QSHIT+YDtdpeLn2HTcftwMlRvsiuGMEQqqVwEh5EZmhLRXYBW+qykNQH+dkPuMDcHc1Ja9wLf3Vwot9K3NWxeO+dMutxTQotnktcQVXxvmlMq5PA4/fPtN6aUq6IZDGiQZeTaWI9I/oOrjuZ13hBUPBpfA6bbK3wWXn4W1U4JnXxotIpd7yJgjrRV7g/GUvjGoqjkq/QTAR8LAzvm/6qfYzGo5ycDFdSjT602kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YNslr8svM/fG3dbO5G4lBPvVnRYzDLeeUBgId55PqbHESurHIHTeiHKqpnLG?=
 =?us-ascii?Q?qXvk3jDZ2XqOeAmQXg5LM7oimP96mMDUluLHW0Yb3QeeG7GHYi81Gxc2/GI4?=
 =?us-ascii?Q?FL0q248PVOxpZ7AiTL2ny4hU9oD+EWsIIkG8FfuBhhXEuu/2xdWgUNO4dKoX?=
 =?us-ascii?Q?GYfeRosLGH2XEG1JIuPsCkPNutUNk2mFpyxiNHQRlMMcEYvvCpy7mqTtMdLk?=
 =?us-ascii?Q?o8DRJe8lYS1ijcArwVS8bCZ5OXZbsYI1a/7CcCR4pnURguat91XqyLxGvYEu?=
 =?us-ascii?Q?BEOK7rfhMRKJCHGkwbhdXJKtKyWwC7BK5oPMQXoueqkEdHDw2cp/xizxnxic?=
 =?us-ascii?Q?onKicxmeMpFXwIwt1ZMrtBsk1ESMwO/GzQAhdXZmmXMsqZb3bqXkxCCOxG7D?=
 =?us-ascii?Q?RGROccweDsnUe/1iUhF5924uVdISbsZWnwJngDIdjER94iBRwIxoDm4MmQnl?=
 =?us-ascii?Q?Vdr0wI66t9+gpGNxochIPkhkbh/kazPyqJdCuX70LEk9CdmIUiqY7T6tR5iy?=
 =?us-ascii?Q?RQ36HdzVX+5Dysg/WzWtDaULtF9UCaTdWXoFRgguD0pLPylBzgdXLDIpaQ/p?=
 =?us-ascii?Q?Extnz124de4iZlL6oeSaIf3VdW4uSisDbBZ/6wlNYPauBu3v+ZrlVkYLlu3b?=
 =?us-ascii?Q?IvE3TXvAaAFhxpu1OeTBLKo9k/FpH7PXwmLeSokLmW/P6f5baMP2xKWX5NtH?=
 =?us-ascii?Q?5SUizOBNnz23yPmamfYAYsKYRSNh+ipvETW2+ahTZzaY57aVYZPZZ7Iw3fQr?=
 =?us-ascii?Q?o3hZCoql+WUSu3JFd/moaDM/47uxT6dsTKSvbc5ghWLszk0feordHvGG9KjK?=
 =?us-ascii?Q?lN4Y3wIidkbYNgF6Z6CPRRLlQhXTimGEGA5xR1ovTKl65eSvL+x0dTtVxl/A?=
 =?us-ascii?Q?cKru0PU8zZ1J/Moo6eAIfTBk3/iDX+c1Rk/Pox0SX76MCnDoZhwtmM1MID+Z?=
 =?us-ascii?Q?rePkcrFUtUnQg6Y4bKezdFttujRBDuoJhnZ206X5XDsHzDWhSzdrc7DeuGLW?=
 =?us-ascii?Q?6dw7/JvfkbU922T8q8PNxHvpEYCu4VEzXmgSEeLGYMrWDVUYXwlnpuP0pKbk?=
 =?us-ascii?Q?4U6zzoPXOcRLvoSH5ldp3+9QxRGuXJkesEGHpeO6S4vUVBVwgpJMs6HFtltf?=
 =?us-ascii?Q?dUMQeqHxFEwrg9j/ZFSfU61OyEEMqIzb7GFBXaF3x34N5rt7boPXpohCvdqo?=
 =?us-ascii?Q?qjj1D/Uxe+LYIbyMx8WeDIXFlzujBSdERcPTSjb01vqItqD7ujkdwF8dW31r?=
 =?us-ascii?Q?tBti96aEc3b3Xu3qtdq6csvCQYfRq+fmldc6kd5mJyfvnq2/bMasPk6FuFi6?=
 =?us-ascii?Q?JM7sGBnMPLRkfCy1dyBu+rKhTQuO3nDJ/gaI70MX8mzD7CEA+8S7lp8aRA9J?=
 =?us-ascii?Q?oQRDBY3tU62AymDpiAdz6JRMx0qSH9rGGv9zzM0bRlK/UrWpa+2b9LmnJ1u6?=
 =?us-ascii?Q?TAqI39CEbjXlgNHVVD5W3xPEeEHzVLCxBtpwEcGKV0XNmMEwagDBnmB4putI?=
 =?us-ascii?Q?q+lX+Ti/Wn6CHG8osZhXumObqPy0qyym0cYRdujVzzjdcxFFw8fosF/L796L?=
 =?us-ascii?Q?Ad+hBYYKfBBZ/VTjSTDAH91iG0EVOqsPiNzCyiKp2dssbccgJWe0qc5B0cx8?=
 =?us-ascii?Q?2I/LvQXm2Ewtl6h0BKeboUs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c3a5d0-2cf9-4f8c-b242-08d9f1592df3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:37.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: diiPXl9O4I0kD0csHLMfvYP+i1tWnG8HKWeK3CCc0eE1JKX7Vswpfc8t1rU2UcXrMHQvdPwroI7OOGbbKHht9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every use case that needed VCAP filters (in order: DSA tag_8021q, MRP,
PTP traps) has hardcoded filter identifiers that worked well enough for
that use case alone. But when two or more of those use cases would be
used together, some of those identifiers would overlap, leading to
breakage.

Add definitions for each cookie and centralize them in ocelot_vcap.h,
such that the overlaps are more obvious.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 10 +++++-----
 drivers/net/ethernet/mscc/ocelot.c     | 20 ++++++++++----------
 drivers/net/ethernet/mscc/ocelot_mrp.c | 20 +++++++++-----------
 include/soc/mscc/ocelot_vcap.h         | 16 ++++++++++++++++
 4 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f5a3da59ae00..eae6da2d625d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -50,7 +50,7 @@ static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
 
 	outer_tagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
 	outer_tagging_rule->prio = 1;
-	outer_tagging_rule->id.cookie = port;
+	outer_tagging_rule->id.cookie = OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port);
 	outer_tagging_rule->id.tc_offload = false;
 	outer_tagging_rule->block_id = VCAP_ES0;
 	outer_tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -103,7 +103,7 @@ static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
 	untagging_rule->vlan.vid.value = vid;
 	untagging_rule->vlan.vid.mask = VLAN_VID_MASK;
 	untagging_rule->prio = 1;
-	untagging_rule->id.cookie = port;
+	untagging_rule->id.cookie = OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port);
 	untagging_rule->id.tc_offload = false;
 	untagging_rule->block_id = VCAP_IS1;
 	untagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -124,7 +124,7 @@ static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
 	redirect_rule->ingress_port_mask = BIT(upstream);
 	redirect_rule->pag = port;
 	redirect_rule->prio = 1;
-	redirect_rule->id.cookie = port;
+	redirect_rule->id.cookie = OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port);
 	redirect_rule->id.tc_offload = false;
 	redirect_rule->block_id = VCAP_IS2;
 	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -308,7 +308,7 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
 	tagging_rule->ingress_port_mask = user_ports;
 	tagging_rule->prio = 1;
-	tagging_rule->id.cookie = ocelot->num_phys_ports;
+	tagging_rule->id.cookie = OCELOT_VCAP_IS1_TAG_8021Q_PTP_MMIO(ocelot);
 	tagging_rule->id.tc_offload = false;
 	tagging_rule->block_id = VCAP_IS1;
 	tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -327,7 +327,7 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 	redirect_rule->ingress_port_mask = user_ports;
 	redirect_rule->pag = ocelot->num_phys_ports;
 	redirect_rule->prio = 1;
-	redirect_rule->id.cookie = ocelot->num_phys_ports;
+	redirect_rule->id.cookie = OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO(ocelot);
 	redirect_rule->id.tc_offload = false;
 	redirect_rule->block_id = VCAP_IS2;
 	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index eb6c7db6c7c4..6fe6bf88bdec 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1541,7 +1541,7 @@ static int ocelot_trap_del(struct ocelot *ocelot, int port,
 
 static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
 {
-	unsigned long l2_cookie = ocelot->num_phys_ports + 1;
+	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
 
 	return ocelot_trap_add(ocelot, port, l2_cookie,
 			       ocelot_populate_l2_ptp_trap_key);
@@ -1549,15 +1549,15 @@ static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
 
 static int ocelot_l2_ptp_trap_del(struct ocelot *ocelot, int port)
 {
-	unsigned long l2_cookie = ocelot->num_phys_ports + 1;
+	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
 
 	return ocelot_trap_del(ocelot, port, l2_cookie);
 }
 
 static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
 {
-	unsigned long ipv4_gen_cookie = ocelot->num_phys_ports + 2;
-	unsigned long ipv4_ev_cookie = ocelot->num_phys_ports + 3;
+	unsigned long ipv4_gen_cookie = OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
 	int err;
 
 	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie,
@@ -1575,8 +1575,8 @@ static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
 
 static int ocelot_ipv4_ptp_trap_del(struct ocelot *ocelot, int port)
 {
-	unsigned long ipv4_gen_cookie = ocelot->num_phys_ports + 2;
-	unsigned long ipv4_ev_cookie = ocelot->num_phys_ports + 3;
+	unsigned long ipv4_gen_cookie = OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
 	int err;
 
 	err = ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
@@ -1586,8 +1586,8 @@ static int ocelot_ipv4_ptp_trap_del(struct ocelot *ocelot, int port)
 
 static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
 {
-	unsigned long ipv6_gen_cookie = ocelot->num_phys_ports + 4;
-	unsigned long ipv6_ev_cookie = ocelot->num_phys_ports + 5;
+	unsigned long ipv6_gen_cookie = OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
 	int err;
 
 	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie,
@@ -1605,8 +1605,8 @@ static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
 
 static int ocelot_ipv6_ptp_trap_del(struct ocelot *ocelot, int port)
 {
-	unsigned long ipv6_gen_cookie = ocelot->num_phys_ports + 4;
-	unsigned long ipv6_ev_cookie = ocelot->num_phys_ports + 5;
+	unsigned long ipv6_gen_cookie = OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
 	int err;
 
 	err = ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 742242bab6ef..d763fb32a56c 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -60,7 +60,7 @@ static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
 
 	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
 	filter->prio = 1;
-	filter->id.cookie = src_port;
+	filter->id.cookie = OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, src_port);
 	filter->id.tc_offload = false;
 	filter->block_id = VCAP_IS2;
 	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -77,8 +77,7 @@ static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
 	return err;
 }
 
-static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port,
-				    int prio, unsigned long cookie)
+static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port, int prio)
 {
 	const u8 mrp_mask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
 	struct ocelot_vcap_filter *filter;
@@ -90,7 +89,7 @@ static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port,
 
 	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
 	filter->prio = prio;
-	filter->id.cookie = cookie;
+	filter->id.cookie = OCELOT_VCAP_IS2_MRP_TRAP(ocelot, port);
 	filter->id.tc_offload = false;
 	filter->block_id = VCAP_IS2;
 	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -186,8 +185,7 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 	ocelot_mrp_save_mac(ocelot, ocelot_port);
 
 	if (mrp->ring_role != BR_MRP_RING_ROLE_MRC)
-		return ocelot_mrp_copy_add_vcap(ocelot, port, 1,
-						port + ocelot->num_phys_ports);
+		return ocelot_mrp_copy_add_vcap(ocelot, port, 1);
 
 	dst_port = ocelot_mrp_find_partner_port(ocelot, ocelot_port);
 	if (dst_port == -1)
@@ -197,10 +195,10 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 	if (err)
 		return err;
 
-	err = ocelot_mrp_copy_add_vcap(ocelot, port, 2,
-				       port + ocelot->num_phys_ports);
+	err = ocelot_mrp_copy_add_vcap(ocelot, port, 2);
 	if (err) {
-		ocelot_mrp_del_vcap(ocelot, port);
+		ocelot_mrp_del_vcap(ocelot,
+				    OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port));
 		return err;
 	}
 
@@ -223,8 +221,8 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 	if (ocelot_port->mrp_ring_id != mrp->ring_id)
 		return 0;
 
-	ocelot_mrp_del_vcap(ocelot, port);
-	ocelot_mrp_del_vcap(ocelot, port + ocelot->num_phys_ports);
+	ocelot_mrp_del_vcap(ocelot, OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port));
+	ocelot_mrp_del_vcap(ocelot, OCELOT_VCAP_IS2_MRP_TRAP(ocelot, port));
 
 	for (i = 0; i < ocelot->num_phys_ports; ++i) {
 		ocelot_port = ocelot->ports[i];
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 709cbc198fd2..562bcd972132 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -8,6 +8,22 @@
 
 #include <soc/mscc/ocelot.h>
 
+/* Cookie definitions for private VCAP filters installed by the driver.
+ * Must be unique per VCAP block.
+ */
+#define OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port)		(port)
+#define OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port)		(port)
+#define OCELOT_VCAP_IS1_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports)
+#define OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port)		(port)
+#define OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports)
+#define OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot)			((ocelot)->num_phys_ports + 1)
+#define OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 2)
+#define OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 3)
+#define OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 4)
+#define OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 5)
+#define OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port)		(port)
+#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot, port)			((ocelot)->num_phys_ports + (port))
+
 /* =================================================================
  *  VCAP Common
  * =================================================================
-- 
2.25.1

