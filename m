Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34F530604B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhA0PzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhA0Pxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:53:47 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5045FC061574;
        Wed, 27 Jan 2021 07:53:07 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id y19so2333001iov.2;
        Wed, 27 Jan 2021 07:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=//wYoBrgSV3+Y7ZtW7mN0X5EZ4X9Xhzqkl+AgunMKHI=;
        b=IOvv4p8NftAs7W4o7D1cjuMYDRdD0JARQiJrXcFW3L4FZw2KlDNPknPZQtNvYuRcEp
         kZgEasKJL5e1rxs7n7CPh/5+q9I+olokOfcg6DDe1AtoXVAPI3LRGa+oUKKsl0kDCL04
         Mc0p5MO7LdRIzdpYs3re7AzdSoYtWxAaYAoRgsmf+risKCAIM1pZnxJI9JnngLMWjpOE
         97+kzU+lX18CyHnzO4TVb4BQvjYSJewW2PJXLOVT33vQesgsD+uLXD2sKY4z28CsAErD
         SCUYUTQQlh1xNHmsOhsruQEb6x9IhymSJNqwLvRzdyf1KA128YtBfx8RpzjXJ5sZw3k7
         ZnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=//wYoBrgSV3+Y7ZtW7mN0X5EZ4X9Xhzqkl+AgunMKHI=;
        b=qO4N0uyMkCdRY8ZYntOw/r7fXcRWZULfBBatXIQt7s7cB8f4WDza9Xe0G6cqWD/We9
         VL3bloW3i16j4yFPFZOfx2X523XIdBw7nXKvD7qc93dZhQFqxIPYAi61Jc7YLdEbj+Aa
         GOcvypoH9Y8veR0TcHQwL2ioj3OlIQehS3ParG2crC/lT8/g6e1Fcihw7n2jXv85YhBp
         M1Epw4D1juKw5wWLjUTkX01DZRuHBbYKutik1nHuxXqCcqu00mdDmCy/10z7qOD45nDc
         3zwdfY7ET9YQZt22b1RgnC95cRGdbZwh7ovN91ur9PX+r66eo1RaSAtRHd28ASheQG5c
         cLWg==
X-Gm-Message-State: AOAM532t9luf7jmy0FW3L573VVma9nVCnSRWJtowM2RaQDiiA/Ha73I9
        UQCFf1mLlBXiXekS2YIRqQY=
X-Google-Smtp-Source: ABdhPJyq2nFIMBUJIALdzI//lQJwHnFT8HLxKRQMYCwWCw236kvk55JHmGk8oVOPJD5MJUUXqFmPZQ==
X-Received: by 2002:a05:6638:d0b:: with SMTP id q11mr9270229jaj.88.1611762786654;
        Wed, 27 Jan 2021 07:53:06 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id h14sm1226885ilh.63.2021.01.27.07.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 07:53:05 -0800 (PST)
Date:   Wed, 27 Jan 2021 07:52:56 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Message-ID: <60118c586000d_9913c208c2@john-XPS-13-9370.notmuch>
In-Reply-To: <20210127160029.73f22659@carbon>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-2-liuhangbin@gmail.com>
 <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
 <87lfcesomf.fsf@toke.dk>
 <20210127122050.GA41732@ranger.igk.intel.com>
 <20210127160029.73f22659@carbon>
Subject: Re: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Wed, 27 Jan 2021 13:20:50 +0100
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> =

> > On Wed, Jan 27, 2021 at 10:41:44AM +0100, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> > > John Fastabend <john.fastabend@gmail.com> writes:
> > >   =

> > > > Hangbin Liu wrote:  =

> > > >> From: Jesper Dangaard Brouer <brouer@redhat.com>
> > > >> =

> > > >> This changes the devmap XDP program support to run the program w=
hen the
> > > >> bulk queue is flushed instead of before the frame is enqueued. T=
his has
> > > >> a couple of benefits:
> > > >> =

> > > >> - It "sorts" the packets by destination devmap entry, and then r=
uns the
> > > >>   same BPF program on all the packets in sequence. This ensures =
that we
> > > >>   keep the XDP program and destination device properties hot in =
I-cache.
> > > >> =

> > > >> - It makes the multicast implementation simpler because it can j=
ust
> > > >>   enqueue packets using bq_enqueue() without having to deal with=
 the
