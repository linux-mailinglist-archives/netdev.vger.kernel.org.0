Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF3651396
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 21:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiLSUDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 15:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiLSUDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 15:03:13 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDC713F68
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 12:03:12 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u6-20020a170903124600b00188cd4769bcso7564089plh.0
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 12:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B93Ere0lh6/8aqm4JgiAxJ/jdGiP7qSbPB4CT/66Oaw=;
        b=Lfpguxg1frG0D7dBTC/sOSV3iTGWzZIjjDjX6GxO7UKgIrGgBPdsfwUdoEBGDy0FSu
         iykv3g6pFQCM42WgaFvwRxGSbrXnW8tAhGOYI9u/xolNJBGDmtrhUrkDgeOgWEEr0oIj
         +NS4+pDhy0gtzlJavgnMxdRGv6VdNKIbP+sv2zg7ZgzIWKK9Mx4iOfEWpWzZ1gZZyVap
         D9HHaHZWdJhqWrXxf1nAWWr9ly3kbh2qgEB/ojs7xGwvbryXkLKBfIbAFJMxi0GSVFRY
         kBdKreYqeMUfeMxKntBFLivjwMGky6b5Gzjp+1zwomL1hg7/TmfjHOQcTUhYzKI6wYim
         XSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B93Ere0lh6/8aqm4JgiAxJ/jdGiP7qSbPB4CT/66Oaw=;
        b=dWL/YPqTieVSVm2nEt+Y4owyymSgVdqujI1hIyuQjZVz+AFH8uvzOnZs6M0cIWMeIO
         SQsGwosavkzp9U16JvZ6arQ0YZJfTrxeXWAFzBYJjJ/Gsdcogvees8DG3gpAa9nTQDUd
         Rf/evc0lKxadNMTFKAnRAhj4n33J1ye17ZXlsEaaa2XThB6ypRvsGyWbYdLBdORhjYP7
         pbRlUngAMaDi/QAezytZFg9U+JFoDNetp0jRPYPGdLq3CK87HGklNDT4+iDQZ/PduxbL
         vktSZpwGNb53Jy+LRjwumOgvPf8Yc+oCli86lf6pL7VhnII2cGBB00qhDT56S2z3MSI1
         pugA==
X-Gm-Message-State: AFqh2krcSIL28A78dj3gFXEeNUfzoFbD/SaphwLcHYMg74C3Os3sEmA/
        jFbXCB3V0XJWQrZ2igoHOu/vYVs=
X-Google-Smtp-Source: AMrXdXsx6noD2wWH0DbWT6pPsOKfsqEWhJ1gVTk9BKTO1WPgvZTY40rYjG+JjMQVgVQdmbqLwC1d8MY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:4ccf:b0:219:b015:58cd with SMTP id
 nd15-20020a17090b4ccf00b00219b01558cdmr2486553pjb.40.1671480191438; Mon, 19
 Dec 2022 12:03:11 -0800 (PST)
Date:   Mon, 19 Dec 2022 12:03:09 -0800
In-Reply-To: <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
Mime-Version: 1.0
References: <cover.1671462950.git.lorenzo@kernel.org> <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
Message-ID: <Y6DDfVhOWRybVNUt@google.com>
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
From:   sdf@google.com
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com, mst@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19, Lorenzo Bianconi wrote:
> From: Marek Majtyka <alardam@gmail.com>

> Implement support for checking what kind of XDP features a netdev
> supports. Previously, there was no way to do this other than to try to
> create an AF_XDP socket on the interface or load an XDP program and see
> if it worked. This commit changes this by adding a new variable which
> describes all xdp supported functions on pretty detailed level:

>   - aborted
>   - drop
>   - pass
>   - tx
>   - redirect
>   - sock_zerocopy
>   - hw_offload
>   - redirect_target
>   - tx_lock
>   - frag_rx
>   - frag_target

> Zerocopy mode requires that redirect XDP operation is implemented in a
> driver and the driver supports also zero copy mode. Full mode requires
> that all XDP operation are implemented in the driver. Basic mode is just
> full mode without redirect operation. Frag target requires
> redirect_target one is supported by the driver.

