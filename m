Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD5F361380
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbhDOUaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:30:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235063AbhDOUaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618518586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlYo0mHiTApeShLKAbr8fAEDx74PZ+QpvdaREwQDtrk=;
        b=CH3lbtSBi1cz1wbwMgHkNPfadfDZL35NtAzAvWqeXEvlCNXEX0tVZkRJasSdjUWtts5xyX
        x6yTyNw06vSiGX/ioD2YfHxiAX0822BbbYxb9OzKxk9Ty8px4ZXyxBX0kBiVwVo5IbeSso
        LyleScBzIJ9pwEPU0ZN2fR2wBWs0Imk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-TC003sVPNwOF-lFyPsdqeA-1; Thu, 15 Apr 2021 16:29:43 -0400
X-MC-Unique: TC003sVPNwOF-lFyPsdqeA-1
Received: by mail-ed1-f72.google.com with SMTP id t11-20020aa7d4cb0000b0290382e868be07so5785371edr.20
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 13:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JlYo0mHiTApeShLKAbr8fAEDx74PZ+QpvdaREwQDtrk=;
        b=EYGLVCuas4x6vyD6Kd6Sk17St7tX2nzJ1nFfmR+IVZu3QtWSmjmL9wMzlWoKhNQx7a
         Pr6lKu9RvRlcQ0n/5pvuh/PrcweBBUZzysW3tlc1Up6ZKhNuk3oB3VRyPh7A78AgN7+S
         92LobDJEsy1/OjwU+mnY6m4t0rEAS3/Q2okoZE4CJnoHqF3tILSxAWN+T/hBrixPzeS0
         GMFiWeDBb18qGaStZQ7Yz2oTppbKTJ468ZG9LUMTesyaFxmuqpdVJx0hAqfrrocXC9RB
         nLJ/A97QkYy2x9CWOG9QTQO6EAwLG1uqx536nzGbd6jIVPfeqEDef492N6QZkCVGyTp/
         UTWg==
X-Gm-Message-State: AOAM530XXSBX3B9C8ebdxEGt1h9eZlm0xfcaB7jJgWpiyesTf7t7DjkX
        ufBlhLv+hMLk2ucZR35ASBDEe6Saol4vNrK3IJra26Gv9OB0EQ7B6B/wfifiRWgrCbMUmexAuE1
        Swpd4lr5dldMwNnaY
X-Received: by 2002:a05:6402:204e:: with SMTP id bc14mr6424891edb.312.1618518582556;
        Thu, 15 Apr 2021 13:29:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpLRNkBY35mNG6dFuOEA/IWpdiFD6aNcL5O5Q30Po2mb7nZ7R6REMXD+sDmr1uej77vgafug==
X-Received: by 2002:a05:6402:204e:: with SMTP id bc14mr6424871edb.312.1618518582382;
        Thu, 15 Apr 2021 13:29:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g22sm2656233ejm.69.2021.04.15.13.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 13:29:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D97411806B3; Thu, 15 Apr 2021 22:29:40 +0200 (CEST)
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
        <bjorn.topel@gmail.com>, brouer@redhat.com
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <20210415202132.7b5e8d0d@carbon>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s> <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Apr 2021 22:29:40 +0200
Message-ID: <87k0p3i957.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 15 Apr 2021 10:35:51 -0700
> Martin KaFai Lau <kafai@fb.com> wrote:
>
>> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> > Hangbin Liu <liuhangbin@gmail.com> writes:
>> >=20=20=20
>> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:=20=
=20
>> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>> > >> >  {
>> > >> >  	struct net_device *dev =3D bq->dev;
>> > >> > -	int sent =3D 0, err =3D 0;
>> > >> > +	int sent =3D 0, drops =3D 0, err =3D 0;
>> > >> > +	unsigned int cnt =3D bq->count;
>> > >> > +	int to_send =3D cnt;
>> > >> >  	int i;
>> > >> >=20=20
>> > >> > -	if (unlikely(!bq->count))
>> > >> > +	if (unlikely(!cnt))
>> > >> >  		return;
>> > >> >=20=20
>> > >> > -	for (i =3D 0; i < bq->count; i++) {
>> > >> > +	for (i =3D 0; i < cnt; i++) {
>> > >> >  		struct xdp_frame *xdpf =3D bq->q[i];
>> > >> >=20=20
>> > >> >  		prefetch(xdpf);
>> > >> >  	}
>> > >> >=20=20
>> > >> > -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, f=
lags);
>> > >> > +	if (bq->xdp_prog) {=20=20
>> > >> bq->xdp_prog is used here
>> > >>=20=20=20
>> > >> > +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev=
);
>> > >> > +		if (!to_send)
>> > >> > +			goto out;
>> > >> > +
>> > >> > +		drops =3D cnt - to_send;
>> > >> > +	}
>> > >> > +=20=20
>> > >>=20
>> > >> [ ... ]
>> > >>=20=20=20
>> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame =
*xdpf,
>> > >> > -		       struct net_device *dev_rx)
>> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
>> > >> >  {
>> > >> >  	struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_list);
>> > >> >  	struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bulkq);
>> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *d=
ev, struct xdp_frame *xdpf,
>> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
>> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
>> > >> >  	 * from net_device drivers NAPI func end.
>> > >> > +	 *
>> > >> > +	 * Do the same with xdp_prog and flush_list since these fields
>> > >> > +	 * are only ever modified together.
>> > >> >  	 */
>> > >> > -	if (!bq->dev_rx)
>> > >> > +	if (!bq->dev_rx) {
>> > >> >  		bq->dev_rx =3D dev_rx;
>> > >> > +		bq->xdp_prog =3D xdp_prog;=20=20
>> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit_al=
l().
>> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock=
()?
>> > >> It is not very obvious after taking a quick look at xdp_do_flush[_m=
ap].
>> > >>=20
>> > >> e.g. what if the devmap elem gets deleted.=20=20
>> > >
>> > > Jesper knows better than me. From my veiw, based on the description =
of
>> > > __dev_flush():
>> > >
>> > > On devmap tear down we ensure the flush list is empty before complet=
ing to
>> > > ensure all flush operations have completed. When drivers update the =
bpf
>> > > program they may need to ensure any flush ops are also complete.=20=
=20
>>
>> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.
>>=20
>> >=20
>> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
>> > which also runs under one big rcu_read_lock(). So the storage in the
>> > bulk queue is quite temporary, it's just used for bulking to increase
>> > performance :)=20=20
>>
>> I am missing the one big rcu_read_lock() part.  For example, in i40e_txr=
x.c,
>> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used t=
o run
>> in i40e_run_xdp() and it is fine.
>>=20
>> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
>> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
>> or I missed the big rcu_read_lock() in i40e_napi_poll()?
>>
>> I do see the big rcu_read_lock() in mlx5e_napi_poll().
>
> I believed/assumed xdp_do_flush_map() was already protected under an
> rcu_read_lock.  As the devmap and cpumap, which get called via
> __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
> are operating on.
>
> Perhaps it is a bug in i40e?
>
> We are running in softirq in NAPI context, when xdp_do_flush_map() is
> call, which I think means that this CPU will not go-through a RCU grace
> period before we exit softirq, so in-practice it should be safe.

Yup, this seems to be correct: rcu_softirq_qs() is only called between
full invocations of the softirq handler, which for networking is
net_rx_action(), and so translates into full NAPI poll cycles.

-Toke

