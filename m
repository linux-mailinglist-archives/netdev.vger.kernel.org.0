Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E876306092
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343907AbhA0QHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:07:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343618AbhA0QGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611763509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymgthTUCmjUlFjWwxIOhiUdaaEE7IEt5beNZN3TBBUk=;
        b=BzOCWEa7Hzj5lbgpA9R5IDAJNIJ1Hcl/5wgvLj95c+K3uzcGShm1DQ4RRVZnnvur76ltYv
        7JjQEqjq4bZxpPxn8IQKvq4xVhHSZa3sLrB5MnKM2g4fM0C1LkMVoyYsuknAQUoNjSE3oQ
        QuflkjpOKAW4+Ktvk6/F6Zv395rcPjk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-2RuPsSnHPz6sKvJILBBolA-1; Wed, 27 Jan 2021 11:05:08 -0500
X-MC-Unique: 2RuPsSnHPz6sKvJILBBolA-1
Received: by mail-ej1-f70.google.com with SMTP id md20so866917ejb.7
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ymgthTUCmjUlFjWwxIOhiUdaaEE7IEt5beNZN3TBBUk=;
        b=Ou1nTtje+Z9m90SjAOe+8aeQWGRDxeDKv5UfoqOHnuCxW4XChZZCym8iIddVbLWfv3
         fXNK3yUVBs1owF2buwl7kw2AwhcbLkynmaEzQ7c4E6TkgVOvpbLOXcO6CJSJJcAd8RyO
         RQhBVSRwmUsNFNZkSLbfGzihPzhsx5Y/LY1MQlBfci5Hsn6agQ1yAlTto2MeQJs2JCnS
         eq81XSbpI4X5iw3GS6fHt16uJmT0lQGDlxZlI1GmHb2xYDDdlYXRYenW+dtTIV55UMg/
         pTw0C9Y6jzTTb4Z1LJEGRGgYs+HFBfrmPydY4eywZaGx+gkEST2X4pew35e2F4VAZoIk
         LsOA==
X-Gm-Message-State: AOAM530I8z2uAojyLWcoSonL5s4U6t6gBmcO5PbpM8sDSqTMFrFhlI2Q
        AeMkoxbuaJ8+tTwPolNI17E4VtdhdIs+T5IbnDMKgF+b2DRllAWlB8KyiGqTDF2V+UhErvOdptf
        SWMQFd5kjSyCBSlzK
X-Received: by 2002:a17:907:20aa:: with SMTP id pw10mr7243350ejb.314.1611763506865;
        Wed, 27 Jan 2021 08:05:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4WA9iN+PNDapSxs8K8VV9E/BR+D7Ls8wf5HctHLa1BWsn9NBEFGhrvvLaM3fIAsnd/gqAYw==
X-Received: by 2002:a17:907:20aa:: with SMTP id pw10mr7243321ejb.314.1611763506559;
        Wed, 27 Jan 2021 08:05:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id pw28sm1021929ejb.115.2021.01.27.08.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:05:06 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 96D52180349; Wed, 27 Jan 2021 17:05:05 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
In-Reply-To: <60118c586000d_9913c208c2@john-XPS-13-9370.notmuch>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-2-liuhangbin@gmail.com>
 <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
 <87lfcesomf.fsf@toke.dk> <20210127122050.GA41732@ranger.igk.intel.com>
 <20210127160029.73f22659@carbon>
 <60118c586000d_9913c208c2@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 Jan 2021 17:05:05 +0100
