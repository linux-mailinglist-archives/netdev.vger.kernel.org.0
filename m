Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DEB2F9686
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 01:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbhARALf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 19:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbhARALb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 19:11:31 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002C6C061573;
        Sun, 17 Jan 2021 16:10:50 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y19so29654257iov.2;
        Sun, 17 Jan 2021 16:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FqsjQwQKA1gw4+j522YIQEQoxr3GnpyQrRbljAkYheY=;
        b=Ij5YKx2YiEtaoNqOoN9HwTO4/F/28R2Af+4gkJW8eGhWqIyhnsBNOFST23yJr0cFh/
         7fzRTgAaQc6Fe1S3bxyjzBmCRceKqjUogfztvlwx8uADPL4avY5W1Cgejem9hkj8AeaN
         A7cJxl5UJjSfc4FRCLzH7QXpUX2GiXNyzUMeMXhfw+i+gn1zFfbNJIdcAShLXEJCn26D
         17nS7i34wq+7J5b3cxY8+9NaMBYB0rzgbocaTgx7EWf3w76/+JnOAh3FMnYWntCBKloG
         MOuuU6rBugjbVM1LwJdfppAJ3d9j9NJt4vdYkKvHqMO7BEmUXMeYSeNLtuH2JSu5eIuo
         /vRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FqsjQwQKA1gw4+j522YIQEQoxr3GnpyQrRbljAkYheY=;
        b=p1rQ8FKC46Xcu0QmDcYAy4cMAdOGAqLPMQ2GJKM6T/39Q2azKrIArW4QEuFfeG9r7n
         P00NXKXTWbf76/oJEuTzxA9yB9Ln7HxrgIdijv/MvDD1GrS3T6wtO19PMNc0Wbkb3It1
         4e4Qtq7WY5FCjDFezZrdvY2IH4zZlLYHVq99Qfr1Am1pGSeDTObQVtx7zQIVgMcds2L2
         l5PfVV7wGT/oDJtTBGA56fkr2VxGF4ACGraJFfA6PqhyM0JCjWkr6s8hPrQ7RJrnHFrh
         617p978XoJ9WMSwOfPYOI6AJbIDpviTGvKeAZKxN4uwOf+mSTh/JY8E4afW0RuxtEuL9
         n+1w==
X-Gm-Message-State: AOAM530DTrdBw72xc8NnyBza76KK1sK+iy/wLY9m+iwqr1N1N9d1FL+c
        kJORjIrbIMS7FNHNUQeLRBI=
X-Google-Smtp-Source: ABdhPJz9fb0PS7SNK4Jti7Ll6oLGm5wmSqWZ4NQhTIkP5BZ406WD5nkHN6XTuThp08sgmR8vhc+s4g==
X-Received: by 2002:a92:1589:: with SMTP id 9mr18399403ilv.39.1610928650204;
        Sun, 17 Jan 2021 16:10:50 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id f80sm4544715ilg.8.2021.01.17.16.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 16:10:49 -0800 (PST)
