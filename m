Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFDE3649AA
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 20:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbhDSSNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 14:13:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240427AbhDSSNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 14:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618855956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ju/4vhU8MP7I28WVjcXgr2ibYzfOMrr6gIFzg3+yy0c=;
        b=gR33jlwiWWKn1RYzYhRRkM8Td070WmUIWjdtPrG66loBt5xI3ftMQndJoDDjlFlgQTlrnL
        XnyNzvl/NFKk7IsJ3Mzwe+GxC2NS//PqNFc2DuE+d1ILbU+l8hrjZAcV3zXRuY8TwnPgvW
        b1tT9dcsD1/5+6ijCacyvF6mkgN2+Lk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-nQzMZd4bNIyNPcNj0xo7FA-1; Mon, 19 Apr 2021 14:12:31 -0400
X-MC-Unique: nQzMZd4bNIyNPcNj0xo7FA-1
Received: by mail-ed1-f70.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so4238312edb.8
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 11:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ju/4vhU8MP7I28WVjcXgr2ibYzfOMrr6gIFzg3+yy0c=;
        b=ED7iCY+kJUp7HmvqhbMuN3KQHkZoOU/hqKAVBUNBzl5saBenXp8FvxK/K7nGm0JIyC
         D7ZgkMst/rUCNZwl1zVfuyAx2vhMleuujkW3mRzjZ6v98PYvObq8C7vZZKEttgP4bC5N
         E0tkb/UQI7u0ZuLsA9UIZLT3xy0jrV2nfD7bnHLAdldDiBBKI4Pl9wvtoJofzi1IEHeE
         7C0RJ4SIaXskfxC0pp8F8f3Oh8W+jWCFCRfEEKDCt4zSKllNA+UmXQhYdfBdV3Oi4+V9
         P8cb0fNKhvPBT7FnL+LhdJbDicTkty8YullREBccxHvI8TzKm3FqVC9KI3HqKh4Ykkoy
         ze6Q==
X-Gm-Message-State: AOAM533QVv218tCEY8ZfMsboI1iz5Cz7kaUjmCqWZJMgwLijecOQ2hAE
        2InnbuHRQpgd/TWxQj/Vh/hbS20F/3IRokvHyDYua/3H2Lsg33zPegMjap1x5GT7LkVctxhR80p
        vs8oAEtNi50C74cSt
X-Received: by 2002:a17:906:254f:: with SMTP id j15mr23666366ejb.344.1618855949956;
        Mon, 19 Apr 2021 11:12:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWVkJ9I9sKrQVIrzn+voz53fj7pwwlrsa1eN+9aT0revWKyCS6FVfcGpPYzWkF79Zc/8/avA==
X-Received: by 2002:a17:906:254f:: with SMTP id j15mr23666335ejb.344.1618855949608;
        Mon, 19 Apr 2021 11:12:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r17sm13656497edt.70.2021.04.19.11.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 11:12:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 81234180002; Mon, 19 Apr 2021 20:12:27 +0200 (CEST)
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
In-Reply-To: <20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1>
References: <20210415023746.GR2900@Leo-laptop-t470s>
 <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon> <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <20210416154523.3b1fe700@carbon>
 <20210416182252.c25akwj6zjdvo7u2@kafai-mbp.dhcp.thefacebook.com>
 <20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1>
 <87h7k5hza0.fsf@toke.dk>
 <20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 19 Apr 2021 20:12:27 +0200