Message-ID: <87wnvy4b7y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Jesper Dangaard Brouer wrote:
>> On Wed, 27 Jan 2021 13:20:50 +0100
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
>>=20
>> > On Wed, Jan 27, 2021 at 10:41:44AM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> > > John Fastabend <john.fastabend@gmail.com> writes:
>> > >=20=20=20
>> > > > Hangbin Liu wrote:=20=20
>> > > >> From: Jesper Dangaard Brouer <brouer@redhat.com>
>> > > >>=20
>> > > >> This changes the devmap XDP program support to run the program wh=
en the
>> > > >> bulk queue is flushed instead of before the frame is enqueued. Th=
is has
>> > > >> a couple of benefits:
>> > > >>=20
>> > > >> - It "sorts" the packets by destination devmap entry, and then ru=
ns the
>> > > >>   same BPF program on all the packets in sequence. This ensures t=
hat we
>> > > >>   keep the XDP program and destination device properties hot in I=
-cache.
>> > > >>=20
>> > > >> - It makes the multicast implementation simpler because it can ju=
st
>> > > >>   enqueue packets using bq_enqueue() without having to deal with =
the
>> > > >>   devmap program at all.
>> > > >>=20
>> > > >> The drawback is that if the devmap program drops the packet, the =
enqueue
>> > > >> step is redundant. However, arguably this is mostly visible in a
>> > > >> micro-benchmark, and with more mixed traffic the I-cache benefit =
should
>> > > >> win out. The performance impact of just this patch is as follows:
>> > > >>=20
>> > > >> The bq_xmit_all's logic is also refactored and error label is rem=
oved.
>> > > >> When bq_xmit_all() is called from bq_enqueue(), another packet wi=
ll
>> > > >> always be enqueued immediately after, so clearing dev_rx, xdp_pro=
g and
>> > > >> flush_node in bq_xmit_all() is redundant. Let's move the clear to
>> > > >> __dev_flush(), and only check them once in bq_enqueue() since the=
y are
>> > > >> all modified together.
>> > > >>=20
>> > > >> By using xdp_redirect_map in sample/bpf and send pkts via pktgen =
cmd:
>> > > >> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst=
_mac -t 10 -s 64
>> > > >>=20
>> > > >> There are about +/- 0.1M deviation for native testing, the perfor=
mance
>> > > >> improved for the base-case, but some drop back with xdp devmap pr=
og attached.
>> > > >>=20
>> > > >> Version          | Test                           | Generic | Nat=
ive | Native + 2nd xdp_prog
>> > > >> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9=
.1M |  8.0M
>> > > >> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11=
.0M |  9.7M
>> > > >> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9=
.5M |  7.5M
>> > > >> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11=
.6M |  9.1M
>> > > >>=20=20=20
>> > > >
>> > > > [...]
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
>> > > >>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>> > > >>  {
>> > > >>  	struct net_device *dev =3D bq->dev;
>> > > >> -	int sent =3D 0, drops =3D 0, err =3D 0;
>> > > >> +	unsigned int cnt =3D bq->count;
>> > > >> +	int drops =3D 0, err =3D 0;
>> > > >> +	int to_send =3D cnt;
>> > > >> +	int sent =3D cnt;
>> > > >>  	int i;
>> > > >>=20=20
>> > > >> -	if (unlikely(!bq->count))
>> > > >> +	if (unlikely(!cnt))
>> > > >>  		return;
>> > > >>=20=20
>> > > >> -	for (i =3D 0; i < bq->count; i++) {
>> > > >> +	for (i =3D 0; i < cnt; i++) {
>> > > >>  		struct xdp_frame *xdpf =3D bq->q[i];
>> > > >>=20=20
>> > > >>  		prefetch(xdpf);
>> > > >>  	}
>> > > >>=20=20
>> > > >> -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, f=
lags);
>> > > >> +	if (bq->xdp_prog) {
>> > > >> +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev=
);
>> > > >> +		if (!to_send) {
>> > > >> +			sent =3D 0;
>> > > >> +			goto out;
>> > > >> +		}
>> > > >> +		drops =3D cnt - to_send;
>> > > >> +	}=20=20
>> > > >
>> > > > I might be missing something about how *bq works here. What happen=
s when
>> > > > dev_map_bpf_prog_run returns to_send < cnt?
>> > > >
>> > > > So I read this as it will send [0, to_send] and [to_send, cnt] wil=
l be
>> > > > dropped? How do we know the bpf prog would have dropped the set,
>> > > > [to_send+1, cnt]?=20=20
>> >=20
>> > You know that via recalculation of 'drops' value after you returned fr=
om
>> > dev_map_bpf_prog_run() which later on is provided onto trace_xdp_devma=
p_xmit.
>> >=20
>> > >=20
>> > > Because dev_map_bpf_prog_run() compacts the array:
>> > >=20
>> > > +		case XDP_PASS:
>> > > +			err =3D xdp_update_frame_from_buff(&xdp, xdpf);
>> > > +			if (unlikely(err < 0))
>> > > +				xdp_return_frame_rx_napi(xdpf);
>> > > +			else
>> > > +				frames[nframes++] =3D xdpf;
>> > > +			break;=20=20
>> >=20
>> > To expand this a little, 'frames' array is reused and 'nframes' above =
is
>> > the value that is returned and we store it onto 'to_send' variable.
>> >=20
>
> In the morning with coffee looks good to me. Thanks Toke, Jesper.

Haha, yeah, coffee does tend to help, doesn't it? You're welcome :)

-Toke

