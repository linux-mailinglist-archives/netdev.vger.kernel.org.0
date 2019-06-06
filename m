Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309AA378FE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfFFP4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:56:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34075 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbfFFP4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:56:45 -0400
Received: by mail-lj1-f195.google.com with SMTP id j24so2568436ljg.1
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 08:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BTFSYHhoAv2eDoZKT2KokrC8CG/nITTN7eKw0LXHzY4=;
        b=fYUNO4DQ3ZqwGuNpNq3FgrSB/SIRoOM46UmxgjxIB/NE6Fedezjd1rBsT+Crx1iIY5
         d2Axo/Ytc2Dfe8mKQEZbuBbCoivvxxRBXPZeJZ1D7wOdTZayKYcFmVvyj9aphhteZXNz
         3OZI6fo05yRJaoLfTIyItCFi8M7QSbK8WHAXTdlx2xGlAV29nnTTZMY/7cjZKSGKP0e8
         r9ejxqGKL5ahr96zOaWA1o716UAoI97/9ygk69TXcRX0lltIAxzNMz8rCJIhi29z8jeK
         N8xzr29nEQNZlsiEm3AvHjpIsmW1YDbL9IUqQuKjAqEnr6bzd+LNTTNqHbstcqUojgkk
         AkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BTFSYHhoAv2eDoZKT2KokrC8CG/nITTN7eKw0LXHzY4=;
        b=C6hvearHY1FDNkIqidv0Qblf5n4Gj5Qas70jrEC3090YiZE/uU2bPBPzf7U1wSzUtn
         tzwz/lKtVE/aUL4iAesh79lHpJ7cKeYuRlMdTKwARD6y4TtKBE4eGvewNJEWU8oDm93d
         T2QuoOS5IVAJDlF26LgYsH9eLo4kcWFtBPVidD3czBPVSqR2juQsakOaDBtNbj2IrZ+f
         S4l+ZRkiC3VqtLc8sDvf3taPNgqY+3DJvcpD+cblBJNM8mccyXgOaqnX1sMcl+N8/W0t
         C5OKAph7Stth1xS1uflFXtTc7quQ+iBcpkm+3eXWXAx/jRQUpWBnPA6RCz1KUZZ4ZED3
         it2w==
X-Gm-Message-State: APjAAAXzOyu+Yp1IsdRBDgX/jW6xKuDveSBPMK8ZPK2Il6WY+7acTF9m
        wdYMBCgNI4Bjpeu37aT5Wyx79aRJlkse83pUHKoBaQ==
X-Google-Smtp-Source: APXvYqwnQBrjJlHJeJjUBr/MzTlBE9fdteIsVazTIA8kPuWcUIjeMKQfQWkyJGdV1vdc+c6B1wYTO5VU+GYnJCr8i1Q=
X-Received: by 2002:a2e:96d7:: with SMTP id d23mr12538386ljj.206.1559836602748;
 Thu, 06 Jun 2019 08:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
 <155982745460.30088.2745998912845128889.stgit@alrua-x1> <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net>
In-Reply-To: <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jun 2019 08:56:30 -0700
Message-ID: <CAADnVQKZG6nOZUvqzvxz5xjZZLieQB4DvbkP=AjDF25FQB8Jfg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 8:51 AM Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>
> On 06/06/2019 03:24 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > The bpf_redirect_map() helper used by XDP programs doesn't return any
> > indication of whether it can successfully redirect to the map index it =
was
> > given. Instead, BPF programs have to track this themselves, leading to
> > programs using duplicate maps to track which entries are populated in t=
he
> > devmap.
> >
> > This patch adds a flag to the XDP version of the bpf_redirect_map() hel=
per,
> > which makes the helper do a lookup in the map when called, and return
> > XDP_PASS if there is no value at the provided index.
> >
> > With this, a BPF program can check the return code from the helper call=
 and
> > react if it is XDP_PASS (by, for instance, substituting a different
> > redirect). This works for any type of map used for redirect.
> >
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h |    8 ++++++++
> >  net/core/filter.c        |   10 +++++++++-
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 7c6aef253173..d57df4f0b837 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3098,6 +3098,14 @@ enum xdp_action {
> >       XDP_REDIRECT,
> >  };
> >
> > +/* Flags for bpf_xdp_redirect_map helper */
> > +
> > +/* If set, the help will check if the entry exists in the map and retu=
rn
> > + * XDP_PASS if it doesn't.
> > + */
> > +#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
> > +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
> > +
> >  /* user accessible metadata for XDP packet hook
> >   * new fields must be added to the end of this structure
> >   */
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 55bfc941d17a..2e532a9b2605 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map =
*, map, u32, ifindex,
> >  {
> >       struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info)=
;
> >
> > -     if (unlikely(flags))
> > +     if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
> >               return XDP_ABORTED;
> >
> > +     if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
> > +             void *val;
> > +
> > +             val =3D __xdp_map_lookup_elem(map, ifindex);
> > +             if (unlikely(!val))
> > +                     return XDP_PASS;
>
> Generally looks good to me, also the second part with the flag. Given we =
store into
> the per-CPU scratch space and function like xdp_do_redirect() pick this u=
p again, we
> could even propagate val onwards and save a second lookup on the /same/ e=
lement (which
> also avoids a race if the val was dropped from the map in the meantime). =
Given this
> should all still be within RCU it should work. Perhaps it even makes sens=
e to do the
> lookup unconditionally inside bpf_xdp_redirect_map() helper iff we manage=
 to do it
> only once anyway?

+1

also I don't think we really need a new flag here.
Yes, it could be considered an uapi change, but it
looks more like bugfix in uapi to me.
Since original behavior was so clunky to use.
