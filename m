Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE0361688
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbhDOXuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbhDOXuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:50:13 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80220C061574;
        Thu, 15 Apr 2021 16:49:49 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j4so2383135lfp.0;
        Thu, 15 Apr 2021 16:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=93RaKIcPxj4ed/vj3/T6taZCo8gljqrXH2nCGhdkM1Q=;
        b=aBCM67HeOS1RQpmZ9d1xkBbfZ9OjHVKizD6JMJntC1jztjXCaMAD4PxLVP6PE65ty3
         cKPeKzgiEbgw3SQZ8eR83qtBjTP2OYUdbnqkzhUAbE0u+1hOdGsAn8xKem5MzABFlQgD
         mRXyEbRdJWemOBA5ZL1H2F5rm/kMfg/eeqCccq1PGYnduzRrD+ZOmE6Jc8ZifznL8idv
         FrDgLXsLKsMduLqpBFFg7xH0u5XmXHclHLbXV0TX9HDDr95c+SXlKyzlZoT5Ez5tEE8O
         yL7SLoB/UGXylkkP0jVvQUti3azG7QIpldbt+d5lTdgqR0VqbJM4y+Fb3QAjnu0TlNPa
         AWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=93RaKIcPxj4ed/vj3/T6taZCo8gljqrXH2nCGhdkM1Q=;
        b=NBeeKEl+SDqHxh0WzmN7s/knZGZEHz9+ow9jKXLEnCkg8ZCNlAK8VquipOILHOPasM
         G6PX5iw5kJFSM/WWJQdJFnxhnGANHBNakvIkAgPKiC3eHVS65skz8zcNslTG/8GeJPeX
         D+KY5lvbBuvNfEOUcMl6oTYR05yesWVw/iX2LbOj4YzVvuL7R+Wl0KayDpLfR4p1z/Cz
         aF2TWgaOdOiKC5qW9nKluFNK77YYTM/OwywIEzkTlqXh3q6DO6WSShNGLpqEXkUfq+dW
         o6cXoVD0x5kjaWeo0yMAI+B5q+XrSUbF1ONuX+O9VEtOY0xofyCkNZ3OxQ13ZtCK8gaG
         Dgog==
X-Gm-Message-State: AOAM533kX0OdH+H6rXq5RAVhK167nyX6Qf7HgnHu+iQQszdYyqGY76hQ
        57otHoWt+UXRfpV77SDnzsBgyrpvEbjNSULikuk=
X-Google-Smtp-Source: ABdhPJyNhOogFP8g+e8x1hnSTCcEzJfdpg/9ifXfqOKSgpR6Q7EyYPjeRQKWzaeLUb3+uY3vv8XYIkkzgMMMfdz4tQA=
X-Received: by 2002:ac2:4d4d:: with SMTP id 13mr1106974lfp.540.1618530588068;
 Thu, 15 Apr 2021 16:49:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com> <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
 <d3949501-8f7d-57c4-b3fe-bcc3b24c09d8@isovalent.com>
In-Reply-To: <d3949501-8f7d-57c4-b3fe-bcc3b24c09d8@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Apr 2021 16:49:36 -0700
Message-ID: <CAADnVQJ2oHbYfgY9jqM_JMxUsoZxaNrxKSVFYfgCXuHVpDehpQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jianlin Lv <Jianlin.Lv@arm.com>, bpf <bpf@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, paulburton@kernel.org,
        tsbogend@alpha.franken.de,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Wang YanQing <udknight@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Simon Horman <horms@verge.net.au>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tobias Klauser <tklauser@distanz.ch>, grantseltzer@gmail.com,
        Ian Rogers <irogers@google.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux@vger.kernel.org, iecedge@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 8:41 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-04-15 16:37 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
> > On 4/15/21 11:32 AM, Jianlin Lv wrote:
> >> For debugging JITs, dumping the JITed image to kernel log is discouraged,
> >> "bpftool prog dump jited" is much better way to examine JITed dumps.
> >> This patch get rid of the code related to bpf_jit_enable=2 mode and
> >> update the proc handler of bpf_jit_enable, also added auxiliary
> >> information to explain how to use bpf_jit_disasm tool after this change.
> >>
> >> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
>
> Hello,
>
> For what it's worth, I have already seen people dump the JIT image in
> kernel logs in Qemu VMs running with just a busybox, not for kernel
> development, but in a context where buiding/using bpftool was not
> possible.

If building/using bpftool is not possible then majority of selftests won't
be exercised. I don't think such environment is suitable for any kind
of bpf development. Much so for JIT debugging.
While bpf_jit_enable=2 is nothing but the debugging tool for JIT developers.
I'd rather nuke that code instead of carrying it from kernel to kernel.
