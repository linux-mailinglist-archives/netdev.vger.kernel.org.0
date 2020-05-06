Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92881C6CA4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgEFJPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728385AbgEFJPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:15:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB44C061A0F;
        Wed,  6 May 2020 02:15:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s20so238122plp.6;
        Wed, 06 May 2020 02:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GHTuD7z8HT04Mp58KOzS9FGB9ObUo6rHxMN4v5nOPk0=;
        b=Qf0KRvxNhPYiWMMe/dB8hDjj+Qym60FOKkaZMMhbTXRxwTx4ti555dj8oJ+s+E06MD
         Y/99v00xBxaUMP2DorA799yLSeCxgHefsG6TtzWNOGGrjc8YrYM9lf3eILsl5B4hL6Gg
         FD5lz40Vm8ByBnG8xrPnRuKTpnGhwTbcRoBxy8m156QNry4yeFTyEaKZjipYGr/JNMX/
         4lYZNlAdLv8VOGoCb2F1nnkNqkwTtSaVVZQsNSNuOD0YLJ4MDcBl0yQ6ZVxCS2pMImmO
         ROld0HDltNq4xbjJwbAc2t0wH6fpHCJapnFNtJcS1lkz8vFgw4FVktYXs0J+E8dSZNfM
         aMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GHTuD7z8HT04Mp58KOzS9FGB9ObUo6rHxMN4v5nOPk0=;
        b=REAz1uR8iE7PtjUQ71blA9kpMTOFeDIt0EvKn1Ybp0LYYn0GFWepEyCfvh1XyG+Eg+
         dXi2ID14IRQxLe5E5YqwSMU4DPZ3or+IzcOEMFHpedghLBhVus10OUT6d7CjpHJwcBN3
         TpPUE9pD32dppz4cu8V2DJcAfrnNjKJT6j6A2eNHNRqNK766XyOfYBNS/OYkYXsN3nRT
         F5ePFmepHuQYDIZWt8C3tzSM2QUtb0HWzBtFnbwQ/UoJs5c5R8QHesewTMCWc9LRlAU7
         SEppuccBgaDEStCdtuHUAH90MXL74RJo75i/fGiSslHv7/43xwHIAulYmUoxG4D0hL6Z
         j1zw==
X-Gm-Message-State: AGi0Pub+1JakFybPQ7aqKr5nKiAot111SX+y2Wjh3mV+gWa1CLfj9jtw
        ifpIS49p2PCx7doFaUgTjTE=
X-Google-Smtp-Source: APiQypIBpic8ukiu0AOeIvYkazFi5Jkb9smeRrLwj5F2Vgu/Bj53G93Ke+0jyXGOLGNrxgVvLbviMg==
X-Received: by 2002:a17:90a:9295:: with SMTP id n21mr8360641pjo.195.1588756542974;
        Wed, 06 May 2020 02:15:42 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e2sm4150086pjt.2.2020.05.06.02.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:15:42 -0700 (PDT)
Date:   Wed, 6 May 2020 17:14:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200506091442.GA102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-2-liuhangbin@gmail.com>
 <87r1wd2bqu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1wd2bqu.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

Thanks for your review, please see replies below.

On Fri, Apr 24, 2020 at 04:34:49PM +0200, Toke Høiland-Jørgensen wrote:
> >
> > The general data path is kept in net/core/filter.c. The native data
> > path is in kernel/bpf/devmap.c so we can use direct calls to
> > get better performace.
> 
> Got any performance numbers? :)

No, I haven't test the performance. Do you have any suggestions about how
to test it? I'd like to try forwarding pkts to 10+ ports. But I don't know
how to test the throughput. I don't think netperf or iperf supports this.
> 
> > + * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
> > + * 	Description
> > + * 		Redirect the packet to all the interfaces in *map*, and
> > + * 		exclude the interfaces that in *ex_map*. The *ex_map* could
> > + * 		be NULL.
> > + *
> > + * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
> > + * 		which could exlcude redirect to the ingress device.
> 
> I'd suggest rewording this to:
> 
> * 		Redirect the packet to ALL the interfaces in *map*, but
> * 		exclude the interfaces in *ex_map* (which may be NULL).
> *
> * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
> * 		which additionally excludes the current ingress device.

