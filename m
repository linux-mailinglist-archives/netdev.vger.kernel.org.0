Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E00506353
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 06:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348323AbiDSEgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 00:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348298AbiDSEgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 00:36:19 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C73725E80;
        Mon, 18 Apr 2022 21:33:38 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e194so11925683iof.11;
        Mon, 18 Apr 2022 21:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FRol2Ixdapg4j6Uubg8h/Lz+s9FI9j4eiU5OeuRx7x0=;
        b=LY5NLAdXfjvJQN/FK13ITsFNln7oksLs2VxwloLzdDODmDRlP8fTtetuJDBdGN2Z8+
         CXgjP7UARDBVnBEcsXut3Ghhco5bQkMNyDPSVpGDJwFt1wbqZvlDPL7BjrhUzbFL4eFd
         q0DfaFL9w7IrL2S3KV706XOrc14/JRVnFnWwLJASIB2N/45Hg+6uGrLFT+bOD23lzA2e
         vqj+7PcGJ5yougE3T2dyVzS55k3mXqW6rCHfWzUN8+iJmNR/vNC31CGSDvf4cWeoHcaR
         jEYk4BXCs/EVAc6x2Po5iKbucwjZJ7dIsmuVcPopQpr0T2xJ2LZmS/KULXLBWSkn7ogp
         igsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FRol2Ixdapg4j6Uubg8h/Lz+s9FI9j4eiU5OeuRx7x0=;
        b=YzrZlycOM7fxIJvh30MsJIu+7tXNq4xj3fbnSfD49/1gEnRTWOn3xTselKAkigfO+u
         EvLFMKURWYTApxUUkjV8arcmrG6IzlRTb0LUGUmQlBUwQ0wzlU05xJF04m/qRa2awQsC
         YNmoFT1zJHp6p8249TDs9pOoS+OqepkcjVokBp1yG2ImIv2TUrK+yLko0E8os3dRfuFk
         pr+JJK9VhJA6fJNCUyIUoGgxVbLbTaiTigrIx3KMATGpJkEv/ktDit0sSjJcuqPDC04/
         fuksohxlgq7HQBmfWa7AliWBx8+nZrmWyYh+3lrOziNOFa0Uxg0xy8LaMLwd3s7xbusG
         6Esg==
X-Gm-Message-State: AOAM532/jEVOCXBnwL+ZOSBcO0EYtVJ+ViIBPnh6hvDBP+4A5sNvix84
        8h+eCr58tDmolI9jVhQZWMHZOakRf0w+Oq4+P/s=
X-Google-Smtp-Source: ABdhPJw/8+UIm4hFbM+iPSMSY1l5WCy3bScYyt9/mmw1xH4rZvSRp4COfQKVYT2qMXltFgOWDhdYu06slG9UMKl+wXs=
X-Received: by 2002:a05:6638:338e:b0:328:807a:e187 with SMTP id
 h14-20020a056638338e00b00328807ae187mr4322086jav.93.1650342817565; Mon, 18
 Apr 2022 21:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220418042222.2464199-1-pulehui@huawei.com>
In-Reply-To: <20220418042222.2464199-1-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Apr 2022 21:33:26 -0700
Message-ID: <CAEf4BzbavSC=JN=sowFY3t4yOUfe8QtVXhdG+y7a-T1YtfRqXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Support riscv USDT argument parsing logic
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
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

On Sun, Apr 17, 2022 at 8:53 PM Pu Lehui <pulehui@huawei.com> wrote:
>
> Add riscv-specific USDT argument specification parsing logic.
> riscv USDT argument format is shown below:
> - Memory dereference case:
>   "size@off(reg)", e.g. "-8@-88(s0)"
> - Constant value case:
>   "size@val", e.g. "4@5"
> - Register read case:
>   "size@reg", e.g. "-8@a1"
>
> s8 will be marked as poison while it's a reg of riscv, we need
> to alias it in advance.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---

Can you please mention briefly the testing you performed as I'm not
able to test this locally.

>  tools/lib/bpf/usdt.c | 107 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
>
> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
> index 934c25301ac1..b8af409cc763 100644
> --- a/tools/lib/bpf/usdt.c
> +++ b/tools/lib/bpf/usdt.c
> @@ -10,6 +10,11 @@
>  #include <linux/ptrace.h>
>  #include <linux/kernel.h>
>
> +/* s8 will be marked as poison while it's a reg of riscv */
> +#if defined(__riscv)
> +#define rv_s8 s8
> +#endif
> +
>  #include "bpf.h"
>  #include "libbpf.h"
>  #include "libbpf_common.h"
> @@ -1400,6 +1405,108 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>         return len;
>  }
>
> +#elif defined(__riscv)
> +
> +static int calc_pt_regs_off(const char *reg_name)
> +{
> +       static struct {
> +               const char *name;
> +               size_t pt_regs_off;
> +       } reg_map[] = {
> +               { "ra", offsetof(struct user_regs_struct, ra) },
> +               { "sp", offsetof(struct user_regs_struct, sp) },
> +               { "gp", offsetof(struct user_regs_struct, gp) },
> +               { "tp", offsetof(struct user_regs_struct, tp) },
> +               { "t0", offsetof(struct user_regs_struct, t0) },
> +               { "t1", offsetof(struct user_regs_struct, t1) },
> +               { "t2", offsetof(struct user_regs_struct, t2) },
> +               { "s0", offsetof(struct user_regs_struct, s0) },
> +               { "s1", offsetof(struct user_regs_struct, s1) },
> +               { "a0", offsetof(struct user_regs_struct, a0) },
> +               { "a1", offsetof(struct user_regs_struct, a1) },
> +               { "a2", offsetof(struct user_regs_struct, a2) },
> +               { "a3", offsetof(struct user_regs_struct, a3) },
> +               { "a4", offsetof(struct user_regs_struct, a4) },
> +               { "a5", offsetof(struct user_regs_struct, a5) },
> +               { "a6", offsetof(struct user_regs_struct, a6) },
> +               { "a7", offsetof(struct user_regs_struct, a7) },
> +               { "s2", offsetof(struct user_regs_struct, s2) },
> +               { "s3", offsetof(struct user_regs_struct, s3) },
> +               { "s4", offsetof(struct user_regs_struct, s4) },
> +               { "s5", offsetof(struct user_regs_struct, s5) },
> +               { "s6", offsetof(struct user_regs_struct, s6) },
> +               { "s7", offsetof(struct user_regs_struct, s7) },
> +               { "s8", offsetof(struct user_regs_struct, rv_s8) },
> +               { "s9", offsetof(struct user_regs_struct, s9) },
> +               { "s10", offsetof(struct user_regs_struct, s10) },
> +               { "s11", offsetof(struct user_regs_struct, s11) },
> +               { "t3", offsetof(struct user_regs_struct, t3) },
> +               { "t4", offsetof(struct user_regs_struct, t4) },
> +               { "t5", offsetof(struct user_regs_struct, t5) },
> +               { "t6", offsetof(struct user_regs_struct, t6) },

would it make sense to order registers a bit more "logically"? Like
s0-s11, t0-t6, etc. Right now it looks very random and it's hard to
see if all the registers from some range of registers are defined.

> +       };
> +       int i;
> +

[...]
