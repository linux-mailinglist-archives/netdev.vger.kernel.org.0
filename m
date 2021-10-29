Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F088443F6BB
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhJ2FlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:41:15 -0400
Received: from mail-vi1eur05on2131.outbound.protection.outlook.com ([40.107.21.131]:51585
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229504AbhJ2FlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 01:41:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhd7o2lxFlhnybiG3xptFwx7lHu9p2C6x2HI3gNMbKo6tYRwWLGdjqCsmGaHwMgcrq6E2bjDsRn3n4NFW+2P/FgyLuU/EjSYiRECYVAWqamS/xniUn8iLtGvEgxthMsiWbDPdIFTcP2ZIQdvk8iOG5uo3zqffZWaLDbvTfpS/TNvz4kS3f36Xw7Z/GSyZ2AC0vbWuxqZACJPUrGf/pqZau/l9h6HLv4VtZDajjSlDdfoBIIR/ij0lxNboU1EPeYWaldHOTygx33C6vbHgomS5sG5QxKfVjSXnDi0m7k/weXPYj+6k5qNCVz5t6bBLgxxmhmfE+9hnw5uBCmUIw/Yyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzNOF2bwv3+DXtCRMXQQt/nPAX4qaDA/4OA+m5ISHo8=;
 b=R/Ghpvq2dVfyDdlCTl1nyzi9iMeTSx0e94cnTER/eh8vogLcWSL/4EIAMtSOM8VDFRPG/RuUz41FhtENoEW/anOXu/oC24Srep0USsRRoBRrMpVT7HFEj2Y6AR6AFajvhlvBy4GlbshpzQMwaWeQeEnHLdYiy+rxVjcucLg9OaH9sbGC0hIOHgCa4hUTcJ18IT58fv1JeL4miR3UG2QwtATBWDN/yyFu04DVGIUbzhzCbCbfCmsNQQ3wQ3aTfowlbMT5eEs8GtA2+URfnl3vZa2QF7JqTqfwnNBKGVTuPusXeQzcKlFjvXIi8bAIjolpvyk7UrOGUu28UknltHREbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzNOF2bwv3+DXtCRMXQQt/nPAX4qaDA/4OA+m5ISHo8=;
 b=mXcKNasnpMllsrn0tFejzhsLStApgAQ6ZM8IqWtJo3VZM61wbt3LaEUTU05YTb5BYauXPHo9qvUOJeSg4g7VH3ovXeEgF3il9jlbc8aqFlRPFIAA+CUUJda7d/PEQYj7ErrBJ4rKSv8nUlzPs/3GawwNeasvjTvsEqJcTvE3FJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0093.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 29 Oct
 2021 05:38:39 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%5]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 05:38:39 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     kuba@kernel.org, andrew@lunn.ch
