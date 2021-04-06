Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BBE355F40
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbhDFXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233608AbhDFXKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617750610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9lk+Krk0fLvsER4GAD3GYNK/6lCYDO0gWm9uVu7Uf0=;
        b=CstFtfSdDE4okzUhDRekLdvc4LXktWcldx6nUtKJsFWhkgmxfrNpWFHpBGfXcuPk/hoV03
        EZ4eVPmhiWfCYb8p9bgXSvEdStFrulLkUdPjtCBTP+o6HRzpqMxHUTtXs0AqKbAvOOYyLF
        mnxcLjPl4cfLtXfwIvefiguN5ej5FLc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-HHFRSKspPwWGpRDgoNLjvA-1; Tue, 06 Apr 2021 19:10:09 -0400
X-MC-Unique: HHFRSKspPwWGpRDgoNLjvA-1
Received: by mail-ej1-f69.google.com with SMTP id gn30so6117613ejc.3
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 16:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=I9lk+Krk0fLvsER4GAD3GYNK/6lCYDO0gWm9uVu7Uf0=;
        b=sHSDHkO1IDI0PV6tDxiztx0Ektx1yitcwbpKc8Pj5eg9GBQ+qp08Qk+rgkOYLktwv/
         WoaM1N2nwSdXC6WEDzGF15O/ZSSlaeVJNSxEPZAzgXCOzO+QbAnz3Un9OAoIojA7neU2
         LJPMH5hruVtZEwP7CUel806lrRiuDR1/aJSE+DZ0w1BwidazTXEyDkfNRm2HvnHFKR9K
         uL5a1ARtHJQDzcDAv9zi7s4Ph5YgcjpI0LsvrLI/nSQuUFdSi+s3q6SP7y+7R4YNHL32
         u59r317+fDl3rJjwgD0k9czVtXMSlaKz9hFWrm88zN67d9rnnMn9klrNC1JmVXRGsfyp
         vZ3g==
X-Gm-Message-State: AOAM5306QnJ8GYUlwTPRmAwBJ0bw2v04yXiD7vt96hMNxCWiGLASHzGO
        EI7jl9kbcFQJ3yoCL/D5hhQ5fUDm7doGfkDMRjxsts5wrQOptKgxHBpi06buRi4n250ztZsAIYO
        CxWS/5Q2uqTkIcDHg
X-Received: by 2002:a05:6402:35cd:: with SMTP id z13mr876691edc.21.1617750607701;
        Tue, 06 Apr 2021 16:10:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWRIJOD9j2QRoELtGTYCPU6rb4xxfUtlIyMNRmEtTmNh5fMjR218oGLmRBwjXcT20dHBN+pg==
X-Received: by 2002:a05:6402:35cd:: with SMTP id z13mr876632edc.21.1617750607168;
        Tue, 06 Apr 2021 16:10:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r13sm14684513edy.3.2021.04.06.16.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 16:10:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BD24318030A; Wed,  7 Apr 2021 01:10:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
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
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <606ce0db7cd40_2865920845@john-XPS-13-9370.notmuch>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
 <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
 <20210406063819.GF2900@Leo-laptop-t470s> <878s5v4swp.fsf@toke.dk>
 <606cd787d64da_22ba520855@john-XPS-13-9370.notmuch>
 <87k0pf2gz6.fsf@toke.dk>
 <606ce0db7cd40_2865920845@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 07 Apr 2021 01:10:04 +0200
Message-ID: <87h7kj2enn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> John Fastabend <john.fastabend@gmail.com> writes:
>>=20
>> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Hangbin Liu <liuhangbin@gmail.com> writes:
>> >>=20
>> >> > On Mon, Apr 05, 2021 at 05:24:48PM -0700, John Fastabend wrote:
>> >> >> Hangbin Liu wrote:
>> >> >> > This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRE=
SS to extend
>> >> >> > xdp_redirect_map for broadcast support.
>> >> >> >=20
>> >> >> > Keep the general data path in net/core/filter.c and the native d=
ata
>> >> >> > path in kernel/bpf/devmap.c so we can use direct calls to get be=
tter
>> >> >> > performace.
>> >> >> >=20
>> >> >> > Here is the performance result by using xdp_redirect_{map, map_m=
ulti} in
>> >> >> > sample/bpf and send pkts via pktgen cmd:
>> >> >> > ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $ds=
t_mac -t 10 -s 64
>> >> >> >=20
>> >> >> > There are some drop back as we need to loop the map and get each=
 interface.
