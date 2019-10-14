Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E1CD5D63
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbfJNI0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:26:25 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41166 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbfJNI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:26:24 -0400
Received: by mail-ot1-f65.google.com with SMTP id g13so13081114otp.8;
        Mon, 14 Oct 2019 01:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iKX4/uHaoZ1upFTAF18Q28/UWp+Z5XRqm9+nI8qbEGw=;
        b=Urk3tTv4w/Uy3+DLXy+P4n+zLdTwXHEdni6VQT0RyDUPtaZknZyUN2tauNsTkg/lPT
         LSKkJsWVm9SYxNgzGFI6NJqOtnAdrWPHgQckFquODbS3KjVb1DfpoWXt1xVef7IgKg1j
         hQ1hCDkfmX+wxbUKsi25JDMI7FbB8JQ7TuLI7JVFYstDeSddP5xdLdvPptF5EA/XkTSi
         f3L9vXnZQQepugb/dE1A0UyhIa8Pd54HwQSdafbfSwmj8bnstTKjPwuNquVPqG4+USGx
         zhP+ZlwQwwaszNBeL82uFRM9niT0ZRIUCiVrTQYAR4ayoSBkg3y0BL69wCvoZRNJyyqk
         tq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iKX4/uHaoZ1upFTAF18Q28/UWp+Z5XRqm9+nI8qbEGw=;
        b=GwOYojnNJ8ghxSZduGfCQreDG4Yynxf4tSJsl++iTR6SMv1XoWfCwmsSbfVzfnBn7p
         WpJBkdorElRP20sAil14P+pg8WSO+nx9VSa/YdASTqhfUdQlr+bnxVt9HHKr0WWmlafv
         aQ/SBvB109yU1SWIqnN00dxY9c+uQdN7UZW+nTKRyzhE89aLtWmB1owkfE+ZwNzEH2vA
         XMxfShfqjGR00htq5EJdXyrYLzpqVRPqEX8XKDAq1S/elXXaxWZ5EgTpPgbhYEI2aX7+
         4+xdT4NQsbHfGtz+0zKxUCczWn/k6CMVjxk8qtWTPNsYgNgWKumi0TRAEYxxy6bKt/NI
         w9Cg==
X-Gm-Message-State: APjAAAXGOA41JXj9A4dcAG915xrqUY+CIxsNjtYX5e6Y/B9RDl/2z0nI
        LIi7G4zajfCJqM1Z1+56XYs2kGG847oA6hzzL+0=
X-Google-Smtp-Source: APXvYqwtjDBgaBHyncvshNegSKRqlG8RP7mDEpXUiTBz+yYFUtoLiTN1KnA3jzk17wDD5DUFxGKKSfvmgyqncPlhUsc=
X-Received: by 2002:a9d:7345:: with SMTP id l5mr14083032otk.39.1571041581799;
 Mon, 14 Oct 2019 01:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
 <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
 <CAJ8uoz3t2jVuwYKaFtt7huJo8HuW9aKLaFpJ4WcWxjm=-wQgrQ@mail.gmail.com>
 <5da0ed0b2a26d_70f72aad5dc6a5b8db@john-XPS-13-9370.notmuch> <CAADnVQKDr0u_YfB_eMYZEPKO1O=4hdzLye9FDMqjy4J3GL8Szg@mail.gmail.com>
In-Reply-To: <CAADnVQKDr0u_YfB_eMYZEPKO1O=4hdzLye9FDMqjy4J3GL8Szg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 14 Oct 2019 10:26:10 +0200
Message-ID: <CAJ8uoz2mzgwvxpE1jsXvPEU=830MeOEtx4T_CMK3pjexFyJdnw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix compatibility for kernels without need_wakeup
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
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

