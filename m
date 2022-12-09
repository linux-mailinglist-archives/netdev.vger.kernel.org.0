Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C139648A62
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 22:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLIVxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 16:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLIVxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 16:53:09 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7734E1D65D;
        Fri,  9 Dec 2022 13:53:08 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso6559679wmb.0;
        Fri, 09 Dec 2022 13:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e04fWdrgLrCJ7xFCCYgZ998Z3D+QTmt0l/uRKckiRY0=;
        b=KAm7RhPjXfPzcHcAK7ilA1CutcIi95JHKl4ciiUhFrim3Lw+wQZN1Itcuw6khB8PZi
         PoOrCc+0fEqXI6a3P3vIhq3pNvStYW+b++lC3QPSzfKBhIN6xeNqHIf85FU3RuiTFzmo
         pshJVQfsAmaRqZa9kLkuQLOTM+WgP7zM4E/W2m3gHFOK4a7DVi2QB9qvYIWb4Bpz/h2i
         RY5rWBpAXSF3uM1PC2CRbZfYZ+7jAorTQ7Idv2EY+9rJsvFr2s+noV9PPSS8vga5pPJa
         bWC/bbiUT+REQ2wf26Awzehetfy1Mj1xuteL5zXXxPcnGTpwR0YKJXKvoS7PxQy19HwP
         Z/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e04fWdrgLrCJ7xFCCYgZ998Z3D+QTmt0l/uRKckiRY0=;
        b=FXZiEgCFHzmyMQqAeEVZF1nlR/u0Lz4YE6ytbwZd016be8O9xm4g7Dvk+T9Hfsjwlh
         KgcGM2bBW4vDH9qa0kNhsR9cPvRWtiFL5bjwBdHBWQarZPiT516um6QcsS7Z13p8CIzw
         N1ebjeUDKaGgooVB5R+75zTqUney2t7lpwhdgeQA08RVyxeEpmVqvY09gNuG6jsN0Vpo
         +6MXop13yP5uILpvYPlC1PKhj4CvFRRtq022drxzev+yIbqhTBuYTrEnQ4gjzOD+CQe9
         /EIwT/xcFKfwc5cW3COeRQZNSrYScDmMx7aeGS7Bxgn1eFn0unKMobhI3b1aqpPI+qtU
         O+iw==
X-Gm-Message-State: ANoB5pmJRHBZk5VR8hUb2Jp9ArGsRHlPQ/x0Ip+MCg3NQEkkpt4l16vJ
        k+79Ik/xDTCEsUKDnpHPuZg=
X-Google-Smtp-Source: AA0mqf7i9Wkuh/QW7GPUQeMM7VV0Wffu8wnytmIeaumPpoCJSGte+QMkhGRVyXjsEHmdWisdHfisZA==
X-Received: by 2002:a1c:4b16:0:b0:3cf:7197:e68a with SMTP id y22-20020a1c4b16000000b003cf7197e68amr6142506wma.18.1670622786829;
        Fri, 09 Dec 2022 13:53:06 -0800 (PST)
Received: from krava ([83.240.62.58])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c154900b003d2157627a8sm830998wmg.47.2022.12.09.13.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 13:53:06 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 9 Dec 2022 22:53:04 +0100
To:     Yonghong Song <yhs@meta.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5OuQNmkoIvcV6IL@krava>
References: <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
 <Y5Inw4HtkA2ql8GF@krava>
 <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava>
 <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:31:06PM -0800, Yonghong Song wrote:
