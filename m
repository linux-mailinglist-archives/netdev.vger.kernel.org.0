Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD861AEAD4
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDRIVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 04:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgDRIVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 04:21:14 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09382C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 01:21:13 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id f8so3699180lfe.12
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 01:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=v8RC3lM119mByCUSuLXagf8GpGwfc/WMlIE01WyWCOs=;
        b=fQQWygvZdTVZSiMjo5o7XeQUoM+r88ifUrZY5qcYmS5MSOBJsI6NG/x/KcLgAs7pKC
         +UtywlGEvqt5PyAoD9LP4b+hT+YsBmFXRssL8RTWccsXzIsOPuMNsHJ+bYu3Eqpvys06
         /B2cadDy0q+EXXzpNmj3viN7DaOg/1weiy3g4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8RC3lM119mByCUSuLXagf8GpGwfc/WMlIE01WyWCOs=;
        b=m1AKa6yDLC3Zn4JtYBRTOUQWyahJcpbI6xlq+6I5bOmeHSeSwGZYWNjAqPyR2ZlahN
         uHt0MT20GIEzG0bT0o0m7aDpgd/kdXbO4kQApx4HtOZglfO1EaEZFe5PAgCmLoK1jWsp
         E2WUQLm/TKyH5mQ2pT2CPUAE5s4WbnjRnfs1TyQ+e3pIBG7cg3VgHywlCR5UXWXLM0ky
         d135m5Gn9EFpzVhgbQJnyZz9gO+BOpT1ZZweatxDev0c0+jkpj/lNA70XBDh+UF4sQ87
         QWKzTNsMZRoHH6lXJghvOLgB+y4cFHMLq9XgPxrCS1iWvQXpSs6fBdJUafUydvz2An2n
         Je5Q==
X-Gm-Message-State: AGi0PuaM+sYx4wbt834rllI1LbkwGOXgxtDGrwiY2rVEpoVn0F0atTOZ
        24ChoHr5/Y+bMdOrspKjv/tLjg==
X-Google-Smtp-Source: APiQypLXod/BXxYafkVzGdCbViNXxpPEpzDBz5nzkNTXrB6/G44ajPdChUktJJgzBNt8mjZMmnLDfA==
X-Received: by 2002:a05:6512:3b0:: with SMTP id v16mr4457346lfp.213.1587198072400;
        Sat, 18 Apr 2020 01:21:12 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w24sm20024957lfe.58.2020.04.18.01.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 01:21:11 -0700 (PDT)
