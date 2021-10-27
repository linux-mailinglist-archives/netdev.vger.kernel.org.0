Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9855743CDC7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242814AbhJ0Pkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbhJ0Pki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:40:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1B1C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:38:13 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so2365171pjb.3
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mv5pDkE0kLHyDm0wYiX/MgOngJ6OxitI4fkONZwtLP8=;
        b=aPwkeNPQlo60vacXF+akOtoVMnkYsLRnbSqlLiaOTqK3OedPaAfgZCdBacXeAnnt84
         3AUSAvs8o98OwYo3yBmsNFdJEInFH+Gu2cqt9ZvBdncoxwEQIP1NAhenITybxhgBpCZs
         /nJo5aZ/tnMorNPKc3D3CtS7GOIhhoRwE5XFrIIkZc8dn5dqaRzM2UvgIl2Snl2BmqWj
         oTZDb0/QXZ6g/JQBy7MvC/dl/fJKEqmW9GDMmkKB1qB2XZDDfN1LSrrX52qvP4lLnP/g
         HIKzvE+VtTkF/cCihf6mj2jZmhe4BM+Qi5r4qrGzmP+lT7jy0Nx3U/yrmXQkZOxgYY4R
         c0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mv5pDkE0kLHyDm0wYiX/MgOngJ6OxitI4fkONZwtLP8=;
        b=Lf8YZBQkiDe5NSPYC1vOgvbbyCf3t66PjWuqz5MdU+tH2Qr3XVY7QftzHXOSUt4Ge2
         +zVLsXhdArKJ52e78mZ34LQMxK2ufJlZp1G7Eamlv7xYy3Jc0JWQi7JMsuMVzGn2VjzO
         gpW7Bbj1EJC1HurGjVxxr5KFbt3oPSSzGa0qaCzlo5szC1fvtdATLltx+FfiWFTn6MAU
         t590pZEdxIijcibkYX6WP4aB4Q199ZcSmBg6wtTIDV29kVsK1afUrUGUqleeDnxUsXSc
         vSNYNrWJjoqc/O4B1GdYvJVTxE8e6wZMm7z7S2yNz0ZWX6BQvWMZa32fEcuHk9JfVPfg
         go3A==
X-Gm-Message-State: AOAM532cmUSjMKqS5DmGBVCiBrhstPRrbTGuY4czGg2+ZQkb4mNwBvv0
        UBUrwogXk8xfpwwavWdwKiYl+bFU4FWa8g==
X-Google-Smtp-Source: ABdhPJwBRzZtL7E+meMH8z/b+cTbCdz9w/ScA82/uzTVrjsNRK+NEq7HXRYwM17RlkwlNfqiktW4Ag==
X-Received: by 2002:a17:90b:2248:: with SMTP id hk8mr6598301pjb.102.1635349092977;
        Wed, 27 Oct 2021 08:38:12 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 11sm326116pfl.41.2021.10.27.08.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:38:12 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4 v4] amt: add control plane of amt interface
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, netdev@vger.kernel.org
Cc:     dkirjanov@suse.de
References: <20211026151016.25997-1-ap420073@gmail.com>
 <20211026151016.25997-2-ap420073@gmail.com>
 <ee2ef934-0387-6711-6f04-027db65d256d@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <3e8840f7-9927-0d20-65f6-89eb63fca79b@gmail.com>
Date:   Thu, 28 Oct 2021 00:38:08 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ee2ef934-0387-6711-6f04-027db65d256d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
Thank you so much for your review!

