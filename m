Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A303674AE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbhDUVLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:11:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238047AbhDUVLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 17:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619039446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtM2Isf7SDxosMSXbq4c9FXVMDELL1KH/MxkjvnOK+A=;
        b=IHZ1NY+30SXfqw+yQvtIXa3DN4maOLzGktk2RVUalGvQvFXbWKksbxcLh4BJOgktGoVu+U
        eSwDvEZVf8Pf6e51GhZh8pN4UV2i2E1LYu35f2ggcEJ8nh4JvfAJ96IPDVrTK7+6y0NapY
        qTNBxVnylcHGxMa6hJNRigikdfydg8A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-rQ2I4fB1PNSz3u08Zr96EA-1; Wed, 21 Apr 2021 17:10:41 -0400
X-MC-Unique: rQ2I4fB1PNSz3u08Zr96EA-1
Received: by mail-ed1-f72.google.com with SMTP id m18-20020a0564025112b0290378d2a266ebso15660752edd.15
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 14:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dtM2Isf7SDxosMSXbq4c9FXVMDELL1KH/MxkjvnOK+A=;
        b=ZsMUORYoz966HG+g44xBfZsJ3zD06aiE4sSpHpgshZ8/j+sw9GM2O+eCmGETRVRasN
         YrtGtwSlfemJ+bc+tEvMsxGX6/tFCcOg+SkjvDEWHcQntA/w2UPKNLQM6vpBxuB1yHv/
         j5li6wOGnKN+4NacdnWY3/QwruK4eKNgB9jIzDpfz1yJcNqyG9lOX7GQ8cTRBwTCs5dQ
         KB0NBTI5QOgmy+E97wFNrXhFhO4RdOXMmKeO7hH5b0EnkTP7tsL83F5RIUqhiYrVV9lD
         Cg2LShGbnu8XQ+lDgrB+jkTF04Ysxk1zN5+oPIfDQTno7Yq+ZoreBUu2mS6VPCqDm4hB
         oRsA==
X-Gm-Message-State: AOAM533O7inF0wpwujhoK+rTLWojTuYmoonOwz1IRxfDnc+0ZmFLEnKm
        R4/+8cQ+SOJQuTEEZb3Dq5MVDvbtWjg1LqX7bc3T5GT8bl/lu5gvvBTNevpooCFYe2apyuAQXXx
        G4QqlXLQfXVeWcjaQ
X-Received: by 2002:a17:906:f155:: with SMTP id gw21mr34036133ejb.170.1619039439778;
        Wed, 21 Apr 2021 14:10:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3o9OkXhDNqgX9JAWwNcI9RE/Fh7c/S8L4nsBGjww9HIV893kZbC7GP6pV4+eyUyowGQHdlg==
X-Received: by 2002:a17:906:f155:: with SMTP id gw21mr34036099ejb.170.1619039439395;
        Wed, 21 Apr 2021 14:10:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gn19sm424430ejc.68.2021.04.21.14.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 14:10:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1452E1802FE; Wed, 21 Apr 2021 23:10:38 +0200 (CEST)
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
In-Reply-To: <20210421205146.GX975577@paulmck-ThinkPad-P17-Gen-1>
References: <20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1>
 <87lf9egn3o.fsf@toke.dk>
 <20210419183223.GC975577@paulmck-ThinkPad-P17-Gen-1>
 <877dkygeca.fsf@toke.dk>
 <20210419214117.GE975577@paulmck-ThinkPad-P17-Gen-1>
 <87y2ddgbsn.fsf@toke.dk>
 <20210419223143.GG975577@paulmck-ThinkPad-P17-Gen-1>
 <87wnsvhg0m.fsf@toke.dk>
 <20210421145951.GT975577@paulmck-ThinkPad-P17-Gen-1>
 <87r1j3h0hw.fsf@toke.dk>
 <20210421205146.GX975577@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Apr 2021 23:10:38 +0200