Cc:     mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support
Date:   Fri, 29 Oct 2021 08:38:07 +0300
Message-Id: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0305.eurprd06.prod.outlook.com
 (2603:10a6:20b:45b::24) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS9PR06CA0305.eurprd06.prod.outlook.com (2603:10a6:20b:45b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 05:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4107835-cdf7-4d50-3d94-08d99a9e5bb3
X-MS-TrafficTypeDiagnostic: VI1P190MB0093:
X-Microsoft-Antispam-PRVS: <VI1P190MB0093C55626EFB31ACE0BA9568F879@VI1P190MB0093.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O42hnnhQo3B4MNwHHn/fVAt7CwMFMFxoPLpNhWf32cqCdO+7Nr55ZP7LTnx3enY8gE2X4StUyynCctLK7krSGJGjjS6xsRtUHjYH0ylUQrRW8rgUeS0ii2v9lnWUcnqhI5FClwhS5ToTC4xhuuk92FJ51v8V2KInq6lQpFVPwF8hY6YLKb25BDGsw7QyfaRSrmGIdejELqf6uzUmCRdWXY8AYyCzIpu5Tp3GUrq4DqCnfqBb8qXkiJb9IVglJ84/zrK1TApFO5I9CdWteC8QXOIBEe2B4i5MbLoHsTOMP3B/oY1FLlW8YqgXDsNkrXxcxT0nZf4prLyJJpI31hOaDbnGWoOjR4Cf3Dz2GSb4uWNddjCBgJYyMhZHMw0HPIDhUYPNP77CK44texYwmwwXF3XL4nyvJTs7MCGoPPCSHe2SVu2Pk/1vYoAk3vLfJHVdG2V4jMMwLw2VXQJfuxYQoIgGocNUee5h7kVG6EJamz1vtDj/ydpGGu6/oL0U7yQ554C6c4DjezQZE41TK1/z6NSjE0sSalqsTjL3iFw8yuMHwp8Proal23aaRMwktRzaboQFhCL15zHxY4ZxTBfdlMgPF04gGnvw1szZcTPZbf8h5BUC6eGHKmxtxjpb+joJxLyo5rPHGphXL1JbKfKDTgYWjzpBk4lv/ywbqm5JLrND8DEmyUG4QLwnuwOFSgy51GTJqdqDZnDHOZACaWK91w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(136003)(366004)(376002)(396003)(66946007)(956004)(66476007)(8676002)(66556008)(2616005)(2906002)(30864003)(38350700002)(8936002)(36756003)(44832011)(316002)(6506007)(5660300002)(38100700002)(83380400001)(52116002)(66574015)(186003)(6486002)(508600001)(6666004)(6512007)(54906003)(4326008)(26005)(86362001)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YmdrO2WOe6GWCQGznzmEafkVYpIccpfeezvPKTRMp3yY6MdtrDt8/i0rit6i?=
 =?us-ascii?Q?8cvW9FFBIXOb3nfyJ9Dh56vl4PTLPcl3IkJhiexjHwUHQGF1Ifi+AcM7wys6?=
 =?us-ascii?Q?nxKrxP7wTQqRd3F5snRn5BnxHyLzsH3P6TQtMcHI1OomOpPFEKq5S4AN2gfO?=
 =?us-ascii?Q?Vsg7YnHjaUel/FUJOuu6xAL2Q2u5QZx0HSf46+2t8LcU3BOYugS//6qE7A98?=
 =?us-ascii?Q?5J8f0uKDKBGMAMwTH6s6zdIrs5XMcj6scH82IBvtKR1I4tb3E/XqW01APvHT?=
 =?us-ascii?Q?Foja7m0rODQ7D+EyFb5Tv3hqCgGs8F/enHMlUfFFFnc2xqKFRjfy3xSI2NBD?=
 =?us-ascii?Q?6SzkHlGLSJVfk58+zu5++P4qKDcwkX/OhCMUGgaKHg4TFhEFIg6eXG5GRhH2?=
 =?us-ascii?Q?P+rvP7VjlnSeX+XRcUMl/vFVTxZYms2o6MRRu+hTmXn0WRnQ4lUvjV8TXCvW?=
 =?us-ascii?Q?phjQuklJWQs3DO6JowiFSzf6vcZFd8JWjcX2uexJrO4ZpiWciLu2CPnWenh9?=
 =?us-ascii?Q?+4J6TUvXxWL2CDArRXvbLbcBn+Zp/TrxsHYnqoDUmBhhW/qou68ybfUUGQfe?=
 =?us-ascii?Q?SVGnH2pMM62GboQ3HIaRGh75XcrzSDSyF21R466/fN9RBph7fP3Nt0IM274t?=
 =?us-ascii?Q?wyzyo+QjUyDNJ4GOVf7jPTWGjYR1m4quxip3H6CrQMvTLG0wO3lJonimA6VX?=
 =?us-ascii?Q?CnnP6frl+e8aPBAm7YZRk9F+L6iA/oGplSKviIc/wx7VainqiDFCDrEIs4DM?=
 =?us-ascii?Q?s0wrywH7kEF618H/tmTBXqj4fYFlXbQ3dUkQ6rSBuuDuXrSv0kaC6NcJfMxt?=
 =?us-ascii?Q?NOPKqomFx3QyGAHXvbrMCVCa/6PauG0iIMqyL8Yq83PEcA0P9oCO4Hwl6Lic?=
 =?us-ascii?Q?6sv8wkeMzm0Hb/ekMk0d6xn32Dd+nJvCflyl3v30ugPYTja1k2OuFgoDAQsv?=
 =?us-ascii?Q?d6znRsukufYvzwOtZRhdt0nbQ4JWLUD1ou9zJ7z4HvUqeM5+7g9Ef57bbh/a?=
 =?us-ascii?Q?E4dxqfo6yt/5ZR9BDpHrSG++Nesj3m7SYwj7dSeqLgTQ/NMb0uhVkJBkC7Cm?=
 =?us-ascii?Q?iwYgh0bavZU9CdSHu2X6nCEnI5lYV4akyGoXaUlhVHqtyJMYn5GNXmaSDQSJ?=
 =?us-ascii?Q?PifP8INIUGP3+bjbDhl0xG3FMy4p6g0iCrD8zh46MwBDEejJo2FE/hFtavWC?=
 =?us-ascii?Q?OaaqWGBig0gHcstLzXi1KfDQs6w9hrwYjQV4O+in154IKwHejuVeMBk+74+e?=
 =?us-ascii?Q?KaeDgKhuVFSu/3ZYHDO643D57KtiYoxT620VEoP3glIBuocvPTDG0ZRRLdPc?=
 =?us-ascii?Q?ybYHRZj/eipLhTi/19BaWpovF65+yh/L4kp1Jy25j8/GaKHLgXrzivqU5dMx?=
 =?us-ascii?Q?wejjDZlhOnEDp93EwRYUQCVUnI0Wa5rA6PdFJkhaToVorWcqMTv8Oixse6C6?=
 =?us-ascii?Q?gewO+DqcruVH5861nO9ju0ilqoZ9F3MjPdfSZQsmXUMlU/W3lQ0hd3UIT40Q?=
 =?us-ascii?Q?XyYkTeshXE+c50RGNk966RGw8+0aZnqZG2wY8rLCPp53gRh4FwRlkfOWH5YI?=
 =?us-ascii?Q?6qSlAiOA4fodDDRAnbhlNJw9OTBwzZc/YVHJUAGd0TiMvi379n4W41HEgUBR?=
 =?us-ascii?Q?j3fGX5t48QZ5Kidv9+ExwVz90zAPckiGR5k1Wvppt5NXFRbamfcGc9Jkzga5?=
 =?us-ascii?Q?Jka2PA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d4107835-cdf7-4d50-3d94-08d99a9e5bb3
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 05:38:38.9961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61t7m083J5MzlISJLyWQpGgLJcpeWnXrNT93PDHO/tt5ytPOosunz0oUDs29sBDm8dJpmd/7wu+R0NsY0uF90jdmwr/9qojn1n6wtSLzos8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Add firmware (FW) version 4.0 support for Marvell Prestera
driver.

Major changes have been made to new v4.0 FW ABI to add support
of new features, introduce the stability of the FW ABI and ensure
better forward compatibility for the future driver vesrions.

Current v4.0 FW feature set support does not expect any changes
to ABI, as it was defined and tested through long period of time.
The ABI may be extended in case of new features, but it will not
break the backward compatibility.

ABI major changes done in v4.0:
- L1 ABI, where MAC and PHY API configuration are split.
- ACL has been split to low-level TCAM and Counters ABI
  to provide more HW ACL capabilities for future driver
  versions.

To support backward support, the addition compatibility layer is
required in the driver which will have two different codebase under
"if FW-VER elif FW-VER else" conditions that will be removed
in the future anyway, So, the idea was to break backward support
and focus on more stable FW instead of supporting old version
with very minimal and limited set of features/capabilities.

Improve FW msg validation:
 * Use __le64, __le32, __le16 types in msg to/from FW to
   catch endian mismatch by sparse.
 * Use BUILD_BUG_ON for structures sent/recv to/from FW.

Co-developed-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

Changes in V2:

 * Fix sparse errors:
   warning: no previous prototype for function 'prestera_hw_port_state_set' [-Wmissing-prototypes]
   int prestera_hw_port_state_set(const struct prestera_port *port,
       ^

Changes in V3:

 * Clarify commit message description according
   to discussion with Andrew.

Changes in V4:

 * Fix structure laid out in prestera.h
 * Use __le64, __le32, __le16 types in msg to/from FW to
   catch endian mismatch by sparse.
 * Use BUILD_BUG_ON for structures sent/recv to/from FW.
 * Removed redundant TODOs.

 drivers/net/ethernet/marvell/prestera/prestera.h   |   69 +-
 .../ethernet/marvell/prestera/prestera_ethtool.c   |  219 ++--
 .../ethernet/marvell/prestera/prestera_ethtool.h   |    6 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 1064 ++++++++++----------
 .../net/ethernet/marvell/prestera/prestera_hw.h    |   47 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |  144 ++-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |  114 ++-
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |    7 -
 8 files changed, 951 insertions(+), 719 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index f18fe664b373..2a4c14c704c0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -53,6 +53,8 @@ struct prestera_port_stats {
 	u64 good_octets_sent;
 };
 
+#define PRESTERA_AP_PORT_MAX   (10)
+
 struct prestera_port_caps {
 	u64 supp_link_modes;
 	u8 supp_fec;
@@ -69,6 +71,39 @@ struct prestera_lag {
 
 struct prestera_flow_block;
 
+struct prestera_port_mac_state {
+	u32 mode;
+	u32 speed;
+	bool oper;
+	u8 duplex;
+	u8 fc;
+	u8 fec;
+};
+
+struct prestera_port_phy_state {
+	u64 lmode_bmap;
+	struct {
+		bool pause;
+		bool asym_pause;
+	} remote_fc;
+	u8 mdix;
+};
+
+struct prestera_port_mac_config {
+	u32 mode;
+	u32 speed;
+	bool admin;
+	u8 inband;
+	u8 duplex;
+	u8 fec;
+};
+
+struct prestera_port_phy_config {
+	u32 mode;
+	bool admin;
+	u8 mdix;
+};
+
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
@@ -91,6 +126,10 @@ struct prestera_port {
 		struct prestera_port_stats stats;
 		struct delayed_work caching_dw;
 	} cached_hw_stats;
+	struct prestera_port_mac_config cfg_mac;
+	struct prestera_port_phy_config cfg_phy;
+	struct prestera_port_mac_state state_mac;
+	struct prestera_port_phy_state state_phy;
 };
 
 struct prestera_device {
@@ -107,7 +146,7 @@ struct prestera_device {
 	int (*recv_msg)(struct prestera_device *dev, void *msg, size_t size);
 
 	/* called by higher layer to send request to the firmware */
-	int (*send_req)(struct prestera_device *dev, void *in_msg,
+	int (*send_req)(struct prestera_device *dev, int qid, void *in_msg,
 			size_t in_size, void *out_msg, size_t out_size,
 			unsigned int wait);
 };
@@ -129,13 +168,28 @@ enum prestera_rxtx_event_id {
 
 enum prestera_port_event_id {
 	PRESTERA_PORT_EVENT_UNSPEC,
-	PRESTERA_PORT_EVENT_STATE_CHANGED,
+	PRESTERA_PORT_EVENT_MAC_STATE_CHANGED,
 };
 
 struct prestera_port_event {
 	u32 port_id;
 	union {
-		u32 oper_state;
+		struct {
+			u32 mode;
+			u32 speed;
+			u8 oper;
+			u8 duplex;
+			u8 fc;
+			u8 fec;
+		} mac;
+		struct {
+			u64 lmode_bmap;
+			struct {
+				bool pause;
+				bool asym_pause;
+			} remote_fc;
+			u8 mdix;
+		} phy;
 	} data;
 };
 
@@ -223,11 +277,16 @@ void prestera_device_unregister(struct prestera_device *dev);
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id);
 
-int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
-			      u64 adver_link_modes, u8 adver_fec);
+int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes);
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
+int prestera_port_cfg_mac_read(struct prestera_port *port,
+			       struct prestera_port_mac_config *cfg);
+
+int prestera_port_cfg_mac_write(struct prestera_port *port,
+				struct prestera_port_mac_config *cfg);
+
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 93a5e2baf808..6011454dba71 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -323,7 +323,6 @@ static int prestera_port_type_set(const struct ethtool_link_ksettings *ecmd,
 {
 	u32 new_mode = PRESTERA_LINK_MODE_MAX;
 	u32 type, mode;
-	int err;
 
 	for (type = 0; type < PRESTERA_PORT_TYPE_MAX; type++) {
 		if (port_types[type].eth_type == ecmd->base.port &&
@@ -348,13 +347,8 @@ static int prestera_port_type_set(const struct ethtool_link_ksettings *ecmd,
 		}
 	}
 
-	if (new_mode < PRESTERA_LINK_MODE_MAX)
-		err = prestera_hw_port_link_mode_set(port, new_mode);
-	else
-		err = -EINVAL;
-
-	if (err)
-		return err;
+	if (new_mode >= PRESTERA_LINK_MODE_MAX)
+		return -EINVAL;
 
 	port->caps.type = type;
 	port->autoneg = false;
@@ -434,27 +428,33 @@ static void prestera_port_supp_types_get(struct ethtool_link_ksettings *ecmd,
 static void prestera_port_remote_cap_get(struct ethtool_link_ksettings *ecmd,
 					 struct prestera_port *port)
 {
+	struct prestera_port_phy_state *state = &port->state_phy;
 	bool asym_pause;
 	bool pause;
 	u64 bitmap;
 	int err;
 
-	err = prestera_hw_port_remote_cap_get(port, &bitmap);
-	if (!err) {
-		prestera_modes_to_eth(ecmd->link_modes.lp_advertising,
-				      bitmap, 0, PRESTERA_PORT_TYPE_NONE);
+	err = prestera_hw_port_phy_mode_get(port, NULL, &state->lmode_bmap,
+					    &state->remote_fc.pause,
+					    &state->remote_fc.asym_pause);
+	if (err)
+		netdev_warn(port->dev, "Remote link caps get failed %d",
+			    port->caps.transceiver);
 
-		if (!bitmap_empty(ecmd->link_modes.lp_advertising,
-				  __ETHTOOL_LINK_MODE_MASK_NBITS)) {
-			ethtool_link_ksettings_add_link_mode(ecmd,
-							     lp_advertising,
-							     Autoneg);
-		}
+	bitmap = state->lmode_bmap;
+
+	prestera_modes_to_eth(ecmd->link_modes.lp_advertising,
+			      bitmap, 0, PRESTERA_PORT_TYPE_NONE);
+
+	if (!bitmap_empty(ecmd->link_modes.lp_advertising,
+			  __ETHTOOL_LINK_MODE_MASK_NBITS)) {
+		ethtool_link_ksettings_add_link_mode(ecmd,
+						     lp_advertising,
+						     Autoneg);
 	}
 
-	err = prestera_hw_port_remote_fc_get(port, &pause, &asym_pause);
-	if (err)
-		return;
+	pause = state->remote_fc.pause;
+	asym_pause = state->remote_fc.asym_pause;
 
 	if (pause)
 		ethtool_link_ksettings_add_link_mode(ecmd,
@@ -466,30 +466,46 @@ static void prestera_port_remote_cap_get(struct ethtool_link_ksettings *ecmd,
 						     Asym_Pause);
 }
 
-static void prestera_port_speed_get(struct ethtool_link_ksettings *ecmd,
-				    struct prestera_port *port)
+static void prestera_port_link_mode_get(struct ethtool_link_ksettings *ecmd,
+					struct prestera_port *port)
 {
+	struct prestera_port_mac_state *state = &port->state_mac;
 	u32 speed;
+	u8 duplex;
 	int err;
 
-	err = prestera_hw_port_speed_get(port, &speed);
-	ecmd->base.speed = err ? SPEED_UNKNOWN : speed;
+	if (!port->state_mac.oper)
+		return;
+
+	if (state->speed == SPEED_UNKNOWN || state->duplex == DUPLEX_UNKNOWN) {
+		err = prestera_hw_port_mac_mode_get(port, NULL, &speed,
+						    &duplex, NULL);
+		if (err) {
+			state->speed = SPEED_UNKNOWN;
+			state->duplex = DUPLEX_UNKNOWN;
+		} else {
+			state->speed = speed;
+			state->duplex = duplex == PRESTERA_PORT_DUPLEX_FULL ?
+					  DUPLEX_FULL : DUPLEX_HALF;
+		}
+	}
+
+	ecmd->base.speed = port->state_mac.speed;
+	ecmd->base.duplex = port->state_mac.duplex;
 }
 
-static void prestera_port_duplex_get(struct ethtool_link_ksettings *ecmd,
-				     struct prestera_port *port)
+static void prestera_port_mdix_get(struct ethtool_link_ksettings *ecmd,
+				   struct prestera_port *port)
 {
-	u8 duplex;
-	int err;
+	struct prestera_port_phy_state *state = &port->state_phy;
 
-	err = prestera_hw_port_duplex_get(port, &duplex);
-	if (err) {
-		ecmd->base.duplex = DUPLEX_UNKNOWN;
-		return;
+	if (prestera_hw_port_phy_mode_get(port, &state->mdix, NULL, NULL, NULL)) {
+		netdev_warn(port->dev, "MDIX params get failed");
+		state->mdix = ETH_TP_MDI_INVALID;
 	}
 
-	ecmd->base.duplex = duplex == PRESTERA_PORT_DUPLEX_FULL ?
-			    DUPLEX_FULL : DUPLEX_HALF;
+	ecmd->base.eth_tp_mdix = port->state_phy.mdix;
+	ecmd->base.eth_tp_mdix_ctrl = port->cfg_phy.mdix;
 }
 
 static int
@@ -501,6 +517,8 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 	ethtool_link_ksettings_zero_link_mode(ecmd, supported);
 	ethtool_link_ksettings_zero_link_mode(ecmd, advertising);
 	ethtool_link_ksettings_zero_link_mode(ecmd, lp_advertising);
+	ecmd->base.speed = SPEED_UNKNOWN;
+	ecmd->base.duplex = DUPLEX_UNKNOWN;
 
 	ecmd->base.autoneg = port->autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 
@@ -521,13 +539,8 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 
 	prestera_port_supp_types_get(ecmd, port);
 
-	if (netif_carrier_ok(dev)) {
-		prestera_port_speed_get(ecmd, port);
-		prestera_port_duplex_get(ecmd, port);
-	} else {
-		ecmd->base.speed = SPEED_UNKNOWN;
-		ecmd->base.duplex = DUPLEX_UNKNOWN;
-	}
+	if (netif_carrier_ok(dev))
+		prestera_port_link_mode_get(ecmd, port);
 
 	ecmd->base.port = prestera_port_type_get(port);
 
@@ -545,8 +558,7 @@ prestera_ethtool_get_link_ksettings(struct net_device *dev,
 
 	if (port->caps.type == PRESTERA_PORT_TYPE_TP &&
 	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER)
-		prestera_hw_port_mdix_get(port, &ecmd->base.eth_tp_mdix,
-					  &ecmd->base.eth_tp_mdix_ctrl);
+		prestera_port_mdix_get(ecmd, port);
 
 	return 0;
 }
@@ -555,12 +567,17 @@ static int prestera_port_mdix_set(const struct ethtool_link_ksettings *ecmd,
 				  struct prestera_port *port)
 {
 	if (ecmd->base.eth_tp_mdix_ctrl != ETH_TP_MDI_INVALID &&
-	    port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER &&
-	    port->caps.type == PRESTERA_PORT_TYPE_TP)
-		return prestera_hw_port_mdix_set(port,
-						 ecmd->base.eth_tp_mdix_ctrl);
-
+	    port->caps.transceiver ==  PRESTERA_PORT_TCVR_COPPER &&
+	    port->caps.type == PRESTERA_PORT_TYPE_TP) {
+		port->cfg_phy.mdix = ecmd->base.eth_tp_mdix_ctrl;
+		return prestera_hw_port_phy_mode_set(port, port->cfg_phy.admin,
+						     port->autoneg,
+						     port->cfg_phy.mode,
+						     port->adver_link_modes,
+						     port->cfg_phy.mdix);
+	}
 	return 0;
+
 }
 
 static int prestera_port_link_mode_set(struct prestera_port *port,
@@ -568,12 +585,15 @@ static int prestera_port_link_mode_set(struct prestera_port *port,
 {
 	u32 new_mode = PRESTERA_LINK_MODE_MAX;
 	u32 mode;
+	int err;
 
 	for (mode = 0; mode < PRESTERA_LINK_MODE_MAX; mode++) {
-		if (speed != port_link_modes[mode].speed)
+		if (speed != SPEED_UNKNOWN &&
+		    speed != port_link_modes[mode].speed)
 			continue;
 
-		if (duplex != port_link_modes[mode].duplex)
+		if (duplex != DUPLEX_UNKNOWN &&
+		    duplex != port_link_modes[mode].duplex)
 			continue;
 
 		if (!(port_link_modes[mode].pr_mask &
@@ -590,36 +610,31 @@ static int prestera_port_link_mode_set(struct prestera_port *port,
 	if (new_mode == PRESTERA_LINK_MODE_MAX)
 		return -EOPNOTSUPP;
 
-	return prestera_hw_port_link_mode_set(port, new_mode);
+	err = prestera_hw_port_phy_mode_set(port, port->cfg_phy.admin,
+					    false, new_mode, 0,
+					    port->cfg_phy.mdix);
+	if (err)
+		return err;
+
+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
+	port->adver_link_modes = 0;
+	port->cfg_phy.mode = new_mode;
+	port->autoneg = false;
+
+	return 0;
 }
 
 static int
 prestera_port_speed_duplex_set(const struct ethtool_link_ksettings *ecmd,
 			       struct prestera_port *port)
 {
-	u32 curr_mode;
-	u8 duplex;
-	u32 speed;
-	int err;
-
-	err = prestera_hw_port_link_mode_get(port, &curr_mode);
-	if (err)
-		return err;
-	if (curr_mode >= PRESTERA_LINK_MODE_MAX)
-		return -EINVAL;
+	u8 duplex = DUPLEX_UNKNOWN;
 
 	if (ecmd->base.duplex != DUPLEX_UNKNOWN)
 		duplex = ecmd->base.duplex == DUPLEX_FULL ?
 			 PRESTERA_PORT_DUPLEX_FULL : PRESTERA_PORT_DUPLEX_HALF;
-	else
-		duplex = port_link_modes[curr_mode].duplex;
 
-	if (ecmd->base.speed != SPEED_UNKNOWN)
-		speed = ecmd->base.speed;
-	else
-		speed = port_link_modes[curr_mode].speed;
-
-	return prestera_port_link_mode_set(port, speed, duplex,
+	return prestera_port_link_mode_set(port, ecmd->base.speed, duplex,
 					   port->caps.type);
 }
 
@@ -645,19 +660,12 @@ prestera_ethtool_set_link_ksettings(struct net_device *dev,
 	prestera_modes_from_eth(ecmd->link_modes.advertising, &adver_modes,
 				&adver_fec, port->caps.type);
 
-	err = prestera_port_autoneg_set(port,
-					ecmd->base.autoneg == AUTONEG_ENABLE,
-					adver_modes, adver_fec);
-	if (err)
-		return err;
-
-	if (ecmd->base.autoneg == AUTONEG_DISABLE) {
+	if (ecmd->base.autoneg == AUTONEG_ENABLE)
+		err = prestera_port_autoneg_set(port, adver_modes);
+	else
 		err = prestera_port_speed_duplex_set(ecmd, port);
-		if (err)
-			return err;
-	}
 
-	return 0;
+	return err;
 }
 
 static int prestera_ethtool_get_fecparam(struct net_device *dev,
@@ -668,7 +676,7 @@ static int prestera_ethtool_get_fecparam(struct net_device *dev,
 	u32 mode;
 	int err;
 
-	err = prestera_hw_port_fec_get(port, &active);
+	err = prestera_hw_port_mac_mode_get(port, NULL, NULL, NULL, &active);
 	if (err)
 		return err;
 
@@ -693,18 +701,19 @@ static int prestera_ethtool_set_fecparam(struct net_device *dev,
 					 struct ethtool_fecparam *fecparam)
 {
 	struct prestera_port *port = netdev_priv(dev);
-	u8 fec, active;
+	struct prestera_port_mac_config cfg_mac;
 	u32 mode;
-	int err;
+	u8 fec;
 
 	if (port->autoneg) {
 		netdev_err(dev, "FEC set is not allowed while autoneg is on\n");
 		return -EINVAL;
 	}
 
-	err = prestera_hw_port_fec_get(port, &active);
-	if (err)
-		return err;
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+		netdev_err(dev, "FEC set is not allowed on non-SFP ports\n");
+		return -EINVAL;
+	}
 
 	fec = PRESTERA_PORT_FEC_MAX;
 	for (mode = 0; mode < PRESTERA_PORT_FEC_MAX; mode++) {
@@ -715,13 +724,19 @@ static int prestera_ethtool_set_fecparam(struct net_device *dev,
 		}
 	}
 
-	if (fec == active)
+	prestera_port_cfg_mac_read(port, &cfg_mac);
+
+	if (fec == cfg_mac.fec)
 		return 0;
 
-	if (fec == PRESTERA_PORT_FEC_MAX)
-		return -EOPNOTSUPP;
+	if (fec == PRESTERA_PORT_FEC_MAX) {
+		netdev_err(dev, "Unsupported FEC requested");
+		return -EINVAL;
+	}
+
+	cfg_mac.fec = fec;
 
-	return prestera_hw_port_fec_set(port, fec);
+	return prestera_port_cfg_mac_write(port, &cfg_mac);
 }
 
 static int prestera_ethtool_get_sset_count(struct net_device *dev, int sset)
@@ -766,6 +781,28 @@ static int prestera_ethtool_nway_reset(struct net_device *dev)
 	return -EINVAL;
 }
 
+void prestera_ethtool_port_state_changed(struct prestera_port *port,
+					 struct prestera_port_event *evt)
+{
+	struct prestera_port_mac_state *smac = &port->state_mac;
+
+	smac->oper = evt->data.mac.oper;
+
+	if (smac->oper) {
+		smac->mode = evt->data.mac.mode;
+		smac->speed = evt->data.mac.speed;
+		smac->duplex = evt->data.mac.duplex;
+		smac->fc = evt->data.mac.fc;
+		smac->fec = evt->data.mac.fec;
+	} else {
+		smac->mode = PRESTERA_MAC_MODE_MAX;
+		smac->speed = SPEED_UNKNOWN;
+		smac->duplex = DUPLEX_UNKNOWN;
+		smac->fc = 0;
+		smac->fec = 0;
+	}
+}
+
 const struct ethtool_ops prestera_ethtool_ops = {
 	.get_drvinfo = prestera_ethtool_get_drvinfo,
 	.get_link_ksettings = prestera_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
index 523ef1f592ce..9eb18e99dea6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
@@ -6,6 +6,12 @@
 
 #include <linux/ethtool.h>
 
+struct prestera_port_event;
+struct prestera_port;
+
 extern const struct ethtool_ops prestera_ethtool_ops;
 
+void prestera_ethtool_port_state_changed(struct prestera_port *port,
+					 struct prestera_port_event *evt);
+
 #endif /* _PRESTERA_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index c1297859e471..41ba17cb2965 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -47,7 +47,6 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_ACL_PORT_UNBIND = 0x531,
 
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
-	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
 	PRESTERA_CMD_TYPE_LAG_MEMBER_DELETE = 0x901,
@@ -76,16 +75,12 @@ enum {
 	PRESTERA_CMD_PORT_ATTR_LEARNING = 7,
 	PRESTERA_CMD_PORT_ATTR_FLOOD = 8,
 	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
-	PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY = 10,
-	PRESTERA_CMD_PORT_ATTR_REMOTE_FC = 11,
-	PRESTERA_CMD_PORT_ATTR_LINK_MODE = 12,
+	PRESTERA_CMD_PORT_ATTR_PHY_MODE = 12,
 	PRESTERA_CMD_PORT_ATTR_TYPE = 13,
-	PRESTERA_CMD_PORT_ATTR_FEC = 14,
-	PRESTERA_CMD_PORT_ATTR_AUTONEG = 15,
-	PRESTERA_CMD_PORT_ATTR_DUPLEX = 16,
 	PRESTERA_CMD_PORT_ATTR_STATS = 17,
-	PRESTERA_CMD_PORT_ATTR_MDIX = 18,
-	PRESTERA_CMD_PORT_ATTR_AUTONEG_RESTART = 19,
+	PRESTERA_CMD_PORT_ATTR_MAC_AUTONEG_RESTART = 18,
+	PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART = 19,
+	PRESTERA_CMD_PORT_ATTR_MAC_MODE = 22,
 };
 
 enum {
@@ -169,12 +164,12 @@ struct prestera_fw_event_handler {
 };
 
 struct prestera_msg_cmd {
-	u32 type;
+	__le32 type;
 };
 
 struct prestera_msg_ret {
 	struct prestera_msg_cmd cmd;
-	u32 status;
+	__le32 status;
 };
 
 struct prestera_msg_common_req {
@@ -187,102 +182,144 @@ struct prestera_msg_common_resp {
 
 union prestera_msg_switch_param {
 	u8 mac[ETH_ALEN];
-	u32 ageing_timeout_ms;
-};
+	__le32 ageing_timeout_ms;
+} __packed;
 
 struct prestera_msg_switch_attr_req {
 	struct prestera_msg_cmd cmd;
-	u32 attr;
+	__le32 attr;
 	union prestera_msg_switch_param param;
 };
 
 struct prestera_msg_switch_init_resp {
 	struct prestera_msg_ret ret;
-	u32 port_count;
-	u32 mtu_max;
+	__le32 port_count;
+	__le32 mtu_max;
 	u8  switch_id;
 	u8  lag_max;
 	u8  lag_member_max;
-};
+	__le32 size_tbl_router_nexthop;
+} __packed __aligned(4);
 
-struct prestera_msg_port_autoneg_param {
-	u64 link_mode;
-	u8  enable;
-	u8  fec;
-};
+struct prestera_msg_event_port_param {
+	union {
+		struct {
+			u8 oper;
+			__le32 mode;
+			__le32 speed;
+			u8 duplex;
+			u8 fc;
+			u8 fec;
+		} __packed mac;
+		struct {
+			u8 mdix;
+			__le64 lmode_bmap;
+			u8 fc;
+		} __packed phy;
+	} __packed;
+} __packed __aligned(4);
 
 struct prestera_msg_port_cap_param {
-	u64 link_mode;
+	__le64 link_mode;
 	u8  type;
 	u8  fec;
+	u8  fc;
 	u8  transceiver;
 };
 
-struct prestera_msg_port_mdix_param {
-	u8 status;
-	u8 admin_mode;
-};
-
 struct prestera_msg_port_flood_param {
 	u8 type;
 	u8 enable;
 };
 
 union prestera_msg_port_param {
-	u8  admin_state;
-	u8  oper_state;
-	u32 mtu;
-	u8  mac[ETH_ALEN];
-	u8  accept_frm_type;
-	u32 speed;
+	u8 admin_state;
+	u8 oper_state;
+	__le32 mtu;
+	u8 mac[ETH_ALEN];
+	u8 accept_frm_type;
+	__le32 speed;
 	u8 learning;
 	u8 flood;
-	u32 link_mode;
-	u8  type;
-	u8  duplex;
-	u8  fec;
-	u8  fc;
-	struct prestera_msg_port_mdix_param mdix;
-	struct prestera_msg_port_autoneg_param autoneg;
+	__le32 link_mode;
+	u8 type;
+	u8 duplex;
+	u8 fec;
+	u8 fc;
+
+	union {
+		struct {
+			u8 admin:1;
+			u8 fc;
+			u8 ap_enable;
+			union {
+				struct {
+					__le32 mode;
+					u8  inband:1;
+					__le32 speed;
+					u8  duplex;
+					u8  fec;
+					u8  fec_supp;
+				} __packed reg_mode;
+				struct {
+					__le32 mode;
+					__le32 speed;
+					u8  fec;
+					u8  fec_supp;
+				} __packed ap_modes[PRESTERA_AP_PORT_MAX];
+			} __packed;
+		} __packed mac;
+		struct {
+			u8 admin:1;
+			u8 adv_enable;
+			__le64 modes;
+			__le32 mode;
+			u8 mdix;
+		} __packed phy;
+	} __packed link;
+
 	struct prestera_msg_port_cap_param cap;
 	struct prestera_msg_port_flood_param flood_ext;
-};
+	struct prestera_msg_event_port_param link_evt;
+} __packed;
 
 struct prestera_msg_port_attr_req {
 	struct prestera_msg_cmd cmd;
-	u32 attr;
-	u32 port;
-	u32 dev;
+	__le32 attr;
+	__le32 port;
+	__le32 dev;
 	union prestera_msg_port_param param;
-};
+} __packed __aligned(4);
+
 
 struct prestera_msg_port_attr_resp {
 	struct prestera_msg_ret ret;
 	union prestera_msg_port_param param;
-};
+} __packed __aligned(4);
+
 
 struct prestera_msg_port_stats_resp {
 	struct prestera_msg_ret ret;
-	u64 stats[PRESTERA_PORT_CNT_MAX];
+	__le64 stats[PRESTERA_PORT_CNT_MAX];
 };
 
 struct prestera_msg_port_info_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
+	__le32 port;
 };
 
 struct prestera_msg_port_info_resp {
 	struct prestera_msg_ret ret;
-	u32 hw_id;
-	u32 dev_id;
-	u16 fp_id;
+	__le32 hw_id;
+	__le32 dev_id;
+	__le16 fp_id;
 };
 
 struct prestera_msg_vlan_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
-	u16 vid;
+	__le32 port;
+	__le32 dev;
+	__le16 vid;
 	u8  is_member;
 	u8  is_tagged;
 };
@@ -292,113 +329,114 @@ struct prestera_msg_fdb_req {
 	u8 dest_type;
 	union {
 		struct {
-			u32 port;
-			u32 dev;
+			__le32 port;
+			__le32 dev;
 		};
-		u16 lag_id;
+		__le16 lag_id;
 	} dest;
 	u8  mac[ETH_ALEN];
-	u16 vid;
+	__le16 vid;
 	u8  dynamic;
-	u32 flush_mode;
-};
+	__le32 flush_mode;
+} __packed __aligned(4);
 
 struct prestera_msg_bridge_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
-	u16 bridge;
+	__le32 port;
+	__le32 dev;
+	__le16 bridge;
 };
 
 struct prestera_msg_bridge_resp {
 	struct prestera_msg_ret ret;
-	u16 bridge;
+	__le16 bridge;
 };
 
 struct prestera_msg_acl_action {
-	u32 id;
+	__le32 id;
+	__le32 reserved[5];
 };
 
 struct prestera_msg_acl_match {
-	u32 type;
+	__le32 type;
 	union {
 		struct {
 			u8 key;
 			u8 mask;
-		} u8;
+		} __packed u8;
 		struct {
-			u16 key;
-			u16 mask;
+			__le16 key;
+			__le16 mask;
 		} u16;
 		struct {
-			u32 key;
-			u32 mask;
+			__le32 key;
+			__le32 mask;
 		} u32;
 		struct {
-			u64 key;
-			u64 mask;
+			__le64 key;
+			__le64 mask;
 		} u64;
 		struct {
 			u8 key[ETH_ALEN];
 			u8 mask[ETH_ALEN];
-		} mac;
-	} __packed keymask;
+		} __packed mac;
+	} keymask;
 };
 
 struct prestera_msg_acl_rule_req {
 	struct prestera_msg_cmd cmd;
-	u32 id;
-	u32 priority;
-	u16 ruleset_id;
+	__le32 id;
+	__le32 priority;
+	__le16 ruleset_id;
 	u8 n_actions;
 	u8 n_matches;
 };
 
 struct prestera_msg_acl_rule_resp {
 	struct prestera_msg_ret ret;
-	u32 id;
+	__le32 id;
 };
 
 struct prestera_msg_acl_rule_stats_resp {
 	struct prestera_msg_ret ret;
-	u64 packets;
-	u64 bytes;
+	__le64 packets;
+	__le64 bytes;
 };
 
 struct prestera_msg_acl_ruleset_bind_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
-	u16 ruleset_id;
+	__le32 port;
+	__le32 dev;
+	__le16 ruleset_id;
 };
 
 struct prestera_msg_acl_ruleset_req {
 	struct prestera_msg_cmd cmd;
-	u16 id;
+	__le16 id;
 };
 
 struct prestera_msg_acl_ruleset_resp {
 	struct prestera_msg_ret ret;
-	u16 id;
+	__le16 id;
 };
 
 struct prestera_msg_span_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
+	__le32 port;
+	__le32 dev;
 	u8 id;
-} __packed __aligned(4);
+};
 
 struct prestera_msg_span_resp {
 	struct prestera_msg_ret ret;
 	u8 id;
-} __packed __aligned(4);
+};
 
 struct prestera_msg_stp_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
-	u16 vid;
+	__le32 port;
+	__le32 dev;
+	__le16 vid;
 	u8  state;
 };
 
@@ -409,20 +447,14 @@ struct prestera_msg_rxtx_req {
 
 struct prestera_msg_rxtx_resp {
 	struct prestera_msg_ret ret;
-	u32 map_addr;
-};
-
-struct prestera_msg_rxtx_port_req {
-	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
+	__le32 map_addr;
 };
 
 struct prestera_msg_lag_req {
 	struct prestera_msg_cmd cmd;
-	u32 port;
-	u32 dev;
-	u16 lag_id;
+	__le32 port;
+	__le32 dev;
+	__le16 lag_id;
 };
 
 struct prestera_msg_cpu_code_counter_req {
@@ -433,22 +465,18 @@ struct prestera_msg_cpu_code_counter_req {
 
 struct mvsw_msg_cpu_code_counter_ret {
 	struct prestera_msg_ret ret;
-	u64 packet_count;
+	__le64 packet_count;
 };
 
 struct prestera_msg_event {
-	u16 type;
-	u16 id;
-};
-
-union prestera_msg_event_port_param {
-	u32 oper_state;
+	__le16 type;
+	__le16 id;
 };
 
 struct prestera_msg_event_port {
 	struct prestera_msg_event id;
-	u32 port_id;
-	union prestera_msg_event_port_param param;
+	__le32 port_id;
+	struct prestera_msg_event_port_param param;
 };
 
 union prestera_msg_event_fdb_param {
@@ -459,12 +487,52 @@ struct prestera_msg_event_fdb {
 	struct prestera_msg_event id;
 	u8 dest_type;
 	union {
-		u32 port_id;
-		u16 lag_id;
+		__le32 port_id;
+		__le16 lag_id;
 	} dest;
-	u32 vid;
+	__le32 vid;
 	union prestera_msg_event_fdb_param param;
-};
+} __packed __aligned(4);
+
+static inline void prestera_hw_build_tests(void)
+{
+	/* check requests */
+	BUILD_BUG_ON(sizeof(struct prestera_msg_common_req) != 4);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_attr_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_req) != 120);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vlan_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_fdb_req) != 28);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_rule_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_ruleset_bind_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_ruleset_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_span_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_stp_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_lag_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_cpu_code_counter_req) != 8);
+
+	/* check responses */
+	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 112);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_stats_resp) != 248);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_resp) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_rule_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_rule_stats_resp) != 24);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_ruleset_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_span_resp) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
+
+	/* check events */
+	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_event_fdb) != 20);
+}
+
+static u8 prestera_hw_mdix_to_eth(u8 mode);
+static void prestera_hw_remote_fc_to_eth(u8 fc, bool *pause, bool *asym_pause);
 
 static int __prestera_cmd_ret(struct prestera_switch *sw,
 			      enum prestera_cmd_type_t type,
@@ -475,15 +543,15 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
 	struct prestera_device *dev = sw->dev;
 	int err;
 
-	cmd->type = type;
+	cmd->type = __cpu_to_le32(type);
 
-	err = dev->send_req(dev, cmd, clen, ret, rlen, waitms);
+	err = dev->send_req(dev, 0, cmd, clen, ret, rlen, waitms);
 	if (err)
 		return err;
 
-	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
+	if (__le32_to_cpu(ret->cmd.type) != PRESTERA_CMD_TYPE_ACK)
 		return -EBADE;
-	if (ret->status != PRESTERA_CMD_ACK_OK)
+	if (__le32_to_cpu(ret->status) != PRESTERA_CMD_ACK_OK)
 		return -EINVAL;
 
 	return 0;
@@ -517,13 +585,24 @@ static int prestera_cmd(struct prestera_switch *sw,
 
 static int prestera_fw_parse_port_evt(void *msg, struct prestera_event *evt)
 {
-	struct prestera_msg_event_port *hw_evt = msg;
+	struct prestera_msg_event_port *hw_evt;
 
-	if (evt->id != PRESTERA_PORT_EVENT_STATE_CHANGED)
-		return -EINVAL;
+	hw_evt = (struct prestera_msg_event_port *)msg;
 
-	evt->port_evt.data.oper_state = hw_evt->param.oper_state;
-	evt->port_evt.port_id = hw_evt->port_id;
+	evt->port_evt.port_id = __le32_to_cpu(hw_evt->port_id);
+
+	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
+		evt->port_evt.data.mac.oper = hw_evt->param.mac.oper;
+		evt->port_evt.data.mac.mode =
+			__le32_to_cpu(hw_evt->param.mac.mode);
+		evt->port_evt.data.mac.speed =
+			__le32_to_cpu(hw_evt->param.mac.speed);
+		evt->port_evt.data.mac.duplex = hw_evt->param.mac.duplex;
+		evt->port_evt.data.mac.fc = hw_evt->param.mac.fc;
+		evt->port_evt.data.mac.fec = hw_evt->param.mac.fec;
+	} else {
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -535,17 +614,17 @@ static int prestera_fw_parse_fdb_evt(void *msg, struct prestera_event *evt)
 	switch (hw_evt->dest_type) {
 	case PRESTERA_HW_FDB_ENTRY_TYPE_REG_PORT:
 		evt->fdb_evt.type = PRESTERA_FDB_ENTRY_TYPE_REG_PORT;
-		evt->fdb_evt.dest.port_id = hw_evt->dest.port_id;
+		evt->fdb_evt.dest.port_id = __le32_to_cpu(hw_evt->dest.port_id);
 		break;
 	case PRESTERA_HW_FDB_ENTRY_TYPE_LAG:
 		evt->fdb_evt.type = PRESTERA_FDB_ENTRY_TYPE_LAG;
-		evt->fdb_evt.dest.lag_id = hw_evt->dest.lag_id;
+		evt->fdb_evt.dest.lag_id = __le16_to_cpu(hw_evt->dest.lag_id);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	evt->fdb_evt.vid = hw_evt->vid;
+	evt->fdb_evt.vid = __le32_to_cpu(hw_evt->vid);
 
 	ether_addr_copy(evt->fdb_evt.data.mac, hw_evt->param.mac);
 
@@ -597,20 +676,22 @@ static int prestera_evt_recv(struct prestera_device *dev, void *buf, size_t size
 	struct prestera_msg_event *msg = buf;
 	struct prestera_fw_event_handler eh;
 	struct prestera_event evt;
+	u16 msg_type;
 	int err;
 
-	if (msg->type >= PRESTERA_EVENT_TYPE_MAX)
+	msg_type = __le16_to_cpu(msg->type);
+	if (msg_type >= PRESTERA_EVENT_TYPE_MAX)
 		return -EINVAL;
-	if (!fw_event_parsers[msg->type].func)
+	if (!fw_event_parsers[msg_type].func)
 		return -ENOENT;
 
-	err = prestera_find_event_handler(sw, msg->type, &eh);
+	err = prestera_find_event_handler(sw, msg_type, &eh);
 	if (err)
 		return err;
 
-	evt.id = msg->id;
+	evt.id = __le16_to_cpu(msg->id);
 
-	err = fw_event_parsers[msg->type].func(buf, &evt);
+	err = fw_event_parsers[msg_type].func(buf, &evt);
 	if (err)
 		return err;
 
@@ -635,11 +716,39 @@ static void prestera_pkt_recv(struct prestera_device *dev)
 	eh.func(sw, &ev, eh.arg);
 }
 
+static u8 prestera_hw_mdix_to_eth(u8 mode)
+{
+	switch (mode) {
+	case PRESTERA_PORT_TP_MDI:
+		return ETH_TP_MDI;
+	case PRESTERA_PORT_TP_MDIX:
+		return ETH_TP_MDI_X;
+	case PRESTERA_PORT_TP_AUTO:
+		return ETH_TP_MDI_AUTO;
+	default:
+		return ETH_TP_MDI_INVALID;
+	}
+}
+
+static u8 prestera_hw_mdix_from_eth(u8 mode)
+{
+	switch (mode) {
+	case ETH_TP_MDI:
+		return PRESTERA_PORT_TP_MDI;
+	case ETH_TP_MDI_X:
+		return PRESTERA_PORT_TP_MDIX;
+	case ETH_TP_MDI_AUTO:
+		return PRESTERA_PORT_TP_AUTO;
+	default:
+		return PRESTERA_PORT_TP_NA;
+	}
+}
+
 int prestera_hw_port_info_get(const struct prestera_port *port,
 			      u32 *dev_id, u32 *hw_id, u16 *fp_id)
 {
 	struct prestera_msg_port_info_req req = {
-		.port = port->id,
+		.port = __cpu_to_le32(port->id),
 	};
 	struct prestera_msg_port_info_resp resp;
 	int err;
@@ -649,9 +758,9 @@ int prestera_hw_port_info_get(const struct prestera_port *port,
 	if (err)
 		return err;
 
-	*dev_id = resp.dev_id;
-	*hw_id = resp.hw_id;
-	*fp_id = resp.fp_id;
+	*dev_id = __le32_to_cpu(resp.dev_id);
+	*hw_id = __le32_to_cpu(resp.hw_id);
+	*fp_id = __le16_to_cpu(resp.fp_id);
 
 	return 0;
 }
@@ -659,7 +768,7 @@ int prestera_hw_port_info_get(const struct prestera_port *port,
 int prestera_hw_switch_mac_set(struct prestera_switch *sw, const char *mac)
 {
 	struct prestera_msg_switch_attr_req req = {
-		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
+		.attr = __cpu_to_le32(PRESTERA_CMD_SWITCH_ATTR_MAC),
 	};
 
 	ether_addr_copy(req.param.mac, mac);
@@ -676,6 +785,8 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 
 	INIT_LIST_HEAD(&sw->event_handlers);
 
+	prestera_hw_build_tests();
+
 	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
 				    &req.cmd, sizeof(req),
 				    &resp.ret, sizeof(resp),
@@ -685,9 +796,9 @@ int prestera_hw_switch_init(struct prestera_switch *sw)
 
 	sw->dev->recv_msg = prestera_evt_recv;
 	sw->dev->recv_pkt = prestera_pkt_recv;
-	sw->port_count = resp.port_count;
+	sw->port_count = __le32_to_cpu(resp.port_count);
 	sw->mtu_min = PRESTERA_MIN_MTU;
-	sw->mtu_max = resp.mtu_max;
+	sw->mtu_max = __le32_to_cpu(resp.mtu_max);
 	sw->id = resp.switch_id;
 	sw->lag_member_max = resp.lag_member_max;
 	sw->lag_max = resp.lag_max;
@@ -703,9 +814,9 @@ void prestera_hw_switch_fini(struct prestera_switch *sw)
 int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing_ms)
 {
 	struct prestera_msg_switch_attr_req req = {
-		.attr = PRESTERA_CMD_SWITCH_ATTR_AGEING,
+		.attr = __cpu_to_le32(PRESTERA_CMD_SWITCH_ATTR_AGEING),
 		.param = {
-			.ageing_timeout_ms = ageing_ms,
+			.ageing_timeout_ms = __cpu_to_le32(ageing_ms),
 		},
 	};
 
@@ -713,15 +824,56 @@ int prestera_hw_switch_ageing_set(struct prestera_switch *sw, u32 ageing_ms)
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_state_set(const struct prestera_port *port,
-			       bool admin_state)
+int prestera_hw_port_mac_mode_get(const struct prestera_port *port,
+				  u32 *mode, u32 *speed, u8 *duplex, u8 *fec)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_MAC_MODE),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id)
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	if (mode)
+		*mode = __le32_to_cpu(resp.param.link_evt.mac.mode);
+
+	if (speed)
+		*speed = __le32_to_cpu(resp.param.link_evt.mac.speed);
+
+	if (duplex)
+		*duplex = resp.param.link_evt.mac.duplex;
+
+	if (fec)
+		*fec = resp.param.link_evt.mac.fec;
+
+	return err;
+}
+
+int prestera_hw_port_mac_mode_set(const struct prestera_port *port,
+				  bool admin, u32 mode, u8 inband,
+				  u32 speed, u8 duplex, u8 fec)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_MAC_MODE),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
-			.admin_state = admin_state,
+			.link = {
+				.mac = {
+					.admin = admin,
+					.reg_mode.mode = __cpu_to_le32(mode),
+					.reg_mode.inband = inband,
+					.reg_mode.speed = __cpu_to_le32(speed),
+					.reg_mode.duplex = duplex,
+					.reg_mode.fec = fec
+				}
+			}
 		}
 	};
 
@@ -729,14 +881,70 @@ int prestera_hw_port_state_set(const struct prestera_port *port,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_phy_mode_get(const struct prestera_port *port,
+				  u8 *mdix, u64 *lmode_bmap,
+				  bool *fc_pause, bool *fc_asym)
+{
+	struct prestera_msg_port_attr_resp resp;
+	struct prestera_msg_port_attr_req req = {
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_MODE),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id)
+	};
+	int err;
+
+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	if (mdix)
+		*mdix = prestera_hw_mdix_to_eth(resp.param.link_evt.phy.mdix);
+
+	if (lmode_bmap)
+		*lmode_bmap = __le64_to_cpu(resp.param.link_evt.phy.lmode_bmap);
+
+	if (fc_pause && fc_asym)
+		prestera_hw_remote_fc_to_eth(resp.param.link_evt.phy.fc,
+					     fc_pause, fc_asym);
+
+	return err;
+}
+
+int prestera_hw_port_phy_mode_set(const struct prestera_port *port,
+				  bool admin, bool adv, u32 mode, u64 modes,
+				  u8 mdix)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_MODE),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.param = {
+			.link = {
+				.phy = {
+					.admin = admin,
+					.adv_enable = adv ? 1 : 0,
+					.mode = __cpu_to_le32(mode),
+					.modes = __cpu_to_le64(modes),
+				}
+			}
+		}
+	};
+
+	req.param.link.phy.mdix = prestera_hw_mdix_from_eth(mdix);
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_MTU,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_MTU),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
-			.mtu = mtu,
+			.mtu = __cpu_to_le32(mtu),
 		}
 	};
 
