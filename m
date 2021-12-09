Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BCD46F37F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 19:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhLIS7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 13:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhLIS7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 13:59:49 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5720CC061746;
        Thu,  9 Dec 2021 10:56:15 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id k21so7773922ioh.4;
        Thu, 09 Dec 2021 10:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yQNobjI2fO/H/TiEGzal1GrMllHmTLCVM0olAqUxQuA=;
        b=Eno+gCA+KTBxS3OUICr2Dkht8GChYGRCAzyXEmozRJf+kDCFALD07gQHyoAtfqp3Aa
         /mf11bs6xhcVN1nMwQJQ+TjyIjRZQCLJuliAckDgzlgLTzTGZpSOdwQtOZvuS4EF4tMT
         5EoqYlM4b0CapiH+7ics705qT6FEPciJTpoGxKkvAJQXxOEeY+TEARgo+9igtu/fNBKO
         W8keletQFZSaOAPBN0VgfXo4BZI5unmPW+JzotNPKPj2W9Qqd+oeiYmZ5yjcP2DLjXoa
         twx2oOtl8bd0nZ180XB8hOXKQJZTbxeW1PplWCH1Tk9MWl72c4nQmLMflFzye3dSSeD+
         I9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yQNobjI2fO/H/TiEGzal1GrMllHmTLCVM0olAqUxQuA=;
        b=7zLYQX42UFE67P1iw7G+lCmNAVwkgzgj2VKVjJUkbaXlK+hv/9Kbr7hbkUv8Ktval3
         lk5kQC652wdc8sQ+i0wB6z/RJoN6ft1u9F46I9zQ1bR9jur+EH+DRmBmuO70HZqLXZdR
         wRlCF05l0CW49XTnfTqCF6idvZiUOx+N+5OJe6Ft3hMsH2kUJq/iUMhHSA039ruhZmzP
         ccIPZ3uHxtso5jycX9zey+qKRi8bFsmK1TZOlC/sGTrlyEi7l6NWPK1MepF5bjzdvxk0
         8khZHPiEOUY8VqNumfxkrRJ0FtXcl5Dp7MXbE6rJA9t/tV50W+jIyANf5KEqSY0EP57M
         n4Nw==
X-Gm-Message-State: AOAM532BxF7ZTDM6AxMA4U/KGenmK727tF6TylKKhGhgqU9sgjiXvxfb
        DbrjKievo5xVYYljA6diUOU=
X-Google-Smtp-Source: ABdhPJzIN54R5HeNmI51Fz/ISpjieAYVkBBXLd+9zqeF8gdGan8XUXEsGCKdkejlWVuel3AZdmCayg==
X-Received: by 2002:a05:6638:3049:: with SMTP id u9mr11883187jak.132.1639076174747;
        Thu, 09 Dec 2021 10:56:14 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id 18sm298478iln.83.2021.12.09.10.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 10:56:14 -0800 (PST)
Date:   Thu, 09 Dec 2021 10:56:07 -0800
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
Message-ID: <61b25147bc136_6bfb208c5@john.notmuch>
In-Reply-To: <87r1alwwk4.fsf@toke.dk>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-7-toke@redhat.com>
 <61b1537634e07_979572086f@john.notmuch>
 <87tufhwygr.fsf@toke.dk>
 <87r1alwwk4.fsf@toke.dk>
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
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
> =

> > John Fastabend <john.fastabend@gmail.com> writes:
> >
> >> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>> This adds support for doing real redirects when an XDP program retu=
rns
> >>> XDP_REDIRECT in bpf_prog_run(). To achieve this, we create a page p=
ool
> >>> instance while setting up the test run, and feed pages from that in=
to the
> >>> XDP program. The setup cost of this is amortised over the number of=

> >>> repetitions specified by userspace.
> >>> =

> >>> To support performance testing use case, we further optimise the se=
tup step
> >>> so that all pages in the pool are pre-initialised with the packet d=
ata, and
> >>> pre-computed context and xdp_frame objects stored at the start of e=
ach
> >>> page. This makes it possible to entirely avoid touching the page co=
ntent on
> >>> each XDP program invocation, and enables sending up to 11.5 Mpps/co=
re on my
> >>> test box.
> >>> =

> >>> Because the data pages are recycled by the page pool, and the test =
runner
> >>> doesn't re-initialise them for each run, subsequent invocations of =
the XDP
> >>> program will see the packet data in the state it was after the last=
 time it
> >>> ran on that particular page. This means that an XDP program that mo=
difies
> >>> the packet before redirecting it has to be careful about which assu=
mptions
> >>> it makes about the packet content, but that is only an issue for th=
e most
> >>> naively written programs.
> >>> =

> >>> Previous uses of bpf_prog_run() for XDP returned the modified packe=
t data
> >>> and return code to userspace, which is a different semantic then th=
is new
> >>> redirect mode. For this reason, the caller has to set the new
> >>> BPF_F_TEST_XDP_DO_REDIRECT flag when calling bpf_prog_run() to opt =
in to
> >>> the different semantics. Enabling this flag is only allowed if not =
setting
> >>> ctx_out and data_out in the test specification, since it means fram=
es will
> >>> be redirected somewhere else, so they can't be returned.
> >>> =

> >>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> ---
> >>
> >> [...]
> >>
> >>> +static int bpf_test_run_xdp_redirect(struct bpf_test_timer *t,
> >>> +				     struct bpf_prog *prog, struct xdp_buff *orig_ctx)
> >>> +{
> >>> +	void *data, *data_end, *data_meta;
> >>> +	struct xdp_frame *frm;
> >>> +	struct xdp_buff *ctx;
> >>> +	struct page *page;
> >>> +	int ret, err =3D 0;
> >>> +
> >>> +	page =3D page_pool_dev_alloc_pages(t->xdp.pp);
> >>> +	if (!page)
> >>> +		return -ENOMEM;
> >>> +
> >>> +	ctx =3D ctx_from_page(page);
> >>> +	data =3D ctx->data;
> >>> +	data_meta =3D ctx->data_meta;
> >>> +	data_end =3D ctx->data_end;
> >>> +
> >>> +	ret =3D bpf_prog_run_xdp(prog, ctx);
> >>> +	if (ret =3D=3D XDP_REDIRECT) {
> >>> +		frm =3D (struct xdp_frame *)(ctx + 1);
> >>> +		/* if program changed pkt bounds we need to update the xdp_frame=
 */
> >>
> >> Because this reuses the frame repeatedly is there any issue with als=
o
> >> updating the ctx each time? Perhaps if the prog keeps shrinking
> >> the pkt it might wind up with 0 len pkt? Just wanted to ask.
> >
> > Sure, it could. But the data buffer comes from userspace anyway, and
> > there's nothing preventing userspace from passing a 0-length packet
> > anyway, so I just mentally put this in the "don't do that, then" buck=
et :)
> >
> > At least I don't *think* there's actually any problem with this that =
we
> > don't have already? A regular XDP program can also shrink an incoming=

> > packet to zero, then redirect it, no?
> =

> Another thought is that we could of course do the opposite here: instea=
d
> of updating the xdp_frame when the program resizes the packet, just
> reset the pointers so that the next invocation will get the original
> size again? The data would still be changed, but maybe that behaviour i=
s
> less surprising? WDYT?

Should read my email from newest to oldest :)

I think resetting it back to the original size is less surprising. And
if I want to benchmark a helper that moves the pointers it will be
easier. For example benchmarking shrinking a packet with current
code wouldn't really work because eventually the packet will be 0
and my test will stop doing what I expect.

Lets do the reset back to original size.

Thanks,
John

> =

> -Toke
> =



