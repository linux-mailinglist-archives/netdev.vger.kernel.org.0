Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8981F361DC1
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhDPKEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 06:04:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236893AbhDPKEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 06:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618567426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNZ3Jw5dgOM6r+i39VOOxLgO7yM8hGleXoJbsySK2fI=;
        b=TsCtYmWoYjiTft+b119PfiiD4VQ1wUxddMihCM+A+MiwSjXQWsP7fqrNJdFoKJML2fmXt+
        Gn59mQ5L4n9Ei25L7cK2fDUpewRMGyDkZ2xZeZf6/xYJhst/iYoKt6++RGqpGpXtbPQOBN
        kDtnqiD72m1zA7km5dVbY8hvfcl98Kk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439--YHTGhUvPd2lGdX_fClJvA-1; Fri, 16 Apr 2021 06:03:44 -0400
X-MC-Unique: -YHTGhUvPd2lGdX_fClJvA-1
Received: by mail-ej1-f72.google.com with SMTP id c18-20020a17090603d2b029037c77ad778eso1858486eja.1
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 03:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=sNZ3Jw5dgOM6r+i39VOOxLgO7yM8hGleXoJbsySK2fI=;
        b=fVHEiRU3fcMnEhO8gTdhRcbpEwDJI4Ucj4kO9EzfTbw8+keId/EtJXk68ORmcdUmE4
         j3cGynPb5J4ZcAotHI5QRBHymGLSxUKExN3Mil1CvWLlzNwqRHMFjMH1S8q5JK6FvtsF
         msT0NDbeukDlMWZGHC9FtAeG6HX957tS7b5US7XjdBVUFXKxtaf0E8ogzfh6cDnOgg8J
         uE5P/Jehn3WFLIOL4YLbX0lUHpUfDC4reKrXtZh1hw+WDdiOYzSijmsxsq1TQvb7hol4
         Iq04ktsboaZAmkOOw95d+51Hw58N331ckv1899T8HLjodwIlVi3jRfqDY4aHVk+ktt9Y
         AhWw==
X-Gm-Message-State: AOAM530OtHZksvBJt8Y6ztOWEZJhfmhQ2c6mkGF/mrO1r7fizPU71CPo
        AYGJpFHpXZdqtTjUqjeaaXewj6tLnHjbJX8o6yT/KoTGer5JH+03bn9Y7Q9xeBpno9BkekB6JU1
        IdjEn8ihoIcNZZjNg
X-Received: by 2002:a17:906:6bc8:: with SMTP id t8mr7708105ejs.115.1618567423124;
        Fri, 16 Apr 2021 03:03:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIYGikkIaYFUxebkrpDVmlXTE47O2Hmmg7bFgQCQ293Oxdg1fXPCpyve2SwgESot+v9a0sHg==
X-Received: by 2002:a17:906:6bc8:: with SMTP id t8mr7708060ejs.115.1618567422689;
        Fri, 16 Apr 2021 03:03:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m14sm4809621edd.63.2021.04.16.03.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 03:03:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 684861806B2; Fri, 16 Apr 2021 12:03:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
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
In-Reply-To: <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s> <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon> <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 16 Apr 2021 12:03:41 +0200
Message-ID: <877dl2im0y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>=20
>> > On Thu, 15 Apr 2021 10:35:51 -0700
>> > Martin KaFai Lau <kafai@fb.com> wrote:
>> >
>> >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
>> >> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> >> >=20=20=20
>> >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:=
=20=20
>> >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 fl=
ags)
>> >> > >> >  {
>> >> > >> >  	struct net_device *dev =3D bq->dev;
>> >> > >> > -	int sent =3D 0, err =3D 0;
>> >> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
>> >> > >> > +	unsigned int cnt =3D bq->count;
>> >> > >> > +	int to_send =3D cnt;
>> >> > >> >  	int i;
>> >> > >> >=20=20
>> >> > >> > -	if (unlikely(!bq->count))
>> >> > >> > +	if (unlikely(!cnt))
>> >> > >> >  		return;
>> >> > >> >=20=20
>> >> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> >> > >> > +	for (i =3D 0; i < cnt; i++) {
>> >> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> >> > >> >=20=20
>> >> > >> >  		prefetch(xdpf);
>> >> > >> >  	}
>> >> > >> >=20=20
>> >> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q=
, flags);
>> >> > >> > +	if (bq->xdp_prog) {=20=20
>> >> > >> bq->xdp_prog is used here
>> >> > >>=20=20=20
>> >> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, =
dev);
>> >> > >> > +		if (!to_send)
>> >> > >> > +			goto out;
>> >> > >> > +
>> >> > >> > +		drops =3D cnt - to_send;
>> >> > >> > +	}
>> >> > >> > +=20=20
>> >> > >>=20
>> >> > >> [ ... ]
>> >> > >>=20=20=20
>> >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_fra=
me *xdpf,
>> >> > >> > -		       struct net_device *dev_rx)
>> >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
>> >> > >> >  {
>> >> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_lis=
t);
>> >> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bulk=
q);
>> >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device=
 *dev, struct xdp_frame *xdpf,
