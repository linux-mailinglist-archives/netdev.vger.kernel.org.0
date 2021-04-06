Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84FA354D01
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244044AbhDFGiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbhDFGis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:38:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F072DC06174A;
        Mon,  5 Apr 2021 23:38:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t23so4140126pjy.3;
        Mon, 05 Apr 2021 23:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5gpYD2QirgoNDVu+wPFaX3j6NElwnydYQhPuxHV70c4=;
        b=HiwF5EmsrOywP4B4G5JJz85LdHCTS3AI9pcr6ufxwL9ZFOo38g1TfsnQwAV3Cs1i4c
         pRs8PnwxcYWBqAw9TNorw6hi89ASY7tPtBx/ZvzSQQz80a/uskVk4iuX+ZITzx0DkYtk
         47HGlvj4cXlUsHrbZz7PYvbYlQEAoyFbDCTu8WuCFsaNJVTANGLP5BbHnwq2HBscs54G
         upLNbrl7F0+nCSNq0QZrpHbRtSGJGsvB/xOob0yjx2/XCpTRuG9ye/RzS/Z4pKkY2l10
         PDOIDr98LT0ThdVAq73ezHWWWc5ruWxvr6TLHCMiupDB3RrO9y2MDcMzknUEgGCUtSRI
         QQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5gpYD2QirgoNDVu+wPFaX3j6NElwnydYQhPuxHV70c4=;
        b=uX2yh03TwSITS3Rlz9VO55zL0KUmRWVNcQaCGw2Vfua7ON7Vf39lO7UuccuLR78KQ0
         Jl2ZQiiEz5Qqm9IUj1DGOZh5AiYdgbnfOefKdKwsl1qxB7ZHhs+jOn+vQ06lSV51VIe1
         yTzmbgLApJwtlKW0LXYvVg52ARzyrSQ8XhiTsCu+MGgNYwInXzRNO7in4KXhUZaLu4Y3
         iAb3Ce4KjoZmvaA0YzTDdvYXiv06oDdCwGNtmJea0RfNenR3UwpuCsdBmziMshQw0CpI
         3NyGi2C9MQz1ezOOWy+fs1vE8QLv1ya6FiMWvaT/3GjmlT5uidzEEoo3NCHjl9w+RLOQ
         gH7g==
X-Gm-Message-State: AOAM530aqmpDW35ivGpY9+F6fcGGpxwbQXArv5G1QRGKKOin5AL7yhlL
        SuKe6gIRYI3mRIbyauUjzAT+FCrnoapb6A==
X-Google-Smtp-Source: ABdhPJyC1gyutH94/bwcHB+JrIog2ipkuq0w9tY6RTdXwjwRNJ+/xabsF4Wg9eMmsOjraq4BBfuwKQ==
X-Received: by 2002:a17:902:e843:b029:e7:3c04:8d70 with SMTP id t3-20020a170902e843b02900e73c048d70mr27537557plg.48.1617691119375;
        Mon, 05 Apr 2021 23:38:39 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gd13sm1317733pjb.56.2021.04.05.23.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 23:38:38 -0700 (PDT)
Date:   Tue, 6 Apr 2021 14:38:19 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
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
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210406063819.GF2900@Leo-laptop-t470s>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
 <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 05:24:48PM -0700, John Fastabend wrote:
> Hangbin Liu wrote:
> > This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to extend
> > xdp_redirect_map for broadcast support.
> > 
> > Keep the general data path in net/core/filter.c and the native data
> > path in kernel/bpf/devmap.c so we can use direct calls to get better
> > performace.
> > 
> > Here is the performance result by using xdp_redirect_{map, map_multi} in
> > sample/bpf and send pkts via pktgen cmd:
> > ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> > 
> > There are some drop back as we need to loop the map and get each interface.
> > 
> > Version          | Test                                | Generic | Native
> > 5.12 rc2         | redirect_map        i40e->i40e      |    2.0M |  9.8M
> > 5.12 rc2         | redirect_map        i40e->veth      |    1.8M | 12.0M
> 
> Are these are 10gbps i40e ports? Sorry if I asked this earlier, maybe
> add a note in the commit if another respin is needed.

Yes, I will add it if there is an update.

> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > index 3980fb3bfb09..c8452c5f40f8 100644
> > --- a/kernel/bpf/devmap.c
> > +++ b/kernel/bpf/devmap.c
> > @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
> >  	list_del_rcu(&dtab->list);
> >  	spin_unlock(&dev_map_lock);
> >  
> > +	bpf_clear_redirect_map(map);
> 
> Is this a bugfix? If its needed here wouldn't we also need it in the
> devmap case.

