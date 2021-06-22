Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB55F3B0EE0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFVUfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:35:36 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:47049 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhFVUff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:35:35 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mqrs9-1lRSM03R1V-00mrbw; Tue, 22 Jun 2021 22:33:17 +0200
Received: by mail-wr1-f46.google.com with SMTP id m18so133528wrv.2;
        Tue, 22 Jun 2021 13:33:17 -0700 (PDT)
X-Gm-Message-State: AOAM532uPd44LJIKfFzGpLjTCnJEot8IKsQp2+R0J2No2wyfqRGCzWh4
        V6IJVaLdllkpXYPF17LjcmRSVTNkD+/VNP36FqQ=
X-Google-Smtp-Source: ABdhPJxIxO/xXDmBL9CuTqUfJPeIqUNEO8k6TjCUhFN3xY3HAWWytEGfglJh+8bqyJP/NPuAFwnum684HVLDv6sIonM=
X-Received: by 2002:a5d:5905:: with SMTP id v5mr7302490wrd.361.1624393997509;
 Tue, 22 Jun 2021 13:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
In-Reply-To: <20210622202345.795578-1-jernej.skrabec@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 22 Jun 2021 22:30:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1mvRTTFHtxqREmcbgJS+e94BHajCtAU_fzBhNNKjJBcg@mail.gmail.com>
Message-ID: <CAK8P3a1mvRTTFHtxqREmcbgJS+e94BHajCtAU_fzBhNNKjJBcg@mail.gmail.com>
Subject: Re: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
To:     Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     pizza@shaftnet.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UDwhB0AIeFYw8fWlG1HJDe/qGwXmYMz69G8vpsnra2CQVSh8lgt
 pbGHN8cMNCDDd8FKbV87kDqsN3VuEryRhvAAXrV2vSRBetLS//TQOipgc3YbZwzZOEIKSPW
 +9hJMSmXD1ehSw5HB2+0QQA92U8q0cDGjPrABSxJ4MeqT3Nxb0iGy87eADLY3+9IWOXHsaS
 XIfzjmWcJYg6w0r08gEKA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mXPUlyWGewU=:qsP5JBu1opz816nEqKxwqX
 LgV2UsCLyCttOFmeWt98zf7GQmQUZLw/Nk91XuZkOiEWEu38PZWJ9mY4syOhYqR8egyoW15bC
 HtCt3cyRYhwUKDRFY73ADtY+Rb/A2Ysg0ymgQ4yhE2h/UeKrm84UzGUo9Q7N7DHwJVonxg+20
 YgSWhXW5mXA+B0nN5B72KoQxXUFLhbPbUkEcyToPsrd66Zh4AeN0BOoLaPjhC5Aap8Jo6S51C
 QOwKmGMgQ0MLbtrTaS7uGqFMXL8GkrC+wPFyxr+bmcI7Hsg0yUj1JNgysO2r/G5XL5J732SGU
 nRoP8H+20ZwwwRtwtpR+CRivE7Ew77kkdbzMURH11Ocxfz0ker+WATZkcCU8njFBRoX9FedYe
 bqf78CbgJhz2063dPV2aajScT6RGNgQM8Aw/C+N9y8qA5wdukMOEHpxBxXoA+5a0QEMSWW9Ru
 XtKC0eEqCZtpbyItnxwhLwNPk4QxTX8gZxjCh8TkoGjt2YCStniJxbIbaTLzDvzAdKupVYb21
 1Ev1kTozJcz4ZgRYstm9xY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 10:24 PM Jernej Skrabec
<jernej.skrabec@gmail.com> wrote:
>
> It turns out that if CONFIG_VMAP_STACK is enabled and src or dst is
> memory allocated on stack, SDIO operations fail due to invalid memory
> address conversion:

Thank you for sending this!

It's worth pointing out that even without CONFIG_VMAP_STACK, using
dma_map_sg() on a stack variable is broken, though it will appear to
work most of the time but rarely cause a stack data corruption when
the cache management goes wrong.

This clearly needs to be fixed somewhere, if not with your patch, then
a similar one.

> diff --git a/drivers/net/wireless/st/cw1200/hwio.c b/drivers/net/wireless/st/cw1200/hwio.c
> index 3ba462de8e91..5521cb7f2233 100644
> --- a/drivers/net/wireless/st/cw1200/hwio.c
> +++ b/drivers/net/wireless/st/cw1200/hwio.c
> @@ -66,33 +66,65 @@ static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
>  static inline int __cw1200_reg_read_32(struct cw1200_common *priv,
>                                         u16 addr, u32 *val)
>  {
> -       __le32 tmp;
> -       int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
> -       *val = le32_to_cpu(tmp);
> +       __le32 *tmp;
> +       int i;
> +
> +       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +       if (!tmp)
> +               return -ENOMEM;
> +
> +       i = __cw1200_reg_read(priv, addr, tmp, sizeof(*tmp), 0);
> +       *val = le32_to_cpu(*tmp);
> +       kfree(tmp);
>         return i;
>  }

There is a possible problem here when the function gets called from
atomic context, so it might need to use GFP_ATOMIC instead of
GFP_KERNEL. If it's never called from atomic context, then this patch
looks correct to me.

The alternative would be to add a bounce buffer check based on
is_vmalloc_or_module_addr() in sdio_io_rw_ext_helper(), which would
add a small bit of complexity there but solve the problem for
all drivers at once. In this case, it would probably have to use
GFP_ATOMIC regardless of whether __cw1200_reg_read_32()
is allowed to sleep, since other callers might not.

      Arnd
