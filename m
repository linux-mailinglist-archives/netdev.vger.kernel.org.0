Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216563B87E3
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhF3Rpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhF3Rpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 13:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE8466147D;
        Wed, 30 Jun 2021 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625075000;
        bh=cFUf1mlqqTK6IFfurvcBWl5TwaAkLxgp6AVyWL5pGUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQlJrGjJzzHw6AHbTw6T0C8FXFPYwo6lpeejY6r9Ehl1tPYcccToPtdBMsYLOEGTs
         E3f4bn6cXKIzsQylh3iLgXZ53vQMmDaH4CsuJFJgNZWm9anMxUvutE9AXWp22Ki9rY
         Ina/77X+gVliLRwFbCxmKnQGUiwE00McS9Qkjj4XNWmMx0Z48d8m6s9Bhfs2HleiGd
         ALoNd6RsM/kWvrO7jcMmuJrtT3tABCIyqDI54D7cR1WgCpK99DEJuY3LCuvubMwnvU
         4p57qhqwJ8o+Y8XLbXsAeYG9ez5Z20YLh3mXoZqd9wDjpUDV05BCDWQxWLjtazuih0
         X6cj7yakN8e3g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 5/6] net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
Date:   Wed, 30 Jun 2021 19:43:07 +0200
Message-Id: <20210630174308.31831-6-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630174308.31831-1-kabel@kernel.org>
References: <20210630174308.31831-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0df952873636a ("mv88e6xxx: Add serdes Rx statistics") added
support for RX statistics on SerDes ports for Peridot.

This same implementation is also valid for Topaz, but was not enabled
at the time.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 0df952873636a ("mv88e6xxx: Add serdes Rx statistics")
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 354ff0b84b7f..1e95a0facbd4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3623,6 +3623,9 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4429,6 +4432,9 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
-- 
2.31.1

