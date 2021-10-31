Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133F1440F3F
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 17:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhJaQCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 12:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhJaQCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 12:02:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A620C061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 09:00:16 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v20so10021248plo.7
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 09:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nsoQm61XwooDzoHknLfUlXWBRrfXg9ySglsxjMSIs/Y=;
        b=UnVHXnwG56pgtnd1buv/bpjNG8DkhQMN6cpS0n98z8sneM4n2u4zk81tx/BtulLnTS
         V5+UcJlKA7G5qLI7VqreYYDygyFfGqeSIdtM0iXjeFD45B5tv6ZzbLvFIqc6ozghlxZP
         SYJvVop8xxNt9IJdShNDAuzKVcXxoy4WlaHa1aaxNJ9aL4Ujv+2vjFv07RGQoB1q8F8q
         EdGKOO1XmnYB+FMfJSstSuVmurYks0dx32WoIks78gcUrbEyxbdOrnO81hb5wUTYJDBu
         CzvBIWCelpv6tXPoRWET39ZKepz0CwhmOUJFJsnYaQaFWmQgU7+CiKNxmqq+9SBTdgss
         Qr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nsoQm61XwooDzoHknLfUlXWBRrfXg9ySglsxjMSIs/Y=;
        b=g1kYaxmBBWKfBNovVLPu7J4/scStaEu/ZF0a0PhfLxjeVIZXaFAayFFWWwSeBZHOGa
         H1Orycplw5Rx32XNlOjJerh6WonQsJoYq37oUX88KissNDyiioP49m0+xxTWNNSwdwsM
         5teE/iB+apfhKivmJOxcojTck3P4IUVoU1rGDolEXYWxRFYRA39zp9kDICEUElrrn0oq
         pDP0iTrml+6IbqB7ycrryre+nZ0G2rk93WEOyQ+Fah1paozIILamJwm2+49XF6Helfbs
         7btULiIWKKCVD9Zo2FCkw4L20gzulL5f3sJ2eoaGypuDHSjxmXseIn2RFNrZ1uLZslav
         cqvQ==
X-Gm-Message-State: AOAM533p65SgdY8FQpeqL42GwJBuOsNlaXm6PvybKR3ZN5xHZYgwye8J
        x7p54da4m50pkVwLHWsC8vY=
X-Google-Smtp-Source: ABdhPJwD+L7Pd7cQ46+DvOaafHTQWgEiqavkoVpPZNYLleDuW3W8PwRYeTpPs32E1hQ7LZ4q+KjTaw==
X-Received: by 2002:a17:90b:1e01:: with SMTP id pg1mr24168767pjb.81.1635696015406;
        Sun, 31 Oct 2021 09:00:15 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 1sm12297943pfl.133.2021.10.31.09.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 09:00:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v7 1/5] amt: add control plane of amt interface
Date:   Sun, 31 Oct 2021 16:00:02 +0000
Message-Id: <20211031160006.3367-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211031160006.3367-1-ap420073@gmail.com>
References: <20211031160006.3367-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It adds definitions and control plane code for AMT.
this is very similar to udp tunneling interfaces such as gtp, vxlan, etc.
In the next patch, data plane code will be added.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Eliminate sparse warnings.
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.
 - Fix compile error

v4 -> v5:
 - Remove unnecessary rcu_read_lock().
 - Remove unnecessary amt_change_mtu().
 - Change netlink error message.
 - Add validation for IFLA_AMT_LOCAL_IP and IFLA_AMT_DISCOVERY_IP.
 - Add comments in amt.h.
 - Add missing dev_put() in error path of amt_newlink().
 - Fix typo.

v5 -> v6:
 - Reset remote_ip in amt_dev_stop().

