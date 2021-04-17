Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A68362FDC
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 15:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhDQM1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 08:27:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDQM1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 08:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618662445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UcVLxACFCEQjuWdMqOIDxJbiuOAE3Voxj6exHo3cApA=;
        b=B/OiW6JyWe9q1dhLJk9k6lyBdapG42l8+NlI/x07yjwvr1kQZPyg72wmgGRQ2ZCaUd8qit
        c/j0u3wV78kVpIpHgQlnXE9GCHEzSnvTzVOu9WpsaawYx+tdOFAtOOUoOqqwoI2ykZcv+C
        CFAFLdFWQenxTUlQ+Mz9PAiAs5LeLYs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-u6RwPo1gPJaauyyxXpZWxA-1; Sat, 17 Apr 2021 08:27:23 -0400
X-MC-Unique: u6RwPo1gPJaauyyxXpZWxA-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a50f1ca0000b0290382d654f75eso8573300edl.1
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 05:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UcVLxACFCEQjuWdMqOIDxJbiuOAE3Voxj6exHo3cApA=;
        b=ivZU6/w84OSvSkNjgKiuKIBsTwWpm3+SWR5FEBrr+QZWLNvgNrgvNXNenl8vzmOpEL
         ISkA6Qs4WmheR4MjCU9InHa/EVuZ1jXUTskdz+tAeRdigNkuAaschhc0IBn1kA2oJrgD
         ROOAkO54nnW0E1BeduIN9BqOILb0G3wdARXikpWIKqnnqm9HayyWJ//Japc+e1SrdUdl
         +ShPYCBdXBErwZHrUEXwCNF5EN2gZveaZYxhVmyphr9AE0hdYfJUhYnew6yYqG/vtSfr
         HsxsbpT8MoMmfvtoelo0U4fBf0mUbhWXL73KRoVUyk1r/kxNm8A1q3pt7cxtkV6DWAsL
         gN5g==
X-Gm-Message-State: AOAM531HXppSNt3wz2OD3Wj7NCVLaO74gocYsXCmP7bCA+3/U+X8hyrL
        L/FEXQn5cvIDB2uX1m9YWlrV+Sva/dJsNXvWJ/i++jTN6NEi1JhErr1FNmA3CEk1B26KOVojkWe
        1Ebc4Xkq5M/wOC1Rx
X-Received: by 2002:a17:906:3c1b:: with SMTP id h27mr13291738ejg.182.1618662441984;
        Sat, 17 Apr 2021 05:27:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjfoQRATjunian71aZVRSW4TzCiqCl98mHdyasVNApF32CsG4rKSuGFVPKRC4EE2p5ckeJ2g==
X-Received: by 2002:a17:906:3c1b:: with SMTP id h27mr13291706ejg.182.1618662441517;
        Sat, 17 Apr 2021 05:27:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i2sm6259078ejv.99.2021.04.17.05.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 05:27:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B3BC6180002; Sat, 17 Apr 2021 14:27:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     paulmck@kernel.org, Martin KaFai Lau <kafai@fb.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
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
In-Reply-To: <20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1>
References: <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s> <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon> <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <20210416154523.3b1fe700@carbon>
 <20210416182252.c25akwj6zjdvo7u2@kafai-mbp.dhcp.thefacebook.com>
 <20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 17 Apr 2021 14:27:19 +0200
Message-ID: <87h7k5hza0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Fri, Apr 16, 2021 at 11:22:52AM -0700, Martin KaFai Lau wrote:
>> On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper Dangaard Brouer wrote:
>> > On Thu, 15 Apr 2021 17:39:13 -0700
>> > Martin KaFai Lau <kafai@fb.com> wrote:
>> >=20
>> > > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
>> > > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> > > >=20=20=20
>> > > > > On Thu, 15 Apr 2021 10:35:51 -0700
>> > > > > Martin KaFai Lau <kafai@fb.com> wrote:
>> > > > >=20=20
>> > > > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-J=
=C3=B8rgensen wrote:=20=20
>> > > > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> > > > >> >=20=20=20=20=20
>> > > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau =
wrote:=20=20=20=20
>> > > > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, =
u32 flags)
>> > > > >> > >> >  {
>> > > > >> > >> >  	struct net_device *dev =3D bq->dev;
>> > > > >> > >> > -	int sent =3D 0, err =3D 0;
>> > > > >> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
>> > > > >> > >> > +	unsigned int cnt =3D bq->count;
>> > > > >> > >> > +	int to_send =3D cnt;
>> > > > >> > >> >  	int i;
>> > > > >> > >> >=20=20
>> > > > >> > >> > -	if (unlikely(!bq->count))
>> > > > >> > >> > +	if (unlikely(!cnt))
>> > > > >> > >> >  		return;
>> > > > >> > >> >=20=20
>> > > > >> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> > > > >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> > > > >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> > > > >> > >> >=20=20
>> > > > >> > >> >  		prefetch(xdpf);
>> > > > >> > >> >  	}
>> > > > >> > >> >=20=20
>> > > > >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count,=
 bq->q, flags);
