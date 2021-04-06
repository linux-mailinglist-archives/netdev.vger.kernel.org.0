Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D32355ECD
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhDFWaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhDFWaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 18:30:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B18C06174A;
        Tue,  6 Apr 2021 15:29:55 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id j26so12072875iog.13;
        Tue, 06 Apr 2021 15:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HEwdLbu2KVt2UromBB3I/1/Xpp/EjdsnfXwriiqXBGk=;
        b=WQtZAPDAxMHuIpXeBaB4M59OudGhADaSVwFkVX1CCoBmRpxt0m3JomIlehswxGSfX8
         CaRjc0DYIoGFBrw8T/UA4lbQ5wVSL6W/RrhTug6eaBvQou7pOXwQddKNGNnLYVWpyx7e
         rv//9V1NmsorBVDXQxpFeAvsCsuPS8RNRsIyj4ot4lnbhscfITDnTGODkEAV3vLLRXGS
         MkmepFuE2mLVXLwaVkWwVbwzUmg/zzVbnEChwB53DQGFLBWm555dpIviMg9kaxJrt6W8
         ze6gI+sy6rdImBH78yqVm9V3y79MMfXnEyggegwdBLGm/x9ndcA8QuJbd5BZgByfXpKA
         VWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HEwdLbu2KVt2UromBB3I/1/Xpp/EjdsnfXwriiqXBGk=;
        b=V7vHaVPVGz2sIeCxukLLC+UBryuF70IahIWRjdbwe0OJ+JlZ3Sw5WVXCJoHh9tsP2S
         6rZ2uxVivJkKDUZR51gRWl6v0L/nSg9cNt2SqmZB654763Ic6IOePCc5OxmUJYO3MBLg
         iYmsUFlvRJxR/e2g6aLA5Jzi09vtb8Zj+pP9JUOmQGdBs825Rz+X0JStwBX7+3kr3EJ1
         P8Qcy39Ppt0D+OGS3z2df1+bOM41GhQWRCY1vLd2eZrkg7XHm0f3bEIa9PDeRGDsIr7x
         Rj2Qo4q0kd30/yzLbRRqzu/IRRzVOePTPvktWvK42OSUEvw73UzTVVa+Rku7VEtxc0kx
         TwaA==
X-Gm-Message-State: AOAM530snBMRaUD92MahioE7p2rH6vwyRshcgJLCXqHzc4gJOltvk93f
        ZUxBmSBrqecN9Gkjn1Q0XLk=
X-Google-Smtp-Source: ABdhPJxBAWszRALYmxpcMt6PJYqJgdapLEQtwiougBpqN4rtxwL9DqPytTy0oNM+SG7Pnp3Yi9zWMw==
X-Received: by 2002:a05:6638:2101:: with SMTP id n1mr405161jaj.7.1617748194538;
        Tue, 06 Apr 2021 15:29:54 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x20sm13242427ilc.88.2021.04.06.15.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 15:29:54 -0700 (PDT)
Date:   Tue, 06 Apr 2021 15:29:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
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
Message-ID: <606ce0db7cd40_2865920845@john-XPS-13-9370.notmuch>
In-Reply-To: <87k0pf2gz6.fsf@toke.dk>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
 <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
 <20210406063819.GF2900@Leo-laptop-t470s>
 <878s5v4swp.fsf@toke.dk>
 <606cd787d64da_22ba520855@john-XPS-13-9370.notmuch>
 <87k0pf2gz6.fsf@toke.dk>
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
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Hangbin Liu <liuhangbin@gmail.com> writes:
> >> =

> >> > On Mon, Apr 05, 2021 at 05:24:48PM -0700, John Fastabend wrote:
> >> >> Hangbin Liu wrote:
> >> >> > This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGR=
ESS to extend
> >> >> > xdp_redirect_map for broadcast support.
> >> >> > =

> >> >> > Keep the general data path in net/core/filter.c and the native =
data
> >> >> > path in kernel/bpf/devmap.c so we can use direct calls to get b=
etter
> >> >> > performace.
> >> >> > =

> >> >> > Here is the performance result by using xdp_redirect_{map, map_=
multi} in
> >> >> > sample/bpf and send pkts via pktgen cmd:
> >> >> > ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $d=
st_mac -t 10 -s 64
> >> >> > =

