Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34542502E49
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 19:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343862AbiDORPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 13:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiDORPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 13:15:12 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4519BAC5;
        Fri, 15 Apr 2022 10:12:43 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id c125so1585518iof.9;
        Fri, 15 Apr 2022 10:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrjUGuM6rsjd8l4kfiI/+ZvHzPP7KdnaSgcThC3AV8o=;
        b=kKdXm1SFgaU0iXA2vligFziQ2tI3e4EIcf2e7gI9zKaVVjoJhwqa6nil1gW6QuZQcX
         yTfkNxFYkQabvpe3wRuWqWHLTF6CpllydvcNWtRCILfdfOR5A63e2ts7V2n6xzxOsJpG
         Y4aq1E0Z23FtIuzyB8xUYBJg6qyRNu5J43LfRlXIp49m7Rq7gUl0mfxkV0kqxxxk8fly
         eQRSN0sUhANtHFudZbLuk4Nw/mGjSIBoVboWUuwBJUTqF8wImuscttw8qag/vC/gBaCA
         v8WKOJzooa3wSHSmQfhzNL7BHJXQum0JWnLtwlIVyivtFiBpBZKILiGPhpyH2fOmH/zr
         etug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrjUGuM6rsjd8l4kfiI/+ZvHzPP7KdnaSgcThC3AV8o=;
        b=NCTZQOpJh6WRWa2wP2fsV+xVT11hFBauk334ATqklZ2TVQz8UyHUEppn1l6HRNW6Ww
         oD6ddO8AbFu3M8QurbD2nJNGungnK4fcVNCVwBgA9y0OuG0vs+Ql18jRehDmTyVSlxtp
         o1JtIPphPD/uz6F9lKZYFqsGhD1UOa+8M9+inigJ+WiITc3h7vJi7Oo6j1h5b5FwCX/h
         RKQDYS1ftaxOrA2qJU7JAXW0V/qKesfB0NJZgJwiHWJg8iyVt92Ya22BnNnCZWB8Xn2B
         KWekKMnUY+Uh1lT4Vq9yxpAey2nmO6UFnueLDDmAQgPQcdZTDreTvV+zlvzQUzmtiFhl
         rxbg==
X-Gm-Message-State: AOAM5321lRDISJNOIL54u5BC9qF63xma6aBQv3t7KGjuALyCFehOqEhu
        vNqnWtTUWvOjmzV4wk0KDElmhEIie7KEWdYimI8=
X-Google-Smtp-Source: ABdhPJzxTm55bqpj9D4DAFEW2P37c3B5S+N0gPMJy7zffSpWPkEiz3q0FQyy5x0p9Pr8mdpZ/LMosfy/lWxTiQuG6ZA=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr3603490ioi.154.1650042762884; Fri, 15
 Apr 2022 10:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220414162220.1985095-1-xukuohai@huawei.com> <20220414162220.1985095-6-xukuohai@huawei.com>
In-Reply-To: <20220414162220.1985095-6-xukuohai@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Apr 2022 10:12:31 -0700
Message-ID: <CAEf4Bzb_R56wAuD-Wgg7B5brT-dcsa+5sYynY+_CFzRwg+N5AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/6] bpf, arm64: bpf trampoline for arm64
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>,
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
        KP Singh <kpsingh@kernel.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 9:10 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> Add bpf trampoline support for arm64. Most of the logic is the same as
> x86.
>
> fentry before bpf trampoline hooked:
>  mov x9, x30
>  nop
>
> fentry after bpf trampoline hooked:
>  mov x9, x30
>  bl  <bpf_trampoline>
>
> Tested on qemu, result:
>  #55 fentry_fexit:OK
>  #56 fentry_test:OK
>  #58 fexit_sleep:OK
>  #59 fexit_stress:OK
>  #60 fexit_test:OK
>  #67 get_func_args_test:OK
>  #68 get_func_ip_test:OK
>  #101 modify_return:OK
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---

Can you please also take a look at [0], which is an ongoing work to
add support for BPF cookie to BPF trampoline-based BPF programs. It's
very close to being done, so it would be good if you can implement
that at the same time.

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20220412165555.4146407-4-kuifeng@fb.com/

>  arch/arm64/net/bpf_jit.h      |  14 +-
>  arch/arm64/net/bpf_jit_comp.c | 338 +++++++++++++++++++++++++++++++++-
>  2 files changed, 348 insertions(+), 4 deletions(-)
>

[...]