Thanks, I will update it
> > +
> > +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> > +			int exclude_ifindex)
> > +{
> > +	struct bpf_dtab_netdev *in_obj = NULL;
> > +	u32 key, next_key;
> > +	int err;
> > +
> > +	if (!map)
> > +		return false;
> > +
> > +	if (obj->dev->ifindex == exclude_ifindex)
> > +		return true;
> 
> We probably want the EXCLUDE_INGRESS flag to work even if ex_map is
> NULL, right? In that case you want to switch the order of the two checks
> above.

Yes, will fix it.

> 
> > +	devmap_get_next_key(map, NULL, &key);
> > +
> > +	for (;;) {
> 
> I wonder if we should require DEVMAP_HASH maps to be indexed by ifindex
> to avoid the loop?

I guess it's not easy to force user to index the map by ifindex.

> > +	xdpf = convert_to_xdp_frame(xdp);
> > +	if (unlikely(!xdpf))
> > +		return -EOVERFLOW;
> 
> You do a clone for each map entry below, so I think you end up leaking
> this initial xdpf? Also, you'll end up with one clone more than
> necessary - redirecting to two interfaces should only require 1 clone,
> you're doing 2.

We don't know which is the latest one. So we need to keep the initial
for clone. Is it enough to call xdp_release_frame() after the for loop?
> 
> > +	for (;;) {
> > +		switch (map->map_type) {
> > +		case BPF_MAP_TYPE_DEVMAP:
> > +			obj = __dev_map_lookup_elem(map, key);
> > +			break;
> > +		case BPF_MAP_TYPE_DEVMAP_HASH:
> > +			obj = __dev_map_hash_lookup_elem(map, key);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +
> > +		if (!obj || dev_in_exclude_map(obj, ex_map,
> > +					       exclude_ingress ? dev_rx->ifindex : 0))
> > +			goto find_next;
> > +
> > +		dev = obj->dev;
> > +
> > +		if (!dev->netdev_ops->ndo_xdp_xmit)
> > +			return -EOPNOTSUPP;
> > +
> > +		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> > +		if (unlikely(err))
> > +			return err;
> 
> These abort the whole operation midway through the loop if any error
> occurs. That is probably not what we want? I think the right thing to do
> is just continue the loop and only return an error if *all* of the
> forwarding attempts failed. Maybe we need a tracepoint to catch
> individual errors?

Makes sense. I will see if we can add a tracepoint here.
> >  
> > +static int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
> > +				  struct bpf_prog *xdp_prog,
> > +				  struct bpf_map *map, struct bpf_map *ex_map,
> > +				  bool exclude_ingress)
> > +
> > +{
> > +	struct bpf_dtab_netdev *dst;
> > +	struct sk_buff *nskb;
> > +	u32 key, next_key;
> > +	int err;
> > +	void *fwd;
> > +
> > +	/* Get first key from forward map */
> > +	map->ops->map_get_next_key(map, NULL, &key);
> > +
> > +	for (;;) {
> > +		fwd = __xdp_map_lookup_elem(map, key);
> > +		if (fwd) {
> > +			dst = (struct bpf_dtab_netdev *)fwd;
> > +			if (dev_in_exclude_map(dst, ex_map,
> > +					       exclude_ingress ? dev->ifindex : 0))
> > +				goto find_next;
> > +
> > +			nskb = skb_clone(skb, GFP_ATOMIC);
> > +			if (!nskb)
> > +				return -EOVERFLOW;
> > +
> > +			err = dev_map_generic_redirect(dst, nskb, xdp_prog);
> > +			if (unlikely(err))
> > +				return err;
> > +		}
> > +
> > +find_next:
> > +		err = map->ops->map_get_next_key(map, &key, &next_key);
> > +		if (err)
> > +			break;
> > +
> > +		key = next_key;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> This duplication bugs me; maybe we should try to consolidate the generic
> and native XDP code paths?

Yes, I have tried to combine these two functions together. But one is generic
code path and another is XDP code patch. One use skb_clone and another
use xdpf_clone(). There are also some extra checks for XDP code. So maybe
we'd better just keep it as it is.

> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 2e29a671d67e..1dbe42290223 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> 
> Updates to tools/include should generally go into a separate patch.

Will fix it, thanks.

Best Regards
Hangbin