> >> >> > There are some drop back as we need to loop the map and get eac=
h interface.
> >> >> > =

> >> >> > Version          | Test                                | Generi=
c | Native
> >> >> > 5.12 rc2         | redirect_map        i40e->i40e      |    2.0=
M |  9.8M
> >> >> > 5.12 rc2         | redirect_map        i40e->veth      |    1.8=
M | 12.0M
> >> >> =

> >> >> Are these are 10gbps i40e ports? Sorry if I asked this earlier, m=
aybe
> >> >> add a note in the commit if another respin is needed.
> >> >
> >> > Yes, I will add it if there is an update.
> >> >
> >> >> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> >> > index 3980fb3bfb09..c8452c5f40f8 100644
> >> >> > --- a/kernel/bpf/devmap.c
> >> >> > +++ b/kernel/bpf/devmap.c
> >> >> > @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *ma=
p)
> >> >> >  	list_del_rcu(&dtab->list);
> >> >> >  	spin_unlock(&dev_map_lock);
> >> >> >  =

> >> >> > +	bpf_clear_redirect_map(map);
> >> >> =

> >> >> Is this a bugfix? If its needed here wouldn't we also need it in =
the
> >> >> devmap case.
> >> >
> >> > No, in ee75aef23afe ("bpf, xdp: Restructure redirect actions") thi=
s function
> >> > was removed. I added it back as we use ri->map again.
> >> >
> >> > What devmap case you mean?
> >> >
> >> >> =

> >> >> >  	synchronize_rcu();
> >> >> >  =

> >> >> >  	/* Make sure prior __dev_map_entry_free() have completed. */
> >> >> =

> >> >> [...]
> >> >> =

