Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E56C28729A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgJHKey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJHKex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:34:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F54C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 03:34:53 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dt13so7347662ejb.12
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 03:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xk1UawkGscrdgyTTdSmArkeO7Pere7VwZLuC1AwgAxQ=;
        b=YOHSLaz4bydXyJ7BWWL1O6Xcre8rBne+Xu+denGCa6Ya2ZB/qnacxBnhkqaLdFe3+5
         paGQZkYkjJcJmZH7LZmPdP8HUJCOi2/SXtgW4KtUfMkOH3HZQnALBmpt7/ljJ7MsBQ+8
         pmFaNw529K8cLy3AG8UBqP9O48VYPmCWVNn0vApt16v+kHWgwmxbKLGe68/pBOtKXr0f
         NTPpIQUcOMdM2oiEDXYBAJ+K7+RWW3wzISohZtWQ592FZzSoWlZHKBF6o5/rV5KiKq58
         dMMnhNNZlMlNSvb98HK/0cFQtKI1sptpfkU4G/kYwZF2VWLsy8Pk6uD65fkGNmWpMJsd
         Sw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xk1UawkGscrdgyTTdSmArkeO7Pere7VwZLuC1AwgAxQ=;
        b=Eoz7rBaho3yLf9wddXgKXLRamMW2sstbQTJNMRtHakvn5B5Lg192LgpVwPEA913N7u
         FVhfzha49gvzQgcvtleiOL24E/1vh3LSqKDo1PgVzV530jvEJC/f9/EUI5jo+DfayHFi
         EOomFb7ucjoApCpiwhQ+2iT0NG4HtHp/JYELTEs0DjX81JhpfxoNmFO5+iop8q2ap/JT
         M7Jk7w+znW568JLsW2peU4GvRmMeDHaxKF2hbg0Dqwt6m7pR4KvueAdXhUqLza643lSa
         hIl0/HsMqUXLdcY5iAe3dxnIRh+R1DHAplrRLR4S4hnE/aOedghaDe+dnYa4jAwhd10D
         ZmKg==
X-Gm-Message-State: AOAM531Dgip+qr2H2XMa5XXCPm2pmHWhZ2IPsur8jtBOr4OnbYLBaCFu
        7Z7dzfjLyDUBaUHgW7JHjV/3xxtV+T0rcSR4QbpDsAZWihjj0agf
X-Google-Smtp-Source: ABdhPJygODbT8Wy9l2d7FOrsdSQH7N26yw4nFAuGY6k5vZlb7tGt9KmD3PsZeNjmX4N5b1ARhbmKpBUCNV8Wc/wNJNg=
X-Received: by 2002:a17:906:270f:: with SMTP id z15mr7908192ejc.6.1602153291904;
 Thu, 08 Oct 2020 03:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <20201002010633.3706122-1-andriin@fb.com> <CAKQ-crhUT07SXZ16NK4_2RtpNA+kvm7VtB5fdo4qSV4Qi4GJ_g@mail.gmail.com>
 <CAEf4Bzb7kE5x=Ow=XHMb1wmt0Tjw-qqoL-yihAWx5s10Dk9chQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzb7kE5x=Ow=XHMb1wmt0Tjw-qqoL-yihAWx5s10Dk9chQ@mail.gmail.com>
From:   Luka Perkov <luka.perkov@sartura.hr>
Date:   Thu, 8 Oct 2020 12:34:41 +0200
Message-ID: <CAKQ-crhMomcb9v3LAnqrBFLp1=m8bh4ZBnD7O_oH2XsU2faMAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] libbpf: auto-resize relocatable LOAD/STORE instructions
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

Hello Andrii,

On Wed, Oct 7, 2020 at 8:01 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 7, 2020 at 10:56 AM Luka Perkov <luka.perkov@sartura.hr> wrote:
> >
> > Hello Andrii,
> >
> > On Fri, Oct 2, 2020 at 3:09 AM Andrii Nakryiko <andriin@fb.com> wrote:
> > > Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, 4-,
> > > 8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE field
> > > offset relocation associated with it. In practice this means transparent
> > > handling of 32-bit kernels, both pointer and unsigned integers. Signed
> > > integers are not relocatable with zero-extending loads/stores, so libbpf
> > > poisons them and generates a warning. If/when BPF gets support for sign-extending
> > > loads/stores, it would be possible to automatically relocate them as well.
> > >
> > > All the details are contained in patch #1 comments and commit message.
> > > Patch #2 is a simple change in libbpf to make advanced testing with custom BTF
> > > easier. Patch #3 validates correct uses of auto-resizable loads, as well as
> > > check that libbpf fails invalid uses.
> > >
> > > I'd really appreciate folks that use BPF on 32-bit architectures to test this
> > > out with their BPF programs and report if there are any problems with the
> > > approach.
> > >
> > > Cc: Luka Perkov <luka.perkov@sartura.hr>
> >
> > First, thank you for the support and sending this series. It took us a
> > bit longer to run the tests as our target hardware still did not fully
> > get complete mainline support and we had to rebase our patches. These
> > are not related to BPF.
> >
> > Related to this patch, we have tested various BPF programs with this
> > patch, and can confirm that it fixed previous issues with pointer
> > offsets that we had and reported at:
> >
> > https://lore.kernel.org/r/CA+XBgLU=8PFkP8S32e4gpst0=R4MFv8rZA5KaO+cEPYSnTRYYw@mail.gmail.com/.
> >
> > Most of our programs now work and we are currently debugging other
> > programs that still aren't working. We are still not sure if the
> > remaining issues are related to this or not, but will let you know
> > sometime this week after further and more detailed investigation.
> >
>
> Ok, great, thanks for the update.

Just to update you that we have identified that the problem was a
known issue with JIT as we had enabled the BPF_JIT_ALWAYS_ON.

That said, it would be great to see this series included in 5.10 :)

Thanks,
Luka
