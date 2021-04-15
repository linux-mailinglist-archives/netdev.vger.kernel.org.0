Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5557A35FFF1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhDOCWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhDOCWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:22:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69866C061574;
        Wed, 14 Apr 2021 19:21:40 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so13517301pjb.4;
        Wed, 14 Apr 2021 19:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EOb9rPznoEXcqGxotMq6uaL/+ylKCtr4fu4Yg5khbEg=;
        b=DqhOdMeCkkpe/3JASv0jhLkmlj97Nk3h3NoCaE19XJWoB0TJ+EcZ4RTpgdRIj+Fn16
         tLkKQHQxxm6dMn6Xr5YOY5OulAfYzTq4KTa14QUMEsMLFdBmOfRN2Crw54RCME4sNUTg
         fFFmgxtAKJ7weheB7hcCTPxs4/gSZIdbl7gFIUtl76+bwlpDia/iRkzKP4x0xsrHfMyt
         2BS2nnkfw6Vuz6VN8lsjAyVNrxg/txAFVk/gDj/389hd9Zc5T9ynn/fZ93K9+2Qu6VtB
         NqSV6kCWck0CNgHCOwEWOEdgmkLISRtPGVSNFY3TO620OcQOPPiTJs0aGFVdGwrUkwKG
         aedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EOb9rPznoEXcqGxotMq6uaL/+ylKCtr4fu4Yg5khbEg=;
        b=VZw8LZk3FUSaQr37w66FzOzYRrZK85DyKXSLq4ZG2Sw+s/zvs2pIANrNxRSRJqCZ2b
         9oi75bJlG5WMIA0bfyo3TzdJG1bPLBNeSTsbs9OYcpLkWRrR/elkAKuikJ7d00l5sDzc
         DJSEFGeDfz8mvYdh+aIyB325FwoWREgRIcmYIy4/sHVKlibuJaSjuF6oZgQZub/fFZm9
         Ne4MJyYv9W0vFCB2lcYqS07i5Znf9WUPQfikIcmghBmsJEyRhRnALD74VBDJnpz9Y6re
         wcV9nCU3P3IHQLuPfAUTtArz/wjuM5X5P7+wiKIbe2XGj1zWCV7yqyQ5gEQys4WNaAtW
         YlaA==
X-Gm-Message-State: AOAM5326cEECpUGNUc95hhJEejmNWl1NYfi0KbYjcyOqsu05zP9BZG4A
        YGYqptQ+BcgkPxT6w88dqYg=
X-Google-Smtp-Source: ABdhPJwfy/Qc5zG9+vJX9mKj+w4aDTEC/7MRMTjtFpppJ23ROzT2RA0LxsuTKpO984UYHthCohlKog==
X-Received: by 2002:a17:902:7403:b029:e9:d170:5b11 with SMTP id g3-20020a1709027403b02900e9d1705b11mr1425760pll.50.1618453299992;
        Wed, 14 Apr 2021 19:21:39 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k3sm587550pfh.12.2021.04.14.19.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 19:21:39 -0700 (PDT)
Date:   Thu, 15 Apr 2021 10:21:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210415022127.GQ2900@Leo-laptop-t470s>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-3-liuhangbin@gmail.com>
 <20210415002350.247ni4rqjwzguu4j@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415002350.247ni4rqjwzguu4j@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:23:50PM -0700, Martin KaFai Lau wrote:
> On Wed, Apr 14, 2021 at 08:26:08PM +0800, Hangbin Liu wrote:
> [ ... ]
> 
> > +static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
> > +						  u64 flags, u64 flag_mask,
> >  						  void *lookup_elem(struct bpf_map *map, u32 key))
> >  {
> >  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> >  
> >  	/* Lower bits of the flags are used as return code on lookup failure */
> > -	if (unlikely(flags > XDP_TX))
> > +	if (unlikely(flags & ~(BPF_F_ACTION_MASK | flag_mask)))
> >  		return XDP_ABORTED;
> >  
> >  	ri->tgt_value = lookup_elem(map, ifindex);
> > -	if (unlikely(!ri->tgt_value)) {
> > +	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
> >  		/* If the lookup fails we want to clear out the state in the
> >  		 * redirect_info struct completely, so that if an eBPF program
> >  		 * performs multiple lookups, the last one always takes
> > @@ -1482,13 +1484,21 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
> >  		 */
> >  		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
> >  		ri->map_type = BPF_MAP_TYPE_UNSPEC;
> > -		return flags;
> > +		return flags & BPF_F_ACTION_MASK;
> >  	}
> >  
> >  	ri->tgt_index = ifindex;
> >  	ri->map_id = map->id;
> >  	ri->map_type = map->map_type;
> >  
> > +	if (flags & BPF_F_BROADCAST) {
> > +		WRITE_ONCE(ri->map, map);
> Why only WRITE_ONCE on ri->map?  Is it needed?

I think this is make sure the map pointer assigned to ri->map safely.
which starts from commit f6069b9aa993 ("bpf: fix redirect to map under tail
calls")

> 
> > +		ri->flags = flags;
> > +	} else {
> > +		WRITE_ONCE(ri->map, NULL);
> > +		ri->flags = 0;
> > +	}
> > +
> >  	return XDP_REDIRECT;
> >  }
> >  
> [ ... ]
> 
> > +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> > +			  struct bpf_map *map, bool exclude_ingress)
> > +{
> > +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> > +	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
> > +	struct bpf_dtab_netdev *dst, *last_dst = NULL;
> > +	struct hlist_head *head;
> > +	struct hlist_node *next;
> > +	struct xdp_frame *xdpf;
> > +	unsigned int i;
> > +	int err;
> > +
> > +	xdpf = xdp_convert_buff_to_frame(xdp);
> > +	if (unlikely(!xdpf))
> > +		return -EOVERFLOW;
> > +
> > +	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
> > +		for (i = 0; i < map->max_entries; i++) {
> > +			dst = READ_ONCE(dtab->netdev_map[i]);
> > +			if (!is_valid_dst(dst, xdp, exclude_ifindex))
> > +				continue;
> > +
> > +			/* we only need n-1 clones; last_dst enqueued below */
> > +			if (!last_dst) {
> > +				last_dst = dst;
> > +				continue;
> > +			}
> > +
> > +			err = dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
> > +			if (err)
> > +				return err;
> > +
> > +			last_dst = dst;
> > +		}
> > +	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
> > +		for (i = 0; i < dtab->n_buckets; i++) {
> > +			head = dev_map_index_hash(dtab, i);
> > +			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
> hmm.... should it be hlist_for_each_entry_rcu() instead?

Ah, makes sense to me. I will fix it.

Thanks
Hangbin