> >> >> > +
> >> >> > +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_=
buff *xdp,
> >> >> > +						   struct bpf_map *map,
> >> >> > +						   u32 *key, u32 *next_key,
> >> >> > +						   int ex_ifindex)
> >> >> > +{
> >> >> > +	struct bpf_dtab_netdev *obj;
> >> >> > +	struct net_device *dev;
> >> >> > +	u32 index;
> >> >> > +	int err;
> >> >> > +
> >> >> > +	err =3D devmap_get_next_key(map, key, next_key);
> >> >> > +	if (err)
> >> >> > +		return NULL;
> >> >> > +
> >> >> > +	/* When using dev map hash, we could restart the hashtab trav=
ersal
> >> >> > +	 * in case the key has been updated/removed in the mean time.=

> >> >> > +	 * So we may end up potentially looping due to traversal rest=
arts
> >> >> > +	 * from first elem.
> >> >> > +	 *
> >> >> > +	 * Let's use map's max_entries to limit the loop number.
> >> >> > +	 */
> >> >> > +	for (index =3D 0; index < map->max_entries; index++) {
> >> >> > +		obj =3D devmap_lookup_elem(map, *next_key);
> >> >> > +		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
> >> >> > +			goto find_next;
> >> >> > +
> >> >> > +		dev =3D obj->dev;
> >> >> > +
> >> >> > +		if (!dev->netdev_ops->ndo_xdp_xmit)
> >> >> > +			goto find_next;
> >> >> > +
> >> >> > +		err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> >> >> > +		if (unlikely(err))
> >> >> > +			goto find_next;
> >> >> > +
> >> >> > +		return obj;
> >> >> > +
> >> >> > +find_next:
> >> >> > +		key =3D next_key;
> >> >> > +		err =3D devmap_get_next_key(map, key, next_key);
> >> >> > +		if (err)
> >> >> > +			break;
> >> >> > +	}
> >> >> =

> >> >> I'm missing something. Either an elaborated commit message or com=
ment
> >> >> is probably needed. I've been looking at this block for 30 minute=
s and
> >> >> can't see how we avoid sending duplicate frames on a single inter=
face?
> >> >> Can you check this code flow, =

> >> >> =

> >> >>   dev_map_enqueue_multi()
> >> >>    for (;;) {
> >> >>      next_obj =3D devmap_get_next_obj(...)
> >> >>         for (index =3D 0; index < map->max_entries; index++) {
> >> >>            obj =3D devmap_lookup_elem();
> >> >>            if (!obj) goto find_next
> >> >>            key =3D next_key;
> >> >>            err =3D devmap_get_next_key() =

> >> >>                   if (!key) goto find_first
> >> >>                   for (i =3D 0; i < dtab->n_buckets; i++)
> >> >>                      return *next <- now *next_key is point back
> >> >>                                      at first entry
> >> >>            // loop back through and find first obj and return tha=
t
> >> >
> >> > 	 devmap_get_next_key() will loop to find the first one if there i=
s no
> >> > 	 key or dev. In normal time it will stop after the latest one.
> >> >>         }
> >> >>       bq_enqueue(...) // enqueue original obj
> >> >>       obj =3D next_obj;
> >> >>       key =3D next_key; =

> >> >>       ...  // we are going to enqueue first obj, but how do we kn=
ow
> >> >>            // this hasn't already been sent? Presumably if we hav=
e
> >> >>            // a delete in the hash table in the middle of a multi=
cast
> >> >>            // operation this might happen?
> >> >>    }
> >> >
> >> > And yes, there is an corner case that if we removed a dev during m=
ulticast,
> >> > there is an possibility that restart from the first key. But given=
 that
> >> > this is an unlikely case, and in normal internet there is also a p=
ossibility
> >> > of duplicate/lost packet. This should also be acceptable?
> >> =

> >> In my mind this falls under "acceptable corner cases". I.e., if you'=
re
> >> going to use the map for redirect and you expect to be updating it w=
hile
> >> you're doing so, don't use a hashmap. But if you will not be updatin=
g
> >> the map (or find the possible duplication acceptable), you can use t=
he
> >> hashmap and gain the benefit of being able to index by ifindex.
> >
> > In a Kubernetes setup its going to be hard, if possible at all, to re=
strict
> > the map from moving as interfaces/IPs are going to be dynamic. Using =
a
> > hash map has nice benefits of not having to figure out how to put ifi=
ndex's
> > into the array. Although on some early implementations I wrote a smal=
l
> > hashing algorithm over the top of array, so that could work.
> >
> > I don't know how well multicast applications might handle duplicate p=
ackets.
> > I wouldn't be too surprised if it was problematic. On the other hand =
missing
> > an entry that was just added is likely OK. There is no way to know fr=
om
> > network/user side if the entry was actually added before multicast op=
 and
> > skipped or insert happened just after multicast op. And vice versa fo=
r a
> > delete dev, no way to know the multicast op happened before/after the=

> > delete.
> >
> > Have we consider doing something like the batch lookup ops over hasht=
ab?
> > I don't mind "missing" values so if we just walk the list?
> >
> >      head =3D dev_map_index_hash(dtab, i)
> >      // collect all my devs and get ready to send multicast
> >      hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist) {
> > 		enqueue(dev, skb)
> >      }
> >      // submit the queue of entries and do all the work to actually x=
mit
> >      submit_enqueued();
> >
> > We don't have to care about keys just walk the hash list?
> =

> So you'd wrap that in a loop like:
> =

> for (i =3D 0; i < dtab->n_buckets; i++) {
> 	head =3D dev_map_index_hash(dtab, i);
> 	hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist) {
> 		bq_enqueue(dev, xdpf, dev_rx, obj->xdp_prog);
> 	}
> }
> =

> or? Yeah, I guess that would work!

Nice. Thanks for sticking with this Hangbin its taking us a bit, but
I think above works on my side at least.

> =

> It would mean that dev_map_enqueue_multi() would need more in-depth
> knowledge into the map type, so would likely need to be two different
> functions for the two different map types, living in devmap.c - but
> that's probably acceptable.

Yeah, I think thats fine.

> =

> And while we're doing that, the array-map version can also loop over al=
l
> indexes up to max_entries, instead of stopping at the first index that
> doesn't have an entry like it does now (right now, it looks like if you=

> populate entries 0 and 2 in an array-map only one copy of the packet
> will be sent, to index 0).

Right, this is likely needed anyways. At least when I was doing prototype=
s
of using array maps I often ended up with holes in the map. Just imagine
adding a set of devs and then removing one, its not likely to be the
last one you insert.

> =

> It makes it a bit more awkward to do Hangbin's clever trick to avoid
> doing an extra copy by aborting the loop early. But I guess the same
> technique could apply...
> =

> -Toke
> =