Message-ID: <87im4fgx81.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Wed, Apr 21, 2021 at 09:59:55PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> "Paul E. McKenney" <paulmck@kernel.org> writes:
>>=20
>> > On Wed, Apr 21, 2021 at 04:24:41PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >>=20
>> >> > On Tue, Apr 20, 2021 at 12:16:40AM +0200, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
>> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >>=20
>> >> >> > On Mon, Apr 19, 2021 at 11:21:41PM +0200, Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
>> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >>=20
>> >> >> >> > On Mon, Apr 19, 2021 at 08:12:27PM +0200, Toke H=C3=B8iland-J=
=C3=B8rgensen wrote:
>> >> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >> >>=20
>> >> >> >> >> > On Sat, Apr 17, 2021 at 02:27:19PM +0200, Toke H=C3=B8ilan=
d-J=C3=B8rgensen wrote:
>> >> >> >> >> >> "Paul E. McKenney" <paulmck@kernel.org> writes:
>> >> >> >> >> >>=20
>> >> >> >> >> >> > On Fri, Apr 16, 2021 at 11:22:52AM -0700, Martin KaFai =
Lau wrote:
>> >> >> >> >> >> >> On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper Danga=
ard Brouer wrote:
>> >> >> >> >> >> >> > On Thu, 15 Apr 2021 17:39:13 -0700
>> >> >> >> >> >> >> > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=
=C3=B8iland-J=C3=B8rgensen wrote:
>> >> >> >> >> >> >> > > > Jesper Dangaard Brouer <brouer@redhat.com> write=
s:
>> >> >> >> >> >> >> > > >=20=20=20
>> >> >> >> >> >> >> > > > > On Thu, 15 Apr 2021 10:35:51 -0700
>> >> >> >> >> >> >> > > > > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >> >> >> >> >> > > > >=20=20
>> >> >> >> >> >> >> > > > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Tok=
e H=C3=B8iland-J=C3=B8rgensen wrote:=20=20
>> >> >> >> >> >> >> > > > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> >> >> >> >> >> >> > > > >> >=20=20=20=20=20
>> >> >> >> >> >> >> > > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700,=
 Martin KaFai Lau wrote:=20=20=20=20
