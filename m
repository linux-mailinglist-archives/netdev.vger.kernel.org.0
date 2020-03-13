Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F12183FF4
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgCMEIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgCMEIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:20 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BD82076C;
        Fri, 13 Mar 2020 04:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072499;
        bh=dkZKIFK8OauPtRrJxJuomj+0UAlE1oiopGaNWm2pFT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IISBR18hxoxls2EQ0irVBH+yTCdGvcGqbOhZ1CUk7SPshEHsA2Vp8m1ADUh1jCm4s
         Pk3e9KMFNKYV1Dgdq9aXrJl43gWPRtvTEyr4Kj8PEKwpoEyeALyDOu+XCFJz3WFsfG
         KBbPm+p2FBh3iaQqsEd6DziZIAcO0IlP+JYPmth0=
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
Subject: [PATCH net-next 13/15] net: r8169: reject unsupported coalescing params
Date:   Thu, 12 Mar 2020 21:08:01 -0700
Message-Id: <20200313040803.2367590-14-kuba@kernel.org>
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
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ce030e093485..d2eef3754b33 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2006,6 +2006,8 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 }
 
 static const struct ethtool_ops rtl8169_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_drvinfo		= rtl8169_get_drvinfo,
 	.get_regs_len		= rtl8169_get_regs_len,
 	.get_link		= ethtool_op_get_link,
-- 
2.24.1