v6 -> v7:
 - Fix compile error.

 MAINTAINERS              |   8 +
 drivers/net/Kconfig      |  16 ++
 drivers/net/Makefile     |   1 +
 drivers/net/amt.c        | 493 +++++++++++++++++++++++++++++++++++++++
 include/net/amt.h        | 235 +++++++++++++++++++
 include/uapi/linux/amt.h |  62 +++++
 6 files changed, 815 insertions(+)
 create mode 100644 drivers/net/amt.c
 create mode 100644 include/net/amt.h
 create mode 100644 include/uapi/linux/amt.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b85f039fbf9..917f360b3ece 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1020,6 +1020,14 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/light/ams,as73211.yaml
 F:	drivers/iio/light/as73211.c
 
+AMT (Automatic Multicast Tunneling)
+M:	Taehee Yoo <ap420073@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
+F:	drivers/net/amt.c
+
 ANALOG DEVICES INC AD7192 DRIVER
 M:	Alexandru Tachici <alexandru.tachici@analog.com>
 L:	linux-iio@vger.kernel.org
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dd335ae1122b..034dbd487c33 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -291,6 +291,22 @@ config GTP
 	  To compile this drivers as a module, choose M here: the module
 	  will be called gtp.
 
+config AMT
+	tristate "Automatic Multicast Tunneling (AMT)"
+	depends on INET && IP_MULTICAST
+	select NET_UDP_TUNNEL
+	help
+	  This allows one to create AMT(Automatic Multicast Tunneling)
+	  virtual interfaces that provide multicast tunneling.
+	  There are two roles, Gateway, and Relay.
+	  Gateway Encapsulates IGMP/MLD traffic from listeners to the Relay.
+	  Gateway Decapsulates multicast traffic from the Relay to Listeners.
+	  Relay Encapsulates multicast traffic from Sources to Gateway.
+	  Relay Decapsulates IGMP/MLD traffic from Gateway.
+
+	  To compile this drivers as a module, choose M here: the module
+	  will be called amt.
+
 config MACSEC
 	tristate "IEEE 802.1AE MAC-level encryption (MACsec)"
 	select CRYPTO
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 739838623cf6..50b23e71065f 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_WIREGUARD) += wireguard/
 obj-$(CONFIG_EQUALIZER) += eql.o
 obj-$(CONFIG_IFB) += ifb.o
 obj-$(CONFIG_MACSEC) += macsec.o
