Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3A368278
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbhDVObL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236341AbhDVObK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 10:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619101835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W3Z6/RkfariQy2oTB92f/6Rg6/9VM4ZDI1Tb6cEqirk=;
        b=WgfZaOmvuQmGiOy7aP7z3dvgWbKRpEfiRIqbarpgm+TBseuXXiELmiBBRqgSX+54Ps91sL
        lryTnqOuaFxxBSVLhSFDaoVIXhdEllLTyl2VE25Zvzn9mhoigwzVe3sHPYAdsZxXe6+54h
        NQejIJBm7N/3nACo+HFeZGmYnqOlvEQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-MGBp_UiJPKu19NakXpbO2Q-1; Thu, 22 Apr 2021 10:30:24 -0400
X-MC-Unique: MGBp_UiJPKu19NakXpbO2Q-1
Received: by mail-ej1-f69.google.com with SMTP id ne22-20020a1709077b96b02903803a047edeso5954224ejc.3
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 07:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=W3Z6/RkfariQy2oTB92f/6Rg6/9VM4ZDI1Tb6cEqirk=;
        b=YdU75tBYXXYW5PlqXiMJeFnEp1Qw9caed1MGC9ENxIDfepE1UgzO1BIIlMvhCkAoKm
         f1nDfwtoAsuxxGa0OBY0coaOJCIRdfco2E9As23ubMCFMN6GcSHdIgzTh5rEHvQltEh2
         ywbz8pvwegN0Jz8uU3QG2OrZnAw4Sq3dLKo7Ly5dNfTODwVfCjuxIRPJzu2una809Mpe
         y+jzs7A65dGNc+rdLvhxbx5HHUgH9v3XpIMCIdzU546m5mA6uGopH5HOOsn49ai7VqIa
         BD5u2pwYkugajGlI2Ra5Yo3hXiQ62wybA7YxTCriNWfPSzxWH3zIXNHTeirwecryqLZe
         V8iQ==
X-Gm-Message-State: AOAM530KwUGU/eGVGBU79Hk4odtMBdzqXtyN4nuowTq50eD2ys1jU1nH
        6JFS3tx02Iq0vESxiidpkKTP4bc2IGVGqZsdj2nobjXpkcVHGmT62b76FrG7Q1iJtAVrvQmp1u+
        YeuxD+CKhQDYGRD8v
X-Received: by 2002:a17:906:2a46:: with SMTP id k6mr3645794eje.406.1619101821913;
        Thu, 22 Apr 2021 07:30:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnBoYfMorGKpAh5HFLZqtdxy4JMftG6PC5qLQ+CBBx3So38b+w2Oiv4scCSQDbjSivJamtLA==
X-Received: by 2002:a17:906:2a46:: with SMTP id k6mr3645729eje.406.1619101821321;
        Thu, 22 Apr 2021 07:30:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g20sm2351829edb.7.2021.04.22.07.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 07:30:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 885BC180675; Thu, 22 Apr 2021 16:30:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     paulmck@kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
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
        <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <20210421223110.GZ975577@paulmck-ThinkPad-P17-Gen-1>
References: <20210419214117.GE975577@paulmck-ThinkPad-P17-Gen-1>
 <87y2ddgbsn.fsf@toke.dk>
 <20210419223143.GG975577@paulmck-ThinkPad-P17-Gen-1>
 <87wnsvhg0m.fsf@toke.dk>
 <20210421145951.GT975577@paulmck-ThinkPad-P17-Gen-1>
 <87r1j3h0hw.fsf@toke.dk>
 <20210421205146.GX975577@paulmck-ThinkPad-P17-Gen-1>
 <87im4fgx81.fsf@toke.dk>
 <20210421213019.GY975577@paulmck-ThinkPad-P17-Gen-1>
 <87bla7gux3.fsf@toke.dk>
 <20210421223110.GZ975577@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Apr 2021 16:30:19 +0200
Message-ID: <87k0oufl38.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Thu, Apr 22, 2021 at 12:00:24AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> "Paul E. McKenney" <paulmck@kernel.org> writes:
>>=20
>> > On Wed, Apr 21, 2021 at 11:10:38PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >>=20
>> >> > On Wed, Apr 21, 2021 at 09:59:55PM +0200, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
>> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >>=20
>> >> >> > On Wed, Apr 21, 2021 at 04:24:41PM +0200, Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
>> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >>=20
>> >> >> >> > On Tue, Apr 20, 2021 at 12:16:40AM +0200, Toke H=C3=B8iland-J=
=C3=B8rgensen wrote:
>> >> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >> >>=20
>> >> >> >> >> > On Mon, Apr 19, 2021 at 11:21:41PM +0200, Toke H=C3=B8ilan=
d-J=C3=B8rgensen wrote:
>> >> >> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >> >> >>=20
>> >> >> >> >> >> > On Mon, Apr 19, 2021 at 08:12:27PM +0200, Toke H=C3=B8i=
land-J=C3=B8rgensen wrote:
>> >> >> >> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> > On Sat, Apr 17, 2021 at 02:27:19PM +0200, Toke H=C3=
=B8iland-J=C3=B8rgensen wrote:
>> >> >> >> >> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >> > On Fri, Apr 16, 2021 at 11:22:52AM -0700, Martin =
KaFai Lau wrote:
>> >> >> >> >> >> >> >> >> On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper=
 Dangaard Brouer wrote:
