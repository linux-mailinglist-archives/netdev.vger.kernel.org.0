Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFD245A889
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhKWQnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhKWQno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B11360F9D;
        Tue, 23 Nov 2021 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685636;
        bh=yhEHz9JVknjMUJ/knQ9hcoYufuSNDgBuNPUmMLAzHlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC2PzEq0YJ2pnQclk0dVVpo0ReZare75YROyKTZ+lVbkfu5oI24aDKTLvNQ9aZMSF
         8mfcPGb8MpOXlt7RVQP6yNhZcGOQtSDdY0ZdE12eR7J40dDe0mpm0CAnOc3Mz19mVc
         HgPIQz6kDNVMV4EKnyOAiYKpWfIKFyT5SH5BhpWtc3DsjOk5KuN1OuVOjTeDQhalGV
         UbKNkZ5Z5k6bAjqjbJv3L8NPKzCQACQU4+5n+tb9EcVg+BhuNtOOdVJTeCzNupGZKs
         uVCXvYRUeLQjeGoT94IATBuQynaztvkRN8z3lWB5jfi72Xu79a7b1H2ykl/ib4WKLw
         PpbMtvvAZ8koA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 2/8] net: Update documentation for *_get_phy_mode() functions
Date:   Tue, 23 Nov 2021 17:40:21 +0100
Message-Id: <20211123164027.15618-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the `phy-mode` DT property can be an array of strings instead
of just one string, update the documentation for of_get_phy_mode(),
fwnode_get_phy_mode() and device_get_phy_mode() saying that if multiple
strings are present, the first one is returned.

Conventionally the property was used to represent the mode we want the
PHY to operate in, but we extended this to mean the list of all
supported modes by that PHY on that particular board.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/base/property.c | 14 ++++++++------
 net/core/of_net.c       |  9 +++++----
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index f1f35b48ab8b..e12aef10f7fd 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -893,12 +893,13 @@ enum dev_dma_attr device_get_dma_attr(struct device *dev)
 EXPORT_SYMBOL_GPL(device_get_dma_attr);
 
 /**
- * fwnode_get_phy_mode - Get phy mode for given firmware node
+ * fwnode_get_phy_mode - Get first phy mode for given firmware node
  * @fwnode:	Pointer to the given node
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type', and return its index in phy_modes table, or errno in
- * error case.
+ * 'phy-connection-type', and returns its index in phy_modes table, or errno in
+ * error case. If there are multiple strings in the property, the first one is
+ * used.
  */
 int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
 {
@@ -921,12 +922,13 @@ int fwnode_get_phy_mode(struct fwnode_handle *fwnode)
 EXPORT_SYMBOL_GPL(fwnode_get_phy_mode);
 
 /**
- * device_get_phy_mode - Get phy mode for given device
+ * device_get_phy_mode - Get first phy mode for given device
  * @dev:	Pointer to the given device
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type', and return its index in phy_modes table, or errno in
- * error case.
+ * 'phy-connection-type', and returns its index in phy_modes table, or errno in
+ * error case. If there are multiple strings in the property, the first one is
+ * used.
  */
 int device_get_phy_mode(struct device *dev)
 {
diff --git a/net/core/of_net.c b/net/core/of_net.c
index f1a9bf7578e7..7cd10f0ef679 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -14,14 +14,15 @@
 #include <linux/nvmem-consumer.h>
 
 /**
- * of_get_phy_mode - Get phy mode for given device_node
+ * of_get_phy_mode - Get first phy mode for given device_node
  * @np:	Pointer to the given device_node
  * @interface: Pointer to the result
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type'. The index in phy_modes table is set in
- * interface and 0 returned. In case of error interface is set to
- * PHY_INTERFACE_MODE_NA and an errno is returned, e.g. -ENODEV.
+ * 'phy-connection-type'. If there are more string in the property, the first
+ * one is used. The index in phy_modes table is set in interface and 0 returned.
+ * In case of error interface is set to PHY_INTERFACE_MODE_NA and an errno is
+ * returned, e.g. -ENODEV.
  */
 int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
 {
-- 
2.32.0