+obj-$(CONFIG_AMT) += amt.o
 obj-$(CONFIG_MACVLAN) += macvlan.o
 obj-$(CONFIG_MACVTAP) += macvtap.o
 obj-$(CONFIG_MII) += mii.o
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
new file mode 100644
index 000000000000..addab3b1de0a
--- /dev/null
+++ b/drivers/net/amt.c
@@ -0,0 +1,493 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com> */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/udp.h>
+#include <linux/jhash.h>
+#include <linux/if_tunnel.h>
+#include <linux/net.h>
+#include <linux/igmp.h>
+#include <linux/workqueue.h>
+#include <net/net_namespace.h>
+#include <net/protocol.h>
+#include <net/ip.h>
+#include <net/udp.h>
+#include <net/udp_tunnel.h>
+#include <net/icmp.h>
+#include <net/mld.h>
+#include <net/amt.h>
+#include <uapi/linux/amt.h>
+#include <linux/security.h>
+#include <net/gro_cells.h>
+#include <net/ipv6.h>
+#include <net/protocol.h>
+#include <net/if_inet6.h>
+#include <net/ndisc.h>
+#include <net/addrconf.h>
+#include <net/ip6_route.h>
+#include <net/inet_common.h>
+
+static struct workqueue_struct *amt_wq;
+
+static struct socket *amt_create_sock(struct net *net, __be16 port)
+{
+	struct udp_port_cfg udp_conf;
+	struct socket *sock;
+	int err;
+
+	memset(&udp_conf, 0, sizeof(udp_conf));
+	udp_conf.family = AF_INET;
+	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
+
+	udp_conf.local_udp_port = port;
+
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	return sock;
+}
+
+static int amt_socket_create(struct amt_dev *amt)
+{
+	struct udp_tunnel_sock_cfg tunnel_cfg;
+	struct socket *sock;
+
+	sock = amt_create_sock(amt->net, amt->relay_port);
+	if (IS_ERR(sock))
+		return PTR_ERR(sock);
+
+	/* Mark socket as an encapsulation socket */
+	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
+	tunnel_cfg.sk_user_data = amt;
+	tunnel_cfg.encap_type = 1;
+	tunnel_cfg.encap_destroy = NULL;
+	setup_udp_tunnel_sock(amt->net, sock, &tunnel_cfg);
+
+	rcu_assign_pointer(amt->sock, sock);
+	return 0;
+}
+
+static int amt_dev_open(struct net_device *dev)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+	int err;
+
+	amt->ready4 = false;
+	amt->ready6 = false;
+
+	err = amt_socket_create(amt);
+	if (err)
+		return err;
+
+	amt->req_cnt = 0;
+	amt->remote_ip = 0;
+	get_random_bytes(&amt->key, sizeof(siphash_key_t));
+
+	amt->status = AMT_STATUS_INIT;
+	return err;
+}
+
+static int amt_dev_stop(struct net_device *dev)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+	struct socket *sock;
+
+	/* shutdown */
+	sock = rtnl_dereference(amt->sock);
+	RCU_INIT_POINTER(amt->sock, NULL);
+	synchronize_net();
+	if (sock)
+		udp_tunnel_sock_release(sock);
+
+	amt->ready4 = false;
+	amt->ready6 = false;
+	amt->req_cnt = 0;
+	amt->remote_ip = 0;
+
+	return 0;
+}
+
+static const struct device_type amt_type = {
+	.name = "amt",
+};
+
+static int amt_dev_init(struct net_device *dev)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+	int err;
+
+	amt->dev = dev;
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
+
+	err = gro_cells_init(&amt->gro_cells, dev);
+	if (err) {
+		free_percpu(dev->tstats);
+		return err;
+	}
+
+	return 0;
+}
+
+static void amt_dev_uninit(struct net_device *dev)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+
+	gro_cells_destroy(&amt->gro_cells);
+	free_percpu(dev->tstats);
+}
+
+static const struct net_device_ops amt_netdev_ops = {
+	.ndo_init               = amt_dev_init,
+	.ndo_uninit             = amt_dev_uninit,
+	.ndo_open		= amt_dev_open,
+	.ndo_stop		= amt_dev_stop,
+	.ndo_get_stats64        = dev_get_tstats64,
+};
+
+static void amt_link_setup(struct net_device *dev)
+{
+	dev->netdev_ops         = &amt_netdev_ops;
+	dev->needs_free_netdev  = true;
+	SET_NETDEV_DEVTYPE(dev, &amt_type);
+	dev->min_mtu		= ETH_MIN_MTU;
+	dev->max_mtu		= ETH_MAX_MTU;
+	dev->type		= ARPHRD_NONE;
+	dev->flags		= IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
+	dev->hard_header_len	= 0;
+	dev->addr_len		= 0;
+	dev->priv_flags		|= IFF_NO_QUEUE;
+	dev->features		|= NETIF_F_LLTX;
+	dev->features		|= NETIF_F_GSO_SOFTWARE;
+	dev->features		|= NETIF_F_NETNS_LOCAL;
+	dev->hw_features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->hw_features	|= NETIF_F_FRAGLIST | NETIF_F_RXCSUM;
+	dev->hw_features	|= NETIF_F_GSO_SOFTWARE;
+	eth_hw_addr_random(dev);
+	eth_zero_addr(dev->broadcast);
+	ether_setup(dev);
+}
+
+static const struct nla_policy amt_policy[IFLA_AMT_MAX + 1] = {
+	[IFLA_AMT_MODE]		= { .type = NLA_U32 },
+	[IFLA_AMT_RELAY_PORT]	= { .type = NLA_U16 },
+	[IFLA_AMT_GATEWAY_PORT]	= { .type = NLA_U16 },
+	[IFLA_AMT_LINK]		= { .type = NLA_U32 },
+	[IFLA_AMT_LOCAL_IP]	= { .len = sizeof_field(struct iphdr, daddr) },
+	[IFLA_AMT_REMOTE_IP]	= { .len = sizeof_field(struct iphdr, daddr) },
+	[IFLA_AMT_DISCOVERY_IP]	= { .len = sizeof_field(struct iphdr, daddr) },
+	[IFLA_AMT_MAX_TUNNELS]	= { .type = NLA_U32 },
+};
+
+static int amt_validate(struct nlattr *tb[], struct nlattr *data[],
+			struct netlink_ext_ack *extack)
+{
+	if (!data)
+		return -EINVAL;
+
+	if (!data[IFLA_AMT_LINK]) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_LINK],
+				    "Link attribute is required");
+		return -EINVAL;
+	}
+
+	if (!data[IFLA_AMT_MODE]) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_MODE],
+				    "Mode attribute is required");
+		return -EINVAL;
+	}
+
+	if (nla_get_u32(data[IFLA_AMT_MODE]) > AMT_MODE_MAX) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_MODE],
+				    "Mode attribute is not valid");
+		return -EINVAL;
+	}
+
+	if (!data[IFLA_AMT_LOCAL_IP]) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_DISCOVERY_IP],
+				    "Local attribute is required");
+		return -EINVAL;
+	}
+
+	if (!data[IFLA_AMT_DISCOVERY_IP] &&
+	    nla_get_u32(data[IFLA_AMT_MODE]) == AMT_MODE_GATEWAY) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_LOCAL_IP],
+				    "Discovery attribute is required");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int amt_newlink(struct net *net, struct net_device *dev,
+		       struct nlattr *tb[], struct nlattr *data[],
+		       struct netlink_ext_ack *extack)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+	int err = -EINVAL;
+
+	amt->net = net;
+	amt->mode = nla_get_u32(data[IFLA_AMT_MODE]);
+
+	if (data[IFLA_AMT_MAX_TUNNELS])
+		amt->max_tunnels = nla_get_u32(data[IFLA_AMT_MAX_TUNNELS]);
+	else
+		amt->max_tunnels = AMT_MAX_TUNNELS;
+
+	spin_lock_init(&amt->lock);
+	amt->max_groups = AMT_MAX_GROUP;
+	amt->max_sources = AMT_MAX_SOURCE;
+	amt->hash_buckets = AMT_HSIZE;
+	amt->nr_tunnels = 0;
+	get_random_bytes(&amt->hash_seed, sizeof(amt->hash_seed));
+	amt->stream_dev = dev_get_by_index(net,
+					   nla_get_u32(data[IFLA_AMT_LINK]));
+	if (!amt->stream_dev) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_LINK],
+				    "Can't find stream device");
+		return -ENODEV;
+	}
+
+	if (amt->stream_dev->type != ARPHRD_ETHER) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_LINK],
+				    "Invalid stream device type");
+		goto err;
+	}
+
+	amt->local_ip = nla_get_in_addr(data[IFLA_AMT_LOCAL_IP]);
+	if (ipv4_is_loopback(amt->local_ip) ||
+	    ipv4_is_zeronet(amt->local_ip) ||
+	    ipv4_is_multicast(amt->local_ip)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_LOCAL_IP],
+				    "Invalid Local address");
+		goto err;
+	}
+
+	if (data[IFLA_AMT_RELAY_PORT])
+		amt->relay_port = nla_get_be16(data[IFLA_AMT_RELAY_PORT]);
+	else
+		amt->relay_port = htons(IANA_AMT_UDP_PORT);
+
+	if (data[IFLA_AMT_GATEWAY_PORT])
+		amt->gw_port = nla_get_be16(data[IFLA_AMT_GATEWAY_PORT]);
+	else
+		amt->gw_port = htons(IANA_AMT_UDP_PORT);
+
+	if (!amt->relay_port) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
+				    "relay port must not be 0");
+		goto err;
+	}
+	if (amt->mode == AMT_MODE_RELAY) {
+		amt->qrv = amt->net->ipv4.sysctl_igmp_qrv;
+		amt->qri = 10;
+		dev->needed_headroom = amt->stream_dev->needed_headroom +
+				       AMT_RELAY_HLEN;
+		dev->mtu = amt->stream_dev->mtu - AMT_RELAY_HLEN;
+		dev->max_mtu = dev->mtu;
+		dev->min_mtu = ETH_MIN_MTU + AMT_RELAY_HLEN;
+	} else {
+		if (!data[IFLA_AMT_DISCOVERY_IP]) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
+					    "discovery must be set in gateway mode");
+			goto err;
+		}
+		if (!amt->gw_port) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
+					    "gateway port must not be 0");
+			goto err;
+		}
+		amt->remote_ip = 0;
+		amt->discovery_ip = nla_get_in_addr(data[IFLA_AMT_DISCOVERY_IP]);
+		if (ipv4_is_loopback(amt->discovery_ip) ||
+		    ipv4_is_zeronet(amt->discovery_ip) ||
+		    ipv4_is_multicast(amt->discovery_ip)) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
+					    "discovery must be unicast");
+			goto err;
+		}
+
+		dev->needed_headroom = amt->stream_dev->needed_headroom +
+				       AMT_GW_HLEN;
+		dev->mtu = amt->stream_dev->mtu - AMT_GW_HLEN;
+		dev->max_mtu = dev->mtu;
+		dev->min_mtu = ETH_MIN_MTU + AMT_GW_HLEN;
+	}
+	amt->qi = AMT_INIT_QUERY_INTERVAL;
+
+	err = register_netdevice(dev);
+	if (err < 0) {
+		netdev_dbg(dev, "failed to register new netdev %d\n", err);
+		goto err;
+	}
+
+	err = netdev_upper_dev_link(amt->stream_dev, dev, extack);
+	if (err < 0) {
+		unregister_netdevice(dev);
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_put(amt->stream_dev);
+	return err;
+}
+
+static void amt_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+
+	unregister_netdevice_queue(dev, head);
+	netdev_upper_dev_unlink(amt->stream_dev, dev);
+	dev_put(amt->stream_dev);
+}
+
+static size_t amt_get_size(const struct net_device *dev)
+{
+	return nla_total_size(sizeof(__u32)) + /* IFLA_AMT_MODE */
+	       nla_total_size(sizeof(__u16)) + /* IFLA_AMT_RELAY_PORT */
+	       nla_total_size(sizeof(__u16)) + /* IFLA_AMT_GATEWAY_PORT */
+	       nla_total_size(sizeof(__u32)) + /* IFLA_AMT_LINK */
+	       nla_total_size(sizeof(__u32)) + /* IFLA_MAX_TUNNELS */
+	       nla_total_size(sizeof(struct iphdr)) + /* IFLA_AMT_DISCOVERY_IP */
+	       nla_total_size(sizeof(struct iphdr)) + /* IFLA_AMT_REMOTE_IP */
+	       nla_total_size(sizeof(struct iphdr)); /* IFLA_AMT_LOCAL_IP */
+}
+
+static int amt_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+
+	if (nla_put_u32(skb, IFLA_AMT_MODE, amt->mode))
+		goto nla_put_failure;
+	if (nla_put_be16(skb, IFLA_AMT_RELAY_PORT, amt->relay_port))
+		goto nla_put_failure;
+	if (nla_put_be16(skb, IFLA_AMT_GATEWAY_PORT, amt->gw_port))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_AMT_LINK, amt->stream_dev->ifindex))
+		goto nla_put_failure;
+	if (nla_put_in_addr(skb, IFLA_AMT_LOCAL_IP, amt->local_ip))
+		goto nla_put_failure;
+	if (nla_put_in_addr(skb, IFLA_AMT_DISCOVERY_IP, amt->discovery_ip))
+		goto nla_put_failure;
+	if (amt->remote_ip)
+		if (nla_put_in_addr(skb, IFLA_AMT_REMOTE_IP, amt->remote_ip))
+			goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_AMT_MAX_TUNNELS, amt->max_tunnels))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static struct rtnl_link_ops amt_link_ops __read_mostly = {
+	.kind		= "amt",
+	.maxtype	= IFLA_AMT_MAX,
+	.policy		= amt_policy,
+	.priv_size	= sizeof(struct amt_dev),
+	.setup		= amt_link_setup,
+	.validate	= amt_validate,
+	.newlink	= amt_newlink,
+	.dellink	= amt_dellink,
+	.get_size       = amt_get_size,
+	.fill_info      = amt_fill_info,
+};
+
+static struct net_device *amt_lookup_upper_dev(struct net_device *dev)
+{
+	struct net_device *upper_dev;
+	struct amt_dev *amt;
+
+	for_each_netdev(dev_net(dev), upper_dev) {
+		if (netif_is_amt(upper_dev)) {
+			amt = netdev_priv(upper_dev);
+			if (amt->stream_dev == dev)
+				return upper_dev;
+		}
+	}
+
+	return NULL;
+}
+
+static int amt_device_event(struct notifier_block *unused,
+			    unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net_device *upper_dev;
+	struct amt_dev *amt;
+	LIST_HEAD(list);
+	int new_mtu;
+
+	upper_dev = amt_lookup_upper_dev(dev);
+	if (!upper_dev)
+		return NOTIFY_DONE;
+	amt = netdev_priv(upper_dev);
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		amt_dellink(amt->dev, &list);
+		unregister_netdevice_many(&list);
+		break;
+	case NETDEV_CHANGEMTU:
+		if (amt->mode == AMT_MODE_RELAY)
+			new_mtu = dev->mtu - AMT_RELAY_HLEN;
+		else
+			new_mtu = dev->mtu - AMT_GW_HLEN;
+
+		dev_set_mtu(amt->dev, new_mtu);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block amt_notifier_block __read_mostly = {
+	.notifier_call = amt_device_event,
+};
+
+static int __init amt_init(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&amt_notifier_block);
+	if (err < 0)
+		goto err;
+
+	err = rtnl_link_register(&amt_link_ops);
+	if (err < 0)
+		goto unregister_notifier;
+
+	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 1);
+	if (!amt_wq)
+		goto rtnl_unregister;
+
+	return 0;
+
+rtnl_unregister:
+	rtnl_link_unregister(&amt_link_ops);
+unregister_notifier:
+	unregister_netdevice_notifier(&amt_notifier_block);
+err:
+	pr_err("error loading AMT module loaded\n");
+	return err;
+}
+late_initcall(amt_init);
+
+static void __exit amt_fini(void)
+{
+	rtnl_link_unregister(&amt_link_ops);
+	unregister_netdevice_notifier(&amt_notifier_block);
+	destroy_workqueue(amt_wq);
+}
+module_exit(amt_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Taehee Yoo <ap420073@gmail.com>");
+MODULE_ALIAS_RTNL_LINK("amt");
diff --git a/include/net/amt.h b/include/net/amt.h
new file mode 100644
index 000000000000..ce24ff823555
--- /dev/null
+++ b/include/net/amt.h
@@ -0,0 +1,235 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ */
+#ifndef _NET_AMT_H_
+#define _NET_AMT_H_
+
+#include <linux/siphash.h>
+#include <linux/jhash.h>
+
+enum amt_msg_type {
+	AMT_MSG_DISCOVERY = 1,
+	AMT_MSG_ADVERTISEMENT,
+	AMT_MSG_REQUEST,
+	AMT_MSG_MEMBERSHIP_QUERY,
+	AMT_MSG_MEMBERSHIP_UPDATE,
+	AMT_MSG_MULTICAST_DATA,
+	AMT_MSG_TEARDOWM,
+	__AMT_MSG_MAX,
+};
+
+#define AMT_MSG_MAX (__AMT_MSG_MAX - 1)
+
+enum amt_status {
+	AMT_STATUS_INIT,
+	AMT_STATUS_SENT_DISCOVERY,
+	AMT_STATUS_RECEIVED_DISCOVERY,
+	AMT_STATUS_SENT_ADVERTISEMENT,
+	AMT_STATUS_RECEIVED_ADVERTISEMENT,
+	AMT_STATUS_SENT_REQUEST,
+	AMT_STATUS_RECEIVED_REQUEST,
+	AMT_STATUS_SENT_QUERY,
+	AMT_STATUS_RECEIVED_QUERY,
+	AMT_STATUS_SENT_UPDATE,
+	AMT_STATUS_RECEIVED_UPDATE,
+	__AMT_STATUS_MAX,
+};
+
+#define AMT_STATUS_MAX (__AMT_STATUS_MAX - 1)
+
+struct amt_header_discovery {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u32	type:4,
+		version:4,
+		reserved:24;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u32	version:4,
+		type:4,
+		reserved:24;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+	__be32	nonce;
+} __packed;
+
+struct amt_header_advertisement {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u32	type:4,
+		version:4,
+		reserved:24;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u32	version:4,
+		type:4,
+		reserved:24;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+	__be32	nonce;
+	__be32	ip4;
+} __packed;
+
+struct amt_header_request {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u32	type:4,
+		version:4,
+		reserved1:7,
+		p:1,
+		reserved2:16;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u32	version:4,
+		type:4,
+		p:1,
+		reserved1:7,
+		reserved2:16;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+	__be32	nonce;
+} __packed;
+
+struct amt_header_membership_query {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u64	type:4,
+		version:4,
+		reserved:6,
+		l:1,
+		g:1,
+		response_mac:48;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u64	version:4,
+		type:4,
+		g:1,
+		l:1,
+		reserved:6,
+		response_mac:48;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+	__be32	nonce;
+} __packed;
+
+struct amt_header_membership_update {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u64	type:4,
+		version:4,
+		reserved:8,
+		response_mac:48;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u64	version:4,
+		type:4,
+		reserved:8,
+		response_mac:48;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+	__be32	nonce;
+} __packed;
+
+struct amt_header_mcast_data {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u16	type:4,
+		version:4,
+		reserved:8;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u16	version:4,
+		type:4,
+		reserved:8;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+} __packed;
+
+struct amt_gw_headers {
+	union {
+		struct amt_header_discovery discovery;
+		struct amt_header_request request;
+		struct amt_header_membership_update update;
+	};
+} __packed;
+
+struct amt_relay_headers {
+	union {
+		struct amt_header_advertisement advertisement;
+		struct amt_header_membership_query query;
+		struct amt_header_mcast_data data;
+	};
+} __packed;
+
+struct amt_dev {
+	struct net_device       *dev;
+	struct net_device       *stream_dev;
+	struct net		*net;
+	/* Global lock for amt device */
+	spinlock_t		lock;
+	/* Used only in relay mode */
+	struct list_head        tunnel_list;
+	struct gro_cells	gro_cells;
+
+	/* Protected by RTNL */
+	struct delayed_work     discovery_wq;
+	/* Protected by RTNL */
+	struct delayed_work     req_wq;
+	/* Protected by RTNL */
+	struct delayed_work     secret_wq;
+	/* AMT status */
+	enum amt_status		status;
+	/* Generated key */
+	siphash_key_t		key;
+	struct socket	  __rcu *sock;
+	u32			max_groups;
+	u32			max_sources;
+	u32			hash_buckets;
+	u32			hash_seed;
+	/* Default 128 */
+	u32                     max_tunnels;
+	/* Default 128 */
+	u32                     nr_tunnels;
+	/* Gateway or Relay mode */
+	u32                     mode;
+	/* Default 2268 */
+	__be16			relay_port;
+	/* Default 2268 */
+	__be16			gw_port;
+	/* Outer local ip */
+	__be32			local_ip;
+	/* Outer remote ip */
+	__be32			remote_ip;
+	/* Outer discovery ip */
+	__be32			discovery_ip;
+	/* Only used in gateway mode */
+	__be32			nonce;
+	/* Gateway sent request and received query */
+	bool			ready4;
+	bool			ready6;
+	u8			req_cnt;
+	u8			qi;
+	u64			qrv;
+	u64			qri;
+	/* Used only in gateway mode */
+	u64			mac:48,
+				reserved:16;
+};
+
+#define AMT_MAX_GROUP		32
+#define AMT_MAX_SOURCE		128
+#define AMT_HSIZE_SHIFT		8
+#define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
+
+#define AMT_INIT_QUERY_INTERVAL	125
+#define IANA_AMT_UDP_PORT	2268
+#define AMT_MAX_TUNNELS         128
+#define AMT_MAX_REQS		128
+#define AMT_GW_HLEN (sizeof(struct iphdr) + \
+		     sizeof(struct udphdr) + \
+		     sizeof(struct amt_gw_headers))
+#define AMT_RELAY_HLEN (sizeof(struct iphdr) + \
+		     sizeof(struct udphdr) + \
+		     sizeof(struct amt_relay_headers))
+
+static inline bool netif_is_amt(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops && !strcmp(dev->rtnl_link_ops->kind, "amt");
+}
+
+#endif /* _NET_AMT_H_ */
diff --git a/include/uapi/linux/amt.h b/include/uapi/linux/amt.h
new file mode 100644
index 000000000000..2dccff417195
--- /dev/null
+++ b/include/uapi/linux/amt.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ */
+#ifndef _UAPI_AMT_H_
+#define _UAPI_AMT_H_
+
+enum ifla_amt_mode {
+	/* AMT interface works as Gateway mode.
+	 * The Gateway mode encapsulates IGMP/MLD traffic and decapsulates
+	 * multicast traffic.
+	 */
+	AMT_MODE_GATEWAY = 0,
+	/* AMT interface works as Relay mode.
+	 * The Relay mode encapsulates multicast traffic and decapsulates
+	 * IGMP/MLD traffic.
+	 */
+	AMT_MODE_RELAY,
+	__AMT_MODE_MAX,
+};
+
+#define AMT_MODE_MAX (__AMT_MODE_MAX - 1)
+
+enum {
+	IFLA_AMT_UNSPEC,
+	/* This attribute specify mode etier Gateway or Relay. */
+	IFLA_AMT_MODE,
+	/* This attribute specify Relay port.
+	 * AMT interface is created as Gateway mode, this attribute is used
+	 * to specify relay(remote) port.
+	 * AMT interface is created as Relay mode, this attribute is used
+	 * as local port.
+	 */
+	IFLA_AMT_RELAY_PORT,
+	/* This attribute specify Gateway port.
+	 * AMT interface is created as Gateway mode, this attribute is used
+	 * as local port.
+	 * AMT interface is created as Relay mode, this attribute is not used.
+	 */
+	IFLA_AMT_GATEWAY_PORT,
+	/* This attribute specify physical device */
+	IFLA_AMT_LINK,
+	/* This attribute specify local ip address */
+	IFLA_AMT_LOCAL_IP,
+	/* This attribute specify Relay ip address.
+	 * So, this is not used by Relay.
+	 */
+	IFLA_AMT_REMOTE_IP,
+	/* This attribute specify Discovery ip address.
+	 * When Gateway get started, it send discovery message to find the
+	 * Relay's ip address.
+	 * So, this is not used by Relay.
+	 */
+	IFLA_AMT_DISCOVERY_IP,
+	/* This attribute specify number of maximum tunnel. */
+	IFLA_AMT_MAX_TUNNELS,
+	__IFLA_AMT_MAX,
+};
+
+#define IFLA_AMT_MAX (__IFLA_AMT_MAX - 1)
+
+#endif /* _UAPI_AMT_H_ */
-- 
2.17.1

