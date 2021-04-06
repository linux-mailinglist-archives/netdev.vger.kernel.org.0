Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76590355E3B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243108AbhDFVuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbhDFVuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:50:18 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1640BC06174A;
        Tue,  6 Apr 2021 14:50:10 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id p8so10106129ilm.13;
        Tue, 06 Apr 2021 14:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DUZzMxDA3HfNEvcmb6SwNiEZLawyvpP+gcxEKBC/RlU=;
        b=dN5a799JfwoyXHB6DnHwgY5YzfsCyQI8IKbzQOdCHgQRzg0o8b0J2LOJ5KDhvqkNyR
         HGBQ06fVmh80nD0yBNKddfGsvkswOrTv/DBTdtJ+16lfgvXbMMFPb1UcVuWIgUUav3fL
         mYLQec3U/QlOpXgnaeCr2g7l6C6aibihQizOiXl6qCK5QewY5k8BPiC1iL4CZtleqlfX
         QsKZMpRBs4BTYWO8SKxR7pw036DhrHZZpywDEvZDmGbDLH4mFtXDAzb6hEOLa1S5J+Uc
         uttIvC+W9/rX6dhgcOVatrYDtdAxvNwDcmcl5s0Ezg/y5ITBtgoJ94eMSg65fCcCMbJs
         IAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DUZzMxDA3HfNEvcmb6SwNiEZLawyvpP+gcxEKBC/RlU=;
        b=eEYbWfKlhWOET6VJlOkc3+hA+MsBoWCltiuOF9U9hc7BL0lVAvx2fschRWDuQWIczp
         qdvVTU4ZW+Sk8qJAZthywlfgkalQR7iVz13ARwAOGbyPA7XxChBDIXSulj+r1JzL8mPN
         aeirl+NRTWKdjFmAeWVUJ8tpPWYScpsdAevnUjiLYmvnhThdlIkJIMrmlwvtirlFRR8V
         oXhgLiWLZazsydKkpXUJ50enz6/aygVOd+1/7PIZHiaE8aig7a0Y8GjFvbYBNFEQLH32
         IFQDQpuI7CcV4LF76zT0MPzHrAaEknbHA+Br6WYRBJH5F9x/A95Vx5m6boq7HtN2NbRM
         WH/w==
X-Gm-Message-State: AOAM5332iE62jYcGxv4SRIwsVgn381acnsTt36ShvUo0tWyBt07xNL6s
        d/2V4IOFOOEvxVOJ6S1Dk8A=
X-Google-Smtp-Source: ABdhPJyeb14J8a/HRtdjMAQ2U/yHwqSaKA+efHTKD1Z68jno0JBkWOyO2Fd/5r72iNCODSJ45+/Rvw==
X-Received: by 2002:a92:8752:: with SMTP id d18mr253914ilm.283.1617745809378;
        Tue, 06 Apr 2021 14:50:09 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id a4sm13764582iow.55.2021.04.06.14.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:50:08 -0700 (PDT)
Date:   Tue, 06 Apr 2021 14:49:59 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Message-ID: <606cd787d64da_22ba520855@john-XPS-13-9370.notmuch>
In-Reply-To: <878s5v4swp.fsf@toke.dk>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
 <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
 <20210406063819.GF2900@Leo-laptop-t470s>
 <878s5v4swp.fsf@toke.dk>
Subject: Re: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> =

> > On Mon, Apr 05, 2021 at 05:24:48PM -0700, John Fastabend wrote:
> >> Hangbin Liu wrote:
> >> > This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS=
 to extend
> >> > xdp_redirect_map for broadcast support.
> >> > =

> >> > Keep the general data path in net/core/filter.c and the native dat=
a
> >> > path in kernel/bpf/devmap.c so we can use direct calls to get bett=
er
> >> > performace.
> >> > =

> >> > Here is the performance result by using xdp_redirect_{map, map_mul=
ti} in
> >> > sample/bpf and send pkts via pktgen cmd:
> >> > ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_=
mac -t 10 -s 64
> >> > =

> >> > There are some drop back as we need to loop the map and get each i=
nterface.
> >> > =

> >> > Version          | Test                                | Generic |=
 Native
> >> > 5.12 rc2         | redirect_map        i40e->i40e      |    2.0M |=
  9.8M
> >> > 5.12 rc2         | redirect_map        i40e->veth      |    1.8M |=
 12.0M
> >> =

> >> Are these are 10gbps i40e ports? Sorry if I asked this earlier, mayb=
e
> >> add a note in the commit if another respin is needed.
> >
> > Yes, I will add it if there is an update.
> >
> >> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> > index 3980fb3bfb09..c8452c5f40f8 100644
> >> > --- a/kernel/bpf/devmap.c
> >> > +++ b/kernel/bpf/devmap.c
> >> > @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
> >> >  	list_del_rcu(&dtab->list);
> >> >  	spin_unlock(&dev_map_lock);
> >> >  =

> >> > +	bpf_clear_redirect_map(map);
> >> =

> >> Is this a bugfix? If its needed here wouldn't we also need it in the=

> >> devmap case.
> >
> > No, in ee75aef23afe ("bpf, xdp: Restructure redirect actions") this f=
unction
> > was removed. I added it back as we use ri->map again.
> >
> > What devmap case you mean?
> >
> >> =

