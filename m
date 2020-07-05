Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B76214EE1
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgGETaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:30:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgGETaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:30:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsALD-003jRW-O7; Sun, 05 Jul 2020 21:30:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/5] net: dsa: Add __precpu property to prevent warnings
Date:   Sun,  5 Jul 2020 21:30:04 +0200
Message-Id: <20200705193008.889623-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193008.889623-1-andrew@lunn.ch>
References: <20200705193008.889623-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/dsa/slave.c:505:13: warning: incorrect type in initializer (different address spaces)
net/dsa/slave.c:505:13:    expected void const [noderef] <asn:3> *__vpp_verify
net/dsa/slave.c:505:13:    got struct pcpu_sw_netstats *

Add the needed _percpu property to prevent this warning.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/dsa_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index adecf73bd608..1653e3377cb3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -77,7 +77,7 @@ struct dsa_slave_priv {
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
 					struct net_device *dev);
 
-	struct pcpu_sw_netstats	*stats64;
+	struct pcpu_sw_netstats	__percpu *stats64;
 
 	struct gro_cells	gcells;
 
-- 
2.27.0.rc2

