Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6EA28A20D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388560AbgJJWyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46197 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730262AbgJJSzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C8065C00D9;
        Sat, 10 Oct 2020 11:41:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=xVOzhAZ/5cfR1H3np1vZXaEyLGoHlTSKOfwz74dsBQg=; b=Hux/Flzb
        19xH2OS8xSRqPHXE3C4O1NW8UnUW1N08Qsgdp/CPLfN+03Imc8mZbqXd8rFRxrbY
        BXSmGFS7GrihbV3TLIaCjwKiZKdN5leRm0DiqoO5Q/8mu7IPWpAeZFm7DVK7FSyd
        w+E19eZplxTKXnL23lKKZB1gKuzyYu5OzzC6/Tbw3eNC0YfBtiklrZSS0595Z1zR
        l15NY4PoN4FnXkR3xd9MDLNmlf88q7HzZx2LLhH/G0g6GCxKMGofmadrVGrVwP85
        wi7FEStkuAGV51dGWxSmhZ5NkMBgiOBB+QAeIA7C6bB6cz0ekdC1dgzUUCbEHbZh
        O+C/uem3zD5sHQ==
X-ME-Sender: <xms:PtaBX8IaZWtLhgNt1oHEPqvgv3IHZO1MLxg-sTewSKUw4ogmxFGjyw>
    <xme:PtaBX8LM5L5K20_b5hdxKVQ3DaytGFtEaOm5fPWf0dNttKiS1PWl5zHjEGprJKVrb
    rFZ9C13lL8lXY8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:P9aBX8vSmc3ScU1GhrQY4K3svc6e1Np2eyncmoaPeh31TtOZvmDYdw>
    <xmx:P9aBX5aO6F-PbuL2wzwgsr4JD9KJZmVwwIoz4Y_fZscfrguSXYhhOA>
    <xmx:P9aBXzY-q4ikXs1ClkZkZ1gkeNvhyOpf2Xp07v9eg0J8PhU1F7MAkQ>
    <xmx:P9aBX4O0NpoguEa_uF4AApIHB_9zpwFmNBU0BMezEWkgqhABgKTZ8g>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46956328005A;
        Sat, 10 Oct 2020 11:41:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI with lanes
Date:   Sat, 10 Oct 2020 18:41:14 +0300
Message-Id: <20201010154119.3537085-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010154119.3537085-1-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when auto negotiation is on, the user can advertise all the
linkmodes which correspond to a specific speed, but does not have a
similar selector for the number of lanes. This is significant when a
specific speed can be achieved using different number of lanes.  For
example, 2x50 or 4x25.

Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
ethtool_link_settings' with lanes field in order to implement a new
lanes-selector that will enable the user to advertise a specific number
of lanes as well.

When auto negotiation is off, lanes parameter can be forced only if the
driver supports it. Add a capability bit in 'struct ethtool_ops' that
allows ethtool know if the driver can handle the lanes parameter when
auto negotiation is off, so if it does not, an error message will be
returned when trying to set lanes.

Example:

$ ethtool -s swp1 lanes 4
$ ethtool swp1
  Settings for swp1:
	Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
				40000baseSR4/Full
				40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
				50000baseCR2/Full
                                100000baseSR4/Full
				100000baseCR4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  40000baseCR4/Full
				40000baseSR4/Full
				40000baseLR4/Full
                                100000baseSR4/Full
				100000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: on
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: no

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  11 +-
 include/linux/ethtool.h                      |   4 +
 include/uapi/linux/ethtool.h                 |   8 +
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/linkmodes.c                      | 227 +++++++++++--------
 net/ethtool/netlink.h                        |   2 +-
 6 files changed, 158 insertions(+), 95 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 30b98245979f..05073482db05 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -431,16 +431,17 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
+  ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   ==========================================  ======  ==========================
 
 ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes. If
 autonegotiation is on (either set now or kept from before), advertised modes
 are not changed (no ``ETHTOOL_A_LINKMODES_OURS`` attribute) and at least one
