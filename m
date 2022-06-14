Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B75854B810
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350986AbiFNRu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350483AbiFNRuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:50:55 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D503B55E;
        Tue, 14 Jun 2022 10:50:54 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id r12so9686927vsg.8;
        Tue, 14 Jun 2022 10:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y7lWlC0ID6xcYIKCksaK2Q6U4VJ116tOdaANaaZcHwU=;
        b=pOjMdzI/JF0vEBkUzR6KhTpZx5s6v5P4F67yaNDe4QPTSP1717tVEC2JvCxksyFIk0
         egCsCID/4hPrNntwYL8Is+XuagbsEEYfJRxrbdHIyg9B4/gba3mprI//UDspafagYbbX
         lu1/hDyxP6rahxQQqvHM5yidQf7HWyFfC16Wh3MSxEjd/Pd0nm4uzZPLTx10L7QIjC3I
         0GwqBs3fjPLGgfOoT5l79FEgJuoDGUARR9KPFzobRQaeGGDiUlR74ZEY0CWQBLEuDxMR
         37k8XTJYReH618+W3RuncRf+hXWsWje0X2Ys1UR8KDe/EFEXpiGVR3T+Dc1METl1ic5N
         3A+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y7lWlC0ID6xcYIKCksaK2Q6U4VJ116tOdaANaaZcHwU=;
        b=cQBNBdSrq5WoVN0fL0fsRHVbrutFZ9YmcnWkENQy8GA8tf5v17rNnt2qSmrhYjvzct
         B7xwt53mEoOpUCYo1XyOowH4dwVO5AcwQHjZ5mIViXyJODej05ohARf+sTBpf6Y/RMA9
         1D6Lm1Vvz5E0URy9hU1LN1i5VIIfZ0ar01pGByxDRekuKKLA4dWl+ZuMivebI3COl+X8
         Kg80Wls3fAU3iS2uC4ZNW8BFTwK4ntnzDASapT4TApt1oZos6PG3BQVLDBUhZKqG95PA
         NRWZA9P6tXlNWJ+Jo+UxXUd+SqJUcdkrCiqIPYE/0F7dcPEnIiG3qR+xX5UQSbTFgFEZ
         Pazw==
X-Gm-Message-State: AJIora+/Ta2a0MguaV+u3O21lo2rjwEksTO9a4u4xSKepZ786lm42Ahh
        lWeStPrrUSgy47Ou9rmYo3RGM4ZK9mS2CkC4ruE=
X-Google-Smtp-Source: AGRyM1tE8iGrta1sVvxhDPQh8BCuTc253XBQH2pgFXHYPLVPTv3GqCMLRqQNJsX26NjGlp2URASn1JPtDTSQqqI8xCI=
X-Received: by 2002:a67:d70e:0:b0:34b:8e32:404b with SMTP id
 p14-20020a67d70e000000b0034b8e32404bmr3097325vsj.31.1655229053277; Tue, 14
 Jun 2022 10:50:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220614115420.1964686-1-roberto.sassu@huawei.com> <20220614115420.1964686-2-roberto.sassu@huawei.com>
In-Reply-To: <20220614115420.1964686-2-roberto.sassu@huawei.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 14 Jun 2022 10:50:42 -0700
Message-ID: <CAJnrk1bz33yeRRXP46tU1iKOHKxowj5-BaThT24kEnfUP9aAeQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] bpf: Export bpf_dynptr_get_size()
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Jun 14, 2022 at 4:54 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> Export bpf_dynptr_get_size(), so that kernel code dealing with eBPF dynamic
> pointers can obtain the real size of data carried by this data structure.
>
> Cc: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

LGTM

Acked-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  include/linux/bpf.h  | 1 +
>  kernel/bpf/helpers.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8e6092d0ea95..6eb03a0c9687 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2420,5 +2420,6 @@ void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
>                      enum bpf_dynptr_type type, u32 offset, u32 size);
>  void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
>  int bpf_dynptr_check_size(u32 size);
> +u32 bpf_dynptr_get_size(struct bpf_dynptr_kern *ptr);
>
>  #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 225806a02efb..29e1810afaf6 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1430,7 +1430,7 @@ static void bpf_dynptr_set_type(struct bpf_dynptr_kern *ptr, enum bpf_dynptr_typ
>         ptr->size |= type << DYNPTR_TYPE_SHIFT;
>  }
>
> -static u32 bpf_dynptr_get_size(struct bpf_dynptr_kern *ptr)
> +u32 bpf_dynptr_get_size(struct bpf_dynptr_kern *ptr)
>  {
>         return ptr->size & DYNPTR_SIZE_MASK;
>  }
> --
> 2.25.1
>