> 
> 
> On 12/9/22 7:20 AM, Jiri Olsa wrote:
> > On Fri, Dec 09, 2022 at 02:50:55PM +0100, Jiri Olsa wrote:
> > > On Fri, Dec 09, 2022 at 12:22:37PM +0100, Jiri Olsa wrote:
> > > 
> > > SBIP
> > > 
> > > > > > > > > > 
> > > > > > > > > > I'm trying to understand the severity of the issues and
> > > > > > > > > > whether we need to revert that commit asap since the merge window
> > > > > > > > > > is about to start.
> > > > > > > > > 
> > > > > > > > > Jiri, Peter,
> > > > > > > > > 
> > > > > > > > > ping.
> > > > > > > > > 
> > > > > > > > > cc-ing Thorsten, since he's tracking it now.
> > > > > > > > > 
> > > > > > > > > The config has CONFIG_X86_KERNEL_IBT=y.
> > > > > > > > > Is it related?
> > > > > > > > 
> > > > > > > > sorry for late reply.. I still did not find the reason,
> > > > > > > > but I did not try with IBT yet, will test now
> > > > > > > 
> > > > > > > no difference with IBT enabled, can't reproduce the issue
> > > > > > > 
> > > > > > 
> > > > > > ok, scratch that.. the reproducer got stuck on wifi init :-\
> > > > > > 
> > > > > > after I fix that I can now reproduce on my local config with
> > > > > > IBT enabled or disabled.. it's something else
> > > > > 
> > > > > I'm getting the error also when reverting the static call change,
> > > > > looking for good commit, bisecting
> > > > > 
> > > > > I'm getting fail with:
> > > > >     f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
> > > > > 
> > > > > v6.1-rc1 is ok
> > > > 
> > > > so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far
> > > > 
> > > > attaching some more logs
> > > 
> > > looking at the code.. how do we ensure that code running through
> > > bpf_prog_run_xdp will not get dispatcher image changed while
> > > it's being exetuted
> > > 
> > > we use 'the other half' of the image when we add/remove programs,
> > > but could bpf_dispatcher_update race with bpf_prog_run_xdp like:
> > > 
> > > 
> > > cpu 0:                                  cpu 1:
> > > 
> > > bpf_prog_run_xdp
> > >     ...
> > >     bpf_dispatcher_xdp_func
> > >        start exec image at offset 0x0
> > > 
> > >                                          bpf_dispatcher_update
> > >                                                  update image at offset 0x800
> > >                                          bpf_dispatcher_update
> > >                                                  update image at offset 0x0
> > > 
> > >        still in image at offset 0x0
> > > 
> > > 
> > > that might explain why I wasn't able to trigger that on
> > > bare metal just in qemu
> > 
> > I tried patch below and it fixes the issue for me and seems
> > to confirm the race above.. but not sure it's the best fix
> > 
> > jirka
> > 
> > 
> > ---
> > diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> > index c19719f48ce0..6a2ced102fc7 100644
> > --- a/kernel/bpf/dispatcher.c
> > +++ b/kernel/bpf/dispatcher.c
> > @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
> >   	}
> >   	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> > +	synchronize_rcu_tasks();
> >   	if (new)
> >   		d->image_off = noff;
> 
> This might work. In arch/x86/kernel/alternative.c, we have following
> code and comments. For text_poke, synchronize_rcu_tasks() might be able
> to avoid concurrent execution and update.

so my idea was that we need to ensure all the current callers of
bpf_dispatcher_xdp_func (which should have rcu read lock, based
on the comment in bpf_prog_run_xdp) are gone before and new ones
execute the new image, so the next call to the bpf_dispatcher_update
will be safe to overwrite the other half of the image

jirka

> 
> /**
>  * text_poke_copy - Copy instructions into (an unused part of) RX memory
>  * @addr: address to modify
>  * @opcode: source of the copy
>  * @len: length to copy, could be more than 2x PAGE_SIZE
>  *
>  * Not safe against concurrent execution; useful for JITs to dump
>  * new code blocks into unused regions of RX memory. Can be used in
>  * conjunction with synchronize_rcu_tasks() to wait for existing
>  * execution to quiesce after having made sure no existing functions
>  * pointers are live.
>  */
> void *text_poke_copy(void *addr, const void *opcode, size_t len)
> {
>         unsigned long start = (unsigned long)addr;
>         size_t patched = 0;
> 
>         if (WARN_ON_ONCE(core_kernel_text(start)))
>                 return NULL;
> 
>         mutex_lock(&text_mutex);
>         while (patched < len) {
>                 unsigned long ptr = start + patched;
>                 size_t s;
> 
>                 s = min_t(size_t, PAGE_SIZE * 2 - offset_in_page(ptr), len -
> patched);
> 
>                 __text_poke(text_poke_memcpy, (void *)ptr, opcode + patched,
> s);
>                 patched += s;
>         }
>         mutex_unlock(&text_mutex);
>         return addr;
> }