Subject: Re: [RFC net-next v5 8/9] bridge: mrp: Implement netlink interface to
 configure MRP
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <20200414112618.3644-9-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <ef5f40ad-6d35-0897-3355-60c97777b79a@cumulusnetworks.com>
Date:   Sat, 18 Apr 2020 11:21:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414112618.3644-9-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2020 14:26, Horatiu Vultur wrote:
> Implement netlink interface to configure MRP. The implementation
> will do sanity checks over the attributes and then eventually call the MRP
> interface.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp_netlink.c | 164 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 164 insertions(+)
>  create mode 100644 net/bridge/br_mrp_netlink.c
> 
> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> new file mode 100644
> index 000000000000..0d8253311595
> --- /dev/null> +++ b/net/bridge/br_mrp_netlink.c
> @@ -0,0 +1,164 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <net/genetlink.h>
> +
> +#include <uapi/linux/mrp_bridge.h>
> +#include "br_private.h"
> +#include "br_private_mrp.h"
> +
> +static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_EXACT_LEN,
> +					    .len = sizeof(struct br_mrp_instance)},
> +	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_EXACT_LEN,
> +					    .len = sizeof(struct br_mrp_port_role)},
> +	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_EXACT_LEN,
> +					    .len = sizeof(struct br_mrp_ring_state)},
> +	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_EXACT_LEN,
> +					    .len = sizeof(struct br_mrp_ring_role)},
> +	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_EXACT_LEN,
> +					    .len = sizeof(struct br_mrp_start_test)},
> +};
> +
> +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> +		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_MAX + 1];
> +	int err;
> +
> +	if (br->stp_enabled != BR_NO_STP) {
> +		br_warn(br, "MRP can't be enabled if STP is already enabled\n");

Use extack.

> +		return -EINVAL;
> +	}
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_MAX, attr,
> +			       NULL, extack);
> +	if (err)
> +		return err;
> +
> +	if (tb[IFLA_BRIDGE_MRP_INSTANCE]) {
> +		struct br_mrp_instance *instance =
> +			nla_data(tb[IFLA_BRIDGE_MRP_INSTANCE]);
> +
> +		if (cmd == RTM_SETLINK)
> +			err = br_mrp_add(br, instance);
> +		else
> +			err = br_mrp_del(br, instance);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (tb[IFLA_BRIDGE_MRP_PORT_STATE]) {
> +		enum br_mrp_port_state_type state =
> +			nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE]);
> +
> +		err = br_mrp_set_port_state(p, state);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (tb[IFLA_BRIDGE_MRP_PORT_ROLE]) {
> +		struct br_mrp_port_role *role =
> +			nla_data(tb[IFLA_BRIDGE_MRP_PORT_ROLE]);
> +
> +		err = br_mrp_set_port_role(p, role);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (tb[IFLA_BRIDGE_MRP_RING_STATE]) {
> +		struct br_mrp_ring_state *state =
> +			nla_data(tb[IFLA_BRIDGE_MRP_RING_STATE]);
> +
> +		err = br_mrp_set_ring_state(br, state);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (tb[IFLA_BRIDGE_MRP_RING_ROLE]) {
> +		struct br_mrp_ring_role *role =
> +			nla_data(tb[IFLA_BRIDGE_MRP_RING_ROLE]);
> +
> +		err = br_mrp_set_ring_role(br, role);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (tb[IFLA_BRIDGE_MRP_START_TEST]) {
> +		struct br_mrp_start_test *test =
> +			nla_data(tb[IFLA_BRIDGE_MRP_START_TEST]);
> +
> +		err = br_mrp_start_test(br, test);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline size_t br_mrp_nlmsg_size(void)
> +{
> +	return NLMSG_ALIGN(sizeof(struct ifinfomsg))
> +		+ nla_total_size(4); /* IFLA_BRIDGE_MRP_RING_OPEN */
> +}
> +
> +int br_mrp_port_open(struct net_device *dev, u8 loc)
> +{
> +	struct nlattr *af, *mrp;
> +	struct ifinfomsg *hdr;
> +	struct nlmsghdr *nlh;
> +	struct sk_buff *skb;
> +	int err = -ENOBUFS;
> +	struct net *net;
> +
> +	net = dev_net(dev);
> +
> +	skb = nlmsg_new(br_mrp_nlmsg_size(), GFP_ATOMIC);
> +	if (!skb)
> +		goto errout;
> +
> +	nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*hdr), 0);
> +	if (!nlh)
> +		goto errout;
> +
> +	hdr = nlmsg_data(nlh);
> +	hdr->ifi_family = AF_BRIDGE;
> +	hdr->__ifi_pad = 0;
> +	hdr->ifi_type = dev->type;
> +	hdr->ifi_index = dev->ifindex;
> +	hdr->ifi_flags = dev_get_flags(dev);
> +	hdr->ifi_change = 0;
> +
> +	af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
> +	if (!af) {
> +		err = -EMSGSIZE;
> +		goto nla_put_failure;
> +	}
> +
> +	mrp = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
> +	if (!mrp) {
> +		err = -EMSGSIZE;
> +		goto nla_put_failure;
> +	}
> +
> +	err = nla_put_u32(skb, IFLA_BRIDGE_MRP_RING_OPEN, loc);
> +	if (err)
> +		goto nla_put_failure;
> +
> +	nla_nest_end(skb, mrp);
> +	nla_nest_end(skb, af);
> +	nlmsg_end(skb, nlh);
> +
> +	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
> +	return 0;
> +
> +nla_put_failure:
> +	nlmsg_cancel(skb, nlh);
> +	kfree_skb(skb);
> +
> +errout:
> +	rtnl_set_sk_err(net, RTNLGRP_LINK, err);
> +	return err;
> +}
> +EXPORT_SYMBOL(br_mrp_port_open);
> 

Why do you need this function when you already have br_ifinfo_notify() ?

