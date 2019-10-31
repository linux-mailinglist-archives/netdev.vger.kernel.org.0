Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E120CEAF06
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfJaLhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:37:14 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56398 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfJaLhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:37:12 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6447A1A051B;
        Thu, 31 Oct 2019 12:37:10 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 57F551A0509;
        Thu, 31 Oct 2019 12:37:10 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 19ABF205E9;
        Thu, 31 Oct 2019 12:37:10 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next 10/13] dpaa_eth: remove netdev_err() for user errors
Date:   Thu, 31 Oct 2019 13:36:56 +0200
Message-Id: <1572521819-10458-11-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
References: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User reports that an application making an (incorrect) call to
restart AN on a fixed link DPAA interface triggers an error in
the kernel log while the returned EINVAL should be enough.

Reported-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 1c689e11c61f..126c0f1d8442 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -81,7 +81,6 @@ static int dpaa_get_link_ksettings(struct net_device *net_dev,
 				   struct ethtool_link_ksettings *cmd)
 {
 	if (!net_dev->phydev) {
-		netdev_dbg(net_dev, "phy device not initialized\n");
 		return 0;
 	}
 
@@ -96,7 +95,6 @@ static int dpaa_set_link_ksettings(struct net_device *net_dev,
 	int err;
 
 	if (!net_dev->phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
 		return -ENODEV;
 	}
 
@@ -143,7 +141,6 @@ static int dpaa_nway_reset(struct net_device *net_dev)
 	int err;
 
 	if (!net_dev->phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
 		return -ENODEV;
 	}
 
@@ -168,7 +165,6 @@ static void dpaa_get_pauseparam(struct net_device *net_dev,
 	mac_dev = priv->mac_dev;
 
 	if (!net_dev->phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
 		return;
 	}
 
-- 
2.1.0

