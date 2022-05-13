Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8465C526BA1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 22:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383768AbiEMUeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 16:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353047AbiEMUeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 16:34:20 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC771155
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:34:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so5337287wmn.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZQV/tHpq1cMbRcbBcjpXkG1K7J3GsBoqbe0nOzBrb0=;
        b=hN+3aM+F9NgDAbgjX1uUC80Tg5RwVV6Jd0gAEvz6AWswwdMr1t2jSByCRmlGgBTPOM
         YJw7/5xGLs7caHgLuIZyUw6yWQaydmobgXYPbg8CODCXZ7dEfkW7leZWfw1u6qZSfu0f
         SafcUigarkPqcbpuyro2yR0GXJ4F/zXxmMMLmxnAcEy85Wmx6oTNpeDV/sWwoAgPrbhn
         gu6xRDCk/qcc2miG4twmrRPpd6HfHwAvVzouzsYhENDCKCtP2GP8/cLRGIIx0lpRCYxC
         wtItOHwPInbgGes0HWsGhd1x0WzqOKBPoJreXZfxsb56oldseZ2T9rvYeYxO4GRpSSsE
         C0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZQV/tHpq1cMbRcbBcjpXkG1K7J3GsBoqbe0nOzBrb0=;
        b=uTRTxrIlj2ueCqJuwfi2bejGJpfK9H95Ha0/t9JYWZvi4EEQ0TRELxoheNC21p2tz/
         eQWxlzlWHxnGJ9WSMGF3Ye2yRiRMno3MsCvnQdQjrFY04M7uHj0hpfLN/0/f/pYsYW3D
         BENKAa/XuJHuLQQLL3RYPbSZ6hIhGoddblMKn3xMCu2dZjyyuHPLs/5UojChjJarfUKS
         lClYVcFJE64NRebON97OIAiCYtWp6+QjZKEBo+MsiwK5fkNo0ysPSbqmGIedMeXNUeti
         B3p5mMpy4641Iui+3/KosKzwtnNLufN0A4fUdtpIsmOAjCEgQv5m9luvcKPW6t5RB1q0
         kCGg==
X-Gm-Message-State: AOAM5313ihOXpC1FLnH1O8VFtVp+yYPdal3qFGZlR4B8o1iufchT8IXg
        +dF6YJ5+dbjHo4XzXmjLbH0=
X-Google-Smtp-Source: ABdhPJx2ldjHHj/DI5HiFESjM2j34iB+z1OIE4XhBWB6ATv+Ksl1KI/mF1/5d3QZCAXLyZbk+LfSfA==
X-Received: by 2002:a05:600c:4f53:b0:394:6a35:79ac with SMTP id m19-20020a05600c4f5300b003946a3579acmr16685988wmq.36.1652474056831;
        Fri, 13 May 2022 13:34:16 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id l18-20020adfb112000000b0020c5253d8d3sm2986561wra.31.2022.05.13.13.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 13:34:16 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH ipsec,v2] xfrm: fix "disable_policy" flag use when arriving from different devices
Date:   Fri, 13 May 2022 23:34:02 +0300
Message-Id: <20220513203402.1290131-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In IPv4 setting the "disable_policy" flag on a device means no policy
should be enforced for traffic originating from the device. This was
implemented by seting the DST_NOPOLICY flag in the dst based on the
originating device.

However, dsts are cached in nexthops regardless of the originating
devices, in which case, the DST_NOPOLICY flag value may be incorrect.

Consider the following setup:

                     +------------------------------+
                     | ROUTER                       |
  +-------------+    | +-----------------+          |
  | ipsec src   |----|-|ipsec0           |          |
  +-------------+    | |disable_policy=0 |   +----+ |
                     | +-----------------+   |eth1|-|-----
  +-------------+    | +-----------------+   +----+ |
  | noipsec src |----|-|eth0             |          |
  +-------------+    | |disable_policy=1 |          |
                     | +-----------------+          |
                     +------------------------------+

Where ROUTER has a default route towards eth1.

dst entries for traffic arriving from eth0 would have DST_NOPOLICY
and would be cached and therefore can be reused by traffic originating
from ipsec0, skipping policy check.

Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
of the DST in IN/FWD IPv4 policy checks.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v2: set IPSKB_NOPOLICY in ip_route_input_mc() as needed
---
 include/net/ip.h   |  1 +
 include/net/xfrm.h | 14 +++++++++++++-
 net/ipv4/route.c   | 23 ++++++++++++++++++-----
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 3984f2c39c4b..0161137914cf 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -56,6 +56,7 @@ struct inet_skb_parm {
 #define IPSKB_DOREDIRECT	BIT(5)
 #define IPSKB_FRAG_PMTU		BIT(6)
 #define IPSKB_L3SLAVE		BIT(7)
+#define IPSKB_NOPOLICY		BIT(8)
 
 	u16			frag_max_size;
 };
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6fb899ff5afc..d2efddce65d4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1093,6 +1093,18 @@ static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
 	return false;
 }
 
+static inline bool __xfrm_check_dev_nopolicy(struct sk_buff *skb,
+					     int dir, unsigned short family)
+{
+	if (dir != XFRM_POLICY_OUT && family == AF_INET) {
+		/* same dst may be used for traffic originating from
+		 * devices with different policy settings.
+		 */
+		return IPCB(skb)->flags & IPSKB_NOPOLICY;
+	}
+	return skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY);
+}
+
 static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 				       struct sk_buff *skb,
 				       unsigned int family, int reverse)
@@ -1104,7 +1116,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
 	return __xfrm_check_nopolicy(net, skb, dir) ||
-	       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
+	       __xfrm_check_dev_nopolicy(skb, dir, family) ||
 	       __xfrm_policy_check(sk, ndir, skb, family);
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 98c6f3429593..fe5d14ef5c4d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1726,6 +1726,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	unsigned int flags = RTCF_MULTICAST;
 	struct rtable *rth;
+	bool no_policy;
 	u32 itag = 0;
 	int err;
 
@@ -1736,8 +1737,12 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (our)
 		flags |= RTCF_LOCAL;
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	rth = rt_dst_alloc(dev_net(dev)->loopback_dev, flags, RTN_MULTICAST,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		return -ENOBUFS;
 
@@ -1795,7 +1800,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct rtable *rth;
 	int err;
 	struct in_device *out_dev;
-	bool do_cache;
+	bool do_cache, no_policy;
 	u32 itag = 0;
 
 	/* get a working reference to the output device */
@@ -1840,6 +1845,10 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	fnhe = find_exception(nhc, daddr);
 	if (do_cache) {
 		if (fnhe)
@@ -1852,8 +1861,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY),
+	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,
 			   IN_DEV_ORCONF(out_dev, NOXFRM));
 	if (!rth) {
 		err = -ENOBUFS;
@@ -2228,6 +2236,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	struct rtable	*rth;
 	struct flowi4	fl4;
 	bool do_cache = true;
+	bool no_policy;
 
 	/* IP on this device is disabled. */
 
@@ -2346,6 +2355,10 @@ out:	return err;
 	RT_CACHE_STAT_INC(in_brd);
 
 local_input:
+	no_policy = IN_DEV_ORCONF(in_dev, NOPOLICY);
+	if (no_policy)
+		IPCB(skb)->flags |= IPSKB_NOPOLICY;
+
 	do_cache &= res->fi && !itag;
 	if (do_cache) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
@@ -2360,7 +2373,7 @@ out:	return err;
 
 	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
 			   flags | RTCF_LOCAL, res->type,
-			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
+			   no_policy, false);
 	if (!rth)
 		goto e_nobufs;
 
-- 
2.34.1

