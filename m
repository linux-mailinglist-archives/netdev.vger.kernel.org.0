Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9F31E5072
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgE0V0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0VZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CC0C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 131so4065284pfv.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6E0CuAmzrqLV/5FlkXuNCBuYTLkJT9/8lpXxATFVnBI=;
        b=N1M6Sve44HQjNEA3CnnD+zRdnDl9MX1zAOCDEiNkg8gerUxNw7vTgHoL0OWT6JDYuW
         Xh+A2YhxDks4CrhT6CimzkU1yA1q2V8/hrbzooVh3uGF/eAgw9kGpo1lxjx/kY/7UKDR
         IUipi+vbfh+WtEamZkxwcc/Kht49T6wB+JTyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6E0CuAmzrqLV/5FlkXuNCBuYTLkJT9/8lpXxATFVnBI=;
        b=IzBwdgS/qYbIFdjrXWkJR8NHgAjtTBDTbbnLwJMCxCPAp1Mo95h5jGssArZs11Y+cu
         OyrlohdTc6wpaGQAWrVYyxtPmLok5uoN5WTNYV8XiR5KqvxxzUFGC5dEFicSuDlLLjDu
         yKqAPSAkGhL8cfIWLRrefGR6zl6Ot63t7ncELQReSMBUNEUwqf3Ow9SHwJJUauWOomPk
         9QSaSG80TMVHzfJKsqx4S589uIpF7rSj460vVZ0Z9kR8e7BtwQ68ormeoXWvFo6Fbn8L
         FPQN9KfZrbqxYVsQj9Pdioe3fyGKPUWGoDKZboEGZuC54E0Ep7wtkBNH+rteEvHJ+hR0
         ADMA==
X-Gm-Message-State: AOAM532DrKe4ZHXlUvb+LqDjVaXZdzLSOKPc0CQt/HTjau6pZgqthpxz
        l2Lfj7K3M6WCw41G1ycjd3v9A0v3ONc0DYhMZiRmHp6RyTBeRTCBCJZtMCkXIl+UbOUswruV+sI
        ZRS0cCRbKq61BU6HFPI6TwDyvg4QJSeO5OzK8HkkfgDIn5FBlZxv8van5Lv/QX0LYiPynw1rI
X-Google-Smtp-Source: ABdhPJwq26CJ8jw8c7qF0PVUcjRrsmW/+Ndfal810fHE4wn8laPLNjpMxNvJvvxQTmMTste31CBYfA==
X-Received: by 2002:a62:168b:: with SMTP id 133mr6036399pfw.137.1590614758678;
        Wed, 27 May 2020 14:25:58 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:58 -0700 (PDT)
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
Subject: [RFC PATCH net-next 06/11] net: l2tp_eth: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
Date:   Wed, 27 May 2020 14:25:07 -0700
Message-Id: <20200527212512.17901-7-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constrain the MTU of upper VLAN devices if the MTU of the L2TP Ethernet
device is configured to its default optimal size, which does not leave
space for a nested VLAN tag without causing fragmentation.

Refactor l2tp_eth_adjust_mtu() so that it can also be used to determine
the optimal size when the L2TP device's MTU is changed. This function
needed to move before the net_device_ops definition in order to avoid a
forward declaration, but instead the definition of net_device_ops is
moved so that the refactoring changes are better represented in the
diff.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 net/l2tp/l2tp_eth.c | 114 ++++++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 51 deletions(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index fd5ac2788e45..6fbb900bc3d1 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -103,28 +103,6 @@ static void l2tp_eth_get_stats64(struct net_device *dev,
 
 }
 
-static const struct net_device_ops l2tp_eth_netdev_ops = {
-	.ndo_init		= l2tp_eth_dev_init,
-	.ndo_uninit		= l2tp_eth_dev_uninit,
-	.ndo_start_xmit		= l2tp_eth_dev_xmit,
-	.ndo_get_stats64	= l2tp_eth_get_stats64,
-	.ndo_set_mac_address	= eth_mac_addr,
-};
-
-static struct device_type l2tpeth_type = {
-	.name = "l2tpeth",
-};
-
-static void l2tp_eth_dev_setup(struct net_device *dev)
-{
-	SET_NETDEV_DEVTYPE(dev, &l2tpeth_type);
-	ether_setup(dev);
-	dev->priv_flags		&= ~IFF_TX_SKB_SHARING;
-	dev->features		|= NETIF_F_LLTX;
-	dev->netdev_ops		= &l2tp_eth_netdev_ops;
-	dev->needs_free_netdev	= true;
-}
-
 static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb, int data_len)
 {
 	struct l2tp_eth_sess *spriv = l2tp_session_priv(session);
@@ -215,44 +193,73 @@ static void l2tp_eth_show(struct seq_file *m, void *arg)
 	dev_put(dev);
 }
 