>> >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
>> >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
>> >> > >> >  	 * from net_device drivers NAPI func end.
>> >> > >> > +	 *
>> >> > >> > +	 * Do the same with xdp_prog and flush_list since these fiel=
ds
>> >> > >> > +	 * are only ever modified together.
>> >> > >> >  	 */
>> >> > >> > -	if (!bq->dev_rx)
>> >> > >> > +	if (!bq->dev_rx) {
>> >> > >> >  		bq->dev_rx =3D dev_rx;
>> >> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20
>> >> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit=
_all().
>> >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_l=
ock()?
>> >> > >> It is not very obvious after taking a quick look at xdp_do_flush=
[_map].
>> >> > >>=20
>> >> > >> e.g. what if the devmap elem gets deleted.=20=20
>> >> > >
>> >> > > Jesper knows better than me. From my veiw, based on the descripti=
on of
>> >> > > __dev_flush():
>> >> > >
>> >> > > On devmap tear down we ensure the flush list is empty before comp=
leting to
>> >> > > ensure all flush operations have completed. When drivers update t=
he bpf
>> >> > > program they may need to ensure any flush ops are also complete.=
=20=20
>> >>
>> >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's e=
lem.
>> >>=20
>> >> >=20
>> >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll lo=
op,
>> >> > which also runs under one big rcu_read_lock(). So the storage in the
>> >> > bulk queue is quite temporary, it's just used for bulking to increa=
se
>> >> > performance :)=20=20
>> >>
>> >> I am missing the one big rcu_read_lock() part.  For example, in i40e_=
txrx.c,
>> >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog use=
d to run
>> >> in i40e_run_xdp() and it is fine.
>> >>=20
>> >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where t=
he
>> >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_ma=
p().
>> >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
>> >>
>> >> I do see the big rcu_read_lock() in mlx5e_napi_poll().
>> >
>> > I believed/assumed xdp_do_flush_map() was already protected under an
>> > rcu_read_lock.  As the devmap and cpumap, which get called via
>> > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
>> > are operating on.
> What other rcu objects it is using during flush?

The bq_enqueue() function in cpumap.c puts the 'bq' pointer onto the
flush_list, and 'bq' lives inside struct bpf_cpu_map_entry, so that's a
reference to the map entry as well.

The devmap function used to work the same way, until we changed it in
75ccae62cb8d ("xdp: Move devmap bulk queue into struct net_device").

>> > Perhaps it is a bug in i40e?
> A quick look into ixgbe falls into the same bucket.
> didn't look at other drivers though.
>
>> >
>> > We are running in softirq in NAPI context, when xdp_do_flush_map() is
>> > call, which I think means that this CPU will not go-through a RCU grace
>> > period before we exit softirq, so in-practice it should be safe.
>>=20
>> Yup, this seems to be correct: rcu_softirq_qs() is only called between
>> full invocations of the softirq handler, which for networking is
>> net_rx_action(), and so translates into full NAPI poll cycles.
>
> I don't know enough to comment on the rcu/softirq part, may be someone
> can chime in.  There is also a recent napi_threaded_poll().
>
> If it is the case, then some of the existing rcu_read_lock() is unnecessa=
ry?
> At least, it sounds incorrect to only make an exception here while keeping
> other rcu_read_lock() as-is.

I'd tend to agree that the correct thing to do is to fix any affected
drivers so there's a wide rcu_read_lock() around the full xdp+flush. If
nothing else, this serves as an annotation for the expected lifetime of
the objects involved.

However, given that this is not a new issue, I don't think it should be
holding up this patch series... We can start a new conversation on what
the right way to fix this is - and maybe bring in Paul for advice on the
RCU side? WDYT?

-Toke

