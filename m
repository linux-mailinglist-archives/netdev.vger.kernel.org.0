Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4855163EFE4
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiLALuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiLALuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:50:40 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2614AA056A;
        Thu,  1 Dec 2022 03:50:39 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id o13so3629776ejm.1;
        Thu, 01 Dec 2022 03:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1mHYW7QBgRCxEy3sQjKWQKEVvYIuKwT9l/MfIuCMVow=;
        b=b6sLZx69YXAEjKUn16Ge/paNCrmNWedAl53ZpUYw7fpNoXrVT5N0UXknFnlfao4Ce0
         tGA0fUe1eKUJk/7pKjYCttExGPtnXUzgWqc9DMk5G1fsF4kiRXRbIpg0/zB+T/ReLhUx
         bqkSblyn5YOCwsnGGPruYSkigDqwroAoopNeLPH0ET0k+mvDKoRoGfSwnTooFEQHpu8h
         GT5Fi4hbPOo9Dq1nLOisN8F7HFI+2MYy4WFVvmIBtF67eFSz7qa1iC+jGQTlxw3KmBJ8
         1ML8m/meDyn8O+/8nxJn93/S7zYtqkDo6Rd0G2o8ijBQVoapvf0w2fyPTL5v0F6rfnsY
         mBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1mHYW7QBgRCxEy3sQjKWQKEVvYIuKwT9l/MfIuCMVow=;
        b=l6MTM7d3BXptMv7Nvspq4Qdwaufp6p1yVlEKb70Lm2d1bImvIL6E1Q+dxXJms1Mqrq
         PINhwa4TCfIUM09nZItzCmE4dvnf9Juz4JqwH1mGYnVP0EBfLev4D9A174Vua+QP1Zri
         LDBCedOXeaJxHRXVbqVVVrbGjSWSkkAgoqWST95sbtyi+RV3K8XocsthpfUnLNW0LFZv
         K0qo7z5U704Qsp5h5aF4NIbJWNzgJvOiox0ReLZtQenFIP0fXGq8x6G2NRoEk+P+uhHE
         YZKwcflRXRQUpRGbZvbZt8iub/3T8CHOA4wkEowOCh3vbFv1ayXdhouCaIdNrTBp0HlO
         btFA==
X-Gm-Message-State: ANoB5pkK3ZwheRXGUNZk4w3vPIWvb0aZqJi/qhHhWpbjrVNTSoS0y9D1
        QbMjEN4BeCHNnlzZpI2V8aM=
X-Google-Smtp-Source: AA0mqf4EtvYipEcgfGaagQRoYu76SgWuwW2Ge5CLfuwLdGnjvuL65Eigs0XilHrBW/pb3dcGP9HC3Q==
X-Received: by 2002:a17:906:a052:b0:7be:beb3:1343 with SMTP id bg18-20020a170906a05200b007bebeb31343mr18794061ejb.211.1669895437481;
        Thu, 01 Dec 2022 03:50:37 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id q18-20020a1709066b1200b007bf988ce9f7sm1708749ejr.38.2022.12.01.03.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:50:36 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 1 Dec 2022 12:50:34 +0100
To:     "Chen, Hu1" <hu1.chen@intel.com>
Cc:     Yonghong Song <yhs@meta.com>, jpoimboe@kernel.org,
        memxor@gmail.com, bpf@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v3] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Message-ID: <Y4iVCmBS1fbTw63o@krava>
References: <20221130101135.26806-1-hu1.chen@intel.com>
 <a1745d9b-4bfc-50d2-8da6-7631ae2b24d0@meta.com>
 <aadf45b9-b6e1-256d-c618-31b65e9f7161@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aadf45b9-b6e1-256d-c618-31b65e9f7161@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 04:07:56PM +0800, Chen, Hu1 wrote:
> On 12/1/2022 12:52 AM, Yonghong Song wrote:
> >  
> >  
> >  On 11/30/22 2:11 AM, Chen Hu wrote:
> > > With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> > > following BUG:
> > >
> > >    traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> > >    ------------[ cut here ]------------
> > >    kernel BUG at arch/x86/kernel/traps.c:254!
> > >    invalid opcode: 0000 [#1] PREEMPT SMP
> > >    <TASK>
> > >     asm_exc_control_protection+0x26/0x50
> > >    RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> > >    Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> > >     0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> > >         <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> > >     bpf_map_free_kptrs+0x2e/0x70
> > >     array_map_free+0x57/0x140
> > >     process_one_work+0x194/0x3a0
> > >     worker_thread+0x54/0x3a0
> > >     ? rescuer_thread+0x390/0x390
> > >     kthread+0xe9/0x110
> > >     ? kthread_complete_and_exit+0x20/0x20
> > >
> > > It turns out that ENDBR in bpf_kfunc_call_test_release() is converted to
> > > NOP by apply_ibt_endbr().
> > >
> > > The only text references to this function from kernel side are:
> > >
> > >    $ grep -r bpf_kfunc_call_test_release
> > >    net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(...)
> > >    net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, ...)
> > >    net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)

Alexei mentioned we could now move these ^^^ into kernel module:
  https://lore.kernel.org/bpf/CAADnVQJ4xaAacOUpzMG+bm2WK5u=1YLo5kLUL+RP3JZGW3Sfww@mail.gmail.com/