-static void l2tp_eth_adjust_mtu(struct l2tp_tunnel *tunnel,
-				struct l2tp_session *session,
-				struct net_device *dev)
+static unsigned int l2tp_eth_best_mtu(struct net_device *dev)
 {
-	unsigned int overhead = 0;
-	u32 l3_overhead = 0;
-	u32 mtu;
+	struct l2tp_eth *priv = netdev_priv(dev);
+	struct l2tp_session *session = priv->session;
+	struct l2tp_tunnel *tunnel = session->tunnel;
+	unsigned int mtu, overhead = 0;
 
-	/* if the encap is UDP, account for UDP header size */
-	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
-		overhead += sizeof(struct udphdr);
-		dev->needed_headroom += sizeof(struct udphdr);
+	if (tunnel->sock) {
+		lock_sock(tunnel->sock);
+		overhead = kernel_sock_ip_overhead(tunnel->sock);
+		release_sock(tunnel->sock);
 	}
 
-	lock_sock(tunnel->sock);
-	l3_overhead = kernel_sock_ip_overhead(tunnel->sock);
-	release_sock(tunnel->sock);
-
-	if (l3_overhead == 0) {
+	if (overhead == 0) {
 		/* L3 Overhead couldn't be identified, this could be
 		 * because tunnel->sock was NULL or the socket's
 		 * address family was not IPv4 or IPv6,
-		 * dev mtu stays at 1500.
+		 * assume existing MTU is best
 		 */
-		return;
+		return dev->mtu;
 	}
-	/* Adjust MTU, factor overhead - underlay L3, overlay L2 hdr
-	 * UDP overhead, if any, was already factored in above.
-	 */
-	overhead += session->hdr_len + ETH_HLEN + l3_overhead;
 
+	/* if the encap is UDP, account for UDP header size */
+	if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
+		overhead += sizeof(struct udphdr);
+
+	/* Maximize MTU, factor in overhead - overlay L2 and Geneve header.
+	 * UDP overhead, if any, and underlay L3 already factored in above.
+	 */
+	overhead += session->hdr_len + ETH_HLEN;
 	mtu = l2tp_tunnel_dst_mtu(tunnel) - overhead;
 	if (mtu < dev->min_mtu || mtu > dev->max_mtu)
-		dev->mtu = ETH_DATA_LEN - overhead;
-	else
-		dev->mtu = mtu;
+		mtu = ETH_DATA_LEN - overhead;
 
-	dev->needed_headroom += session->hdr_len;
+	return mtu;
+}
+
+static int l2tp_eth_change_mtu(struct net_device *dev, int new_mtu)
+{
+	unsigned int best_mtu = l2tp_eth_best_mtu(dev);
+
+	dev->mtu = new_mtu;
+	__vlan_constrain_mtu(dev, best_mtu);
+	return 0;
+}
+
+static const struct net_device_ops l2tp_eth_netdev_ops = {
+	.ndo_init		= l2tp_eth_dev_init,
+	.ndo_uninit		= l2tp_eth_dev_uninit,
+	.ndo_start_xmit		= l2tp_eth_dev_xmit,
+	.ndo_get_stats64	= l2tp_eth_get_stats64,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_change_mtu		= l2tp_eth_change_mtu,
+};
+
+static struct device_type l2tpeth_type = {
+	.name = "l2tpeth",
+};
+
+static void l2tp_eth_dev_setup(struct net_device *dev)
+{
+	SET_NETDEV_DEVTYPE(dev, &l2tpeth_type);
+	ether_setup(dev);
+	dev->priv_flags		&= ~IFF_TX_SKB_SHARING;
+	dev->features		|= NETIF_F_LLTX;
+	dev->netdev_ops		= &l2tp_eth_netdev_ops;
+	dev->needs_free_netdev	= true;
 }
 
 static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
@@ -289,14 +296,19 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 		goto err_sess;
 	}
 
-	dev_net_set(dev, net);
-	dev->min_mtu = 0;
-	dev->max_mtu = ETH_MAX_MTU;
-	l2tp_eth_adjust_mtu(tunnel, session, dev);
+	if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
+		dev->needed_headroom += sizeof(struct udphdr);
+	dev->needed_headroom += session->hdr_len;
 
 	priv = netdev_priv(dev);
 	priv->session = session;
 
+	dev_net_set(dev, net);
+	dev->min_mtu = 0;
+	dev->max_mtu = ETH_MAX_MTU;
+	dev->mtu = l2tp_eth_best_mtu(dev);
+	dev->priv_flags |= IFF_NO_VLAN_ROOM;
+
 	session->recv_skb = l2tp_eth_dev_recv;
 	session->session_close = l2tp_eth_delete;
 	if (IS_ENABLED(CONFIG_L2TP_DEBUGFS))
-- 
2.26.2