Message-ID: <87lf9egn3o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Sat, Apr 17, 2021 at 02:27:19PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> "Paul E. McKenney" <paulmck@kernel.org> writes:
>>=20
>> > On Fri, Apr 16, 2021 at 11:22:52AM -0700, Martin KaFai Lau wrote:
>> >> On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper Dangaard Brouer wrot=
e:
>> >> > On Thu, 15 Apr 2021 17:39:13 -0700
>> >> > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> >=20
>> >> > > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
>> >> > > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> >> > > >=20=20=20
>> >> > > > > On Thu, 15 Apr 2021 10:35:51 -0700
>> >> > > > > Martin KaFai Lau <kafai@fb.com> wrote:
>> >> > > > >=20=20
>> >> > > > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-=
J=C3=B8rgensen wrote:=20=20
>> >> > > > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> >> > > > >> >=20=20=20=20=20
>> >> > > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai L=
au wrote:=20=20=20=20
>> >> > > > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *b=
q, u32 flags)
>> >> > > > >> > >> >  {
>> >> > > > >> > >> >  	struct net_device *dev =3D bq->dev;
>> >> > > > >> > >> > -	int sent =3D 0, err =3D 0;
>> >> > > > >> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
>> >> > > > >> > >> > +	unsigned int cnt =3D bq->count;
>> >> > > > >> > >> > +	int to_send =3D cnt;
>> >> > > > >> > >> >  	int i;
>> >> > > > >> > >> >=20=20
>> >> > > > >> > >> > -	if (unlikely(!bq->count))
>> >> > > > >> > >> > +	if (unlikely(!cnt))
>> >> > > > >> > >> >  		return;
>> >> > > > >> > >> >=20=20
>> >> > > > >> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> >> > > > >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> >> > > > >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> >> > > > >> > >> >=20=20
>> >> > > > >> > >> >  		prefetch(xdpf);
>> >> > > > >> > >> >  	}
>> >> > > > >> > >> >=20=20
>> >> > > > >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->cou=
nt, bq->q, flags);
>> >> > > > >> > >> > +	if (bq->xdp_prog) {=20=20=20=20
>> >> > > > >> > >> bq->xdp_prog is used here
>> >> > > > >> > >>=20=20=20=20=20
>> >> > > > >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq-=
>q, cnt, dev);
>> >> > > > >> > >> > +		if (!to_send)
>> >> > > > >> > >> > +			goto out;
>> >> > > > >> > >> > +
>> >> > > > >> > >> > +		drops =3D cnt - to_send;
>> >> > > > >> > >> > +	}
>> >> > > > >> > >> > +=20=20=20=20
>> >> > > > >> > >>=20
>> >> > > > >> > >> [ ... ]
>> >> > > > >> > >>=20=20=20=20=20
>> >> > > > >> > >> >  static void bq_enqueue(struct net_device *dev, struc=
t xdp_frame *xdpf,
>> >> > > > >> > >> > -		       struct net_device *dev_rx)
>> >> > > > >> > >> > +		       struct net_device *dev_rx, struct bpf_prog =
*xdp_prog)
>> >> > > > >> > >> >  {
>> >> > > > >> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_=
flush_list);
>> >> > > > >> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev-=
>xdp_bulkq);
>> >> > > > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct n=
et_device *dev, struct xdp_frame *xdpf,
>> >> > > > >> > >> >  	/* Ingress dev_rx will be the same for all xdp_fram=
e's in
>> >> > > > >> > >> >  	 * bulk_queue, because bq stored per-CPU and must b=
e flushed
>> >> > > > >> > >> >  	 * from net_device drivers NAPI func end.
>> >> > > > >> > >> > +	 *
>> >> > > > >> > >> > +	 * Do the same with xdp_prog and flush_list since t=
hese fields
>> >> > > > >> > >> > +	 * are only ever modified together.
>> >> > > > >> > >> >  	 */
>> >> > > > >> > >> > -	if (!bq->dev_rx)
>> >> > > > >> > >> > +	if (!bq->dev_rx) {
>> >> > > > >> > >> >  		bq->dev_rx =3D dev_rx;
>> >> > > > >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20=20=20
>> >> > > > >> > >> bp->xdp_prog is assigned here and could be used later i=
n bq_xmit_all().
>> >> > > > >> > >> How is bq->xdp_prog protected? Are they all under one r=
cu_read_lock()?
>> >> > > > >> > >> It is not very obvious after taking a quick look at xdp=
_do_flush[_map].
>> >> > > > >> > >>=20
>> >> > > > >> > >> e.g. what if the devmap elem gets deleted.=20=20=20=20
>> >> > > > >> > >
>> >> > > > >> > > Jesper knows better than me. From my veiw, based on the =
description of
>> >> > > > >> > > __dev_flush():
>> >> > > > >> > >
>> >> > > > >> > > On devmap tear down we ensure the flush list is empty be=
fore completing to
>> >> > > > >> > > ensure all flush operations have completed. When drivers=
 update the bpf
>> >> > > > >> > > program they may need to ensure any flush ops are also c=
omplete.=20=20=20=20
>> >> > > > >>
>> >> > > > >> AFAICT, the bq->xdp_prog is not from the dev. It is from a d=
evmap's elem.
>> >> >=20
>> >> > The bq->xdp_prog comes form the devmap "dev" element, and it is sto=
red
>> >> > in temporarily in the "bq" structure that is only valid for this
>> >> > softirq NAPI-cycle.  I'm slightly worried that we copied this point=
er
>> >> > the the xdp_prog here, more below (and Q for Paul).
>> >> >=20
>> >> > > > >> >=20
>> >> > > > >> > Yeah, drivers call xdp_do_flush() before exiting their NAP=
I poll loop,
>> >> > > > >> > which also runs under one big rcu_read_lock(). So the stor=
age in the
>> >> > > > >> > bulk queue is quite temporary, it's just used for bulking =
to increase
>> >> > > > >> > performance :)=20=20=20=20
>> >> > > > >>
>> >> > > > >> I am missing the one big rcu_read_lock() part.  For example,=
 in i40e_txrx.c,