>> >> >> >=20
>> >> >> > Version          | Test                                | Generic=
 | Native
>> >> >> > 5.12 rc2         | redirect_map        i40e->i40e      |    2.0M=
 |  9.8M
>> >> >> > 5.12 rc2         | redirect_map        i40e->veth      |    1.8M=
 | 12.0M
>> >> >>=20
>> >> >> Are these are 10gbps i40e ports? Sorry if I asked this earlier, ma=
ybe
>> >> >> add a note in the commit if another respin is needed.
>> >> >
>> >> > Yes, I will add it if there is an update.
>> >> >
>> >> >> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> >> >> > index 3980fb3bfb09..c8452c5f40f8 100644
>> >> >> > --- a/kernel/bpf/devmap.c
>> >> >> > +++ b/kernel/bpf/devmap.c
>> >> >> > @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
>> >> >> >  	list_del_rcu(&dtab->list);
>> >> >> >  	spin_unlock(&dev_map_lock);
>> >> >> >=20=20
>> >> >> > +	bpf_clear_redirect_map(map);
>> >> >>=20
>> >> >> Is this a bugfix? If its needed here wouldn't we also need it in t=
he
>> >> >> devmap case.
>> >> >
>> >> > No, in ee75aef23afe ("bpf, xdp: Restructure redirect actions") this=
 function
