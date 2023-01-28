Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EB067F95D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjA1P70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbjA1P7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:59:06 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26012A143
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:52 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id e8so6585156qts.1
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNEc7yx9vM6DvoqCIp74I08UHkEg4YRarn2/YK5h2lU=;
        b=X+iyssBCDSJPDcvbFyTUa2IV3rVkQf5nvQbBHoN+G01xvPvI/NsWkCeoZTBrIJAz7D
         J7KDq/KCjTMtnXgEu8kcGkmrZbYtDjBvGdenNXgpX3NP5yjln9R+iLqqPvcLoxIHqmdH
         RstSwYOikYM8OzV0iZWvyr2gn7oCN2sdwNzLvrMPNikeeYrcXotQ+8/UdYoEUjQD2KOJ
         JoEtJ7sqNMwr9ynptICn76KA/BJJez5AhhOxoxGHgg3/rPj12R6zAgAznJiFZgOrKiJ7
         mNtN7OsDraFa9G3LbZ32DmrbSmWNiFPlu/YThOSNTJ4wAJiQXGSrmIOTjOQRezknHo8j
         Xrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZNEc7yx9vM6DvoqCIp74I08UHkEg4YRarn2/YK5h2lU=;
        b=Dn8FtjIrXuQcxm4MxxOdvMN1xEyMR4H2JhRKKW8ag1RFkn+qtakvrwfRGrWQDfNnNX
         SOuu1fgDie5VCyx697ISqvfbZl2br1SKo0GoMYTDSYPhwtx20vnSAIwxWixQRQWDprJM
         EiEPAk6SzUejTyebpUo/pnxp37F0rF2xxsi8Nc/PqyDHgRi/I/iApUBahR/ozyqFpb9c
         9p6ccePA8ywBa6VySbhSar86nUHSbs9840PO77hdasY2WfpI4CtCOs/58H9yMHOj0WxF
         DLxtAxyZY2FK6yh+bdXchwecotvxKtcWYoLySL1sktuA16J3D1gpvESsxRoChMTS+6/z
         F/fQ==
X-Gm-Message-State: AFqh2kpg6xscA8UOwDGGMX+uiTYmTbo36FRs8rurRSd0WX9WvsCZKu3i
        +eZsCatXeST0W66j+yKRyIm/rAvFtiMYwg==
X-Google-Smtp-Source: AMrXdXukWeTzwgrbb+nD8zsORrzcv9xeTMvkBThNV75BYZbKZIOFWFjD+1hSDB/JeJ1NYTsLXrTXWA==
X-Received: by 2002:a05:622a:a07:b0:3b6:2fd2:84b5 with SMTP id bv7-20020a05622a0a0700b003b62fd284b5mr70758176qtb.57.1674921531639;
        Sat, 28 Jan 2023 07:58:51 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:51 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv4 net-next 09/10] net: add gso_ipv4_max_size and gro_ipv4_max_size per device
Date:   Sat, 28 Jan 2023 10:58:38 -0500
Message-Id: <7e1f733cc96c7f7658fbf3276a90281b2f37acd1.1674921359.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces gso_ipv4_max_size and gro_ipv4_max_size
per device and adds netlink attributes for them, so that IPV4
BIG TCP can be guarded by a separate tunable in the next patch.

