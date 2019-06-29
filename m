Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E145C5A8DA
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 06:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfF2ENg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 00:13:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:55505 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfF2ENf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 00:13:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 21:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,430,1557212400"; 
   d="scan'208";a="173677755"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2019 21:13:33 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hh4k1-000I8K-Ci; Sat, 29 Jun 2019 12:13:33 +0800
Date:   Sat, 29 Jun 2019 12:13:26 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: [RFC PATCH] gve: gve_napi_poll() can be static
Message-ID: <20190629041326.GA26834@lkp-kbuild18>
References: <20190626185251.205687-3-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-3-csully@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: fa090987329c ("gve: Add transmit and receive support")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 gve_main.c |    6 +++---
 gve_rx.c   |    2 +-
 gve_tx.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 966bcee..f226a18 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -81,7 +81,7 @@ static irqreturn_t gve_intr(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-int gve_napi_poll(struct napi_struct *napi, int budget)
+static int gve_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct gve_notify_block *block;
 	__be32 __iomem *irq_doorbell;
@@ -294,7 +294,7 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 	gve_clear_device_resources_ok(priv);
 }
 
-void gve_add_napi(struct gve_priv *priv, int ntfy_idx)
+static void gve_add_napi(struct gve_priv *priv, int ntfy_idx)
 {
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
@@ -302,7 +302,7 @@ void gve_add_napi(struct gve_priv *priv, int ntfy_idx)
 		       NAPI_POLL_WEIGHT);
 }
 
-void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
+static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
 {
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 5bcf250..37d6fef 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -8,7 +8,7 @@
 #include "gve_adminq.h"
 #include <linux/etherdevice.h>
 
-void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
+static void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
 {
 	struct gve_notify_block *block =
 			&priv->ntfy_blocks[gve_rx_idx_to_ntfy(priv, queue_idx)];
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 221a2e7..c7b5c6d 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -142,7 +142,7 @@ static void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx)
 static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			     u32 to_do, bool try_to_wake);
 
-void gve_tx_free_ring(struct gve_priv *priv, int idx)
+static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_tx_ring *tx = &priv->tx[idx];
 	struct device *hdev = &priv->pdev->dev;
