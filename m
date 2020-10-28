Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E7429D9CB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733023AbgJ1XCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730802AbgJ1XCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:02:37 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B23C0613CF;
        Wed, 28 Oct 2020 16:02:36 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k21so1294166ioa.9;
        Wed, 28 Oct 2020 16:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j+TCYxFvNdwFOUEdlBYEeSuUFVQez9IdExtvmUG9wKI=;
        b=eMgJU9OB8SFYhSjDX0dUFS/91iW6pgVsQGurCw7JMR+oD8cS9lpe43GSx84MwQQVQC
         Y7jJrOZBbsLCgT3G2uKxj0rbFUibnITrudm8fjBoF2a0HMcrCeQy5Gda0ugnbxtn7z19
         3JjKtLe3pheUMc2z4Lmzh+NuSJcMiKgBWfxV8QKX2kKOQ/IE4T06kiu1aXbhnx0XZgo3
         hgs7btUSNZQZSAZczYXk8U5e2N7kVa4Qiff9XO44HzXmzOT7izFr9TviHXS6DLHlNhER
         +4SgtpOUtSGILz6QQEmANJ8lsVnypd94EKuebxPRCR4qwe0A+RM3c/EU7I7iGMszd4SY
         V+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j+TCYxFvNdwFOUEdlBYEeSuUFVQez9IdExtvmUG9wKI=;
        b=EGDg2cgg2GoogyrkFccJyAa0RjaS6l0mgxcqIarMYkyRutKusv5EmOr6kVCMuaZHOC
         mbx+s7IeXyHiqJ+jI0QHqokIcDDADVfAWxlR0QRKjTeL9DuAEHaG1W7iGEYS4O9qfUxP
         BJrjF4/y7VIyx1SOwh3Z/rwsXRZpwNSOoyrcAJ5JjbaoUNHyJUsaIel93VHWXrR7fLay
         SoDSMXbza6Kd6fPtnx0gm5hh+doDMElIQS/fCCO/cOlpekkoILmFm6PIOClAtYWXMIB9
         Ryhe24DS9R4MHZ+KdUgr0i8+lKa1ypPFmQs80d7jc07J1oCx3C37aaN894KizLulOs3C
         AXRg==
X-Gm-Message-State: AOAM5301zgKXjtH/wqQ1PX1o1mjSBee+OZTpWLy12uVLB+vtWSf4mu90
        oAYw1uZY5OCna6v5iUv89ew=
X-Google-Smtp-Source: ABdhPJy/SQhGL9lcibcP7k0GVXTLmTr5DSuvgOxdk8ItwGzYI2dS+K9W4RSJhKsob9Ko3fL06HptAw==
X-Received: by 2002:a5d:9a19:: with SMTP id s25mr741153iol.7.1603926156172;
        Wed, 28 Oct 2020 16:02:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e1b0:db06:9a2d:91c5])
        by smtp.googlemail.com with ESMTPSA id q23sm580132iob.19.2020.10.28.16.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 16:02:35 -0700 (PDT)
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
Date:   Wed, 28 Oct 2020 17:02:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201028132529.3763875-1-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 7:25 AM, Hangbin Liu wrote:
> This series converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available. This means that iproute2 will
> correctly process BTF information and support the new-style BTF-defined
> maps, while keeping compatibility with the old internal map definition
> syntax.
> 
> This is achieved by checking for libbpf at './configure' time, and using
> it if available. By default the system libbpf will be used, but static
> linking against a custom libbpf version can be achieved by passing
> LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
> abort if no suitable libbpf is found (useful for automatic packaging
> that wants to enforce the dependency).
> 
> The old iproute2 bpf code is kept and will be used if no suitable libbpf
> is available. When using libbpf, wrapper code ensures that iproute2 will
> still understand the old map definition format, including populating
> map-in-map and tail call maps before load.
> 
> The examples in bpf/examples are kept, and a separate set of examples
> are added with BTF-based map definitions for those examples where this
> is possible (libbpf doesn't currently support declaratively populating
> tail call maps).
> 
> At last, Thanks a lot for Toke's help on this patch set.
> 
> 
> v2:
> a) Remove self defined IS_ERR_OR_NULL and use libbpf_get_error() instead.
> b) Add ipvrf with libbpf support.
> 
> 

fails to compile on Ubuntu 20.10:

root@u2010-sfo3:~/iproute2.git# ./configure
TC schedulers
 ATM	yes
 IPT	using xtables
 IPSET  yes

iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
libc has setns: yes
SELinux support: yes
libbpf support: yes
ELF support: yes
libmnl support: yes
Berkeley DB: no
need for strlcpy: yes
libcap support: yes

root@u2010-sfo3:~/iproute2.git# make clean

root@u2010-sfo3:~/iproute2.git# make -j 4
...
/usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
bpf_libbpf.c:(.text+0x3cb): undefined reference to
`bpf_program__section_name'
/usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
`bpf_program__section_name'
/usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
`bpf_program__section_name'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:27: ip] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:64: all] Error 2