On Sat, Oct 12, 2019 at 6:55 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 11, 2019 at 1:58 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Magnus Karlsson wrote:
> > > On Tue, Oct 8, 2019 at 9:29 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Magnus Karlsson wrote:
> > > > > When the need_wakeup flag was added to AF_XDP, the format of the
> > > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
> > > > > to take care of compatibility issues arrising from running
> > > > > applications using any of the two formats. However, libbpf was not
> > > > > extended to take care of the case when the application/libbpf uses the
> > > > > new format but the kernel only supports the old format. This patch
> > > > > adds support in libbpf for parsing the old format, before the
> > > > > need_wakeup flag was added, and emulating a set of static need_wakeup
> > > > > flags that will always work for the application.
> > > > >
> > > > > Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> > > > > Reported-by: Eloy Degen <degeneloy@gmail.com>
> > > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > > ---
> > > > >  tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
> > > > >  1 file changed, 78 insertions(+), 31 deletions(-)
> > > > >
> > > > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > > > index a902838..46f9687 100644
> > > > > --- a/tools/lib/bpf/xsk.c
> > > > > +++ b/tools/lib/bpf/xsk.c
> > > > > @@ -44,6 +44,25 @@
> > > > >   #define PF_XDP AF_XDP
> > > > >  #endif
> > > > >
> > > > > +#define is_mmap_offsets_v1(optlen) \
> > > > > +     ((optlen) == sizeof(struct xdp_mmap_offsets_v1))
> > > > > +
> > > > > +#define get_prod_off(ring) \
> > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
> > > > > +      off.ring.producer)
> > > > > +#define get_cons_off(ring) \
> > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
> > > > > +      off.ring.consumer)
> > > > > +#define get_desc_off(ring) \
> > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
> > > > > +#define get_flags_off(ring) \
> > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
> > > > > +      off.ring.flags)
> > > > > +
> > > >
> > > > It seems the only thing added was flags right? If so seems we
> > > > only need the last one there, get_flags_off(). I think it would
> > > > be a bit cleaner to just use the macros where its actually
> > > > needed IMO.
> > >
> > > The flag is indeed added to the end of struct xdp_ring_offsets, but
> > > this struct is replicated four times in the struct xdp_mmap_offsets,
> > > so the added flags are present four time there at different offsets.
> > > This means that 3 out of the 4 prod, cons and desc variables are
> > > located at different offsets from the original. Do not know how I can
> > > get rid of these macros in this case. But it might just be me not
> > > seeing it, of course :-).
> >
> > Not sure I like it but not seeing a cleaner solution that doesn't cause
> > larger changes so...
> >
> > Acked-by: John Fastabend <john.fastabend.gmail.com>
>
> Frankly above hack looks awful.
> What is _v1 ?! Is it going to be _v2?
> What was _v0?
> I also don't see how this is a fix. imo bpf-next is more appropriate
> and if "large changes" are necessary then go ahead and do them.
> We're not doing fixes-branches in libbpf.
> The library always moves forward and compatible with all older kernels.

The fix in this patch is about making libbpf compatible with older
kernels (<=5.3). It is not at the moment in bpf. The current code in
bpf and bpf-next only works with the 5.3-rc kernels, which I think is
bad and a bug. But please let me know if this is bpf or bpf-next and I
will adjust accordingly.

As for the hack, I do not like it and neither did John, but no one
managed to come up with something better. But if this is a fix for bpf
(will not work at all for bpf-next for compatibility reasons), we
could potentially do something like this, as this is only present in
the 5.4-rc series. Currently the extension of the XDP_MMAP_OFFSETS in
5.4-rc is from:

struct xdp_ring_offset {
       __u64 producer;
       __u64 consumer;
       __u64 desc;
};

to:

struct xdp_ring_offset {
       __u64 producer;
       __u64 consumer;
       __u64 desc;
       __u64 flags;
};

while the overall struct provided to the getsockopt stayed the same:

struct xdp_mmap_offsets {
       struct xdp_ring_offset rx;
       struct xdp_ring_offset tx;
       struct xdp_ring_offset fr;
       struct xdp_ring_offset cr;
};

If we instead keep the original struct xdp_ring_offset and append the
new flag offsets at the end of struct xdp_mmap_offsets to something
like this:

struct xdp_mmap_offsets {
       struct xdp_ring_offset rx;
       struct xdp_ring_offset tx;
       struct xdp_ring_offset fr;
       struct xdp_ring_offset cr;
       __u64 rx_flag;
       __u64 tx_flag;
       __u64 fr_flag;
       __u64 cr_flag;
};

the implementation in both the kernel and libbpf becomes much cleaner.
The only change needed in libbpf and the kernel is to introduce a new
function for reading the flag field. The other offset reading and
setting code would stay the same, in contrast to the current scheme.
None of the current patch's macro crap would be needed. This would
also simplify the kernel implementation, improving maintainability.
But this would only be possible to change in bpf. So let me know what
you think. Do not know what the policy is here, so need some advice
please.

Cheers: Magnus
