Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4546A639D8B
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiK0WNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiK0WNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:13:44 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93D7FCDD;
        Sun, 27 Nov 2022 14:13:43 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n21so21677851ejb.9;
        Sun, 27 Nov 2022 14:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IWSnow9K42kiG4FlXCeG2dAprSiEjJ5iy4gmyXQPEIo=;
        b=CJg2LFgbTwU1lJW4n9pFO3RMa4ELlVJGrRzInPf7+IZjLHTl+v74Dv3QqEBYc6Is7g
         Oaw6NquM9atsNcCw2EXfs9D5kYkxnlVYGrYcDhVqQrijfPSehi58qyd1wZ3snTBdNA6S
         IW3qERaaY6lZ2qubalYDh48Fq2LSPJgXgmy+1Bk/G7XrJfcku/KREpzlDOsLu4girF5t
         oOf7rjxIeNMIhdpso3HckwXlJDXtFuKRDAi+VGQawC2gAKo23VUQQXRxd0X+N8L0xN4g
         ESXCkm8Jq5kWfC5kuDvtTcXnO7N6KqyWeTsHLWFEY/KHchjuhzpRHRWHcOLJ/+spt5Py
         gcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWSnow9K42kiG4FlXCeG2dAprSiEjJ5iy4gmyXQPEIo=;
        b=G3ZgfY26kw6fh/Gn0LpCjmjmx9QAXgyzJVgBfLgJVLPIgaZcF4ySUEF6scEOhBauvh
         i9NpjbuRjhMISQacRQ/lx3G5hzQ8PSuZlEQmrc0RA88ii/NG40PPKldZI99A35i5M4X5
         bY2XFcYlcVgLvyH3LLYBHcX8Ks6mhpv4+ZXitRuavGsoy0FGQ542lIawVvgGzVudJX0y
         Od7wR6VtrwCcUVcXMeB/eIdjRYWkSNxUoC8Bt3L7SfJYWNWy4n2g51QY0wHBh5DN+Xxc
         h5M75N8cYCon8rz7G3xQslqhTUosnSyQ9RoQshpVgIfWj92qXxD6IRyCf/48TpX5QtlP
         Nzbg==
X-Gm-Message-State: ANoB5pkVhzP17FZlshTpCvPn73/LLqpHqacvcMShae63K09Vek6yR0X2
        kIy1ZQ9W9p/zegEbfmwfRm5pwQBBl2CBTiz/htI=
X-Google-Smtp-Source: AA0mqf73ubXx+lo0xHhxIAC6+5hGbc2YueCnK/2F/A1SlLXeaeEHVCYDaToPR2Cw+TP8kSpvNRzNTMtV1eI3+Z+cCwI=
X-Received: by 2002:a17:906:34d0:b0:78d:c16e:dfc9 with SMTP id
 h16-20020a17090634d000b0078dc16edfc9mr41260021ejb.327.1669587222107; Sun, 27
 Nov 2022 14:13:42 -0800 (PST)
MIME-Version: 1.0
References: <20221122073244.21279-1-hu1.chen@intel.com> <Y3zTF0CjQFt/dR2M@krava>
 <Y3zZQpHNQ8cRjKQY@hirez.programming.kicks-ass.net> <d6555f27-95bf-5474-3006-6f8d399ab556@intel.com>
 <Y4PfBZpdZL00tDMu@krava>
In-Reply-To: <Y4PfBZpdZL00tDMu@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 27 Nov 2022 14:13:30 -0800
Message-ID: <CAADnVQJ4xaAacOUpzMG+bm2WK5u=1YLo5kLUL+RP3JZGW3Sfww@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     "Chen, Hu1" <hu1.chen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Pengfei Xu <pengfei.xu@intel.com>,
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
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 2:05 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Nov 25, 2022 at 09:44:29PM +0800, Chen, Hu1 wrote:
> > On 11/22/2022 10:14 PM, Peter Zijlstra wrote:
> > > On Tue, Nov 22, 2022 at 02:48:07PM +0100, Jiri Olsa wrote:
> > >> On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
> > >>> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> > >>> following BUG:
> > >>>
> > >>>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> > >>>   ------------[ cut here ]------------
> > >>>   kernel BUG at arch/x86/kernel/traps.c:254!
> > >>>   invalid opcode: 0000 [#1] PREEMPT SMP
> > >>>   <TASK>
> > >>>    asm_exc_control_protection+0x26/0x50
> > >>>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> > >>>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> > >>>   0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> > >>>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> > >>>    bpf_map_free_kptrs+0x2e/0x70
> > >>>    array_map_free+0x57/0x140
> > >>>    process_one_work+0x194/0x3a0
> > >>>    worker_thread+0x54/0x3a0
> > >>>    ? rescuer_thread+0x390/0x390
> > >>>    kthread+0xe9/0x110
> > >>>    ? kthread_complete_and_exit+0x20/0x20
> > >>>
> > >>> This is because there are no compile-time references to the destructor
> > >>> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
> > >>> them sealable and ENDBR in the functions were sealed (converted to NOP)
> > >>> by apply_ibt_endbr().
> > >
> > > If there is no compile time reference to it, what stops an LTO linker
> > > from throwing it out in the first place?
> > >
> >
> > Ah, my stupid.
> >
> > The only references to this function from kernel space are:
> >     $ grep -r bpf_kfunc_call_test_release
> >     net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
> >     net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
> >     net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)
> >
> > Macro BTF_ID_... puts the function names to .BTF_ids section. It looks
> > like:
> > __BTF_ID__func__bpf_kfunc_call_test_release__692
>
> bpf_kfunc_call_test_release test function called bpf program as kfunc
> (check tools/testing/selftests/bpf/progs/*.c)
>
> it's placed in BTF ID lists so verifier can validate its ID when called
> from bpf program.. it has no other caller from kernel side

They were added when we had no ability to call kfuncs from modules.
Now we should probably move all of them to bpf_testmod.
