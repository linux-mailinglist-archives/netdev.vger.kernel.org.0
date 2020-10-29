Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F40529E430
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgJ2Hfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgJ2HY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:56 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE7EC0613D4;
        Wed, 28 Oct 2020 19:46:49 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h196so949979ybg.4;
        Wed, 28 Oct 2020 19:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fABtmEv4epg3sR+yL6QGcoJXHUHo9G2azV/Jbl517G8=;
        b=MQQ9pRPma+JuxAjBmR7Gor4oqCqHPKcmoRPHH4Kpvucj9Wje3Cq4fF/91i3PYER7bg
         9VIkXxBnQYzM5Z7AQVOoHgK9GmNFHCE/FkgzLcEIBHA58OPKRnr7nAyuuSDjPOGPHPFO
         oKamzZuuMx2VvVxSw3veS5/FyHxgJB++9np66FAEtnIwTDhy+03Y9v6jKzTf32NdmO2F
         Kke+iJQWIP4HIZAHbxk0bG99dDHZKg1NwCp+gSrFpphvfnKAFRuBCMw5C6qiZa6GUSIe
         FXedfx0GfNYQRP1nx7jxDdrZ3ofnsAGN3Xwm1nmDc0WRMCzbGOPKtRPlTc1PybVYb4Qk
         isdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fABtmEv4epg3sR+yL6QGcoJXHUHo9G2azV/Jbl517G8=;
        b=ncA9dNFLRONaHiUZ7iNr8XDf/893yZRxpNQyLXUJWCnZ2ZgpQyNnVt1zfVwLUJAYBv
         STrlIPY8s71GnCkxYXUtW0f5qToiq1+cy27JbWk9Muf2//XchdFfyqaUgCEM7I1egDa5
         3xNm6mT7zaQV4n2Uts8ZMLvQogEuI9kys7dZYkVqUg1kZs2pxqg6rLfW+b/iC2Dc00mT
         vT4hE7XOXsy+OJPFAgm/AzHR7CtseYoSsu2lUDhKRVKfc6N843kP+7x5mBADff4pImNA
         CxMtj8OIJKEmvvWK1Q4QawFjafklPx5FNs3GiRWac8gVl68qGOPwFCqXqAudH+e10U/W
         kScQ==
X-Gm-Message-State: AOAM532hM1p/6ed/HUfb7xSzXCiI9oDKrmeSbN5RlgOOxu7DOh0r1WCU
        lBhUVb1dyx8JYCdiNRR6YQBQP6ioW5juAYvtgQM=
X-Google-Smtp-Source: ABdhPJxnXLGTM5MpZq+oFYWhzCvrNSw1tMMRNaXrk0zKK9jtDdlQbwb59XmaAmJiKG4qsQDVQU3y0VjFo/9Yy5uMOJA=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr3113487ybe.403.1603939609041;
 Wed, 28 Oct 2020 19:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033855.3894509-1-haliu@redhat.com> <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com> <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com> <b17e7428-dd99-09f8-7254-c61d25a0c797@gmail.com>
In-Reply-To: <b17e7428-dd99-09f8-7254-c61d25a0c797@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Oct 2020 19:46:38 -0700
Message-ID: <CAEf4BzacgsZiXQJPM=j_cKW=3pF8Kwx=JvY9FjMgvJ1HzfyVAA@mail.gmail.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 7:33 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/28/20 8:27 PM, Andrii Nakryiko wrote:
> > On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:
> >>
> >> On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
> >>> fails to compile on Ubuntu 20.10:
> >>>
> >>> root@u2010-sfo3:~/iproute2.git# ./configure
> >>> TC schedulers
> >>>  ATM  yes
> >>>  IPT  using xtables
> >>>  IPSET  yes
> >>>
> >>> iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
> >>> libc has setns: yes
> >>> SELinux support: yes
> >>> libbpf support: yes
> >>> ELF support: yes
> >>> libmnl support: yes
> >>> Berkeley DB: no
> >>> need for strlcpy: yes
> >>> libcap support: yes
> >>>
> >>> root@u2010-sfo3:~/iproute2.git# make clean
> >>>
> >>> root@u2010-sfo3:~/iproute2.git# make -j 4
> >>> ...
> >>> /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
> >>> bpf_libbpf.c:(.text+0x3cb): undefined reference to
> >>> `bpf_program__section_name'
> >>> /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
> >>> `bpf_program__section_name'
> >>> /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
> >>> `bpf_program__section_name'
> >>> collect2: error: ld returned 1 exit status
> >>> make[1]: *** [Makefile:27: ip] Error 1
> >>> make[1]: *** Waiting for unfinished jobs....
> >>> make: *** [Makefile:64: all] Error 2
> >>
> >> You need to update libbpf to latest version.
> >
> > Why not using libbpf from submodule?
> >
>
> no. iproute2 does not bring in libmnl, libc, ... a submodules. libbpf is
> not special. OS versions provide it and it needs to co-exist with packages.

Not saying libbpf is special, but libbpf is a fast moving target right
now, so it's pragmatic to have it as submodule, because if you'd like
to use some latest functionality, you won't have to add all the
conditional compilation shenanigans to detect every single new API
you'd like to use from libbpf. And libbpf is pretty small to not worry
about saving memory through a shared library.

But it's up to you guys, of course.
