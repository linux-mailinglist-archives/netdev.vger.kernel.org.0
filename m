Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271F546F442
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhLITxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23365 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229754AbhLITxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639079386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1VlNw/KZlHl5E8RLFnAf0s51nE1tAmTafxcQLW1VBY=;
        b=YBAVDr4erUi5kaAlVRvZbWnXM7cW++10Fa8HwJROtWCLdz0qsK9J5PpM+UUf4wgks9OyRS
        joHtecJ+2kALlv0hDkmD8rY/aes1GERnhEsbB0jZZQljcDbMtkCClgJQ0SAtxN/JIH6RiA
        L84Cl+avwzVHJHunEAp+8FsiXj76BR8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-qykO5r0JNFWBcsqB7u6jQg-1; Thu, 09 Dec 2021 14:49:45 -0500
X-MC-Unique: qykO5r0JNFWBcsqB7u6jQg-1
Received: by mail-ed1-f71.google.com with SMTP id n11-20020aa7c68b000000b003e7d68e9874so6200939edq.8
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 11:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=z1VlNw/KZlHl5E8RLFnAf0s51nE1tAmTafxcQLW1VBY=;
        b=8HdVmkQTgwL6q4PIzIrYv0cgIBgbHjCce5YyzOMLXMa3XEkacv/f4sMuGbZ8HnXKJK
         ZTH9g61bSmn+ZZF07Epa6oVclfAIhyHoUm4Wabta9JPtewN7TwJDGy5eOjt3EHX1GC0O
         vOI4Nbpy8WKjaIkwyvMJXpCVAF6oC+XpYXrq78msYcpy40YD53jcwxTb54EE5s4aEeP8
         BpgZLk+hhqZfSNm7avtvkC7PqjO6DmdubuQ7VjmBt04sK3F6O08i/6WgztRUez8LYAUK
         mf/4GTdkO3xMp1Q4XagDgCLQmAml1HrWEGs1bVG0+kqXEehJPhe7fJmDyXOMwvMaQJa1
         sKJQ==
X-Gm-Message-State: AOAM533BXtq0/wWCDXXPBq+/tW1kZ9avZxeP4Q5EJmseRWXfl3bZmg6t
        0bMTXmSLyfJxcwShc+5dXZ9oHwXCHqQUobDrCm3tIVNmx/0nJIW4c293nct8tZI19m+xtBaVQbI
        e951lRWGICWK9K5kn
X-Received: by 2002:a17:907:e86:: with SMTP id ho6mr17437473ejc.197.1639079383356;
        Thu, 09 Dec 2021 11:49:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyW9lMHqrOui27+mqNoup+jhzcEFsbMl9m+0Hq7Z6njxiI6S08BVr3PHdYZQcanRf2lUOd0rQ==
X-Received: by 2002:a17:907:e86:: with SMTP id ho6mr17437354ejc.197.1639079382308;
        Thu, 09 Dec 2021 11:49:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e1sm360118edc.27.2021.12.09.11.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 11:49:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 22BBF180471; Thu,  9 Dec 2021 20:49:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: RE: [PATCH bpf-next 6/8] bpf: Add XDP_REDIRECT support to XDP for
 bpf_prog_run()
In-Reply-To: <61b25147bc136_6bfb208c5@john.notmuch>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-7-toke@redhat.com>
 <61b1537634e07_979572086f@john.notmuch> <87tufhwygr.fsf@toke.dk>
 <87r1alwwk4.fsf@toke.dk> <61b25147bc136_6bfb208c5@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Dec 2021 20:49:40 +0100