Can you share more about _why_ is it needed? If we can already obtain
most of these signals via probing, why export the flags?

> Initially, these new flags are disabled for all drivers by default.

> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> ---
>   .../networking/netdev-xdp-features.rst        | 60 +++++++++++++++++
>   include/linux/netdevice.h                     |  2 +
>   include/linux/xdp_features.h                  | 64 +++++++++++++++++++
>   include/uapi/linux/if_link.h                  |  7 ++
>   include/uapi/linux/xdp_features.h             | 34 ++++++++++
>   net/core/rtnetlink.c                          | 34 ++++++++++
>   tools/include/uapi/linux/if_link.h            |  7 ++
>   tools/include/uapi/linux/xdp_features.h       | 34 ++++++++++
>   8 files changed, 242 insertions(+)
>   create mode 100644 Documentation/networking/netdev-xdp-features.rst
>   create mode 100644 include/linux/xdp_features.h
>   create mode 100644 include/uapi/linux/xdp_features.h
>   create mode 100644 tools/include/uapi/linux/xdp_features.h

> diff --git a/Documentation/networking/netdev-xdp-features.rst  
> b/Documentation/networking/netdev-xdp-features.rst
> new file mode 100644
> index 000000000000..1dc803fe72dd
> --- /dev/null
> +++ b/Documentation/networking/netdev-xdp-features.rst
> @@ -0,0 +1,60 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================
> +Netdev XDP features
> +=====================
> +
> + * XDP FEATURES FLAGS
> +
> +Following netdev xdp features flags can be retrieved over route netlink
> +interface (compact form) - the same way as netdev feature flags.
> +These features flags are read only and cannot be change at runtime.
> +
> +*  XDP_ABORTED
> +
> +This feature informs if netdev supports xdp aborted action.
> +
> +*  XDP_DROP
> +
> +This feature informs if netdev supports xdp drop action.
> +
> +*  XDP_PASS
> +
> +This feature informs if netdev supports xdp pass action.
> +
> +*  XDP_TX
> +
> +This feature informs if netdev supports xdp tx action.
> +
> +*  XDP_REDIRECT
> +
> +This feature informs if netdev supports xdp redirect action.
> +It assumes the all beforehand mentioned flags are enabled.
> +
> +*  XDP_SOCK_ZEROCOPY
> +
> +This feature informs if netdev driver supports xdp zero copy.
> +It assumes the all beforehand mentioned flags are enabled.
> +
> +*  XDP_HW_OFFLOAD
> +
> +This feature informs if netdev driver supports xdp hw oflloading.
> +
> +*  XDP_TX_LOCK
> +
> +This feature informs if netdev ndo_xdp_xmit function requires locking.
> +
> +*  XDP_REDIRECT_TARGET
> +
> +This feature informs if netdev implements ndo_xdp_xmit callback.
> +
> +*  XDP_FRAG_RX
> +
> +This feature informs if netdev implements non-linear xdp buff support in
> +the driver napi callback.
> +
> +*  XDP_FRAG_TARGET
> +
> +This feature informs if netdev implements non-linear xdp buff support in
> +ndo_xdp_xmit callback. XDP_FRAG_TARGET requires XDP_REDIRECT_TARGET is  
> properly
> +supported.
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index aad12a179e54..ae5a8564383b 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -43,6 +43,7 @@
>   #include <net/xdp.h>

>   #include <linux/netdev_features.h>
> +#include <linux/xdp_features.h>
>   #include <linux/neighbour.h>
>   #include <uapi/linux/netdevice.h>
>   #include <uapi/linux/if_bonding.h>
> @@ -2362,6 +2363,7 @@ struct net_device {
>   	struct rtnl_hw_stats64	*offload_xstats_l3;

>   	struct devlink_port	*devlink_port;
> +	xdp_features_t		xdp_features;
>   };
>   #define to_net_dev(d) container_of(d, struct net_device, dev)