To not break the old application using "gso/gro_max_size" for
IPv4 GSO packets, this patch updates "gso/gro_ipv4_max_size"
in netif_set_gso/gro_max_size() if the new size isn't greater
than GSO_LEGACY_MAX_SIZE, so that nothing will change even if
userspace doesn't realize the new netlink attributes.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/netdevice.h    |  6 ++++++
 include/uapi/linux/if_link.h |  3 +++
 net/core/dev.c               |  4 ++++
 net/core/dev.h               | 18 ++++++++++++++++++
 net/core/rtnetlink.c         | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 64 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2466afa25078..d5ef4c1fedd2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1964,6 +1964,8 @@ enum netdev_ml_priv_type {
  *	@gso_max_segs:	Maximum number of segments that can be passed to the
  *			NIC for GSO
  *	@tso_max_segs:	Device (as in HW) limit on the max TSO segment count
+ * 	@gso_ipv4_max_size:	Maximum size of generic segmentation offload,
+ * 				for IPv4.
  *
  *	@dcbnl_ops:	Data Center Bridging netlink ops
  *	@num_tc:	Number of traffic classes in the net device
@@ -2004,6 +2006,8 @@ enum netdev_ml_priv_type {
  *			keep a list of interfaces to be deleted.
  *	@gro_max_size:	Maximum size of aggregated packet in generic
  *			receive offload (GRO)
+ * 	@gro_ipv4_max_size:	Maximum size of aggregated packet in generic
+ * 				receive offload (GRO), for IPv4.
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
@@ -2207,6 +2211,7 @@ struct net_device {
  */
 #define GRO_MAX_SIZE		(8 * 65535u)
 	unsigned int		gro_max_size;
+	unsigned int		gro_ipv4_max_size;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
@@ -2330,6 +2335,7 @@ struct net_device {
 	u16			gso_max_segs;
 #define TSO_MAX_SEGS		U16_MAX
 	u16			tso_max_segs;
+	unsigned int		gso_ipv4_max_size;
 
 #ifdef CONFIG_DCB
 	const struct dcbnl_rtnl_ops *dcbnl_ops;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1021a7e47a86..02b87e4c65be 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -374,6 +374,9 @@ enum {
 
 	IFLA_DEVLINK_PORT,
 
+	IFLA_GSO_IPV4_MAX_SIZE,
+	IFLA_GRO_IPV4_MAX_SIZE,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index f72f5c4ee7e2..bb42150a38ec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3001,6 +3001,8 @@ void netif_set_tso_max_size(struct net_device *dev, unsigned int size)
 	dev->tso_max_size = min(GSO_MAX_SIZE, size);
 	if (size < READ_ONCE(dev->gso_max_size))
 		netif_set_gso_max_size(dev, size);
+	if (size < READ_ONCE(dev->gso_ipv4_max_size))
+		netif_set_gso_ipv4_max_size(dev, size);
 }
 EXPORT_SYMBOL(netif_set_tso_max_size);
 
@@ -10614,6 +10616,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_size = GSO_LEGACY_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_LEGACY_MAX_SIZE;
+	dev->gso_ipv4_max_size = GSO_LEGACY_MAX_SIZE;
+	dev->gro_ipv4_max_size = GRO_LEGACY_MAX_SIZE;
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
 	dev->tso_max_segs = TSO_MAX_SEGS;
 	dev->upper_level = 1;
diff --git a/net/core/dev.h b/net/core/dev.h
index 814ed5b7b960..a065b7571441 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -100,6 +100,8 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
 {
 	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
 	WRITE_ONCE(dev->gso_max_size, size);
+	if (size <= GSO_LEGACY_MAX_SIZE)
+		WRITE_ONCE(dev->gso_ipv4_max_size, size);
 }
 
 static inline void netif_set_gso_max_segs(struct net_device *dev,
@@ -114,6 +116,22 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
 {
 	/* This pairs with the READ_ONCE() in skb_gro_receive() */
 	WRITE_ONCE(dev->gro_max_size, size);
+	if (size <= GRO_LEGACY_MAX_SIZE)
+		WRITE_ONCE(dev->gro_ipv4_max_size, size);
+}
+
+static inline void netif_set_gso_ipv4_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	/* dev->gso_ipv4_max_size is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_ipv4_max_size, size);
+}
+
+static inline void netif_set_gro_ipv4_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_ipv4_max_size, size);
 }
 
 #endif
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 64289bc98887..b9f584955b77 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1074,6 +1074,8 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GSO_IPV4_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GRO_IPV4_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SEGS */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
@@ -1807,6 +1809,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
+	    nla_put_u32(skb, IFLA_GSO_IPV4_MAX_SIZE, dev->gso_ipv4_max_size) ||
+	    nla_put_u32(skb, IFLA_GRO_IPV4_MAX_SIZE, dev->gro_ipv4_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SIZE, dev->tso_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SEGS, dev->tso_max_segs) ||
 #ifdef CONFIG_RPS
@@ -1968,6 +1972,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
 	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
 	[IFLA_ALLMULTI]		= { .type = NLA_REJECT },
+	[IFLA_GSO_IPV4_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GRO_IPV4_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2883,6 +2889,29 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GSO_IPV4_MAX_SIZE]) {
+		u32 max_size = nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]);
+
+		if (max_size > dev->tso_max_size) {
+			err = -EINVAL;
+			goto errout;
+		}
+
+		if (dev->gso_ipv4_max_size ^ max_size) {
+			netif_set_gso_ipv4_max_size(dev, max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
+	if (tb[IFLA_GRO_IPV4_MAX_SIZE]) {
+		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]);
+
+		if (dev->gro_ipv4_max_size ^ gro_max_size) {
+			netif_set_gro_ipv4_max_size(dev, gro_max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_OPERSTATE])
 		set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]));
 
@@ -3325,6 +3354,10 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 	if (tb[IFLA_GRO_MAX_SIZE])
 		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
+	if (tb[IFLA_GSO_IPV4_MAX_SIZE])
+		netif_set_gso_ipv4_max_size(dev, nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]));
+	if (tb[IFLA_GRO_IPV4_MAX_SIZE])
+		netif_set_gro_ipv4_max_size(dev, nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]));
 
 	return dev;
 }
-- 
2.31.1

