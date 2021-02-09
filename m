Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD13152A0
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhBIPVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbhBIPUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:20:36 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A271EC06178C;
        Tue,  9 Feb 2021 07:19:55 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f14so32208818ejc.8;
        Tue, 09 Feb 2021 07:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8FyuAvBiOLT1wV9WHhK/m2gvVYQtuLBYVGqY8Uxksmo=;
        b=EjDqlKOF5HwpEw9EuAQ4zs1FSd+tFqypUe8j7gfOGPO9vUtjLNScY29DOU7aeAyvlg
         iCjETv/Bc1EqraU1poY7pS4VJXZHAMVwOlmVw7+VpqLjL84f0S5NdBMs8LGxQ/egpMGe
         aEDFc8KCAmpaaMMtPXhKR6YjkxSocn/EoOIL7wjBxMd3nrbks6Im+5aRBvhgQVXpc1ht
         HOvny39mbZkw5OWSgLCvha0awcTr7c7fPn1IVOkCw7lfAKUZxu6vobytWqohHkXvWygR
         Z7aIn1oqYrh2RXldwuJAvZZd3H03DGJcCHSLv6U73xvhhYVj+OOWbabhcxwxa/2tS/8l
         hEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8FyuAvBiOLT1wV9WHhK/m2gvVYQtuLBYVGqY8Uxksmo=;
        b=LoMC/OSLUmo0Iu6lbW7dQ4Y8ChBEng/afT+fxKgk+t7jI3YZCyhowMv9OGNeBsXcse
         sRHJZensLPe8Xbep+uvFm5BAat4ncXjVoJXlYUKjwKcQ6d3MGXT/XhwZb/7en7DMz1qZ
         h42bq/3WRXVtPA8PG/h+zVYvca7IOSzGoINZML3k/iSqbZ/9y4t5cM7I4GGkzLoHPa1I
         4weGUmOQ5xl8NualChzLSj2qo1GxaYdPRXJKkPmJY0IzFMlE+WSkUREOVwiOc2ocgCoO
         MqDMfy+j+S2SXf5NH9BnIu1rWyqDz7mvBKQbpDROEcf5bgGFRL01O4tctGgSn0ZAz+yr
         ROEA==
X-Gm-Message-State: AOAM533hpM8POTnrMcoI5twtfTaCdS77MFCkl6CVVYs0BnzfxpTc12/2
        UIM/N+Xmf6uIGSwnlBZ53dw=
X-Google-Smtp-Source: ABdhPJxFyQTfqrqfnFLbdsltX9AKazUTUsiM52qg20Xa5yvwitP6nvkWVaY5jRtcwHYH7oqje5VijA==
X-Received: by 2002:a17:906:af86:: with SMTP id mj6mr22802558ejb.509.1612883994339;
        Tue, 09 Feb 2021 07:19:54 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:19:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v2 net-next 04/11] net: bridge: offload initial and final port flags through switchdev
Date:   Tue,  9 Feb 2021 17:19:29 +0200
Message-Id: <20210209151936.97382-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It must first be admitted that switchdev device drivers have a life
beyond the bridge, and when they aren't offloading the bridge driver
they are operating with forwarding disabled between ports, emulating as
closely as possible N standalone network interfaces.

Now it must be said that for a switchdev port operating in standalone
mode, address learning doesn't make much sense since that is a bridge
function. In fact, address learning even breaks setups such as this one:

   +---------------------------------------------+
   |                                             |
   | +-------------------+                       |
   | |        br0        |    send      receive  |
   | +--------+-+--------+ +--------+ +--------+ |
   | |        | |        | |        | |        | |
   | |  swp0  | |  swp1  | |  swp2  | |  swp3  | |
   | |        | |        | |        | |        | |
   +-+--------+-+--------+-+--------+-+--------+-+
          |         ^           |          ^
          |         |           |          |
          |         +-----------+          |
          |                                |
          +--------------------------------+

