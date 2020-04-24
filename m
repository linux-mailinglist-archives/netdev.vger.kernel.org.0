Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792EB1B7025
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgDXI5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:57:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726324AbgDXI5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587718670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=58998l5G/3UYFw34WJbGJzcTH0mtZwGcApXuDFIHfoM=;
        b=UkGZGE7o5H/ChBXCdk74brRH/QHsrQXDVcUkm6TB0shiQtV3OEt8psK2bqH+ZOJ8pR2Wn8
        6uqSNSfIsjSfiLzs04/bQq0dr0Va83E62PugYIgR3UlccSVOpPU3LMgI5bcOLr56IM5yHA
        1DAzyl09q9plUYOepsUKDaoAawP0EH0=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-tRAemd8OPtedQUpbvlZD8g-1; Fri, 24 Apr 2020 04:57:48 -0400
X-MC-Unique: tRAemd8OPtedQUpbvlZD8g-1
Received: by mail-lf1-f72.google.com with SMTP id b16so3639163lfb.19
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 01:57:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=58998l5G/3UYFw34WJbGJzcTH0mtZwGcApXuDFIHfoM=;
        b=ohf8cq2qw2go2b2tGnUaADpAjIVrY8aepcGDLBjq7i3+BydNM9WC5xpfyBmXMEtEub
         WCKh+Z3kFaVEE728lE4XqZeHzo+DwNN/CWrRj8GpJDDcQx+IaSiKFwtTNiLwUtDqTcxB
         wn2JLNc8goonWvVbqOi915EGfY0KOeXphTdroBASSFgK+pd/Gx48et/GkEE3hshrYwBp
         4ra4EHwMF7ffcbYfsHDzKT9PZXBzM5g2X02h2veIklKb1uZnmSsql/OYz4qu42wcC3v/
         olCIBiyMy9MvC9HObSZkIZjmftQdQgxR2xgoZAIgr/rE4nglMlMCJbX3/siL0SPy/06N
         9Tfw==
X-Gm-Message-State: AGi0PuYYekQUTDGMFHmTTrsblgqYK9Y9GITO/pn4fMfbNgQXSggWIb2j
        Yn4cLqZ2aiLjZBY7wqrdOZ2DdHJJRayRHHg5gVPclJLR2VaT652B8AKOGW0VxkQeW6RwXpEEuY7
        2o0h7gpqknBxZRNqG
X-Received: by 2002:ac2:51c9:: with SMTP id u9mr5718078lfm.184.1587718664654;
        Fri, 24 Apr 2020 01:57:44 -0700 (PDT)
X-Google-Smtp-Source: APiQypJQnAJJOdG8eR875uLp+CXMEZdy8TAfaV7HV0tyNHDJoAZBjBEHy2AE2zdGOqgz4FVKyytyJw==
X-Received: by 2002:ac2:51c9:: with SMTP id u9mr5718056lfm.184.1587718664337;
        Fri, 24 Apr 2020 01:57:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e7sm4557439lfc.72.2020.04.24.01.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 01:57:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0563B1814FF; Fri, 24 Apr 2020 10:57:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v2 bpf-next 06/17] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200424021148.83015-7-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org> <20200424021148.83015-7-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 10:57:42 +0200