No, in ee75aef23afe ("bpf, xdp: Restructure redirect actions") this function
was removed. I added it back as we use ri->map again.

What devmap case you mean?

> 
> >  	synchronize_rcu();
> >  
> >  	/* Make sure prior __dev_map_entry_free() have completed. */
> 
> [...]
> 
> > +
> > +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buff *xdp,
> > +						   struct bpf_map *map,
> > +						   u32 *key, u32 *next_key,
> > +						   int ex_ifindex)
> > +{
> > +	struct bpf_dtab_netdev *obj;
> > +	struct net_device *dev;
> > +	u32 index;
> > +	int err;
> > +
> > +	err = devmap_get_next_key(map, key, next_key);
> > +	if (err)
> > +		return NULL;
> > +
> > +	/* When using dev map hash, we could restart the hashtab traversal
> > +	 * in case the key has been updated/removed in the mean time.
> > +	 * So we may end up potentially looping due to traversal restarts
> > +	 * from first elem.
> > +	 *
> > +	 * Let's use map's max_entries to limit the loop number.
> > +	 */
> > +	for (index = 0; index < map->max_entries; index++) {
> > +		obj = devmap_lookup_elem(map, *next_key);
> > +		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
> > +			goto find_next;
> > +
> > +		dev = obj->dev;
> > +
> > +		if (!dev->netdev_ops->ndo_xdp_xmit)
> > +			goto find_next;
> > +
> > +		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> > +		if (unlikely(err))
> > +			goto find_next;
> > +
> > +		return obj;
> > +
> > +find_next:
> > +		key = next_key;
> > +		err = devmap_get_next_key(map, key, next_key);
> > +		if (err)
> > +			break;
> > +	}
> 
> I'm missing something. Either an elaborated commit message or comment
> is probably needed. I've been looking at this block for 30 minutes and
> can't see how we avoid sending duplicate frames on a single interface?
> Can you check this code flow, 
> 
>   dev_map_enqueue_multi()
>    for (;;) {
>      next_obj = devmap_get_next_obj(...)
>         for (index = 0; index < map->max_entries; index++) {
>            obj = devmap_lookup_elem();
>            if (!obj) goto find_next
>            key = next_key;
>            err = devmap_get_next_key() 
>                   if (!key) goto find_first
>                   for (i = 0; i < dtab->n_buckets; i++)
>                      return *next <- now *next_key is point back
>                                      at first entry
>            // loop back through and find first obj and return that

	 devmap_get_next_key() will loop to find the first one if there is no
	 key or dev. In normal time it will stop after the latest one.
>         }
>       bq_enqueue(...) // enqueue original obj
>       obj = next_obj;
>       key = next_key; 
>       ...  // we are going to enqueue first obj, but how do we know
>            // this hasn't already been sent? Presumably if we have
>            // a delete in the hash table in the middle of a multicast
>            // operation this might happen?
>    }

And yes, there is an corner case that if we removed a dev during multicast,
there is an possibility that restart from the first key. But given that
this is an unlikely case, and in normal internet there is also a possibility
of duplicate/lost packet. This should also be acceptable?

For the loop limit, Daniel suggested to add it:
https://lore.kernel.org/bpf/609c2fdf-09b7-b86e-26c0-ad386770ac33@iogearbox.net/

> > +
> > +	return NULL;
> > +}
> > +
> > +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> > +			  struct bpf_map *map, bool exclude_ingress)
> > +{
> > +	struct bpf_dtab_netdev *obj = NULL, *next_obj = NULL;
> > +	struct xdp_frame *xdpf, *nxdpf;
> > +	u32 key, next_key;
> > +	int ex_ifindex;
> > +
> > +	ex_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
> > +
> > +	/* Find first available obj */
> > +	obj = devmap_get_next_obj(xdp, map, NULL, &key, ex_ifindex);
> > +	if (!obj)
> > +		return -ENOENT;
> > +
> > +	xdpf = xdp_convert_buff_to_frame(xdp);
> > +	if (unlikely(!xdpf))
> > +		return -EOVERFLOW;
> > +
> > +	for (;;) {
> 
> A nit take it or not. These for (;;) loops always seem a bit odd to me
> when we really don't want it to run forever. I prefer
> 
>         while (!next_obj)
> 
> but a matter of style I guess.

OK, I will do it if there is an respin.

Thank
Hangbin
