Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD72CFE9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfE1UDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:03:02 -0400
Received: from mail.bix.bg ([193.105.196.21]:60668 "HELO mail.bix.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1726619AbfE1UDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 16:03:01 -0400
Received: (qmail 18670 invoked from network); 28 May 2019 20:03:00 -0000
Received: from d2.declera.com (212.116.131.122)
  by indigo.declera.com with SMTP; 28 May 2019 20:03:00 -0000
Message-ID: <d35f93599eab47ea78e9d42ce18673733611fbd8.camel@declera.com>
Subject: [PATCH] net: mvpp2: setup link irqs for ports with in-band-status
 phylink
From:   Yanko Kaneti <yaneti@declera.com>
To:     netdev <netdev@vger.kernel.org>
Date:   Tue, 28 May 2019 23:03:00 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.33.2 (3.33.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

This might be misguided but it seems to fix link status on my mcbin-
singleshot SFP+ ports

-Yanko

-- >8 --

MACCHIATObin Single-shot uses the direct-to-MAC SFP+ ports setup
which phylink supports in in-band-status mode. Don't assume
phylink means external phy and connect the link irqs.

Signed-off-by: Yanko Kaneti <yaneti@declera.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d38952eb7aa9..2f6acc38087c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3447,7 +3447,7 @@ static int mvpp2_open(struct net_device *dev)
 		valid = true;
 	}
 
-	if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
+	if (priv->hw_version == MVPP22 && port->link_irq && !port->has_phy) {
 		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
 				  dev->name, port);
 		if (err) {
-- 