On 10/27/21 11:37 PM, David Ahern wrote:
 > On 10/26/21 9:10 AM, Taehee Yoo wrote:
 >> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 >> new file mode 100644
 >> index 000000000000..8d4782c66cde
 >> --- /dev/null
 >> +++ b/drivers/net/amt.c
 >> @@ -0,0 +1,487 @@
 >> +// SPDX-License-Identifier: GPL-2.0-or-later
 >> +/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com> */
 >> +
 >> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 >> +
 >> +#include <linux/module.h>
 >> +#include <linux/skbuff.h>
 >> +#include <linux/udp.h>
 >> +#include <linux/jhash.h>
 >> +#include <linux/if_tunnel.h>
 >> +#include <linux/net.h>
 >> +#include <linux/igmp.h>
 >> +#include <net/net_namespace.h>
 >> +#include <net/protocol.h>
 >> +#include <net/ip.h>
 >> +#include <net/udp.h>
 >> +#include <net/udp_tunnel.h>
 >> +#include <net/icmp.h>
 >> +#include <net/mld.h>
 >> +#include <net/amt.h>
 >> +#include <uapi/linux/amt.h>
 >> +#include <linux/security.h>
 >> +#include <net/gro_cells.h>
 >> +#include <net/ipv6.h>
 >> +#include <net/protocol.h>
 >> +#include <net/if_inet6.h>
 >> +#include <net/ndisc.h>
 >> +#include <net/addrconf.h>
 >> +#include <net/ip6_route.h>
 >> +#include <net/inet_common.h>
 >> +
 >> +static struct workqueue_struct *amt_wq;
 >> +
 >> +static struct socket *amt_create_sock(struct net *net, __be16 port)
 >> +{
 >> +	struct udp_port_cfg udp_conf;
 >> +	struct socket *sock;
 >> +	int err;
 >> +
 >> +	memset(&udp_conf, 0, sizeof(udp_conf));
 >> +	udp_conf.family = AF_INET;
 >> +	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
 >> +
 >> +	udp_conf.local_udp_port = port;
 >> +
 >> +	err = udp_sock_create(net, &udp_conf, &sock);
 >> +	if (err < 0)
 >> +		return ERR_PTR(err);
 >> +
 >> +	return sock;
 >> +}
 >> +
 >> +static int amt_socket_create(struct amt_dev *amt)
 >> +{
 >> +	struct udp_tunnel_sock_cfg tunnel_cfg;
 >> +	struct socket *sock;
 >> +
 >> +	sock = amt_create_sock(amt->net, amt->relay_port);
 >> +	if (IS_ERR(sock))
 >> +		return PTR_ERR(sock);
 >> +
 >> +	/* Mark socket as an encapsulation socket */
 >> +	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
 >> +	tunnel_cfg.sk_user_data = amt;
 >> +	tunnel_cfg.encap_type = 1;
 >> +	tunnel_cfg.encap_destroy = NULL;
 >> +	setup_udp_tunnel_sock(amt->net, sock, &tunnel_cfg);
 >> +
 >> +	rcu_assign_pointer(amt->sock, sock);
 >> +	return 0;
 >> +}
 >> +
 >> +static int amt_dev_open(struct net_device *dev)
 >> +{
 >> +	struct amt_dev *amt = netdev_priv(dev);
 >> +	int err;
 >> +
 >> +	amt->ready4 = false;
 >> +	amt->ready6 = false;
 >> +
 >> +	err = amt_socket_create(amt);
 >> +	if (err)
 >> +		return err;
 >> +
 >> +	spin_lock_bh(&amt->lock);
 >> +	amt->req_cnt = 0;
 >> +	get_random_bytes(&amt->key, sizeof(siphash_key_t));
 >> +	spin_unlock_bh(&amt->lock);
 >
 > why the amt dev lock here? dev_open is called with rtnl lock held and
 > the device will not be receiving packets yet (the _bh).
 >

I agree that I think it is not needed, so I will remove it.

 >> +
 >> +	amt->status = AMT_STATUS_INIT;
 >> +	return err;
 >> +}
 >> +
 >
 >> +
 >> +static int amt_change_mtu(struct net_device *dev, int new_mtu)
 >> +{
 >> +	if (new_mtu > dev->max_mtu)
 >> +		new_mtu = dev->max_mtu;
 >> +	else if (new_mtu < dev->min_mtu)
 >> +		new_mtu = dev->min_mtu;
 >
 > that is handled by dev_validate_mtu.
 >
 > Since you are not doing anything special here, I believe you do not need
 > the ndo_change_mtu at all.
 >

Okay, I will remove it too.

 >> +
 >> +	dev->mtu = new_mtu;
 >> +	return 0;
 >> +}
 >> +
 >> +static const struct net_device_ops amt_netdev_ops = {
 >> +	.ndo_init               = amt_dev_init,
 >> +	.ndo_uninit             = amt_dev_uninit,
 >> +	.ndo_open		= amt_dev_open,
 >> +	.ndo_stop		= amt_dev_stop,
 >> +	.ndo_get_stats64        = dev_get_tstats64,
 >> +	.ndo_change_mtu         = amt_change_mtu,
 >> +};
 >> +
 >> +static void amt_link_setup(struct net_device *dev)
 >> +{
 >> +	dev->netdev_ops         = &amt_netdev_ops;
 >> +	dev->needs_free_netdev  = true;
 >> +	SET_NETDEV_DEVTYPE(dev, &amt_type);
 >> +	dev->min_mtu		= ETH_MIN_MTU;
 >> +	dev->max_mtu		= ETH_MAX_MTU;
 >> +	dev->type		= ARPHRD_NONE;
 >> +	dev->flags		= IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 >> +	dev->hard_header_len	= 0;
 >> +	dev->addr_len		= 0;
 >> +	dev->priv_flags		|= IFF_NO_QUEUE;
 >> +	dev->features		|= NETIF_F_LLTX;
 >> +	dev->features		|= NETIF_F_GSO_SOFTWARE;
 >> +	dev->features		|= NETIF_F_NETNS_LOCAL;
 >> +	dev->hw_features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
 >> +	dev->hw_features	|= NETIF_F_FRAGLIST | NETIF_F_RXCSUM;
 >> +	dev->hw_features	|= NETIF_F_GSO_SOFTWARE;
 >> +	eth_hw_addr_random(dev);
 >> +	eth_zero_addr(dev->broadcast);
 >> +	ether_setup(dev);
 >> +}
 >> +
 >> +static const struct nla_policy amt_policy[IFLA_AMT_MAX + 1] = {
 >> +	[IFLA_AMT_MODE]		= { .type = NLA_U32 },
 >> +	[IFLA_AMT_RELAY_PORT]	= { .type = NLA_U16 },
 >> +	[IFLA_AMT_GATEWAY_PORT]	= { .type = NLA_U16 },
 >> +	[IFLA_AMT_LINK]		= { .type = NLA_U32 },
 >> +	[IFLA_AMT_LOCAL_IP]	= { .len = sizeof_field(struct iphdr, daddr) },
 >> +	[IFLA_AMT_REMOTE_IP]	= { .len = sizeof_field(struct iphdr, daddr) },
 >> +	[IFLA_AMT_DISCOVERY_IP]	= { .len = sizeof_field(struct iphdr, 
daddr) },
 >> +	[IFLA_AMT_MAX_TUNNELS]	= { .type = NLA_U32 },
 >> +};
 >> +
 >> +static int amt_validate(struct nlattr *tb[], struct nlattr *data[],
 >> +			struct netlink_ext_ack *extack)
 >> +{
 >> +	if (!data)
 >> +		return -EINVAL;
 >> +
 >> +	if (!data[IFLA_AMT_LINK]) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_LINK],
 >> +				    "link interface should not be empty");
 >
 > How about: "Link attribute is required".
 >
 > Similar for the checks below.
 >

