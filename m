Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39F1A8A1C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504362AbgDNSr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504355AbgDNSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:47:51 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA6AC061A0C;
        Tue, 14 Apr 2020 11:47:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id t3so10666905qkg.1;
        Tue, 14 Apr 2020 11:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tCuiB+gxxLKMAeEwRtqlDEJRt4BXHAF5hJLpYf4AJtA=;
        b=r0kopZ9c3nuyFV9DshoKGWDwPFtGoVTmBNVorsSHW9UMQrbcu+Pi445YYYSmKu6DGA
         fj1dJH/nP5wZir21R4rRyP489R2mBEcP6YME//dEbuyV44OdYnYsnHHuLTYSstgo7pAw
         /+zIoUCyl5qUBTIKyIi5pikSlyN5I07W02sJIZeymeqjJ5GLtBnoWYFoKHRIsmapdASy
         76gOTLxlgKY0+ps8nerQJVYCgq+YzOJ3EogroXzcDCx2pK4Fpy5CDJj9J+3sNgSHqyQi
         xO70mJPS0TKWCeUolL3tGBDTG90irddTgtq9l6DuyBNLLKZ7XAACmIoIv0dKWTYghAQY
         /K7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tCuiB+gxxLKMAeEwRtqlDEJRt4BXHAF5hJLpYf4AJtA=;
        b=HHQyRwIK1CJX2r57RE/MrWXr/Si/XeibI+m6CtUIDRro46QkH11JRshmkJVjyTy5KR
         /ZRNFk9nP0MYuL2erWCZsDnr44zsXtj9ux5mzdxrp0fmKxMPPZOgvw3nPtW+I/8HDeN3
         aT5e9OWFo93+zXh16M8evWgCqvhc0SrXpcpve0GA1zLI+KhUZDI8ySl/9J4m/bovtCCM
         ZISIvUbDfy4g+LWcGXWpijX+mtccvulJqHMUWgZtGoSoJk8DxYednHYPbAA9gcDMyD0Q
         xFP/nJt+t4EyOMQMwbNbKh2Xh7s6Uw5aVmggLVdJxfsAfWIo1kXFOQ2lRwfLxMZdN5F3
         u41g==
X-Gm-Message-State: AGi0PubcAyaTPMso+v5Mu964W58o686PvpJD1l5Y3mU3bk0KG08B6Qq3
        Qe4yx+mke4TXA5SvWsrT1m0l3Non3qIrT8QDTZI=
X-Google-Smtp-Source: APiQypL9aTkmA8mTEsFBOtyNEDICzLuM4NGuJ9oLKZTYL68bn5lRj6zekK5F97BM7gz6A8w05X1k+fT5D7HjmOCb/ww=
X-Received: by 2002:ae9:eb8c:: with SMTP id b134mr7744373qkg.39.1586890068495;
 Tue, 14 Apr 2020 11:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com>
 <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com>
 <877dyq80x8.fsf@toke.dk> <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com>
 <87tv1t65cr.fsf@toke.dk> <CAEf4BzbXCsHCJ6Tet0i5g=pKB_uYqvgiaBNuY-NMdZm8rdZN5g@mail.gmail.com>
 <87mu7enysb.fsf@toke.dk>
In-Reply-To: <87mu7enysb.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Apr 2020 11:47:37 -0700
Message-ID: <CAEf4BzZtJo5dKMX_ys_2rN+bx6QqDGz9DAEVFod6Ys9Rs93VgA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and
 GET_NEXT_ID for bpf_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 3:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> >> > After that, one can pin bpf_link temporarily and re-open it as
> >> > writable one, provided CAP_DAC_OVERRIDE capability is present. All
> >> > that works already, because pinned bpf_link is just a file, so one c=
an
> >> > do fchmod on it and all that will go through normal file access
> >> > permission check code path.
> >>
> >> Ah, I did not know that was possible - I was assuming that bpffs was
> >> doing something special to prevent that. But if not, great!
> >>
> >> > Unfortunately, just re-opening same FD as writable (which would
> >> > be possible if fcntl(fd, F_SETFL, S_IRUSR
> >> >  S_IWUSR) was supported on Linux) without pinning is not possible.
> >> > Opening link from /proc/<pid>/fd/<link-fd> doesn't seem to work
> >> > either, because backing inode is not BPF FS inode. I'm not sure, but
> >> > maybe we can support the latter eventually. But either way, I think
> >> > given this is to be used for manual troubleshooting, going through f=
ew
> >> > extra hoops to force-detach bpf_link is actually a good thing.
> >>
> >> Hmm, I disagree that deliberately making users jump through hoops is a
> >> good thing. Smells an awful lot like security through obscurity to me;
> >> and we all know how well that works anyway...
> >
> > Depends on who users are? bpftool can implement this as one of
> > `bpftool link` sub-commands and allow human operators to force-detach
> > bpf_link, if necessary.
>
> Yeah, I would expect this to be the common way this would be used: built
> into tools.
>
> > I think applications shouldn't do this (programmatically) at all,
> > which is why I think it's actually good that it's harder and not
> > obvious, this will make developer think again before implementing
> > this, hopefully. For me it's about discouraging bad practice.
>
> I guess I just don't share your optimism that making people jump through
> hoops will actually discourage them :)

I understand. I just don't see why would anyone have to implement this
at all and especially would think it's a good idea to begin with?

>
> If people know what they are doing it should be enough to document it as
> discouraged. And if they don't, they are perfectly capable of finding
> and copy-pasting the sequence of hoop-jumps required to achieve what
> they want, probably with more bugs added along the way.
>
> So in the end I think that all you're really achieving is annoying
> people who do have a legitimate reason to override the behaviour (which
> includes yourself as a bpftool developer :)). That's what I meant by the
> 'security through obscurity' comment.

Can I please get a list of real examples of legitimate reasons to
override this behavior?

>
> -Toke
>
