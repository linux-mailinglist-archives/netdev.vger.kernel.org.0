Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEA29E2B6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391330AbgJ2CeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729940AbgJ2Cdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:33:45 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21467C0613CF;
        Wed, 28 Oct 2020 19:33:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z5so1831414iob.1;
        Wed, 28 Oct 2020 19:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6GytV/YfZqiq2s9nqgfVb891weslak10f/ixf3YW0ZE=;
        b=tOTX7t2OIuZH3UnQFep/TOZBB00cBS/IWDotGJGlh0t/UEMZfTdbfHV1569JAZg06I
         R88JxH9OWlL0jGvRZqxUBONLlRyDJjg7ZR71RfK0Bw7bggQhbubKBt45WvFQ6IsnFaI5
         p8OBvxk9k7ao+werHg67+vw9y/AbBW6hNN6zT4fjgqNMdQdgqa9XRpxqbRjPtydqgmK0
         5d9iAHTNGYtNi79KGkv6CPhuYkHw1l0fqeRSMp12oFkxLKZM+wz7qbbmIFLVdXz123Xm
         CrH8OfmehgUtsvjlpvFtSo88ZJCw6l2yK5an0ANhSRvb3ZwJdL1j4uVRYcU3YcsrO4SQ
         yaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6GytV/YfZqiq2s9nqgfVb891weslak10f/ixf3YW0ZE=;
        b=rcJr0YkL4THhZPYlQvqBfXZaZZ3Krx9Gq3oFLZxK/LW1qeaAvnftyQmjH/g6U+i/gH
         VMOR6/UtG0wjfX0tH1BHABlHBcHqWk2Y8oCH5pVWi26Rp+wv+gUcWqcia70FvpMxW/VB
         COvq+ccL7SKI6kxh9zSxtBIkPUYOrnCLu8PusWQqNObkZivE3lhcYhqHiEGvMXERYHiA
         zRgyyuEuHJXI+Nq+4TXvah546K47M860IrW5cGuG2EGy3DZVdWv71Ha7DV1bEt7OanUH
         RWwNiVir9BL4QX05FTgx/Y8exQ4nWVbNQmcZVRMybMXWSqv93MHXjf/Xu3wqnie82C9C
         ojrg==
X-Gm-Message-State: AOAM533JEhj4drukd5249hOGLZUI1FaLJwOesmx0/KuJcCflJNQwG829
        X318I8ZbXE47lUFnqmZe3sA=
X-Google-Smtp-Source: ABdhPJx6pHJr5RkSB7hHl65PFO3eVLmalsEfN019T1FytM0+LEJaP74JtpGFu6rRHe+Os3eR4dc7tg==
X-Received: by 2002:a05:6638:10ea:: with SMTP id g10mr1885135jae.9.1603938824510;
        Wed, 28 Oct 2020 19:33:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e1b0:db06:9a2d:91c5])
        by smtp.googlemail.com with ESMTPSA id v85sm1365404ilk.50.2020.10.28.19.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:33:44 -0700 (PDT)
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
 <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b17e7428-dd99-09f8-7254-c61d25a0c797@gmail.com>
Date:   Wed, 28 Oct 2020 20:33:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 8:27 PM, Andrii Nakryiko wrote:
> On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:
>>
>> On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
>>> fails to compile on Ubuntu 20.10:
>>>
>>> root@u2010-sfo3:~/iproute2.git# ./configure
>>> TC schedulers
>>>  ATM  yes
>>>  IPT  using xtables
>>>  IPSET  yes
>>>
>>> iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
>>> libc has setns: yes
>>> SELinux support: yes
>>> libbpf support: yes
>>> ELF support: yes
>>> libmnl support: yes
>>> Berkeley DB: no
>>> need for strlcpy: yes
>>> libcap support: yes
>>>
>>> root@u2010-sfo3:~/iproute2.git# make clean
>>>
>>> root@u2010-sfo3:~/iproute2.git# make -j 4
>>> ...
>>> /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
>>> bpf_libbpf.c:(.text+0x3cb): undefined reference to
>>> `bpf_program__section_name'
>>> /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
>>> `bpf_program__section_name'
>>> /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
>>> `bpf_program__section_name'
>>> collect2: error: ld returned 1 exit status
>>> make[1]: *** [Makefile:27: ip] Error 1
>>> make[1]: *** Waiting for unfinished jobs....
>>> make: *** [Makefile:64: all] Error 2
>>
>> You need to update libbpf to latest version.
> 
> Why not using libbpf from submodule?
> 

no. iproute2 does not bring in libmnl, libc, ... a submodules. libbpf is
not special. OS versions provide it and it needs to co-exist with packages.
