Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71113D86E1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 06:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhG1EtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 00:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhG1EtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 00:49:16 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D47C061757;
        Tue, 27 Jul 2021 21:49:14 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u20so1609911ljo.0;
        Tue, 27 Jul 2021 21:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bWbRi1rMmK5hcUgOMCErZOOpaayl8qYdTbOgj40N92A=;
        b=XxtLohpOSQF8FB06GYhe52yf2P6kyqltj5BdiXgnpGnrj/42X7y10Ok8jJa4mS+fAY
         F1peZcGUa6uWOxNEV4xFctUuGv5EidCFtftYu1Fhrs/iU4SAkYCj3LlSJVIEijzVvciY
         yoCmAOq/K+wb24Ui2jXRqDLcfm900yrmhaFx5iZQ+t54dbGzrCS2/uzM3BkIzRsHeNwe
         n4D1pe9WdHya2N6ZJE/wsaxeYVrYYfBGqeKSCLfbMbhThxYEK0m8p0tLf0Gm+0xG9bwS
         pLZ3Tc0i1KCb9NqUGqLXI0b9lgnIAppNairuFu0lcdygCyAS3T6WmYejKI4kTLSeuacL
         8jQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWbRi1rMmK5hcUgOMCErZOOpaayl8qYdTbOgj40N92A=;
        b=JUUKzUmGRuiem8CzRDuxrs/JDD9SQ9pIkxPDNHhE/ztdXWrCAZZAOQtRfVpPAtcaKl
         th2UojwynIbU5NRhAfdaKXybQ+nY/lLx2rotJUJUBEkx9FCY+50vpDbXQy0QMD5+LJn2
         oriCc2RKSH/SBFOuuf17lPClpJLKIVnuZAacpZV4HiFBTl76/9zGTpeahMtmOTR1PZaw
         FvuslO+9cUoxwncGghJRHRIFKTo4hVRooy/lwLDs+Ri03OgGs/tZcYTR2SbiljIPpYHm
         FUm4cwPlMblo/Xtq2aKs/IunLziwQ7a7tK8d+IzJmOKwOD/FBIMxQmzjKs/ftk2EGDaT
         4m7A==
X-Gm-Message-State: AOAM532eCdq5Ilrizs3238n2XPccGQfVW6gLGESMPQPbt5d+xPhnZimu
        EMStEGUReFhPXoSou14JS334hc5k3RVfFSeEB2M=
X-Google-Smtp-Source: ABdhPJxqa27hXo4TlHher1pDVU8cEOZXuqFB2PBMQy/OZFFhzaaGgLidPy486YcJ6Qk8tm8fxq52Zy0Ta7aapDxcf+M=
X-Received: by 2002:a2e:7817:: with SMTP id t23mr17374907ljc.486.1627447752902;
 Tue, 27 Jul 2021 21:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com> <CAEf4Bza3nAgUVdaP6sh9XG4oMdawCp55UeAB3Lgjf9opCw_UnA@mail.gmail.com>
In-Reply-To: <CAEf4Bza3nAgUVdaP6sh9XG4oMdawCp55UeAB3Lgjf9opCw_UnA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 27 Jul 2021 21:49:01 -0700
Message-ID: <CAADnVQ+4j1snfhygHh6=+y9-Rb52iKewP5qoQ54WX85kZN5qCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: Move CO-RE logic into separate file.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 12:38 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jul 20, 2021 at 5:08 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Split CO-RE processing logic from libbpf into separate file
> > with an interface that doesn't dependend on libbpf internal details.
> > As the next step relo_core.c will be compiled with libbpf and with the kernel.
> > The _internal_ interface between libbpf/CO-RE and kernel/CO-RE will be:
> > int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
> >                              int insn_idx,
> >                              const struct bpf_core_relo *relo,
> >                              int relo_idx,
> >                              const struct btf *local_btf,
> >                              struct bpf_core_cand_list *cands);
> > where bpf_core_relo and bpf_core_cand_list are simple types
> > prepared by kernel and libbpf.
> >
> > Though diff stat shows a lot of lines inserted/deleted they are moved lines.
> > Pls review with diff.colorMoved.
> >
> > Alexei Starovoitov (4):
> >   libbpf: Cleanup the layering between CORE and bpf_program.
> >   libbpf: Split bpf_core_apply_relo() into bpf_program indepdent helper.
> >   libbpf: Move CO-RE types into relo_core.h.
> >   libbpf: Split CO-RE logic into relo_core.c.
> >
>
> LGTM. Applied to bpf-next, fixed typo in patch 3 subject, and also
> made few adjustments. Let me know if you object to any of them:
>
> 1. I felt like the original copyright year should be preserved when
> moving code into a new file, so I've changed relo_core.h's year to
> 2019. Hope that's fine.
> 2. relo_core.c didn't have a Copyright line, so I added the /*
> Copyright (c) 2019 Facebook */ as well.
> 3. I trimmed down the list of #includes in core_relo.c, because most
> of them were absolutely irrelevant and just preserved as-is from
> libbpf.c Everything seems to compile just fine without those.

Thanks! Much appreciate it.
It was on my todo list. I lazily copy-pasted them to avoid
accidental breakage on some archs that I don't have access to
(since I didn't wait for the kernel build bot to process them before I
sent them).
fyi intel folks can include your private tree as well, so you'd have to respin
your patches due to odd 32-bit build breakage. Just email them with
your git tree location.