> diff --git a/include/linux/xdp_features.h b/include/linux/xdp_features.h
> new file mode 100644
> index 000000000000..4e72a86ef329
> --- /dev/null
> +++ b/include/linux/xdp_features.h
> @@ -0,0 +1,64 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Network device xdp features.
> + */
> +#ifndef _LINUX_XDP_FEATURES_H
> +#define _LINUX_XDP_FEATURES_H
> +
> +#include <linux/types.h>
> +#include <linux/bitops.h>
> +#include <asm/byteorder.h>
> +#include <uapi/linux/xdp_features.h>
> +
> +typedef u32 xdp_features_t;
> +
> +#define __XDP_F_BIT(bit)	((xdp_features_t)1 << (bit))
> +#define __XDP_F(name)		__XDP_F_BIT(XDP_F_##name##_BIT)
> +
> +#define XDP_F_ABORTED		__XDP_F(ABORTED)
> +#define XDP_F_DROP		__XDP_F(DROP)
> +#define XDP_F_PASS		__XDP_F(PASS)
> +#define XDP_F_TX		__XDP_F(TX)
> +#define XDP_F_REDIRECT		__XDP_F(REDIRECT)
> +#define XDP_F_REDIRECT_TARGET	__XDP_F(REDIRECT_TARGET)
> +#define XDP_F_SOCK_ZEROCOPY	__XDP_F(SOCK_ZEROCOPY)
> +#define XDP_F_HW_OFFLOAD	__XDP_F(HW_OFFLOAD)
> +#define XDP_F_TX_LOCK		__XDP_F(TX_LOCK)
> +#define XDP_F_FRAG_RX		__XDP_F(FRAG_RX)
> +#define XDP_F_FRAG_TARGET	__XDP_F(FRAG_TARGET)
> +
> +#define XDP_F_BASIC		(XDP_F_ABORTED | XDP_F_DROP |	\
> +				 XDP_F_PASS | XDP_F_TX)
> +
> +#define XDP_F_FULL		(XDP_F_BASIC | XDP_F_REDIRECT)
> +
> +#define XDP_F_FULL_ZC		(XDP_F_FULL | XDP_F_SOCK_ZEROCOPY)
> +
> +#define XDP_FEATURES_ABORTED_STR		"xdp-aborted"
> +#define XDP_FEATURES_DROP_STR			"xdp-drop"
> +#define XDP_FEATURES_PASS_STR			"xdp-pass"
> +#define XDP_FEATURES_TX_STR			"xdp-tx"
> +#define XDP_FEATURES_REDIRECT_STR		"xdp-redirect"
> +#define XDP_FEATURES_REDIRECT_TARGET_STR	"xdp-redirect-target"
> +#define XDP_FEATURES_SOCK_ZEROCOPY_STR		"xdp-sock-zerocopy"
> +#define XDP_FEATURES_HW_OFFLOAD_STR		"xdp-hw-offload"
> +#define XDP_FEATURES_TX_LOCK_STR		"xdp-tx-lock"
> +#define XDP_FEATURES_FRAG_RX_STR		"xdp-frag-rx"
> +#define XDP_FEATURES_FRAG_TARGET_STR		"xdp-frag-target"
> +
> +#define DECLARE_XDP_FEATURES_TABLE(name, length)				\
> +	const char name[][length] = {						\
> +		[XDP_F_ABORTED_BIT] = XDP_FEATURES_ABORTED_STR,			\
> +		[XDP_F_DROP_BIT] = XDP_FEATURES_DROP_STR,			\
> +		[XDP_F_PASS_BIT] = XDP_FEATURES_PASS_STR,			\
> +		[XDP_F_TX_BIT] = XDP_FEATURES_TX_STR,				\
> +		[XDP_F_REDIRECT_BIT] = XDP_FEATURES_REDIRECT_STR,		\
> +		[XDP_F_REDIRECT_TARGET_BIT] = XDP_FEATURES_REDIRECT_TARGET_STR,	\
> +		[XDP_F_SOCK_ZEROCOPY_BIT] = XDP_FEATURES_SOCK_ZEROCOPY_STR,	\
> +		[XDP_F_HW_OFFLOAD_BIT] = XDP_FEATURES_HW_OFFLOAD_STR,		\
> +		[XDP_F_TX_LOCK_BIT] = XDP_FEATURES_TX_LOCK_STR,			\
> +		[XDP_F_FRAG_RX_BIT] = XDP_FEATURES_FRAG_RX_STR,			\
> +		[XDP_F_FRAG_TARGET_BIT] = XDP_FEATURES_FRAG_TARGET_STR,		\
> +	}
> +
> +#endif /* _LINUX_XDP_FEATURES_H */
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 1021a7e47a86..971c658ceaea 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -374,6 +374,8 @@ enum {

>   	IFLA_DEVLINK_PORT,

> +	IFLA_XDP_FEATURES,
> +
>   	__IFLA_MAX
>   };

