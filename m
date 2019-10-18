Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B537EDBC8D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504296AbfJRFGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:06:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43987 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504043AbfJRFGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:06:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id f21so2247159plj.10;
        Thu, 17 Oct 2019 22:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TCMqo1bzjd5t8QP9CMHm+x8fzH1KL/PG6H6lSp0PHdI=;
        b=H8TLl1YB5AiyfqoxV98BgfWUScF35a/A1zSICZ1FmYKBecdazHllGEt9tIqGZSt0L8
         O2okt5M4+Qy1DOYxqE+XfMHE+6PByrFGt89orBT2kiiMwrh3rlDiY8CYaDs2brOyOFli
         0rYwmr3R3chZtXWgx6T/VkAWUvhCObb3Eqj4bzyh1SMDnREJS/O3ryzBJdTeJLchEva+
         XJHlO98hYh4j/D2ZBUUxWJFDq++vmZ+O7SLharTDVtEIEShSod6YlagXV0aNaXVVhMO/
         ZajM5RlGzkVZGi5XXFQptSgZu/Oy3xAPorIX3Nk3trj8pbXleP5f4EfmKQOGKFeE0yOP
         7cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TCMqo1bzjd5t8QP9CMHm+x8fzH1KL/PG6H6lSp0PHdI=;
        b=alNmr1+zltmVuPCz0qvzinw0vSmm47RxefCMtMFwY5vfuW0S53cwVroOxwb5EuYMnk
         q2Qt6/ZdQl8v9r/HKd+ub//EVHZFAuBkRJAtpQqJYoTyeD6xoY/vOoAMfJiUBp9HhEHb
         AkGQ5t+k40/led4saTQAroURCetQFGQQ2IZoPyQbRf+tZdahrGu/J1K5TWLC/asAm2q/
         C237Q13Y2qIyOQ6ryJRujWnaWUhOMvVlh3zh7FR+4hsKhRrwDu2B0PSljet5XNExYQQh
         Q2Bxi/NMr4uBzN1ROGvN0BmF6mYmST8Zl1PDCQIzG3LXUX+FourFRUdc9HOKDYlFD35d
         F38Q==
X-Gm-Message-State: APjAAAW2J2W0ogX1qpWf7qRLeLAEgKQfr5Cch1PqcPqLhtpcUPhi+lo7
        a3xWEJhippg2Mfe8YXmtYQDnKBn2
X-Google-Smtp-Source: APXvYqwDC0PoSaJlI1G8s8m1E9AJ5ROywf7OJ2mIOZJAyEzGw5mFRuaNDlJCEwq+Q79TXDlnKc5UXw==
X-Received: by 2002:a17:902:724b:: with SMTP id c11mr7643993pll.155.1571371750717;
        Thu, 17 Oct 2019 21:09:10 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:09:10 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 10/15] xdp_flow: Add netdev feature for enabling flow offload to XDP
Date:   Fri, 18 Oct 2019 13:07:43 +0900
Message-Id: <20191018040748.30593-11-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage would be like this:

 $ ethtool -K eth0 flow-offload-xdp on
 $ tc qdisc add dev eth0 clsact
 $ tc filter add dev eth0 ingress protocol ip flower ...

Then the filters offloaded to XDP are marked as "in_hw".