> >> >  	synchronize_rcu();
> >> >  =

> >> >  	/* Make sure prior __dev_map_entry_free() have completed. */
> >> =

> >> [...]
> >> =

> >> > +
> >> > +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buf=
f *xdp,
> >> > +						   struct bpf_map *map,
> >> > +						   u32 *key, u32 *next_key,
> >> > +						   int ex_ifindex)
> >> > +{
> >> > +	struct bpf_dtab_netdev *obj;
> >> > +	struct net_device *dev;
> >> > +	u32 index;
> >> > +	int err;
> >> > +
> >> > +	err =3D devmap_get_next_key(map, key, next_key);
> >> > +	if (err)
> >> > +		return NULL;
> >> > +
> >> > +	/* When using dev map hash, we could restart the hashtab travers=
al
> >> > +	 * in case the key has been updated/removed in the mean time.
> >> > +	 * So we may end up potentially looping due to traversal restart=
s
> >> > +	 * from first elem.
> >> > +	 *
> >> > +	 * Let's use map's max_entries to limit the loop number.
> >> > +	 */
> >> > +	for (index =3D 0; index < map->max_entries; index++) {
> >> > +		obj =3D devmap_lookup_elem(map, *next_key);
> >> > +		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
> >> > +			goto find_next;
> >> > +
> >> > +		dev =3D obj->dev;
> >> > +
> >> > +		if (!dev->netdev_ops->ndo_xdp_xmit)
> >> > +			goto find_next;
> >> > +
> >> > +		err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> >> > +		if (unlikely(err))
> >> > +			goto find_next;
> >> > +
> >> > +		return obj;
> >> > +
> >> > +find_next:
> >> > +		key =3D next_key;
> >> > +		err =3D devmap_get_next_key(map, key, next_key);
> >> > +		if (err)
> >> > +			break;
> >> > +	}
> >> =

> >> I'm missing something. Either an elaborated commit message or commen=
t
> >> is probably needed. I've been looking at this block for 30 minutes a=
nd
> >> can't see how we avoid sending duplicate frames on a single interfac=
e?
> >> Can you check this code flow, =

> >> =

> >>   dev_map_enqueue_multi()
> >>    for (;;) {
> >>      next_obj =3D devmap_get_next_obj(...)
> >>         for (index =3D 0; index < map->max_entries; index++) {
> >>            obj =3D devmap_lookup_elem();
> >>            if (!obj) goto find_next
> >>            key =3D next_key;
> >>            err =3D devmap_get_next_key() =

> >>                   if (!key) goto find_first
> >>                   for (i =3D 0; i < dtab->n_buckets; i++)
> >>                      return *next <- now *next_key is point back
> >>                                      at first entry
> >>            // loop back through and find first obj and return that
> >
> > 	 devmap_get_next_key() will loop to find the first one if there is n=
o
> > 	 key or dev. In normal time it will stop after the latest one.
> >>         }
> >>       bq_enqueue(...) // enqueue original obj
> >>       obj =3D next_obj;
> >>       key =3D next_key; =

> >>       ...  // we are going to enqueue first obj, but how do we know
> >>            // this hasn't already been sent? Presumably if we have
> >>            // a delete in the hash table in the middle of a multicas=
t
> >>            // operation this might happen?
> >>    }
> >
> > And yes, there is an corner case that if we removed a dev during mult=
icast,
> > there is an possibility that restart from the first key. But given th=
at
> > this is an unlikely case, and in normal internet there is also a poss=
ibility
> > of duplicate/lost packet. This should also be acceptable?
> =

> In my mind this falls under "acceptable corner cases". I.e., if you're
> going to use the map for redirect and you expect to be updating it whil=
e
> you're doing so, don't use a hashmap. But if you will not be updating
> the map (or find the possible duplication acceptable), you can use the
> hashmap and gain the benefit of being able to index by ifindex.

In a Kubernetes setup its going to be hard, if possible at all, to restri=
ct
the map from moving as interfaces/IPs are going to be dynamic. Using a
hash map has nice benefits of not having to figure out how to put ifindex=
's
into the array. Although on some early implementations I wrote a small
hashing algorithm over the top of array, so that could work.

I don't know how well multicast applications might handle duplicate packe=
ts.
I wouldn't be too surprised if it was problematic. On the other hand miss=
ing
an entry that was just added is likely OK. There is no way to know from
network/user side if the entry was actually added before multicast op and=

skipped or insert happened just after multicast op. And vice versa for a
delete dev, no way to know the multicast op happened before/after the
delete.

Have we consider doing something like the batch lookup ops over hashtab?
I don't mind "missing" values so if we just walk the list?

     head =3D dev_map_index_hash(dtab, i)
     // collect all my devs and get ready to send multicast
     hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist) {
		enqueue(dev, skb)
     }
     // submit the queue of entries and do all the work to actually xmit
     submit_enqueued();

We don't have to care about keys just walk the hash list?

> =

> But John does have a point that this is not obvious; so maybe it should=

> be pointed out in the helper documentation?

At minimum it needs to be documented, but really I want to fix it. I
can see the confused end users sending me bug reports already about
duplicate packets.

> =

> -Toke
> =



