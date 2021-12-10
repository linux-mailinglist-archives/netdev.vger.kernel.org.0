Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A3347077A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhLJRl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238351AbhLJRl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:41:27 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C9AC0617A1;
        Fri, 10 Dec 2021 09:37:52 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id v203so22973648ybe.6;
        Fri, 10 Dec 2021 09:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbDsL79OudshH/Pa1Nr6jNiPia/i/MwqyUuLxD54n8U=;
        b=k8B1SGbxIqX3CJv6zv7/HSEoVou2QhPAqFyrJqn9ITy/M0Soa5H2+OkpfK1zj0PDiP
         +8Rv+T0SDDMgQdOQrQeRj++rcwSabqlByk9Q2Hpnc/kiE/JMlNq5rnDaNbKl/UAjt6iN
         0704HGrx2ll8XGw5ySeLqFfWCsmRjELxJB35DEsq9g2530iGVDAL9U2VwxJJgBmQWz4i
         xPWG/VGZpLtbsR7HdJrJWfBPpseVOicSpWxqnbG1n20xsGzrqHm5MKaCseoqueISWKTQ
         cIT5GJQswAVG8sXV+/bGAzu/M446Qkv1+xjRaOHqpzfurRuh2jG38SWbAVs/+vusnpYd
         PNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbDsL79OudshH/Pa1Nr6jNiPia/i/MwqyUuLxD54n8U=;
        b=erhQ6Gdg3vlzsfvdSsHxyPf1aZtyaidgei4OO3k1pgwRIlyfQ+mWDU2nvxHXLKqJmf
         lPAvd5mXIqYTzV+fYEXXAQASQUbR95N/lbJHgJURWdoWQ2tbPWxin21qJO1M8yFogIeK
         Y+HeyBb4aDAIbLczRr8zokraBC/vY5Qkr1YSrlb6zeDTHFhOZwkzat3BVxwszPGXYhvW
         OixouJZS4GUb6wZVClyp8R4LjoAbCijz4tQ3ley9va446I2gG4XHzRH7/rwLb90W6UTu
         5t7toP8TZn6wFPoMMt0InDBt1puLOAW3UTA8/dMX1diovSK/iOZM7BjUj4MoxlCW30kX
         t9VQ==
X-Gm-Message-State: AOAM530rNs1ifIvqGraOPep8/IVuIhtigBVuR8iuIX9hkR8g1LSJH7c2
        Hoi+pHyFRkYlJqCEGK9GgblSnDShRfvJiuFYSQ0=
X-Google-Smtp-Source: ABdhPJzTmkWJaS8tlWJmvwoBriKbdM8BNPnF23BjxAmAPNGNlmbmNpHMPYdDAzdw7AmsaF2xg7Sl2PnF6MGDREGvqKE=
X-Received: by 2002:a25:e90a:: with SMTP id n10mr15505738ybd.180.1639157871317;
 Fri, 10 Dec 2021 09:37:51 -0800 (PST)
MIME-Version: 1.0
References: <20211209120327.551952-1-emmanuel.deloget@eho.link>
 <CAEf4BzYJ+GPpjcMMYQM_BfQ1-aq6dz_JbF-m5meiCZ=oPbrM=w@mail.gmail.com> <15676ff5-5c5c-fd06-308f-10611c01f6a9@eho.link>
In-Reply-To: <15676ff5-5c5c-fd06-308f-10611c01f6a9@eho.link>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Dec 2021 09:37:40 -0800
Message-ID: <CAEf4Bzb_f1FYkVre62ACTpEYq5=rPjZ-5BD-jHAez=oUmvC6yA@mail.gmail.com>
Subject: Re: [PATCH v1 bpf 1/1] libbpf: don't force user-supplied ifname
 string to be of fixed size