-of speed and duplex is specified, kernel adjusts advertised modes to all
-supported modes matching speed, duplex or both (whatever is specified). This
-autoselection is done on ethtool side with ioctl interface, netlink interface
-is supposed to allow requesting changes without knowing what exactly kernel
-supports.
+of speed, duplex and lanes is specified, kernel adjusts advertised modes to all
+supported modes matching speed, duplex, lanes or all (whatever is specified).
+This autoselection is done on ethtool side with ioctl interface, netlink
+interface is supposed to allow requesting changes without knowing what exactly
+kernel supports.
 
 
 LINKSTATE_GET
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6408b446051f..4945ce487f01 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -128,6 +128,7 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
+	u32	lanes;
 };
 
 /**
@@ -241,6 +242,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 
+#define ETHTOOL_CAP_LINK_LANES_SUPPORTED BIT(0)
+
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
 /**
@@ -419,6 +422,7 @@ struct ethtool_pause_stats {
  * of the generic netdev features interface.
  */
 struct ethtool_ops {
+	u32     capabilities;
 	u32	supported_coalesce_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9ca87bc73c44..2125b93ecee0 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1738,6 +1738,14 @@ static inline int ethtool_validate_speed(__u32 speed)
 	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
 }
 
+/* Lanes, 1, 2, 4 or 8. */
+#define ETHTOOL_LANES_1			1
+#define ETHTOOL_LANES_2			2
+#define ETHTOOL_LANES_4			4
+#define ETHTOOL_LANES_8			8
+
+#define ETHTOOL_LANES_UNKNOWN		0
+
 /* Duplex, half or full. */
 #define DUPLEX_HALF		0x00
 #define DUPLEX_FULL		0x01
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e2bf36e6964b..a286635ac9b8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..a1f02896ed8b 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -152,12 +152,14 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 
 struct link_mode_info {
 	int				speed;
+	int				lanes;
 	u8				duplex;
 };
 
-#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex) \
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
 	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = { \
 		.speed	= SPEED_ ## _speed, \
+		.lanes	= ETHTOOL_LANES_ ## _lanes, \
 		.duplex	= __DUPLEX_ ## _duplex \
 	}
 #define __DUPLEX_Half DUPLEX_HALF
