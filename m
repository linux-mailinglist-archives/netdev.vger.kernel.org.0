Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF71143C12F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 06:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhJ0EPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 00:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhJ0EPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 00:15:08 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C785EC061570;
        Tue, 26 Oct 2021 21:12:43 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id d204so3069119ybb.4;
        Tue, 26 Oct 2021 21:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3gpq8GYijA5zR6LY7HJFtXt2EpxHHNzVSt/bs4ryc1c=;
        b=mP+HX1JQ90QOtK4mmihkOyg6H/+XvHO74h1I9h/ruOI0l1vWsO/Y99nVI8In2VFOid
         UXC+nkj1yfKzodC8Ux3NWKpE6dQelc8NeFVmlGbBK2J88Cl3SidpnGp+yjChO6XVqsvK
         zfuiiejIoAWZlkLurh7ODaE78YGLybMqMWAV0mxy7I7n/Z8jqmrQEAuByA56uPUQKgfx
         b8mj/DtMZpej6yQUz+EVHsrVoi87q8ighmNm55U8+eLGBt4iOCNovzWsTLqVEedfExdk
         oOISxAC3QOsFnWdXMwcbhsv6YKVGImjmV6C3H7mzYumlzyJYc8fvb2z+hAXrUzy+q+bf
         g6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3gpq8GYijA5zR6LY7HJFtXt2EpxHHNzVSt/bs4ryc1c=;
        b=tmXdanASXoFjAVkPkNxMgyF2iCrXJPgcDAeQqeTS0HzPNX/7chl8qHVqJ5yGW0EWUb
         o34RuW+MctjLGuYYCuHnBAZCeN5nvLCnGyUAP0aAN90yYzTJvVQAmCYKYljz4geh5U9R
         foZju0pcHAhQRrJkDBsHNcefTCInRLsaIQN5RI7L1dfXioJviDH/aqSmpOJDmeO4eD1S
         Srf8HsvIGzsPBmv7dA0Kxnm+bGgMRnA1v3Zc0oIPicUG6dsYmDbY3A6Ej3TCg2RIPXbG
         XiKjnQEYgLahEZeYPOjTTyM83826ImGDWXRX2qGsB46LHzAC9P8jTNqD3ZdGPoywn8SQ
         l44A==
X-Gm-Message-State: AOAM533aozRPE4cegMvNU3VHKizO3cTKrFaXDSNKuAAsMxO0crHvQh7E
        EWMXq8XUzeteidNZ/XrMkcdvsplU2Uh2NEcpV4Y=
X-Google-Smtp-Source: ABdhPJwKBdNdbWWHB04e8K/wevSHjHWNRMBoTCt2QQ7U/TQfSZnNrGOFkiw3ZNYNpPc9rdC4HRtXrVWBB1OQmHVr/Zs=
X-Received: by 2002:a25:cf50:: with SMTP id f77mr15192395ybg.114.1635307962936;
 Tue, 26 Oct 2021 21:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211023120452.212885-1-jolsa@kernel.org> <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava>
In-Reply-To: <YXfulitQY1+Gd35h@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Oct 2021 21:12:31 -0700
Message-ID: <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > hi,
> > > I'm trying to enable BTF for kernel module in fedora,
> > > and I'm getting big increase on modules sizes on s390x arch.
> > >
> > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > from kernel-core and kernel-module packages:
> > >
> > >                current   new
> > >       aarch64      60M   76M
> > >       ppc64le      53M   66M
> > >       s390x        21M   41M
> > >       x86_64       64M   79M
> > >
> > > The reason for higher increase on s390x was that dedup algorithm
> > > did not detect some of the big kernel structs like 'struct module',
> > > so they are duplicated in the kernel module BTF data. The s390x
> > > has many small modules that increased significantly in size because
> > > of that even after compression.
> > >
> > > First issues was that the '--btf_gen_floats' option is not passed
> > > to pahole for kernel module BTF generation.
> > >
> > > The other problem is more tricky and is the reason why this patchset
> > > is RFC ;-)
> > >
> > > The s390x compiler generates multiple definitions of the same struct
> > > and dedup algorithm does not seem to handle this at the moment.
> > >
> > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > >   http://people.redhat.com/~jolsa/kmodbtf/
> > >
> > > Please let me know if you'd like to see other info/files.
> > >
> >
> > Hard to tell what's going on without vmlinux itself. Can you upload a
> > corresponding kernel image with BTF in it?
>
> sure, uploaded
>

vmlinux.btfdump:

[174] FLOAT 'float' size=4
[175] FLOAT 'double' size=8

VS

pnet.btfdump:

[89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
[89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)


> jirka
>
> >
> > > I found code in dedup that seems to handle such situation for arrays,
> > > and added 'some' fix for structs. With that change I can no longer
> > > see vmlinux's structs in kernel module BTF data, but I have no idea
> > > if that breaks anything else.
> > >
> > > thoughts? thanks,
> > > jirka
> > >
> > >
> > > ---
> > > Jiri Olsa (2):
> > >       kbuild: Unify options for BTF generation for vmlinux and modules
> > >       bpf: Add support to detect and dedup instances of same structs
> > >
> > >  Makefile                  |  3 +++
> > >  scripts/Makefile.modfinal |  2 +-
> > >  scripts/link-vmlinux.sh   | 11 +----------
> > >  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
> > >  tools/lib/bpf/btf.c       | 12 ++++++++++--
> > >  5 files changed, 35 insertions(+), 13 deletions(-)
> > >  create mode 100755 scripts/pahole-flags.sh
> > >
> >
>
