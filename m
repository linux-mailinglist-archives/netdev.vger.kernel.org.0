Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD322AA7AB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgKGTfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:35:40 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:39979 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726206AbgKGTfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:35:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id A511ED19;
        Sat,  7 Nov 2020 14:35:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 07 Nov 2020 14:35:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=6/hoxChDQQHHb
        F/sCHpLtlxigecF0MmA0hHa1O2awHM=; b=pYWBA6Ip1bO9L1Y91lhEWzIU0vlys
        lvYtQOJ6CPXmm2y4FURR5yQWwFTBdJd/8kJsVY82XNHnJIc82GBg6uVDhN3jPpsk
        rdOSDADoQ9c/W0QzldnFLVtlAoZeyOLfRq+VgAj2WkM3790ACQo9fbpv751qpPBf
        Wp9rQbV+cQtk5LxdqVYLGx1t5Wu2p2j48x8ojixwKkmuMYJQTS85XC6y9gWz0/OT
        PMLm26oG9yviIIj6SsyVuGEgInl/PZDZvz1VoFlKuJLVvBj9ZE7hOawP5FMkZLQL
        juAw4IzKysLC20uM+10OkW02pe8Vx5FgtenYKHxy2kg2ViHy5Z80Ly7ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6/hoxChDQQHHbF/sCHpLtlxigecF0MmA0hHa1O2awHM=; b=FYPh7TCM
        ew8CVTIDXoQ7FYWNZPeOy7CTi7zguxlCz8T8JDJ06xszjdmuPZenQtY6U7Ks0UC4
        zMeMTnI5R8M6+wGAOGKi7xniHXVkelmEuulG6aQvyjBZOtRosnIDbcF58AhwCF+/
        02SR6qTHqpB5Xrmr7i43tR8qsqL9eIOf6wIUphH8/OTLJU2yLg+UnwOHi57tS+bp
        EbfYCuqDBQZ0MvZCJuuOG1dtxQu3zzCCfVRcMT+i0MepkLHiarvnmV6kecV5g4ZQ
        LxOtBr85pMx2vkUenVMkO1W56SCydmmPFxoVVF7gZgfSZ/zC6uFZ4k5jA+W4Zqxe
        q6I3R8irw0645w==
X-ME-Sender: <xms:BfemX4MSLlVigi4PSmnh6X-Ecpi7WTKBYetWjPmy8KoTSAnFIr9wnA>
    <xme:BfemX--v-Zv1NnRKCUFDocyPuyXShDpwmor73lkz6yf5oFp2qiXDrQh0rY0PEBkVI
    AA27M5k0C4LId6cdh4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrf
    grthhtvghrnhepieefjeeuieeggeehkeettdeltdehffffjeehtdehlefhtdffteegleeg
    geduhfejnecukfhppeekiedrvdegvddrkedrudeijeenucevlhhushhtvghrufhiiigvpe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhufhhfhidrtgig
X-ME-Proxy: <xmx:BfemX_T6FCfHDHJaMo1CeySaXPgfE5q3B241uPzx3qgBzLDvixsi-w>
    <xmx:BfemXwt-ObPqgDcFaGbLDJDCVa4cd6ZAM354n3dxivQjzodox9XSfA>
    <xmx:BfemXwdRIO8s5x_WeEbUfZYlGR9KM3qgy-uH2OVbOzMEZ18zX18r1A>
    <xmx:BfemX_63TKTcHRXlJ7eNSMJPXjptGCzaolQh2ksIOZlxjXoOa535ww>
Received: from neo.luffy.cx (lfbn-idf1-1-619-167.w86-242.abo.wanadoo.fr [86.242.8.167])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A007328041B;
        Sat,  7 Nov 2020 14:35:33 -0500 (EST)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 5C35D2341; Sat,  7 Nov 2020 20:35:32 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [PATCH net-next v2 3/3] net: evaluate net.ipvX.conf.all.disable_policy and disable_xfrm
Date:   Sat,  7 Nov 2020 20:35:15 +0100
Message-Id: <20201107193515.1469030-4-vincent@bernat.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201107193515.1469030-1-vincent@bernat.ch>
References: <20201107193515.1469030-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The disable_policy and disable_xfrm are a per-interface sysctl to
disable IPsec policy or encryption on an interface. However, while a
"all" variant is exposed, it was a noop since it was never evaluated.
We use the usual "or" logic for this kind of sysctls.

Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dc2a399cd9f4..a3b60c41cbad 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1741,7 +1741,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		flags |= RTCF_LOCAL;
 
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
+			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1857,8 +1857,8 @@ static int __mkroute_input(struct sk_buff *skb,
 	}
 
 	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
-			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
-			   IN_DEV_CONF_GET(out_dev, NOXFRM));
+			   IN_DEV_ORCONF(in_dev, NOPOLICY),
+			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
 		goto cleanup;
@@ -2227,7 +2227,7 @@ out:	return err;
 
 	rth = rt_dst_alloc(l3mdev_master_dev_rcu(dev) ? : net->loopback_dev,
 			   flags | RTCF_LOCAL, res->type,
-			   IN_DEV_CONF_GET(in_dev, NOPOLICY), false);
+			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
 	if (!rth)
 		goto e_nobufs;
 
@@ -2450,8 +2450,8 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 
 add:
 	rth = rt_dst_alloc(dev_out, flags, type,
-			   IN_DEV_CONF_GET(in_dev, NOPOLICY),
-			   IN_DEV_CONF_GET(in_dev, NOXFRM));
+			   IN_DEV_ORCONF(in_dev, NOPOLICY),
+			   IN_DEV_ORCONF(in_dev, NOXFRM));
 	if (!rth)
 		return ERR_PTR(-ENOBUFS);
 
-- 
2.29.2