> @@ -1318,6 +1320,11 @@ enum {

>   #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)

> +enum {
> +	IFLA_XDP_FEATURES_WORD_UNSPEC = 0,
> +	IFLA_XDP_FEATURES_BITS_WORD,
> +};
> +
>   enum {
>   	IFLA_EVENT_NONE,
>   	IFLA_EVENT_REBOOT,		/* internal reset / reboot */
> diff --git a/include/uapi/linux/xdp_features.h  
> b/include/uapi/linux/xdp_features.h
> new file mode 100644
> index 000000000000..48eb42069bcd
> --- /dev/null
> +++ b/include/uapi/linux/xdp_features.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (c) 2020 Intel
> + */
> +
> +#ifndef __UAPI_LINUX_XDP_FEATURES__
> +#define __UAPI_LINUX_XDP_FEATURES__
> +
> +enum {
> +	XDP_F_ABORTED_BIT,
> +	XDP_F_DROP_BIT,
> +	XDP_F_PASS_BIT,
> +	XDP_F_TX_BIT,
> +	XDP_F_REDIRECT_BIT,
> +	XDP_F_REDIRECT_TARGET_BIT,
> +	XDP_F_SOCK_ZEROCOPY_BIT,
> +	XDP_F_HW_OFFLOAD_BIT,
> +	XDP_F_TX_LOCK_BIT,
> +	XDP_F_FRAG_RX_BIT,
> +	XDP_F_FRAG_TARGET_BIT,
> +	/*
> +	 * Add your fresh new property above and remember to update
> +	 * documentation.
> +	 */
> +	XDP_FEATURES_COUNT,
> +};
> +
> +#define XDP_FEATURES_WORDS			((XDP_FEATURES_COUNT + 32 - 1) / 32)
> +#define XDP_FEATURES_WORD(blocks, index)	((blocks)[(index) / 32U])
> +#define XDP_FEATURES_FIELD_FLAG(index)		(1U << (index) % 32U)
> +#define XDP_FEATURES_BIT_IS_SET(blocks, index)        \
> +	(XDP_FEATURES_WORD(blocks, index) & XDP_FEATURES_FIELD_FLAG(index))
> +
> +#endif  /* __UAPI_LINUX_XDP_FEATURES__ */
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 64289bc98887..1c299746b614 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1016,6 +1016,14 @@ static size_t rtnl_xdp_size(void)
>   	return xdp_size;
>   }

> +static size_t rtnl_xdp_features_size(void)
> +{
> +	size_t xdp_size = nla_total_size(0) +	/* nest IFLA_XDP_FEATURES */
> +			  XDP_FEATURES_WORDS * nla_total_size(4);
> +
> +	return xdp_size;
> +}
> +
>   static size_t rtnl_prop_list_size(const struct net_device *dev)
>   {
>   	struct netdev_name_node *name_node;
> @@ -1103,6 +1111,7 @@ static noinline size_t if_nlmsg_size(const struct  
> net_device *dev,
>   	       + rtnl_prop_list_size(dev)
>   	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
>   	       + rtnl_devlink_port_size(dev)
> +	       + rtnl_xdp_features_size() /* IFLA_XDP_FEATURES */
>   	       + 0;
>   }

> @@ -1546,6 +1555,27 @@ static int rtnl_xdp_fill(struct sk_buff *skb,  
> struct net_device *dev)
>   	return err;
>   }

> +static int rtnl_xdp_features_fill(struct sk_buff *skb, struct net_device  
> *dev)
> +{
> +	struct nlattr *attr;
> +
> +	attr = nla_nest_start_noflag(skb, IFLA_XDP_FEATURES);
> +	if (!attr)
> +		return -EMSGSIZE;
> +
> +	BUILD_BUG_ON(XDP_FEATURES_WORDS != 1);
> +	if (nla_put_u32(skb, IFLA_XDP_FEATURES_BITS_WORD, dev->xdp_features))
> +		goto err_cancel;
> +
> +	nla_nest_end(skb, attr);
> +
> +	return 0;
> +
> +err_cancel:
> +	nla_nest_cancel(skb, attr);
> +	return -EMSGSIZE;
> +}
> +
>   static u32 rtnl_get_event(unsigned long event)
>   {
>   	u32 rtnl_event_type = IFLA_EVENT_NONE;
> @@ -1904,6 +1934,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>   	if (rtnl_fill_devlink_port(skb, dev))
>   		goto nla_put_failure;

> +	if (rtnl_xdp_features_fill(skb, dev))
> +		goto nla_put_failure;
> +
>   	nlmsg_end(skb, nlh);
>   	return 0;

> @@ -1968,6 +2001,7 @@ static const struct nla_policy  
> ifla_policy[IFLA_MAX+1] = {
>   	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
>   	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
>   	[IFLA_ALLMULTI]		= { .type = NLA_REJECT },
> +	[IFLA_XDP_FEATURES]	= { .type = NLA_NESTED },
>   };

>   static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> diff --git a/tools/include/uapi/linux/if_link.h  
> b/tools/include/uapi/linux/if_link.h
> index 82fe18f26db5..994228e9909a 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -354,6 +354,8 @@ enum {

>   	IFLA_DEVLINK_PORT,

> +	IFLA_XDP_FEATURES,
> +
>   	__IFLA_MAX
>   };

> @@ -1222,6 +1224,11 @@ enum {

>   #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)

> +enum {
> +	IFLA_XDP_FEATURES_WORD_UNSPEC = 0,
> +	IFLA_XDP_FEATURES_BITS_WORD,
> +};
> +
>   enum {
>   	IFLA_EVENT_NONE,
>   	IFLA_EVENT_REBOOT,		/* internal reset / reboot */
> diff --git a/tools/include/uapi/linux/xdp_features.h  
> b/tools/include/uapi/linux/xdp_features.h
> new file mode 100644
> index 000000000000..48eb42069bcd
> --- /dev/null
> +++ b/tools/include/uapi/linux/xdp_features.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (c) 2020 Intel
> + */
> +
> +#ifndef __UAPI_LINUX_XDP_FEATURES__
> +#define __UAPI_LINUX_XDP_FEATURES__
> +
> +enum {
> +	XDP_F_ABORTED_BIT,
> +	XDP_F_DROP_BIT,
> +	XDP_F_PASS_BIT,
> +	XDP_F_TX_BIT,
> +	XDP_F_REDIRECT_BIT,
> +	XDP_F_REDIRECT_TARGET_BIT,
> +	XDP_F_SOCK_ZEROCOPY_BIT,
> +	XDP_F_HW_OFFLOAD_BIT,
> +	XDP_F_TX_LOCK_BIT,
> +	XDP_F_FRAG_RX_BIT,
> +	XDP_F_FRAG_TARGET_BIT,
> +	/*
> +	 * Add your fresh new property above and remember to update
> +	 * documentation.
> +	 */
> +	XDP_FEATURES_COUNT,
> +};
> +
> +#define XDP_FEATURES_WORDS			((XDP_FEATURES_COUNT + 32 - 1) / 32)
> +#define XDP_FEATURES_WORD(blocks, index)	((blocks)[(index) / 32U])
> +#define XDP_FEATURES_FIELD_FLAG(index)		(1U << (index) % 32U)
> +#define XDP_FEATURES_BIT_IS_SET(blocks, index)        \
> +	(XDP_FEATURES_WORD(blocks, index) & XDP_FEATURES_FIELD_FLAG(index))
> +
> +#endif  /* __UAPI_LINUX_XDP_FEATURES__ */
> --
> 2.38.1

