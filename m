Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7222D6C7B37
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjCXJXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjCXJXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:23:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBDEAF1A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9zuW/o9ByjUmp8jyU2wRl/jKDRAV1MddWDvwmzK8UmM=; b=QC3drg4+fwL39z/On6ihFz4zFw
        RC0IVm4Av+E086djQz5QoK6ogtGwTG1dbraNM0T538VPtcEH+ivUYgykdFzBb6hh1rqRXxESMdrMd
        m1Qj3OqCjk6rRMjgl3ZlMEPB2DixOA8WoGFuzWnJ/olulzZ4Dlfbqby3YFqTA/0QUnZcSZ43Pe41E
        eArYHrnGbWtrraYPOKBlTPSShDbZjTOZd4Dkf9mthVN6OjuqKxGq4FsiRCgL5bFcsfqKfuDEeAD9z
        RqbTE6JxTdSzP37xpY9i1+y3mk+yVbOWxbozHTHoFe2Xq2RWmPsQA96maVnmIYTSqYZ1DuSiEDWlt
        WgYPGSgg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:32884 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pfdeB-0006jc-HI; Fri, 24 Mar 2023 09:23:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pfdeA-00EQ6K-SI; Fri, 24 Mar 2023 09:23:42 +0000
In-Reply-To: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/3] net: sfp: make sfp_bus_find_fwnode() take a
 const fwnode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pfdeA-00EQ6K-SI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Mar 2023 09:23:42 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp_bus_find_fwnode() does not write to the fwnode, so let's make it
const.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 2 +-
 include/linux/sfp.h       | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 1dd50f2ca05d..b4680f859269 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -593,7 +593,7 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
  *	- %-ENOMEM if we failed to allocate the bus.
  *	- an error from the upstream's connect_phy() method.
  */
-struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
+struct sfp_bus *sfp_bus_find_fwnode(const struct fwnode_handle *fwnode)
 {
 	struct fwnode_reference_args ref;
 	struct sfp_bus *bus;
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 52b98f9666a2..ef06a195b3c2 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -557,7 +557,7 @@ int sfp_get_module_eeprom_by_page(struct sfp_bus *bus,
 void sfp_upstream_start(struct sfp_bus *bus);
 void sfp_upstream_stop(struct sfp_bus *bus);
 void sfp_bus_put(struct sfp_bus *bus);
-struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode);
+struct sfp_bus *sfp_bus_find_fwnode(const struct fwnode_handle *fwnode);
 int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
 			 const struct sfp_upstream_ops *ops);
 void sfp_bus_del_upstream(struct sfp_bus *bus);
@@ -619,7 +619,8 @@ static inline void sfp_bus_put(struct sfp_bus *bus)
 {
 }
 
-static inline struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
+static inline struct sfp_bus *
+sfp_bus_find_fwnode(const struct fwnode_handle *fwnode)
 {
 	return NULL;
 }
-- 
2.30.2

