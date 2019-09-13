Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2525B1772
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 05:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfIMD2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 23:28:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40290 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfIMD2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 23:28:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so14528590pgj.7;
        Thu, 12 Sep 2019 20:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BfRk36jUxhPvrR7SuyOXhAxYDPZWPiFNoz8hjpc7xtc=;
        b=jRbddGfongUF/lPGlR6S0KO6Dudfzh8jqNK6t1k9n1CxT3G/TaDAq0sWkKxdstUBmP
         7mlfTNeUU+uRdySfFTLV8iAAOryFPtXSZG0m1PEDOBDmZBFZVTYdGyxP6Ewj46TKPM3Z
         6CDG0ypLhw6SesryQ8FZYNzGB6gSyU/1uECS0OV/Jr2bT4NUdRO5L/OzsndEcMI2dQFn
         Z2Q37XVB7k9y419aV95vWEVE3OVbTO3JtbWdIv8xWSqTnFTRCY/2kRUh8Tq0HGA575Vf
         0+YtFfcnXuBcowsmcFTP95ETYxqBNPTk0TWF6ZXH92uj4iwe99rjp9I7F3+OnM4bsKj8
         hxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BfRk36jUxhPvrR7SuyOXhAxYDPZWPiFNoz8hjpc7xtc=;
        b=t1pq5wYjzjXU/YcAyQP73/QwiXaRg/GuX22u5L1dK+qRsvCN8r807SWbrAiuKC5Tgx
         tRhtyHJ28fXGgFyFFIzGAXAK++Aec4wo16LflYF/v+sT3jsVNzPf0rWIgVqZFbf2NV5V
         ndP1bDGIcEGyDghkmbjog9bvpHL4361ulnJPXeqE9UbUwYzRjjLGKIGZTttrupBtD8li
         Ej5SyFqmvUvbGgQbus1lTVvptTDx67yyQxTrW6bPSpkycH3ZCVObIdGpjfMlowKK/W5h
         qWAY/mMOl5dKhbjBFEfUTFK5aDJQLFAJUCgNu26l8jmfLi/nwQM1AGUl/ZUHfJatXf7H
         YpwA==
X-Gm-Message-State: APjAAAWL/OX7QvNf20UFLGKNDGLFNjLe5NVtXHt1PfgfumrkOwfUr++P
        1VsNTz400KBu5eaCT7gYUqGhr0jV
X-Google-Smtp-Source: APXvYqz2pJWIyyYMIMiNiS9Yut9EPDbIjU9fuRAk+2YHilrEBGv5lCwEQ9Q+33ySpZe8bSx9xbrfPQ==
X-Received: by 2002:aa7:8188:: with SMTP id g8mr12215751pfi.88.1568345328669;
        Thu, 12 Sep 2019 20:28:48 -0700 (PDT)
Received: from localhost.localdomain ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id r12sm30146006pgb.73.2019.09.12.20.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 20:28:48 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     b.spranger@linutronix.de, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: b53: Add support for port_egress_floods callback
Date:   Thu, 12 Sep 2019 20:28:39 -0700
Message-Id: <20190913032841.4302-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring the per-port egress flooding control for
both Unicast and Multicast traffic.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Beneditk,

Do you mind re-testing, or confirming that this patch that I sent much
earlier does work correctly for you? Thanks!

 drivers/net/dsa/b53/b53_common.c | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 7d328a5f0161..ac2ec08a652b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -342,6 +342,13 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
 	mgmt |= B53_MII_DUMB_FWDG_EN;
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+
+	/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
+	 * frames should be flooed or not.
+	 */
+	b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
+	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN;
+	b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
 }
 
 static void b53_enable_vlan(struct b53_device *dev, bool enable,
@@ -1753,6 +1760,31 @@ void b53_br_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_br_fast_age);
 
+int b53_br_egress_floods(struct dsa_switch *ds, int port,
+			 bool unicast, bool multicast)
+{
+	struct b53_device *dev = ds->priv;
+	u16 uc, mc;
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FWD_EN, &uc);
+	if (unicast)
+		uc |= BIT(port);
+	else
+		uc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FWD_EN, uc);
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FWD_EN, &mc);
+	if (multicast)
+		mc |= BIT(port);
+	else
+		mc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FWD_EN, mc);
+
+	return 0;
+
+}
+EXPORT_SYMBOL(b53_br_egress_floods);
+
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
 	/* Broadcom switches will accept enabling Broadcom tags on the
@@ -1953,6 +1985,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_bridge_leave	= b53_br_leave,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
+	.port_egress_floods	= b53_br_egress_floods,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_prepare	= b53_vlan_prepare,
 	.port_vlan_add		= b53_vlan_add,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index f25bc80c4ffc..a7dd8acc281b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -319,6 +319,8 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge);
 void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
+int b53_br_egress_floods(struct dsa_switch *ds, int port,
+			 bool unicast, bool multicast);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
 			  unsigned long *supported,
-- 
2.17.1

