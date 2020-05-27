Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC71E5073
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbgE0V0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0V0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:26:03 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0FCC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:03 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 124so6206290pgi.9
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBtlx5cSFWoIzmSUvjtqmJJ/wx+m6j8k9yl1yVIDcWo=;
        b=Uem4qny7EMYOeJx1UBoA2Lr3mDzYJ9v6EoT5iah6YD8Jq1jYJ1xdx51408Lmab2zfa
         7/kbMWVB/Bd9wkuFmcvdEH83oMhfS87m4T4SxNTAVpLiYkrUjQyeXPbTAaFUYqJQQjgi
         dKprV4mDXRfkB4TEBSI7pjzdnvnst/ihzk7Fs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBtlx5cSFWoIzmSUvjtqmJJ/wx+m6j8k9yl1yVIDcWo=;
        b=aRf0bi0MWNyovawA9/jXP04qk/rwNtroFuwNup6K9iV6Dff++kpJ1/5EH5Y2q4xHDB
         4SMQpWmfLw9PV4cJzKPZmfUdyJ/OLUlyYumYgrhqFIT9sRgv32OO2D3TUdm5wM9A6ms3
         REyGt8UBc6kr0l6eP9W+InLw2TCsAq8iHXyv1JV9XsBDCd8PTHez3xcItAg1igREQOzR
         X2S7cbyRS9QoRYwNZoHaIopqOTf7yNquh2ZxN09JaLi2Wl5RR5n6wu2SqwycJilWIe4Y
         l//rjXmMYFZJWvjdkR8ji1stgC7f0Occ3fXalv8M9kDfYdD9HYM/zjJTIslWQcBbc0Zz
         ut7A==
X-Gm-Message-State: AOAM531uiTKCrKSkbJxGaKIc8VegaSeq0ajutu5KD82M3m01Kl/Kuinp
        5Ax/AAKQM11mtYESfXZwGtMbZ7CilcAteaUtZN0v6G2GgMft1Lo3ZUZI5NQ7B/jBC3xb3IjBKRe
        Mkc03VxMQD/j3o/6VAZAF188AzFgjSyP6AhmjxZMH/wdB8MUjultntR+5gi3yEQPVHmqWEZ0n
X-Google-Smtp-Source: ABdhPJxmB7Dqiue9OhpcJtekBG+OhCvRR5sLCjN+vtFx2LA2nSnaNb5DiL5WuURV5M9jctqJfRnkOw==
X-Received: by 2002:a62:2c8d:: with SMTP id s135mr6129030pfs.231.1590614762080;
        Wed, 27 May 2020 14:26:02 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:26:01 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 07/11] net: gre: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
Date:   Wed, 27 May 2020 14:25:08 -0700
Message-Id: <20200527212512.17901-8-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constrain the MTU of upper VLAN devices if the MTU of the GRE device
is configured to its default optimal size, which does not leave space
for a nested VLAN tag without causing fragmentation. If the underlying
lower device is not known, then the worst case is assumed and any upper
VLAN devices will always be adjusted to accommodate the VLAN tag.

For IPv4 tunnels, the changes to support this are made in the generic
ip_tunnel_change_mtu() handler and so IFF_NO_VLAN_ROOM is consequently
maintained for all tunnel devices that leverage this implementation. GRE
is, however, the only one of these implementations that might use an L2
overlay. At present nothing prevents VLAN devices being layered above
raw IP tunnel devices, which does not make sense. This limitation will
be addressed by a later patch in this series.

IPv6 GRE is dependent on PMTU discovery, but the MTU of nested VLANs
still need to be constrained, because non-VLAN packets will share the
same path MTU.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 net/ipv4/ip_tunnel.c | 2 ++
 net/ipv6/ip6_gre.c   | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..21803bd35ab3 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -981,6 +981,7 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	int max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	int best_mtu = ip_tunnel_bind_dev(dev);
 
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
@@ -993,6 +994,7 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 	}
 
 	dev->mtu = new_mtu;
+	__vlan_constrain_mtu(dev, best_mtu);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__ip_tunnel_change_mtu);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 781ca8c07a0d..0b86ee7f3d31 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1131,6 +1131,8 @@ static void ip6gre_tnl_link_config_route(struct ip6_tnl *t, int set_mtu,
 
 				if (dev->mtu < IPV6_MIN_MTU)
 					dev->mtu = IPV6_MIN_MTU;
+
+				dev->priv_flags |= IFF_NO_VLAN_ROOM;
 			}
 		}
 		ip6_rt_put(rt);
@@ -1801,7 +1803,7 @@ static int ip6gre_tap_init(struct net_device *dev)
 	if (ret)
 		return ret;
 
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_VLAN_ROOM;
 
 	return 0;
 }
-- 
2.26.2