@@ -165,105 +167,106 @@ struct link_mode_info {
 #define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
 	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = { \
 		.speed	= SPEED_UNKNOWN, \
+		.lanes	= ETHTOOL_LANES_UNKNOWN, \
 		.duplex	= DUPLEX_UNKNOWN, \
 	}
 
 static const struct link_mode_info link_mode_params[] = {
-	__DEFINE_LINK_MODE_PARAMS(10, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(10, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
 	__DEFINE_SPECIAL_MODE_PARAMS(TP),
 	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
 	__DEFINE_SPECIAL_MODE_PARAMS(MII),
 	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
 	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
-	__DEFINE_LINK_MODE_PARAMS(10000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
 	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
-	__DEFINE_LINK_MODE_PARAMS(2500, X, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
-	__DEFINE_LINK_MODE_PARAMS(1000, KX, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KX4, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
 	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
 		.speed	= SPEED_10000,
 		.duplex = DUPLEX_FULL,
 	},
-	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
-	__DEFINE_LINK_MODE_PARAMS(20000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, LR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, LR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, X, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LRM, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, ER, Full),
-	__DEFINE_LINK_MODE_PARAMS(2500, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(5000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, DR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T1, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
 };
 
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
@@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
 	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
 	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
+	[ETHTOOL_A_LINKMODES_LANES]		= { .type = NLA_U32 },
 };
 
-/* Set advertised link modes to all supported modes matching requested speed
- * and duplex values. Called when autonegotiation is on, speed or duplex is
- * requested but no link mode change. This is done in userspace with ioctl()
- * interface, move it into kernel for netlink.
+/* Set advertised link modes to all supported modes matching requested speed,
+ * lanes and duplex values. Called when autonegotiation is on, speed, lanes or
+ * duplex is requested but no link mode change. This is done in userspace with
+ * ioctl() interface, move it into kernel for netlink.
  * Returns true if advertised modes bitmap was modified.
  */
 static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
-				 bool req_speed, bool req_duplex)
+				 bool req_speed, bool req_lanes, bool req_duplex)
 {
 	unsigned long *advertising = ksettings->link_modes.advertising;
 	unsigned long *supported = ksettings->link_modes.supported;
@@ -302,6 +306,7 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
 			continue;
 		if (test_bit(i, supported) &&
 		    (!req_speed || info->speed == ksettings->base.speed) &&
+		    (!req_lanes || info->lanes == ksettings->lanes) &&
 		    (!req_duplex || info->duplex == ksettings->base.duplex))
 			set_bit(i, advertising);
 		else
@@ -325,12 +330,25 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
 	return false;
 }
 
+static bool ethnl_validate_lanes_cfg(u32 cfg)
+{
+	switch (cfg) {
+	case ETHTOOL_LANES_1:
+	case ETHTOOL_LANES_2:
+	case ETHTOOL_LANES_4:
+	case ETHTOOL_LANES_8:
+		return true;
+	}
+
+	return false;
+}
+
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 				  struct ethtool_link_ksettings *ksettings,
-				  bool *mod)
+				  bool *mod, const struct net_device *dev)
 {
 	struct ethtool_link_settings *lsettings = &ksettings->base;
-	bool req_speed, req_duplex;
+	bool req_speed, req_lanes, req_duplex;
 	const struct nlattr *master_slave_cfg;
 	int ret;
 
@@ -353,10 +371,39 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 
 	*mod = false;
 	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
+	req_lanes = tb[ETHTOOL_A_LINKMODES_LANES];
 	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
 
 	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
 			mod);
+
+	if (req_lanes) {
+		u32 lanes_cfg = nla_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);
+
+		if (!ethnl_validate_lanes_cfg(lanes_cfg)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    "lanes value is invalid");
+			return -EINVAL;
+		}
+
+		/* If autoneg is off and lanes parameter is not supported by the
+		 * driver, return an error.
+		 */
+		if (!lsettings->autoneg &&
+		    !(dev->ethtool_ops->capabilities & ETHTOOL_CAP_LINK_LANES_SUPPORTED)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    "lanes configuration not supported by device");
+			return -EOPNOTSUPP;
+		}
+	} else if (!lsettings->autoneg) {
+		/* If autoneg is off and lanes parameter is not passed from user,
+		 * set the lanes parameter to UNKNOWN.
+		 */
+		ksettings->lanes = ETHTOOL_LANES_UNKNOWN;
+	}
+
 	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
 				  __ETHTOOL_LINK_MODE_MASK_NBITS,
 				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
@@ -365,13 +412,15 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 		return ret;
 	ethnl_update_u32(&lsettings->speed, tb[ETHTOOL_A_LINKMODES_SPEED],
 			 mod);
+	ethnl_update_u32(&ksettings->lanes, tb[ETHTOOL_A_LINKMODES_LANES],
+			 mod);
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
 
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
-	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
+	    (req_speed || req_lanes || req_duplex) &&
+	    ethnl_auto_linkmodes(ksettings, req_speed, req_lanes, req_duplex))
 		*mod = true;
 
 	return 0;
@@ -409,7 +458,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
-	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod, dev);
 	if (ret < 0)
 		goto out_ops;
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..6eabd58d81bf 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -351,7 +351,7 @@ extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_O
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
-extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMODES_LANES + 1];
 extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_HEADER + 1];
 extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_HEADER + 1];
 extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MSGMASK + 1];
-- 
2.26.2

