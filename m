Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B38736702B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbhDUQah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbhDUQae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 12:30:34 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F4AC06174A;
        Wed, 21 Apr 2021 09:29:59 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id c4so8860917ilq.9;
        Wed, 21 Apr 2021 09:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kZEeiT+02hDVJRhO51gnJpF7hYzhozQfqmgkPQR+2go=;
        b=RCvSbC5gF4irYRxbKtCXq6ucAmn/fBlZPcmxc5StJjv0OsgtmawKZzSRMOt9KwaVfB
         mOterPVI+uca5uIZicYzxPVaYRAjch0dVaykdoLqmfnumz1qeSndgLTPIM5A88GuAh16
         kY60ERydmvvHQ8SECatQeY+fvihLUbYrM61BxVEcAV4K+xfLjiZrTMwPk+MtsJVT2Zr6
         GOZv43s51r2l+BrbedzeIDb4y3VrRbbDk8nnNp+fNSeMWAnjMPVM6JYQO/h4ai6vqwLR
         UCr2zI9SxvzesSwPuDXcovg8tK5WkZn8XccEKEIg0LxS0AurB5NZT/Bi0RNt9J0flU4S
         ysDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kZEeiT+02hDVJRhO51gnJpF7hYzhozQfqmgkPQR+2go=;
        b=LGFDSbNPq1gf/rK+UPmEorDkOeFw4LOj+j8juXF4Dg4lA37nUOOl3sByLXMTrnWHQc
         hBM0vRjY+dV+NOwWU08w+PpwDU2OgPm6mBzFfBjNzqpDrcvnLuBl8UDJRbbu3EiCoRFM
         HUe4p6lgkV+21HeN1vvXNy5y50hvL1iRUdz6/Ftydi6FIqBaw2gYQQE8CmyTJrDgekDx
         Fyi7rA9bdUE9vLvewlJp3YLFmlNONbXbBtFeagHr06/OWUZGfD9Yvl0aUzEAWuiUrlLm
         RrtF8fCAdi3fEgpImsSmuUD7qM/9DAsho21L6b1DKECc5U+/QhM7o7fiUcsNmKeJdajZ
         tvig==
X-Gm-Message-State: AOAM5312Msjljx61MNr6hFgZTispHkNvHFNG0/ZKd8tuZJZUME5PKeNK
        7WcYBtJH+kThXase1XwC6x0=
X-Google-Smtp-Source: ABdhPJz7ul05BAWC6HoOuLc6EjCX5ztWUgfj1SHdCI0SDk1nQOPXDNy1tG/R5d8sRRgMhivItaOuEA==
X-Received: by 2002:a92:ce0e:: with SMTP id b14mr25946343ilo.283.1619022599257;
        Wed, 21 Apr 2021 09:29:59 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id v26sm1303125ioh.42.2021.04.21.09.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:29:58 -0700 (PDT)
Date:   Wed, 21 Apr 2021 09:29:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Ian Rogers <irogers@google.com>,
        Song Liu <songliubraving@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Sandipan Das <sandipan@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, sparclinux@vger.kernel.org,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Will Deacon <will@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>, paulburton@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        X86 ML <x86@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        linux-mips@vger.kernel.org, grantseltzer@gmail.com,
        Xi Wang <xi.wang@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Kees Cook <keescook@chromium.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        KP Singh <kpsingh@kernel.org>, iecedge@gmail.com,
        Simon Horman <horms@verge.net.au>,
        Borislav Petkov <bp@alien8.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Vyukov <dvyukov@google.com>, tsbogend@alpha.franken.de,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Wang YanQing <udknight@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, bpf <bpf@vger.kernel.org>,
        Jianlin Lv <Jianlin.Lv@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <608052fea86fb_46b92087@john-XPS-13-9370.notmuch>
