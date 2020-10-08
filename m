Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0602C287B51
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgJHR76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgJHR75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:59:57 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1884C061755;
        Thu,  8 Oct 2020 10:59:55 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id b138so2871987yba.5;
        Thu, 08 Oct 2020 10:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6njneO7slKj5/+PMT+PB84NeoG+y8vzhAQwBKhkl3W8=;
        b=PSkLaVGXzzVjeXXjx1PHLFwPcSe1HGGkAt55mSQ1O5sI7Jx4VY8/aZDMvkIXdBNrdX
         sgdFPqxfisAD+ysTgJCfLCYBACHXxV4e5mb0uT3iWCwcx/k4yM2zGGA6l8recMfnRt5l
         CP1UaO8vcE6mROqlcBXx/26EyV+RfHbuOae8IA2SrJwh+7Sk0GMTbZG+7d/0efEPiljc
         4ZHb5CuvILlVvKru1zI06gG99vFxXFJ7WElKq6AQgCfcBN4R978Ps84RCiIVQ4cl4z5Z
         N1wIWylUHvVu+zSATK+WPolNb4GT/K8tSl+z+u3/9rdDA/9VFqCDPfmF6pOfxeQzgoFW
         3lUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6njneO7slKj5/+PMT+PB84NeoG+y8vzhAQwBKhkl3W8=;
        b=bDW1Z7hN8I8kdUgSy4V0n8qG3Axh1/kMfkp/4NE7BOknJ2sxcnoOV+qu7TtLe7Rqc5
         k3C2ZQNx48hQO3grADx66NLkvu/OaPvNXG8Fle5zPpvqZk+mWYwHuajkQ/Nebac+XJSI
         k7S16poNs/knrwn0LmFWizds93nLESWNSmwtsHpAVLQSN+Ekh8nA0ARGFoKe0FkZ2+h4
         QOe6ZO/7MFQtj52SSzItChFGRjBoEM0J3pY+2o9fm2uDtt7h8o8mJHGJYFF58K2ipegk
         quxB/YwTB+kvf383E+HIR3RBP2ijRHULPxCaHYLvDyJvesjCBMY9VG8p8AAfPTZ8AtP2
         x+OQ==
X-Gm-Message-State: AOAM531QeOuvXEN6A+HSYC3e5+E2hWGHM8PPqXDQrdzNcrA3UWdgoxbA
        +zmpoxRTvDeoP+HKwqQnxf1QbXPMuORFDPMCAks=
X-Google-Smtp-Source: ABdhPJzonQjnJ/NIGKZvf5cFO2VayxaAzMpGI3PmM0jpSBZce8cuuWa1Rc0qC/0LCqonl5k0Ac1eljj/M4Xe2oRYjhQ=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr2882035ybe.403.1602179995090;
 Thu, 08 Oct 2020 10:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201002010633.3706122-1-andriin@fb.com> <CAKQ-crhUT07SXZ16NK4_2RtpNA+kvm7VtB5fdo4qSV4Qi4GJ_g@mail.gmail.com>
 <CAEf4Bzb7kE5x=Ow=XHMb1wmt0Tjw-qqoL-yihAWx5s10Dk9chQ@mail.gmail.com> <CAKQ-crhMomcb9v3LAnqrBFLp1=m8bh4ZBnD7O_oH2XsU2faMAg@mail.gmail.com>
In-Reply-To: <CAKQ-crhMomcb9v3LAnqrBFLp1=m8bh4ZBnD7O_oH2XsU2faMAg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Oct 2020 10:59:44 -0700
Message-ID: <CAEf4BzYByy8DZz+nB6RcAgRytXLRjWfM=_xBJRF2+jfxsFVdog@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] libbpf: auto-resize relocatable LOAD/STORE instructions
To:     Luka Perkov <luka.perkov@sartura.hr>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Oreskovic <luka.oreskovic@sartura.hr>,
        Sven Fijan <sven.fijan@sartura.hr>,
        David Marcinkovic <david.marcinkovic@sartura.hr>,
        Jakov Petrina <jakov.petrina@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 3:34 AM Luka Perkov <luka.perkov@sartura.hr> wrote:
>
> Hello Andrii,
>
> On Wed, Oct 7, 2020 at 8:01 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Oct 7, 2020 at 10:56 AM Luka Perkov <luka.perkov@sartura.hr> wrote:
> > >
> > > Hello Andrii,
> > >
> > > On Fri, Oct 2, 2020 at 3:09 AM Andrii Nakryiko <andriin@fb.com> wrote:
> > > > Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, 4-,
> > > > 8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE field
> > > > offset relocation associated with it. In practice this means transparent
> > > > handling of 32-bit kernels, both pointer and unsigned integers. Signed
> > > > integers are not relocatable with zero-extending loads/stores, so libbpf
> > > > poisons them and generates a warning. If/when BPF gets support for sign-extending
> > > > loads/stores, it would be possible to automatically relocate them as well.
> > > >
> > > > All the details are contained in patch #1 comments and commit message.
> > > > Patch #2 is a simple change in libbpf to make advanced testing with custom BTF
> > > > easier. Patch #3 validates correct uses of auto-resizable loads, as well as
> > > > check that libbpf fails invalid uses.
> > > >
> > > > I'd really appreciate folks that use BPF on 32-bit architectures to test this
> > > > out with their BPF programs and report if there are any problems with the
> > > > approach.
> > > >
> > > > Cc: Luka Perkov <luka.perkov@sartura.hr>
> > >
> > > First, thank you for the support and sending this series. It took us a
> > > bit longer to run the tests as our target hardware still did not fully
> > > get complete mainline support and we had to rebase our patches. These
> > > are not related to BPF.
> > >
> > > Related to this patch, we have tested various BPF programs with this
> > > patch, and can confirm that it fixed previous issues with pointer
> > > offsets that we had and reported at:
> > >
> > > https://lore.kernel.org/r/CA+XBgLU=8PFkP8S32e4gpst0=R4MFv8rZA5KaO+cEPYSnTRYYw@mail.gmail.com/.
> > >
> > > Most of our programs now work and we are currently debugging other
> > > programs that still aren't working. We are still not sure if the
> > > remaining issues are related to this or not, but will let you know
> > > sometime this week after further and more detailed investigation.
> > >
> >
> > Ok, great, thanks for the update.
>
> Just to update you that we have identified that the problem was a
> known issue with JIT as we had enabled the BPF_JIT_ALWAYS_ON.
>
> That said, it would be great to see this series included in 5.10 :)

This is purely a libbpf feature, completely agnostic to kernel
versions. So you'll get this with upcoming libbpf 0.2.0 release.

>
> Thanks,
> Luka
