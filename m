Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F22183FEF
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgCMEIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgCMEIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:12 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDFFB2074F;
        Fri, 13 Mar 2020 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072491;
        bh=xmWw3hyDhsas59JXMdvsr35LodVu6+YY6+iNUhoyZJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrBcWbUUQbgRBu5sNWKmji7TAZebmN5y7yJingN1sERDzXpLzJNLjhD2zksBQcbRX
         grvISIS/VunV52yrpZRwV0H4877Vtnmdf9dXyDIGt1JOknAeMJku/Jue+LtiuKeco3
         Z+Wuk9ClmAGN3GzcL+t2E8RXmeumpyqdg9HD1T8U=
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
Subject: [PATCH net-next 06/15] net: skge: reject unsupported coalescing params
Date:   Thu, 12 Mar 2020 21:07:54 -0700
Message-Id: <20200313040803.2367590-7-kuba@kernel.org>
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
 drivers/net/ethernet/marvell/skge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 97f270d30cce..3c89206f18a7 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -876,6 +876,7 @@ static int skge_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom
 }
 
 static const struct ethtool_ops skge_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo	= skge_get_drvinfo,
 	.get_regs_len	= skge_get_regs_len,
 	.get_regs	= skge_get_regs,
-- 
2.24.1