>> >> >> >> >> >> >> >> >> > On Thu, 15 Apr 2021 17:39:13 -0700
>> >> >> >> >> >> >> >> >> > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > > On Thu, Apr 15, 2021 at 10:29:40PM +0200, To=
ke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> >> >> >> >> >> >> >> > > > Jesper Dangaard Brouer <brouer@redhat.com>=
 writes:
>> >> >> >> >> >> >> >> >> > > >=20=20=20
>> >> >> >> >> >> >> >> >> > > > > On Thu, 15 Apr 2021 10:35:51 -0700
>> >> >> >> >> >> >> >> >> > > > > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >> >> >> >> >> >> >> > > > >=20=20
>> >> >> >> >> >> >> >> >> > > > >> On Thu, Apr 15, 2021 at 11:22:19AM +020=
0, Toke H=C3=B8iland-J=C3=B8rgensen wrote:=20=20
>> >> >> >> >> >> >> >> >> > > > >> > Hangbin Liu <liuhangbin@gmail.com> wr=
ites:
>> >> >> >> >> >> >> >> >> > > > >> >=20=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM =
-0700, Martin KaFai Lau wrote:=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> >  static void bq_xmit_all(struct =
xdp_dev_bulk_queue *bq, u32 flags)
>> >> >> >> >> >> >> >> >> > > > >> > >> >  {
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	struct net_device *dev =3D bq-=
>dev;
>> >> >> >> >> >> >> >> >> > > > >> > >> > -	int sent =3D 0, err =3D 0;
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	int sent =3D 0, drops =3D 0, e=
rr =3D 0;
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	unsigned int cnt =3D bq->count;
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	int to_send =3D cnt;
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	int i;
>> >> >> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> > -	if (unlikely(!bq->count))
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	if (unlikely(!cnt))
>> >> >> >> >> >> >> >> >> > > > >> > >> >  		return;
>> >> >> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> > -	for (i =3D 0; i < bq->count; i=
++) {
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> >> >> >> >> >> >> >> >> > > > >> > >> >  		struct xdp_frame *xdpf =3D bq=
->q[i];
>> >> >> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> >  		prefetch(xdpf);
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	}
>> >> >> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> > -	sent =3D dev->netdev_ops->ndo_=
xdp_xmit(dev, bq->count, bq->q, flags);
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	if (bq->xdp_prog) {=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> bq->xdp_prog is used here
>> >> >> >> >> >> >> >> >> > > > >> > >>=20=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> > +		to_send =3D dev_map_bpf_prog_=
run(bq->xdp_prog, bq->q, cnt, dev);
>> >> >> >> >> >> >> >> >> > > > >> > >> > +		if (!to_send)
>> >> >> >> >> >> >> >> >> > > > >> > >> > +			goto out;
>> >> >> >> >> >> >> >> >> > > > >> > >> > +
>> >> >> >> >> >> >> >> >> > > > >> > >> > +		drops =3D cnt - to_send;
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	}
>> >> >> >> >> >> >> >> >> > > > >> > >> > +=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >>=20
>> >> >> >> >> >> >> >> >> > > > >> > >> [ ... ]
>> >> >> >> >> >> >> >> >> > > > >> > >>=20=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> >  static void bq_enqueue(struct n=
et_device *dev, struct xdp_frame *xdpf,
>> >> >> >> >> >> >> >> >> > > > >> > >> > -		       struct net_device *dev=
_rx)
>> >> >> >> >> >> >> >> >> > > > >> > >> > +		       struct net_device *dev=
_rx, struct bpf_prog *xdp_prog)
>> >> >> >> >> >> >> >> >> > > > >> > >> >  {
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	struct list_head *flush_list =
=3D this_cpu_ptr(&dev_flush_list);
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	struct xdp_dev_bulk_queue *bq =
=3D this_cpu_ptr(dev->xdp_bulkq);
>> >> >> >> >> >> >> >> >> > > > >> > >> > @@ -412,18 +466,22 @@ static voi=
d bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	/* Ingress dev_rx will be the =
same for all xdp_frame's in
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	 * bulk_queue, because bq stor=
ed per-CPU and must be flushed
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	 * from net_device drivers NAP=
I func end.
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	 *
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	 * Do the same with xdp_prog a=
nd flush_list since these fields
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	 * are only ever modified toge=
ther.
>> >> >> >> >> >> >> >> >> > > > >> > >> >  	 */
>> >> >> >> >> >> >> >> >> > > > >> > >> > -	if (!bq->dev_rx)
>> >> >> >> >> >> >> >> >> > > > >> > >> > +	if (!bq->dev_rx) {
>> >> >> >> >> >> >> >> >> > > > >> > >> >  		bq->dev_rx =3D dev_rx;
>> >> >> >> >> >> >> >> >> > > > >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=
=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >> bp->xdp_prog is assigned here and =
could be used later in bq_xmit_all().
>> >> >> >> >> >> >> >> >> > > > >> > >> How is bq->xdp_prog protected? Are=
 they all under one rcu_read_lock()?
>> >> >> >> >> >> >> >> >> > > > >> > >> It is not very obvious after takin=
g a quick look at xdp_do_flush[_map].
>> >> >> >> >> >> >> >> >> > > > >> > >>=20
>> >> >> >> >> >> >> >> >> > > > >> > >> e.g. what if the devmap elem gets =
deleted.=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >> > >
>> >> >> >> >> >> >> >> >> > > > >> > > Jesper knows better than me. From m=
y veiw, based on the description of
>> >> >> >> >> >> >> >> >> > > > >> > > __dev_flush():
>> >> >> >> >> >> >> >> >> > > > >> > >
>> >> >> >> >> >> >> >> >> > > > >> > > On devmap tear down we ensure the f=
lush list is empty before completing to
>> >> >> >> >> >> >> >> >> > > > >> > > ensure all flush operations have co=
mpleted. When drivers update the bpf
>> >> >> >> >> >> >> >> >> > > > >> > > program they may need to ensure any=
 flush ops are also complete.=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >>
>> >> >> >> >> >> >> >> >> > > > >> AFAICT, the bq->xdp_prog is not from th=
e dev. It is from a devmap's elem.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > The bq->xdp_prog comes form the devmap "dev" e=
lement, and it is stored
>> >> >> >> >> >> >> >> >> > in temporarily in the "bq" structure that is o=
nly valid for this
>> >> >> >> >> >> >> >> >> > softirq NAPI-cycle.  I'm slightly worried that=
 we copied this pointer
>> >> >> >> >> >> >> >> >> > the the xdp_prog here, more below (and Q for P=
aul).
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > > > >> >=20
>> >> >> >> >> >> >> >> >> > > > >> > Yeah, drivers call xdp_do_flush() bef=
ore exiting their NAPI poll loop,
>> >> >> >> >> >> >> >> >> > > > >> > which also runs under one big rcu_rea=
d_lock(). So the storage in the
>> >> >> >> >> >> >> >> >> > > > >> > bulk queue is quite temporary, it's j=
ust used for bulking to increase
>> >> >> >> >> >> >> >> >> > > > >> > performance :)=20=20=20=20
>> >> >> >> >> >> >> >> >> > > > >>
>> >> >> >> >> >> >> >> >> > > > >> I am missing the one big rcu_read_lock(=
) part.  For example, in i40e_txrx.c,
>> >> >> >> >> >> >> >> >> > > > >> i40e_run_xdp() has its own rcu_read_loc=
k/unlock().  dst->xdp_prog used to run
>> >> >> >> >> >> >> >> >> > > > >> in i40e_run_xdp() and it is fine.
>> >> >> >> >> >> >> >> >> > > > >>=20
>> >> >> >> >> >> >> >> >> > > > >> In this patch, dst->xdp_prog is run out=
side of i40e_run_xdp() where the
>> >> >> >> >> >> >> >> >> > > > >> rcu_read_unlock() has already done.  It=
 is now run in xdp_do_flush_map().
>> >> >> >> >> >> >> >> >> > > > >> or I missed the big rcu_read_lock() in =
i40e_napi_poll()?
>> >> >> >> >> >> >> >> >> > > > >>
>> >> >> >> >> >> >> >> >> > > > >> I do see the big rcu_read_lock() in mlx=
5e_napi_poll().=20=20
>> >> >> >> >> >> >> >> >> > > > >
>> >> >> >> >> >> >> >> >> > > > > I believed/assumed xdp_do_flush_map() wa=
s already protected under an
>> >> >> >> >> >> >> >> >> > > > > rcu_read_lock.  As the devmap and cpumap=
, which get called via
>> >> >> >> >> >> >> >> >> > > > > __dev_flush() and __cpu_map_flush(), hav=
e multiple RCU objects that we
>> >> >> >> >> >> >> >> >> > > > > are operating on.=20=20
>> >> >> >> >> >> >> >> >> > >
>> >> >> >> >> >> >> >> >> > > What other rcu objects it is using during fl=
ush?
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > Look at code:
>> >> >> >> >> >> >> >> >> >  kernel/bpf/cpumap.c
>> >> >> >> >> >> >> >> >> >  kernel/bpf/devmap.c
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > The devmap is filled with RCU code and complic=
ated take-down steps.=20=20
>> >> >> >> >> >> >> >> >> > The devmap's elements are also RCU objects and=
 the BPF xdp_prog is
>> >> >> >> >> >> >> >> >> > embedded in this object (struct bpf_dtab_netde=
v).  The call_rcu
>> >> >> >> >> >> >> >> >> > function is __dev_map_entry_free().
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > > > > Perhaps it is a bug in i40e?=20=20
>> >> >> >> >> >> >> >> >> > >
>> >> >> >> >> >> >> >> >> > > A quick look into ixgbe falls into the same =
bucket.
>> >> >> >> >> >> >> >> >> > > didn't look at other drivers though.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > Intel driver are very much in copy-paste mode.
>> >> >> >> >> >> >> >> >> >=20=20
>> >> >> >> >> >> >> >> >> > > > >
>> >> >> >> >> >> >> >> >> > > > > We are running in softirq in NAPI contex=
t, when xdp_do_flush_map() is
>> >> >> >> >> >> >> >> >> > > > > call, which I think means that this CPU =
will not go-through a RCU grace
>> >> >> >> >> >> >> >> >> > > > > period before we exit softirq, so in-pra=
ctice it should be safe.=20=20
>> >> >> >> >> >> >> >> >> > > >=20
>> >> >> >> >> >> >> >> >> > > > Yup, this seems to be correct: rcu_softirq=
_qs() is only called between
>> >> >> >> >> >> >> >> >> > > > full invocations of the softirq handler, w=
hich for networking is
>> >> >> >> >> >> >> >> >> > > > net_rx_action(), and so translates into fu=
ll NAPI poll cycles.=20=20
>> >> >> >> >> >> >> >> >> > >
>> >> >> >> >> >> >> >> >> > > I don't know enough to comment on the rcu/so=
ftirq part, may be someone
>> >> >> >> >> >> >> >> >> > > can chime in.  There is also a recent napi_t=
hreaded_poll().
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > CC added Paul. (link to patch[1][2] for contex=
t)
>> >> >> >> >> >> >> >> >> Updated Paul's email address.
>> >> >> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > > If it is the case, then some of the existing=
 rcu_read_lock() is unnecessary?
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > Well, in many cases, especially depending on h=
ow kernel is compiled,
>> >> >> >> >> >> >> >> >> > that is true.  But we want to keep these, as t=
hey also document the
>> >> >> >> >> >> >> >> >> > intend of the programmer.  And allow us to mak=
e the kernel even more
>> >> >> >> >> >> >> >> >> > preempt-able in the future.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > > At least, it sounds incorrect to only make a=
n exception here while keeping
>> >> >> >> >> >> >> >> >> > > other rcu_read_lock() as-is.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > Let me be clear:  I think you have spotted a p=
roblem, and we need to
>> >> >> >> >> >> >> >> >> > add rcu_read_lock() at least around the invoca=
tion of
>> >> >> >> >> >> >> >> >> > bpf_prog_run_xdp() or before around if-stateme=
nt that call
>> >> >> >> >> >> >> >> >> > dev_map_bpf_prog_run(). (Hangbin please do thi=
s in V8).
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > Thank you Martin for reviewing the code carefu=
lly enough to find this
>> >> >> >> >> >> >> >> >> > issue, that some drivers don't have a RCU-sect=
ion around the full XDP
>> >> >> >> >> >> >> >> >> > code path in their NAPI-loop.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > Question to Paul.  (I will attempt to describe=
 in generic terms what
>> >> >> >> >> >> >> >> >> > happens, but ref real-function names).
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > We are running in softirq/NAPI context, the dr=
iver will call a
>> >> >> >> >> >> >> >> >> > bq_enqueue() function for every packet (if cal=
ling xdp_do_redirect) ,
>> >> >> >> >> >> >> >> >> > some driver wrap this with a rcu_read_lock/unl=
ock() section (other have
>> >> >> >> >> >> >> >> >> > a large RCU-read section, that include the flu=
sh operation).
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > In the bq_enqueue() function we have a per_cpu=
_ptr (that store the
>> >> >> >> >> >> >> >> >> > xdp_frame packets) that will get flushed/send =
in the call
>> >> >> >> >> >> >> >> >> > xdp_do_flush() (that end-up calling bq_xmit_al=
l()).  This flush will
>> >> >> >> >> >> >> >> >> > happen before we end our softirq/NAPI context.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > The extension is that the per_cpu_ptr data str=
ucture (after this patch)
>> >> >> >> >> >> >> >> >> > store a pointer to an xdp_prog (which is a RCU=
 object).  In the flush
>> >> >> >> >> >> >> >> >> > operation (which we will wrap with RCU-read se=
ction), we will use this
>> >> >> >> >> >> >> >> >> > xdp_prog pointer.   I can see that it is in-pr=
inciple wrong to pass
>> >> >> >> >> >> >> >> >> > this-pointer between RCU-read sections, but I =
consider this safe as we
>> >> >> >> >> >> >> >> >> > are running under softirq/NAPI and the per_cpu=
_ptr is only valid in
>> >> >> >> >> >> >> >> >> > this short interval.
>> >> >> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >> >> > I claim a grace/quiescent RCU cannot happen be=
tween these two RCU-read
>> >> >> >> >> >> >> >> >> > sections, but I might be wrong? (especially in=
 the future or for RT).
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > If I am reading this correctly (ha!), a very high=
-level summary of the
>> >> >> >> >> >> >> >> > code in question is something like this:
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 	void foo(void)
>> >> >> >> >> >> >> >> > 	{
>> >> >> >> >> >> >> >> > 		local_bh_disable();
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 		rcu_read_lock();
>> >> >> >> >> >> >> >> > 		p =3D rcu_dereference(gp);
>> >> >> >> >> >> >> >> > 		do_something_with(p);
>> >> >> >> >> >> >> >> > 		rcu_read_unlock();
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 		do_something_else();
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 		rcu_read_lock();
>> >> >> >> >> >> >> >> > 		do_some_other_thing(p);
>> >> >> >> >> >> >> >> > 		rcu_read_unlock();
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 		local_bh_enable();
>> >> >> >> >> >> >> >> > 	}
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 	void bar(struct blat *new_gp)
>> >> >> >> >> >> >> >> > 	{
>> >> >> >> >> >> >> >> > 		struct blat *old_gp;
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > 		spin_lock(my_lock);
>> >> >> >> >> >> >> >> > 		old_gp =3D rcu_dereference_protected(gp, lock_h=
eld(my_lock));
>> >> >> >> >> >> >> >> > 		rcu_assign_pointer(gp, new_gp);
>> >> >> >> >> >> >> >> > 		spin_unlock(my_lock);
>> >> >> >> >> >> >> >> > 		synchronize_rcu();
>> >> >> >> >> >> >> >> > 		kfree(old_gp);
>> >> >> >> >> >> >> >> > 	}
>> >> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >> Yeah, something like that (the object is freed usin=
g call_rcu() - but I
>> >> >> >> >> >> >> >> think that's equivalent, right?). And the question =
is whether we need to
>> >> >> >> >> >> >> >> extend foo() so that is has one big rcu_read_lock()=
 that covers the
>> >> >> >> >> >> >> >> whole lifetime of p.
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > Yes, use of call_rcu() is an asynchronous version of=
 synchronize_rcu().
>> >> >> >> >> >> >> > In fact, synchronize_rcu() is implemented in terms o=
f call_rcu().  ;-)
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> Right, gotcha!
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >> > I need to check up on -rt.
>> >> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > But first... In recent mainline kernels, the loca=
l_bh_disable() region
>> >> >> >> >> >> >> >> > will look like one big RCU read-side critical sec=
tion.  But don't try
>> >> >> >> >> >> >> >> > this prior to v4.20!!!  In v4.19 and earlier, you=
 would need to use
>> >> >> >> >> >> >> >> > both synchronize_rcu() and synchronize_rcu_bh() t=
o make this work, or,
>> >> >> >> >> >> >> >> > for less latency, synchronize_rcu_mult(call_rcu, =
call_rcu_bh).
>> >> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >> OK. Variants of this code has been around since bef=
ore then, but I
>> >> >> >> >> >> >> >> honestly have no idea what it looked like back then=
 exactly...
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > I know that feeling...
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> >> > Except that in that case, why not just drop the i=
nner rcu_read_unlock()
>> >> >> >> >> >> >> >> > and rcu_read_lock() pair?  Awkward function bound=
aries or some such?
>> >> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >> Well if we can just treat such a local_bh_disable()=
/enable() pair as the
>> >> >> >> >> >> >> >> equivalent of rcu_read_lock()/unlock() then I suppo=
se we could just get
>> >> >> >> >> >> >> >> rid of the inner ones. What about tools like lockde=
p; do they understand
>> >> >> >> >> >> >> >> this, or are we likely to get complaints if we remo=
ve it?
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > If you just got rid of the first rcu_read_unlock() a=
nd the second
>> >> >> >> >> >> >> > rcu_read_lock() in the code above, lockdep will unde=
rstand.
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> Right, but doing so entails going through all the driv=
ers, which is what
>> >> >> >> >> >> >> we're trying to avoid :)
>> >> >> >> >> >> >
>> >> >> >> >> >> > I was afraid of that...  ;-)
>> >> >> >> >> >> >
>> >> >> >> >> >> >> > However, if you instead get rid of -all- of the rcu_=
read_lock() and
>> >> >> >> >> >> >> > rcu_read_unlock() invocations in the code above, you=
 would need to let