>> >> > > > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp=
_prog used to run
>> >> > > > >> in i40e_run_xdp() and it is fine.
>> >> > > > >>=20
>> >> > > > >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp(=
) where the
>> >> > > > >> rcu_read_unlock() has already done.  It is now run in xdp_do=
_flush_map().
>> >> > > > >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
>> >> > > > >>
>> >> > > > >> I do see the big rcu_read_lock() in mlx5e_napi_poll().=20=20
>> >> > > > >
>> >> > > > > I believed/assumed xdp_do_flush_map() was already protected u=
nder an
>> >> > > > > rcu_read_lock.  As the devmap and cpumap, which get called via
>> >> > > > > __dev_flush() and __cpu_map_flush(), have multiple RCU object=
s that we
>> >> > > > > are operating on.=20=20
>> >> > >
>> >> > > What other rcu objects it is using during flush?
>> >> >=20
>> >> > Look at code:
>> >> >  kernel/bpf/cpumap.c
>> >> >  kernel/bpf/devmap.c
>> >> >=20
>> >> > The devmap is filled with RCU code and complicated take-down steps.=
=20=20
>> >> > The devmap's elements are also RCU objects and the BPF xdp_prog is
>> >> > embedded in this object (struct bpf_dtab_netdev).  The call_rcu
>> >> > function is __dev_map_entry_free().
>> >> >=20
>> >> >=20
>> >> > > > > Perhaps it is a bug in i40e?=20=20
>> >> > >
>> >> > > A quick look into ixgbe falls into the same bucket.
>> >> > > didn't look at other drivers though.
>> >> >=20
>> >> > Intel driver are very much in copy-paste mode.
>> >> >=20=20
>> >> > > > >
>> >> > > > > We are running in softirq in NAPI context, when xdp_do_flush_=
map() is
>> >> > > > > call, which I think means that this CPU will not go-through a=
 RCU grace