>> >> > was removed. I added it back as we use ri->map again.
>> >> >
>> >> > What devmap case you mean?
>> >> >
>> >> >>=20
>> >> >> >  	synchronize_rcu();
>> >> >> >=20=20
>> >> >> >  	/* Make sure prior __dev_map_entry_free() have completed. */
>> >> >>=20
>> >> >> [...]
>> >> >>=20
>> >> >> > +
>> >> >> > +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_b=
uff *xdp,
>> >> >> > +						   struct bpf_map *map,
>> >> >> > +						   u32 *key, u32 *next_key,
>> >> >> > +						   int ex_ifindex)
>> >> >> > +{
>> >> >> > +	struct bpf_dtab_netdev *obj;
>> >> >> > +	struct net_device *dev;
>> >> >> > +	u32 index;
>> >> >> > +	int err;
>> >> >> > +
>> >> >> > +	err =3D devmap_get_next_key(map, key, next_key);
>> >> >> > +	if (err)
>> >> >> > +		return NULL;
>> >> >> > +
>> >> >> > +	/* When using dev map hash, we could restart the hashtab trave=
rsal
>> >> >> > +	 * in case the key has been updated/removed in the mean time.
>> >> >> > +	 * So we may end up potentially looping due to traversal resta=
rts
>> >> >> > +	 * from first elem.
>> >> >> > +	 *
>> >> >> > +	 * Let's use map's max_entries to limit the loop number.
>> >> >> > +	 */
>> >> >> > +	for (index =3D 0; index < map->max_entries; index++) {
>> >> >> > +		obj =3D devmap_lookup_elem(map, *next_key);
>> >> >> > +		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
>> >> >> > +			goto find_next;
>> >> >> > +
>> >> >> > +		dev =3D obj->dev;
>> >> >> > +
>> >> >> > +		if (!dev->netdev_ops->ndo_xdp_xmit)
>> >> >> > +			goto find_next;
>> >> >> > +
>> >> >> > +		err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
>> >> >> > +		if (unlikely(err))
>> >> >> > +			goto find_next;
>> >> >> > +
>> >> >> > +		return obj;
>> >> >> > +
>> >> >> > +find_next:
>> >> >> > +		key =3D next_key;
>> >> >> > +		err =3D devmap_get_next_key(map, key, next_key);
>> >> >> > +		if (err)
>> >> >> > +			break;
>> >> >> > +	}
>> >> >>=20
>> >> >> I'm missing something. Either an elaborated commit message or comm=
ent
>> >> >> is probably needed. I've been looking at this block for 30 minutes=
 and
>> >> >> can't see how we avoid sending duplicate frames on a single interf=
ace?
>> >> >> Can you check this code flow,=20
>> >> >>=20
>> >> >>   dev_map_enqueue_multi()
>> >> >>    for (;;) {
>> >> >>      next_obj =3D devmap_get_next_obj(...)
>> >> >>         for (index =3D 0; index < map->max_entries; index++) {
>> >> >>            obj =3D devmap_lookup_elem();
>> >> >>            if (!obj) goto find_next
>> >> >>            key =3D next_key;
>> >> >>            err =3D devmap_get_next_key()=20
>> >> >>                   if (!key) goto find_first
>> >> >>                   for (i =3D 0; i < dtab->n_buckets; i++)
>> >> >>                      return *next <- now *next_key is point back
>> >> >>                                      at first entry
>> >> >>            // loop back through and find first obj and return that
>> >> >
>> >> > 	 devmap_get_next_key() will loop to find the first one if there is=
 no
>> >> > 	 key or dev. In normal time it will stop after the latest one.
>> >> >>         }
>> >> >>       bq_enqueue(...) // enqueue original obj
>> >> >>       obj =3D next_obj;
>> >> >>       key =3D next_key;=20
>> >> >>       ...  // we are going to enqueue first obj, but how do we know
>> >> >>            // this hasn't already been sent? Presumably if we have
>> >> >>            // a delete in the hash table in the middle of a multic=
ast
>> >> >>            // operation this might happen?
>> >> >>    }
>> >> >
>> >> > And yes, there is an corner case that if we removed a dev during mu=
lticast,
>> >> > there is an possibility that restart from the first key. But given =
that
>> >> > this is an unlikely case, and in normal internet there is also a po=
ssibility
>> >> > of duplicate/lost packet. This should also be acceptable?
>> >>=20
>> >> In my mind this falls under "acceptable corner cases". I.e., if you're
>> >> going to use the map for redirect and you expect to be updating it wh=
ile
>> >> you're doing so, don't use a hashmap. But if you will not be updating
>> >> the map (or find the possible duplication acceptable), you can use the
>> >> hashmap and gain the benefit of being able to index by ifindex.
>> >
>> > In a Kubernetes setup its going to be hard, if possible at all, to res=
trict
>> > the map from moving as interfaces/IPs are going to be dynamic. Using a
>> > hash map has nice benefits of not having to figure out how to put ifin=
dex's
>> > into the array. Although on some early implementations I wrote a small
>> > hashing algorithm over the top of array, so that could work.
>> >
>> > I don't know how well multicast applications might handle duplicate pa=
ckets.
>> > I wouldn't be too surprised if it was problematic. On the other hand m=
issing
>> > an entry that was just added is likely OK. There is no way to know from
>> > network/user side if the entry was actually added before multicast op =
and
>> > skipped or insert happened just after multicast op. And vice versa for=
 a
>> > delete dev, no way to know the multicast op happened before/after the
>> > delete.
>> >
>> > Have we consider doing something like the batch lookup ops over hashta=
b?
>> > I don't mind "missing" values so if we just walk the list?
>> >
>> >      head =3D dev_map_index_hash(dtab, i)
>> >      // collect all my devs and get ready to send multicast
>> >      hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist) {
>> > 		enqueue(dev, skb)
>> >      }
>> >      // submit the queue of entries and do all the work to actually xm=
it
>> >      submit_enqueued();
>> >
>> > We don't have to care about keys just walk the hash list?
>>=20
>> So you'd wrap that in a loop like:
>>=20
>> for (i =3D 0; i < dtab->n_buckets; i++) {
>> 	head =3D dev_map_index_hash(dtab, i);
>> 	hlist_nulls_for_each_entry_safe(dev, next, head, index_hlist) {
>> 		bq_enqueue(dev, xdpf, dev_rx, obj->xdp_prog);
>> 	}
>> }
>>=20
>> or? Yeah, I guess that would work!
>
> Nice. Thanks for sticking with this Hangbin its taking us a bit, but
> I think above works on my side at least.
>
>>=20
>> It would mean that dev_map_enqueue_multi() would need more in-depth
>> knowledge into the map type, so would likely need to be two different
>> functions for the two different map types, living in devmap.c - but
>> that's probably acceptable.
>
> Yeah, I think thats fine.
>
>>=20
>> And while we're doing that, the array-map version can also loop over all
>> indexes up to max_entries, instead of stopping at the first index that
>> doesn't have an entry like it does now (right now, it looks like if you
>> populate entries 0 and 2 in an array-map only one copy of the packet
>> will be sent, to index 0).
>
> Right, this is likely needed anyways. At least when I was doing prototypes
> of using array maps I often ended up with holes in the map. Just imagine
> adding a set of devs and then removing one, its not likely to be the
> last one you insert.

Yeah, totally. Would have pointed it out if I'd noticed before, but I
was too trusting in the abstraction of get_next_key() etc :)

-Toke

