Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620771216FB
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfLPSdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:33:02 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35069 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbfLPScx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:32:53 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so2230016plt.2;
        Mon, 16 Dec 2019 10:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=o91fzN2Y/X2pYVVbNINyzWcNsMLhEgfMww7nvU4ja1A=;
        b=LpTHnZdl+8KeCrOr2LCUVbjlt3LBBk3CS0fa+Uggxd3ak34a+nrJ7TqU1TTPhwxuKO
         23piv+guYTxrglZcCE9VkkQP0OlBxofzBz8b/9dT51GuRbxOtfI6N2Rt483HAx8w5UyP
         BClgt6tnFVPd3ODWYxhGnakclB9vjfEk1Z71vtbI0h8TpgSe7NqddxvjRksNg7/8ROP3
         zErmTtDaXDJCa1+Dhse/2yZt2L+lZKNbqkz8j5oHvDsNlUE7rXNVk1CrDFPUhCodGoSC
         SIM0EiI1SFRfYh/X5DUr4PZHmBLwyLMsZYyy1k0S8rNl1XH2QVtQ724gQ8aL97GOrL1/
         dWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o91fzN2Y/X2pYVVbNINyzWcNsMLhEgfMww7nvU4ja1A=;
        b=l8LRoJlI6KysE78wUnYXAliJu4lCopF/owZs4q4OXzJckDsQMS9hNAC+sdS4a0WZ6v
         s45LLLZt+DBOh8vYT4X0bn1SqlRq5wMBZWCaKGcTmVKzcme841OT5gHXglOZN+oZZbzo
         aiNBcKU122wM2JSsIrg9/eSz9+J4gu3yObkaWO50aJLtv1MxA5drfGt7kAg8+UwzChF7
         OtuDa57FxXklWexfiII/QO2AAUu+XlqTjOqdTk4ZEkjwJ8/9JgGokft7lfqaBRUWho0w
         /LFQg6F5BKpuFX2OSZ2I/yoaknkWvOAFqXujH/LAGORWepE1tbbUPAgiZxPAG37nrdTP
         dGzg==
X-Gm-Message-State: APjAAAWfahXm0+NZihFsoJnZUMobGKiiP/1vinxgWQXMIJBiIA3liEJj
        bh8Q1+pJBH2HtLn1BDBXGxKau051
X-Google-Smtp-Source: APXvYqy16E6kEH55xOzJzxaSnsNjzeH6MnSuTTQdSvurBwtB8/c1RsDKm42kYkycQUJJFDs41GK+IQ==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr17629802plt.110.1576521172472;
        Mon, 16 Dec 2019 10:32:52 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm23945761pfs.20.2019.12.16.10.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:32:51 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     rmk+kernel@armlinux.org.uk, ioana.ciornei@nxp.com,
        olteanv@gmail.com, jakub.kicinski@netronome.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Make PHYLINK related function static again
Date:   Mon, 16 Dec 2019 10:32:47 -0800
Message-Id: <20191216183248.16309-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 77373d49de22 ("net: dsa: Move the phylink driver calls into
port.c") moved and exported a bunch of symbols, but they are not used
outside of net/dsa/port.c at the moment, so no reason to export them.

Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa_priv.h | 16 ----------------
 net/dsa/port.c     | 38 ++++++++++++++++----------------------
 2 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2dd86d9bcda9..09ea2fd78c74 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -150,22 +150,6 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
 int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
-void dsa_port_phylink_validate(struct phylink_config *config,
-			       unsigned long *supported,
-			       struct phylink_link_state *state);
-void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
-					struct phylink_link_state *state);
-void dsa_port_phylink_mac_config(struct phylink_config *config,
-				 unsigned int mode,
-				 const struct phylink_link_state *state);
-void dsa_port_phylink_mac_an_restart(struct phylink_config *config);
-void dsa_port_phylink_mac_link_down(struct phylink_config *config,
-				    unsigned int mode,
-				    phy_interface_t interface);
-void dsa_port_phylink_mac_link_up(struct phylink_config *config,
-				  unsigned int mode,
-				  phy_interface_t interface,
-				  struct phy_device *phydev);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 /* slave.c */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 46ac9ba21987..ffb5601f7ed6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -415,9 +415,9 @@ static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 	return phydev;
 }
 
-void dsa_port_phylink_validate(struct phylink_config *config,
-			       unsigned long *supported,
-			       struct phylink_link_state *state)
+static void dsa_port_phylink_validate(struct phylink_config *config,
+				      unsigned long *supported,
+				      struct phylink_link_state *state)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
@@ -427,10 +427,9 @@ void dsa_port_phylink_validate(struct phylink_config *config,
 
 	ds->ops->phylink_validate(ds, dp->index, supported, state);
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_validate);
 
-void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
-					struct phylink_link_state *state)
+static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
+					       struct phylink_link_state *state)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
@@ -444,11 +443,10 @@ void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
 	if (ds->ops->phylink_mac_link_state(ds, dp->index, state) < 0)
 		state->link = 0;
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_pcs_get_state);
 
-void dsa_port_phylink_mac_config(struct phylink_config *config,
-				 unsigned int mode,
-				 const struct phylink_link_state *state)
+static void dsa_port_phylink_mac_config(struct phylink_config *config,
+					unsigned int mode,
+					const struct phylink_link_state *state)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
@@ -458,9 +456,8 @@ void dsa_port_phylink_mac_config(struct phylink_config *config,
 
 	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_config);
 
-void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
+static void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
@@ -470,11 +467,10 @@ void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
 
 	ds->ops->phylink_mac_an_restart(ds, dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_an_restart);
 
-void dsa_port_phylink_mac_link_down(struct phylink_config *config,
-				    unsigned int mode,
-				    phy_interface_t interface)
+static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
+					   unsigned int mode,
+					   phy_interface_t interface)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct phy_device *phydev = NULL;
@@ -491,12 +487,11 @@ void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 
 	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_down);
 
-void dsa_port_phylink_mac_link_up(struct phylink_config *config,
-				  unsigned int mode,
-				  phy_interface_t interface,
-				  struct phy_device *phydev)
+static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
+					 unsigned int mode,
+					 phy_interface_t interface,
+					 struct phy_device *phydev)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
@@ -509,7 +504,6 @@ void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 
 	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
 }
-EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_up);
 
 const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
-- 
2.17.1