Message-ID: <87o85pwobv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>>=20
>> > John Fastabend <john.fastabend@gmail.com> writes:
>> >
>> >> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >>> This adds support for doing real redirects when an XDP program retur=
ns
>> >>> XDP_REDIRECT in bpf_prog_run(). To achieve this, we create a page po=
ol
>> >>> instance while setting up the test run, and feed pages from that int=
o the
>> >>> XDP program. The setup cost of this is amortised over the number of
>> >>> repetitions specified by userspace.
>> >>>=20
>> >>> To support performance testing use case, we further optimise the set=
up step
>> >>> so that all pages in the pool are pre-initialised with the packet da=
ta, and
>> >>> pre-computed context and xdp_frame objects stored at the start of ea=
ch
>> >>> page. This makes it possible to entirely avoid touching the page con=
tent on
>> >>> each XDP program invocation, and enables sending up to 11.5 Mpps/cor=
e on my
>> >>> test box.
>> >>>=20
>> >>> Because the data pages are recycled by the page pool, and the test r=
unner
>> >>> doesn't re-initialise them for each run, subsequent invocations of t=
he XDP
>> >>> program will see the packet data in the state it was after the last =
time it
>> >>> ran on that particular page. This means that an XDP program that mod=
ifies
>> >>> the packet before redirecting it has to be careful about which assum=
ptions
>> >>> it makes about the packet content, but that is only an issue for the=
 most
>> >>> naively written programs.
>> >>>=20
>> >>> Previous uses of bpf_prog_run() for XDP returned the modified packet=
 data
>> >>> and return code to userspace, which is a different semantic then thi=
s new
>> >>> redirect mode. For this reason, the caller has to set the new
>> >>> BPF_F_TEST_XDP_DO_REDIRECT flag when calling bpf_prog_run() to opt i=
n to
>> >>> the different semantics. Enabling this flag is only allowed if not s=
etting
>> >>> ctx_out and data_out in the test specification, since it means frame=
s will
>> >>> be redirected somewhere else, so they can't be returned.
>> >>>=20
>> >>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>> ---
>> >>
>> >> [...]
>> >>
>> >>> +static int bpf_test_run_xdp_redirect(struct bpf_test_timer *t,
>> >>> +				     struct bpf_prog *prog, struct xdp_buff *orig_ctx)
>> >>> +{
>> >>> +	void *data, *data_end, *data_meta;
>> >>> +	struct xdp_frame *frm;
>> >>> +	struct xdp_buff *ctx;
>> >>> +	struct page *page;
>> >>> +	int ret, err =3D 0;
>> >>> +
>> >>> +	page =3D page_pool_dev_alloc_pages(t->xdp.pp);
>> >>> +	if (!page)
>> >>> +		return -ENOMEM;
>> >>> +
>> >>> +	ctx =3D ctx_from_page(page);
>> >>> +	data =3D ctx->data;
>> >>> +	data_meta =3D ctx->data_meta;
>> >>> +	data_end =3D ctx->data_end;
>> >>> +
>> >>> +	ret =3D bpf_prog_run_xdp(prog, ctx);
>> >>> +	if (ret =3D=3D XDP_REDIRECT) {
>> >>> +		frm =3D (struct xdp_frame *)(ctx + 1);
>> >>> +		/* if program changed pkt bounds we need to update the xdp_frame =
*/
>> >>
>> >> Because this reuses the frame repeatedly is there any issue with also
>> >> updating the ctx each time? Perhaps if the prog keeps shrinking
>> >> the pkt it might wind up with 0 len pkt? Just wanted to ask.
>> >
>> > Sure, it could. But the data buffer comes from userspace anyway, and
>> > there's nothing preventing userspace from passing a 0-length packet
>> > anyway, so I just mentally put this in the "don't do that, then" bucke=
t :)
>> >
>> > At least I don't *think* there's actually any problem with this that we
>> > don't have already? A regular XDP program can also shrink an incoming
>> > packet to zero, then redirect it, no?
>>=20
>> Another thought is that we could of course do the opposite here: instead
>> of updating the xdp_frame when the program resizes the packet, just
>> reset the pointers so that the next invocation will get the original
>> size again? The data would still be changed, but maybe that behaviour is
>> less surprising? WDYT?
>
> Should read my email from newest to oldest :)
>
> I think resetting it back to the original size is less surprising. And
> if I want to benchmark a helper that moves the pointers it will be
> easier. For example benchmarking shrinking a packet with current
> code wouldn't really work because eventually the packet will be 0
> and my test will stop doing what I expect.

Ah yes, good point!

> Lets do the reset back to original size.

Alright, will do; thanks! :)

-Toke

