Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D50362267
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 16:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbhDPOgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 10:36:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235292AbhDPOgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 10:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618583741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvafGi97crQQ64ed+6kmSAKhO5/PoIYJnKG8ux7EbcU=;
        b=HA9qK/6mxwm8ieWjWudxwdv5yvMNNEJ0qCnaV+JfoVoGAJBm5zsbRG/b4ok8D27rnTqOWk
        4jcpwVAw8AKJgH7joSbXpXYQuJaOvBKJKDnh00SssyO0qRUhAkXVu5Bn5XQYemGotAHmgu
        Ma7coxvJfmPvhasUQWt6pgnl8Smy1qk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-SUAq054JOM2VxnTrochZdw-1; Fri, 16 Apr 2021 10:35:39 -0400
X-MC-Unique: SUAq054JOM2VxnTrochZdw-1
Received: by mail-ej1-f71.google.com with SMTP id r17-20020a1709069591b029037cf6a4a56dso2095829ejx.12
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 07:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DvafGi97crQQ64ed+6kmSAKhO5/PoIYJnKG8ux7EbcU=;
        b=R13+SomxYhcObQJoSosfOFA8Ts6EieYheqGEWzKub4ipejziQybAVp+2PBH6vHIRYz
         xZD3gItJBev/85bDvfCEROYzfQEmNGQ/t99w3fiWd37FBpLWN6yJ1JIXz9kbp68Nrgi3
         cjaDBS1idUD13isnVXnKg58K0FkfaRYX0OIRmGKEXxykt/VCCNDUgAcIInUaI3ExCUdd
         U1mxO8jP0Nzyhvbu/h/lFRn4aU97aADj6tyTHOIUhuJL0fNAy2NUSVz0MSh4YPOIy0Vi
         SqfE92MCu5HAocF92fXSoCz1xxVP9UuxxHaCKsBP20OvIvR824uZYHO4g+ggRNeqpmKw
         5tYA==
X-Gm-Message-State: AOAM53001fWodS5x7ozU1OWcfVUd/LjyQRWih9Ivb/GfR0R9QJxa8tj8
        v8Gvmg1u+yhr8bUxQwzt7PDtR3BbfjqsgMEaBcXT++224OX/SsppHTfjEz21+wrqeNW8JHzVWsj
        H7Wi+GG+NcLmPCo+V
X-Received: by 2002:a17:906:6d48:: with SMTP id a8mr8822510ejt.92.1618583737641;
        Fri, 16 Apr 2021 07:35:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDYsf3htL6pZlKDSy29fFkraYFElLoTokkjABKgIkO1YQvf6zF3ZrsdZAu05Ce84hfhA9X2Q==
X-Received: by 2002:a17:906:6d48:: with SMTP id a8mr8822456ejt.92.1618583737044;
        Fri, 16 Apr 2021 07:35:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e16sm5595496edu.94.2021.04.16.07.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 07:35:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 82D461806B2; Fri, 16 Apr 2021 16:35:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, brouer@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <20210416154523.3b1fe700@carbon>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s> <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon> <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <20210416154523.3b1fe700@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 16 Apr 2021 16:35:35 +0200
Message-ID: <87eefaguvc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 15 Apr 2021 17:39:13 -0700
> Martin KaFai Lau <kafai@fb.com> wrote:
>
>> On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> >=20=20=20
>> > > On Thu, 15 Apr 2021 10:35:51 -0700
>> > > Martin KaFai Lau <kafai@fb.com> wrote:
>> > >=20=20
>> > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:=20=20
>> > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> > >> >=20=20=20=20=20
>> > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrot=
e:=20=20=20=20
>> > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 =
flags)
>> > >> > >> >  {
>> > >> > >> >  	struct net_device *dev =3D bq->dev;
>> > >> > >> > -	int sent =3D 0, err =3D 0;
>> > >> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
>> > >> > >> > +	unsigned int cnt =3D bq->count;
>> > >> > >> > +	int to_send =3D cnt;
>> > >> > >> >  	int i;
>> > >> > >> >=20=20
>> > >> > >> > -	if (unlikely(!bq->count))
>> > >> > >> > +	if (unlikely(!cnt))
>> > >> > >> >  		return;
>> > >> > >> >=20=20
>> > >> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> > >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> > >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> > >> > >> >=20=20
>> > >> > >> >  		prefetch(xdpf);
>> > >> > >> >  	}
>> > >> > >> >=20=20
>> > >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq-=
>q, flags);
>> > >> > >> > +	if (bq->xdp_prog) {=20=20=20=20
>> > >> > >> bq->xdp_prog is used here
>> > >> > >>=20=20=20=20=20
>> > >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt=
, dev);
>> > >> > >> > +		if (!to_send)
>> > >> > >> > +			goto out;
>> > >> > >> > +
>> > >> > >> > +		drops =3D cnt - to_send;
>> > >> > >> > +	}
>> > >> > >> > +=20=20=20=20
>> > >> > >>=20
>> > >> > >> [ ... ]
>> > >> > >>=20=20=20=20=20
>> > >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_f=
rame *xdpf,
>> > >> > >> > -		       struct net_device *dev_rx)
>> > >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_pr=
og)
>> > >> > >> >  {
>> > >> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_l=
ist);
>> > >> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bu=
lkq);
>> > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_devi=
ce *dev, struct xdp_frame *xdpf,
>> > >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
>> > >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flush=
ed
>> > >> > >> >  	 * from net_device drivers NAPI func end.
>> > >> > >> > +	 *
>> > >> > >> > +	 * Do the same with xdp_prog and flush_list since these fi=
elds
>> > >> > >> > +	 * are only ever modified together.
>> > >> > >> >  	 */
>> > >> > >> > -	if (!bq->dev_rx)
>> > >> > >> > +	if (!bq->dev_rx) {
>> > >> > >> >  		bq->dev_rx =3D dev_rx;
>> > >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20=20=20
>> > >> > >> bp->xdp_prog is assigned here and could be used later in bq_xm=
it_all().
>> > >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read=
_lock()?
>> > >> > >> It is not very obvious after taking a quick look at xdp_do_flu=
sh[_map].
>> > >> > >>=20
>> > >> > >> e.g. what if the devmap elem gets deleted.=20=20=20=20
>> > >> > >
>> > >> > > Jesper knows better than me. From my veiw, based on the descrip=
tion of
>> > >> > > __dev_flush():
>> > >> > >
>> > >> > > On devmap tear down we ensure the flush list is empty before co=
mpleting to
>> > >> > > ensure all flush operations have completed. When drivers update=
 the bpf
>> > >> > > program they may need to ensure any flush ops are also complete=
.=20=20=20=20
>> > >>
>> > >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's=
 elem.
>
> The bq->xdp_prog comes form the devmap "dev" element, and it is stored
> in temporarily in the "bq" structure that is only valid for this
> softirq NAPI-cycle.  I'm slightly worried that we copied this pointer
> the the xdp_prog here, more below (and Q for Paul).
>
>> > >> >=20
>> > >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll =
loop,
>> > >> > which also runs under one big rcu_read_lock(). So the storage in =
the
>> > >> > bulk queue is quite temporary, it's just used for bulking to incr=
ease
>> > >> > performance :)=20=20=20=20
>> > >>
>> > >> I am missing the one big rcu_read_lock() part.  For example, in i40=
e_txrx.c,
>> > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog u=
sed to run
>> > >> in i40e_run_xdp() and it is fine.
>> > >>=20
>> > >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where=
 the