>> > > > >> > >> > +	if (bq->xdp_prog) {=20=20=20=20
>> > > > >> > >> bq->xdp_prog is used here
>> > > > >> > >>=20=20=20=20=20
>> > > > >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q,=
 cnt, dev);
>> > > > >> > >> > +		if (!to_send)
>> > > > >> > >> > +			goto out;
>> > > > >> > >> > +
>> > > > >> > >> > +		drops =3D cnt - to_send;
>> > > > >> > >> > +	}
>> > > > >> > >> > +=20=20=20=20
>> > > > >> > >>=20
>> > > > >> > >> [ ... ]
>> > > > >> > >>=20=20=20=20=20
>> > > > >> > >> >  static void bq_enqueue(struct net_device *dev, struct x=
dp_frame *xdpf,
>> > > > >> > >> > -		       struct net_device *dev_rx)
>> > > > >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xd=
p_prog)
>> > > > >> > >> >  {
>> > > > >> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_flu=
sh_list);
>> > > > >> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xd=
p_bulkq);
>> > > > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_=
device *dev, struct xdp_frame *xdpf,
>> > > > >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's=
 in
>> > > > >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be f=
lushed
>> > > > >> > >> >  	 * from net_device drivers NAPI func end.
>> > > > >> > >> > +	 *
>> > > > >> > >> > +	 * Do the same with xdp_prog and flush_list since thes=
e fields
>> > > > >> > >> > +	 * are only ever modified together.
>> > > > >> > >> >  	 */
>> > > > >> > >> > -	if (!bq->dev_rx)
>> > > > >> > >> > +	if (!bq->dev_rx) {
>> > > > >> > >> >  		bq->dev_rx =3D dev_rx;
>> > > > >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20=20=20
>> > > > >> > >> bp->xdp_prog is assigned here and could be used later in b=
q_xmit_all().
>> > > > >> > >> How is bq->xdp_prog protected? Are they all under one rcu_=
read_lock()?
>> > > > >> > >> It is not very obvious after taking a quick look at xdp_do=
_flush[_map].
>> > > > >> > >>=20
>> > > > >> > >> e.g. what if the devmap elem gets deleted.=20=20=20=20
>> > > > >> > >
>> > > > >> > > Jesper knows better than me. From my veiw, based on the des=
cription of
>> > > > >> > > __dev_flush():
>> > > > >> > >
>> > > > >> > > On devmap tear down we ensure the flush list is empty befor=
e completing to
>> > > > >> > > ensure all flush operations have completed. When drivers up=
date the bpf
>> > > > >> > > program they may need to ensure any flush ops are also comp=
lete.=20=20=20=20
>> > > > >>
>> > > > >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devm=
ap's elem.
>> >=20
>> > The bq->xdp_prog comes form the devmap "dev" element, and it is stored
>> > in temporarily in the "bq" structure that is only valid for this
>> > softirq NAPI-cycle.  I'm slightly worried that we copied this pointer
>> > the the xdp_prog here, more below (and Q for Paul).
>> >=20
>> > > > >> >=20
>> > > > >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI p=
oll loop,
>> > > > >> > which also runs under one big rcu_read_lock(). So the storage=
 in the
>> > > > >> > bulk queue is quite temporary, it's just used for bulking to =
increase
>> > > > >> > performance :)=20=20=20=20
>> > > > >>
>> > > > >> I am missing the one big rcu_read_lock() part.  For example, in=
 i40e_txrx.c,
>> > > > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_pr=
og used to run
>> > > > >> in i40e_run_xdp() and it is fine.
>> > > > >>=20
>> > > > >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() w=
here the
>> > > > >> rcu_read_unlock() has already done.  It is now run in xdp_do_fl=
ush_map().
>> > > > >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
>> > > > >>
>> > > > >> I do see the big rcu_read_lock() in mlx5e_napi_poll().=20=20
>> > > > >
>> > > > > I believed/assumed xdp_do_flush_map() was already protected unde=
r an
>> > > > > rcu_read_lock.  As the devmap and cpumap, which get called via
>> > > > > __dev_flush() and __cpu_map_flush(), have multiple RCU objects t=
hat we
>> > > > > are operating on.=20=20
>> > >
>> > > What other rcu objects it is using during flush?
>> >=20
>> > Look at code:
>> >  kernel/bpf/cpumap.c
>> >  kernel/bpf/devmap.c
>> >=20
>> > The devmap is filled with RCU code and complicated take-down steps.=20=
=20
>> > The devmap's elements are also RCU objects and the BPF xdp_prog is
>> > embedded in this object (struct bpf_dtab_netdev).  The call_rcu
>> > function is __dev_map_entry_free().
>> >=20
>> >=20
>> > > > > Perhaps it is a bug in i40e?=20=20
>> > >
>> > > A quick look into ixgbe falls into the same bucket.
>> > > didn't look at other drivers though.
>> >=20
>> > Intel driver are very much in copy-paste mode.
>> >=20=20
>> > > > >
>> > > > > We are running in softirq in NAPI context, when xdp_do_flush_map=
() is
>> > > > > call, which I think means that this CPU will not go-through a RC=
U grace
>> > > > > period before we exit softirq, so in-practice it should be safe.=
=20=20
>> > > >=20
>> > > > Yup, this seems to be correct: rcu_softirq_qs() is only called bet=
ween
>> > > > full invocations of the softirq handler, which for networking is
>> > > > net_rx_action(), and so translates into full NAPI poll cycles.=20=
=20
>> > >
>> > > I don't know enough to comment on the rcu/softirq part, may be someo=
ne
>> > > can chime in.  There is also a recent napi_threaded_poll().
>> >=20
>> > CC added Paul. (link to patch[1][2] for context)
>> Updated Paul's email address.
>>=20
>> >=20
>> > > If it is the case, then some of the existing rcu_read_lock() is unne=
cessary?
>> >=20
>> > Well, in many cases, especially depending on how kernel is compiled,
>> > that is true.  But we want to keep these, as they also document the
>> > intend of the programmer.  And allow us to make the kernel even more
>> > preempt-able in the future.
>> >=20
>> > > At least, it sounds incorrect to only make an exception here while k=
eeping
>> > > other rcu_read_lock() as-is.
>> >=20
>> > Let me be clear:  I think you have spotted a problem, and we need to
>> > add rcu_read_lock() at least around the invocation of
>> > bpf_prog_run_xdp() or before around if-statement that call
>> > dev_map_bpf_prog_run(). (Hangbin please do this in V8).
>> >=20
>> > Thank you Martin for reviewing the code carefully enough to find this
>> > issue, that some drivers don't have a RCU-section around the full XDP
>> > code path in their NAPI-loop.
>> >=20
>> > Question to Paul.  (I will attempt to describe in generic terms what
>> > happens, but ref real-function names).
>> >=20
>> > We are running in softirq/NAPI context, the driver will call a
>> > bq_enqueue() function for every packet (if calling xdp_do_redirect) ,
>> > some driver wrap this with a rcu_read_lock/unlock() section (other have
>> > a large RCU-read section, that include the flush operation).
>> >=20
>> > In the bq_enqueue() function we have a per_cpu_ptr (that store the
>> > xdp_frame packets) that will get flushed/send in the call
>> > xdp_do_flush() (that end-up calling bq_xmit_all()).  This flush will
>> > happen before we end our softirq/NAPI context.
>> >=20
>> > The extension is that the per_cpu_ptr data structure (after this patch)
>> > store a pointer to an xdp_prog (which is a RCU object).  In the flush
>> > operation (which we will wrap with RCU-read section), we will use this
>> > xdp_prog pointer.   I can see that it is in-principle wrong to pass
>> > this-pointer between RCU-read sections, but I consider this safe as we
>> > are running under softirq/NAPI and the per_cpu_ptr is only valid in
>> > this short interval.
>> >=20
>> > I claim a grace/quiescent RCU cannot happen between these two RCU-read
>> > sections, but I might be wrong? (especially in the future or for RT).
>
> If I am reading this correctly (ha!), a very high-level summary of the
> code in question is something like this:
>
> 	void foo(void)
> 	{
> 		local_bh_disable();
>
> 		rcu_read_lock();
> 		p =3D rcu_dereference(gp);
> 		do_something_with(p);
> 		rcu_read_unlock();
>
> 		do_something_else();
>
> 		rcu_read_lock();
> 		do_some_other_thing(p);
> 		rcu_read_unlock();
>
> 		local_bh_enable();
> 	}
>
> 	void bar(struct blat *new_gp)
> 	{
> 		struct blat *old_gp;
>
> 		spin_lock(my_lock);
> 		old_gp =3D rcu_dereference_protected(gp, lock_held(my_lock));
> 		rcu_assign_pointer(gp, new_gp);
> 		spin_unlock(my_lock);
> 		synchronize_rcu();
> 		kfree(old_gp);
> 	}

Yeah, something like that (the object is freed using call_rcu() - but I
think that's equivalent, right?). And the question is whether we need to
extend foo() so that is has one big rcu_read_lock() that covers the
whole lifetime of p.

> I need to check up on -rt.
>
> But first... In recent mainline kernels, the local_bh_disable() region
> will look like one big RCU read-side critical section.  But don't try
> this prior to v4.20!!!  In v4.19 and earlier, you would need to use
> both synchronize_rcu() and synchronize_rcu_bh() to make this work, or,
> for less latency, synchronize_rcu_mult(call_rcu, call_rcu_bh).

OK. Variants of this code has been around since before then, but I
honestly have no idea what it looked like back then exactly...

> Except that in that case, why not just drop the inner rcu_read_unlock()
> and rcu_read_lock() pair?  Awkward function boundaries or some such?

Well if we can just treat such a local_bh_disable()/enable() pair as the
equivalent of rcu_read_lock()/unlock() then I suppose we could just get
rid of the inner ones. What about tools like lockdep; do they understand
this, or are we likely to get complaints if we remove it?

> Especially given that if this works on -rt, it is probably because
> their variant of do_softirq() holds rcu_read_lock() across each
> softirq handler invocation. They do something similar for rwlocks.

Right. Guess we'll wait for your confirmation of that, then. Thanks! :)

-Toke

