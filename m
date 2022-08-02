Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37915874CD
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 02:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiHBA1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 20:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiHBA07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 20:26:59 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2064.outbound.protection.outlook.com [40.107.21.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E681EB7F2;
        Mon,  1 Aug 2022 17:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3Ym/TeyQL9+A6BSx8NKlcCbfNJ3Gz82NPIuQKrnG7giDxS/wMZjl256udoPq0HWTIx4dQG0bsJjK9VN4m6kb2cMwbzWWwV1j2JbJjd1hjkchAnywkNVvI/QNmKbGSfKUeccCLe9/G7eElI6/C5/E/vuczAQwCMW0TYSAl8j0HdfxjrBiaLUIQMGJMMUTR1AL61cbNlHlKjJGWecD+lb2HEcAqonySkNOJFoqh6VQl/WeuVrVojyEiGpXaYOxkemRRQKMvabfe3qLRUS+e7FirhbO0w2UtEdcY1hmvxvB3AGBmtTi1zehY2nOgiPggDyVleew5Rmun+aQgCfzgsZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9k+1YOr/dbbIXe2kynMV4+AoZ+P9Djqc7UQyQ79hLp8=;
 b=ba9WGak2e+p5IqC9tGAmjTl+0lUUQO0BiOlOtHf9UCXbOABYmERDznGo8JdmrlIzXxyO2k2MwcWwFygEUuI7RorwKGZ7xB1CJEaL/bKDqEiSRlrl61i1ucBprL3FTYwYxYKNmrKoAiCvUtHI5tjEcheFW4fkDdubBLE5V/oo2sykUi/ZF2vUTUy1AIJA4kNVnS5CZ06gUipcvnCwVMZgNWiW39PewIHEsyOT16oomGh5tQrQP8sO4rD8xXVuzQSjDw5/j+B2Kabgz9pml20SmTlUXf91+bIHtOHIfpHTPOGzJzpVV54HR3n/Z75smPJisH2AcdgUbVVFp5BtLAcyMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9k+1YOr/dbbIXe2kynMV4+AoZ+P9Djqc7UQyQ79hLp8=;
 b=LWRXialyHaVE1oFgWr8tkh/YZJmmez1qpG5uSEkJzlIW9bQ41HuBoM10fw30ewnwqKw2eMO0sbM9cqB/JXB7JZrkWu8uNoDSSezmPTTGEd9SFUXW99arnNArwBMgDE9MKDEeyID5MWUIZRHoM9/eGs+UeJGGi4dK23GSZp0o1/4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5385.eurprd04.prod.outlook.com (2603:10a6:10:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Tue, 2 Aug
 2022 00:26:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 00:26:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: [PATCH net] net: dsa: microchip: make learning configurable and keep it off while standalone
Date:   Tue,  2 Aug 2022 03:26:36 +0300
Message-Id: <20220802002636.3963025-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0144.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71b19dd1-d396-4d83-616e-08da741db35b
X-MS-TrafficTypeDiagnostic: DB7PR04MB5385:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbQX5129F1ei0JyuVIv8EM4zbHALMZdsO88G8z1iqeop45huYFG4KDq2pCvxu0GBf8Zqi6js+GXWssF/xqhvGa4GvDMoA6IIcKEnhiaDxC466n4YfXiDAAqe4xxaDjM0OkUi0tsHvSiMhb0t/gcTFsy3R7+fGebAM8Tb5xAuC1/Uesa2Big1MxgatcTXW3xAdH18Y/dTg9lOI8+7LjmBIBm2bfd8AA8yy4nXM/RCDTDkBftt87YWwakog9BeSjYXT8ffJZT6Bp54x5fthfYhTjWYaVOhE+cQah+j26B1T9YlIlLKC64v+t4gIdsK07hAS6Xt/9ZthEu2nDfUcyHMDu4WyKczrvDM1Pt7TDoMO3Y10AVkv3AtP3fwHQLytVjvGYCtipKiblb2t70d3qtxFBUeOQti/fI9Jj+Me4/TlS035R133Mv2nJYtdfCWDiGhKdSdU1rWtHTj+0ifgV7c80kWF0Px592jRXAFkALjn7LAyuxsB/7ge2t77e5107bwAbjtBYsxwAivgTiILn+aLhcmKRh3JB/EuC0SWBvw7x45uiDwuwcIo9Wl9b9zlbpJJFi0XusiEBiqs0/0P2kYKYPVOu0TU00MdXDTWn0/8Ynt97slTfvIpf1BEXhSfBTIP1QBSQVdsM/WlCdnFEBJN90SS33mHlG9g1RMl16o5VqXKuxebY7vUBRes4cfNPXGrax04K43woKLsoqHPFTDLjHK34cESIg6g3vbHRIKGhGYHZtSWbFlnO93xQfTcwaP249VMykWWQ6LA9Z+8M8XBRmWLCTMYmznXv/tBV1YZE3jJLRJksDHdIGdp2DgkrZVm9UpYRYukSzWDb34XElNLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(44832011)(6506007)(26005)(7416002)(2616005)(5660300002)(6512007)(1076003)(186003)(52116002)(6666004)(8936002)(83380400001)(41300700001)(2906002)(8676002)(966005)(6486002)(38350700002)(38100700002)(478600001)(86362001)(316002)(36756003)(4326008)(66476007)(54906003)(66556008)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SlWD3+rhR58k2xBryZcfDuZYvmIxfeQUuncH/Lfgj+m9j8QO0cNEV5q/kVaa?=
 =?us-ascii?Q?/zCMi/qLU8X+ZzlsYzrMQIF3iKlIhUM+rWlOzxHbNUn/pImw/WKNxxSFIeYd?=
 =?us-ascii?Q?x5N/0j36tVledoE/uX4UX4hxK4+J17DGg2YbaXkTc0Y78GEZm/ZFyWE0G77x?=
 =?us-ascii?Q?WJnmEYStteUdiJqs6Tdde3nkbLByKyor9xlTVyAolOfrGiRydlm5yJPz6waG?=
 =?us-ascii?Q?XlmFrbofg7XV6JfNF7tDGIUjLqBKkiMbTUamUgpbbDDDqGq4KeIGXxeQNlwO?=
 =?us-ascii?Q?2xEeHpCp4b4LyFwPq1+jEsq3TzRCUpvmSEm1v90yosPW/9EWC8e3/1sYL88t?=
 =?us-ascii?Q?eiwL5id5YvE1yGQp7erdDU1wn+Hk2TZWOsl4dWERv4sAARII8hUha8UKpICd?=
 =?us-ascii?Q?qx6YiX7yu1Am71YQnqskNxKgNJ85oT7zVAVZyp/gOnUAwDJt8HBwVZHyuSyU?=
 =?us-ascii?Q?Mh6wNLgPFU1DtmFIXC54zo85c77pvTsqzhdlLLYLb7vxdTtehtxxCRqT9qA+?=
 =?us-ascii?Q?E5VFN81pju7U0XbAZd7S0+AjPfL9QS4OYtOyHoBNCAJZrldCmFWd/JkdqQmF?=
 =?us-ascii?Q?eGO4q/Rh2fk0HGHTPPW4Eiq8+8fM3w7awna6c4rDA3fZA327idsmVaOZJTWA?=
 =?us-ascii?Q?JGtyhZrAImSVthOPPgn+Zz209pP0VUcLbWLdSSCxQ9tBHZrdOwUBsdoGygGe?=
 =?us-ascii?Q?wzPF6Yfw8fAmQyrfBGofVflyaEdgHC8ziTA5UivL1oX20WE3RHXuaA88pFmJ?=
 =?us-ascii?Q?iWUqfG1HDvMDmx+2mGldl3KhKQW0/E8sPW/hv138IGUcttPJgIO0XMpUwcMH?=
 =?us-ascii?Q?hkM0nE9zeWabELA4iJ0pnwKCGplWJCDtRSOZ3NvOUkGOBTUnxilgfRd1dAgf?=
 =?us-ascii?Q?oomIV7M1FZtqiQvMXUK+hosXTdn4mQ1QF+yVcFf/XJIhgCjpxuzZHxWsb4QX?=
 =?us-ascii?Q?HIRNF4RwnJQYmhn+sSlXSr8SE8LUEI4PGM+abjslzZzgklDOrHQBhnU9CxdA?=
 =?us-ascii?Q?8pkZc2QQGN4RrtBsdsDRvM8eDKFDns6vx3yDc8PuAuBTbTc7Xwf/4DVJUY9w?=
 =?us-ascii?Q?jJryUeRKDq1x3dyeU/hmTPIrcAFSNCrd8EtYvG5p6pJd0ArEE5DYcwhWNpVY?=
 =?us-ascii?Q?vHmUJXKgrHdLhEowd7JcfWX6C+B1saV7qiimIEB5gr8wcZ4UnS2fXYjmDqt+?=
 =?us-ascii?Q?Mp+NLD+q/k2kJBjXRb2Q3OVjIBZvdsjJzhpJHngxcp31pDT4/yZ4rP0IO6nB?=
 =?us-ascii?Q?wdFa8pCrhKb7I6xwzkPgoyHOZQmfd0fbLCAMgfKWWJGUEtaW76M6mU+DA88S?=
 =?us-ascii?Q?nNXO+vrgJRvh4/LglR7n1V5XkzCvss7M78GiWiU3Me7UKKwCZqbp8QMkRvoI?=
 =?us-ascii?Q?LWIjPbR1mNj0ZxAZaPm16gWDcx5Ohdjs9yOmwilgSoTfj2rXJBAkIYW+YXgC?=
 =?us-ascii?Q?f8aqORpMpFPr6oUr1YaZaMsSrGnWEIkVCwoHpIZNAmEsSu73hMTGTNi/VZhG?=
 =?us-ascii?Q?K999q+TTldzeWICg/FnGKYf4yTzvEPdF86MotP1jE02VRo08IwEYiwWW5RRU?=
 =?us-ascii?Q?Vwq4G8yaUqAElRbdApTKezyH0fHkuWNdzmyOWAKP1qF/S0z/7GIJAdBjQYw3?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b19dd1-d396-4d83-616e-08da741db35b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 00:26:54.2548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZVShCQ2QFXqF+zYA2tS7nYpNjLAGAqu+rMJq/xFE4h0aQgmk0vboaKgOhchR58z5eKCDUx2A8+DW4I/CI2y4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address learning should initially be turned off by the driver for port
operation in standalone mode, then the DSA core handles changes to it
via ds->ops->port_bridge_flags().

Leaving address learning enabled while ports are standalone breaks any
kind of communication which involves port B receiving what port A has
sent.

This fixes a design oversight in the ksz9477 and ksz8795 drivers, which
unconditionally leave address learning enabled.

Link: https://lore.kernel.org/netdev/CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com/
Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This is compile-tested only, but the equivalent change was tested by
Brian on a 5.10 kernel and it worked.

I'm targeting just the "net" tree here (today 5.19 release candidates),
but this needs to be fixed separately for net-next and essentially every
other stable branch, since we will be lacking the port_bridge_flags
callbacks, and there has been a lot of general refactoring in the
microchip driver.

Jakub, I wonder if I should let you do the merge resolution between
"net" and "net-next", or should I just resend against "net-next" and
keep this patch as one of the stable backports?

 drivers/net/dsa/microchip/ksz8795.c    |  2 ++
 drivers/net/dsa/microchip/ksz9477.c    |  2 ++
 drivers/net/dsa/microchip/ksz_common.c | 35 +++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  7 ++++++
 4 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 12a599d5e61a..17930858cacf 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1408,6 +1408,8 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz8_port_stp_state_set,
+	.port_pre_bridge_flags	= ksz_port_pre_bridge_flags,
+	.port_bridge_flags	= ksz_port_bridge_flags,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz8_port_vlan_filtering,
 	.port_vlan_add		= ksz8_port_vlan_add,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ab40b700cf1a..811ba0a44ae8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1339,6 +1339,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz9477_port_stp_state_set,
+	.port_pre_bridge_flags	= ksz_port_pre_bridge_flags,
+	.port_bridge_flags	= ksz_port_bridge_flags,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz9477_port_vlan_filtering,
 	.port_vlan_add		= ksz9477_port_vlan_add,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 92a500e1ccd2..9bef51af49a0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -900,6 +900,8 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_pread8(dev, port, reg, &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
+	p = &dev->ports[port];
+
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
@@ -909,9 +911,13 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 		break;
 	case BR_STATE_LEARNING:
 		data |= PORT_RX_ENABLE;
+		if (!p->learning)
+			data |= PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_FORWARDING:
 		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		if (!p->learning)
+			data |= PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
@@ -923,13 +929,40 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 
 	ksz_pwrite8(dev, port, reg, data);
 
-	p = &dev->ports[port];
 	p->stp_state = state;
 
 	ksz_update_port_member(dev, port);
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
+int ksz_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+			      struct switchdev_brport_flags flags,
+			      struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~BR_LEARNING)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ksz_port_pre_bridge_flags);
+
+int ksz_port_bridge_flags(struct dsa_switch *ds, int port,
+			  struct switchdev_brport_flags flags,
+			  struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
+
+	if (flags.mask & BR_LEARNING) {
+		p->learning = !!(flags.val & BR_LEARNING);
+
+		ds->ops->port_stp_state_set(ds, port, p->stp_state);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ksz_port_bridge_flags);
+
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8500eaedad67..a0f1775a9960 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -54,6 +54,7 @@ struct ksz_chip_data {
 
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
+	bool learning;
 	int stp_state;
 	struct phy_device phydev;
 
@@ -219,6 +220,12 @@ void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 			    u8 state, int reg);
+int ksz_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+			      struct switchdev_brport_flags flags,
+			      struct netlink_ext_ack *extack);
+int ksz_port_bridge_flags(struct dsa_switch *ds, int port,
+			  struct switchdev_brport_flags flags,
+			  struct netlink_ext_ack *extack);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
-- 
2.34.1