Message-ID: <877dy55khl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Running programs in the egress path, on skbs or xdp_frames, does not
> require driver specific resources like Rx path. Accordingly, the
> programs can be run in core code, so add xdp_egress_prog to net_device
> to hold a reference to an attached program.
>
> For UAPI, add IFLA_XDP_EGRESS to if_link.h to specify egress programs,
> add a new attach flag, XDP_ATTACHED_EGRESS_CORE, to denote the
> attach point is at the core level (as opposed to driver or hardware)
> and add IFLA_XDP_EGRESS_CORE_PROG_ID for reporting the program id.
>
> Add egress argument to do_setlink_xdp to denote processing of
> IFLA_XDP_EGRESS versus IFLA_XDP, and add a check that none of the
> existing modes (SKB, DRV or HW) are set since those modes are not
> valid. The expectation is that XDP_FLAGS_HW_MODE will be used later
> (e.g., offloading guest programs).
>
> Add rtnl_xdp_egress_fill and helpers as the egress counterpart to the
> existing rtnl_xdp_fill.
>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/linux/netdevice.h          |   1 +
>  include/uapi/linux/if_link.h       |   3 +
>  net/core/rtnetlink.c               | 102 +++++++++++++++++++++++++++--
>  tools/include/uapi/linux/if_link.h |   3 +
>  4 files changed, 105 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a416c838b0ec..e157aed04e91 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1996,6 +1996,7 @@ struct net_device {
>  	unsigned int		real_num_rx_queues;
>  
>  	struct bpf_prog __rcu	*xdp_prog;
> +	struct bpf_prog __rcu	*xdp_egress_prog;
>  	unsigned long		gro_flush_timeout;
>  	rx_handler_func_t __rcu	*rx_handler;
>  	void __rcu		*rx_handler_data;
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 127c704eeba9..b3c6cb2f0f0a 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -170,6 +170,7 @@ enum {
>  	IFLA_PROP_LIST,
>  	IFLA_ALT_IFNAME, /* Alternative ifname */
>  	IFLA_PERM_ADDRESS,
> +	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
>  	__IFLA_MAX
>  };
>  
> @@ -988,6 +989,7 @@ enum {
>  	XDP_ATTACHED_SKB,
>  	XDP_ATTACHED_HW,
>  	XDP_ATTACHED_MULTI,
> +	XDP_ATTACHED_EGRESS_CORE,
>  };
>  
>  enum {
> @@ -1000,6 +1002,7 @@ enum {
>  	IFLA_XDP_SKB_PROG_ID,
>  	IFLA_XDP_HW_PROG_ID,
>  	IFLA_XDP_EXPECTED_FD,
> +	IFLA_XDP_EGRESS_CORE_PROG_ID,
>  	__IFLA_XDP_MAX,
>  };
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 4a3e85413688..e6f0eec99058 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1037,7 +1037,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
>  	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_PORT_ID */
>  	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_SWITCH_ID */
>  	       + nla_total_size(IFNAMSIZ) /* IFLA_PHYS_PORT_NAME */
> -	       + rtnl_xdp_size() /* IFLA_XDP */
> +	       + rtnl_xdp_size() * 2 /* IFLA_XDP and IFLA_XDP_EGRESS */
>  	       + nla_total_size(4)  /* IFLA_EVENT */
>  	       + nla_total_size(4)  /* IFLA_NEW_NETNSID */
>  	       + nla_total_size(4)  /* IFLA_NEW_IFINDEX */
> @@ -1402,6 +1402,42 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
>  	return 0;
>  }
>  
> +static u32 rtnl_xdp_egress_prog(struct net_device *dev)
> +{
> +	const struct bpf_prog *prog;
> +
> +	ASSERT_RTNL();
> +
> +	prog = rtnl_dereference(dev->xdp_egress_prog);
> +	if (!prog)
> +		return 0;
> +	return prog->aux->id;
> +}
> +
> +static int rtnl_xdp_egress_report(struct sk_buff *skb, struct net_device *dev,
> +				  u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
> +				  u32 (*get_prog_id)(struct net_device *dev))
> +{
> +	u32 curr_id;
> +	int err;
> +
> +	curr_id = get_prog_id(dev);
> +	if (!curr_id)
> +		return 0;
> +
> +	*prog_id = curr_id;
> +	err = nla_put_u32(skb, attr, curr_id);
> +	if (err)
> +		return err;
> +
> +	if (*mode != XDP_ATTACHED_NONE)
> +		*mode = XDP_ATTACHED_MULTI;
> +	else
> +		*mode = tgt_mode;
> +
> +	return 0;
> +}
> +
>  static u32 rtnl_xdp_prog_skb(struct net_device *dev)
>  {
>  	const struct bpf_prog *generic_xdp_prog;
> @@ -1493,6 +1529,42 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
>  	return err;
>  }
>  
> +static int rtnl_xdp_egress_fill(struct sk_buff *skb, struct net_device *dev)
> +{
> +	u8 mode = XDP_ATTACHED_NONE;
> +	struct nlattr *xdp;
> +	u32 prog_id = 0;
> +	int err;
> +
> +	xdp = nla_nest_start_noflag(skb, IFLA_XDP_EGRESS);
> +	if (!xdp)
> +		return -EMSGSIZE;
> +
> +	err = rtnl_xdp_egress_report(skb, dev, &prog_id, &mode,
> +				     XDP_ATTACHED_EGRESS_CORE,
> +				     IFLA_XDP_EGRESS_CORE_PROG_ID,
> +				     rtnl_xdp_egress_prog);
> +	if (err)
> +		goto err_cancel;
> +
> +	err = nla_put_u8(skb, IFLA_XDP_ATTACHED, mode);
> +	if (err)
> +		goto err_cancel;
> +
> +	if (prog_id && mode != XDP_ATTACHED_MULTI) {
> +		err = nla_put_u32(skb, IFLA_XDP_PROG_ID, prog_id);
> +		if (err)
> +			goto err_cancel;
> +	}
> +
> +	nla_nest_end(skb, xdp);
> +	return 0;
> +
> +err_cancel:
> +	nla_nest_cancel(skb, xdp);
> +	return err;
> +}
> +
>  static u32 rtnl_get_event(unsigned long event)
>  {
>  	u32 rtnl_event_type = IFLA_EVENT_NONE;
> @@ -1750,6 +1822,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>  	if (rtnl_xdp_fill(skb, dev))
>  		goto nla_put_failure;
>  
> +	if (rtnl_xdp_egress_fill(skb, dev))
> +		goto nla_put_failure;
> +
>  	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
>  		if (rtnl_link_fill(skb, dev) < 0)
>  			goto nla_put_failure;
> @@ -1834,6 +1909,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
>  				    .len = ALTIFNAMSIZ - 1 },
>  	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
> +	[IFLA_XDP_EGRESS]	= { .type = NLA_NESTED },
>  };
>  
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> @@ -2489,7 +2565,8 @@ static int do_set_master(struct net_device *dev, int ifindex,
>  #define DO_SETLINK_NOTIFY	0x03
>  
>  static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
> -			  int *status, struct netlink_ext_ack *extack)
> +			  int *status, bool egress,
> +			  struct netlink_ext_ack *extack)
>  {
>  	struct nlattr *xdp[IFLA_XDP_MAX + 1];
>  	u32 xdp_flags = 0;
> @@ -2505,6 +2582,10 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
>  
>  	if (xdp[IFLA_XDP_FLAGS]) {
>  		xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
> +		if (egress && xdp_flags & XDP_FLAGS_MODES) {
> +			NL_SET_ERR_MSG(extack, "XDP_FLAGS_MODES not valid for egress");
> +			goto out_einval;
> +		}
>  		if (xdp_flags & ~XDP_FLAGS_MASK)
>  			goto out_einval;
>  		if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1)
> @@ -2522,7 +2603,7 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
>  
>  		err = dev_change_xdp_fd(dev, extack,
>  					nla_get_s32(xdp[IFLA_XDP_FD]),
> -					expected_fd, xdp_flags, false);
> +					expected_fd, xdp_flags, egress);
>  		if (err)
>  			return err;
>  
> @@ -2827,8 +2908,21 @@ static int do_setlink(const struct sk_buff *skb,
>  		status |= DO_SETLINK_NOTIFY;
>  	}
>  
> +	if (tb[IFLA_XDP] && tb[IFLA_XDP_EGRESS]) {
> +		NL_SET_ERR_MSG(extack, "IFLA_XDP and IFLA_XDP_EGRESS can not be configured at the same time");
> +		err = -EINVAL;
> +		goto errout;
> +	}
> +
>  	if (tb[IFLA_XDP]) {
> -		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, extack);
> +		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, false, extack);
> +		if (err)
> +			goto errout;
> +	}
> +
> +	if (tb[IFLA_XDP_EGRESS]) {
> +		err = do_setlink_xdp(dev, tb[IFLA_XDP_EGRESS], &status, true,
> +				     extack);

While testing this yesterday, I ran into an issue where attaching an
XDP_EGRESS program would return no error, but nothing was happening.
Spent quite a bit of time scratching my head until I realised that my
test machine had failed to boot the patched kernel, and had fallen back
to an earlier version; i.e., didn't have any xdp_egress support at all.

I think this will be a problem: Since we don't reject unknown netlink
attributes, userspace can't know if xdp_egress is supported. So maybe
it's better to just re-use IFLA_XDP with a new flag, instead of using a
separate attribute?

-Toke