@@ -747,9 +955,9 @@ int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
 int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_MAC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_MAC),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 
 	ether_addr_copy(req.param.mac, mac);
@@ -762,9 +970,9 @@ int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_ACCEPT_FRAME_TYPE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_ACCEPT_FRAME_TYPE),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
 			.accept_frm_type = type,
 		}
@@ -778,9 +986,9 @@ int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_CAPABILITY),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 	struct prestera_msg_port_attr_resp resp;
 	int err;
@@ -790,7 +998,7 @@ int prestera_hw_port_cap_get(const struct prestera_port *port,
 	if (err)
 		return err;
 
-	caps->supp_link_modes = resp.param.cap.link_mode;
+	caps->supp_link_modes = __le64_to_cpu(resp.param.cap.link_mode);
 	caps->transceiver = resp.param.cap.transceiver;
 	caps->supp_fec = resp.param.cap.fec;
 	caps->type = resp.param.cap.type;
@@ -798,44 +1006,9 @@ int prestera_hw_port_cap_get(const struct prestera_port *port,
 	return err;
 }
 
-int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
-				    u64 *link_mode_bitmap)
+static void prestera_hw_remote_fc_to_eth(u8 fc, bool *pause, bool *asym_pause)
 {
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*link_mode_bitmap = resp.param.cap.link_mode;
-
-	return 0;
-}
-
-int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
-				   bool *pause, bool *asym_pause)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_REMOTE_FC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	switch (resp.param.fc) {
+	switch (fc) {
 	case PRESTERA_FC_SYMMETRIC:
 		*pause = true;
 		*asym_pause = false;
@@ -852,8 +1025,6 @@ int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
 		*pause = false;
 		*asym_pause = false;
 	}
-
-	return 0;
 }
 
 int prestera_hw_acl_ruleset_create(struct prestera_switch *sw, u16 *ruleset_id)