Date:   Sun, 17 Jan 2021 16:10:40 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <6004d200d0d10_266420825@john-XPS-13-9370.notmuch>
In-Reply-To: <20210114142321.2594697-4-liuhangbin@gmail.com>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210114142321.2594697-4-liuhangbin@gmail.com>
Subject: RE: [PATCHv14 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> This patch is for xdp multicast support. which has been discussed
> before[0], The goal is to be able to implement an OVS-like data plane in
> XDP, i.e., a software switch that can forward XDP frames to multiple ports.
> 
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
> 
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because a
> physical interface can be part of a logical grouping, such as a bond
> device.
> 
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.
> 
> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. The forwarding
> map could be DEVMAP or DEVMAP_HASH, but the exclude map *must* be
> DEVMAP_HASH to get better performace. If user don't want to use exclude
> map and just want simply stop redirecting back to ingress device, they
> can use flag BPF_F_EXCLUDE_INGRESS.
> 
> As both bpf_xdp_redirect_map() and this new helpers are using struct
> bpf_redirect_info, I add a new ex_map and set tgt_value to NULL in the
> new helper to make a difference with bpf_xdp_redirect_map().
> 
> Also I keep the general data path in net/core/filter.c, the native data
> path in kernel/bpf/devmap.c so we can use direct calls to get better
> performace.

[...]

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 0cf3976ce77c..0e6468cd0ab9 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -164,6 +164,7 @@ void xdp_warn(const char *msg, const char *func, const int line);
>  #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
>  
>  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
>  
>  static inline
>  void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a1ad32456f89..ecf5d117b96a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3830,6 +3830,27 @@ union bpf_attr {
>   *	Return
>   *		A pointer to a struct socket on success or NULL if the file is
>   *		not a socket.
> + *
> + * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
> + * 	Description
> + * 		This is a multicast implementation for XDP redirect. It will
> + * 		redirect the packet to ALL the interfaces in *map*, but
> + * 		exclude the interfaces in *ex_map*.
> + *
> + * 		The forwarding *map* could be either BPF_MAP_TYPE_DEVMAP or
> + * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
> + * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.

Would be good to add a note ex_map _must_ be keyed by ifindex for the
helper to work. Its the obvious way to key a hashmap, but not required
iirc.

> + *
> + * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
> + * 		which additionally excludes the current ingress device.
> + *
> + * 		See also bpf_redirect_map() as a unicast implementation,
> + * 		which supports redirecting packet to a specific ifindex
> + * 		in the map. As both helpers use struct bpf_redirect_info
> + * 		to store the redirect info, we will use a a NULL tgt_value
> + * 		to distinguish multicast and unicast redirecting.
> + * 	Return
> + * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
>   */

[...]

> +
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, struct bpf_map *ex_map,
> +			  u32 flags)
> +{
> +	struct bpf_dtab_netdev *obj = NULL, *next_obj = NULL;
> +	struct xdp_frame *xdpf, *nxdpf;
> +	bool last_one = false;
> +	int ex_ifindex;
> +	u32 key, next_key;
> +
> +	ex_ifindex = flags & BPF_F_EXCLUDE_INGRESS ? dev_rx->ifindex : 0;
> +
> +	/* Find first available obj */
> +	obj = devmap_get_next_obj(xdp, map, ex_map, NULL, &key, ex_ifindex);
> +	if (!obj)
> +		return 0;
> +
> +	xdpf = xdp_convert_buff_to_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	for (;;) {
> +		/* Check if we still have one more available obj */
> +		next_obj = devmap_get_next_obj(xdp, map, ex_map, &key,
> +					       &next_key, ex_ifindex);
> +		if (!next_obj)
> +			last_one = true;
> +
> +		if (last_one) {
> +			bq_enqueue(obj->dev, xdpf, dev_rx, obj->xdp_prog);
> +			return 0;
> +		}

Just collapse above to

  if (!next_obj) {
        bq_enqueue()
        return
  }

'last_one' is a bit pointless here.

> +
> +		nxdpf = xdpf_clone(xdpf);
> +		if (unlikely(!nxdpf)) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			return -ENOMEM;
> +		}
> +
> +		bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
> +
> +		/* Deal with next obj */
> +		obj = next_obj;
> +		key = next_key;
> +	}
> +}
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
>  			     struct bpf_prog *xdp_prog)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3e4b5d9fce78..2139398057cf 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4420,6 +4420,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  	case BPF_MAP_TYPE_DEVMAP:
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
>  		if (func_id != BPF_FUNC_redirect_map &&
> +		    func_id != BPF_FUNC_redirect_map_multi &&
>  		    func_id != BPF_FUNC_map_lookup_elem)
>  			goto error;
>  		break;
> @@ -4524,6 +4525,11 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		    map->map_type != BPF_MAP_TYPE_XSKMAP)
>  			goto error;
>  		break;
> +	case BPF_FUNC_redirect_map_multi:
> +		if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
> +		    map->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
> +			goto error;
> +		break;
>  	case BPF_FUNC_sk_redirect_map:
>  	case BPF_FUNC_msg_redirect_map:
>  	case BPF_FUNC_sock_map_update:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9ab94e90d660..123efaf4ab88 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3924,12 +3924,19 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
>  };
>  
>  static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
> -			    struct bpf_map *map, struct xdp_buff *xdp)
> +			    struct bpf_map *map, struct xdp_buff *xdp,
> +			    struct bpf_map *ex_map, u32 flags)
>  {
>  	switch (map->map_type) {
>  	case BPF_MAP_TYPE_DEVMAP:
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		return dev_map_enqueue(fwd, xdp, dev_rx);
> +		/* We use a NULL fwd value to distinguish multicast
> +		 * and unicast forwarding
> +		 */
> +		if (fwd)
> +			return dev_map_enqueue(fwd, xdp, dev_rx);
> +		else
> +			return dev_map_enqueue_multi(xdp, dev_rx, map, ex_map, flags);
>  	case BPF_MAP_TYPE_CPUMAP:
>  		return cpu_map_enqueue(fwd, xdp, dev_rx);
>  	case BPF_MAP_TYPE_XSKMAP:
> @@ -3986,12 +3993,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  	struct bpf_map *map = READ_ONCE(ri->map);
> +	struct bpf_map *ex_map = ri->ex_map;

READ_ONCE(ri->ex_map)?

>  	u32 index = ri->tgt_index;
>  	void *fwd = ri->tgt_value;
>  	int err;
>  
>  	ri->tgt_index = 0;
>  	ri->tgt_value = NULL;
> +	ri->ex_map = NULL;

WRITE_ONCE(ri->ex_map)?

>  	WRITE_ONCE(ri->map, NULL);

So we needed write_once, read_once pairs for ri->map do we also need them in
the ex_map case?

>  
>  	if (unlikely(!map)) {
> @@ -4003,7 +4012,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  
>  		err = dev_xdp_enqueue(fwd, xdp, dev);
>  	} else {
> -		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
> +		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, ex_map, ri->flags);
>  	}
>  
>  	if (unlikely(err))
> @@ -4017,6 +4026,62 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_redirect);

[...]

> +BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
> +	   struct bpf_map *, ex_map, u64, flags)
> +{
> +	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +
> +	/* Limit ex_map type to DEVMAP_HASH to get better performance */
> +	if (unlikely((ex_map && ex_map->map_type != BPF_MAP_TYPE_DEVMAP_HASH) ||
> +		     flags & ~BPF_F_EXCLUDE_INGRESS))
> +		return XDP_ABORTED;
> +
> +	ri->tgt_index = 0;
> +	/* Set the tgt_value to NULL to distinguish with bpf_xdp_redirect_map */
> +	ri->tgt_value = NULL;
> +	ri->flags = flags;
> +	ri->ex_map = ex_map;

WRITE_ONCE?

> +
> +	WRITE_ONCE(ri->map, map);
> +
> +	return XDP_REDIRECT;
> +}
> +
> +static const struct bpf_func_proto bpf_xdp_redirect_map_multi_proto = {
> +	.func           = bpf_xdp_redirect_map_multi,
> +	.gpl_only       = false,
> +	.ret_type       = RET_INTEGER,
> +	.arg1_type      = ARG_CONST_MAP_PTR,
> +	.arg2_type      = ARG_CONST_MAP_PTR_OR_NULL,
> +	.arg3_type      = ARG_ANYTHING,
> +};
> +

Thanks,
John