xdp_flow is using the indirect block mechanism to handle the newly added
feature.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/linux/netdev_features.h  |  2 ++
 net/core/dev.c                   |  2 ++
 net/core/ethtool.c               |  1 +
 net/xdp_flow/xdp_flow.h          |  5 ++++
 net/xdp_flow/xdp_flow_core.c     | 55 +++++++++++++++++++++++++++++++++++++++-
 net/xdp_flow/xdp_flow_kern_mod.c |  6 +++++
 6 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 4b19c54..1063511 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -80,6 +80,7 @@ enum {
 
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
+	NETIF_F_XDP_FLOW_BIT,		/* Offload flow to XDP */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -150,6 +151,7 @@ enum {
 #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
+#define NETIF_F_XDP_FLOW	__NETIF_F(XDP_FLOW)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/net/core/dev.c b/net/core/dev.c
index 9965675..62e0469 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9035,6 +9035,8 @@ int register_netdevice(struct net_device *dev)
 	 * software offloads (GSO and GRO).
 	 */
 	dev->hw_features |= NETIF_F_SOFT_FEATURES;
+	if (IS_ENABLED(CONFIG_XDP_FLOW) && dev->netdev_ops->ndo_bpf)
+		dev->hw_features |= NETIF_F_XDP_FLOW;
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->netdev_ops->ndo_udp_tunnel_add) {
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index c763106..200aa96 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -111,6 +111,7 @@ int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
+	[NETIF_F_XDP_FLOW_BIT] =	 "flow-offload-xdp",
 };
 
 static const char
diff --git a/net/xdp_flow/xdp_flow.h b/net/xdp_flow/xdp_flow.h
index 656ceab..58f8a229 100644
--- a/net/xdp_flow/xdp_flow.h
+++ b/net/xdp_flow/xdp_flow.h
@@ -20,4 +20,9 @@ struct xdp_flow_umh_ops {
 
 extern struct xdp_flow_umh_ops xdp_flow_ops;
 
+static inline bool xdp_flow_enabled(const struct net_device *dev)
+{
+	return dev->features & NETIF_F_XDP_FLOW;
+}
+
 #endif
diff --git a/net/xdp_flow/xdp_flow_core.c b/net/xdp_flow/xdp_flow_core.c
index 8265aef..f402427 100644
--- a/net/xdp_flow/xdp_flow_core.c
+++ b/net/xdp_flow/xdp_flow_core.c
@@ -20,7 +20,8 @@ static void xdp_flow_block_release(void *cb_priv)
 	mutex_unlock(&xdp_flow_ops.lock);
 }
 
-int xdp_flow_setup_block(struct net_device *dev, struct flow_block_offload *f)
+static int xdp_flow_setup_block(struct net_device *dev,
+				struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
 	int err = 0;
@@ -32,6 +33,9 @@ int xdp_flow_setup_block(struct net_device *dev, struct flow_block_offload *f)
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
+	if (f->command == FLOW_BLOCK_BIND && !xdp_flow_enabled(dev))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&xdp_flow_ops.lock);
 	if (!xdp_flow_ops.module) {
 		mutex_unlock(&xdp_flow_ops.lock);
@@ -105,6 +109,50 @@ int xdp_flow_setup_block(struct net_device *dev, struct flow_block_offload *f)
 	return err;
 }
 
+static int xdp_flow_indr_setup_cb(struct net_device *dev, void *cb_priv,
+				  enum tc_setup_type type, void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return xdp_flow_setup_block(dev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int xdp_flow_netdevice_event(struct notifier_block *nb,
+				    unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int err;
+
+	if (!dev->netdev_ops->ndo_bpf)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		err = __flow_indr_block_cb_register(dev, NULL,
+						    xdp_flow_indr_setup_cb,
+						    dev);
+		if (err) {
+			netdev_err(dev,
+				   "Failed to register indirect block setup callback: %d\n",
+				   err);
+		}
+		break;
+	case NETDEV_UNREGISTER:
+		__flow_indr_block_cb_unregister(dev, xdp_flow_indr_setup_cb,
+						dev);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xdp_flow_notifier_block __read_mostly = {
+	.notifier_call = xdp_flow_netdevice_event,
+};
+
 static void xdp_flow_umh_cleanup(struct umh_info *info)
 {
 	mutex_lock(&xdp_flow_ops.lock);
@@ -117,6 +165,11 @@ static void xdp_flow_umh_cleanup(struct umh_info *info)
 
 static int __init xdp_flow_init(void)
 {
+	int err = register_netdevice_notifier(&xdp_flow_notifier_block);
+
+	if (err)
+		return err;
+
 	mutex_init(&xdp_flow_ops.lock);
 	xdp_flow_ops.stop = true;
 	xdp_flow_ops.info.cmdline = "xdp_flow_umh";
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index e70a86a..ce8a75b 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -335,6 +335,12 @@ static int xdp_flow_replace(struct net_device *dev, struct flow_cls_offload *f)
 	struct mbox_request *req;
 	int err;
 
+	if (!xdp_flow_enabled(dev)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "flow-offload-xdp is disabled on net device");
+		return -EOPNOTSUPP;
+	}
+
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
-- 
1.8.3.1

