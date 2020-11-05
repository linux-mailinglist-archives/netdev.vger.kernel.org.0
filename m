Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8404E2A7631
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388685AbgKEDsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388670AbgKEDsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:48:35 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84689C0613CF;
        Wed,  4 Nov 2020 19:48:35 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id j12so415313iow.0;
        Wed, 04 Nov 2020 19:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zU4o/Vz/jeSjdyJy2A21CMrZyLkZu8yOx/H+G2wHTdc=;
        b=Cc+4+3Nry85BqsIZjrlLbXJjopgkClUH0XNo4UAHtONrfMvHoqk0Ke8rFBXZUfdEkM
         1mG+YXiNpRJUBK6OrvaE7+POHwi26+4G27OQQDUzLY0ru82+7Kjfc/03/APvhmaNB6Ix
         ycWUco6ldzhRb1JoD2Xl0pZQWKhKGAkkFGnP7Kk6ms84K4cJwFhJVnMgK3XR7NqxutiC
         gPYsDJNhkVCNMvk8nkn3m0ldSAmoej48HB3nOo7l5aWPW8gT4MTP1JZ665HEe5235xg5
         ThS2aizKBl9ei4FpxYwLEqC25nBoyjZZ45EQF/F9A661JS+kj8tmxHXz8Dp8PwN91/kn
         lEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zU4o/Vz/jeSjdyJy2A21CMrZyLkZu8yOx/H+G2wHTdc=;
        b=bQOjzLLfIRM3edJrBi4q7Bo0rH56RVp8pGhZgX+0J5xiy54Ot8gpxXdVsISX4yrh9y
         vVdbIwfTrcLy5YMVNPM7W6JHWG4ZlztVYI4swNJPwqAFPJCKLZGD1sUX2q+gp7pmIouG
         FWsc7mXKzRnuLSYlBMfIg5Y2g5uZ/F0aj2QQaeWviPcZ+tztymYywx0uwxH7THHi+UPA
         P7AVWMzXPeWEmW7QC+67G/If+a4BKEJQGr7JVQXU5Q0wDrHkXnvKhuda6yKI4uFvco1M
         YyGbhkGDnmASwpUuDkk1lPrxhOezYT8AfrXWwdcoa/LEb2mAbCPnnDJatlanTGHKG5mY
         e8TA==
X-Gm-Message-State: AOAM532EvnRfwl/RyRni6XYSg2vFyZODAASA5mArooxAiXdbtwzOUdTa
        Iac3qnd7oUVj8/EgB1MQf4M=
X-Google-Smtp-Source: ABdhPJzB6Cv89hAt0Kq68a1+gDz4Ekbjl69lPl05kP/NBRjPeQcW/soBUypuRI/+QJ2keC5ryNUOxg==
X-Received: by 2002:a6b:911:: with SMTP id t17mr426548ioi.197.1604548114992;
        Wed, 04 Nov 2020 19:48:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6dfd:4f87:68ce:497b])
        by smtp.googlemail.com with ESMTPSA id p83sm222221iod.49.2020.11.04.19.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 19:48:34 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <87zh3xv04o.fsf@toke.dk>
 <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net>
 <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dba0723f-fd55-5dd6-dccc-4e0a649c860e@gmail.com>
Date:   Wed, 4 Nov 2020 20:48:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 1:43 PM, Andrii Nakryiko wrote:
> 
> What users writing BPF programs can expect from iproute2 in terms of
> available BPF features is what matters. And by not enforcing a
> specific minimal libbpf version, iproute2 version doesn't matter all
> that much, because libbpf version that iproute2 ends up linking
> against might be very old.
> 
> There was a lot of talk about API stability and backwards
> compatibility. Libbpf has had a stable API and ABI for at least 1.5
> years now and is very conscious about that when adding or extending
> new APIs. That's not even a factor in me arguing for submodules. I'll
> give a few specific examples of libbpf API not changing at all, but
> how end user experience gets tremendously better.
> 
> Some of the most important APIs of libbpf are, arguably,
> bpf_object__open() and bpf_object__load(). They accept a BPF ELF file,
> do some preprocessing and in the end load BPF instructions into the
> kernel for verification. But while API doesn't change across libbpf
> versions, BPF-side code features supported changes quite a lot.
> 
> 1. BTF sanitization. Newer versions of clang would emit a richer set
> of BTF type information. Old kernels might not support BTF at all (but
> otherwise would work just fine), or might not support some specific
> newer additions to BTF. If someone was to use the latest Clang, but
> outdated libbpf and old kernel, they would have a bad time, because
> their BPF program would fail due to the kernel being strict about BTF.
> But new libbpf would "sanitize" BTF, according to supported features
> of the kernel, or just drop BTF altogether, if the kernel is that old.
> 

In my experience, compilers are the least likely change in a typical
Linux development environment. BPF should not be forcing new versions
(see me last response).

> 
> 2. bpf_probe_read_user() falling back to bpf_probe_read(). Newer
> kernels warn if a BPF application isn't using a proper _kernel() or
> _user() variant of bpf_probe_read(), and eventually will just stop
> supporting generic bpf_probe_read(). So what this means is that end
> users would need to compile to variants of their BPF application, one
> for older kernels with bpf_probe_read(), another with
> bpf_probe_read_kernel()/bpf_probe_read_user(). That's a massive pain
> in the butt. But newer libbpf versions provide a completely
> transparent fallback from _user()/_kernel() variants to generic one,
> if the kernel doesn't support new variants. So the instruction to
> users becomes simple: always use
> bpf_probe_read_user()/bpf_probe_read_kernel().
> 

I vaguely recall a thread about having BPF system call return user
friendly messages, but that was shot down. I take this example to mean
the solution is to have libbpf handle the quirks and various changes
which means that now libbpf takes on burden - the need for constant
updates to handle quirks. extack has been very successful at making
networking configuration mistakes more user friendly. Other kernel
features should be using the same kind of extension.
