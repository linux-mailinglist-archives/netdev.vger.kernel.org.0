Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A632A87D4
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbgKEUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgKEUOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:14:34 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB56C0613CF;
        Thu,  5 Nov 2020 12:14:33 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c18so2434256ybj.10;
        Thu, 05 Nov 2020 12:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=az/qZItMbUayACmUa8L1eqKzRCjHhHA8aWj3m+BO0lY=;
        b=TrP/3FL8GspsKarV4VYXYaezlJaTxrOJFdFM5sjWjLBMXhnFJ00OX2Qlv0uBpKpShy
         iu0AHlDWWBvxPLAF+yV58mNuPMdSjJyKCeiXL/Dtr0bqm7DUyFAeIMFtnW9SRg733MgZ
         w4ydlIVsQqOdX11GUZ7Sop9OWluIr8aNtrhqO19dM5N6Ru6fkLLRp2gf70WWRWcTOj5L
         VdN6f41xRFyZgD+fNy5wBFIzVqmHVM+Cd+BoPKQ18pg0LGhq8w3tpAQoz7MsWq7U4GsZ
         6IggtQmyonukoxixeS7INjs161fvqPL5VC4XPGLfKnVa57DyAjjCY549dis7FL9IlYjO
         KXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=az/qZItMbUayACmUa8L1eqKzRCjHhHA8aWj3m+BO0lY=;
        b=DTN5TD9VWAvkNw8WNMdWffX18/tw1vzRczRXtiH7wk9/KBQNorTb5d9qvtxBSM60Qh
         FJUYLXVNyPQkgtDNczWhcrndN8SpZcjXC8HYuRKaqR0GzBewX39U85TXxNEaKOo0ant1
         38DNUbXsziHFJZETnNE5s6ooMh4ijGD1y6ZzlAnI6fB5TzWB7Vy/FEtLLwGUJdvYLez2
         pMVmL/zmldc7z60WaSg3HdInABJGb10Rqmr6JUx9Z+sGUeh3MOPRcUIleBmAFFgrv6u+
         v/yi+4jSvyqoVZFwmF5+N3rpXqi8BRZXettBdjtXJ5HVwTOcHdYoU+NLHgq5VJzW6Rw8
         6L3g==
X-Gm-Message-State: AOAM532B09ZeJYRmI09U7omv5U5406I3hG+d5CnsGGJJ8thyrJObi0pp
        8gXwS7jGitaBOWwryf2wN+GREHSD7UX59v7hCvU=
X-Google-Smtp-Source: ABdhPJz6YWgzSycmbpjkXtT+LEG5J7S9lcSs8/DHkXG9U598pZOyrTWbh6szeBXF5lZboxNFmHJcd8oMTgLqnWwx++U=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr6095641ybe.403.1604607272664;
 Thu, 05 Nov 2020 12:14:32 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <87zh3xv04o.fsf@toke.dk>
 <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net> <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com> <87ft5ovjz5.fsf@toke.dk>
In-Reply-To: <87ft5ovjz5.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 12:14:21 -0800
Message-ID: <CAEf4BzZh90FY4V+8uAgScb6rmk0r9cpSfidvM+xEGWzF129cTA@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 2:24 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > Some of the most important APIs of libbpf are, arguably,
> > bpf_object__open() and bpf_object__load(). They accept a BPF ELF file,
> > do some preprocessing and in the end load BPF instructions into the
> > kernel for verification. But while API doesn't change across libbpf
> > versions, BPF-side code features supported changes quite a lot.
>
> Yes, which means that nothing has to change in iproute2 *at all* to get
> this; not the version, not even a rebuild: just update the system
> libbpf, and you'll automatically gain all these features. How is that an
> argument for *not* linking dynamically? It's a user *benefit* to not
> have to care about the iproute2 version, but only have to care about
> keeping libbpf up to date.
>
> I mean, if iproute2 had started out by linking dynamically against
> libbpf (setting aside the fact that libbpf didn't exist back then), we
> wouldn't even be having this conversation: In that case its support for
> new features in the BPF format would just automatically have kept up
> along with the rest of the system as the library got upgraded...
>

I think it's a difference in the perspective.

You are seeing iproute2 as an explicit proxy to libbpf. Users should
be aware of the fact that iproute2 just uses libbpf to load whatever
BPF ELF file user provides. At that point iproute2 versions almost
doesn't matter. Whatever BPF application users provide (that rely on
iproute2 to load it) should still be very conscious about libbpf
version and depend on that explicitly.

I saw it differently. For me, the fact that iproute2 is using libbpf
is an implementation detail. User developing BPF application is
providing a BPF ELF file that follows a de facto BPF "spec" (all those
SEC() conventions, global variables, map references, etc). Yes, that
"spec" is being driven by libbpf currently, but libbpf is not the only
library that supports it. Go BPF library is trying to keep up and
support most of the same features. So in that sense, iproute2 is
another BPF loader, just like Go library and libbpf library. The fact
that it defers to libbpf should be not important to the end user. With
that view, if a user tested their BPF program with a specific iproute2
version, it should be enough.

But clearly that's not the view that most people on this thread hold
and prefer end users to know and care about libbpf versioning
explicitly. That's fine.

But can we at least make sure that when libbpf is integrated with
iproute2, it specifies the latest libbpf (v0.2) as a dependency?


> -Toke
>
