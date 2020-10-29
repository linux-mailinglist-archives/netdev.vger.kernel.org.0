Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1002529E4A3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgJ2Hkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgJ2HYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:54 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3554AC0613D6;
        Wed, 28 Oct 2020 19:51:03 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id c129so939391yba.8;
        Wed, 28 Oct 2020 19:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFNTNQYbRyOv5NmpjKO5OIDkrgD4q/4HyFQbZpD9rio=;
        b=Sz3ZR9ETd2kV4vxHW3jXQvbFLBr+/gNd8lV4FkSGC8RQACO3bRIqVuJyqeqCF3w0Zu
         diFYbTQJwT5/x9Tj8qO+qWlVy1iMBrWF6LCV+54pm11ww8siqo/F216uszvvTdxpv+UF
         i7pYyT8qkJGPwEG5sKAIi0hDe/hxWcYaKs1rfJ/JQNEFu7YihXOmLJtvLoe1IfnUR5Zm
         9mIReXtEjB5QAtLn4uGKmUCX83pc0/mNxTvmeBoV0Yr4brgMPi51H+2gnUuv0xDxvDTZ
         gL11sW1ciW+fYidRsNmeVypZUACQFcj950Usl8Tj1C8hywMeic8KyYigDpIVMFZR/b0D
         N+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFNTNQYbRyOv5NmpjKO5OIDkrgD4q/4HyFQbZpD9rio=;
        b=bPbF8ENVQ7Fgc7yljSv6MYbAYzRiVL2zHcUILyaVub5RihAjtXwkDr30TacbekSY9f
         cLCoxRjcfRMsa96ovIc8MmcFzlZ+vWiQzSK4z0Nq1FaBkSMwv42hWrxFrt/k1kC9JliV
         3SWRGhgg5tbk7y3K18r87eDS4vLH2iaVbiughr9iTMnmgcryFxMFs75muHWblmnRimiJ
         CqWeYNPGsWSXJToX6UbyE1+P4NRFjUyWsxidLaDh1BlxZgxVK/hYPiw1cwyM8wauxC9e
         5TcFxqiGq5GzNX+z7k4TKLZxhCyGMjyw97M6cLbhAWTFMjw+7LzWJHFwtM/DaTiTb7Ul
         AgUw==
X-Gm-Message-State: AOAM53188jEHpk1y+U0SX7F6Eg/bHFeCW5cbnw6W9zaXAm1MbpihiSji
        op5PzExFuhLvm7r0zWTZSLasU9ncTDTPYI+q/q8=
X-Google-Smtp-Source: ABdhPJzNjJWkIUjdzJJFAiK/Djvk8G351SdeQVAcdMClEbbFFEmkOxxD14nzc/iZg96DlvalpxCnyrKtP+wUdZ6QhDU=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr3129912ybe.403.1603939862400;
 Wed, 28 Oct 2020 19:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033855.3894509-1-haliu@redhat.com> <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com> <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com> <20201028193438.21f1c9b0@hermes.local>
In-Reply-To: <20201028193438.21f1c9b0@hermes.local>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Oct 2020 19:50:51 -0700
Message-ID: <CAEf4BzY1gz2fR0DXOYgbheDArdYhWA66YRFuy=xMRveHTx=VVQ@mail.gmail.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>,
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

On Wed, Oct 28, 2020 at 7:34 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 28 Oct 2020 19:27:20 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:
> > >
> > > On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
> > > > fails to compile on Ubuntu 20.10:
> > > >
> > > > root@u2010-sfo3:~/iproute2.git# ./configure
> > > > TC schedulers
> > > >  ATM  yes
> > > >  IPT  using xtables
> > > >  IPSET  yes
> > > >
> > > > iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
> > > > libc has setns: yes
> > > > SELinux support: yes
> > > > libbpf support: yes
> > > > ELF support: yes
> > > > libmnl support: yes
> > > > Berkeley DB: no
> > > > need for strlcpy: yes
> > > > libcap support: yes
> > > >
> > > > root@u2010-sfo3:~/iproute2.git# make clean
> > > >
> > > > root@u2010-sfo3:~/iproute2.git# make -j 4
> > > > ...
> > > > /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
> > > > bpf_libbpf.c:(.text+0x3cb): undefined reference to
> > > > `bpf_program__section_name'
> > > > /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
> > > > `bpf_program__section_name'
> > > > /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
> > > > `bpf_program__section_name'
> > > > collect2: error: ld returned 1 exit status
> > > > make[1]: *** [Makefile:27: ip] Error 1
> > > > make[1]: *** Waiting for unfinished jobs....
> > > > make: *** [Makefile:64: all] Error 2
> > >
> > > You need to update libbpf to latest version.
> >
> > Why not using libbpf from submodule?
>
> Because it makes it harder for people downloading tarballs and distributions.

Genuinely curious, making harder how exactly? When packaging sources
as a tarball you'd check out submodules before packaging, right?

> Iproute2 has worked well by being standalone.

Again, maybe I'm missing something, but what makes it not a
standalone, if it is using a submodule? Pahole, for instance, is using
libbpf through submodule and just bypasses all the problems with
detection of features and library availability. I haven't heard anyone
complaining about it made working with pahole harder in any way.

>
> Want to merge libbpf into iproute2??

No... How did you come to this conclusion?..

>
>