>> >> > > > > period before we exit softirq, so in-practice it should be sa=
fe.=20=20
>> >> > > >=20
>> >> > > > Yup, this seems to be correct: rcu_softirq_qs() is only called =
between
>> >> > > > full invocations of the softirq handler, which for networking is
>> >> > > > net_rx_action(), and so translates into full NAPI poll cycles.=
=20=20
>> >> > >
>> >> > > I don't know enough to comment on the rcu/softirq part, may be so=
meone
>> >> > > can chime in.  There is also a recent napi_threaded_poll().
>> >> >=20
>> >> > CC added Paul. (link to patch[1][2] for context)
>> >> Updated Paul's email address.
>> >>=20
>> >> >=20
>> >> > > If it is the case, then some of the existing rcu_read_lock() is u=
nnecessary?
>> >> >=20
>> >> > Well, in many cases, especially depending on how kernel is compiled,
>> >> > that is true.  But we want to keep these, as they also document the
>> >> > intend of the programmer.  And allow us to make the kernel even more
>> >> > preempt-able in the future.
>> >> >=20
>> >> > > At least, it sounds incorrect to only make an exception here whil=
e keeping
>> >> > > other rcu_read_lock() as-is.
>> >> >=20
>> >> > Let me be clear:  I think you have spotted a problem, and we need to
>> >> > add rcu_read_lock() at least around the invocation of
>> >> > bpf_prog_run_xdp() or before around if-statement that call
>> >> > dev_map_bpf_prog_run(). (Hangbin please do this in V8).
>> >> >=20
>> >> > Thank you Martin for reviewing the code carefully enough to find th=
is
>> >> > issue, that some drivers don't have a RCU-section around the full X=
DP
>> >> > code path in their NAPI-loop.
>> >> >=20
>> >> > Question to Paul.  (I will attempt to describe in generic terms what
>> >> > happens, but ref real-function names).
>> >> >=20
>> >> > We are running in softirq/NAPI context, the driver will call a
>> >> > bq_enqueue() function for every packet (if calling xdp_do_redirect)=
 ,
>> >> > some driver wrap this with a rcu_read_lock/unlock() section (other =
have
>> >> > a large RCU-read section, that include the flush operation).
>> >> >=20
>> >> > In the bq_enqueue() function we have a per_cpu_ptr (that store the
>> >> > xdp_frame packets) that will get flushed/send in the call
>> >> > xdp_do_flush() (that end-up calling bq_xmit_all()).  This flush will
>> >> > happen before we end our softirq/NAPI context.
>> >> >=20
>> >> > The extension is that the per_cpu_ptr data structure (after this pa=
tch)
>> >> > store a pointer to an xdp_prog (which is a RCU object).  In the flu=
sh
>> >> > operation (which we will wrap with RCU-read section), we will use t=
his
>> >> > xdp_prog pointer.   I can see that it is in-principle wrong to pass
>> >> > this-pointer between RCU-read sections, but I consider this safe as=
 we
>> >> > are running under softirq/NAPI and the per_cpu_ptr is only valid in
>> >> > this short interval.
>> >> >=20
>> >> > I claim a grace/quiescent RCU cannot happen between these two RCU-r=
ead
>> >> > sections, but I might be wrong? (especially in the future or for RT=
).
>> >
>> > If I am reading this correctly (ha!), a very high-level summary of the
>> > code in question is something like this:
>> >
>> > 	void foo(void)
>> > 	{
>> > 		local_bh_disable();
>> >
>> > 		rcu_read_lock();
>> > 		p =3D rcu_dereference(gp);
>> > 		do_something_with(p);
>> > 		rcu_read_unlock();
>> >
>> > 		do_something_else();
>> >
>> > 		rcu_read_lock();
>> > 		do_some_other_thing(p);
>> > 		rcu_read_unlock();
>> >
>> > 		local_bh_enable();
>> > 	}
>> >
>> > 	void bar(struct blat *new_gp)
>> > 	{
>> > 		struct blat *old_gp;
>> >
>> > 		spin_lock(my_lock);
>> > 		old_gp =3D rcu_dereference_protected(gp, lock_held(my_lock));
>> > 		rcu_assign_pointer(gp, new_gp);
>> > 		spin_unlock(my_lock);
>> > 		synchronize_rcu();
>> > 		kfree(old_gp);
>> > 	}
>>=20
>> Yeah, something like that (the object is freed using call_rcu() - but I
>> think that's equivalent, right?). And the question is whether we need to
>> extend foo() so that is has one big rcu_read_lock() that covers the
>> whole lifetime of p.
>
> Yes, use of call_rcu() is an asynchronous version of synchronize_rcu().
> In fact, synchronize_rcu() is implemented in terms of call_rcu().  ;-)

Right, gotcha!

