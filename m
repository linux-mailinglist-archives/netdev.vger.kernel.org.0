Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3691FD86D9
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732525AbfJPDm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:42:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43489 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfJPDm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:42:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id f21so10575942plj.10;
        Tue, 15 Oct 2019 20:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5LlvjNJ+uZftr8nMNCZEPDpOfuDwhaeRUDzRaIvvjD4=;
        b=IQFFNqgSjqSew/UwE+YMDBtOFy4uTz+GPQRJa8y5W1yL5rUeYXPtr2c23e4MZGg5/g
         d+SqNd1oKBYWjbVexNQB1N8VDqEn3+GWQAEO0TPcq8CnCfzdsoE5sG8QE9d5Xcarj6Fw
         SkpABgOaAre4Xgp7rsl43Suzp7CH+IY9cag1vCG9r1UYKtK+yHN/4AmQrFHFpdTK+JcK
         +xzY1r7M7PjcfluOxyspCIFr/j6AOFhhFQvLUekIvRVKAW9jfoos/NW6ACsHmAsE9PsL
         W/TMYktLWYRtVQ2SAA72yfZj1AELuVGAFjKEU0rrrLV1KU9RXPRDNNpSqgSmtzdXOjjU
         T82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5LlvjNJ+uZftr8nMNCZEPDpOfuDwhaeRUDzRaIvvjD4=;
        b=kZ6DIvsAnsOmThEno0gMmxjCAEh1CgsCHusOQNcatW58RrvZGf1kAQACd7eP7K1nKy
         hyjf4aJCcSuE8AeT7XZFvUsVZsml/dv/pMu9qyDxuynH6WshEivruhTIQKW+gbFldZ2w
         OgGXuveEWbpZADkuPAYCfyA76RiQ+R7e+v0RWmJ9ImjYYom3y1IoSmzZa/NeTycsrkga
         54JE6NaUxs2knry8lZs1Sz5ODw8LJkTjuhfRlQjhjJmI/zf6XtPXqNKvaUROT67oIRRY
         TvNEjon31nB1kjgt/UqwvpRTCm2hd42vdb0UQD4/Z+QXWM/eYxnz1zrJoMSseQmYC0aC
         B+xA==
X-Gm-Message-State: APjAAAXweoybYf5VtjfrUHY9Jt6FC016zy0tr+c3bEi5OVnXLZkb/N3+
        XTzFF68sYdcqKKM15nYosc8=
X-Google-Smtp-Source: APXvYqwqbXLJ34R8fzrC1pUZLHw/ua4WipLSxvhsQxwrqRQrD5aae6bh1EKwb0v6NUnYCLOqNoTldA==
X-Received: by 2002:a17:902:9a45:: with SMTP id x5mr28024895plv.92.1571197347951;
        Tue, 15 Oct 2019 20:42:27 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::efaa])
        by smtp.gmail.com with ESMTPSA id l21sm23383420pgm.55.2019.10.15.20.42.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 20:42:27 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:42:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: fix compatibility for kernels without
 need_wakeup
Message-ID: <20191016034222.zykzlaoinhjvrkef@ast-mbp>
References: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
 <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
 <CAJ8uoz3t2jVuwYKaFtt7huJo8HuW9aKLaFpJ4WcWxjm=-wQgrQ@mail.gmail.com>
 <5da0ed0b2a26d_70f72aad5dc6a5b8db@john-XPS-13-9370.notmuch>
 <CAADnVQKDr0u_YfB_eMYZEPKO1O=4hdzLye9FDMqjy4J3GL8Szg@mail.gmail.com>
 <CAJ8uoz2mzgwvxpE1jsXvPEU=830MeOEtx4T_CMK3pjexFyJdnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz2mzgwvxpE1jsXvPEU=830MeOEtx4T_CMK3pjexFyJdnw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:26:10AM +0200, Magnus Karlsson wrote:
