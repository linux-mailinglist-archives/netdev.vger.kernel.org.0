Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7988D1F8130
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 07:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgFMF6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 01:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgFMF6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 01:58:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6D4C03E96F;
        Fri, 12 Jun 2020 22:58:11 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b27so11123800qka.4;
        Fri, 12 Jun 2020 22:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ooC6zDR4D9kUn0XYJNEVpFCkJ4RWM1cROne2/QW99bw=;
        b=CXQ7IV7TIiEHNbDNvhZmY0SMeldOfH/MJdWYNQaFNLIUBdFbqeNnLSuzYfLeJMN4HO
         8gsxX0QRFq9bIeUjfzZfZZc4j1/MAV0xV33rgAD+2xcIBAqzeHMMwZiBPpYeDQzZe7wz
         1llbBQIinq+NLpjaGEFNT32Jry/c+4eaiIN7Ky2AiSRkGcN/3Euoa76wjK4UgKl8aWKa
         3R3HijAfSH/+7ed7iCha7CVxtzOHTKdOBju7q8pok3a2qldlC9zsBlj674fbsRckqE15
         97S1Cx3j519AS1csowGpJZL5i2DVTPPI0KWaAOXPYR0Fj4Y/SMyenzDNV5FgOYXatw9t
         2wHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooC6zDR4D9kUn0XYJNEVpFCkJ4RWM1cROne2/QW99bw=;
        b=EuUqKRC9ye9XH9cXTx95HFoQMO1lUvmAvFOMpj70F1+iPn/60gphm3g/FSAg0k+VJ3
         KlyUjNlsAUCQXU+KqNwDcaoQh3wXwspPNhyDIIgCaxF10PuOxTTtbhFC957qc1DuzJ74
         U+tKfcV9zr8XmvSJ6oUm6gPuY5+ck8L+X84fv7s3NOad/Hd/skp7JMAKZcuybDQV2YGy
         WltjsetQFjke5P4lbwALhqtFg3+28U/w2EWCY6XY/YQrq0WiENJY5F8G3MHXkzx2gL8k
         FMAwueGN+Z/hlE8io/+xpw8OC7yyqj0SjpIKDWSsMvKPPJHjvZ3pnVVJGh1l62M6+2P1
         4EDQ==
X-Gm-Message-State: AOAM5324mLPbCpWyeqmGSdzECr4A1c/Qhj0+/7Mt/9onmfk3zMK2eDH/
        K37Mc9WUGEGNwv5/GlIgQKpSZX8IJX4X2XH3r5s=
X-Google-Smtp-Source: ABdhPJzYcSdDs9GKpPp+/VbL8vTr1s6QD/8Id1USDo94Qg4iufIANplx6KVZr+wKynEyAQi/TKRBJncRyhWVlhq/vT4=
X-Received: by 2002:a37:a89:: with SMTP id 131mr6282241qkk.92.1592027890424;
 Fri, 12 Jun 2020 22:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-9-andriin@fb.com>
 <20200613034507.wjhd4z6dsda3pz7c@ast-mbp>
In-Reply-To: <20200613034507.wjhd4z6dsda3pz7c@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jun 2020 22:57:59 -0700
Message-ID: <CAEf4BzaHVRxkiDbTGashiuakXFBRYvDsQmJ0O08xFijKXiAwSg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 8/8] tools/bpftool: show PIDs with FDs open
 against BPF map/prog/link/btf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 8:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 12, 2020 at 03:31:50PM -0700, Andrii Nakryiko wrote:
> > Add bpf_iter-based way to find all the processes that hold open FDs against
> > BPF object (map, prog, link, btf). Add new flag (-o, for "ownership", given
> > -p is already taken) to trigger collection and output of these PIDs.
> >
> > Sample output for each of 4 BPF objects:
> >
> > $ sudo ./bpftool -o prog show
> > 1992: cgroup_skb  name egress_alt  tag 9ad187367cf2b9e8  gpl
> >         loaded_at 2020-06-12T14:18:10-0700  uid 0
> >         xlated 48B  jited 59B  memlock 4096B  map_ids 2074
> >         btf_id 460
> >         pids: 913709,913732,913733,913734
> > 2062: cgroup_device  tag 8c42dee26e8cd4c2  gpl
> >         loaded_at 2020-06-12T14:37:52-0700  uid 0
> >         xlated 648B  jited 409B  memlock 4096B
> >         pids: 1
> >
> > $ sudo ./bpftool -o map show
> > 2074: array  name test_cgr.bss  flags 0x400
> >         key 4B  value 8B  max_entries 1  memlock 8192B
> >         btf_id 460
> >         pids: 913709,913732,913733,913734
> >
> > $ sudo ./bpftool -o link show
> > 82: cgroup  prog 1992
> >         cgroup_id 0  attach_type egress
> >         pids: 913709,913732,913733,913734
> > 86: cgroup  prog 1992
> >         cgroup_id 0  attach_type egress
> >         pids: 913709,913732,913733,913734
>
> This is awesome.

Thanks.

>
> Why extra flag though? I think it's so useful that everyone would want to see

No good reason apart from "being safe by default". If turned on by
default, bpftool would need to probe for bpf_iter support first. I can
add probing and do this by default.

> this by default. Also the word 'pid' has kernel meaning or user space meaning?
> Looks like kernel then bpftool should say 'tid'.

No, its process ID in user-space sense. See task->tgid in
pid_iter.bpf.c. I figured thread ID isn't all that useful.

> Could you capture comm as well and sort it by comm, like:
>
> $ sudo ./bpftool link show
> 82: cgroup  prog 1992
>         cgroup_id 0  attach_type egress
>         systemd(1), firewall(913709 913732), logger(913733 913734)

Yep, comm is useful, I'll add that. Grouping by comm is kind of a
pain, though, plus usually there will be one process only. So let me
start with doing comm (pid) for each PID independently. I think that
will be as good in practice.
