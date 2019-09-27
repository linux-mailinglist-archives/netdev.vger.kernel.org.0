Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A227C0D40
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfI0V2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 17:28:48 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54041 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbfI0V2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 17:28:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9A37A22AA;
        Fri, 27 Sep 2019 17:28:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Sep 2019 17:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm1; bh=tEytGYjqRKPYg5eCE7y6nPooC
        bRk5cnOY2TTMlrG3W4=; b=kGHYCLSdj89XY6LTRlLeSXv7el6WQ20uWccauT87V
        E2LZF1nMANPIZHGZohZb0cPcH6+JyOf4EkrfI2bnHTNK7mZq8G27nRwArvGi6jNJ
        f27GAXCO3B/m7NTMXyq/9xCSs20CpkxwqWPm41sQWVDcPIswBqwvCEbuoiYYKj9n
        HsutJ9EreQAdn0cPxldwvttj4F8RQev+IHxWLRx67SsWwLoxCO+YgQ+nShfi8MS8
        9vogDptJ61ADsFQ0dsdPiwDQ3DpGstER6db494cWO8dATsHH68lDBkqEsdbVIhOP
        7+Ed5E0V1FJ6Kncxf1Fc6YtDEcvFRMsSXZ6nSI9zpOzdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tEytGY
        jqRKPYg5eCE7y6nPooCbRk5cnOY2TTMlrG3W4=; b=TRJ5v6i8Anowb1mb/c/xe5
        aER9VH2QCbEL000vUJiyD6UAYRyZlBwp6HfqWuJB4JDKzCx+l6WiXAke/qIApb6s
        lwuNb3Unk6c9P417zwyy66NdKXxUq6dnIPOVgLtdc4P7e+pzywk/9keUns/IQ9hu
        KHmXtGMCMx++/F/mCc3W+fTg7cUeFxQ4pl0tKtdNtgTMSKXhSFEQUkCiilThZpZ7
        c1UPBbc0uWxncZymjE3X3QpAqQBGfWf8LJ2zPQek4es4HtOiOKxTLYo0bvwhFaTd
        29zcfEPbth8UeRh3RcgU0PgVoEvkmyI+FPq4YEmMcNPhdsiviy8eHBUGAgjqAmqA
        ==
X-ME-Sender: <xms:DX-OXf-I8FOKU-EM_IZiZaMH_6_8XfysQ23kziqjZj__X9eSPhxSFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeeigdduheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdljedtmdenucfjughrpefgtggjfffuhffvkfesthhqredttddtjeen
    ucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihusegugihuuhhurdighiiiqeenuc
    fkphepudelledrvddtuddrieegrddvnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihu
    segugihuuhhurdighiiinecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DX-OXQlGZcIaZyDrqLo631BF5AeBeYwvCQmD_G0z4o8InUDWiVJVrQ>
    <xmx:DX-OXVkwo1OLucWU4_-JfdhgXudIt6BOj_bfagWDR8Na9nf_UvtzwA>
    <xmx:DX-OXcva-tU3uG8rUivTJtbuLawLcP6XBN7R-WvDOlwd3rxjbZTXcw>
    <xmx:Dn-OXXifHPLswMp9N9jbLEfGNsKtvLR0JPXCnpWGgitoEhWjZv23ug>
Received: from localhost (unknown [199.201.64.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10B9ED6005B;
        Fri, 27 Sep 2019 17:28:43 -0400 (EDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20190924083342.GA21640@krava>
Date:   Fri, 27 Sep 2019 14:28:43 -0700
Cc:     <bpf@vger.kernel.org>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <peterz@infradead.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <ast@fb.com>,
        <alexander.shishkin@linux.intel.com>, <namhyung@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/5] perf/core: Add PERF_FORMAT_LOST
 read_format
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Jiri Olsa" <jolsa@redhat.com>
Message-Id: <BXB3R6AZT2LR.2DHP9YCMGCTYJ@dlxu-fedora-R90QNFJV>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Tue Sep 24, 2019 at 10:33 AM Jiri Olsa wrote:
> On Tue, Sep 17, 2019 at 06:30:52AM -0700, Daniel Xu wrote:
>=20
> SNIP
>=20
> > +	PERF_FORMAT_MAX =3D 1U << 5,		/* non-ABI */
> >  };
> > =20
> >  #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 0463c1151bae..ee08d3ed6299 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -1715,6 +1715,9 @@ static void __perf_event_read_size(struct perf_ev=
ent *event, int nr_siblings)
> >  	if (event->attr.read_format & PERF_FORMAT_ID)
> >  		entry +=3D sizeof(u64);
> > =20
> > +	if (event->attr.read_format & PERF_FORMAT_LOST)
> > +		entry +=3D sizeof(u64);
> > +
> >  	if (event->attr.read_format & PERF_FORMAT_GROUP) {
> >  		nr +=3D nr_siblings;
> >  		size +=3D sizeof(u64);
> > @@ -4734,6 +4737,24 @@ u64 perf_event_read_value(struct perf_event *eve=
nt, u64 *enabled, u64 *running)
> >  }
> >  EXPORT_SYMBOL_GPL(perf_event_read_value);
> > =20
> > +static struct pmu perf_kprobe;
> > +static u64 perf_event_lost(struct perf_event *event)
> > +{
> > +	struct ring_buffer *rb;
> > +	u64 lost =3D 0;
> > +
> > +	rcu_read_lock();
> > +	rb =3D rcu_dereference(event->rb);
> > +	if (likely(!!rb))
> > +		lost +=3D local_read(&rb->lost);
> > +	rcu_read_unlock();
> > +
> > +	if (event->attr.type =3D=3D perf_kprobe.type)
> > +		lost +=3D perf_kprobe_missed(event);
>=20
> not sure what was the peterz's suggestion, but here you are mixing
> ring buffer's lost count with kprobes missed count, seems wrong

To be honest, I'm not 100% sure what the correct semantics here should
be. I thought it might be less misleading if we included ring buffer
related misses as well.

Regardless, I am ok with either.

> maybe we could add PERF_FORMAT_KPROBE_MISSED

I think the feedback from the last patchset was that we want to keep
the misses unified.

Peter, do you have any thoughts?

Thanks,
Daniel
