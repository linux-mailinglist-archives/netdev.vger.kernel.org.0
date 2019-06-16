Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AF847446
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 12:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFPKmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 06:42:03 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46370 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFPKmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 06:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bdCeIrTIdSE9xmVYhRdd1SVbjVAPDQT/qMUOLAS4y2Q=; b=fr7VfNJEX2vWe3SCD4smjcKsF3
        Lqkn91Vttb+8cysg5efqqAg7Hp/7t3mzEWxXMhZKbZc4uyqMlj2Vw7Sk7teEcIcyXS62M/s8Mw+Ep
        lEnR4e3hb6Tmy2ZBar/vkxfcAP3eHkrsJ8lTgaNc706S8/Y8R6sjeALZoyiyGq515dC/Zxm40qR0L
        YfIMrSivKrOSGHcMUBdpuyI7ERz/kWOEggoSPXB0pkZFpN/38plyJwUKtuv4uKwH1O8IF0ln4E4VV
        Wezql30sAC6SDWHoSXcfxLMSsOLe+N+v/tGaxipqcXGHa1DNwknCcaibHvzu11enCzFvN2LWKVUA3
        r7eXt2Fg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hcSbn-000640-SO; Sun, 16 Jun 2019 11:41:59 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] lapb: moved export of lapb_register.
Date:   Sun, 16 Jun 2019 11:41:59 +0100
Message-Id: <20190616104159.20268-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The EXPORT_SYMBOL for lapb_register was next to a different function.
Moved it to the right place.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/lapb/lapb_iface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 03f0cd872dce..600d754a1700 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -68,7 +68,6 @@ static void __lapb_remove_cb(struct lapb_cb *lapb)
 		lapb_put(lapb);
 	}
 }
-EXPORT_SYMBOL(lapb_register);
 
 /*
  *	Add a socket to the bound sockets list.
@@ -115,7 +114,6 @@ static struct lapb_cb *lapb_create_cb(void)
 {
 	struct lapb_cb *lapb = kzalloc(sizeof(*lapb), GFP_ATOMIC);
 
-
 	if (!lapb)
 		goto out;
 
@@ -167,6 +165,7 @@ int lapb_register(struct net_device *dev,
 	write_unlock_bh(&lapb_list_lock);
 	return rc;
 }
+EXPORT_SYMBOL(lapb_register);
 
 int lapb_unregister(struct net_device *dev)
 {
-- 
2.20.1