>> >> >> >> >> >> >> > lockdep know by adding rcu_read_lock_bh_held().  So =
instead of this:
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > 	p =3D rcu_dereference(gp);
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > You would do this:
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > 	p =3D rcu_dereference_check(gp, rcu_read_lock_bh_he=
ld());
>> >> >> >> >> >> >> >
>> >> >> >> >> >> >> > This would be needed for mainline, regardless of -rt.
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> OK. And as far as I can tell this is harmless for code=
 paths that call
>> >> >> >> >> >> >> the same function but from a regular rcu_read_lock()-p=
rotected section
>> >> >> >> >> >> >> instead from a bh-disabled section, right?
>> >> >> >> >> >> >
>> >> >> >> >> >> > That is correct.  That rcu_dereference_check() invocati=
on will make
>> >> >> >> >> >> > lockdep be OK with rcu_read_lock() or with softirq bein=
g disabled.
>> >> >> >> >> >> > Or both, for that matter.
>> >> >> >> >> >>=20
>> >> >> >> >> >> OK, great, thank you for confirming my understanding!
>> >> >> >> >> >>=20
>> >> >> >> >> >> >> What happens, BTW, if we *don't* get rid of all the ex=
isting
>> >> >> >> >> >> >> rcu_read_lock() sections? Going back to your foo() exa=
mple above, what
>> >> >> >> >> >> >> we're discussing is whether to add that second rcu_rea=
d_lock() around
>> >> >> >> >> >> >> do_some_other_thing(p). I.e., the first one around the=
 rcu_dereference()
