Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422F2369051
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhDWK1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhDWK06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 06:26:58 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33A1C06138C
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:26:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n127so13908133wmb.5
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 03:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pZC3bOQbN5+fqyuA7H9ye81q8uOWfqddKhA+GXdAbe0=;
        b=aSb/o1mV8h0CcE9ai+0+GIlXRSGlsJTPumKNmGEJ88Z4i3bGRbY+GZu4y+9bXJ2Ej0
         Gnr1pQPVFxw/OkuLgXzy8PcFfaYDEZW1fihUNP/VtK/ltQ5OgS+ABY7Byb2o9rvuH3w9
         aiiyIdPgdOTZ+hKQKeseFBSIHuPOG3wEViDcm9o+RO0YnIbhhMqz+iQQf7AY04+ybwHf
         2nC4MhrVKh/73RRSCeoHklo+CLEPmhYLF8BmrTl+dusVmM5VfEfslHL7IoEnP1IXaaeU
         +VlpWeuLfKHGTov0axRspP5fwSgIZ4r+kUdG1PRmBmRYDbmUFoGKlyjNhDcKQj1tRsaO
         5EEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZC3bOQbN5+fqyuA7H9ye81q8uOWfqddKhA+GXdAbe0=;
        b=S3JX5EYDdooplDFdZQ7h1Ow72qoNHBvpAq2DZsasf0OMOu74LMhIdd2CHgT+ojnuL9
         G8+4nOQm6ceFD9RFH4M1x0TVozWaiJswMAto6VBehO6ZkScL2WxWu6/gyOoaHZ/sDCFx
         kCIgp3dsYDAQSiwGuE/llzceLOq63T+YN0MKo8xpXXcpSuaL6sp80/azs1o4At+KQMHj
         RCW9V8in+kfwmGr89kbxGeZLtOazVymdL9Dc8vYXvQd70RpnfbDP8AFLo1cqvI6JTMzf
         HpkpahZIvyizggkhFexThD6EOR3uFgFHFmGkkj942PfsYwp21+38fDuhO4Kq1M00Kfn+
         iEsg==
X-Gm-Message-State: AOAM5338Zp4XKvfUY21BOnoPEsknEih2szdBTcLW/mGHLHmc8l0Km8gm
        Ytl5zCGbIsXOUeet5mBu+7950A==
X-Google-Smtp-Source: ABdhPJwzRkVz3Ofbfxh8n0buCkcX7vCmdhQBvEZ1KP3t4/FvoWzwFRVeYSa0K9So4C2Yfv4k3szanw==
X-Received: by 2002:a1c:b743:: with SMTP id h64mr3431829wmf.35.1619173579445;
        Fri, 23 Apr 2021 03:26:19 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.88.56])
        by smtp.gmail.com with ESMTPSA id b15sm8464544wrt.57.2021.04.23.03.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:26:18 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Ian Rogers <irogers@google.com>, Song Liu <songliubraving@fb.com>,
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
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
 <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
 <d3949501-8f7d-57c4-b3fe-bcc3b24c09d8@isovalent.com>
 <CAADnVQJ2oHbYfgY9jqM_JMxUsoZxaNrxKSVFYfgCXuHVpDehpQ@mail.gmail.com>
 <0dea05ba-9467-0d84-4515-b8766f60318e@csgroup.eu>
 <CAADnVQ+oQT6C7Qv7P5TV-x7im54omKoCYYKtYhcnhb1Uv3LPMQ@mail.gmail.com>
 <be132117-f267-5817-136d-e1aeb8409c2a@csgroup.eu>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <58296f87-ad00-a0f5-954b-2150aa84efc4@isovalent.com>
Date:   Fri, 23 Apr 2021 11:26:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <be132117-f267-5817-136d-e1aeb8409c2a@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-04-23 09:19 UTC+0200 ~ Christophe Leroy <christophe.leroy@csgroup.eu>

[...]

> I finally managed to cross compile bpftool with libbpf, libopcodes,
> readline, ncurses, libcap, libz and all needed stuff. Was not easy but I
> made it.

Libcap is optional and bpftool does not use readline or ncurses. May I
ask how you tried to build it?

> 
> Now, how do I use it ?
> 
> Let say I want to dump the jitted code generated from a call to
> 'tcpdump'. How do I do that with 'bpftool prog dump jited' ?
> 
> I thought by calling this line I would then get programs dumped in a way
> or another just like when setting 'bpf_jit_enable=2', but calling that
> line just provides me some bpftool help text.

Well the purpose of this text is to help you find the way to call
bpftool to do what you want :). For dumping your programs' instructions,
you need to tell bpftool what program to dump: Bpftool isn't waiting
until you load a program to dump it, instead you need to load your
program first and then tell bpftool to retrieve the instructions from
the kernel. To reference your program you could use a pinned path, or
first list the programs on your system with "bpftool prog show":


    # bpftool prog show
    138: tracing  name foo  tag e54c922dfa54f65f  gpl
            loaded_at 2021-02-25T01:32:30+0000  uid 0
            xlated 256B  jited 154B  memlock 4096B  map_ids 64
            btf_id 235

Then you can use for example the program id displayed on the first line
to reference and dump your program:

    # bpftool prog dump jited id 138

You should find additional documentation under
tools/bpf/bpftool/Documentation.

> 
> By the way, I would be nice to have a kernel OPTION that selects all
> OPTIONS required for building bpftool. Because you discover them one by
> one at every build failure. I had to had CONFIG_IPV6, CONFIG_DEBUG_BTF,
> CONFIG_CGROUPS, ... If there could be an option like "Build a 'bpftool'
> ready kernel" that selected all those, it would be great.
> 
> Christophe

I do not believe any of these are required to build bpftool.

Quentin