because if the ASIC has a single FDB (can offload a single bridge)
then source address learning on swp3 can "steal" the source MAC address
of swp2 from br0's FDB, because learning frames coming from swp2 will be
done twice: first on the swp1 ingress port, second on the swp3 ingress
port. So the hardware FDB will become out of sync with the software
bridge, and when swp2 tries to send one more packet towards swp1, the
ASIC will attempt to short-circuit the forwarding path and send it
directly to swp3 (since that's the last port it learned that address on),
which it obviously can't, because swp3 operates in standalone mode.

So switchdev drivers operating in standalone mode should disable address
learning. As a matter of practicality, we can reduce code duplication in
drivers by having the bridge notify through switchdev of the initial and
final brport flags. Then, drivers can simply start up hardcoded for no
address learning (similar to how they already start up hardcoded for no
forwarding), then they only need to listen for
SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and their job is basically done, no
need for special cases when the port joins or leaves the bridge etc.

When a port leaves the bridge (and therefore becomes standalone), we
issue a switchdev attribute that apart from disabling address learning,
enables flooding of all kinds. This is also done for pragmatic reasons,
because even though standalone switchdev ports might not need to have
flooding enabled in order to inject traffic with any MAC DA from the
control interface, it certainly doesn't hurt either, and it even makes
more sense than disabling flooding of unknown traffic towards that port.

Note that the implementation is a bit wacky because the switchdev API
for port attributes is very counterproductive. Instead of issuing a
single switchdev notification with a bitwise OR of all flags that we're
modifying, we need to issue 4 individual notifications, one for each bit.
This is because the SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS notifier
forces you to refuse the entire operation if there's at least one bit
which you can't offload, and that is currently BR_BCAST_FLOOD which
nobody does. So this change would do nothing for no one if we offloaded
all flags at once, but the idea is to offload as much as possible
instead of all or nothing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Renamed nbp_flags_change to nbp_flags_notify.
- Don't return any errors, offload flags one by one as opposed to all at
  once.

 include/linux/if_bridge.h |  3 +++
 net/bridge/br_if.c        | 21 ++++++++++++++++++++-
 net/bridge/br_switchdev.c |  3 +--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b979005ea39c..36d77fa8f40b 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -58,6 +58,9 @@ struct br_ip_list {
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
 
+#define BR_PORT_DEFAULT_FLAGS	(BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
+				 BR_LEARNING)
+
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
 extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..f813eec986ba 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -89,6 +89,23 @@ void br_port_carrier_check(struct net_bridge_port *p, bool *notified)
 	spin_unlock_bh(&br->lock);
 }
 
+/* If @mask has multiple bits set at once, offload them one by one to
+ * switchdev, to allow it to reject only what it doesn't support and accept
+ * what it does.
+ */
+static void nbp_flags_notify(struct net_bridge_port *p, unsigned long flags,
+			     unsigned long mask)
+{
+	int flag;
+
+	for_each_set_bit(flag, &mask, 32)
+		br_switchdev_set_port_flag(p, flags & BIT(flag),
+					   BIT(flag), NULL);
+
+	p->flags &= ~mask;
+	p->flags |= flags;
+}
+
 static void br_port_set_promisc(struct net_bridge_port *p)
 {
 	int err = 0;
@@ -343,6 +360,8 @@ static void del_nbp(struct net_bridge_port *p)
 		update_headroom(br, get_max_headroom(br));
 	netdev_reset_rx_headroom(dev);
 
+	nbp_flags_notify(p, BR_PORT_DEFAULT_FLAGS & ~BR_LEARNING,
+			 BR_PORT_DEFAULT_FLAGS);
 	nbp_vlan_flush(p);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	switchdev_deferred_process();
@@ -428,7 +447,7 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	p->path_cost = port_cost(dev);
 	p->priority = 0x8000 >> BR_PORT_BITS;
 	p->port_no = index;
-	p->flags = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	nbp_flags_notify(p, BR_PORT_DEFAULT_FLAGS, BR_PORT_DEFAULT_FLAGS);
 	br_init_port(p);
 	br_set_state(p, BR_STATE_DISABLED);
 	br_stp_port_timer_init(p);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index ac8dead86bf2..1fae532cfbb1 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -55,8 +55,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 }
 
 /* Flags that can be offloaded to hardware */
-#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+#define BR_PORT_FLAGS_HW_OFFLOAD	BR_PORT_DEFAULT_FLAGS
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-- 
2.25.1

