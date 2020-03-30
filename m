Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20CB198305
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgC3SIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:08:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46131 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgC3SIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:08:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 271845C02C3;
        Mon, 30 Mar 2020 14:08:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 14:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BJ2d85
        qbutoSJgdn1ORmk3O+lFaFPyGnzJEjB72xKvw=; b=P8WreMfcS5Gczhykcc+vED
        Dhs1AZwF+6fA7VEmfCqrDnmOThpI71s+voFA/1ueaKWae/YNKxk4UWY6NiKJvgZB
        9MLJdXHoXO9QhDTf+DBCQhY3xsNivtamOsifQhqALNtf95BaAvZxumZfcMPeyMAG
        vWXGNHD6yBAnLdbf7kNd2vHge/XZZWxgkW5V63rnkGu55HDUqHJBOUfl3XRDnRuY
        RhagbaIIb430KdD26JApKeY1GHvnaxGsDWs4oe939MZn4+Cfw6fGKhiJwKrgTwXp
        VhW/H8jxS4CaXMhPPWpTXCWAYZYhqoF/iLvbpPE2U7ssoDU9yp4bhi1pJXIhyFpg
        ==
X-ME-Sender: <xms:szWCXnmIqXLDqo0dRDaKaqxAMmEIrfeV8VFdCe-kdI1DVLltz7Q7CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffogggtgfesthekre
    dtredtjeenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:szWCXk5Est-O7A4mcrxANXHYvJ0WUeK87GHBRLRIwFLNlFUyEQ60NA>
    <xmx:szWCXstEaWj4YP-s0Fkcj6jwGncr_NFJsI97jq4uC9JVeQP4-IUaCw>
    <xmx:szWCXnsfMDMdeZLtq1fzE7R-Z-bTj0Xa8JKQAmYZ1FzSZW7ABZeBsw>
    <xmx:szWCXmKW8hyZdqYSnfWr8tQm9HdE3YTEbcsuwTe3GcOfveEa2w_Jcg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0487328005D;
        Mon, 30 Mar 2020 14:08:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] mlxsw: spectrum_ptp: Fix build warnings
Date:   Mon, 30 Mar 2020 21:08:20 +0300
Message-Id: <20200330180820.2349593-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Cited commit extended the enums 'hwtstamp_tx_types' and
'hwtstamp_rx_filters' with values that were not accounted for in the
switch statements, resulting in the build warnings below.

Fix by adding a default case.

drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c: In function ‘mlxsw_sp_ptp_get_message_types’:
drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c:915:2: warning: enumeration value ‘__HWTSTAMP_TX_CNT’ not handled in switch [-Wswitch]
  915 |  switch (tx_type) {
      |  ^~~~~~
drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c:927:2: warning: enumeration value ‘__HWTSTAMP_FILTER_CNT’ not handled in switch [-Wswitch]
  927 |  switch (rx_filter) {
      |  ^~~~~~

Fixes: f76510b458a5 ("ethtool: add timestamping related string sets")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 34f7c3501b08..9650562fc0ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -922,6 +922,8 @@ static int mlxsw_sp_ptp_get_message_types(const struct hwtstamp_config *config,
 	case HWTSTAMP_TX_ONESTEP_SYNC:
 	case HWTSTAMP_TX_ONESTEP_P2P:
 		return -ERANGE;
+	default:
+		return -EINVAL;
 	}
 
 	switch (rx_filter) {
@@ -952,6 +954,8 @@ static int mlxsw_sp_ptp_get_message_types(const struct hwtstamp_config *config,
 	case HWTSTAMP_FILTER_SOME:
 	case HWTSTAMP_FILTER_NTP_ALL:
 		return -ERANGE;
+	default:
+		return -EINVAL;
 	}
 
 	*p_ing_types = ing_types;
-- 
2.24.1

