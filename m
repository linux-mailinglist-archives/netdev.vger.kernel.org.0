Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036221D834
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgGMOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:19:48 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F153C061755;
        Mon, 13 Jul 2020 07:19:48 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 72so9633577otc.3;
        Mon, 13 Jul 2020 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=669zIvUcqwcPOJRHeySk+fGK3I4Na5NGEhqk/b1Erro=;
        b=INzRuWz9rItzsqPyumKDEG7ImXS5/LK/XouAqqJnEvtpqgChRdMlDC3nE27pZMo7P3
         ungVVIEopD8BB8FfsLUEb3JCOqH7GnC/6OGTuD5qNSImyUpkB5mSwxELATCJHhk9vet3
         gOxtODHTmc7LY6CiNxijwLCB59cwr35zjVXutpF59pXrsrzKMhjrsQUeLkVJze460jCm
         eZTvyhvLxJpPIl+29WNnAkg/Sv3YhraOt6izJJHoY4YmvW0SMbYDY5SH1LLaHgGfDq4Y
         C+k2qEX6k/lyYdoY4Tt83BXC9d511aAatDCB0uJTQhtkPE9b05+uXch66w5W0HTGgjnr
         mQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=669zIvUcqwcPOJRHeySk+fGK3I4Na5NGEhqk/b1Erro=;
        b=lfqpplGGg/mZqJsXi16LclO6043VUAeiLX+G6b2GYz0xzjHk5R8X6XkabSXd8794Pa
         Js7xjnCRA7iVFqKTc9hoJb6tPeaS9y5HginwQq5WiTrmxNvs2OSjbVfGY4dh0D3IUTjg
         J9pLPUo2TqNZITZCzg5Db/GFE7kJ52xeVqtNC0gGlrbqWCa/KazpovZfQ8sX99GTOntP
         KZe91blnEblB6erpyvDjcXpNTuvK73bsAs0OnA0MRJmsnzMLclkUptcHlD8yNAwndCsJ
         UQSiRB7cLdmeBRshnNFCjxqVLM2icxSNT02f6BGioY1vSueKHX9R14PZH2vKS5B3Xcu0
         tIZQ==
X-Gm-Message-State: AOAM5304OXZh/9ZnB2eTAJS59nyM8Hz5aoqnh+2pMqmFhdOZ3Iz5ssrk
        bDdpHXC2DTd6Y2i68Q8TpleRc9kL
X-Google-Smtp-Source: ABdhPJya+5ClqZrkEEQMtuGpb7WDDi9eJFAaPA8NiQX10Wh+r5OPxbWmH+mrfePF3s7pT7sEHNJ+gw==
X-Received: by 2002:a9d:1b0d:: with SMTP id l13mr36804363otl.145.1594649987538;
        Mon, 13 Jul 2020 07:19:47 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:a406:dd0d:c1f5:683e? ([2601:284:8202:10b0:a406:dd0d:c1f5:683e])
        by smtp.googlemail.com with ESMTPSA id q15sm2778397oij.54.2020.07.13.07.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 07:19:46 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment
 API
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20200710224924.4087399-1-andriin@fb.com>
 <20200710224924.4087399-3-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <58dd821b-c9b2-ac45-d47a-e5f75aec3d68@gmail.com>
Date:   Mon, 13 Jul 2020 08:19:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710224924.4087399-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 4:49 PM, Andrii Nakryiko wrote:
> Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program through
> BPF_LINK_CREATE command.
> 
> bpf_xdp_link is mutually exclusive with direct BPF program attachment,
> previous BPF program should be detached prior to attempting to create a new
> bpf_xdp_link attachment (for a given XDP mode). Once link is attached, it
> can't be replaced by other BPF program attachment or link attachment. It will
> be detached only when the last BPF link FD is closed.
> 
> bpf_xdp_link will be auto-detached when net_device is shutdown, similarly to
> how other BPF links behave (cgroup, flow_dissector). At that point bpf_link
> will become defunct, but won't be destroyed until last FD is closed.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/netdevice.h |   6 +
>  include/uapi/linux/bpf.h  |   7 +-
>  kernel/bpf/syscall.c      |   5 +
>  net/core/dev.c            | 385 ++++++++++++++++++++++++++++----------

