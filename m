Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C2D686335
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjBAJzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjBAJzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:55:41 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2390F518D6
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:55:40 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id h24so28450729lfv.6
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 01:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gOPXlgNZjtNho8nzp/sMGlDYULpras0FGxK/VYvvstM=;
        b=YX8ktkNzJZtPZ3Jbj7KrEDO8skM9T914XRHeeK1oBaJRbGWCess/PSYDtNFg7mKxt8
         y6G0ln1hS5ZYQHzyEiFkaowo//IMfMvWx5NzcjHIv55BR4W1+Xa8ly023lW3LuvEsrC5
         wgROR9RtxiKQF6n8zSPJ4SkXHguJnoP++KRaq8I4Fh7GOV0tgxAwXNrOVk1371bUXT9u
         ikglRTLFIyWk2jtT80JmnUysyFkdUlRkby96IksxDp7O+6jD/pwFoopv9npzSubcX3pO
         7gavGWgLxzxCaYmSYs8GZ0Z9n9gKy+BsyuLUAtM1MtD4844MpOLUTpyo+SoZPecnWCTv
         mPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOPXlgNZjtNho8nzp/sMGlDYULpras0FGxK/VYvvstM=;
        b=r6pMQ0ik42nDpciIXFtq7hdeF+lzj7OdcYBBFVroOe/lqh4M0So+HXgtk4BmNw8ybm
         u/UMIc0p0i+wnmQa201t8r/XewsHJxWRVfcK4HM0j1brQJiHk5VM3Q2yWCSJzeesWWeC
         Bszkj4BrDoOaz7kz03Mp4mtlr8CpGSrTTG0NsvBCoX/6+V4ECfA4ItYYN42I9if46fdN
         Nsj9Ydup8EBGMo/OUsdMSZEF7RhRsRDAPxncRelZqmtoG0g79zyQIVcF7RCpVFPAUqRt
         Ddoho2qVoGBQ8ndsko5lIV1VMU1TXbrkdpz881Y/Aex2Cx4XYECu1G6gPHPrD/1nG0pU
         NfgQ==
X-Gm-Message-State: AO0yUKUdP9j0/+eytJnicXrUANJUqlwn+TgmDZVZkFszLoNhswauKKib
        oAI3K5X+yT24NswZB7Q/Kk+tuw==
X-Google-Smtp-Source: AK7set8BI0ZQnFDpVw0CC9Cl2mgE9DoCr+cHoOhlCNRo90UyZJAJErsgJ8Y8LW3PlQlbiJr3qnQY2A==
X-Received: by 2002:ac2:5a01:0:b0:4b5:987c:de3e with SMTP id q1-20020ac25a01000000b004b5987cde3emr1348094lfn.69.1675245338383;
        Wed, 01 Feb 2023 01:55:38 -0800 (PST)
Received: from ta1.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id y7-20020a197507000000b004cc83be556dsm1131634lfe.247.2023.02.01.01.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 01:55:38 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable {4.14, 4.19, 5.4}.y] ipv6: ensure sane device mtu in tunnels
Date:   Wed,  1 Feb 2023 09:55:33 +0000
Message-Id: <20230201095533.2628469-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]

Another syzbot report [1] with no reproducer hints
at a bug in ip6_gre tunnel (dev:ip6gretap0)

Since ipv6 mcast code makes sure to read dev->mtu once
and applies a sanity check on it (see commit b9b312a7a451
"ipv6: mcast: better catch silly mtu values"), a remaining
possibility is that a layer is able to set dev->mtu to
an underflowed value (high order bit set).

This could happen indeed in ip6gre_tnl_link_config_route(),
ip6_tnl_link_config() and ipip6_tunnel_bind_dev()

Make sure to sanitize mtu value in a local variable before
it is written once on dev->mtu, as lockless readers could
catch wrong temporary value.

