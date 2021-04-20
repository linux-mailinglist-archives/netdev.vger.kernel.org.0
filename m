Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C853650DE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhDTD32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTD3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 23:29:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10933C06174A;
        Mon, 19 Apr 2021 20:28:54 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j4so19800989lfp.0;
        Mon, 19 Apr 2021 20:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sjA5c4MI/V/Us5khupc3zlEWJtPk9Lba1kHWIn9xqrM=;
        b=aZSJaNW84mZRYAHIY5t88erflreGTdYjaH3FYtF1qHJPn6VWs0jryZT46tcKmPEGha
         /og/FC8vcGojrzKljv51Y7lWbKJNsViPSNua0KzzWTeHQBaA77mtr8NCMQ4THd2QTzcC
         W4NX+bAwjkGszUu3wkPlccw0aoYiZjMS+T4JTPsVHoVH+R4TOOISLvGTXFbJ16T+Dgur
         kbNEKiwtz58pU2SAt4AjUcSxyUGvQb0yQueu6ghHyatn+Cc/mNZXXrnsQvXgxCwKXuNp
         sZTyXkoz02r+DOAERoaXyqJHUX8rL4MjlDqKs+1CuVe940UruGYC9kE+b/nNTgV9xhkG
         purg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sjA5c4MI/V/Us5khupc3zlEWJtPk9Lba1kHWIn9xqrM=;
        b=LgJPb5MBlEKi1REqgkAuvdlJjsp0gQpZhNPuzFcdyfII3Wkdw2WUL93Hhz5Yp/9s/z
         Zg3K4GmkMz47pxCriTVhhLFa+EON2SMq/RUwepb7LMM7I0nyTU2HjfRMS/O5k2DUF7h6
         dYKaMX88np5drCkQ3VCx9WuUfiml+evx0IN99nW0ssu3Vb9/aYOurM+c3WnyiX1Lyejn
         q7uNJZm6MC/WC35f4g+0UdSpmrkh4zRUSH+bmQZU1DEIARkeRedC9zVo5cTd52D9b2Hz
         8Lg8v95BMLJEnyFKvMm+eBXFz/WhbJ0o918UxMIpL4vwo2eI8q+SZCX0nZ1SqGGk/LrS
         Exkw==
X-Gm-Message-State: AOAM530Nb75ftxe060+0oeBb+vVmav6/Y7uUN3xTz1ok6Q2Z0C9FT6Bl
        CF9Mupz/vZH60+Tz8lPd7DAow43Kjj+6XiluqSo=
X-Google-Smtp-Source: ABdhPJxtNTC6hNyk2mAr0jYIRtC3Pnw65n4y2IU2BFaZPz0SzJ5eF0gkFi6YsfR4xYcNBc9nZPkqaJatjNPZ02gYJpQ=
X-Received: by 2002:ac2:510d:: with SMTP id q13mr13835296lfb.75.1618889332453;
 Mon, 19 Apr 2021 20:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com> <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
 <d3949501-8f7d-57c4-b3fe-bcc3b24c09d8@isovalent.com> <CAADnVQJ2oHbYfgY9jqM_JMxUsoZxaNrxKSVFYfgCXuHVpDehpQ@mail.gmail.com>
 <0dea05ba-9467-0d84-4515-b8766f60318e@csgroup.eu>
In-Reply-To: <0dea05ba-9467-0d84-4515-b8766f60318e@csgroup.eu>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 19 Apr 2021 20:28:41 -0700
Message-ID: <CAADnVQ+oQT6C7Qv7P5TV-x7im54omKoCYYKtYhcnhb1Uv3LPMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 1:16 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 16/04/2021 =C3=A0 01:49, Alexei Starovoitov a =C3=A9crit :
> > On Thu, Apr 15, 2021 at 8:41 AM Quentin Monnet <quentin@isovalent.com> =
wrote:
> >>
> >> 2021-04-15 16:37 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
> >>> On 4/15/21 11:32 AM, Jianlin Lv wrote:
> >>>> For debugging JITs, dumping the JITed image to kernel log is discour=
aged,
> >>>> "bpftool prog dump jited" is much better way to examine JITed dumps.
> >>>> This patch get rid of the code related to bpf_jit_enable=3D2 mode an=
d
> >>>> update the proc handler of bpf_jit_enable, also added auxiliary
> >>>> information to explain how to use bpf_jit_disasm tool after this cha=
nge.
> >>>>
> >>>> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> >>
> >> Hello,
> >>
> >> For what it's worth, I have already seen people dump the JIT image in
> >> kernel logs in Qemu VMs running with just a busybox, not for kernel
> >> development, but in a context where buiding/using bpftool was not
> >> possible.
> >
> > If building/using bpftool is not possible then majority of selftests wo=
n't
> > be exercised. I don't think such environment is suitable for any kind
> > of bpf development. Much so for JIT debugging.
> > While bpf_jit_enable=3D2 is nothing but the debugging tool for JIT deve=
lopers.
> > I'd rather nuke that code instead of carrying it from kernel to kernel.
> >
>
> When I implemented JIT for PPC32, it was extremely helpfull.
>
> As far as I understand, for the time being bpftool is not usable in my en=
vironment because it
> doesn't support cross compilation when the target's endianess differs fro=
m the building host
> endianess, see discussion at
> https://lore.kernel.org/bpf/21e66a09-514f-f426-b9e2-13baab0b938b@csgroup.=
eu/
>
> That's right that selftests can't be exercised because they don't build.
>
> The question might be candid as I didn't investigate much about the repla=
cement of "bpf_jit_enable=3D2
> debugging mode" by bpftool, how do we use bpftool exactly for that ? Espe=
cially when using the BPF
> test module ?

the kernel developers can add any amount of printk and dumps to debug
their code,
but such debugging aid should not be part of the production kernel.
That sysctl was two things at once: debugging tool for kernel devs and
introspection for users.
bpftool jit dump solves the 2nd part. It provides JIT introspection to user=
s.
Debugging of the kernel can be done with any amount of auxiliary code
including calling print_hex_dump() during jiting.
