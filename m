Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471F2443CF4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 07:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhKCGMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 02:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCGMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 02:12:50 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707CEC061714;
        Tue,  2 Nov 2021 23:10:14 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d5so1878844wrc.1;
        Tue, 02 Nov 2021 23:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mhFGKftRIjcJcC/nt39v6NG9deVMAPc9B2rHmoF3Wyg=;
        b=P47Fhjn5Z/MgIz6wosHw4ahOVYLyMYVRJiQOiVhZSePI2QLXypxPJt0siDj7VOxpSE
         tt6VHRnzSlvLk3yXb8lE35UPJUSQCjpH9J1ImuUA+3ZSV1c8CtsfYTQ5j1NN319vdpgO
         6NW2jbS6Kjpz4BNziepjn3GIO4IJbI+dcVJCpGwpVxAa7kHzLumr/xq2VPiwp9ncCmxY
         paqIHZE2qpapLBJUxVuVcs3Qmdd2jkciMeJQ6YGR7AhH3E+cYxVMpN/CAd4THIlBjXS2
         +8Ucb9AHLyJm5Hy3iDhsWFVJSSKXKKH4xy9Z2chTnNSw2G6UbBq7pRn71J86i8QVzsyu
         WEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mhFGKftRIjcJcC/nt39v6NG9deVMAPc9B2rHmoF3Wyg=;
        b=WpWaztctl3C7ARmzi1wkmqmV57jLOQKZ5CmA+fi1bTctTqVOOEDEPmNK6vQ9zmgpVd
         mxMX9WAEISdIu3DAc/CA+zPWEtc8jqdpL7qyZ6rrh5mKLFEI4eVKhaySDh4Ey83yC5A1
         45lCY1oNWZmgWwmpThoF1qwyBjVX7zssbrhXD67E98Slo7kCyi4PzJDt3eYlkY0TEQhB
         Azk/6J1eeLoMD8AzolH/RWVX5pmzzc+DKywTJ+alTl67vph0sDrkmbqjcjSVpIpPEEqi
         kpZFlyc9X8UJfVMpapZBhyiqjyOimlr+N/fqrf+nl5rI4G2aU1wEdejNv04zr3bS7uA5
         0MLQ==
X-Gm-Message-State: AOAM530KXWUm8P57OcqLgg8fg5QYa9+AnSaagrkmE+nfYdB5B1IQzwRk
        sBG9jHOgzPwCiG7E7PFk4jJem2aaQ2b/RilQ/jI=
X-Google-Smtp-Source: ABdhPJyvNO5HtlrsmV3IHN1qX/3wt/nczXG/NErLEVaI5hbaOC/iHnZejymyGFs1wqQNKIcUpZDEgH/B5rtDWmAQJVE=
X-Received: by 2002:a5d:648e:: with SMTP id o14mr3245168wri.141.1635919813053;
 Tue, 02 Nov 2021 23:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20211102145642.724820-1-tongtiangen@huawei.com>
 <CAJ+HfNg1Ki=1Zc+ThW-ynvtDo5=fNAUK-XV08-icz-nY9CNoUQ@mail.gmail.com> <448599f5-e773-6ab5-bdaf-289f583edf01@huawei.com>
In-Reply-To: <448599f5-e773-6ab5-bdaf-289f583edf01@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 3 Nov 2021 07:10:00 +0100
Message-ID: <CAJ+HfNj_p36trWFzdyxVVgykrPVq=OvKcYq61w2QyKsHwa0gDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] riscv, bpf: fix some compiler error
To:     tongtiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 at 04:06, tongtiangen <tongtiangen@huawei.com> wrote:
>
[...]
> >
> Hi Bj=C3=B6rn:
>  From the perspective of development, introduce asm/extable.h is also pre=
pare for the
> subsequent modification of exception_table_entry, such as:
>    1. https://lkml.org/lkml/2021/10/20/591
>    2. https://lore.kernel.org/linux-arm-kernel/20211019160219.5202-11-mar=
k.rutland@arm.com/
>
> Therefore, the prototype declarations and definitions related to kernel c=
onfig are placed in head file,
> which can avoid compiler error and simplify the rendering of functions.
>

Sure, but *this* patch is about getting the broken RV32 build to work,
aimed for the bpf tree. Moving the extable.h is unrelated, and should
not be done here. IMO it would be better to have this patch small/easy
to read. I can't really see how this patch helps, when merging with
Jisheng's work.

...and I still think that:
--8<--
diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
index 18bf338303b6..ddb7d3b99e89 100644
--- a/arch/riscv/mm/extable.c
+++ b/arch/riscv/mm/extable.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>

-#ifdef CONFIG_BPF_JIT
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
 int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
struct pt_regs *regs);
 #endif

@@ -23,7 +23,7 @@ int fixup_exception(struct pt_regs *regs)
        if (!fixup)
                return 0;

-#ifdef CONFIG_BPF_JIT
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
        if (regs->epc >=3D BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGI=
ON_END)
                return rv_bpf_fixup_exception(fixup, regs);
 #endif
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp6=
4.c
index 2ca345c7b0bf..6372a235522d 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -459,6 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct
rv_jit_context *ctx)
 #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
 #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)

+int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
+                          struct pt_regs *regs);
 int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
                                struct pt_regs *regs)
 {
-->8--

is much simpler.



Thoughts?
Bj=C3=B6rn




> Thanks.
> Tong.
>
> >
> > Bj=C3=B6rn
> > .
> >
