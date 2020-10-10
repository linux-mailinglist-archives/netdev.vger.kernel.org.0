Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A822828A20F
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388585AbgJJWyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53467 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730372AbgJJSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 010565C00D3;
        Sat, 10 Oct 2020 11:41:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=xbnQzBU5ZVJNAiNaX4i1sN/jbwpbt062rrlB6m5UKvM=; b=Sf4J/VjY
        vRy3kR3euUZtSp+D2UcaFeczUlVDmO5QLBfT1rvIacz+ouj8CDpD32kzqEPPPdfa
        BVt9Spqura1ipxftSPmI00L4F3UC7tzkGg+8W1Tmd9WtYq3iVkCbIMXjsD2C9Qv5
        qG4TvTUe8lSlgnuv5Ri5nnauvjCXurjtWgjU8+jqG7EduaRlrBv4FflmEKt1IF3u
        5DdUy6TvUwlq6EKDjTALZrRfRQNyKRLvRQKeaBMCDtbM5PTExi+UGLNsmH4g0syH
        xmSsHhh1XKtROAvfu8UOObSUgLHCW/dlHiL37YX5jJjCGaakNiDVCjv788rjDtVk
        FqS0ByqZ2tKncw==
X-ME-Sender: <xms:QNaBX9ARgBwhgrQV4LkYe2-R_INV8JGxnTPcwAKGdtUgQFngEXmIFw>
    <xme:QNaBX7iRPkaMpxIwfwq5M-7q-oMm2Vmwvut3dIfwN1qAnhCzirM8Uv-UiSb_sXfBk
    AMpr1JexxfGtTo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QNaBX4mzj_zsOFhBtNy9nOGAKBD_1NNRdPisFGZDW1rQOsuN683Kjg>
    <xmx:QNaBX3zzqzn4govnRojDRdwvBbP2YlEQM4_FoLYw2M44iul1n3qI_Q>
    <xmx:QNaBXyTYi0VScUYKRDU4rq6UK4EO7ajIV89woyNlEZERl3Xig1WPUQ>
    <xmx:QNaBXxGLVfrOCrZATd6N1kTtaRlrvqMeEt6Gwg7jVC_gsFSo4tMoCw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D9D73280059;
        Sat, 10 Oct 2020 11:41:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] ethtool: Expose the number of lanes in use
Date:   Sat, 10 Oct 2020 18:41:15 +0300
Message-Id: <20201010154119.3537085-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010154119.3537085-1-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, ethtool does not expose how many lanes are used when the
link is up.

After adding a possibility to advertise or force a specific number of
lanes, the lanes in use value can be either the maximum width of the port
or below.

Extend ethtool to expose the number of lanes currently in use for
drivers that support it.

For example:

$ ethtool -s swp1 speed 100000 lanes 4
$ ethtool -s swp2 speed 100000 lanes 4
$ ip link set swp1 up
$ ip link set swp2 up
$ ethtool swp1
Settings for swp1:
        Supported ports: [ FIBRE         Backplane ]
        Supported link modes:   1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full
                                100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
				200000baseCR4/Full
	Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Advertised link modes:  100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 100000Mb/s
        Lanes: 4
        Duplex: Full
        Auto-negotiation: on
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: yes

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 5 +++--
 net/ethtool/linkmodes.c                      | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 05073482db05..16638ee9d3f9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -388,8 +388,8 @@ LINKMODES_GET
 =============
 
 Requests link modes (supported, advertised and peer advertised) and related
-information (autonegotiation status, link speed and duplex) as provided by
-``ETHTOOL_GLINKSETTINGS``. The request does not use any attributes.
+information (autonegotiation status, link speed, duplex and lanes) as provided
+by ``ETHTOOL_GLINKSETTINGS``. The request does not use any attributes.
 
 Request contents:
 
@@ -408,6 +408,7 @@ Kernel response contents:
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
+  ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   ==========================================  ======  ==========================
 
 For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index a1f02896ed8b..a940cfcd2122 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -43,6 +43,9 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
 		goto out;
 	}
 
+	if (!(dev->ethtool_ops->capabilities & ETHTOOL_CAP_LINK_LANES_SUPPORTED))
+		data->ksettings.lanes = ETHTOOL_LANES_UNKNOWN;
+
 	data->peer_empty =
 		bitmap_empty(data->ksettings.link_modes.lp_advertising,
 			     __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -63,6 +66,7 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 
 	len = nla_total_size(sizeof(u8)) /* LINKMODES_AUTONEG */
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
+		+ nla_total_size(sizeof(u32)) /* LINKMODES_LANES */
 		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
 		+ 0;
 	ret = ethnl_bitset_size(ksettings->link_modes.advertising,
@@ -120,6 +124,7 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	}
 
 	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
+	    nla_put_u32(skb, ETHTOOL_A_LINKMODES_LANES, ksettings->lanes) ||
 	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
 		return -EMSGSIZE;
 
-- 
2.26.2