Thank you for that, I will use it.

 >> +		return -EINVAL;
 >> +	}
 >> +
 >> +	if (!data[IFLA_AMT_MODE] ||
 >> +	    nla_get_u32(data[IFLA_AMT_MODE]) > AMT_MODE_MAX) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_MODE],
 >> +				    "mode should not be empty");
 >
 > For the extack message to make sense, you need separate checks here: one
 > that the attribute is set and one that its value is valid. I believe the
 > latter can be managed through the policy and netlink_range_validation.
 >

Okay, I will separate it.

 >> +		return -EINVAL;
 >> +	}
 >> +
 >> +	if (!data[IFLA_AMT_LOCAL_IP]) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_DISCOVERY_IP],
 >> +				    "local should not be empty");
 >> +		return -EINVAL;
 >> +	}
 >> +
 >> +	if (!data[IFLA_AMT_DISCOVERY_IP] &&
 >> +	    nla_get_u32(data[IFLA_AMT_MODE]) == AMT_MODE_GATEWAY) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_AMT_LOCAL_IP],
 >> +				    "discovery should not be empty");
 >> +		return -EINVAL;
 >> +	}
 >> +
 >> +	return 0;
 >> +}
 >> +
 >> +static int amt_newlink(struct net *net, struct net_device *dev,
 >> +		       struct nlattr *tb[], struct nlattr *data[],
 >> +		       struct netlink_ext_ack *extack)
 >> +{
 >> +	struct amt_dev *amt = netdev_priv(dev);
 >> +	int err;
 >> +
 >> +	amt->net = net;
 >> +	amt->mode = nla_get_u32(data[IFLA_AMT_MODE]);
 >> +
 >> +	if (data[IFLA_AMT_MAX_TUNNELS])
 >> +		amt->max_tunnels = nla_get_u32(data[IFLA_AMT_MAX_TUNNELS]);
 >> +	else
 >> +		amt->max_tunnels = AMT_MAX_TUNNELS;
 >> +
 >> +	spin_lock_init(&amt->lock);
 >> +	amt->max_groups = AMT_MAX_GROUP;
 >> +	amt->max_sources = AMT_MAX_SOURCE;
 >> +	amt->hash_buckets = AMT_HSIZE;
 >> +	amt->nr_tunnels = 0;
 >> +	get_random_bytes(&amt->hash_seed, sizeof(amt->hash_seed));
 >> +	amt->stream_dev = dev_get_by_index(net,
 >> +					   nla_get_u32(data[IFLA_AMT_LINK]));
 >> +	if (!amt->stream_dev) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_LINK],
 >> +				    "Can't find stream device");
 >> +		return -ENODEV;
 >> +	}
 >> +
 >> +	if (amt->stream_dev->type != ARPHRD_ETHER) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_LINK],
 >> +				    "Invalid stream device type");
 >> +		dev_put(amt->stream_dev);
 >> +		return -EINVAL;
 >> +	}
 >> +
 >> +	amt->local_ip = nla_get_in_addr(data[IFLA_AMT_LOCAL_IP]);
 >
 > Any sanity checks needed for the local_ip? broadcast, multicast, local
 > ip is assigned locally.
 >