That's big diff for 1 patch. A fair bit of is refactoring / code
movement that can be done in a separate refactoring patch making it
cleaer what changes you need for the bpf_link piece.


>  4 files changed, 301 insertions(+), 102 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d5630e535836..93bcd81d645d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -886,6 +886,7 @@ struct bpf_prog_offload_ops;
>  struct netlink_ext_ack;
>  struct xdp_umem;
>  struct xdp_dev_bulk_queue;
> +struct bpf_xdp_link;
>  
>  enum bpf_xdp_mode {
>  	XDP_MODE_SKB = 0,
> @@ -896,6 +897,7 @@ enum bpf_xdp_mode {
>  
>  struct bpf_xdp_entity {
>  	struct bpf_prog *prog;
> +	struct bpf_xdp_link *link;
>  };
>  
>  struct netdev_bpf {
> @@ -3824,6 +3826,10 @@ typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
>  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		      int fd, int expected_fd, u32 flags);
>  u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
> +
> +struct bpf_xdp_link;

already stated above.

> +int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> +
>  int xdp_umem_query(struct net_device *dev, u16 queue_id);
>  
>  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 548a749aebb3..41eba148217b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -227,6 +227,7 @@ enum bpf_attach_type {
>  	BPF_CGROUP_INET6_GETSOCKNAME,
>  	BPF_XDP_DEVMAP,
>  	BPF_CGROUP_INET_SOCK_RELEASE,
> +	BPF_XDP,

This really does not add value for the uapi. The link_type uniquely
identifies the type and the expected program type.

>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> @@ -239,6 +240,7 @@ enum bpf_link_type {
>  	BPF_LINK_TYPE_CGROUP = 3,
>  	BPF_LINK_TYPE_ITER = 4,
>  	BPF_LINK_TYPE_NETNS = 5,
> +	BPF_LINK_TYPE_XDP = 6,
>  
>  	MAX_BPF_LINK_TYPE,
>  };
> @@ -604,7 +606,10 @@ union bpf_attr {
>  
>  	struct { /* struct used by BPF_LINK_CREATE command */
>  		__u32		prog_fd;	/* eBPF program to attach */
> -		__u32		target_fd;	/* object to attach to */
> +		union {
> +			__u32		target_fd;	/* object to attach to */
> +			__u32		target_ifindex; /* target ifindex */
> +		};
>  		__u32		attach_type;	/* attach type */
>  		__u32		flags;		/* extra flags */
>  	} link_create;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 156f51ffada2..eb4ed4b29418 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2817,6 +2817,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>  		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
>  	case BPF_TRACE_ITER:
>  		return BPF_PROG_TYPE_TRACING;
> +	case BPF_XDP:
> +		return BPF_PROG_TYPE_XDP;
>  	default:
>  		return BPF_PROG_TYPE_UNSPEC;
>  	}
> @@ -3890,6 +3892,9 @@ static int link_create(union bpf_attr *attr)
>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>  		ret = netns_bpf_link_create(attr, prog);
>  		break;
> +	case BPF_PROG_TYPE_XDP:
> +		ret = bpf_xdp_link_attach(attr, prog);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d3b82b664e2d..84f755a1ec36 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8713,8 +8713,47 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
>  }
>  EXPORT_SYMBOL(dev_change_proto_down_generic);
>  
> -static struct bpf_prog *dev_xdp_prog(struct net_device *dev, enum bpf_xdp_mode mode)
> +struct bpf_xdp_link {
> +	struct bpf_link link;
> +	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
> +	int flags;
> +};
> +
> +static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
> +{
> +	if (flags & XDP_FLAGS_HW_MODE)
> +		return XDP_MODE_HW;
> +	if (flags & XDP_FLAGS_DRV_MODE)
> +		return XDP_MODE_DRV;
> +	return XDP_MODE_SKB;
> +}
> +
> +static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
>  {
> +	switch (mode) {
> +	case XDP_MODE_SKB:
> +		return generic_xdp_install;
> +	case XDP_MODE_DRV:
> +	case XDP_MODE_HW:
> +		return dev->netdev_ops->ndo_bpf;
> +	default:
> +		return NULL;
> +	};
> +}
> +
> +static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
> +					 enum bpf_xdp_mode mode)
> +{
> +	return dev->xdp_state[mode].link;
> +}
> +
> +static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
> +				     enum bpf_xdp_mode mode)
> +{
> +	struct bpf_xdp_link *link = dev_xdp_link(dev, mode);
> +
> +	if (link)
> +		return link->link.prog;
>  	return dev->xdp_state[mode].prog;
>  }
>  
> @@ -8725,9 +8764,17 @@ u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
>  	return prog ? prog->aux->id : 0;
>  }
>  
> +static void dev_xdp_set_link(struct net_device *dev, enum bpf_xdp_mode mode,
> +			     struct bpf_xdp_link *link)
> +{
> +	dev->xdp_state[mode].link = link;
> +	dev->xdp_state[mode].prog = NULL;
> +}
> +
>  static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode mode,
>  			     struct bpf_prog *prog)
>  {
> +	dev->xdp_state[mode].link = NULL;
>  	dev->xdp_state[mode].prog = prog;
>  }
>  
> @@ -8744,6 +8791,14 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
>  	xdp.flags = flags;
>  	xdp.prog = prog;
>  
> +	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
> +	 * "moved" into driver), so they don't increment it on their own, but
> +	 * they do decrement refcnt when program is detached or replaced.
> +	 * Given net_device also owns link/prog, we need to bump refcnt here
> +	 * to prevent drivers from underflowing it.
> +	 */
> +	if (prog)
> +		bpf_prog_inc(prog);