>> >> >> >> >> >> >> > > > >> > >> >  static void bq_xmit_all(struct xdp_de=
v_bulk_queue *bq, u32 flags)
>> >> >> >> >> >> >> > > > >> > >> >  {
>> >> >> >> >> >> >> > > > >> > >> >  	struct net_device *dev =3D bq->dev;
>> >> >> >> >> >> >> > > > >> > >> > -	int sent =3D 0, err =3D 0;
>> >> >> >> >> >> >> > > > >> > >> > +	int sent =3D 0, drops =3D 0, err =3D=
 0;
>> >> >> >> >> >> >> > > > >> > >> > +	unsigned int cnt =3D bq->count;
>> >> >> >> >> >> >> > > > >> > >> > +	int to_send =3D cnt;
>> >> >> >> >> >> >> > > > >> > >> >  	int i;
>> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> > > > >> > >> > -	if (unlikely(!bq->count))
>> >> >> >> >> >> >> > > > >> > >> > +	if (unlikely(!cnt))
>> >> >> >> >> >> >> > > > >> > >> >  		return;
>> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> > > > >> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> >> >> >> >> >> >> > > > >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> >> >> >> >> >> >> > > > >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> > > > >> > >> >  		prefetch(xdpf);
>> >> >> >> >> >> >> > > > >> > >> >  	}
>> >> >> >> >> >> >> > > > >> > >> >=20=20
>> >> >> >> >> >> >> > > > >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xm=
it(dev, bq->count, bq->q, flags);
>> >> >> >> >> >> >> > > > >> > >> > +	if (bq->xdp_prog) {=20=20=20=20
>> >> >> >> >> >> >> > > > >> > >> bq->xdp_prog is used here
>> >> >> >> >> >> >> > > > >> > >>=20=20=20=20=20
>> >> >> >> >> >> >> > > > >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq=
->xdp_prog, bq->q, cnt, dev);
>> >> >> >> >> >> >> > > > >> > >> > +		if (!to_send)
>> >> >> >> >> >> >> > > > >> > >> > +			goto out;
>> >> >> >> >> >> >> > > > >> > >> > +
>> >> >> >> >> >> >> > > > >> > >> > +		drops =3D cnt - to_send;
>> >> >> >> >> >> >> > > > >> > >> > +	}
>> >> >> >> >> >> >> > > > >> > >> > +=20=20=20=20
>> >> >> >> >> >> >> > > > >> > >>=20
>> >> >> >> >> >> >> > > > >> > >> [ ... ]
>> >> >> >> >> >> >> > > > >> > >>=20=20=20=20=20
>> >> >> >> >> >> >> > > > >> > >> >  static void bq_enqueue(struct net_dev=
ice *dev, struct xdp_frame *xdpf,
>> >> >> >> >> >> >> > > > >> > >> > -		       struct net_device *dev_rx)
>> >> >> >> >> >> >> > > > >> > >> > +		       struct net_device *dev_rx, s=
truct bpf_prog *xdp_prog)
>> >> >> >> >> >> >> > > > >> > >> >  {
>> >> >> >> >> >> >> > > > >> > >> >  	struct list_head *flush_list =3D thi=
s_cpu_ptr(&dev_flush_list);
>> >> >> >> >> >> >> > > > >> > >> >  	struct xdp_dev_bulk_queue *bq =3D th=
is_cpu_ptr(dev->xdp_bulkq);
>> >> >> >> >> >> >> > > > >> > >> > @@ -412,18 +466,22 @@ static void bq_e=
nqueue(struct net_device *dev, struct xdp_frame *xdpf,
>> >> >> >> >> >> >> > > > >> > >> >  	/* Ingress dev_rx will be the same f=
or all xdp_frame's in
>> >> >> >> >> >> >> > > > >> > >> >  	 * bulk_queue, because bq stored per=
-CPU and must be flushed
>> >> >> >> >> >> >> > > > >> > >> >  	 * from net_device drivers NAPI func=
 end.
>> >> >> >> >> >> >> > > > >> > >> > +	 *
>> >> >> >> >> >> >> > > > >> > >> > +	 * Do the same with xdp_prog and flu=
sh_list since these fields
>> >> >> >> >> >> >> > > > >> > >> > +	 * are only ever modified together.
>> >> >> >> >> >> >> > > > >> > >> >  	 */
>> >> >> >> >> >> >> > > > >> > >> > -	if (!bq->dev_rx)
>> >> >> >> >> >> >> > > > >> > >> > +	if (!bq->dev_rx) {
>> >> >> >> >> >> >> > > > >> > >> >  		bq->dev_rx =3D dev_rx;
>> >> >> >> >> >> >> > > > >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20=20=
=20
>> >> >> >> >> >> >> > > > >> > >> bp->xdp_prog is assigned here and could =
be used later in bq_xmit_all().
>> >> >> >> >> >> >> > > > >> > >> How is bq->xdp_prog protected? Are they =
all under one rcu_read_lock()?
>> >> >> >> >> >> >> > > > >> > >> It is not very obvious after taking a qu=
ick look at xdp_do_flush[_map].
>> >> >> >> >> >> >> > > > >> > >>=20
>> >> >> >> >> >> >> > > > >> > >> e.g. what if the devmap elem gets delete=
d.=20=20=20=20
>> >> >> >> >> >> >> > > > >> > >
>> >> >> >> >> >> >> > > > >> > > Jesper knows better than me. From my veiw=
, based on the description of
>> >> >> >> >> >> >> > > > >> > > __dev_flush():
>> >> >> >> >> >> >> > > > >> > >
>> >> >> >> >> >> >> > > > >> > > On devmap tear down we ensure the flush l=
ist is empty before completing to
>> >> >> >> >> >> >> > > > >> > > ensure all flush operations have complete=
d. When drivers update the bpf
>> >> >> >> >> >> >> > > > >> > > program they may need to ensure any flush=
 ops are also complete.=20=20=20=20
>> >> >> >> >> >> >> > > > >>
>> >> >> >> >> >> >> > > > >> AFAICT, the bq->xdp_prog is not from the dev.=
 It is from a devmap's elem.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > The bq->xdp_prog comes form the devmap "dev" element=
, and it is stored
>> >> >> >> >> >> >> > in temporarily in the "bq" structure that is only va=
lid for this
>> >> >> >> >> >> >> > softirq NAPI-cycle.  I'm slightly worried that we co=
pied this pointer
>> >> >> >> >> >> >> > the the xdp_prog here, more below (and Q for Paul).
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > > > >> >=20
>> >> >> >> >> >> >> > > > >> > Yeah, drivers call xdp_do_flush() before ex=
iting their NAPI poll loop,
>> >> >> >> >> >> >> > > > >> > which also runs under one big rcu_read_lock=
(). So the storage in the
>> >> >> >> >> >> >> > > > >> > bulk queue is quite temporary, it's just us=
ed for bulking to increase
>> >> >> >> >> >> >> > > > >> > performance :)=20=20=20=20
>> >> >> >> >> >> >> > > > >>
>> >> >> >> >> >> >> > > > >> I am missing the one big rcu_read_lock() part=
.  For example, in i40e_txrx.c,
>> >> >> >> >> >> >> > > > >> i40e_run_xdp() has its own rcu_read_lock/unlo=
ck().  dst->xdp_prog used to run
>> >> >> >> >> >> >> > > > >> in i40e_run_xdp() and it is fine.
>> >> >> >> >> >> >> > > > >>=20
>> >> >> >> >> >> >> > > > >> In this patch, dst->xdp_prog is run outside o=
f i40e_run_xdp() where the
>> >> >> >> >> >> >> > > > >> rcu_read_unlock() has already done.  It is no=
w run in xdp_do_flush_map().
>> >> >> >> >> >> >> > > > >> or I missed the big rcu_read_lock() in i40e_n=
api_poll()?
>> >> >> >> >> >> >> > > > >>
>> >> >> >> >> >> >> > > > >> I do see the big rcu_read_lock() in mlx5e_nap=
i_poll().=20=20
>> >> >> >> >> >> >> > > > >
>> >> >> >> >> >> >> > > > > I believed/assumed xdp_do_flush_map() was alre=
ady protected under an
>> >> >> >> >> >> >> > > > > rcu_read_lock.  As the devmap and cpumap, whic=
h get called via
>> >> >> >> >> >> >> > > > > __dev_flush() and __cpu_map_flush(), have mult=
iple RCU objects that we
>> >> >> >> >> >> >> > > > > are operating on.=20=20
>> >> >> >> >> >> >> > >
>> >> >> >> >> >> >> > > What other rcu objects it is using during flush?
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > Look at code:
>> >> >> >> >> >> >> >  kernel/bpf/cpumap.c
>> >> >> >> >> >> >> >  kernel/bpf/devmap.c
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > The devmap is filled with RCU code and complicated t=
ake-down steps.=20=20
>> >> >> >> >> >> >> > The devmap's elements are also RCU objects and the B=
PF xdp_prog is
>> >> >> >> >> >> >> > embedded in this object (struct bpf_dtab_netdev).  T=
he call_rcu
>> >> >> >> >> >> >> > function is __dev_map_entry_free().
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > > > > Perhaps it is a bug in i40e?=20=20
>> >> >> >> >> >> >> > >
>> >> >> >> >> >> >> > > A quick look into ixgbe falls into the same bucket.
>> >> >> >> >> >> >> > > didn't look at other drivers though.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > Intel driver are very much in copy-paste mode.
>> >> >> >> >> >> >> >=20=20
>> >> >> >> >> >> >> > > > >
>> >> >> >> >> >> >> > > > > We are running in softirq in NAPI context, whe=
n xdp_do_flush_map() is
>> >> >> >> >> >> >> > > > > call, which I think means that this CPU will n=
ot go-through a RCU grace
>> >> >> >> >> >> >> > > > > period before we exit softirq, so in-practice =
it should be safe.=20=20
>> >> >> >> >> >> >> > > >=20
>> >> >> >> >> >> >> > > > Yup, this seems to be correct: rcu_softirq_qs() =
is only called between
>> >> >> >> >> >> >> > > > full invocations of the softirq handler, which f=
or networking is
>> >> >> >> >> >> >> > > > net_rx_action(), and so translates into full NAP=
I poll cycles.=20=20
>> >> >> >> >> >> >> > >
>> >> >> >> >> >> >> > > I don't know enough to comment on the rcu/softirq =
part, may be someone
>> >> >> >> >> >> >> > > can chime in.  There is also a recent napi_threade=
d_poll().
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > CC added Paul. (link to patch[1][2] for context)
>> >> >> >> >> >> >> Updated Paul's email address.
>> >> >> >> >> >> >>=20
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > > If it is the case, then some of the existing rcu_r=
ead_lock() is unnecessary?
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > Well, in many cases, especially depending on how ker=
nel is compiled,
>> >> >> >> >> >> >> > that is true.  But we want to keep these, as they al=
so document the
>> >> >> >> >> >> >> > intend of the programmer.  And allow us to make the =
kernel even more
>> >> >> >> >> >> >> > preempt-able in the future.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > > At least, it sounds incorrect to only make an exce=
ption here while keeping
>> >> >> >> >> >> >> > > other rcu_read_lock() as-is.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > Let me be clear:  I think you have spotted a problem=
, and we need to
>> >> >> >> >> >> >> > add rcu_read_lock() at least around the invocation of
>> >> >> >> >> >> >> > bpf_prog_run_xdp() or before around if-statement tha=
t call
>> >> >> >> >> >> >> > dev_map_bpf_prog_run(). (Hangbin please do this in V=
8).
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > Thank you Martin for reviewing the code carefully en=
ough to find this
>> >> >> >> >> >> >> > issue, that some drivers don't have a RCU-section ar=
ound the full XDP
>> >> >> >> >> >> >> > code path in their NAPI-loop.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > Question to Paul.  (I will attempt to describe in ge=
neric terms what
>> >> >> >> >> >> >> > happens, but ref real-function names).
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > We are running in softirq/NAPI context, the driver w=
ill call a
>> >> >> >> >> >> >> > bq_enqueue() function for every packet (if calling x=
dp_do_redirect) ,
>> >> >> >> >> >> >> > some driver wrap this with a rcu_read_lock/unlock() =
section (other have
>> >> >> >> >> >> >> > a large RCU-read section, that include the flush ope=
ration).
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > In the bq_enqueue() function we have a per_cpu_ptr (=
that store the
>> >> >> >> >> >> >> > xdp_frame packets) that will get flushed/send in the=
 call
>> >> >> >> >> >> >> > xdp_do_flush() (that end-up calling bq_xmit_all()). =
 This flush will
>> >> >> >> >> >> >> > happen before we end our softirq/NAPI context.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > The extension is that the per_cpu_ptr data structure=
 (after this patch)
>> >> >> >> >> >> >> > store a pointer to an xdp_prog (which is a RCU objec=
t).  In the flush
>> >> >> >> >> >> >> > operation (which we will wrap with RCU-read section)=
, we will use this
>> >> >> >> >> >> >> > xdp_prog pointer.   I can see that it is in-principl=
e wrong to pass
>> >> >> >> >> >> >> > this-pointer between RCU-read sections, but I consid=
er this safe as we
>> >> >> >> >> >> >> > are running under softirq/NAPI and the per_cpu_ptr i=
s only valid in
>> >> >> >> >> >> >> > this short interval.
>> >> >> >> >> >> >> >=20
>> >> >> >> >> >> >> > I claim a grace/quiescent RCU cannot happen between =
these two RCU-read
>> >> >> >> >> >> >> > sections, but I might be wrong? (especially in the f=
uture or for RT).
>> >> >> >> >> >> >
>> >> >> >> >> >> > If I am reading this correctly (ha!), a very high-level=
 summary of the
>> >> >> >> >> >> > code in question is something like this:
>> >> >> >> >> >> >
>> >> >> >> >> >> > 	void foo(void)
>> >> >> >> >> >> > 	{
>> >> >> >> >> >> > 		local_bh_disable();
>> >> >> >> >> >> >
>> >> >> >> >> >> > 		rcu_read_lock();
>> >> >> >> >> >> > 		p =3D rcu_dereference(gp);
>> >> >> >> >> >> > 		do_something_with(p);
>> >> >> >> >> >> > 		rcu_read_unlock();
>> >> >> >> >> >> >
>> >> >> >> >> >> > 		do_something_else();
>> >> >> >> >> >> >
>> >> >> >> >> >> > 		rcu_read_lock();
>> >> >> >> >> >> > 		do_some_other_thing(p);
>> >> >> >> >> >> > 		rcu_read_unlock();
>> >> >> >> >> >> >
>> >> >> >> >> >> > 		local_bh_enable();
>> >> >> >> >> >> > 	}
>> >> >> >> >> >> >
>> >> >> >> >> >> > 	void bar(struct blat *new_gp)
>> >> >> >> >> >> > 	{
>> >> >> >> >> >> > 		struct blat *old_gp;
>> >> >> >> >> >> >
>> >> >> >> >> >> > 		spin_lock(my_lock);
>> >> >> >> >> >> > 		old_gp =3D rcu_dereference_protected(gp, lock_held(my=
_lock));
>> >> >> >> >> >> > 		rcu_assign_pointer(gp, new_gp);
>> >> >> >> >> >> > 		spin_unlock(my_lock);
>> >> >> >> >> >> > 		synchronize_rcu();
>> >> >> >> >> >> > 		kfree(old_gp);
>> >> >> >> >> >> > 	}
>> >> >> >> >> >>=20
>> >> >> >> >> >> Yeah, something like that (the object is freed using call=
_rcu() - but I
>> >> >> >> >> >> think that's equivalent, right?). And the question is whe=
ther we need to
>> >> >> >> >> >> extend foo() so that is has one big rcu_read_lock() that =
covers the
>> >> >> >> >> >> whole lifetime of p.
>> >> >> >> >> >
>> >> >> >> >> > Yes, use of call_rcu() is an asynchronous version of synch=
ronize_rcu().
>> >> >> >> >> > In fact, synchronize_rcu() is implemented in terms of call=
_rcu().  ;-)
>> >> >> >> >>=20
>> >> >> >> >> Right, gotcha!
>> >> >> >> >>=20
>> >> >> >> >> >> > I need to check up on -rt.
>> >> >> >> >> >> >
>> >> >> >> >> >> > But first... In recent mainline kernels, the local_bh_d=
isable() region
>> >> >> >> >> >> > will look like one big RCU read-side critical section. =
 But don't try
>> >> >> >> >> >> > this prior to v4.20!!!  In v4.19 and earlier, you would=
 need to use
>> >> >> >> >> >> > both synchronize_rcu() and synchronize_rcu_bh() to make=
 this work, or,
>> >> >> >> >> >> > for less latency, synchronize_rcu_mult(call_rcu, call_r=
cu_bh).
>> >> >> >> >> >>=20
>> >> >> >> >> >> OK. Variants of this code has been around since before th=
en, but I
>> >> >> >> >> >> honestly have no idea what it looked like back then exact=
ly...
>> >> >> >> >> >
>> >> >> >> >> > I know that feeling...
>> >> >> >> >> >
>> >> >> >> >> >> > Except that in that case, why not just drop the inner r=
cu_read_unlock()
>> >> >> >> >> >> > and rcu_read_lock() pair?  Awkward function boundaries =
or some such?
>> >> >> >> >> >>=20
>> >> >> >> >> >> Well if we can just treat such a local_bh_disable()/enabl=
e() pair as the
>> >> >> >> >> >> equivalent of rcu_read_lock()/unlock() then I suppose we =
could just get
>> >> >> >> >> >> rid of the inner ones. What about tools like lockdep; do =
they understand
>> >> >> >> >> >> this, or are we likely to get complaints if we remove it?
>> >> >> >> >> >
>> >> >> >> >> > If you just got rid of the first rcu_read_unlock() and the=
 second
>> >> >> >> >> > rcu_read_lock() in the code above, lockdep will understand.
>> >> >> >> >>=20
>> >> >> >> >> Right, but doing so entails going through all the drivers, w=
hich is what
>> >> >> >> >> we're trying to avoid :)
>> >> >> >> >
>> >> >> >> > I was afraid of that...  ;-)
>> >> >> >> >
>> >> >> >> >> > However, if you instead get rid of -all- of the rcu_read_l=
ock() and
>> >> >> >> >> > rcu_read_unlock() invocations in the code above, you would=
 need to let
>> >> >> >> >> > lockdep know by adding rcu_read_lock_bh_held().  So instea=
d of this:
>> >> >> >> >> >
>> >> >> >> >> > 	p =3D rcu_dereference(gp);
>> >> >> >> >> >
>> >> >> >> >> > You would do this:
>> >> >> >> >> >
>> >> >> >> >> > 	p =3D rcu_dereference_check(gp, rcu_read_lock_bh_held());
>> >> >> >> >> >
>> >> >> >> >> > This would be needed for mainline, regardless of -rt.
>> >> >> >> >>=20
>> >> >> >> >> OK. And as far as I can tell this is harmless for code paths=
 that call
>> >> >> >> >> the same function but from a regular rcu_read_lock()-protect=
ed section
>> >> >> >> >> instead from a bh-disabled section, right?
>> >> >> >> >
>> >> >> >> > That is correct.  That rcu_dereference_check() invocation wil=
l make
>> >> >> >> > lockdep be OK with rcu_read_lock() or with softirq being disa=
bled.
>> >> >> >> > Or both, for that matter.
>> >> >> >>=20
>> >> >> >> OK, great, thank you for confirming my understanding!
>> >> >> >>=20
>> >> >> >> >> What happens, BTW, if we *don't* get rid of all the existing
>> >> >> >> >> rcu_read_lock() sections? Going back to your foo() example a=
bove, what
>> >> >> >> >> we're discussing is whether to add that second rcu_read_lock=
() around
>> >> >> >> >> do_some_other_thing(p). I.e., the first one around the rcu_d=
ereference()
>> >> >> >> >> is already there (in the particular driver we're discussing)=
, and the
>> >> >> >> >> local_bh_disable/enable() pair is already there. AFAICT from=
 our
>> >> >> >> >> discussion, there really is not much point in adding that se=
cond
>> >> >> >> >> rcu_read_lock/unlock(), is there?
>> >> >> >> >
>> >> >> >> > From an algorithmic point of view, the second rcu_read_lock()
>> >> >> >> > and rcu_read_unlock() are redundant.  Of course, there are al=
so
>> >> >> >> > software-engineering considerations, including copy-pasta iss=
ues.
>> >> >> >> >
>> >> >> >> >> And because that first rcu_read_lock() around the rcu_derefe=
rence() is
>> >> >> >> >> already there, lockdep is not likely to complain either, so =
we're
>> >> >> >> >> basically fine? Except that the code is somewhat confusing a=
s-is, of
>> >> >> >> >> course; i.e., we should probably fix it but it's not terribl=
y urgent. Or?
>> >> >> >> >
>> >> >> >> > I am concerned about copy-pasta-induced bugs.  Someone looks =
just at
>> >> >> >> > the code, fails to note the fact that softirq is disabled thr=
oughout,
>> >> >> >> > and decides that leaking a pointer from one RCU read-side cri=
tical
>> >> >> >> > section to a later one is just fine.  :-/
>> >> >> >>=20
>> >> >> >> Yup, totally agreed that we need to fix this for the sake of th=
e humans
>> >> >> >> reading the code; just wanted to make sure my understanding was=
 correct
>> >> >> >> that we don't strictly need to do anything as far as the machin=
es
>> >> >> >> executing it are concerned :)
>> >> >> >>=20
>> >> >> >> >> Hmm, looking at it now, it seems not all the lookup code is =
actually
>> >> >> >> >> doing rcu_dereference() at all, but rather just a plain READ=
_ONCE() with
>> >> >> >> >> a comment above it saying that RCU ensures objects won't dis=
appear[0];
>> >> >> >> >> so I suppose we're at least safe from lockdep in that sense =
:P - but we
>> >> >> >> >> should definitely clean this up.
>> >> >> >> >>=20
>> >> >> >> >> [0] Exhibit A: https://elixir.bootlin.com/linux/latest/sourc=
e/kernel/bpf/devmap.c#L391
>> >> >> >> >
>> >> >> >> > That use of READ_ONCE() will definitely avoid lockdep complai=
nts,
>> >> >> >> > including those complaints that point out bugs.  It also migh=
t get you
>> >> >> >> > sparse complaints if the RCU-protected pointer is marked with=
 __rcu.
>> >> >> >>=20
>> >> >> >> It's not; it's the netdev_map member of this struct:
>> >> >> >>=20
>> >> >> >> struct bpf_dtab {
>> >> >> >> 	struct bpf_map map;
>> >> >> >> 	struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
>> >> >> >> 	struct list_head list;
>> >> >> >>=20
>> >> >> >> 	/* these are only used for DEVMAP_HASH type maps */
>> >> >> >> 	struct hlist_head *dev_index_head;
>> >> >> >> 	spinlock_t index_lock;
>> >> >> >> 	unsigned int items;
>> >> >> >> 	u32 n_buckets;
>> >> >> >> };
>> >> >> >>=20
>> >> >> >> Will adding __rcu to such a dynamic array member do the right t=
hing when
>> >> >> >> paired with rcu_dereference() on array members (i.e., in place =
of the
>> >> >> >> READ_ONCE in the code linked above)?
>> >> >> >
>> >> >> > The only thing __rcu will do is provide information to the spars=
e static
>> >> >> > analysis tool.  Which will then gripe at you for applying READ_O=
NCE()
>> >> >> > to a __rcu pointer.  But it is already griping at you for applyi=
ng
>> >> >> > rcu_dereference() to something not marked __rcu, so...  ;-)
>> >> >>=20
>> >> >> Right, hence the need for a cleanup ;)
>> >> >>=20
>> >> >> My question was more if it understood arrays, though. I.e., that
>> >> >> 'netdev_map' is an array of RCU pointers, not an RCU pointer to an
>> >> >> array... Or am I maybe thinking that tool is way smarter than it i=
s, and
>> >> >> it just complains for any access to that field that doesn't use
>> >> >> rcu_dereference()?
>> >> >
>> >> > I believe that sparse will know about the pointers being __rcu, but
>> >> > not the array.  Unless you mark both levels.
>> >>=20
>> >> Hi Paul
>> >>=20
>> >> One more question, since I started adding the annotations: We are
>> >> currently swapping out the pointers using xchg():
>> >> https://elixir.bootlin.com/linux/latest/source/kernel/bpf/devmap.c#L5=
55
>> >>=20
>> >> and even cmpxchg():
>> >> https://elixir.bootlin.com/linux/latest/source/kernel/bpf/devmap.c#L8=
31
>> >>=20
>> >> Sparse complains about these if I add the __rcu annotation to the
>> >> definition (which otherwise works just fine with the double-pointer,
>> >> BTW). Is there a way to fix that? Some kind of rcu_ macro version of =
the
>> >> atomic swaps or something? Or do we just keep the regular xchg() and
>> >> ignore those particular sparse warnings?
>> >
>> > Sounds like I need to supply a unrcu_pointer() macro or some such.
>> > This would operate something like the current open-coded casts
>> > in __rcu_dereference_protected().
>>=20
>> So with that, I would turn the existing:
>>=20
>> 	dev =3D READ_ONCE(dtab->netdev_map[i]);
>> 	if (!dev || netdev !=3D dev->dev)
>> 		continue;
>> 	odev =3D cmpxchg(&dtab->netdev_map[i], dev, NULL);
>>=20
>> into:
>>=20
>> 	dev =3D rcu_dereference(dtab->netdev_map[i]);
>> 	if (!dev || netdev !=3D dev->dev)
>> 		continue;
>> 	odev =3D cmpxchg(unrcu_pointer(&dtab->netdev_map[i]), dev, NULL);
>>=20
>>=20
>> and with a _check version:
>>=20
>> 	old_dev =3D xchg(unrcu_pointer_check(&dtab->netdev_map[k], rcu_read_loc=
k_bh_held()), NULL);
>>=20
>> right?
>>=20
>> Or would it be:
>> 	odev =3D cmpxchg(&unrcu_pointer(dtab->netdev_map[i]), dev, NULL);
>> ?
>>=20
>> > Would something like that work for you?
>>=20
>> Yeah, I believe it would :)
>
> Except that I was forgetting that the __rcu decorates the pointed-to
> data rather than the pointer itself.  :-/
>
> But that is actually easier, as you can follow the example of
> rcu_assign_pointer(), namely using RCU_INITIALIZER().
>
> So like this:
>
> 	odev =3D cmpxchg(&dtab->netdev_map[i], RCU_INITIALIZER(dev), NULL);
>
> I -think- that the NULL doesn't need an RCU_INITIALIZER(), but it is
> of course sparse's opinion that matters.
>
> And of course like this:
>
> 	old_dev =3D xchg(&dtab->netdev_map[k], RCU_INITIALIZER(newmap));
>
> Does that work, or am I still confused?

