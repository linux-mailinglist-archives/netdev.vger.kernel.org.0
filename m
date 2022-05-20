Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087BF52F4E8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbiETVSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiETVSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:18:36 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA7319C74A;
        Fri, 20 May 2022 14:18:34 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id n23so12335896edy.0;
        Fri, 20 May 2022 14:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DDu/yTLze4KFg1yFxzaUGUfDQmxCo5o2Ixng2muyqhM=;
        b=cGT/MLA73M02bfwmF153L+N9j9VGqt4svVWLmTvd8me8wufermxRixpqT7FiftfEWw
         snz0jt0fvMmRJycvtC19EfxtGK0uJLEpqsINRZHAIqqJGJAidG3GhnE1JcDorl4KbQX0
         U/yijzz++jneJNOfIv0LL0x7C6yfmr7DX6xT3nJk9Zto9Ra+FvcvEXKvVoeiVSAsGFdv
         qw0xXE4mEi5xNL1V+f/6usYfu8dha1bsepuEf309yAsCpxjkgzYvoOeO4WkooK7VEDev
         i+6XuTpJ/+khHFt4PCt8ogJCs284JujSoeaCEdicl39lyA+h5ojY5er7SAf3ZrVTH/Pr
         g42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DDu/yTLze4KFg1yFxzaUGUfDQmxCo5o2Ixng2muyqhM=;
        b=xaYTWvq3jB9ymqJwktTlOmu5PrnxZWNgSSOTcw1f8ONkEqAtSkoxbSmd4aTAB+bH9Z
         /vXBnGOt+a8+Z0nh4W4zlwE1nziC6Q5B1gpM1nd7lItRIU3BRfVU12mAOS4i6KC+oBTZ
         axDnArJ5aNepuCCpqF2URxBtIbmS5TZ2HywDxTAgHyyKLmUjiIGIAunbw0kVYOiZ8yp4
         boiTZCH4DdK2jj+v9H2pkVjsbvxAIQz9gunfQ1LTzlFRhniejiRO9vbIrId+LSz8Xxz0
         stZ5MQKX3tniZgD4yKDtIx67h20BU1EVom+1hAlzwe5GGfLiT3g6y5AqOQpurNfET5Ud
         3CLw==
X-Gm-Message-State: AOAM530PEmh0BHEPZmM1WfpPA+KWTh7nRlRQ/xjDkxPNcxAfQzsUJuT6
        CKZFAeL2GUO6yqDTHp3cPxbymmgllpVdekWWenHKkuMa
X-Google-Smtp-Source: ABdhPJxjcBduBZ+3KMZKwOS16jDqf/LZsYbh4MNzUOUwuzvLfR/ciHJ9IfIzVmNsXrghMzHXByJKIR7piKRMzcpmlSM=
X-Received: by 2002:a05:6402:1d48:b0:427:dfa3:2272 with SMTP id
 dz8-20020a0564021d4800b00427dfa32272mr12914264edb.333.1653081513187; Fri, 20
 May 2022 14:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220518131638.3401509-1-xukuohai@huawei.com> <20220518131638.3401509-6-xukuohai@huawei.com>
In-Reply-To: <20220518131638.3401509-6-xukuohai@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 May 2022 14:18:20 -0700
Message-ID: <CAADnVQJr8Sc5d+XUAY2UnNbZ2TP5OCAQNm3eyTponbMfcpXbkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/6] bpf, arm64: bpf trampoline for arm64
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 6:54 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> Add bpf trampoline support for arm64. Most of the logic is the same as
> x86.
>
> Tested on raspberry pi 4b and qemu with KASLR disabled (avoid long jump),
> result:
>  #9  /1     bpf_cookie/kprobe:OK
>  #9  /2     bpf_cookie/multi_kprobe_link_api:FAIL
>  #9  /3     bpf_cookie/multi_kprobe_attach_api:FAIL
>  #9  /4     bpf_cookie/uprobe:OK
>  #9  /5     bpf_cookie/tracepoint:OK
>  #9  /6     bpf_cookie/perf_event:OK
>  #9  /7     bpf_cookie/trampoline:OK
>  #9  /8     bpf_cookie/lsm:OK
>  #9         bpf_cookie:FAIL
>  #18 /1     bpf_tcp_ca/dctcp:OK
>  #18 /2     bpf_tcp_ca/cubic:OK
>  #18 /3     bpf_tcp_ca/invalid_license:OK
>  #18 /4     bpf_tcp_ca/dctcp_fallback:OK
>  #18 /5     bpf_tcp_ca/rel_setsockopt:OK
>  #18        bpf_tcp_ca:OK
>  #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
>  #51 /2     dummy_st_ops/dummy_init_ret_value:OK
>  #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
>  #51 /4     dummy_st_ops/dummy_multiple_args:OK
>  #51        dummy_st_ops:OK
>  #55        fentry_fexit:OK
>  #56        fentry_test:OK
>  #57 /1     fexit_bpf2bpf/target_no_callees:OK
>  #57 /2     fexit_bpf2bpf/target_yes_callees:OK
>  #57 /3     fexit_bpf2bpf/func_replace:OK
>  #57 /4     fexit_bpf2bpf/func_replace_verify:OK
>  #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
>  #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
>  #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
>  #57 /8     fexit_bpf2bpf/func_replace_multi:OK
>  #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
>  #57        fexit_bpf2bpf:OK
>  #58        fexit_sleep:OK
>  #59        fexit_stress:OK
>  #60        fexit_test:OK
>  #67        get_func_args_test:OK
>  #68        get_func_ip_test:OK
>  #104       modify_return:OK
>  #237       xdp_bpf2bpf:OK
>
> bpf_cookie/multi_kprobe_link_api and bpf_cookie/multi_kprobe_attach_api
> failed due to lack of multi_kprobe on arm64.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>

Catalin, Will, Mark,

could you please ack this patch that you don't mind us
taking this set through bpf-next ?
