Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF0F183FEC
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCMEII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgCMEIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4241A2073B;
        Fri, 13 Mar 2020 04:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072487;
        bh=1S7BggD83DfdIDiyl7AP5ZpDCpRAUb3It0ehgPYL5L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfhn8Cwh0U4K6AlQNVq5VXcYbTw2koqmAqlzJhOR1tqnkWWwb18isskn+unWCdKuw
         bmOmEhp8J+4h7fDkjIY7/L1PSpxlE/R/0I2NOzY9ZXQoG/al4d9jaLOMO7jdIswtCl
         bHqsBg5X6lF6OIC5KYXNimq38vbp6Fzwkpt2N4yw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        cooldavid@cooldavid.org, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        rmk+kernel@armlinux.org.uk, mcroce@redhat.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, mlindner@marvell.com,
        stephen@networkplumber.org, christopher.lee@cspi.com,
        manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        nic_swsd@realtek.com, hkallweit1@gmail.com, bh74.an@samsung.com,
        romieu@fr.zoreil.com
Subject: [PATCH net-next 02/15] net: mv643xx_eth: reject unsupported coalescing params
Date:   Thu, 12 Mar 2020 21:07:50 -0700
Message-Id: <20200313040803.2367590-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313040803.2367590-1-kuba@kernel.org>
References: <20200313040803.2367590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 3c8125cbc84d..81d24481b22c 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1737,6 +1737,7 @@ static int mv643xx_eth_get_sset_count(struct net_device *dev, int sset)
 }
 
 static const struct ethtool_ops mv643xx_eth_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo		= mv643xx_eth_get_drvinfo,
 	.nway_reset		= phy_ethtool_nway_reset,
 	.get_link		= ethtool_op_get_link,
-- 
2.24.1