>> >> >> >> >> >> >> is already there (in the particular driver we're discu=
ssing), and the
>> >> >> >> >> >> >> local_bh_disable/enable() pair is already there. AFAIC=
T from our
>> >> >> >> >> >> >> discussion, there really is not much point in adding t=
hat second
>> >> >> >> >> >> >> rcu_read_lock/unlock(), is there?
>> >> >> >> >> >> >
>> >> >> >> >> >> > From an algorithmic point of view, the second rcu_read_=
lock()
>> >> >> >> >> >> > and rcu_read_unlock() are redundant.  Of course, there =
are also
>> >> >> >> >> >> > software-engineering considerations, including copy-pas=
ta issues.
>> >> >> >> >> >> >
>> >> >> >> >> >> >> And because that first rcu_read_lock() around the rcu_=
dereference() is
>> >> >> >> >> >> >> already there, lockdep is not likely to complain eithe=
r, so we're
>> >> >> >> >> >> >> basically fine? Except that the code is somewhat confu=
sing as-is, of
>> >> >> >> >> >> >> course; i.e., we should probably fix it but it's not t=
erribly urgent. Or?
>> >> >> >> >> >> >
>> >> >> >> >> >> > I am concerned about copy-pasta-induced bugs.  Someone =
looks just at
>> >> >> >> >> >> > the code, fails to note the fact that softirq is disabl=
ed throughout,
>> >> >> >> >> >> > and decides that leaking a pointer from one RCU read-si=
de critical
>> >> >> >> >> >> > section to a later one is just fine.  :-/
>> >> >> >> >> >>=20
>> >> >> >> >> >> Yup, totally agreed that we need to fix this for the sake=
 of the humans
