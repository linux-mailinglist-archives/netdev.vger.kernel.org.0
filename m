Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680C2197FA2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgC3Pax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:30:53 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38135 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgC3Pax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:30:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id w1so18523156ljh.5
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 08:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MfvOmIspdiTZx+YN5qTVFVKcge2K4qjWfcK20gYqoiw=;
        b=WFPm18P+hehJbtGqWYENKe7ddU+TNRoiGFEHzzgaHjvlyIAOfWUndukoDy5czuymXp
         cpXBbX/Max/+ijBO3/972mh5Np4N5bLdmbRb23ETsvotZta6d1CXNBS5Qt5gzOetZ/00
         zWi5rHehHULUBYcw54npWZ0Crm7CI3ZbquKdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MfvOmIspdiTZx+YN5qTVFVKcge2K4qjWfcK20gYqoiw=;
        b=SeLon788KKxZ/upTknMM+lPAaoACA5ZNcbjvRSNQF/DgDUou4nAI1+7VNe0gM0Czpf
         6KDBtHPFAM1cROtwRG5ztwjttRINo5CUIq4hT2OnMu6KpeKwIcKJYrY/cmZNbCZ3hHwz
         OQNm5NkqlwH1cZCaELOS1RnfZfcWrci4ZQVEDgK3mLJsFgC1YTBm6KA/8JEmIiukhsbB
         sI2lbM2kzXOoi+4MnR7XlCzTMreoI05dkN5fIFDo6JDBc6wnG2H7WyqCgguQrbVx5vQe
         DIn3LCdOyqZ/wzg6S8ZJ4nHSfZclX2NyXqe0NFzX6sWUaMAdoLKRwpjqd1f7SOLQNY0G
         YaDg==
X-Gm-Message-State: AGi0PubDP+vyZnwF4DoDhnytijCYD6AAnRwDMxNDUHtRfAjZVR1DnfgD
        y2/Xdr2bVXGs8eG7L8FnYe1TrQ==
X-Google-Smtp-Source: APiQypJVMkEwXyZdFdVxNim1GI03DpNiFA7mBosSFqvQa+y/+K4ycMmI8fUT16G9PLy3Jofz5CDU2w==
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr7333845ljp.116.1585582248717;
        Mon, 30 Mar 2020 08:30:48 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n26sm6882205ljg.93.2020.03.30.08.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 08:30:47 -0700 (PDT)
Subject: Re: [RFC net-next v4 4/9] bridge: mrp: Implement netlink interface to
 configure MRP
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
 <20200327092126.15407-5-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <c64a8e3c-e86a-641d-3cdd-0cec645dd3d1@cumulusnetworks.com>
Date:   Mon, 30 Mar 2020 18:30:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327092126.15407-5-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2020 11:21, Horatiu Vultur wrote:
> Implement netlink interface to configure MRP. The implementation
> will do sanity checks over the attributes and then eventually call the MRP
> interface.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp_netlink.c | 176 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 176 insertions(+)
>  create mode 100644 net/bridge/br_mrp_netlink.c
> 

Hi Horatiu,

> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> new file mode 100644
> index 000000000000..043b7f6cddbe
> --- /dev/null
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -0,0 +1,176 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <net/genetlink.h>
> +
> +#include <uapi/linux/mrp_bridge.h>
> +#include "br_private.h"
> +#include "br_private_mrp.h"
> +
> +static int br_mrp_parse_instance(struct net_bridge *br, struct nlattr *attr,
> +				 int cmd)
> +{
> +	struct br_mrp_instance *instance;
> +
> +	if (nla_len(attr) != sizeof(*instance))
> +		return -EINVAL;
> +
> +	instance = nla_data(attr);
> +
> +	if (cmd == RTM_SETLINK)
> +		return br_mrp_add(br, instance);
> +	else
> +		return br_mrp_del(br, instance);
> +}
> +
> +static int br_mrp_parse_port_state(struct net_bridge *br,
> +				   struct net_bridge_port *p,
> +				   struct nlattr *attr)
> +{
> +	enum br_mrp_port_state_type state;
> +
> +	if (nla_len(attr) != sizeof(u32) || !p)
> +		return -EINVAL;
> +
> +	state = nla_get_u32(attr);
> +
> +	return br_mrp_set_port_state(p, state);
> +}
> +
> +static int br_mrp_parse_port_role(struct net_bridge *br,
> +				  struct net_bridge_port *p,
> +				  struct nlattr *attr)
> +{
> +	struct br_mrp_port_role *role;
> +
> +	if (nla_len(attr) != sizeof(*role) || !p)
> +		return -EINVAL;
> +
> +	role = nla_data(attr);
> +
> +	return br_mrp_set_port_role(p, role->ring_id, role->role);
> +}
> +
> +static int br_mrp_parse_ring_state(struct net_bridge *br, struct nlattr *attr)
> +{
> +	struct br_mrp_ring_state *state;
> +
> +	if (nla_len(attr) != sizeof(*state))
> +		return -EINVAL;
> +
> +	state = nla_data(attr);
> +
> +	return br_mrp_set_ring_state(br, state->ring_id, state->ring_state);
> +}
> +
> +static int br_mrp_parse_ring_role(struct net_bridge *br, struct nlattr *attr)
> +{
> +	struct br_mrp_ring_role *role;
> +
> +	if (nla_len(attr) != sizeof(*role))
> +		return -EINVAL;
> +
> +	role = nla_data(attr);
> +
> +	return br_mrp_set_ring_role(br, role->ring_id, role->ring_role);
> +}
> +
> +static int br_mrp_parse_start_test(struct net_bridge *br, struct nlattr *attr)
> +{
> +	struct br_mrp_start_test *test;
> +
> +	if (nla_len(attr) != sizeof(*test))
> +		return -EINVAL;
> +
> +	test = nla_data(attr);
> +
> +	return br_mrp_start_test(br, test->ring_id, test->interval,
> +				 test->max_miss, test->period);
> +}
> +
> +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> +		 struct nlattr *attr, int cmd)
> +{
> +	struct nlattr *mrp;
> +	int rem, err;
> +
> +	nla_for_each_nested(mrp, attr, rem) {
> +		err = 0;
> +		switch (nla_type(mrp)) {
> +		case IFLA_BRIDGE_MRP_INSTANCE:
> +			err = br_mrp_parse_instance(br, mrp, cmd);
> +			if (err)
> +				return err;
> +			break;
> +		case IFLA_BRIDGE_MRP_PORT_STATE:
> +			err = br_mrp_parse_port_state(br, p, mrp);
> +			if (err)
> +				return err;
> +			break;
> +		case IFLA_BRIDGE_MRP_PORT_ROLE:
> +			err = br_mrp_parse_port_role(br, p, mrp);
> +			if (err)
> +				return err;
> +			break;
> +		case IFLA_BRIDGE_MRP_RING_STATE:
> +			err = br_mrp_parse_ring_state(br, mrp);
> +			if (err)
> +				return err;
> +			break;
> +		case IFLA_BRIDGE_MRP_RING_ROLE:
> +			err = br_mrp_parse_ring_role(br, mrp);
> +			if (err)
> +				return err;
> +			break;
> +		case IFLA_BRIDGE_MRP_START_TEST:
> +			err = br_mrp_parse_start_test(br, mrp);
> +			if (err)
> +				return err;
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}

All of the above can be implemented via nla_parse_nested() with a proper policy.
You don't have to manually check for the attribute size. Then your code follows
the netlink normal (e.g. check the bridge netlink handling) of:
 nla_parse_nested(tb)
 if (tb[attr])
    do_something_with(tb[attr])
 ...


> +
> +void br_mrp_port_open(struct net_device *dev, u8 loc)
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
> +	skb = nlmsg_new(1024, GFP_ATOMIC);

Please add a function which calculates the size based on the attribute sizes.

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
> +	mrp = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
> +

These can return an error which has to be handled.

> +	nla_put_u32(skb, IFLA_BRIDGE_MRP_RING_OPEN, loc);
> +

Same for this.

> +	nla_nest_end(skb, mrp);
> +	nla_nest_end(skb, af);
> +	nlmsg_end(skb, nlh);
> +
> +	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
> +	return;
> +errout:
> +	rtnl_set_sk_err(net, RTNLGRP_LINK, err);
> +}
> +EXPORT_SYMBOL(br_mrp_port_open);
> 