To:     Emmanuel Deloget <emmanuel.deloget@eho.link>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 9, 2021 at 9:55 AM Emmanuel Deloget
<emmanuel.deloget@eho.link> wrote:
>
> Hello,
>
> On 09/12/2021 18:17, Andrii Nakryiko wrote:
> > On Thu, Dec 9, 2021 at 4:03 AM Emmanuel Deloget
> > <emmanuel.deloget@eho.link> wrote:
> >>
> >> When calling either xsk_socket__create_shared() or xsk_socket__create()
> >> the user supplies a const char *ifname which is implicitely supposed to
> >> be a pointer to the start of a char[IFNAMSIZ] array. The internal
> >> function xsk_create_ctx() then blindly copy IFNAMSIZ bytes from this
> >> string into the xsk context.
> >>
> >> This is counter-intuitive and error-prone.
> >>
> >> For example,
> >>
> >>          int r = xsk_socket__create(..., "eth0", ...)
> >>
> >> may result in an invalid object because of the blind copy. The "eth0"
> >> string might be followed by random data from the ro data section,
> >> resulting in ctx->ifname being filled with the correct interface name
> >> then a bunch and invalid bytes.
> >>
> >> The same kind of issue arises when the ifname string is located on the
> >> stack:
> >>
> >>          char ifname[] = "eth0";
> >>          int r = xsk_socket__create(..., ifname, ...);
> >>
> >> Or comes from the command line
> >>
> >>          const char *ifname = argv[n];
> >>          int r = xsk_socket__create(..., ifname, ...);
> >>
> >> In both case we'll fill ctx->ifname with random data from the stack.
> >>
> >> In practice, we saw that this issue caused various small errors which,
> >> in then end, prevented us to setup a valid xsk context that would have
> >> allowed us to capture packets on our interfaces. We fixed this issue in
> >> our code by forcing our char ifname[] to be of size IFNAMSIZ but that felt
> >> weird and unnecessary.
> >
> > I might be missing something, but the eth0 example above would include
> > terminating zero at the right place, so ifname will still have
> > "eth0\0" which is a valid string. Yes there will be some garbage after
> > that, but it shouldn't matter. It could cause ASAN to complain about
> > reading beyond allocated memory, of course, but I'm curious what
> > problems you actually ran into in practice.
>
> I cannot be extremely precise on what was happening as I did not
> investigate past this (and this fixes our issue) but I suspect that
> having weird bytes in ctx->ifname polutes ifr.ifr_name as initialized in
> xsk_get_max_queues(). ioctl(SIOCETHTOOL) was then giving us an error.
> Now, I haven't looked how the kernel implements this ioctl() so I'm not
> going to say that there is a problem here as well.
>
> And since the issue is now about 2 weeks old it's now a bit murky - and
> I don't have much time to put myself in the same setup in order to
> produce a better investigation (sorry for that).
>

Ok, fine, but I still don't see how memcpy() could have caused
correctness errors. The string will be zero-terminated properly, so it
is a valid C string. The only issue I see is reading past allocated
memory (which might trigger SIGSEGV or will make ASAN complain).
Anyways, let's try strncpy() and fix this. Please send it against
bpf-next for the respin, please.


> >>
> >> Fixes: 2f6324a3937f8 (libbpf: Support shared umems between queues and devices)
> >> Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
> >> ---
> >>   tools/lib/bpf/xsk.c | 7 +++++--
> >>   1 file changed, 5 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >> index 81f8fbc85e70..8dda80bcefcc 100644
> >> --- a/tools/lib/bpf/xsk.c
> >> +++ b/tools/lib/bpf/xsk.c
> >> @@ -944,6 +944,7 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
> >>   {
> >>          struct xsk_ctx *ctx;
> >>          int err;
> >> +       size_t ifnamlen;
> >>
> >>          ctx = calloc(1, sizeof(*ctx));
> >>          if (!ctx)
> >> @@ -965,8 +966,10 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
> >>          ctx->refcount = 1;
> >>          ctx->umem = umem;
> >>          ctx->queue_id = queue_id;
> >> -       memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
> >> -       ctx->ifname[IFNAMSIZ - 1] = '\0';
> >> +
> >> +       ifnamlen = strnlen(ifname, IFNAMSIZ);
> >> +       memcpy(ctx->ifname, ifname, ifnamlen);
> >
> > maybe use strncpy instead of strnlen + memcpy? keep the guaranteed
> > zero termination (and keep '\0', why did you change it?)
>
> Well, strncpy() calls were replaced by memcpy() a while ago (see
> 3015b500ae42 (libbpf: Use memcpy instead of strncpy to please GCC) for
> example but there are a few other examples ; most of the changes were
> made to please gcc8) so I thought that it would be a bad idea :). What
> would be the consensus on this?

3015b500ae42 ("libbpf: Use memcpy instead of strncpy to please GCC")
is different, there we are copying from properly sized array which our
code controls. memcpy() is totally reasonable there. Here we can't do
memcpy, unfortunately. Let's try strncpy(), if GCC will start
complaining about this, then GCC is clearly wrong and we'll just
disable this warning altogether (I don't remember if it ever found any
real issues anyways).


>
> Regarding '\0', I'll change that.
>
> > Also, note that xsk.c is deprecated in libbpf and has been moved into
> > libxdp, so please contribute a similar fix there.
>
> Will do.
>
> >> +       ctx->ifname[IFNAMSIZ - 1] = 0;
> >>
> >>          ctx->fill = fill;
> >>          ctx->comp = comp;
> >> --
> >> 2.32.0
> >>
>
> BTW, is there a reason why this patch failed to pass the bpf/vmtest-bpf
> test on patchwork?
>

Unrelated bpftool-related check, that isn't supposed to pass on bpf
tree. That one can be ignored.

> Best regards,
>
> -- Emmanuel Deloget