Okay, I will add a validation code.

 >> +	if (data[IFLA_AMT_RELAY_PORT])
 >> +		amt->relay_port = nla_get_be16(data[IFLA_AMT_RELAY_PORT]);
 >> +	else
 >> +		amt->relay_port = htons(IANA_AMT_UDP_PORT);
 >> +
 >> +	if (data[IFLA_AMT_GATEWAY_PORT])
 >> +		amt->gw_port = nla_get_be16(data[IFLA_AMT_GATEWAY_PORT]);
 >> +	else
 >> +		amt->gw_port = htons(IANA_AMT_UDP_PORT);
 >> +
 >> +	if (!amt->relay_port) {
 >> +		NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
 >> +				    "relay port must not be 0");
 >> +		return -EINVAL;
 >> +	}
 >> +	if (amt->mode == AMT_MODE_RELAY) {
 >> +		amt->qrv = amt->net->ipv4.sysctl_igmp_qrv;
 >> +		amt->qri = 10;
 >> +		dev->needed_headroom = amt->stream_dev->needed_headroom +
 >> +				       AMT_RELAY_HLEN;
 >> +		dev->mtu = amt->stream_dev->mtu - AMT_RELAY_HLEN;
 >> +		dev->max_mtu = dev->mtu;
 >> +		dev->min_mtu = ETH_MIN_MTU + AMT_RELAY_HLEN;
 >> +	} else {
 >> +		if (!data[IFLA_AMT_DISCOVERY_IP]) {
 >> +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
 >> +					    "discovery must be set in gateway mode");
 >> +			return -EINVAL;
 >> +		}
 >> +		if (!amt->gw_port) {
 >> +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
 >> +					    "gateway port must not be 0");
 >> +			return -EINVAL;
 >> +		}
 >> +		amt->remote_ip = 0;
 >> +		amt->discovery_ip = nla_get_in_addr(data[IFLA_AMT_DISCOVERY_IP]);
 >> +		if (ipv4_is_loopback(amt->discovery_ip) ||
 >> +		    ipv4_is_multicast(amt->discovery_ip)) {
 >> +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_AMT_DISCOVERY_IP],
 >> +					    "discovery must be unicast");
 >> +			return -EINVAL;
 >> +		}
 >> +
 >> +		dev->needed_headroom = amt->stream_dev->needed_headroom +
 >> +				       AMT_GW_HLEN;
 >> +		dev->mtu = amt->stream_dev->mtu - AMT_GW_HLEN;
 >> +		dev->max_mtu = dev->mtu;
 >> +		dev->min_mtu = ETH_MIN_MTU + AMT_GW_HLEN;
 >> +	}
 >> +	amt->qi = AMT_INIT_QUERY_INTERVAL;
 >> +
 >> +	err = register_netdevice(dev);
 >> +	if (err < 0) {
 >> +		netdev_dbg(dev, "failed to register new netdev %d\n", err);
 >> +		dev_put(amt->stream_dev);
 >> +		return err;
 >> +	}
 >> +
 >> +	err = netdev_upper_dev_link(amt->stream_dev, dev, extack);
 >> +	if (err < 0) {
 >> +		dev_put(amt->stream_dev);
 >> +		unregister_netdevice(dev);
 >> +		return err;
 >> +	}
 >> +
 >> +	return 0;
 >> +}
 >> +
 >
 >> diff --git a/include/uapi/linux/amt.h b/include/uapi/linux/amt.h
 >> new file mode 100644
 >> index 000000000000..641ef7f51253
 >> --- /dev/null
 >> +++ b/include/uapi/linux/amt.h
 >> @@ -0,0 +1,31 @@
 >> +/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
 >> +/*
 >> + * Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
 >> + */
 >> +#ifndef _UAPI_AMT_H_
 >> +#define _UAPI_AMT_H_
 >> +
 >> +enum ifla_amt_mode {
 >> +	AMT_MODE_GATEWAY = 0,
 >> +	AMT_MODE_RELAY,
 >> +	__AMT_MODE_MAX,
 >> +};
 >> +
 >> +#define AMT_MODE_MAX (__AMT_MODE_MAX - 1)
 >> +
 >> +enum {
 >> +	IFLA_AMT_UNSPEC,
 >> +	IFLA_AMT_MODE,
 >> +	IFLA_AMT_RELAY_PORT,
 >> +	IFLA_AMT_GATEWAY_PORT,
 >> +	IFLA_AMT_LINK,
 >> +	IFLA_AMT_LOCAL_IP,
 >> +	IFLA_AMT_REMOTE_IP,
 >> +	IFLA_AMT_DISCOVERY_IP,
 >> +	IFLA_AMT_MAX_TUNNELS,
 >> +	__IFLA_AMT_MAX,
 >> +};
 >> +
 >> +#define IFLA_AMT_MAX (__IFLA_AMT_MAX - 1)
 >> +
 >> +#endif /* _UAPI_AMT_H_ */
 >>
 >
 > Document each attribute type. Application developer should be able to
 > read this file and properly use the API.
 >

Okay, I will add comments for each attribute type.

Thank you so much for the detailed review.
I will test and send v2 soon.
Thanks!