>> > I need to check up on -rt.
>> >
>> > But first... In recent mainline kernels, the local_bh_disable() region
>> > will look like one big RCU read-side critical section.  But don't try
>> > this prior to v4.20!!!  In v4.19 and earlier, you would need to use
>> > both synchronize_rcu() and synchronize_rcu_bh() to make this work, or,
>> > for less latency, synchronize_rcu_mult(call_rcu, call_rcu_bh).
>>=20
>> OK. Variants of this code has been around since before then, but I
>> honestly have no idea what it looked like back then exactly...
>
> I know that feeling...
>
>> > Except that in that case, why not just drop the inner rcu_read_unlock()
>> > and rcu_read_lock() pair?  Awkward function boundaries or some such?
>>=20
>> Well if we can just treat such a local_bh_disable()/enable() pair as the
>> equivalent of rcu_read_lock()/unlock() then I suppose we could just get
>> rid of the inner ones. What about tools like lockdep; do they understand
>> this, or are we likely to get complaints if we remove it?
>
> If you just got rid of the first rcu_read_unlock() and the second
> rcu_read_lock() in the code above, lockdep will understand.

Right, but doing so entails going through all the drivers, which is what
we're trying to avoid :)

> However, if you instead get rid of -all- of the rcu_read_lock() and
> rcu_read_unlock() invocations in the code above, you would need to let
> lockdep know by adding rcu_read_lock_bh_held().  So instead of this:
>
> 	p =3D rcu_dereference(gp);
>
> You would do this:
>
> 	p =3D rcu_dereference_check(gp, rcu_read_lock_bh_held());
>
> This would be needed for mainline, regardless of -rt.

OK. And as far as I can tell this is harmless for code paths that call
the same function but from a regular rcu_read_lock()-protected section
instead from a bh-disabled section, right?

What happens, BTW, if we *don't* get rid of all the existing
rcu_read_lock() sections? Going back to your foo() example above, what
we're discussing is whether to add that second rcu_read_lock() around
do_some_other_thing(p). I.e., the first one around the rcu_dereference()
is already there (in the particular driver we're discussing), and the
local_bh_disable/enable() pair is already there. AFAICT from our
discussion, there really is not much point in adding that second
rcu_read_lock/unlock(), is there?

And because that first rcu_read_lock() around the rcu_dereference() is
already there, lockdep is not likely to complain either, so we're
basically fine? Except that the code is somewhat confusing as-is, of
course; i.e., we should probably fix it but it's not terribly urgent. Or?

Hmm, looking at it now, it seems not all the lookup code is actually
doing rcu_dereference() at all, but rather just a plain READ_ONCE() with
a comment above it saying that RCU ensures objects won't disappear[0];
so I suppose we're at least safe from lockdep in that sense :P - but we
should definitely clean this up.

[0] Exhibit A: https://elixir.bootlin.com/linux/latest/source/kernel/bpf/de=
vmap.c#L391

>> > Especially given that if this works on -rt, it is probably because
>> > their variant of do_softirq() holds rcu_read_lock() across each
>> > softirq handler invocation. They do something similar for rwlocks.
>>=20
>> Right. Guess we'll wait for your confirmation of that, then. Thanks! :)
>
> Looking at v5.11.4-rt11...
>
> And __local_bh_disable_ip() has added the required rcu_read_lock(),
> so dropping all the rcu_read_lock() and rcu_read_unlock() calls would
> do the right thing in -rt.  And lockdep would understand without the
> rcu_read_lock_bh_held(), but that is still required for mainline.

Great, thanks for checking!

So this brings to mind another question: Are there any performance
implications to nesting rcu_read_locks() inside each other? One
thing that would be fairly easy to do (in terms of how much code we have
to touch) is to just add a top-level rcu_read_lock() around the
napi_poll() call in the core dev code, thus making -rt and mainline
equivalent in that respect. Also, this would make it obvious that all
the RCU usage inside of NAPI is safe, without having to know about
bh_disable() and all that. But we obviously don't want to do that if it
is going to slow things down; WDYT?

-Toke