> On Sat, Oct 12, 2019 at 6:55 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 1:58 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Magnus Karlsson wrote:
> > > > On Tue, Oct 8, 2019 at 9:29 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Magnus Karlsson wrote:
> > > > > > When the need_wakeup flag was added to AF_XDP, the format of the
> > > > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
> > > > > > to take care of compatibility issues arrising from running
> > > > > > applications using any of the two formats. However, libbpf was not
> > > > > > extended to take care of the case when the application/libbpf uses the
> > > > > > new format but the kernel only supports the old format. This patch
> > > > > > adds support in libbpf for parsing the old format, before the
> > > > > > need_wakeup flag was added, and emulating a set of static need_wakeup
> > > > > > flags that will always work for the application.
> > > > > >
> > > > > > Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> > > > > > Reported-by: Eloy Degen <degeneloy@gmail.com>
> > > > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > > > ---
> > > > > >  tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
> > > > > >  1 file changed, 78 insertions(+), 31 deletions(-)
> > > > > >
> > > > > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > > > > index a902838..46f9687 100644
> > > > > > --- a/tools/lib/bpf/xsk.c
> > > > > > +++ b/tools/lib/bpf/xsk.c
> > > > > > @@ -44,6 +44,25 @@
> > > > > >   #define PF_XDP AF_XDP
> > > > > >  #endif
> > > > > >
> > > > > > +#define is_mmap_offsets_v1(optlen) \
> > > > > > +     ((optlen) == sizeof(struct xdp_mmap_offsets_v1))
> > > > > > +
> > > > > > +#define get_prod_off(ring) \
> > > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
> > > > > > +      off.ring.producer)
> > > > > > +#define get_cons_off(ring) \
> > > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
> > > > > > +      off.ring.consumer)
> > > > > > +#define get_desc_off(ring) \
> > > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
> > > > > > +#define get_flags_off(ring) \
> > > > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
> > > > > > +      off.ring.flags)
> > > > > > +
> > > > >
> > > > > It seems the only thing added was flags right? If so seems we
> > > > > only need the last one there, get_flags_off(). I think it would
> > > > > be a bit cleaner to just use the macros where its actually
> > > > > needed IMO.
> > > >
> > > > The flag is indeed added to the end of struct xdp_ring_offsets, but
> > > > this struct is replicated four times in the struct xdp_mmap_offsets,
> > > > so the added flags are present four time there at different offsets.
> > > > This means that 3 out of the 4 prod, cons and desc variables are
> > > > located at different offsets from the original. Do not know how I can
> > > > get rid of these macros in this case. But it might just be me not
> > > > seeing it, of course :-).
> > >
> > > Not sure I like it but not seeing a cleaner solution that doesn't cause
> > > larger changes so...
> > >
> > > Acked-by: John Fastabend <john.fastabend.gmail.com>
> >
> > Frankly above hack looks awful.
> > What is _v1 ?! Is it going to be _v2?
> > What was _v0?
> > I also don't see how this is a fix. imo bpf-next is more appropriate
> > and if "large changes" are necessary then go ahead and do them.
> > We're not doing fixes-branches in libbpf.
> > The library always moves forward and compatible with all older kernels.
> 
> The fix in this patch is about making libbpf compatible with older
> kernels (<=5.3). It is not at the moment in bpf. The current code in
> bpf and bpf-next only works with the 5.3-rc kernels, which I think is
> bad and a bug. But please let me know if this is bpf or bpf-next and I
> will adjust accordingly.
> 
> As for the hack, I do not like it and neither did John, but no one
> managed to come up with something better. But if this is a fix for bpf
> (will not work at all for bpf-next for compatibility reasons), we
> could potentially do something like this, as this is only present in
> the 5.4-rc series.

Practically there is no bpf tree for libbpf.
bpf-next is the only place where most of the fixes to libbpf should go.
libbpf must be compatible with _all_ older kernels.
We have no plans of branching previously released libbpf.
If there is a bug in libbpf 0.0.5 (current latest and released)
then it will be fixed in libbpf 0.0.6.
So please target your fixes to bpf-next tree and upcoming libbpf release.
Please make sure that your fixes work with kernel 5.3 and 5.4-rc.

There are two exceptions where libbpf fixes should actually be in bpf tree:
- fixes to libbpf that are necessary to fix perf builds in bpf tree.
- fixes to libbpf that are necessary to support selftest/bpf/ in bpf tree.
Because these two are actually kernel tree specific.