>> >> >> >> >> >> reading the code; just wanted to make sure my understandi=
ng was correct
>> >> >> >> >> >> that we don't strictly need to do anything as far as the =
machines
>> >> >> >> >> >> executing it are concerned :)
>> >> >> >> >> >>=20
>> >> >> >> >> >> >> Hmm, looking at it now, it seems not all the lookup co=
de is actually
>> >> >> >> >> >> >> doing rcu_dereference() at all, but rather just a plai=
n READ_ONCE() with
>> >> >> >> >> >> >> a comment above it saying that RCU ensures objects won=
't disappear[0];
>> >> >> >> >> >> >> so I suppose we're at least safe from lockdep in that =
sense :P - but we
>> >> >> >> >> >> >> should definitely clean this up.
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> [0] Exhibit A: https://elixir.bootlin.com/linux/latest=
/source/kernel/bpf/devmap.c#L391
>> >> >> >> >> >> >
>> >> >> >> >> >> > That use of READ_ONCE() will definitely avoid lockdep c=
omplaints,
>> >> >> >> >> >> > including those complaints that point out bugs.  It als=
o might get you
>> >> >> >> >> >> > sparse complaints if the RCU-protected pointer is marke=
d with __rcu.
>> >> >> >> >> >>=20
>> >> >> >> >> >> It's not; it's the netdev_map member of this struct:
>> >> >> >> >> >>=20
>> >> >> >> >> >> struct bpf_dtab {
>> >> >> >> >> >> 	struct bpf_map map;
>> >> >> >> >> >> 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only=
 */
>> >> >> >> >> >> 	struct list_head list;
>> >> >> >> >> >>=20
>> >> >> >> >> >> 	/* these are only used for DEVMAP_HASH type maps */
>> >> >> >> >> >> 	struct hlist_head *dev_index_head;
>> >> >> >> >> >> 	spinlock_t index_lock;
>> >> >> >> >> >> 	unsigned int items;
>> >> >> >> >> >> 	u32 n_buckets;
>> >> >> >> >> >> };
>> >> >> >> >> >>=20
>> >> >> >> >> >> Will adding __rcu to such a dynamic array member do the r=
ight thing when
>> >> >> >> >> >> paired with rcu_dereference() on array members (i.e., in =
place of the
>> >> >> >> >> >> READ_ONCE in the code linked above)?
>> >> >> >> >> >
>> >> >> >> >> > The only thing __rcu will do is provide information to the=
 sparse static