[1]
skbuff: skb_over_panic: text:ffff80000b7a2f38 len:40 put:40 head:ffff000149dcf200 data:ffff000149dcf2b0 tail:0xd8 end:0xc0 dev:ip6gretap0
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:120
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 10241 Comm: kworker/1:1 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: mld mld_ifc_work
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : skb_panic+0x4c/0x50 net/core/skbuff.c:116
lr : skb_panic+0x4c/0x50 net/core/skbuff.c:116
sp : ffff800020dd3b60
x29: ffff800020dd3b70 x28: 0000000000000000 x27: ffff00010df2a800
x26: 00000000000000c0 x25: 00000000000000b0 x24: ffff000149dcf200
x23: 00000000000000c0 x22: 00000000000000d8 x21: ffff80000b7a2f38
x20: ffff00014c2f7800 x19: 0000000000000028 x18: 00000000000001a9
x17: 0000000000000000 x16: ffff80000db49158 x15: ffff000113bf1a80
x14: 0000000000000000 x13: 00000000ffffffff x12: ffff000113bf1a80
x11: ff808000081c0d5c x10: 0000000000000000 x9 : 73f125dc5c63ba00
x8 : 73f125dc5c63ba00 x7 : ffff800008161d1c x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0001fefddcd0 x1 : 0000000100000000 x0 : 0000000000000089
Call trace:
skb_panic+0x4c/0x50 net/core/skbuff.c:116
skb_over_panic net/core/skbuff.c:125 [inline]
skb_put+0xd4/0xdc net/core/skbuff.c:2049
ip6_mc_hdr net/ipv6/mcast.c:1714 [inline]
mld_newpack+0x14c/0x270 net/ipv6/mcast.c:1765
add_grhead net/ipv6/mcast.c:1851 [inline]
add_grec+0xa20/0xae0 net/ipv6/mcast.c:1989
mld_send_cr+0x438/0x5a8 net/ipv6/mcast.c:2115
mld_ifc_work+0x38/0x290 net/ipv6/mcast.c:2653
process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
worker_thread+0x340/0x610 kernel/workqueue.c:2436
kthread+0x12c/0x158 kernel/kthread.c:376
ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
Code: 91011400 aa0803e1 a90027ea 94373093 (d4210000)

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221024020124.3756833-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ta: Backport patch for stable kernels < 5.10.y. Fix conflict in
net/ipv6/ip6_tunnel.c, mtu initialized with:
mtu = rt->dst.dev->mtu - t_hlen;]
Cc: <stable@vger.kernel.org> # 4.14.y, 4.19.y, 5.4.y
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 net/ipv6/ip6_gre.c    | 12 +++++++-----
 net/ipv6/ip6_tunnel.c | 10 ++++++----
 net/ipv6/sit.c        |  8 +++++---
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 4a6396d574a0..fd4da1019e44 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1137,14 +1137,16 @@ static void ip6gre_tnl_link_config_route(struct ip6_tnl *t, int set_mtu,
 				dev->needed_headroom = dst_len;
 
 			if (set_mtu) {
-				dev->mtu = rt->dst.dev->mtu - t_hlen;
+				int mtu = rt->dst.dev->mtu - t_hlen;
+
 				if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-					dev->mtu -= 8;
+					mtu -= 8;
 				if (dev->type == ARPHRD_ETHER)
-					dev->mtu -= ETH_HLEN;
+					mtu -= ETH_HLEN;
 
-				if (dev->mtu < IPV6_MIN_MTU)
-					dev->mtu = IPV6_MIN_MTU;
+				if (mtu < IPV6_MIN_MTU)
+					mtu = IPV6_MIN_MTU;
+				WRITE_ONCE(dev->mtu, mtu);
 			}
 		}
 		ip6_rt_put(rt);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 878a08c40fff..acc75975edde 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1430,6 +1430,7 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
 	int t_hlen;
+	int mtu;
 
 	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
@@ -1472,12 +1473,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			dev->hard_header_len = rt->dst.dev->hard_header_len +
 				t_hlen;
 
-			dev->mtu = rt->dst.dev->mtu - t_hlen;
+			mtu = rt->dst.dev->mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-				dev->mtu -= 8;
+				mtu -= 8;
 
-			if (dev->mtu < IPV6_MIN_MTU)
-				dev->mtu = IPV6_MIN_MTU;
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+			WRITE_ONCE(dev->mtu, mtu);
 		}
 		ip6_rt_put(rt);
 	}
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 117d374695fe..1179608955f5 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1083,10 +1083,12 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+		int mtu;
 
-		dev->mtu = tdev->mtu - t_hlen;
-		if (dev->mtu < IPV6_MIN_MTU)
-			dev->mtu = IPV6_MIN_MTU;
+		mtu = tdev->mtu - t_hlen;
+		if (mtu < IPV6_MIN_MTU)
+			mtu = IPV6_MIN_MTU;
+		WRITE_ONCE(dev->mtu, mtu);
 	}
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

