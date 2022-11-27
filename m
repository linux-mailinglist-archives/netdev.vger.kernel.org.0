Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426DD639D6F
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 22:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiK0V66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 16:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiK0V65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 16:58:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12F4DEC3;
        Sun, 27 Nov 2022 13:58:53 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id e27so21591562ejc.12;
        Sun, 27 Nov 2022 13:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8WneuvovqJg9O54n9ZaZ83gW6x83/1EomKDZIjrUe/Q=;
        b=FXWtEyuDhgZAe8OekCGTjgcEK9JHPsAU2Ewi1jlAKgz/AlEl2FdMJWLyVxeWD+e+1L
         0VjxCqYde0X3bGvSe/dUjOaKav0I2lr7EpdInOem10LIHUZuCrcPGQgSco4jqd0Tbz44
         B+I+veATLc3P5VgTArIjey7wqlFc/fxr3vvZK9BEfHsOOs1+GKFwFBd8i28K+NgwSD29
         eEY7Ch0P1nCAz0bxH2DcSO3M33cXXoQ1YpLgWydryESU0A/ZsN8D4tlUt3rKb4GY3+Nd
         uw4dilTVXDdGrFOD+l3GNZ32sKDem5LCRnquJqsDbbJXeenfa86N3RQbGbgY+RnP/Eek
         lbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WneuvovqJg9O54n9ZaZ83gW6x83/1EomKDZIjrUe/Q=;
        b=TbFUmgkDvEnWF8UlybvOOhfZZS16FChqriDr56H65SbhEZcufQCQ07565kwT4Elaah
         AdALshiLtWoydaCyoBm/n6rX1jQQDEEmAVSZWeG6gUZQMLFHH7g/fIFgKsY+JI1YNrPe
         K7tobnwHcJdJmmJHCr2EeoYk0V6MlqDCmbmLCR9NjatiTDSb0HWpiHl3Jrn9DhUAEzs/
         mAtHSigwKcueDsjmy95CQQHzjmoP0rQyvHXaXlq5is9LWU9HX50VL07rAcTBX6wa9Q/k
         g/SBpGFHoCRyYbRuva+hCq0BJx8rEn0rJepthDQccSvi53CCHGvYg77Abf/DfhUCdAlN
         un7A==
X-Gm-Message-State: ANoB5pnx4UYDBELONBBdSF8gahpWa5N1+f5uKKirJ5XgFHb6XT1QyIga
        jCyuDJLLOaViVssTCd1MNXE=
X-Google-Smtp-Source: AA0mqf45+B5sWvm4HmZAO5OMdIe0piAHeByCaWfJcvQ9DyS0F6soA3YocepiFka+DNgoC1L1NYbZTw==
X-Received: by 2002:a17:906:49d0:b0:79f:e0b3:3b9b with SMTP id w16-20020a17090649d000b0079fe0b33b9bmr24003074ejv.378.1669586331938;
        Sun, 27 Nov 2022 13:58:51 -0800 (PST)
Received: from krava ([83.240.61.69])
        by smtp.gmail.com with ESMTPSA id d25-20020a50fe99000000b004588ef795easm4428671edt.34.2022.11.27.13.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 13:58:51 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sun, 27 Nov 2022 22:58:48 +0100
To:     "Chen, Hu1" <hu1.chen@intel.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, jpoimboe@kernel.org,
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
        netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Message-ID: <Y4PdmHlCqqVHRDUJ@krava>
References: <20221122073244.21279-1-hu1.chen@intel.com>
 <Y3zTF0CjQFt/dR2M@krava>
 <8b57320c-df41-a19f-e433-07782a709a5c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b57320c-df41-a19f-e433-07782a709a5c@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 09:28:28PM +0800, Chen, Hu1 wrote:
> On 11/22/2022 9:48 PM, Jiri Olsa wrote:
> > On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
> >> With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> >> following BUG:
> >>
> >>   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> >>   ------------[ cut here ]------------
> >>   kernel BUG at arch/x86/kernel/traps.c:254!
> >>   invalid opcode: 0000 [#1] PREEMPT SMP
> >>   <TASK>
> >>    asm_exc_control_protection+0x26/0x50
> >>   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> >>   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> >> 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> >>        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> >>    bpf_map_free_kptrs+0x2e/0x70
> >>    array_map_free+0x57/0x140
> >>    process_one_work+0x194/0x3a0
> >>    worker_thread+0x54/0x3a0
> >>    ? rescuer_thread+0x390/0x390
> >>    kthread+0xe9/0x110
> >>    ? kthread_complete_and_exit+0x20/0x20
> >>
> >> This is because there are no compile-time references to the destructor
> >> kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
> >> them sealable and ENDBR in the functions were sealed (converted to NOP)
> >> by apply_ibt_endbr().
> >>
> >> This fix creates dummy compile-time references to destructor kfuncs so
> >> ENDBR stay there.
> >>
> >> Fixes: 05a945deefaa ("selftests/bpf: Add verifier tests for kptr")
> >> Signed-off-by: Chen Hu <hu1.chen@intel.com>
> >> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> >> ---
> >> v2:
> >> - Use generic macro name and place the macro after function body as
> >> - suggested by Jiri Olsa
> >>
> >> v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/
> >>
> >>  include/linux/btf_ids.h | 7 +++++++
> >>  net/bpf/test_run.c      | 4 ++++
> >>  2 files changed, 11 insertions(+)
> >>
> >> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> >> index 2aea877d644f..db02691b506d 100644
> >> --- a/include/linux/btf_ids.h
> >> +++ b/include/linux/btf_ids.h
> >> @@ -266,4 +266,11 @@ MAX_BTF_TRACING_TYPE,
> >>  
> >>  extern u32 btf_tracing_ids[];
> >>  
> >> +#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
> >> +#define FUNC_IBT_NOSEAL(name)					\
> >> +	asm(IBT_NOSEAL(#name));
> >> +#else
> >> +#define FUNC_IBT_NOSEAL(name)
> >> +#endif /* CONFIG_X86_KERNEL_IBT */
> > 
> > hum, IBT_NOSEAL is x86 specific, so this will probably fail build
> > on other archs.. I think we could ifdef it with CONFIG_X86, but
> > it should go to some IBT related header? surely not to btf_ids.h
> > 
> > cc-ing Peter and Josh
> > 
> > thanks,
> > jirka
> >
> 
> The lkp reports build success because X86_KERNEL_IBT alredy depends on
> X86_64.

ah right, so please just move it to some other header

jirka

> 
> Currently, arch/x86/include/asm/ibt.h which defines macro IBT_NOSEAL is
> x86 specific. How about we just put asm at test_run.c directly (ugly?):
> 
> #if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
> asm(IBT_NOSEAL("bpf_kfunc_call_test_release"));
> asm(IBT_NOSEAL("bpf_kfunc_call_memb_release"));
> #endif
> 
> thanks
> Chen Hu
> 
> > 
> >> +
> >>  #endif
> >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >> index 13d578ce2a09..07263b7cc12d 100644
> >> --- a/net/bpf/test_run.c
> >> +++ b/net/bpf/test_run.c
> >> @@ -597,10 +597,14 @@ noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
> >>  	refcount_dec(&p->cnt);
> >>  }
> >>  
> >> +FUNC_IBT_NOSEAL(bpf_kfunc_call_test_release)
> >> +
> >>  noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
> >>  {
> >>  }
> >>  
> >> +FUNC_IBT_NOSEAL(bpf_kfunc_call_memb_release)
> >> +
> >>  noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
> >>  {
> >>  	WARN_ON_ONCE(1);
> >> -- 
> >> 2.34.1
> >>