@@ -867,7 +1038,7 @@ int prestera_hw_acl_ruleset_create(struct prestera_switch *sw, u16 *ruleset_id)
 	if (err)
 		return err;
 
-	*ruleset_id = resp.id;
+	*ruleset_id = __le16_to_cpu(resp.id);
 
 	return 0;
 }
@@ -875,7 +1046,7 @@ int prestera_hw_acl_ruleset_create(struct prestera_switch *sw, u16 *ruleset_id)
 int prestera_hw_acl_ruleset_del(struct prestera_switch *sw, u16 ruleset_id)
 {
 	struct prestera_msg_acl_ruleset_req req = {
-		.id = ruleset_id,
+		.id = __cpu_to_le16(ruleset_id),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ACL_RULESET_DELETE,
@@ -890,7 +1061,7 @@ static int prestera_hw_acl_actions_put(struct prestera_msg_acl_action *action,
 	int i = 0;
 
 	list_for_each_entry(a_entry, a_list, list) {
-		action[i].id = a_entry->id;
+		action[i].id = __cpu_to_le32(a_entry->id);
 
 		switch (a_entry->id) {
 		case PRESTERA_ACL_RULE_ACTION_ACCEPT:
@@ -916,7 +1087,7 @@ static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 	int i = 0;
 
 	list_for_each_entry(m_entry, m_list, list) {
-		match[i].type = m_entry->type;
+		match[i].type = __cpu_to_le32(m_entry->type);
 
 		switch (m_entry->type) {
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ETH_TYPE:
@@ -924,8 +1095,10 @@ static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_DST:
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_ID:
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_VLAN_TPID:
-			match[i].keymask.u16.key = m_entry->keymask.u16.key;
-			match[i].keymask.u16.mask = m_entry->keymask.u16.mask;
+			match[i].keymask.u16.key =
+				__cpu_to_le16(m_entry->keymask.u16.key);
+			match[i].keymask.u16.mask =
+				__cpu_to_le16(m_entry->keymask.u16.mask);
 			break;
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_TYPE:
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_ICMP_CODE:
@@ -946,12 +1119,16 @@ static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_IP_DST:
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_SRC:
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_L4_PORT_RANGE_DST:
-			match[i].keymask.u32.key = m_entry->keymask.u32.key;
-			match[i].keymask.u32.mask = m_entry->keymask.u32.mask;
+			match[i].keymask.u32.key =
+				__cpu_to_le32(m_entry->keymask.u32.key);
+			match[i].keymask.u32.mask =
+				__cpu_to_le32(m_entry->keymask.u32.mask);
 			break;
 		case PRESTERA_ACL_RULE_MATCH_ENTRY_TYPE_PORT:
-			match[i].keymask.u64.key = m_entry->keymask.u64.key;
-			match[i].keymask.u64.mask = m_entry->keymask.u64.mask;
+			match[i].keymask.u64.key =
+				__cpu_to_le64(m_entry->keymask.u64.key);
+			match[i].keymask.u64.mask =
+				__cpu_to_le64(m_entry->keymask.u64.mask);
 			break;
 		default:
 			return -EINVAL;
@@ -1001,8 +1178,8 @@ int prestera_hw_acl_rule_add(struct prestera_switch *sw,
 	if (err)
 		goto free_buff;
 
-	req->ruleset_id = prestera_acl_rule_ruleset_id_get(rule);
-	req->priority = prestera_acl_rule_priority_get(rule);
+	req->ruleset_id = __cpu_to_le16(prestera_acl_rule_ruleset_id_get(rule));
+	req->priority = __cpu_to_le32(prestera_acl_rule_priority_get(rule));
 	req->n_actions = prestera_acl_rule_action_len(rule);
 	req->n_matches = prestera_acl_rule_match_len(rule);
 
@@ -1011,7 +1188,7 @@ int prestera_hw_acl_rule_add(struct prestera_switch *sw,
 	if (err)
 		goto free_buff;
 
-	*rule_id = resp.id;
+	*rule_id = __le32_to_cpu(resp.id);
 free_buff:
 	kfree(buff);
 	return err;
@@ -1020,7 +1197,7 @@ int prestera_hw_acl_rule_add(struct prestera_switch *sw,
 int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id)
 {
 	struct prestera_msg_acl_rule_req req = {
-		.id = rule_id
+		.id = __cpu_to_le32(rule_id)
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ACL_RULE_DELETE,
@@ -1032,7 +1209,7 @@ int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw, u32 rule_id,
 {
 	struct prestera_msg_acl_rule_stats_resp resp;
 	struct prestera_msg_acl_rule_req req = {
-		.id = rule_id
+		.id = __cpu_to_le32(rule_id)
 	};
 	int err;
 
@@ -1041,8 +1218,8 @@ int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw, u32 rule_id,
 	if (err)
 		return err;
 
-	*packets = resp.packets;
-	*bytes = resp.bytes;
+	*packets = __le64_to_cpu(resp.packets);
+	*bytes = __le64_to_cpu(resp.bytes);
 
 	return 0;
 }
@@ -1050,9 +1227,9 @@ int prestera_hw_acl_rule_stats_get(struct prestera_switch *sw, u32 rule_id,
 int prestera_hw_acl_port_bind(const struct prestera_port *port, u16 ruleset_id)
 {
 	struct prestera_msg_acl_ruleset_bind_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.ruleset_id = ruleset_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.ruleset_id = __cpu_to_le16(ruleset_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_ACL_PORT_BIND,
@@ -1063,9 +1240,9 @@ int prestera_hw_acl_port_unbind(const struct prestera_port *port,
 				u16 ruleset_id)
 {
 	struct prestera_msg_acl_ruleset_bind_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.ruleset_id = ruleset_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.ruleset_id = __cpu_to_le16(ruleset_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_ACL_PORT_UNBIND,
@@ -1076,8 +1253,8 @@ int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id)
 {
 	struct prestera_msg_span_resp resp;
 	struct prestera_msg_span_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 	int err;
 
@@ -1094,8 +1271,8 @@ int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id)
 int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id)
 {
 	struct prestera_msg_span_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.id = span_id,
 	};
 
@@ -1106,8 +1283,8 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id)
 int prestera_hw_span_unbind(const struct prestera_port *port)
 {
 	struct prestera_msg_span_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_UNBIND,
@@ -1127,9 +1304,9 @@ int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id)
 int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_TYPE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_TYPE),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 	struct prestera_msg_port_attr_resp resp;
 	int err;
@@ -1144,146 +1321,12 @@ int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
 	return 0;
 }
 
-int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*fec = resp.param.fec;
-
-	return 0;
-}
-
-int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FEC,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.param = {
-			.fec = fec,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-static u8 prestera_hw_mdix_to_eth(u8 mode)
-{
-	switch (mode) {
-	case PRESTERA_PORT_TP_MDI:
-		return ETH_TP_MDI;
-	case PRESTERA_PORT_TP_MDIX:
-		return ETH_TP_MDI_X;
-	case PRESTERA_PORT_TP_AUTO:
-		return ETH_TP_MDI_AUTO;
-	default:
-		return ETH_TP_MDI_INVALID;
-	}
-}
-
-static u8 prestera_hw_mdix_from_eth(u8 mode)
-{
-	switch (mode) {
-	case ETH_TP_MDI:
-		return PRESTERA_PORT_TP_MDI;
-	case ETH_TP_MDI_X:
-		return PRESTERA_PORT_TP_MDIX;
-	case ETH_TP_MDI_AUTO:
-		return PRESTERA_PORT_TP_AUTO;
-	default:
-		return PRESTERA_PORT_TP_NA;
-	}
-}
-
-int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
-			      u8 *admin_mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*status = prestera_hw_mdix_to_eth(resp.param.mdix.status);
-	*admin_mode = prestera_hw_mdix_to_eth(resp.param.mdix.admin_mode);
-
-	return 0;
-}
-
-int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_MDIX,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-
-	req.param.mdix.admin_mode = prestera_hw_mdix_from_eth(mode);
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_link_mode_set(const struct prestera_port *port, u32 mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.param = {
-			.link_mode = mode,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_LINK_MODE,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*mode = resp.param.link_mode;
-
-	return 0;
-}
-
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_SPEED,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_SPEED),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 	struct prestera_msg_port_attr_resp resp;
 	int err;
@@ -1293,73 +1336,33 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
 	if (err)
 		return err;
 
-	*speed = resp.param.speed;
+	*speed = __le32_to_cpu(resp.param.speed);
 
 	return 0;
 }
 
-int prestera_hw_port_autoneg_set(const struct prestera_port *port,
-				 bool autoneg, u64 link_modes, u8 fec)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.param = {
-			.autoneg = {
-				.link_mode = link_modes,
-				.enable = autoneg,
-				.fec = fec,
-			}
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
 int prestera_hw_port_autoneg_restart(struct prestera_port *port)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG_RESTART,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_duplex_get(const struct prestera_port *port, u8 *duplex)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_DUPLEX,
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-	struct prestera_msg_port_attr_resp resp;
-	int err;
-
-	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
-			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
-	if (err)
-		return err;
-
-	*duplex = resp.param.duplex;
-
-	return 0;
-}
-
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *st)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_STATS,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_STATS),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 	struct prestera_msg_port_stats_resp resp;
-	u64 *hw = resp.stats;
+	__le64 *hw = resp.stats;
 	int err;
 
 	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
@@ -1367,36 +1370,56 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 	if (err)
 		return err;
 
-	st->good_octets_received = hw[PRESTERA_PORT_GOOD_OCTETS_RCV_CNT];
-	st->bad_octets_received = hw[PRESTERA_PORT_BAD_OCTETS_RCV_CNT];
-	st->mac_trans_error = hw[PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT];
-	st->broadcast_frames_received = hw[PRESTERA_PORT_BRDC_PKTS_RCV_CNT];
-	st->multicast_frames_received = hw[PRESTERA_PORT_MC_PKTS_RCV_CNT];
-	st->frames_64_octets = hw[PRESTERA_PORT_PKTS_64L_CNT];
-	st->frames_65_to_127_octets = hw[PRESTERA_PORT_PKTS_65TO127L_CNT];
-	st->frames_128_to_255_octets = hw[PRESTERA_PORT_PKTS_128TO255L_CNT];
-	st->frames_256_to_511_octets = hw[PRESTERA_PORT_PKTS_256TO511L_CNT];
-	st->frames_512_to_1023_octets = hw[PRESTERA_PORT_PKTS_512TO1023L_CNT];
-	st->frames_1024_to_max_octets = hw[PRESTERA_PORT_PKTS_1024TOMAXL_CNT];
-	st->excessive_collision = hw[PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT];
-	st->multicast_frames_sent = hw[PRESTERA_PORT_MC_PKTS_SENT_CNT];
-	st->broadcast_frames_sent = hw[PRESTERA_PORT_BRDC_PKTS_SENT_CNT];
-	st->fc_sent = hw[PRESTERA_PORT_FC_SENT_CNT];
-	st->fc_received = hw[PRESTERA_PORT_GOOD_FC_RCV_CNT];
-	st->buffer_overrun = hw[PRESTERA_PORT_DROP_EVENTS_CNT];
-	st->undersize = hw[PRESTERA_PORT_UNDERSIZE_PKTS_CNT];
-	st->fragments = hw[PRESTERA_PORT_FRAGMENTS_PKTS_CNT];
-	st->oversize = hw[PRESTERA_PORT_OVERSIZE_PKTS_CNT];
-	st->jabber = hw[PRESTERA_PORT_JABBER_PKTS_CNT];
-	st->rx_error_frame_received = hw[PRESTERA_PORT_MAC_RCV_ERROR_CNT];
-	st->bad_crc = hw[PRESTERA_PORT_BAD_CRC_CNT];
-	st->collisions = hw[PRESTERA_PORT_COLLISIONS_CNT];
-	st->late_collision = hw[PRESTERA_PORT_LATE_COLLISIONS_CNT];
-	st->unicast_frames_received = hw[PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT];
-	st->unicast_frames_sent = hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT];
-	st->sent_multiple = hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT];
-	st->sent_deferred = hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT];
-	st->good_octets_sent = hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT];
+	st->good_octets_received =
+		__le64_to_cpu(hw[PRESTERA_PORT_GOOD_OCTETS_RCV_CNT]);
+	st->bad_octets_received =
+		__le64_to_cpu(hw[PRESTERA_PORT_BAD_OCTETS_RCV_CNT]);
+	st->mac_trans_error =
+		__le64_to_cpu(hw[PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT]);
+	st->broadcast_frames_received =
+		__le64_to_cpu(hw[PRESTERA_PORT_BRDC_PKTS_RCV_CNT]);
+	st->multicast_frames_received =
+		__le64_to_cpu(hw[PRESTERA_PORT_MC_PKTS_RCV_CNT]);
+	st->frames_64_octets = __le64_to_cpu(hw[PRESTERA_PORT_PKTS_64L_CNT]);
+	st->frames_65_to_127_octets =
+		__le64_to_cpu(hw[PRESTERA_PORT_PKTS_65TO127L_CNT]);
+	st->frames_128_to_255_octets =
+		__le64_to_cpu(hw[PRESTERA_PORT_PKTS_128TO255L_CNT]);
+	st->frames_256_to_511_octets =
+		__le64_to_cpu(hw[PRESTERA_PORT_PKTS_256TO511L_CNT]);
+	st->frames_512_to_1023_octets =
+		__le64_to_cpu(hw[PRESTERA_PORT_PKTS_512TO1023L_CNT]);
+	st->frames_1024_to_max_octets =
+		__le64_to_cpu(hw[PRESTERA_PORT_PKTS_1024TOMAXL_CNT]);
+	st->excessive_collision =
+		__le64_to_cpu(hw[PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT]);
+	st->multicast_frames_sent =
+		__le64_to_cpu(hw[PRESTERA_PORT_MC_PKTS_SENT_CNT]);
+	st->broadcast_frames_sent =
+		__le64_to_cpu(hw[PRESTERA_PORT_BRDC_PKTS_SENT_CNT]);
+	st->fc_sent = __le64_to_cpu(hw[PRESTERA_PORT_FC_SENT_CNT]);
+	st->fc_received = __le64_to_cpu(hw[PRESTERA_PORT_GOOD_FC_RCV_CNT]);
+	st->buffer_overrun = __le64_to_cpu(hw[PRESTERA_PORT_DROP_EVENTS_CNT]);
+	st->undersize = __le64_to_cpu(hw[PRESTERA_PORT_UNDERSIZE_PKTS_CNT]);
+	st->fragments = __le64_to_cpu(hw[PRESTERA_PORT_FRAGMENTS_PKTS_CNT]);
+	st->oversize = __le64_to_cpu(hw[PRESTERA_PORT_OVERSIZE_PKTS_CNT]);
+	st->jabber = __le64_to_cpu(hw[PRESTERA_PORT_JABBER_PKTS_CNT]);
+	st->rx_error_frame_received =
+		__le64_to_cpu(hw[PRESTERA_PORT_MAC_RCV_ERROR_CNT]);
+	st->bad_crc = __le64_to_cpu(hw[PRESTERA_PORT_BAD_CRC_CNT]);
+	st->collisions = __le64_to_cpu(hw[PRESTERA_PORT_COLLISIONS_CNT]);
+	st->late_collision =
+		__le64_to_cpu(hw[PRESTERA_PORT_LATE_COLLISIONS_CNT]);
+	st->unicast_frames_received =
+		__le64_to_cpu(hw[PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT]);
+	st->unicast_frames_sent =
+		__le64_to_cpu(hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT]);
+	st->sent_multiple =
+		__le64_to_cpu(hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT]);
+	st->sent_deferred =
+		__le64_to_cpu(hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT]);
+	st->good_octets_sent =
+		__le64_to_cpu(hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT]);
 
 	return 0;
 }
