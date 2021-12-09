Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39A046F371
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhLIS4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 13:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhLIS4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 13:56:50 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6868BC061746;
        Thu,  9 Dec 2021 10:53:16 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id c3so7777501iob.6;
        Thu, 09 Dec 2021 10:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2ddkTnhb6eh7PkQ3B0ABtgAtOMdKg/93O10NZ/9JAKg=;
        b=VP8lyLZj8Zx9dxjwgfbWss3NcWEgRuyumKN6X/LWexcKTZtDkCF3UTWa84XukKfJAT
         fDOrOQYCxu4gxk522FYRA9jTQkwD/XZ9sg4j7/EJ8XEgi0XHIv1mtS+1WXdZQfW/2GA1
         wRaHsAZql7L9kjevAIonAradwNceXTeskXtUt6lFPPAqTc0mazzvr25j7SmgjQT/dKUJ
         UU1T2Cfi8Ju3XF3uSm328AGdA8L/wDhwcXg97xsF0yxnp4Ef7Y4733a1Fo5T4l0qc3WH
         vP0SDEMFSKfU7Q8rPHpjJQBgQ68ISdV3Gf90FaKBUtsF2OcLg29l6y5nPF6DxEhJLgsH
         lJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2ddkTnhb6eh7PkQ3B0ABtgAtOMdKg/93O10NZ/9JAKg=;
        b=NkTkNZ4h5+uZb0ybDncwX0MPuQjh3YAfKpT6qkhtU8rksvwrot1lYaWzRvjr4anP9j
         xclEEVR1TXdZQaMkN20ZZvIlhaoWRYOiBefDOcJulI+ljC7WK/YevLu1lUSBjKeBt6O6
         Xo3wWTIbsVDVdu9dNyHyBJpWykMXJ9ClMdea3HjrS87tEdNGSHFchE0cFCdLuUx5PwyC
         Gciy1CNcDA6ocxbbQTTl4skypwU7dNU4FbM6ho7iPmGatkxW5i11YvJt8pB3YgK3EbXd
         xid1B4C20UpvtChm1YCmWyPP7509DARVZfp6wUY2jLO+ar8Ai74m6jBEkl3oUbJDLSai
         Uc4w==
X-Gm-Message-State: AOAM530UMYWG0Ng7paxA3jtY+F0QfcFZ0YTkt/1ItKIyo8fmIGdcC8Vl
        5X9bl7v0YM0JuCodw0WPVIS8B9orQkxmEA==
X-Google-Smtp-Source: ABdhPJwBPLY46LJbWmU69rhM/76NuPGLZAIcoFsOIMtJRIYbObx4fmNrXtJjt0htRSBe6odeSoeM6Q==
X-Received: by 2002:a05:6602:2e03:: with SMTP id o3mr17071102iow.14.1639075995774;
        Thu, 09 Dec 2021 10:53:15 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id k9sm293004ilv.61.2021.12.09.10.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 10:53:15 -0800 (PST)
Date:   Thu, 09 Dec 2021 10:53:09 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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
Message-ID: <61b250951bc73_6bfb208fd@john.notmuch>
In-Reply-To: <87tufhwygr.fsf@toke.dk>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-7-toke@redhat.com>
 <61b1537634e07_979572086f@john.notmuch>
 <87tufhwygr.fsf@toke.dk>
Subject: RE: [PATCH bpf-next 6/8] bpf: Add XDP_REDIRECT support to XDP for
 bpf_prog_run()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> This adds support for doing real redirects when an XDP program retur=
ns
> >> XDP_REDIRECT in bpf_prog_run(). To achieve this, we create a page po=
ol
> >> instance while setting up the test run, and feed pages from that int=
o the
> >> XDP program. The setup cost of this is amortised over the number of
> >> repetitions specified by userspace.
> >> =

> >> To support performance testing use case, we further optimise the set=
up step
> >> so that all pages in the pool are pre-initialised with the packet da=
ta, and
> >> pre-computed context and xdp_frame objects stored at the start of ea=
ch
> >> page. This makes it possible to entirely avoid touching the page con=
tent on
> >> each XDP program invocation, and enables sending up to 11.5 Mpps/cor=
e on my
> >> test box.
> >> =

> >> Because the data pages are recycled by the page pool, and the test r=
unner
> >> doesn't re-initialise them for each run, subsequent invocations of t=
he XDP
> >> program will see the packet data in the state it was after the last =
time it
> >> ran on that particular page. This means that an XDP program that mod=
ifies
> >> the packet before redirecting it has to be careful about which assum=
ptions
> >> it makes about the packet content, but that is only an issue for the=
 most
> >> naively written programs.
> >> =

> >> Previous uses of bpf_prog_run() for XDP returned the modified packet=
 data
> >> and return code to userspace, which is a different semantic then thi=
s new
> >> redirect mode. For this reason, the caller has to set the new
> >> BPF_F_TEST_XDP_DO_REDIRECT flag when calling bpf_prog_run() to opt i=
n to
> >> the different semantics. Enabling this flag is only allowed if not s=
etting
> >> ctx_out and data_out in the test specification, since it means frame=
s will
> >> be redirected somewhere else, so they can't be returned.
> >> =

> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > [...]
> >
> >> +static int bpf_test_run_xdp_redirect(struct bpf_test_timer *t,
> >> +				     struct bpf_prog *prog, struct xdp_buff *orig_ctx)
> >> +{
> >> +	void *data, *data_end, *data_meta;
> >> +	struct xdp_frame *frm;
> >> +	struct xdp_buff *ctx;
> >> +	struct page *page;
> >> +	int ret, err =3D 0;
> >> +
> >> +	page =3D page_pool_dev_alloc_pages(t->xdp.pp);
> >> +	if (!page)
> >> +		return -ENOMEM;
> >> +
> >> +	ctx =3D ctx_from_page(page);
> >> +	data =3D ctx->data;
> >> +	data_meta =3D ctx->data_meta;
> >> +	data_end =3D ctx->data_end;
> >> +
> >> +	ret =3D bpf_prog_run_xdp(prog, ctx);
> >> +	if (ret =3D=3D XDP_REDIRECT) {
> >> +		frm =3D (struct xdp_frame *)(ctx + 1);
> >> +		/* if program changed pkt bounds we need to update the xdp_frame =
*/
> >
> > Because this reuses the frame repeatedly is there any issue with also=

> > updating the ctx each time? Perhaps if the prog keeps shrinking
> > the pkt it might wind up with 0 len pkt? Just wanted to ask.
> =

> Sure, it could. But the data buffer comes from userspace anyway, and
> there's nothing preventing userspace from passing a 0-length packet
> anyway, so I just mentally put this in the "don't do that, then" bucket=
 :)
> =

> At least I don't *think* there's actually any problem with this that we=

> don't have already? A regular XDP program can also shrink an incoming
> packet to zero, then redirect it, no?
> =

> -Toke
> =


Agree, I don't see any real issue with it. Just wnated to be sure we
thought through it.

Thanks!
John=
