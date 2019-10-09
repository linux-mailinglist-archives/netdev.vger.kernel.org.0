Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59A1D0847
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfJIHbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:31:22 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:32780 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIHbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:31:22 -0400
Received: by mail-ot1-f65.google.com with SMTP id 60so888963otu.0;
        Wed, 09 Oct 2019 00:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JPgub1MuIZH/1GWLVVbLyXVb5jS64cCM9E+ZqYGumsk=;
        b=pnJLToe3gYYe0/kNCVflu25Yx02qPhe36h8YMjVMiVP8o9umVeSha3sGUWYow1yGoI
         6p1cPxZX5/ESpUK4aEDblN5obbLbBuz1zqAZlZkF56Bkq+9F4L0teKzdQ/fuNY1mtKrE
         +jtGtlG7uWEPdAtsYaQmqGEHpwzA63BDkGrfW7IAB9qvtUyBgfN3xaU30OVdeKruVzIq
         yUK8UurAMBfySG2jwlcMh40vwZgYFLXuAtAEnyMECaOO96VbjpmFk6BN6UF2XbGYb298
         4ctgh3de230lnKmlc/Dk2FmVpRWBWO/b20XHELmitgQK3QDWG8YTFSQYHCGvIMpZm2mX
         uSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JPgub1MuIZH/1GWLVVbLyXVb5jS64cCM9E+ZqYGumsk=;
        b=MCUKijVwoMl0HdMGugXcSloICw/sws4IaQhPSPJNeffdRRmmAzKYiIpwqj/cW7/KiU
         fRKOWZqXIEfQ8zI0box3bIslRxidoL2kR0HYOx1SfX7QX6C9DalmTeHhzNzb56oMLkjE
         tpf1a4X7bku6dIGQc6Y8WOtAixldFnhUf4aAlAB6m0OEHtVZiR4sjrP7pwg3xdmcYv47
         gYtrpl1Io8/JKns+K9ejq1YP74m5XzrGE0FT47ru/n6nHExLqI5e2N0UIKoUCvOEoWvC
         /VHULt9G0FQiJGizbu9AmhsKloeKNg07rqhVmnt2/nqTQZ/kA16eraMdVFbQx89CjCTH
         Q/sg==
X-Gm-Message-State: APjAAAVcU7aADw8IqX1/AAxJB9ezxgWu00eCMpSiT6HxJF1VLgZhzH9t
        8rvFXzh/ERur5GA9tD2/snMa04VETu8/Z4BBRMM=
X-Google-Smtp-Source: APXvYqwmIF7x7IYuQaNAEWMMUxk0A555Y6OeAN/AxF/6fNz5vD6G5GGXOzeidpKcF8jfcDSeN21jbhoahEVUK6nXWF8=
X-Received: by 2002:a9d:7345:: with SMTP id l5mr1753864otk.39.1570606281434;
 Wed, 09 Oct 2019 00:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com> <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
In-Reply-To: <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 9 Oct 2019 09:31:10 +0200
Message-ID: <CAJ8uoz3t2jVuwYKaFtt7huJo8HuW9aKLaFpJ4WcWxjm=-wQgrQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix compatibility for kernels without need_wakeup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 9:29 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Magnus Karlsson wrote:
> > When the need_wakeup flag was added to AF_XDP, the format of the
> > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
> > to take care of compatibility issues arrising from running
> > applications using any of the two formats. However, libbpf was not
> > extended to take care of the case when the application/libbpf uses the
> > new format but the kernel only supports the old format. This patch
> > adds support in libbpf for parsing the old format, before the
> > need_wakeup flag was added, and emulating a set of static need_wakeup
> > flags that will always work for the application.
> >
> > Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> > Reported-by: Eloy Degen <degeneloy@gmail.com>
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 78 insertions(+), 31 deletions(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index a902838..46f9687 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -44,6 +44,25 @@
> >   #define PF_XDP AF_XDP
> >  #endif
> >
> > +#define is_mmap_offsets_v1(optlen) \
> > +     ((optlen) == sizeof(struct xdp_mmap_offsets_v1))
> > +
> > +#define get_prod_off(ring) \
> > +     (is_mmap_offsets_v1(optlen) ? \
> > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
> > +      off.ring.producer)
> > +#define get_cons_off(ring) \
> > +     (is_mmap_offsets_v1(optlen) ? \
> > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
> > +      off.ring.consumer)
> > +#define get_desc_off(ring) \
> > +     (is_mmap_offsets_v1(optlen) ? \
> > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
> > +#define get_flags_off(ring) \
> > +     (is_mmap_offsets_v1(optlen) ? \
> > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
> > +      off.ring.flags)
> > +
>
> It seems the only thing added was flags right? If so seems we
> only need the last one there, get_flags_off(). I think it would
> be a bit cleaner to just use the macros where its actually
> needed IMO.

The flag is indeed added to the end of struct xdp_ring_offsets, but
this struct is replicated four times in the struct xdp_mmap_offsets,
so the added flags are present four time there at different offsets.
This means that 3 out of the 4 prod, cons and desc variables are
located at different offsets from the original. Do not know how I can
get rid of these macros in this case. But it might just be me not
seeing it, of course :-).

Thanks: Magnus

> Thanks,
> John