>> > >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_=
map().
>> > >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
>> > >>
>> > >> I do see the big rcu_read_lock() in mlx5e_napi_poll().=20=20
>> > >
>> > > I believed/assumed xdp_do_flush_map() was already protected under an
>> > > rcu_read_lock.  As the devmap and cpumap, which get called via
>> > > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that =
we
>> > > are operating on.=20=20
>>
>> What other rcu objects it is using during flush?
>
> Look at code:
>  kernel/bpf/cpumap.c
>  kernel/bpf/devmap.c
>
> The devmap is filled with RCU code and complicated take-down steps.=20=20
> The devmap's elements are also RCU objects and the BPF xdp_prog is
> embedded in this object (struct bpf_dtab_netdev).  The call_rcu
> function is __dev_map_entry_free().
>
>
>> > > Perhaps it is a bug in i40e?=20=20
>>
>> A quick look into ixgbe falls into the same bucket.
>> didn't look at other drivers though.
>
> Intel driver are very much in copy-paste mode.
>=20=20
>> > >
>> > > We are running in softirq in NAPI context, when xdp_do_flush_map() is
>> > > call, which I think means that this CPU will not go-through a RCU gr=
ace
>> > > period before we exit softirq, so in-practice it should be safe.=20=
=20
>> >=20
>> > Yup, this seems to be correct: rcu_softirq_qs() is only called between
>> > full invocations of the softirq handler, which for networking is
>> > net_rx_action(), and so translates into full NAPI poll cycles.=20=20
>>
>> I don't know enough to comment on the rcu/softirq part, may be someone
>> can chime in.  There is also a recent napi_threaded_poll().
>
> CC added Paul. (link to patch[1][2] for context)
>
>> If it is the case, then some of the existing rcu_read_lock() is unnecess=
ary?
>
> Well, in many cases, especially depending on how kernel is compiled,
> that is true.  But we want to keep these, as they also document the
> intend of the programmer.  And allow us to make the kernel even more
> preempt-able in the future.
>
>> At least, it sounds incorrect to only make an exception here while keepi=
ng
>> other rcu_read_lock() as-is.
>
> Let me be clear:  I think you have spotted a problem, and we need to
> add rcu_read_lock() at least around the invocation of
> bpf_prog_run_xdp() or before around if-statement that call
> dev_map_bpf_prog_run(). (Hangbin please do this in V8).

I'm not sure adding that is going to help, though? It'll make the
potential race window smaller (assuming there is one and we're not
protected by running inside the NAPI poll), but the pointer could still
be invalidated between the two rcu_read_lock() sections. So adding such
an (inner) rcu_read_lock() feels like just papering over the issue?

I think that to fix this properly we either (a) need to conclude that
it's not actually an issue because of the NAPI thing, (b) fix the
drivers to include everything in one big rcu_read_lock() or (c)
restructure the code so it doesn't assume the RCU protection at all.

(c) seems like a lot of work for little gain, so I guess we're left with
(b) unless Paul tells us that (a) is good enough? :)

I guess a variant of (b) that doesn't involve going through all the
drivers could be to just add an rcu_read_lock()/unlock() in the
top-level napi_poll() function? Any reason that couldn't work?

-Toke

