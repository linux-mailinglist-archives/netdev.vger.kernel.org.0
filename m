Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32248639D76
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiK0WFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK0WE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:04:59 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294FADF0D;
        Sun, 27 Nov 2022 14:04:58 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b2so5379495eja.7;
        Sun, 27 Nov 2022 14:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BhrDwAocKK7vaUpKzeMtTE437QttaCgRECeOtJHD6vU=;
        b=TBUpUl8dXmyrte2xGLN71xvRZQ9Tf3R7PUe4CsDo475gkzUSc2YWJxJiG9hNZJj4/b
         E8sAkl62KqJpHehRfQah9iDTsFxLTMl2AkVvO0aEX674B6u/YI6a/uqmPBkCXzTGEZWx
         TVg4W2B1BvtNqVCOgGy66iD8v8LPV9HDY6zX6C15dNQINs5xk+tKd0v1oGVSnV3F1dBu
         Ew/vCpTSGhBmUK3SoO7iAxRimLNooyOFZziKb+wkeQgk05MgFi6g6sTzZJqzRhO+dABT
         uNVJjtTeaQrsdEP5KzbCodRIcfS+NjaYfW39iR3x341JePgKKLBkvb28V8AzO1vkcPJx
         wyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhrDwAocKK7vaUpKzeMtTE437QttaCgRECeOtJHD6vU=;
        b=JJp1YXamb1Mcin3P5X0RmLChKw00M1hsPZLMSz55qjszGFDwMRJ4CGmQrE/IQtnysC
         1Lc46xshXTK9lUTm5BOT7oCAVNl4JxTxHNiqsCsUDkYNbpmPqekf42ZH6kZLfUDh0QKd
         zuuELCdllEuflTXIP3dbAjDsAlANLgX1oAYxcVGBejMIialRvlrMIPHqrVomritpHLUu
         RP3Fy+Zr4fMZPwIDxUPkxAOQtM1Qdc7HOPkeeKDXf/vNlNArSlMyalhtyE9gz5hcjmyd
         V/aI0wxBSGH8Gmyeol9xyfvmf31uVe33DaazNi5whkGthZZboUARUKpeWvMbqpKgNxBO
         65+A==
X-Gm-Message-State: ANoB5pnZODgFzNFKqc0bGM4M4NxqdSDmMeMQNkRJWf3CRnov7CikRHnP
        BoNi8M6Ck0HWMGgw5hKEg9XmrlBTKAi8qw==
X-Google-Smtp-Source: AA0mqf7hQWxfAnfborEq7VESDYCQHN53vZhbd9I7DsK2hVHsppxuFUYOFTrZkr/MBoakrUbZrL2UXw==
X-Received: by 2002:a17:906:1585:b0:7ad:84c7:502d with SMTP id k5-20020a170906158500b007ad84c7502dmr26984398ejd.177.1669586696590;
        Sun, 27 Nov 2022 14:04:56 -0800 (PST)
Received: from krava ([83.240.61.69])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906200a00b00781dbdb292asm4158692ejo.155.2022.11.27.14.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 14:04:56 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sun, 27 Nov 2022 23:04:53 +0100
To:     "Chen, Hu1" <hu1.chen@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <olsajiri@gmail.com>, jpoimboe@kernel.org,
        memxor@gmail.com, bpf@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Message-ID: <Y4PfBZpdZL00tDMu@krava>
References: <20221122073244.21279-1-hu1.chen@intel.com>
 <Y3zTF0CjQFt/dR2M@krava>
 <Y3zZQpHNQ8cRjKQY@hirez.programming.kicks-ass.net>
 <d6555f27-95bf-5474-3006-6f8d399ab556@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6555f27-95bf-5474-3006-6f8d399ab556@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 09:44:29PM +0800, Chen, Hu1 wrote:
> On 11/22/2022 10:14 PM, Peter Zijlstra wrote:
> > On Tue, Nov 22, 2022 at 02:48:07PM +0100, Jiri Olsa wrote:
> >> On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
> >>> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> >>> following BUG:
> >>>
> >>>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> >>>   ------------[ cut here ]------------
> >>>   kernel BUG at arch/x86/kernel/traps.c:254!
> >>>   invalid opcode: 0000 [#1] PREEMPT SMP
> >>>   <TASK>
> >>>    asm_exc_control_protection+0x26/0x50
> >>>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> >>>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> >>> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> >>>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> >>>    bpf_map_free_kptrs+0x2e/0x70
> >>>    array_map_free+0x57/0x140
> >>>    process_one_work+0x194/0x3a0
> >>>    worker_thread+0x54/0x3a0
> >>>    ? rescuer_thread+0x390/0x390
> >>>    kthread+0xe9/0x110
> >>>    ? kthread_complete_and_exit+0x20/0x20
> >>>
> >>> This is because there are no compile-time references to the destructor
> >>> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
> >>> them sealable and ENDBR in the functions were sealed (converted to NOP)
> >>> by apply_ibt_endbr().
> > 
> > If there is no compile time reference to it, what stops an LTO linker
> > from throwing it out in the first place?
> >
> 
> Ah, my stupid.
> 
> The only references to this function from kernel space are:
>     $ grep -r bpf_kfunc_call_test_release
>     net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
>     net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
>     net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)
> 
> Macro BTF_ID_... puts the function names to .BTF_ids section. It looks
> like:
> __BTF_ID__func__bpf_kfunc_call_test_release__692

bpf_kfunc_call_test_release test function called bpf program as kfunc
(check tools/testing/selftests/bpf/progs/*.c)

it's placed in BTF ID lists so verifier can validate its ID when called
from bpf program.. it has no other caller from kernel side

jirka

> 
> When running, it uses kallsyms_lookup_name() to find the function
> address via names in .BTF_ids section.
> 
> 
> Hi jirka,
> Please kindly correct me if my understanding of BTF_ids is wrong.