Why is this refcnt bump not needed today but is needed for your change?

>  	err = bpf_op(dev, &xdp);
>  	if (err)
>  		return err;

and the error path is not decrementing it.

> @@ -8756,39 +8811,221 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
>  
>  static void dev_xdp_uninstall(struct net_device *dev)
>  {
> -	bpf_op_t ndo_bpf;
> +	struct bpf_xdp_link *link;
> +	struct bpf_prog *prog;
> +	enum bpf_xdp_mode mode;
> +	bpf_op_t bpf_op;
>  
> -	/* Remove generic XDP */
> -	WARN_ON(dev_xdp_install(dev, XDP_MODE_SKB, generic_xdp_install,
> -				NULL, 0, NULL));
> -	dev_xdp_set_prog(dev, XDP_MODE_SKB, NULL);
> +	ASSERT_RTNL();
>  
> -	/* Remove from the driver */
> -	ndo_bpf = dev->netdev_ops->ndo_bpf;
> -	if (!ndo_bpf)
> -		return;
> +	for (mode = XDP_MODE_SKB; mode < __MAX_XDP_MODE; mode++) {
> +		prog = dev_xdp_prog(dev, mode);
> +		if (!prog)
> +			continue;
> +
> +		bpf_op = dev_xdp_bpf_op(dev, mode);
> +		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
> +
> +		/* auto-detach link from net device */
> +		link = dev_xdp_link(dev, mode);
> +		if (link)
> +			link->dev = NULL;
> +		else
> +			bpf_prog_put(prog);
> +
> +		dev_xdp_set_link(dev, mode, NULL);
> +	}
> +}
> +
> +static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack,
> +			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
> +			  struct bpf_prog *old_prog, u32 flags)
> +{
> +	struct bpf_prog *cur_prog;
> +	enum bpf_xdp_mode mode;
> +	bpf_op_t bpf_op;
> +	int err;
> +
> +	ASSERT_RTNL();
>  
> -	if (dev_xdp_prog_id(dev, XDP_MODE_DRV)) {
> -		WARN_ON(dev_xdp_install(dev, XDP_MODE_DRV, ndo_bpf,
> -					NULL, 0, NULL));
> -		dev_xdp_set_prog(dev, XDP_MODE_DRV, NULL);
> +	/* link supports only XDP mode flags */
> +	if (link && (flags & ~XDP_FLAGS_MODES))
> +		return -EINVAL;

everyone of the -errno returns needs an extack message explaining why
