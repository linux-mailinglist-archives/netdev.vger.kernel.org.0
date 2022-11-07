Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0142C61F41E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiKGNSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 08:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiKGNSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 08:18:36 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8C51AF1A
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 05:18:33 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 131so9150103ybl.3
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 05:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5SoqAUcnwiRm88ADd2ljnWMq6OYtUHzfrs6KNHdyEzE=;
        b=UGhWJk4HpX9TKsQWQGTHKMh66inqZKg22bG/7kNXFFQ3kZkidg97XqTIHwxg7WPOXu
         0v2Y5ywyxTm8lK4tBBVrN7AiivG6csBLgRaKdyQnRao7nV8N5aOvbgLHoSMCgmQFQyDc
         P87IdNxHWNAAYgvfcEc11SC556SRE2deFJ7I51lI/P+WQ0tCIlZuVbZPBUAraptpo1iV
         HPagSQ3kgZQp0lwo+iU90EWh3daa+XDUDbFYJP15USWHYAYV+3YZqa69ti4roaHutWsS
         tlruEWldOByyLJJXOYjkavzkTQ0kST9VtsXYHB6M93pJmTmgUHEwb1+kVsYuJB9mdnqY
         4lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5SoqAUcnwiRm88ADd2ljnWMq6OYtUHzfrs6KNHdyEzE=;
        b=7E0zxzGzidOL1KXLDlEZY1NvNqD8+8ApF0so6d5j5OUx+yiT6p1mvo9FZ/UEShvfy3
         EiM4ym3Jz63eU57S4KNilBavZycJ112fKcqdE6EmhDtXwLWN/hOT4b8oyzGCdMptNLEr
         FR9pBNTOkeg1C/kJxkH/KYN/l9iZ8Cmo1GAKO/1jEGFAPO0ryJS6dSair30ACqNKLWxH
         6bCqXiS6z74gHLYVJHe6ZFKyTYJvbCqwH3xj0g9kRUcV/k7It16MiSoyrfCy+/6Zx88f
         VzWRz21c14wts/1IzJXfkZOoOoLvDfmsKo2613aSEn99/Fn0WqqMu8UrcmIzOIjbYoHm
         EeTg==
X-Gm-Message-State: ANoB5pnFBUL5eAjIFvspbd1TykZEZDCv5rX1SMy1F+KIi7MqgH9ffRo9
        3VsgdF4c1mu8OxURRr0Oz84trEqBb8bKDV1jgb8k1Q==
X-Google-Smtp-Source: AA0mqf5/eEsy8pyLnv/X6ea7Qff2XeVAQvDcA+/uWKpr7VBmhDic4hY9dpkmZ5Hj8IbqB8MTAJmRX3TqClSEXMTqEFY=
X-Received: by 2002:a25:4090:0:b0:6d3:7bde:23fe with SMTP id
 n138-20020a254090000000b006d37bde23femr15834157yba.388.1667827112974; Mon, 07
 Nov 2022 05:18:32 -0800 (PST)
MIME-Version: 1.0
References: <20221102081620.1465154-1-zhongbaisong@huawei.com>
 <CAG_fn=UDAjNd2xFrRxSVyLTZOAGapjSq2Zu5Xht12JNq-A7S=A@mail.gmail.com> <Y2je9dJxUjEchB9k@FVFF77S0Q05N>
In-Reply-To: <Y2je9dJxUjEchB9k@FVFF77S0Q05N>
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 7 Nov 2022 14:17:56 +0100
Message-ID: <CAG_fn=UdPzBp9uSayPWvtRgjSKoLyfiYacofTS-bbbTauc2F-w@mail.gmail.com>
Subject: Re: [PATCH -next,v2] bpf, test_run: fix alignment problem in bpf_prog_test_run_skb()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Baisong Zhong <zhongbaisong@huawei.com>, elver@google.com,
        Catalin Marinas <catalin.marinas@arm.com>, edumazet@google.com,
        keescook@chromium.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 7, 2022 at 11:33 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Fri, Nov 04, 2022 at 06:06:05PM +0100, Alexander Potapenko wrote:
> > On Wed, Nov 2, 2022 at 9:16 AM Baisong Zhong <zhongbaisong@huawei.com> =
wrote:
> > >
> > > we got a syzkaller problem because of aarch64 alignment fault
> > > if KFENCE enabled.
> > >
> > > When the size from user bpf program is an odd number, like
> > > 399, 407, etc, it will cause the struct skb_shared_info's
> > > unaligned access. As seen below:
> > >
> > > BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 net/core/=
skbuff.c:1032
> >
> > It's interesting that KFENCE is reporting a UAF without a deallocation
> > stack here.
> >
> > Looks like an unaligned access to 0xffff6254fffac077 causes the ARM
> > CPU to throw a fault handled by __do_kernel_fault()
>
> Importantly, an unaligned *atomic*, which is a bug regardless of KFENCE.
>
> > This isn't technically a page fault, but anyway the access address
> > gets passed to kfence_handle_page_fault(), which defaults to a
> > use-after-free, because the address belongs to the object page, not
> > the redzone page.
> >
> > Catalin, Mark, what is the right way to only handle traps caused by
> > reading/writing to a page for which `set_memory_valid(addr, 1, 0)` was
> > called?
>
> That should appear as a translation fault, so we could add an
> is_el1_translation_fault() helper for that. I can't immediately recall ho=
w
> misaligned atomics are presented, but I presume as something other than a
> translation fault.
>
> If the below works for you, I can go spin that as a real patch.

Thanks!
It works for me in QEMU (doesn't report UAF for an unaligned atomic
access and doesn't break the original KFENCE tests), and matches my
reading of https://developer.arm.com/documentation/ddi0595/2020-12/AArch64-=
Registers/ESR-EL1--Exception-Syndrome-Register--EL1-

Feel free to add:
  Reviewed-by: Alexander Potapenko <glider@google.com>
  Tested-by: Alexander Potapenko <glider@google.com>

> Mark.
>
> ---->8----
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 5b391490e045b..1de4b6afa8515 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -239,6 +239,11 @@ static bool is_el1_data_abort(unsigned long esr)
>         return ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_DABT_CUR;
>  }
>
> +static bool is_el1_translation_fault(unsigned long esr)
> +{
> +       return (esr & ESR_ELx_FSC_TYPE) =3D=3D ESR_ELx_FSC_FAULT;

Should we also introduce ESR_ELx_FSC(esr) for this?

> +}
> +
>  static inline bool is_el1_permission_fault(unsigned long addr, unsigned =
long esr,
>                                            struct pt_regs *regs)
>  {
> @@ -385,7 +390,8 @@ static void __do_kernel_fault(unsigned long addr, uns=
igned long esr,
>         } else if (addr < PAGE_SIZE) {
>                 msg =3D "NULL pointer dereference";
>         } else {
> -               if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, reg=
s))
> +               if (is_el1_translation_fault(esr) &&
> +                   kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, reg=
s))
>                         return;
>
>                 msg =3D "paging request";
--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
