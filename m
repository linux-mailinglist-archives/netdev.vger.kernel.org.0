Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90476524ADF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 12:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352854AbiELKzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 06:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352562AbiELKz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 06:55:28 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207A5694A4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:55:27 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bv19so9418939ejb.6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=Iwqqdpj/sCrfAf59NaNACtGSTRtAyJeA5sSf5Q8LpGQ=;
        b=RD/cJqYlBYTnZgehRgve3MmDT02PYH0d0jFIKcdNePCxuFtfrzHeL8I0dT95rbUGLD
         jaSKkMYjaWTSLcQ+lPaD98uG4IUjWd8v9P/2ImVWe7cvfWDZnjacKKm+1TIzpX3PPCJb
         u51vcrC2TjaM7nDHHN4Qc/5yuUUyZCZP2wB8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=Iwqqdpj/sCrfAf59NaNACtGSTRtAyJeA5sSf5Q8LpGQ=;
        b=FQrRdRdEd9WLfn5iLZ1hkuhAveleloJ1QUL8JPuSI7TNAZPN4HhTpWOJ0QqZwIR5X2
         I3tlA+JoRfLjGar+FnPN16QtijUR2lNROgrZqN2YP2LSIl6VPf4SyJl3ZyHFzy1nj4Lm
         IsmTX+3Qy8eU6nKsVL0Zalv/BALGwOeyGxngEOyGM0i9MhWUWHatV9Duiu9ABvWyWyYq
         vbRFKosX4bBCTZBFRaxajmpr6XpRdP9kfiL4Uh5J933gecR0tGq9KQmPaqFQx4o4Jzbe
         bpcSW72Vx0omiMz8IVZK9QZD5ExAooHAI2USbwGB5ZX/LhLcg+wIyjWPIk9FUbi7aIrt
         lG/A==
X-Gm-Message-State: AOAM532kgBq+PDszpxCSjM88NuXZprgu7+th3Va83mjlMJMOEmbjigH7
        knpqDk7lTpJn9q5c4vTSIcD31Q==
X-Google-Smtp-Source: ABdhPJyMEDJyGYlUhPgucEhy64Eh9s0++xx90SftrGOnxuQHSGFNdfGoGpgBQc0SpQTahAATxncZkw==
X-Received: by 2002:a17:906:cb97:b0:6f3:c671:a337 with SMTP id mf23-20020a170906cb9700b006f3c671a337mr29293611ejb.93.1652352925651;
        Thu, 12 May 2022 03:55:25 -0700 (PDT)
Received: from cloudflare.com (79.184.128.236.ipv4.supernova.orange.pl. [79.184.128.236])
        by smtp.gmail.com with ESMTPSA id s4-20020a170906a18400b006f52dbc192bsm2043862ejy.37.2022.05.12.03.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 03:55:25 -0700 (PDT)
References: <20220424154028.1698685-1-xukuohai@huawei.com>
 <20220424154028.1698685-6-xukuohai@huawei.com>
 <87ilqdobl1.fsf@cloudflare.com>
 <5fb30cc0-dcf6-75ec-b6fa-38be3e99dca6@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
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
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
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
Subject: Re: [PATCH bpf-next v3 5/7] bpf, arm64: Support to poke bpf prog
Date:   Thu, 12 May 2022 12:54:07 +0200
In-reply-to: <5fb30cc0-dcf6-75ec-b6fa-38be3e99dca6@huawei.com>
Message-ID: <87wneryq8z.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 11:12 AM +08, Xu Kuohai wrote:
> On 5/10/2022 5:36 PM, Jakub Sitnicki wrote:
>> On Sun, Apr 24, 2022 at 11:40 AM -04, Xu Kuohai wrote:

[...]

>>> @@ -281,12 +290,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>>>  	 *
>>>  	 */
>>>  
>>> +	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
>>> +		emit(A64_BTI_C, ctx);
>> 
>> I'm no arm64 expert, but this looks like a fix for BTI.
>> 
>> Currently we never emit BTI because ARM64_BTI_KERNEL depends on
>> ARM64_PTR_AUTH_KERNEL, while BTI must be the first instruction for the
>> jump target [1]. Am I following correctly?
>> 
>> [1] https://lwn.net/Articles/804982/
>> 
>
> Not quite correct. When the jump target is a PACIASP instruction, no
> Branch Target Exception is generated, so there is no need to insert a
> BTI before PACIASP [2].
>
> In order to attach trampoline to bpf prog, a MOV and NOP are inserted
> before the PACIASP, so BTI instruction is required to avoid Branch
> Target Exception.
>
> The reason for inserting NOP before PACIASP instead of after PACIASP is
> that no call frame is built before entering trampoline, so there is no
> return address on the stack and nothing to be protected by PACIASP.
>
> [2]
> https://developer.arm.com/documentation/ddi0596/2021-12/Base-Instructions/BTI--Branch-Target-Identification-?lang=en

That makes sense. Thanks for the explanation!