>> >> >> >> >> > analysis tool.  Which will then gripe at you for applying =
READ_ONCE()
>> >> >> >> >> > to a __rcu pointer.  But it is already griping at you for =
applying
>> >> >> >> >> > rcu_dereference() to something not marked __rcu, so...  ;-)
>> >> >> >> >>=20
>> >> >> >> >> Right, hence the need for a cleanup ;)
>> >> >> >> >>=20
>> >> >> >> >> My question was more if it understood arrays, though. I.e., =
that
>> >> >> >> >> 'netdev_map' is an array of RCU pointers, not an RCU pointer=
 to an
>> >> >> >> >> array... Or am I maybe thinking that tool is way smarter tha=
n it is, and
>> >> >> >> >> it just complains for any access to that field that doesn't =
use
>> >> >> >> >> rcu_dereference()?
>> >> >> >> >
>> >> >> >> > I believe that sparse will know about the pointers being __rc=
u, but
>> >> >> >> > not the array.  Unless you mark both levels.
>> >> >> >>=20
>> >> >> >> Hi Paul
>> >> >> >>=20
>> >> >> >> One more question, since I started adding the annotations: We a=
re
>> >> >> >> currently swapping out the pointers using xchg():
>> >> >> >> https://elixir.bootlin.com/linux/latest/source/kernel/bpf/devma=
p.c#L555
>> >> >> >>=20
>> >> >> >> and even cmpxchg():
>> >> >> >> https://elixir.bootlin.com/linux/latest/source/kernel/bpf/devma=
p.c#L831
>> >> >> >>=20
>> >> >> >> Sparse complains about these if I add the __rcu annotation to t=
he
>> >> >> >> definition (which otherwise works just fine with the double-poi=
nter,
>> >> >> >> BTW). Is there a way to fix that? Some kind of rcu_ macro versi=
on of the
>> >> >> >> atomic swaps or something? Or do we just keep the regular xchg(=
) and
>> >> >> >> ignore those particular sparse warnings?
>> >> >> >
>> >> >> > Sounds like I need to supply a unrcu_pointer() macro or some suc=
h.
>> >> >> > This would operate something like the current open-coded casts
>> >> >> > in __rcu_dereference_protected().
>> >> >>=20
>> >> >> So with that, I would turn the existing:
>> >> >>=20
>> >> >> 	dev =3D READ_ONCE(dtab->netdev_map[i]);
>> >> >> 	if (!dev || netdev !=3D dev->dev)
>> >> >> 		continue;
>> >> >> 	odev =3D cmpxchg(&dtab->netdev_map[i], dev, NULL);
>> >> >>=20
>> >> >> into:
>> >> >>=20
>> >> >> 	dev =3D rcu_dereference(dtab->netdev_map[i]);
>> >> >> 	if (!dev || netdev !=3D dev->dev)
>> >> >> 		continue;
>> >> >> 	odev =3D cmpxchg(unrcu_pointer(&dtab->netdev_map[i]), dev, NULL);
>> >> >>=20
>> >> >>=20
>> >> >> and with a _check version:
>> >> >>=20
>> >> >> 	old_dev =3D xchg(unrcu_pointer_check(&dtab->netdev_map[k], rcu_re=
ad_lock_bh_held()), NULL);
>> >> >>=20
>> >> >> right?
>> >> >>=20
>> >> >> Or would it be:
>> >> >> 	odev =3D cmpxchg(&unrcu_pointer(dtab->netdev_map[i]), dev, NULL);
>> >> >> ?
>> >> >>=20
>> >> >> > Would something like that work for you?
>> >> >>=20
>> >> >> Yeah, I believe it would :)
>> >> >
>> >> > Except that I was forgetting that the __rcu decorates the pointed-to
>> >> > data rather than the pointer itself.  :-/
>> >> >
>> >> > But that is actually easier, as you can follow the example of
>> >> > rcu_assign_pointer(), namely using RCU_INITIALIZER().
>> >> >
>> >> > So like this:
>> >> >
>> >> > 	odev =3D cmpxchg(&dtab->netdev_map[i], RCU_INITIALIZER(dev), NULL);
>> >> >
>> >> > I -think- that the NULL doesn't need an RCU_INITIALIZER(), but it is
>> >> > of course sparse's opinion that matters.
>> >> >
>> >> > And of course like this:
>> >> >
>> >> > 	old_dev =3D xchg(&dtab->netdev_map[k], RCU_INITIALIZER(newmap));
>> >> >
>> >> > Does that work, or am I still confused?
>> >>=20
>> >> That gets rid of one warning, but not the other. Before (plain xchg):
>> >>=20
>> >> kernel/bpf/devmap.c:657:19: warning: incorrect type in initializer (d=
ifferent address spaces)
>> >> kernel/bpf/devmap.c:657:19:    expected struct bpf_dtab_netdev [noder=
ef] __rcu *__ret
>> >> kernel/bpf/devmap.c:657:19:    got struct bpf_dtab_netdev *[assigned]=
 dev
