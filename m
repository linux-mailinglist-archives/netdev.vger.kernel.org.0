Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA5F8EAB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLLfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:35:16 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50384 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLLfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:35:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ni1GYJnemBzlrcauLb4nzH5o+GAAXgQ/RJnpDmw8IIs=; b=NN6c51mGF8Xbbq3xnOtikdcPBf
        HCA27OvInDoXiOj0PqxA8uvQByEm+OOEkvkoZSgib+evpL3yo8G+AbtZoXKvVE6/uF2nmAQnT7M8h
        O2A0P1DPmWUK11JAHALJYWfJxzl2CPCIqVx0Vizx9FUMSpgkV0O/xCGzIff0JnqqQ1hLfA6XJJFOz
        evzfoCdVHpK1yzYvfCR5sUzBjxiPCm6O7kqQF29u2IqV+i6gHbAOQqn7jHZpVng9XsY9lXzrA7KPl
        ohe8B6pRqpGMZJts0dadUY+e3GfEE6HbsKXGuSWgHf3rsHXxpIDFB0uGXAtr/92uYv5EpnNw2nTeM
        j3cS81Rw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37346 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iUURp-0004Qe-7O; Tue, 12 Nov 2019 11:35:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iUURo-0003A9-KA; Tue, 12 Nov 2019 11:35:00 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net: sfp: fix sfp_bus_add_upstream() warning
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iUURo-0003A9-KA@rmk-PC.armlinux.org.uk>
Date:   Tue, 12 Nov 2019 11:35:00 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with SFP disabled, the stub for sfp_bus_add_upstream()
missed "inline".  Add it.

Fixes: 727b3668b730 ("net: sfp: rework upstream interface")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/sfp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index c8464de7cff5..3b35efd85bb1 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -563,8 +563,8 @@ static inline struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
 	return NULL;
 }
 
-static int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
-				const struct sfp_upstream_ops *ops)
+static inline int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
+				       const struct sfp_upstream_ops *ops)
 {
 	return 0;
 }
-- 
2.20.1