> > > >>   devmap program at all.
> > > >> =

> > > >> The drawback is that if the devmap program drops the packet, the=
 enqueue
> > > >> step is redundant. However, arguably this is mostly visible in a=

> > > >> micro-benchmark, and with more mixed traffic the I-cache benefit=
 should
> > > >> win out. The performance impact of just this patch is as follows=
:
> > > >> =

> > > >> The bq_xmit_all's logic is also refactored and error label is re=
moved.
> > > >> When bq_xmit_all() is called from bq_enqueue(), another packet w=
ill
> > > >> always be enqueued immediately after, so clearing dev_rx, xdp_pr=
og and
> > > >> flush_node in bq_xmit_all() is redundant. Let's move the clear t=
o
> > > >> __dev_flush(), and only check them once in bq_enqueue() since th=
ey are
> > > >> all modified together.
> > > >> =

> > > >> By using xdp_redirect_map in sample/bpf and send pkts via pktgen=
 cmd:
> > > >> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $ds=
t_mac -t 10 -s 64
> > > >> =

> > > >> There are about +/- 0.1M deviation for native testing, the perfo=
rmance
> > > >> improved for the base-case, but some drop back with xdp devmap p=
rog attached.
> > > >> =

> > > >> Version          | Test                           | Generic | Na=
tive | Native + 2nd xdp_prog
> > > >> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   =
9.1M |  8.0M
> > > >> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  1=
1.0M |  9.7M
> > > >> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   =
9.5M |  7.5M
> > > >> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  1=
1.6M |  9.1M
> > > >>   =

> > > >
> > > > [...]

Acked-by: John Fastabend <john.fastabend@gmail.com>

> > > >>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flag=
s)
> > > >>  {
> > > >>  	struct net_device *dev =3D bq->dev;
> > > >> -	int sent =3D 0, drops =3D 0, err =3D 0;
> > > >> +	unsigned int cnt =3D bq->count;
> > > >> +	int drops =3D 0, err =3D 0;
> > > >> +	int to_send =3D cnt;
> > > >> +	int sent =3D cnt;
> > > >>  	int i;
> > > >>  =

> > > >> -	if (unlikely(!bq->count))
> > > >> +	if (unlikely(!cnt))
> > > >>  		return;
> > > >>  =

> > > >> -	for (i =3D 0; i < bq->count; i++) {
> > > >> +	for (i =3D 0; i < cnt; i++) {
> > > >>  		struct xdp_frame *xdpf =3D bq->q[i];
> > > >>  =

> > > >>  		prefetch(xdpf);
> > > >>  	}
> > > >>  =

> > > >> -	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, =
flags);
> > > >> +	if (bq->xdp_prog) {
> > > >> +		to_send =3D dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, de=
v);
> > > >> +		if (!to_send) {
> > > >> +			sent =3D 0;
> > > >> +			goto out;
> > > >> +		}
> > > >> +		drops =3D cnt - to_send;
> > > >> +	}  =

> > > >
> > > > I might be missing something about how *bq works here. What happe=
ns when
> > > > dev_map_bpf_prog_run returns to_send < cnt?
> > > >
> > > > So I read this as it will send [0, to_send] and [to_send, cnt] wi=
ll be
> > > > dropped? How do we know the bpf prog would have dropped the set,
> > > > [to_send+1, cnt]?  =

> > =

> > You know that via recalculation of 'drops' value after you returned f=
rom
> > dev_map_bpf_prog_run() which later on is provided onto trace_xdp_devm=
ap_xmit.
> > =

> > > =

> > > Because dev_map_bpf_prog_run() compacts the array:
> > > =

> > > +		case XDP_PASS:
> > > +			err =3D xdp_update_frame_from_buff(&xdp, xdpf);
> > > +			if (unlikely(err < 0))
> > > +				xdp_return_frame_rx_napi(xdpf);
> > > +			else
> > > +				frames[nframes++] =3D xdpf;
> > > +			break;  =

> > =

> > To expand this a little, 'frames' array is reused and 'nframes' above=
 is
> > the value that is returned and we store it onto 'to_send' variable.
> > =


In the morning with coffee looks good to me. Thanks Toke, Jesper.=
