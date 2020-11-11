Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FA12AF7B7
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 19:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgKKSIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKKSIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 13:08:31 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA2BC0613D1;
        Wed, 11 Nov 2020 10:08:31 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e7so2047616pfn.12;
        Wed, 11 Nov 2020 10:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Jc51fArqDzqnCQpXqWk6upQKQfyxMRbqHQ8w/Ym3axI=;
        b=ZGaVIa9ldSyTYvQyZEIUkCDSDI4pWvJfYkqp65BfniFYH0s5ksjgxnUrGMAmmDVLRk
         sMveZn6+W8t+V+EvahMAOtGT8td00LgQSVHNz7F6HZ9NG1M4RQWJGvBLOE9IX+LnHmXC
         b5uosrDTZPfFRVwpUahxE+Rk7GU2bqyQAKGaHm0J3EW8Rqy7d3fztwoe84f/iUQU7G/s
         Mj99Ky57MWM2kAMqicinshajZi3ZTpLmyh4eH4tv0za+D4MqKoQhtsFNqJKLxh4mc2bx
         rh4CXTgAaJaL+z8RPd3IbCf9KUqMNw6kTOs932/AsyLO09LEDsQ6mB74C0j5oBKGlwwY
         3xXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Jc51fArqDzqnCQpXqWk6upQKQfyxMRbqHQ8w/Ym3axI=;
        b=UCMcVrw8VnU76J47Uu3C3rEBYR2JhPILRH/oX4TEgVADRYpLXFRxDDamo7t+RYHf73
         WWKkoW7Fam7ULCC0WwB7kyrD77+IFnlg827R1ztVTvIdRSy47htjsQSHZ8iyYHtaMWQq
         EGDASnyWZMsm/IOas+K431NNUb1RpChNSzLBdxc7SSXERcp3pXyazb12ifaXhFAr2ndn
         LozsgfUtm5VX8dAAaOu3O2izaoi6dnExbhbOVDAPucUN9pGjrJ459RjwbUxWAJMKeJJR
         sI/SsRFqsBHJJbohcEBTHlDS6Sa7LykwWZnLWfKqinK3qft1tlxIGdfvcqzrj/We483C
         R7/A==
X-Gm-Message-State: AOAM531LPgDBiEJ/RptkayPplIQerVn+sVZXDRdJpP77NGQS3qYYNnrY
        7Krcd8IfDDD0J/cCIYcVDYc=
X-Google-Smtp-Source: ABdhPJyiyY044Q0p8oMYklvqWl97Opwf4WdY+uSm/ttMCQNVKpyzbnmMxSIjLnNEcSy1chonY7Q/HA==
X-Received: by 2002:a62:5293:0:b029:18b:5c86:7ad0 with SMTP id g141-20020a6252930000b029018b5c867ad0mr24519914pfb.51.1605118111139;
        Wed, 11 Nov 2020 10:08:31 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:ba8c])
        by smtp.gmail.com with ESMTPSA id e184sm3259212pfe.146.2020.11.11.10.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 10:08:30 -0800 (PST)
Date:   Wed, 11 Nov 2020 10:08:27 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <haliu@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201111180827.cbyljiknmzf5agf2@ast-mbp>
References: <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
 <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
 <11c18a26-72af-2e0d-a411-3148cfbc91be@solarflare.com>
 <20201111005348.v3dtugzstf6ofnqi@ast-mbp>
 <fcd907f2-3f1d-473b-1d07-2803606005c9@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fcd907f2-3f1d-473b-1d07-2803606005c9@solarflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:31:47AM +0000, Edward Cree wrote:
> On 11/11/2020 00:53, Alexei Starovoitov wrote:
> > On Tue, Nov 10, 2020 at 12:47:28PM +0000, Edward Cree wrote:
> >> But I think it illustrates why having to
> >>  interoperate with systems outside their control and mix-and-match
> >>  versioning of various components provides external discipline that
> >>  is sorely needed if the BPF ecosystem is to remain healthy.
> > 
> > I think thriving public bpf projects, startups and established companies
> > that are obviously outside of control of few people that argue here
> > would disagree with your assessment.
> 
> Correct me if I'm wrong, but aren't those bpf projects and companies
>  _things that are written in BPF_, rather than alternative toolchain
>  components for compiling, loading and otherwise wrangling BPF once
>  it's been written?
> It is the latter that I am saying is needed in order to keep BPF
>  infrastructure development "honest", rather than treating the clang
>  frontend as The API and all layers below it as undocumented internal
>  implementation details.
> In a healthy ecosystem, it should be possible to use a compiler,
>  assembler, linker and loader developed separately by four projects
>  unrelated to each other and to the kernel and runtime.  Thanks to
>  well-specified ABIs and file formats, in the C ecosystem this is
>  actually possible, despite the existence of some projects that
>  bundle together multiple components.
> In the BPF ecosystem, instead, it seems like the only toolchain
>  anyone cares to support is latest clang + latest libbpf, and if you
>  try to replace any component of the toolchain with something else,
>  the spec you have to program against is "Go and read the LLVM
>  source code, figure out what it does, and copy that".
> That is not sustainable in the long term.

Absolutely. I agree 100% with above.
BPF ecosystem eventually will get to a point of fixed file format,
linker specification and 1000 page psABI document.
One can argue that when RISCV ISA was invented recently and it came with full
ABI document just like x86 long ago. BPF ISA is different. It grows
"organically". We don't add all possible instructions up front. We don't define
all possible relocation types to ELF. That fundamental difference vs all other
ISAs help BPF follow its own path. Take BTF, for example. No other ISA have
such concept. Yet due to BTF the BPF ecosystem can provide features no other
ISA can. Similar story happens with clang. BPF extended C language _already_.
The BPF C programs have a way to compare types. It is a C language extension.
Did we go to C standard committee and argue for years that such extension is
necessary? Obviously not. Today BPF is, as you correctly pointed out, layers of
undocumented internal details. Obviously we're not content with such situation.
