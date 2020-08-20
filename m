Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF824B5E9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbgHTK3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbgHTK3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:29:34 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7134C061383
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 03:29:33 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y2so1517640ljc.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 03:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=9pwmmvPAgNgpZan9qxqpd7m5i/x2Jbr84ZbARDB6UlQ=;
        b=Kz0aOxy/GDniL6sr/VQKKUMmlcE4xqm8BzhipXe24UTQl0x9tYcQFrrTj7D+xiZ26w
         hzNlpp/GWZgkSi1vShjeloqy7gTJXloQz/XdD1ZLVmbawyZVuZANQ6vgK2OEPZI7/4ev
         Iu2n6mnBTqhY0Lt0vMyibyZY239UR0KSyqxwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=9pwmmvPAgNgpZan9qxqpd7m5i/x2Jbr84ZbARDB6UlQ=;
        b=X7QXcCaOCaddZVnCeQyVpTNAhbv/b3kX0cJytbgo1thsOgQye7KlHIZ1hDtuItlyuO
         CLmpquYigh9KVJX1doF8ms0cRJ4yTXioVJKksYz/NrJX1bhzSPbo+JyWBtf3fEtL+/cC
         /rvF+1kPwvDTZ7jwUD/c20dNVEW/BtdOpzU0CRqvQcEw1JJ3sfr0Mrsvwdyvvy6xdZIb
         HUOci6iQv05Zx6rwokKeXXEpo2ZAkvhK3UJLrD5Co5guwm48FFFjR7YiiFfouzee9XRw
         By/zrGTF/PRqc7BnzDy6vBbPMA/1rmU3wrcFFwfUQEPNxbIGkOwFP6lBVTwS/7oinuKL
         zYPw==
X-Gm-Message-State: AOAM531SJzJMUUIxr4Mj8j6fQi/LWLnUO4biiwRQmhuAFmjl+y1Hw/J0
        yvSr9/cze13h6lyPuk29hwbaZg==
X-Google-Smtp-Source: ABdhPJxGKv9AjPpps1uUtTo6HIAYPA9ktHbnDoC9XQ0Hh+M7mIatMaC+6PqtnP9zBhHOsltgDiWtNA==
X-Received: by 2002:a2e:b5b3:: with SMTP id f19mr1235128ljn.210.1597919371873;
        Thu, 20 Aug 2020 03:29:31 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y19sm410308lfe.77.2020.08.20.03.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 03:29:31 -0700 (PDT)
References: <20200717103536.397595-1-jakub@cloudflare.com> <87lficrm2v.fsf@cloudflare.com> <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
In-reply-to: <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com>
Date:   Thu, 20 Aug 2020 12:29:30 +0200
Message-ID: <87k0xtsj91.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 08:19 PM CEST, Alexei Starovoitov wrote:
> On Tue, Aug 18, 2020 at 8:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>          :                      rcu_read_lock();
>>          :                      run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
>>     0.01 :   ffffffff817f8624:       mov    0xd68(%r12),%rsi
>>          :                      if (run_array) {
>>     0.00 :   ffffffff817f862c:       test   %rsi,%rsi
>>     0.00 :   ffffffff817f862f:       je     ffffffff817f87a9 <__udp4_lib_lookup+0x2c9>
>>          :                      struct bpf_sk_lookup_kern ctx = {
>>     1.05 :   ffffffff817f8635:       xor    %eax,%eax
>>     0.00 :   ffffffff817f8637:       mov    $0x6,%ecx
>>     0.01 :   ffffffff817f863c:       movl   $0x110002,0x40(%rsp)
>>     0.00 :   ffffffff817f8644:       lea    0x48(%rsp),%rdi
>>    18.76 :   ffffffff817f8649:       rep stos %rax,%es:(%rdi)
>>     1.12 :   ffffffff817f864c:       mov    0xc(%rsp),%eax
>>     0.00 :   ffffffff817f8650:       mov    %ebp,0x48(%rsp)
>>     0.00 :   ffffffff817f8654:       mov    %eax,0x44(%rsp)
>>     0.00 :   ffffffff817f8658:       movzwl 0x10(%rsp),%eax
>>     1.21 :   ffffffff817f865d:       mov    %ax,0x60(%rsp)
>>     0.00 :   ffffffff817f8662:       movzwl 0x20(%rsp),%eax
>>     0.00 :   ffffffff817f8667:       mov    %ax,0x62(%rsp)
>>          :                      .sport          = sport,
>>          :                      .dport          = dport,
>>          :                      };
>
> Such heavy hit to zero init 56-byte structure is surprising.
> There are two 4-byte holes in this struct. You can try to pack it and
> make sure that 'rep stoq' is used instead of 'rep stos' (8 byte at a time vs 4).

Thanks for the tip. I'll give it a try.

> Long term we should probably stop doing *_kern style of ctx passing
> into bpf progs.
> We have BTF, CO-RE and freplace now. This old style of memset *_kern and manual
> ctx conversion has performance implications and annoying copy-paste of ctx
> conversion routines.
> For this particular case instead of introducing udp4_lookup_run_bpf()
> and copying registers into stack we could have used freplace of
> udp4_lib_lookup2.
> More verifier work needed, of course.
> My main point that existing approach "lets prep args for bpf prog to
> run" that is used
> pretty much in every bpf hook is no longer necessary.

Andrii has also suggested leveraging BTF [0], but to expose the *_kern
struct directly to BPF prog instead of emitting ctx access instructions.

What I'm curious about is if we get rid of prepping args and ctx
conversion, then how do we limit what memory BPF prog can access?

Say, I'm passing a struct sock * to my BPF prog. If it's not a tracing
prog, then I don't want it to have access to everything that is
reachable from struct sock *. This is where this approach currently
breaks down for me.

[0] https://lore.kernel.org/bpf/CAEf4BzZ7-0TFD4+NqpK9X=Yuiem89Ug27v90fev=nn+3anCTpA@mail.gmail.com/
