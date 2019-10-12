Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E618D5130
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfJLQ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:57:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40488 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfJLQzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:55:04 -0400
Received: by mail-lf1-f67.google.com with SMTP id d17so9100574lfa.7;
        Sat, 12 Oct 2019 09:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDizdu9ZTbUiBuM21uWD34hEvaAlCgMSnuRFZcYt/XY=;
        b=pO9lZhHTzapFnKp1A1SeeDMdu5u74rTS1jKEzLWhdZWIBvCqZ5VkC7bfHAjqO4p9IL
         /Q/jJQ4URnIkx4i2dJix7O9EwR65uLxLwBI2S+LgQ5vzoCq2UqyHbidijxOFXtUq90fo
         svPrgAsWMbFjhjm5FCVnqMViC72WjMFhnO2RyfjWe194+gSBPNclNX5eah/OnwzooGRi
         HlqxYi7VTuWk90ABAxjmppgitjviM3ZGDU1XFEpCplO0+mZ9p3pCOQjNJSXt9T1SVEqK
         +yoVM6fxjw7VDkf0DhF8/bdW5JH28R13veKHZOWY7O1o8A9vLbaG+ATYUVaAlBoI5JV1
         P61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDizdu9ZTbUiBuM21uWD34hEvaAlCgMSnuRFZcYt/XY=;
        b=Y8oIlf5zykbLhmKJVfkA6pwJVwYp6vgJ9CwwsDvpaJibfZfIo97m+WthXdoVnt4Eyc
         Ez/ZUahb6lyxJQh4R2CLNrZlmlnJvE+JL3zkebI3hsmGQTkPnEDP5WTbHSG6ZEn/gl9r
         zu2wR9QEic/7yuOwerLwybWqRU5Lyw3RHavy/aLPNPmWwmsCQljJ9qwLbPsbDRoeRta5
         +W4+SWlVXbtmzjiOQanOrjJCJ2QvHIN9qL7eJZ8zlG6R9jjWBZZX64ZO6s7xxm9OHhni
         36AKDexX2hVQG0zKUjd1mBAS9qhtGCTHLgn6PTB0YUXOyqXg+oClJmVBk0hw1cu+cc+Y
         HdGg==
X-Gm-Message-State: APjAAAWx5pNDJ+2GW25YJhLCliP2s65CxpsTjqufW128tajmeEhTiNTo
        DLZNgkFB2KIAIZ2Pa9JHGSS+lhn4MToa5SVZc54=
X-Google-Smtp-Source: APXvYqz1YrbXUhmqbBUp2gf/ItCVN5nB4DPteK5Mfohp/t0wE7TqKOkPrdGGItfBLszOa+G9Z37EtaAM0p5+5/0eyLk=
X-Received: by 2002:ac2:597b:: with SMTP id h27mr11986416lfp.100.1570899301833;
 Sat, 12 Oct 2019 09:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
 <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
 <CAJ8uoz3t2jVuwYKaFtt7huJo8HuW9aKLaFpJ4WcWxjm=-wQgrQ@mail.gmail.com> <5da0ed0b2a26d_70f72aad5dc6a5b8db@john-XPS-13-9370.notmuch>
In-Reply-To: <5da0ed0b2a26d_70f72aad5dc6a5b8db@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 12 Oct 2019 09:54:50 -0700
Message-ID: <CAADnVQKDr0u_YfB_eMYZEPKO1O=4hdzLye9FDMqjy4J3GL8Szg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix compatibility for kernels without need_wakeup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
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

On Fri, Oct 11, 2019 at 1:58 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Magnus Karlsson wrote:
> > On Tue, Oct 8, 2019 at 9:29 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Magnus Karlsson wrote:
> > > > When the need_wakeup flag was added to AF_XDP, the format of the
> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
> > > > to take care of compatibility issues arrising from running
> > > > applications using any of the two formats. However, libbpf was not
> > > > extended to take care of the case when the application/libbpf uses the
> > > > new format but the kernel only supports the old format. This patch
> > > > adds support in libbpf for parsing the old format, before the
> > > > need_wakeup flag was added, and emulating a set of static need_wakeup
> > > > flags that will always work for the application.
> > > >
> > > > Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> > > > Reported-by: Eloy Degen <degeneloy@gmail.com>
> > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > ---
> > > >  tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
> > > >  1 file changed, 78 insertions(+), 31 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > > index a902838..46f9687 100644
> > > > --- a/tools/lib/bpf/xsk.c
> > > > +++ b/tools/lib/bpf/xsk.c
> > > > @@ -44,6 +44,25 @@
> > > >   #define PF_XDP AF_XDP
> > > >  #endif
> > > >
> > > > +#define is_mmap_offsets_v1(optlen) \
> > > > +     ((optlen) == sizeof(struct xdp_mmap_offsets_v1))
> > > > +
> > > > +#define get_prod_off(ring) \
> > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
> > > > +      off.ring.producer)
> > > > +#define get_cons_off(ring) \
> > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
> > > > +      off.ring.consumer)
> > > > +#define get_desc_off(ring) \
> > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
> > > > +#define get_flags_off(ring) \
> > > > +     (is_mmap_offsets_v1(optlen) ? \
> > > > +      ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
> > > > +      off.ring.flags)
> > > > +
> > >
> > > It seems the only thing added was flags right? If so seems we
> > > only need the last one there, get_flags_off(). I think it would
> > > be a bit cleaner to just use the macros where its actually
> > > needed IMO.
> >
> > The flag is indeed added to the end of struct xdp_ring_offsets, but
> > this struct is replicated four times in the struct xdp_mmap_offsets,
> > so the added flags are present four time there at different offsets.
> > This means that 3 out of the 4 prod, cons and desc variables are
> > located at different offsets from the original. Do not know how I can
> > get rid of these macros in this case. But it might just be me not
> > seeing it, of course :-).
>
> Not sure I like it but not seeing a cleaner solution that doesn't cause
> larger changes so...
>
> Acked-by: John Fastabend <john.fastabend.gmail.com>

Frankly above hack looks awful.
What is _v1 ?! Is it going to be _v2?
What was _v0?
I also don't see how this is a fix. imo bpf-next is more appropriate
and if "large changes" are necessary then go ahead and do them.
We're not doing fixes-branches in libbpf.
The library always moves forward and compatible with all older kernels.