That gets rid of one warning, but not the other. Before (plain xchg):

kernel/bpf/devmap.c:657:19: warning: incorrect type in initializer (differe=
nt address spaces)
kernel/bpf/devmap.c:657:19:    expected struct bpf_dtab_netdev [noderef] __=
rcu *__ret
kernel/bpf/devmap.c:657:19:    got struct bpf_dtab_netdev *[assigned] dev
kernel/bpf/devmap.c:657:17: warning: incorrect type in assignment (differen=
t address spaces)
kernel/bpf/devmap.c:657:17:    expected struct bpf_dtab_netdev *old_dev
kernel/bpf/devmap.c:657:17:    got struct bpf_dtab_netdev [noderef] __rcu *=
[assigned] __ret

after (RCU_INITIALIZER() on the second argument to xchg):

kernel/bpf/devmap.c:657:17: warning: incorrect type in assignment (differen=
t address spaces)
kernel/bpf/devmap.c:657:17:    expected struct bpf_dtab_netdev *old_dev
kernel/bpf/devmap.c:657:17:    got struct bpf_dtab_netdev [noderef] __rcu *=
[assigned] __ret

I can get rid of that second one by marking old_dev as __rcu, but then I
get a new warning when dereferencing that in the subsequent
call_rcu()...

So I guess we still need that unrcu_pointer(), to wrap the xchg() in?

-Toke