>> >> kernel/bpf/devmap.c:657:17: warning: incorrect type in assignment (di=
fferent address spaces)
>> >> kernel/bpf/devmap.c:657:17:    expected struct bpf_dtab_netdev *old_d=
ev
>> >> kernel/bpf/devmap.c:657:17:    got struct bpf_dtab_netdev [noderef] _=
_rcu *[assigned] __ret
>> >>=20
>> >> after (RCU_INITIALIZER() on the second argument to xchg):
>> >>=20
>> >> kernel/bpf/devmap.c:657:17: warning: incorrect type in assignment (di=
fferent address spaces)
>> >> kernel/bpf/devmap.c:657:17:    expected struct bpf_dtab_netdev *old_d=
ev
>> >> kernel/bpf/devmap.c:657:17:    got struct bpf_dtab_netdev [noderef] _=
_rcu *[assigned] __ret
>> >>=20
>> >> I can get rid of that second one by marking old_dev as __rcu, but the=
n I
>> >> get a new warning when dereferencing that in the subsequent
>> >> call_rcu()...
>> >>=20
>> >> So I guess we still need that unrcu_pointer(), to wrap the xchg() in?
>> >
>> > Well, at least this use case permits an lvalue.  ;-)
>> >
>> > Please see below for an untested patch intended to permit the followin=
g:
>> >
>> > 	old_dev =3D unrcu_pointer(xchg(&dtab->netdev_map[k], RCU_INITIALIZER(=
newmap)));
>> >
>> > Does that do the trick?
>>=20
>> Yes, it does! With that I can mark the pointer as __rcu and get all uses
>> of it through sparse without complaints - awesome!
>>=20
>> How do RCU patches usually make it into the kernel? Can you provide me
>> with a proper patch I can just include along with my cleanup patches
>> (taking it through the bpf tree)? Or do we need to go through some other
>> tree and wait for a merge?
>
> Normally through the -rcu tree, but please feel free to pull this one
> (shown formally below) along with your changes.  I have queued it in
> the -rcu tree as well, but my normal process would submit it during the
> v5.14 merge window, that is, not the upcoming one but the one after that.
>
> So for example if your work makes it into the upcoming merge window,
> I will drop my copy of my patch when I rebase onto v5.13-rc1.

Sounds good; not sure if I'll manage to get something in before this
merge window (which seems to be fast approaching); we'll see. Thanks! :)

-Toke