@@ -1404,9 +1427,9 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_LEARNING,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_LEARNING),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
 			.learning = enable,
 		}
@@ -1419,9 +1442,9 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
 			.flood_ext = {
 				.type = PRESTERA_PORT_FLOOD_TYPE_UC,
@@ -1437,9 +1460,9 @@ static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
 static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
 			.flood_ext = {
 				.type = PRESTERA_PORT_FLOOD_TYPE_MC,
@@ -1455,9 +1478,9 @@ static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 static int prestera_hw_port_flood_set_v2(struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 		.param = {
 			.flood = flood,
 		}
@@ -1505,7 +1528,7 @@ int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
-		.vid = vid,
+		.vid = __cpu_to_le16(vid),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VLAN_CREATE,
@@ -1515,7 +1538,7 @@ int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 int prestera_hw_vlan_delete(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
-		.vid = vid,
+		.vid = __cpu_to_le16(vid),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_VLAN_DELETE,
@@ -1526,9 +1549,9 @@ int prestera_hw_vlan_port_set(struct prestera_port *port, u16 vid,
 			      bool is_member, bool untagged)
 {
 	struct prestera_msg_vlan_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.vid = vid,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.vid = __cpu_to_le16(vid),
 		.is_member = is_member,
 		.is_tagged = !untagged,
 	};
@@ -1540,9 +1563,9 @@ int prestera_hw_vlan_port_set(struct prestera_port *port, u16 vid,
 int prestera_hw_vlan_port_vid_set(struct prestera_port *port, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.vid = vid,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.vid = __cpu_to_le16(vid),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_VLAN_PVID_SET,
@@ -1552,9 +1575,9 @@ int prestera_hw_vlan_port_vid_set(struct prestera_port *port, u16 vid)
 int prestera_hw_vlan_port_stp_set(struct prestera_port *port, u16 vid, u8 state)
 {
 	struct prestera_msg_stp_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.vid = vid,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.vid = __cpu_to_le16(vid),
 		.state = state,
 	};
 
@@ -1567,10 +1590,10 @@ int prestera_hw_fdb_add(struct prestera_port *port, const unsigned char *mac,
 {
 	struct prestera_msg_fdb_req req = {
 		.dest = {
-			.dev = port->dev_id,
-			.port = port->hw_id,
+			.dev = __cpu_to_le32(port->dev_id),
+			.port = __cpu_to_le32(port->hw_id),
 		},
-		.vid = vid,
+		.vid = __cpu_to_le16(vid),
 		.dynamic = dynamic,
 	};
 
@@ -1585,10 +1608,10 @@ int prestera_hw_fdb_del(struct prestera_port *port, const unsigned char *mac,
 {
 	struct prestera_msg_fdb_req req = {
 		.dest = {
-			.dev = port->dev_id,
-			.port = port->hw_id,
+			.dev = __cpu_to_le32(port->dev_id),
+			.port = __cpu_to_le32(port->hw_id),
 		},
-		.vid = vid,
+		.vid = __cpu_to_le16(vid),
 	};
 
 	ether_addr_copy(req.mac, mac);
@@ -1603,9 +1626,9 @@ int prestera_hw_lag_fdb_add(struct prestera_switch *sw, u16 lag_id,
 	struct prestera_msg_fdb_req req = {
 		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
 		.dest = {
-			.lag_id = lag_id,
+			.lag_id = __cpu_to_le16(lag_id),
 		},
-		.vid = vid,
+		.vid = __cpu_to_le16(vid),
 		.dynamic = dynamic,
 	};
 
@@ -1621,9 +1644,9 @@ int prestera_hw_lag_fdb_del(struct prestera_switch *sw, u16 lag_id,
 	struct prestera_msg_fdb_req req = {
 		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
 		.dest = {
-			.lag_id = lag_id,
+			.lag_id = __cpu_to_le16(lag_id),
 		},
-		.vid = vid,
+		.vid = __cpu_to_le16(vid),
 	};
 
 	ether_addr_copy(req.mac, mac);
@@ -1636,10 +1659,10 @@ int prestera_hw_fdb_flush_port(struct prestera_port *port, u32 mode)
 {
 	struct prestera_msg_fdb_req req = {
 		.dest = {
-			.dev = port->dev_id,
-			.port = port->hw_id,
+			.dev = __cpu_to_le32(port->dev_id),
+			.port = __cpu_to_le32(port->hw_id),
 		},
-		.flush_mode = mode,
+		.flush_mode = __cpu_to_le32(mode),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT,
@@ -1649,8 +1672,8 @@ int prestera_hw_fdb_flush_port(struct prestera_port *port, u32 mode)
 int prestera_hw_fdb_flush_vlan(struct prestera_switch *sw, u16 vid, u32 mode)
 {
 	struct prestera_msg_fdb_req req = {
-		.vid = vid,
-		.flush_mode = mode,
+		.vid = __cpu_to_le16(vid),
+		.flush_mode = __cpu_to_le32(mode),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_FLUSH_VLAN,
@@ -1662,11 +1685,11 @@ int prestera_hw_fdb_flush_port_vlan(struct prestera_port *port, u16 vid,
 {
 	struct prestera_msg_fdb_req req = {
 		.dest = {
-			.dev = port->dev_id,
-			.port = port->hw_id,
+			.dev = __cpu_to_le32(port->dev_id),
+			.port = __cpu_to_le32(port->hw_id),
 		},
-		.vid = vid,
-		.flush_mode = mode,
+		.vid = __cpu_to_le16(vid),
+		.flush_mode = __cpu_to_le32(mode),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT_VLAN,
@@ -1679,9 +1702,9 @@ int prestera_hw_fdb_flush_lag(struct prestera_switch *sw, u16 lag_id,
 	struct prestera_msg_fdb_req req = {
 		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
 		.dest = {
-			.lag_id = lag_id,
+			.lag_id = __cpu_to_le16(lag_id),
 		},
-		.flush_mode = mode,
+		.flush_mode = __cpu_to_le32(mode),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT,
@@ -1694,10 +1717,10 @@ int prestera_hw_fdb_flush_lag_vlan(struct prestera_switch *sw,
 	struct prestera_msg_fdb_req req = {
 		.dest_type = PRESTERA_HW_FDB_ENTRY_TYPE_LAG,
 		.dest = {
-			.lag_id = lag_id,
+			.lag_id = __cpu_to_le16(lag_id),
 		},
-		.vid = vid,
-		.flush_mode = mode,
+		.vid = __cpu_to_le16(vid),
+		.flush_mode = __cpu_to_le32(mode),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_FDB_FLUSH_PORT_VLAN,
@@ -1716,7 +1739,7 @@ int prestera_hw_bridge_create(struct prestera_switch *sw, u16 *bridge_id)
 	if (err)
 		return err;
 
-	*bridge_id = resp.bridge;
+	*bridge_id = __le16_to_cpu(resp.bridge);
 
 	return 0;
 }
@@ -1724,7 +1747,7 @@ int prestera_hw_bridge_create(struct prestera_switch *sw, u16 *bridge_id)
 int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id)
 {
 	struct prestera_msg_bridge_req req = {
-		.bridge = bridge_id,
+		.bridge = __cpu_to_le16(bridge_id),
 	};
 
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_BRIDGE_DELETE,
@@ -1734,9 +1757,9 @@ int prestera_hw_bridge_delete(struct prestera_switch *sw, u16 bridge_id)
 int prestera_hw_bridge_port_add(struct prestera_port *port, u16 bridge_id)
 {
 	struct prestera_msg_bridge_req req = {
-		.bridge = bridge_id,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.bridge = __cpu_to_le16(bridge_id),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_BRIDGE_PORT_ADD,
@@ -1746,9 +1769,9 @@ int prestera_hw_bridge_port_add(struct prestera_port *port, u16 bridge_id)
 int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
 {
 	struct prestera_msg_bridge_req req = {
-		.bridge = bridge_id,
-		.port = port->hw_id,
-		.dev = port->dev_id,
+		.bridge = __cpu_to_le16(bridge_id),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_BRIDGE_PORT_DELETE,
@@ -1769,28 +1792,17 @@ int prestera_hw_rxtx_init(struct prestera_switch *sw,
 	if (err)
 		return err;
 
-	params->map_addr = resp.map_addr;
+	params->map_addr = __le32_to_cpu(resp.map_addr);
 
 	return 0;
 }
 
-int prestera_hw_rxtx_port_init(struct prestera_port *port)
-{
-	struct prestera_msg_rxtx_port_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_RXTX_PORT_INIT,
-			    &req.cmd, sizeof(req));
-}
-
 int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id)
 {
 	struct prestera_msg_lag_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.lag_id = lag_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.lag_id = __cpu_to_le16(lag_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_LAG_MEMBER_ADD,
@@ -1800,9 +1812,9 @@ int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id)
 int prestera_hw_lag_member_del(struct prestera_port *port, u16 lag_id)
 {
 	struct prestera_msg_lag_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.lag_id = lag_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.lag_id = __cpu_to_le16(lag_id),
 	};
 
 	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_LAG_MEMBER_DELETE,
@@ -1813,9 +1825,9 @@ int prestera_hw_lag_member_enable(struct prestera_port *port, u16 lag_id,
 				  bool enable)
 {
 	struct prestera_msg_lag_req req = {
-		.port = port->hw_id,
-		.dev = port->dev_id,
-		.lag_id = lag_id,
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.lag_id = __cpu_to_le16(lag_id),
 	};
 	u32 cmd;
 
@@ -1842,7 +1854,7 @@ prestera_hw_cpu_code_counters_get(struct prestera_switch *sw, u8 code,
 	if (err)
 		return err;
 
-	*packet_count = resp.packet_count;
+	*packet_count = __le64_to_cpu(resp.packet_count);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 546d5fd8240d..57a3c2e5b112 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -20,6 +20,23 @@ enum prestera_fdb_flush_mode {
 };
 
 enum {
+	PRESTERA_MAC_MODE_INTERNAL,
+	PRESTERA_MAC_MODE_SGMII,
+	PRESTERA_MAC_MODE_1000BASE_X,
+	PRESTERA_MAC_MODE_KR,
+	PRESTERA_MAC_MODE_KR2,
+	PRESTERA_MAC_MODE_KR4,
+	PRESTERA_MAC_MODE_CR,
+	PRESTERA_MAC_MODE_CR2,
+	PRESTERA_MAC_MODE_CR4,
+	PRESTERA_MAC_MODE_SR_LR,
+	PRESTERA_MAC_MODE_SR_LR2,
+	PRESTERA_MAC_MODE_SR_LR4,
+
+	PRESTERA_MAC_MODE_MAX
+};
+
+enum {
 	PRESTERA_LINK_MODE_10baseT_Half,
 	PRESTERA_LINK_MODE_10baseT_Full,
 	PRESTERA_LINK_MODE_100baseT_Half,
@@ -116,32 +133,29 @@ int prestera_hw_switch_mac_set(struct prestera_switch *sw, const char *mac);
 /* Port API */
 int prestera_hw_port_info_get(const struct prestera_port *port,
 			      u32 *dev_id, u32 *hw_id, u16 *fp_id);
-int prestera_hw_port_state_set(const struct prestera_port *port,
-			       bool admin_state);
+
+int prestera_hw_port_mac_mode_get(const struct prestera_port *port,
+				  u32 *mode, u32 *speed, u8 *duplex, u8 *fec);
+int prestera_hw_port_mac_mode_set(const struct prestera_port *port,
+				  bool admin, u32 mode, u8 inband,
+				  u32 speed, u8 duplex, u8 fec);
+int prestera_hw_port_phy_mode_get(const struct prestera_port *port,
+				  u8 *mdix, u64 *lmode_bmap,
+				  bool *fc_pause, bool *fc_asym);
+int prestera_hw_port_phy_mode_set(const struct prestera_port *port,
+				  bool admin, bool adv, u32 mode, u64 modes,
+				  u8 mdix);
+
 int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu);
 int prestera_hw_port_mtu_get(const struct prestera_port *port, u32 *mtu);
 int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac);
 int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps);
-int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
-				    u64 *link_mode_bitmap);
-int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
-				   bool *pause, bool *asym_pause);
 int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type);
-int prestera_hw_port_fec_get(const struct prestera_port *port, u8 *fec);
-int prestera_hw_port_fec_set(const struct prestera_port *port, u8 fec);
-int prestera_hw_port_autoneg_set(const struct prestera_port *port,
-				 bool autoneg, u64 link_modes, u8 fec);
 int prestera_hw_port_autoneg_restart(struct prestera_port *port);
-int prestera_hw_port_duplex_get(const struct prestera_port *port, u8 *duplex);
 int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
-int prestera_hw_port_link_mode_set(const struct prestera_port *port, u32 mode);
-int prestera_hw_port_link_mode_get(const struct prestera_port *port, u32 *mode);
-int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
-			      u8 *admin_mode);
-int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
 int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
@@ -206,7 +220,6 @@ void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
 /* RX/TX */
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params);
-int prestera_hw_rxtx_port_init(struct prestera_port *port);
 
 /* LAG API */
 int prestera_hw_lag_member_add(struct prestera_port *port, u16 lag_id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index b667f560b931..5924924e8f13 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -80,27 +80,76 @@ struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 	return port;
 }
 
-static int prestera_port_open(struct net_device *dev)
+int prestera_port_cfg_mac_read(struct prestera_port *port,
+			       struct prestera_port_mac_config *cfg)
+{
+	*cfg = port->cfg_mac;
+	return 0;
+}
+
+int prestera_port_cfg_mac_write(struct prestera_port *port,
+				struct prestera_port_mac_config *cfg)
 {
-	struct prestera_port *port = netdev_priv(dev);
 	int err;
 
-	err = prestera_hw_port_state_set(port, true);
+	err = prestera_hw_port_mac_mode_set(port, cfg->admin,
+					    cfg->mode, cfg->inband, cfg->speed,
+					    cfg->duplex, cfg->fec);
 	if (err)
 		return err;
 
+	port->cfg_mac = *cfg;
+	return 0;
+}
+
+static int prestera_port_open(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_mac_config cfg_mac;
+	int err = 0;
+
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+		err = prestera_port_cfg_mac_read(port, &cfg_mac);
+		if (!err) {
+			cfg_mac.admin = true;
+			err = prestera_port_cfg_mac_write(port, &cfg_mac);
+		}
+	} else {
+		port->cfg_phy.admin = true;
+		err = prestera_hw_port_phy_mode_set(port, true, port->autoneg,
+						    port->cfg_phy.mode,
+						    port->adver_link_modes,
+						    port->cfg_phy.mdix);
+	}
+
 	netif_start_queue(dev);
 
-	return 0;
+	return err;
 }
 
 static int prestera_port_close(struct net_device *dev)
 {
 	struct prestera_port *port = netdev_priv(dev);
+	struct prestera_port_mac_config cfg_mac;
+	int err = 0;
 
 	netif_stop_queue(dev);
 
-	return prestera_hw_port_state_set(port, false);
+	if (port->caps.transceiver == PRESTERA_PORT_TCVR_SFP) {
+		err = prestera_port_cfg_mac_read(port, &cfg_mac);
+		if (!err) {
+			cfg_mac.admin = false;
+			prestera_port_cfg_mac_write(port, &cfg_mac);
+		}
+	} else {
+		port->cfg_phy.admin = false;
+		err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
+						    port->cfg_phy.mode,
+						    port->adver_link_modes,
+						    port->cfg_phy.mdix);
+	}
+
+	return err;
 }
 
 static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
@@ -228,46 +277,23 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
-int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
-			      u64 adver_link_modes, u8 adver_fec)
+int prestera_port_autoneg_set(struct prestera_port *port, u64 link_modes)
 {
-	bool refresh = false;
-	u64 link_modes;
 	int err;
-	u8 fec;
-
-	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
-		return enable ? -EINVAL : 0;
-
-	if (!enable)
-		goto set_autoneg;
-
-	link_modes = port->caps.supp_link_modes & adver_link_modes;
-	fec = port->caps.supp_fec & adver_fec;
-
-	if (!link_modes && !fec)
-		return -EOPNOTSUPP;
-
-	if (link_modes && port->adver_link_modes != link_modes) {
-		port->adver_link_modes = link_modes;
-		refresh = true;
-	}
-
-	if (fec && port->adver_fec != fec) {
-		port->adver_fec = fec;
-		refresh = true;
-	}
 
-set_autoneg:
-	if (port->autoneg == enable && !refresh)
+	if (port->autoneg && port->adver_link_modes == link_modes)
 		return 0;
 
-	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
-					   port->adver_fec);
+	err = prestera_hw_port_phy_mode_set(port, port->cfg_phy.admin,
+					    true, 0, link_modes,
+					    port->cfg_phy.mdix);
 	if (err)
 		return err;
 
-	port->autoneg = enable;
+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
+	port->adver_link_modes = link_modes;
+	port->cfg_phy.mode = 0;
+	port->autoneg = true;
 
 	return 0;
 }
@@ -288,6 +314,7 @@ static void prestera_port_list_del(struct prestera_port *port)
 
 static int prestera_port_create(struct prestera_switch *sw, u32 id)
 {
+	struct prestera_port_mac_config cfg_mac;
 	struct prestera_port *port;
 	struct net_device *dev;
 	int err;
@@ -356,16 +383,43 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		goto err_port_init;
 	}
 
-	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
-	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
-				  port->caps.supp_fec);
+	port->adver_link_modes = port->caps.supp_link_modes;
+	port->adver_fec = 0;
+	port->autoneg = true;
+
+	/* initialize config mac */
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP) {
+		cfg_mac.admin = true;
+		cfg_mac.mode = PRESTERA_MAC_MODE_INTERNAL;
+	} else {
+		cfg_mac.admin = false;
+		cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
+	}
+	cfg_mac.inband = false;
+	cfg_mac.speed = 0;
+	cfg_mac.duplex = DUPLEX_UNKNOWN;
+	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
 
-	err = prestera_hw_port_state_set(port, false);
+	err = prestera_port_cfg_mac_write(port, &cfg_mac);
 	if (err) {
-		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac mode\n", id);
 		goto err_port_init;
 	}
 
+	/* initialize config phy (if this is inegral) */
+	if (port->caps.transceiver != PRESTERA_PORT_TCVR_SFP) {
+		port->cfg_phy.mdix = ETH_TP_MDI_AUTO;
+		port->cfg_phy.admin = false;
+		err = prestera_hw_port_phy_mode_set(port,
+						    port->cfg_phy.admin,
+						    false, 0, 0,
+						    port->cfg_phy.mdix);
+		if (err) {
+			dev_err(prestera_dev(sw), "Failed to set port(%u) phy mode\n", id);
+			goto err_port_init;
+		}
+	}
+
 	err = prestera_rxtx_port_init(port);
 	if (err)
 		goto err_port_init;
@@ -446,8 +500,10 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
 
 	caching_dw = &port->cached_hw_stats.caching_dw;
 
-	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
-		if (evt->port_evt.data.oper_state) {
+	prestera_ethtool_port_state_changed(port, &evt->port_evt);
+
+	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
+		if (port->state_mac.oper) {
 			netif_carrier_on(port->dev);
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..5d4d410b07c8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,10 +14,10 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	3
+#define PRESTERA_SUPP_FW_MAJ_VER	4
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
-#define PRESTERA_PREV_FW_MAJ_VER	2
+#define PRESTERA_PREV_FW_MAJ_VER	4
 #define PRESTERA_PREV_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
@@ -102,23 +102,30 @@ struct prestera_fw_evtq_regs {
 	u32 len;
 };
 
+#define PRESTERA_CMD_QNUM_MAX	4
+
+struct prestera_fw_cmdq_regs {
+	u32 req_ctl;
+	u32 req_len;
+	u32 rcv_ctl;
+	u32 rcv_len;
+	u32 offs;
+	u32 len;
+};
+
 struct prestera_fw_regs {
 	u32 fw_ready;
-	u32 pad;
 	u32 cmd_offs;
 	u32 cmd_len;
+	u32 cmd_qnum;
 	u32 evt_offs;
 	u32 evt_qnum;
 
-	u32 cmd_req_ctl;
-	u32 cmd_req_len;
-	u32 cmd_rcv_ctl;
-	u32 cmd_rcv_len;
-
 	u32 fw_status;
 	u32 rx_status;
 
-	struct prestera_fw_evtq_regs evtq_list[PRESTERA_EVT_QNUM_MAX];
+	struct prestera_fw_cmdq_regs cmdq_list[PRESTERA_EVT_QNUM_MAX];
+	struct prestera_fw_evtq_regs evtq_list[PRESTERA_CMD_QNUM_MAX];
 };
 
 #define PRESTERA_FW_REG_OFFSET(f)	offsetof(struct prestera_fw_regs, f)
@@ -130,14 +137,22 @@ struct prestera_fw_regs {
 
 #define PRESTERA_CMD_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(cmd_offs)
 #define PRESTERA_CMD_BUF_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_len)
+#define PRESTERA_CMD_QNUM_REG		PRESTERA_FW_REG_OFFSET(cmd_qnum)
 #define PRESTERA_EVT_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(evt_offs)
 #define PRESTERA_EVT_QNUM_REG		PRESTERA_FW_REG_OFFSET(evt_qnum)
 
-#define PRESTERA_CMD_REQ_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_req_ctl)
-#define PRESTERA_CMD_REQ_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_req_len)
+#define PRESTERA_CMDQ_REG_OFFSET(q, f)			\
+	(PRESTERA_FW_REG_OFFSET(cmdq_list) +		\
+	 (q) * sizeof(struct prestera_fw_cmdq_regs) +	\
+	 offsetof(struct prestera_fw_cmdq_regs, f))
+
+#define PRESTERA_CMDQ_REQ_CTL_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, req_ctl)
+#define PRESTERA_CMDQ_REQ_LEN_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, req_len)
+#define PRESTERA_CMDQ_RCV_CTL_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, rcv_ctl)
+#define PRESTERA_CMDQ_RCV_LEN_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, rcv_len)
+#define PRESTERA_CMDQ_OFFS_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, offs)
+#define PRESTERA_CMDQ_LEN_REG(q)	PRESTERA_CMDQ_REG_OFFSET(q, len)
 
-#define PRESTERA_CMD_RCV_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_ctl)
-#define PRESTERA_CMD_RCV_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_len)
 #define PRESTERA_FW_STATUS_REG		PRESTERA_FW_REG_OFFSET(fw_status)
 #define PRESTERA_RX_STATUS_REG		PRESTERA_FW_REG_OFFSET(rx_status)
 
@@ -174,6 +189,13 @@ struct prestera_fw_evtq {
 	size_t len;
 };
 
+struct prestera_fw_cmdq {
+	/* serialize access to dev->send_req */
+	struct mutex cmd_mtx;
+	u8 __iomem *addr;
+	size_t len;
+};
+
 struct prestera_fw {
 	struct prestera_fw_rev rev_supp;
 	const struct firmware *bin;
@@ -183,9 +205,10 @@ struct prestera_fw {
 	u8 __iomem *ldr_ring_buf;
 	u32 ldr_buf_len;
 	u32 ldr_wr_idx;
-	struct mutex cmd_mtx; /* serialize access to dev->send_req */
 	size_t cmd_mbox_len;
 	u8 __iomem *cmd_mbox;
+	struct prestera_fw_cmdq cmd_queue[PRESTERA_CMD_QNUM_MAX];
+	u8 cmd_qnum;
 	struct prestera_fw_evtq evt_queue[PRESTERA_EVT_QNUM_MAX];
 	u8 evt_qnum;
 	struct work_struct evt_work;
@@ -324,7 +347,27 @@ static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
 				  1 * USEC_PER_MSEC, waitms * USEC_PER_MSEC);
 }
 
-static int prestera_fw_cmd_send(struct prestera_fw *fw,
+static void prestera_fw_cmdq_lock(struct prestera_fw *fw, u8 qid)
+{
+	mutex_lock(&fw->cmd_queue[qid].cmd_mtx);
+}
+
+static void prestera_fw_cmdq_unlock(struct prestera_fw *fw, u8 qid)
+{
+	mutex_unlock(&fw->cmd_queue[qid].cmd_mtx);
+}
+
+static u32 prestera_fw_cmdq_len(struct prestera_fw *fw, u8 qid)
+{
+	return fw->cmd_queue[qid].len;
+}
+
+static u8 __iomem *prestera_fw_cmdq_buf(struct prestera_fw *fw, u8 qid)
+{
+	return fw->cmd_queue[qid].addr;
+}
+
+static int prestera_fw_cmd_send(struct prestera_fw *fw, int qid,
 				void *in_msg, size_t in_size,
 				void *out_msg, size_t out_size,
 				unsigned int waitms)
@@ -335,30 +378,32 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 	if (!waitms)
 		waitms = PRESTERA_FW_CMD_DEFAULT_WAIT_MS;
 
-	if (ALIGN(in_size, 4) > fw->cmd_mbox_len)
+	if (ALIGN(in_size, 4) > prestera_fw_cmdq_len(fw, qid))
 		return -EMSGSIZE;
 
 	/* wait for finish previous reply from FW */
-	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG, 0, 30);
+	err = prestera_fw_wait_reg32(fw, PRESTERA_CMDQ_RCV_CTL_REG(qid), 0, 30);
 	if (err) {
 		dev_err(fw->dev.dev, "finish reply from FW is timed out\n");
 		return err;
 	}
 
-	prestera_fw_write(fw, PRESTERA_CMD_REQ_LEN_REG, in_size);
-	memcpy_toio(fw->cmd_mbox, in_msg, in_size);
+	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_LEN_REG(qid), in_size);
+
+	memcpy_toio(prestera_fw_cmdq_buf(fw, qid), in_msg, in_size);
 
-	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REQ_SENT);
+	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
+			  PRESTERA_CMD_F_REQ_SENT);
 
 	/* wait for reply from FW */
-	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG,
+	err = prestera_fw_wait_reg32(fw, PRESTERA_CMDQ_RCV_CTL_REG(qid),
 				     PRESTERA_CMD_F_REPL_SENT, waitms);
 	if (err) {
 		dev_err(fw->dev.dev, "reply from FW is timed out\n");
 		goto cmd_exit;
 	}
 
-	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
+	ret_size = prestera_fw_read(fw, PRESTERA_CMDQ_RCV_LEN_REG(qid));
 	if (ret_size > out_size) {
 		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
 			ret_size, out_size);
@@ -366,14 +411,15 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 		goto cmd_exit;
 	}
 
-	memcpy_fromio(out_msg, fw->cmd_mbox + in_size, ret_size);
+	memcpy_fromio(out_msg, prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
 
 cmd_exit:
-	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REPL_RCVD);
+	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
+			  PRESTERA_CMD_F_REPL_RCVD);
 	return err;
 }
 
-static int prestera_fw_send_req(struct prestera_device *dev,
+static int prestera_fw_send_req(struct prestera_device *dev, int qid,
 				void *in_msg, size_t in_size, void *out_msg,
 				size_t out_size, unsigned int waitms)
 {
@@ -382,9 +428,10 @@ static int prestera_fw_send_req(struct prestera_device *dev,
 
 	fw = container_of(dev, struct prestera_fw, dev);
 
-	mutex_lock(&fw->cmd_mtx);
-	ret = prestera_fw_cmd_send(fw, in_msg, in_size, out_msg, out_size, waitms);
-	mutex_unlock(&fw->cmd_mtx);
+	prestera_fw_cmdq_lock(fw, qid);
+	ret = prestera_fw_cmd_send(fw, qid, in_msg, in_size, out_msg, out_size,
+				   waitms);
+	prestera_fw_cmdq_unlock(fw, qid);
 
 	return ret;
 }
@@ -414,7 +461,16 @@ static int prestera_fw_init(struct prestera_fw *fw)
 
 	fw->cmd_mbox = base + prestera_fw_read(fw, PRESTERA_CMD_BUF_OFFS_REG);
 	fw->cmd_mbox_len = prestera_fw_read(fw, PRESTERA_CMD_BUF_LEN_REG);
-	mutex_init(&fw->cmd_mtx);
+	fw->cmd_qnum = prestera_fw_read(fw, PRESTERA_CMD_QNUM_REG);
+
+	for (qid = 0; qid < fw->cmd_qnum; qid++) {
+		u32 offs = prestera_fw_read(fw, PRESTERA_CMDQ_OFFS_REG(qid));
+		struct prestera_fw_cmdq *cmdq = &fw->cmd_queue[qid];
+
+		cmdq->len = prestera_fw_read(fw, PRESTERA_CMDQ_LEN_REG(qid));
+		cmdq->addr = fw->cmd_mbox + offs;
+		mutex_init(&cmdq->cmd_mtx);
+	}
 
 	fw->evt_buf = base + prestera_fw_read(fw, PRESTERA_EVT_BUF_OFFS_REG);
 	fw->evt_qnum = prestera_fw_read(fw, PRESTERA_EVT_QNUM_REG);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 73d2eba5262f..e452cdeaf703 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -794,14 +794,7 @@ void prestera_rxtx_switch_fini(struct prestera_switch *sw)
 
 int prestera_rxtx_port_init(struct prestera_port *port)
 {
-	int err;
-
-	err = prestera_hw_rxtx_port_init(port);
-	if (err)
-		return err;
-
 	port->dev->needed_headroom = PRESTERA_DSA_HLEN;
-
 	return 0;
 }
 
-- 
2.7.4