would it help? not sure objtool scans modules as well

but we'd still need fix for bpf_obj_new_impl/bpf_obj_drop_impl below

jirka

> >  
> >  We have some other function like this. For example, some newly added
> >  functions like bpf_obj_new_impl(), bpf_obj_drop_impl(), do they have
> >  the same missing endbr problem? If this is the case, we need a
> >  general solution.
> >
> 
> bpf_obj_new_impl(), bpf_obj_drop_impl() also miss the ENDBR. Below is
> the disassembly on bpf-next kernel:
> 
> (gdb) disas bpf_obj_drop_impl
> Dump of assembler code for function bpf_obj_drop_impl:
>    0xffffffff81288e40 <+0>:     nopw   (%rax)
>    0xffffffff81288e44 <+4>:     nopl   0x0(%rax,%rax,1)
>    0xffffffff81288e49 <+9>:     push   %rbp
>    ...
> 
> (gdb) disas bpf_obj_new_impl
> Dump of assembler code for function bpf_obj_new_impl:
>    0xffffffff81288cd0 <+0>:     nopw   (%rax)
>    0xffffffff81288cd4 <+4>:     nopl   0x0(%rax,%rax,1)
>    0xffffffff81288cd9 <+9>:     push   %rbp
>    ...
> 
> The first insn in the bpf_obj_new_impl has been converted from ENDBR to
> nopw by objtool. If the function is indirectly called on IBT enabled CPU
> (Tigerlake for example), #CP raise.
> 
> Looks like the possible fix in this patch is general?
> If we don't want to seal a funciton, we use macro IBT_NOSEAL to claim.
> IBT_NOSEAL just creates throwaway dummy compile-time references to the
> functions. The section is already thrown away when kernel run. See
> commit e27e5bea956c by Josh Poimboeuf.
> 
> > >
> > > but it may be called from bpf program as kfunc. (no other caller from
> > > kernel)
> > >
> > > This fix creates dummy references to destructor kfuncs so ENDBR stay
> > > there.
> > >
> > > Also modify macro XXX_NOSEAL slightly:
> > > - ASM_IBT_NOSEAL now stands for pure asm
> > > - IBT_NOSEAL can be used directly in C
> > >
> > > Signed-off-by: Chen Hu <hu1.chen@intel.com>
> > > Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> > > ---
> > > v3:
> > > - Macro go to IBT related header as suggested by Jiri Olsa
> > > - Describe reference to the func clearly in commit message as suggested
> > >    by Peter Zijlstra and Jiri Olsa
> > >   v2: https://lore.kernel.org/all/20221122073244.21279-1-hu1.chen@intel.com/
> > >
> > > v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
> > >
> > >   arch/x86/include/asm/ibt.h | 6 +++++-
> > >   arch/x86/kvm/emulate.c     | 2 +-
> > >   net/bpf/test_run.c         | 5 +++++
> > >   3 files changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
> > > index 9b08082a5d9f..be86dc31661c 100644
> > > --- a/arch/x86/include/asm/ibt.h
> > > +++ b/arch/x86/include/asm/ibt.h
> > > @@ -36,11 +36,14 @@
> > >    * the function as needing to be "sealed" (i.e. ENDBR converted to NOP by
> > >    * apply_ibt_endbr()).
> > >    */
> > > -#define IBT_NOSEAL(fname)                \
> > > +#define ASM_IBT_NOSEAL(fname)                \
> > >       ".pushsection .discard.ibt_endbr_noseal\n\t"    \
> > >       _ASM_PTR fname "\n\t"                \
> > >       ".popsection\n\t"
> > >   +#define IBT_NOSEAL(name)                \
> > > +    asm(ASM_IBT_NOSEAL(#name))
> > > +
> > >   static inline __attribute_const__ u32 gen_endbr(void)
> > >   {
> > >       u32 endbr;
> > > @@ -94,6 +97,7 @@ extern __noendbr void ibt_restore(u64 save);
> > >   #ifndef __ASSEMBLY__
> > >     #define ASM_ENDBR
> > > +#define ASM_IBT_NOSEAL(name)
> > >   #define IBT_NOSEAL(name)
> > >     #define __noendbr
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index 4a43261d25a2..d870c8bb5831 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -327,7 +327,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
> > >       ".type " name ", @function \n\t" \
> > >       name ":\n\t" \
> > >       ASM_ENDBR \
> > > -    IBT_NOSEAL(name)
> > > +    ASM_IBT_NOSEAL(name)
> > >     #define FOP_FUNC(name) \
> > >       __FOP_FUNC(#name)
> > > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > > index fcb3e6c5e03c..9e9c8e8d50d7 100644
> > > --- a/net/bpf/test_run.c
> > > +++ b/net/bpf/test_run.c
> > > @@ -601,6 +601,11 @@ noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
> > >   {
> > >   }
> > >   +#ifdef CONFIG_X86_KERNEL_IBT
> > > +IBT_NOSEAL(bpf_kfunc_call_test_release);
> > > +IBT_NOSEAL(bpf_kfunc_call_memb_release);
> > > +#endif
> > > +
> > >   noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
> > >   {
> > >       WARN_ON_ONCE(1);