In-Reply-To: <7dc31256-eb1d-dc93-5e55-2de27475e0c6@csgroup.eu>
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
 <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
 <d3949501-8f7d-57c4-b3fe-bcc3b24c09d8@isovalent.com>
 <CAADnVQJ2oHbYfgY9jqM_JMxUsoZxaNrxKSVFYfgCXuHVpDehpQ@mail.gmail.com>
 <0dea05ba-9467-0d84-4515-b8766f60318e@csgroup.eu>
 <CAADnVQ+oQT6C7Qv7P5TV-x7im54omKoCYYKtYhcnhb1Uv3LPMQ@mail.gmail.com>
 <7dc31256-eb1d-dc93-5e55-2de27475e0c6@csgroup.eu>
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe Leroy wrote:
> =

> =

> Le 20/04/2021 =C3=A0 05:28, Alexei Starovoitov a =C3=A9crit=C2=A0:
> > On Sat, Apr 17, 2021 at 1:16 AM Christophe Leroy
> > <christophe.leroy@csgroup.eu> wrote:
> >>
> >>
> >>
> >> Le 16/04/2021 =C3=A0 01:49, Alexei Starovoitov a =C3=A9crit :
> >>> On Thu, Apr 15, 2021 at 8:41 AM Quentin Monnet <quentin@isovalent.c=
om> wrote:
> >>>>
> >>>> 2021-04-15 16:37 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>=

> >>>>> On 4/15/21 11:32 AM, Jianlin Lv wrote:
> >>>>>> For debugging JITs, dumping the JITed image to kernel log is dis=
couraged,
> >>>>>> "bpftool prog dump jited" is much better way to examine JITed du=
mps.
> >>>>>> This patch get rid of the code related to bpf_jit_enable=3D2 mod=
e and
> >>>>>> update the proc handler of bpf_jit_enable, also added auxiliary
> >>>>>> information to explain how to use bpf_jit_disasm tool after this=
 change.
> >>>>>>
> >>>>>> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> >>>>
> >>>> Hello,
> >>>>
> >>>> For what it's worth, I have already seen people dump the JIT image=
 in
> >>>> kernel logs in Qemu VMs running with just a busybox, not for kerne=
l
> >>>> development, but in a context where buiding/using bpftool was not
> >>>> possible.
> >>>
> >>> If building/using bpftool is not possible then majority of selftest=
s won't
> >>> be exercised. I don't think such environment is suitable for any ki=
nd
> >>> of bpf development. Much so for JIT debugging.
> >>> While bpf_jit_enable=3D2 is nothing but the debugging tool for JIT =
developers.
> >>> I'd rather nuke that code instead of carrying it from kernel to ker=
nel.
> >>>
> >>
> >> When I implemented JIT for PPC32, it was extremely helpfull.
> >>
> >> As far as I understand, for the time being bpftool is not usable in =
my environment because it
> >> doesn't support cross compilation when the target's endianess differ=
s from the building host
> >> endianess, see discussion at
> >> https://lore.kernel.org/bpf/21e66a09-514f-f426-b9e2-13baab0b938b@csg=
roup.eu/
> >>
> >> That's right that selftests can't be exercised because they don't bu=
ild.
> >>
> >> The question might be candid as I didn't investigate much about the =
replacement of "bpf_jit_enable=3D2
> >> debugging mode" by bpftool, how do we use bpftool exactly for that ?=
 Especially when using the BPF
> >> test module ?
> > =

> > the kernel developers can add any amount of printk and dumps to debug=

> > their code,
> > but such debugging aid should not be part of the production kernel.
> > That sysctl was two things at once: debugging tool for kernel devs an=
d
> > introspection for users.
> > bpftool jit dump solves the 2nd part. It provides JIT introspection t=
o users.
> > Debugging of the kernel can be done with any amount of auxiliary code=

> > including calling print_hex_dump() during jiting.
> > =

> =

> I get the following message when trying the command suggested in the pa=
tch message:
> =

> root@vgoip:~# ./bpftool prog dump jited
> Error: No libbfd support
> =

> Christophe

Seems your bpftool prog was built without libbfd, can you rebuild with li=
bbfd
installed.

.John
