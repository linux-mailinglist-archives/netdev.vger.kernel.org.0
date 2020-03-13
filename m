Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7EB183FF2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgCMEIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgCMEIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:08:18 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B72FC20752;
        Fri, 13 Mar 2020 04:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072497;
        bh=hhnlEZBvpjXk/8te9X3v9oAvukWGsv8+/+yrf59oKCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9SfliFgIlfdDnU+DkL0BuG9pDWUW1nYKRXYz9RQjYxlZl3HX4nEv6YUqA2g5QOee
         v1jUBuiVPIBUej24CdkXrjnbaDbH70c70RT2KPxWsojmDY1ouuCZSAo9CWDag6rnyt
         nszOLrkArpFBsuhnAIXEQwRdeIhnlxchr0VtZBOU=
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
Subject: [PATCH net-next 11/15] net: qede: reject unsupported coalescing params
Date:   Thu, 12 Mar 2020 21:07:59 -0700
Message-Id: <20200313040803.2367590-12-kuba@kernel.org>
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
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8a426afb6a55..4f7676f4e624 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -2087,6 +2087,7 @@ static int qede_get_dump_data(struct net_device *dev,
 }
 
 static const struct ethtool_ops qede_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_link_ksettings = qede_get_link_ksettings,
 	.set_link_ksettings = qede_set_link_ksettings,
 	.get_drvinfo = qede_get_drvinfo,
@@ -2133,6 +2134,7 @@ static const struct ethtool_ops qede_ethtool_ops = {
 };
 
 static const struct ethtool_ops qede_vf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_link_ksettings = qede_get_link_ksettings,
 	.get_drvinfo = qede_get_drvinfo,
 	.get_msglevel = qede_get_msglevel,
-- 
2.24.1

