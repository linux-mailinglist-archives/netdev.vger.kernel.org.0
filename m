Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AB8508739
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348035AbiDTLpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 07:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238863AbiDTLpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 07:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4B141601
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 04:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89BD66195A
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 11:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E920BC385B2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650454987;
        bh=SJX0hL833Q2ataycRYrB6BhXBqWa4plfzhGevB+mLF0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oM1KQON57Ca6wBOgHh+FwifBZLN62uNymm74lCFy5MxgS/8YQn5HfvBjWuMraqk8r
         8xanKPCKTIW0/Zxdzggzmp8RVE92mejk9Sq5b7LMEUxuKOqa9AHoOLG4WiuIoiAszo
         xmPJDuxYDBzmf4Qrr61QC+MZdkaP+ch0AKLWPl2Z+C+XL6zdy/Dx1sfTTm98FAycnu
         FUMJm1uEda+QrCbcCHFQI2Fa+4TAJIqN+FE2OMdjAZbV4BHeDQ6lnkuJdFX9zSeLUm
         vByjWYsORkfYyMVKuyrE3+VRH525NnnVm30zHowKwLGimwP8M1z9ax4m+AU19AlCLJ
         OKtbIg/i4yqOA==
Received: by mail-ej1-f52.google.com with SMTP id l7so2994747ejn.2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 04:43:06 -0700 (PDT)
X-Gm-Message-State: AOAM530abdZXJlYB39VekZTSNsThZloC9lGvRchUTiUfvy3aOsWsfeak
        kp3WAk8yLJxvYBDt3fX42kvbIDtdIVi8HKTJ0d8GxA==
X-Google-Smtp-Source: ABdhPJyANcMdvA+ktghYJ4f27ywVan8fgMqIgZ69qYBtSH3bIIwYJZEjs0aaoX0yznuqG16ZBoHNgWlTZ78/VQ4KW/g=
X-Received: by 2002:a17:907:6089:b0:6db:a3d7:3fa9 with SMTP id
 ht9-20020a170907608900b006dba3d73fa9mr18759957ejc.593.1650454985018; Wed, 20
 Apr 2022 04:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220414162220.1985095-1-xukuohai@huawei.com> <20220414162220.1985095-6-xukuohai@huawei.com>
 <CAEf4Bzb_R56wAuD-Wgg7B5brT-dcsa+5sYynY+_CFzRwg+N5AA@mail.gmail.com>
 <6c18a27f-c983-58f3-1dc0-5192f7df232a@huawei.com> <82e7faec-7f0c-573f-4945-de7072744dcb@huawei.com>
In-Reply-To: <82e7faec-7f0c-573f-4945-de7072744dcb@huawei.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 20 Apr 2022 13:42:54 +0200
X-Gmail-Original-Message-ID: <CACYkzJ6QZek1VV-QgO52Kp9X4cCJnXaD7QJFkMtMLtzDTzDDsA@mail.gmail.com>
Message-ID: <CACYkzJ6QZek1VV-QgO52Kp9X4cCJnXaD7QJFkMtMLtzDTzDDsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/6] bpf, arm64: bpf trampoline for arm64
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, hpa@zytor.com,
        Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 9:44 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> On 4/16/2022 9:57 AM, Xu Kuohai wrote:
> > On 4/16/2022 1:12 AM, Andrii Nakryiko wrote:
> >> On Thu, Apr 14, 2022 at 9:10 AM Xu Kuohai <xukuohai@huawei.com> wrote:
> >>>
> >>> Add bpf trampoline support for arm64. Most of the logic is the same as
> >>> x86.
> >>>
> >>> fentry before bpf trampoline hooked:
> >>>  mov x9, x30
> >>>  nop
> >>>
> >>> fentry after bpf trampoline hooked:
> >>>  mov x9, x30
> >>>  bl  <bpf_trampoline>
> >>>
> >>> Tested on qemu, result:
> >>>  #55 fentry_fexit:OK
> >>>  #56 fentry_test:OK
> >>>  #58 fexit_sleep:OK
> >>>  #59 fexit_stress:OK
> >>>  #60 fexit_test:OK
> >>>  #67 get_func_args_test:OK
> >>>  #68 get_func_ip_test:OK
> >>>  #101 modify_return:OK
> >>>
> >>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> >>> Acked-by: Song Liu <songliubraving@fb.com>
> >>> ---
> >>
> >> Can you please also take a look at [0], which is an ongoing work to
> >> add support for BPF cookie to BPF trampoline-based BPF programs. It's
> >> very close to being done, so it would be good if you can implement
> >> that at the same time.
> >
> > OK, I'll take a look and try to implemnt it.
>
> already implemented, but there are some conflicts between these two
> series, will send v3 after trampoline cookie are merged.

Awesome work, Thanks for doing this!
