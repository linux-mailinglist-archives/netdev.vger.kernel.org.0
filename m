Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE23D2CE8
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 21:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhGVTCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 15:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGVTCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 15:02:00 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BDBC061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 12:42:35 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o8so6473475ilf.4
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 12:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ojab.ru; s=ojab;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEuCuHt84F523pMpVlgmLvJ4UIBF4EoLTs4dbDpATW8=;
        b=mKU59JZsPpk4Uwrh9veqroWHFfmAS+JdwuvxLQdk+8vF9zAFjuiNoiHEI24a2DukKo
         5MhOTtxunUNS4hbaqrDkjLwYr76tA5g73A4+lczu0NSSiOmMb+UKUc6r6h99MW6A5+b9
         Q7bvYpxu1Mon2J4EnpLpVzxK+RGPMCxddZpU/EWqjSdsZnK8PKC4m/3T/xuu5KrT1ASi
         wyy/tEO03vbX5aFkjMVtqkhVlsb6N31yshFICDUkrcKUmWz8qhBs0tytE1iqSKSKgECD
         tpPtwFrUdXvO7VCKWdKQKxmu2xurNAK46JCBbIFn7O5l/cT9FyPL2gorlJMGX2WfLV2Q
         qnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bEuCuHt84F523pMpVlgmLvJ4UIBF4EoLTs4dbDpATW8=;
        b=haG2eE1JRYGVYIVDGTQTmbXq/aeMQ5h67XW94aF66B/9DJgS+vNM9cLwwConvwRKHP
         wSU11SIJtMjVQuylDZoYjM9VIMCKPn8FVLP3qVGRye9Ad0GHwog47quiCtAu7dnLfnVf
         rGVfteO2AYgYL3MmwrAxJAjPXvhw6yh2ZUS702rsVYvudY+3quB9ibDUv6yHZYMFz4Nq
         LYjAd15hucFveNiDi+yxliTvweR0ip4LNKpv3CvL4bZKab6/KuSrimCgerFFVtSNXM8z
         jJUfOskrwIRqKJ7+pN/2ho2LKFNQZCyY94ne4Xb+Pv8a3P9dn4JmC0Ob91ozXCz5SJ+q
         gmxg==
X-Gm-Message-State: AOAM531/0gI/6Y52cuWYfj0sHewspRw4i6dMjNsdtwtweZICjz1VSgMl
        9AO5FA9po34qlpmnMXqvR1DT1q3B2Gcd9YARN0xE1A==
X-Google-Smtp-Source: ABdhPJyMABrkiHTJMS9LZm/CFEJBy6P8UgBeaGafeRs22DUJ5aaCx9PBDCrxo0HZCPVZx1y0wGfrIk1R5ZHDwpeYc/o=
X-Received: by 2002:a05:6e02:1d0f:: with SMTP id i15mr893058ila.199.1626982954711;
 Thu, 22 Jul 2021 12:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210722193459.7474-1-ojab@ojab.ru>
In-Reply-To: <20210722193459.7474-1-ojab@ojab.ru>
From:   "ojab //" <ojab@ojab.ru>
Date:   Thu, 22 Jul 2021 22:42:23 +0300
Message-ID: <CAKzrAgRvOLX6rcKKz=8ghD+QLyMu-1KEPm5HkkLEAzuE1MQpDA@mail.gmail.com>
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, axel.rasmussen1@gmail.com
Cc:     ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See also: https://lists.infradead.org/pipermail/ath10k/2021-May/012626.html

On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
>
> After reboot with kernel & firmware updates I found `failed to copy
> target iram contents:` in dmesg and missing wlan interfaces for both
> of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
> it, so while I have no idea what's actually happening, I don't see why
> we should fail in this case, looks like some optional firmware ability
> that could be skipped.
>
> Also with additional logging there is
> ```
> [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
> [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
> [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
> [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram contents: -12
> ```
> so exact branch could be seen.
>
> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> ---
>  Of course I forgot to sing off, since I don't use it by default because I
>  hate my real name and kernel requires it
>
>  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 2f9be182fbfb..d9fd5294e142 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
>         u32 len, remaining_len;
>
>         hw_mem = ath10k_coredump_get_mem_layout(ar);
> -       if (!hw_mem)
> +       if (!hw_mem) {
> +               ath10k_warn(ar, "No hardware memory");
>                 return -ENOMEM;
> +       }
>
>         for (i = 0; i < hw_mem->region_table.size; i++) {
>                 tmp = &hw_mem->region_table.regions[i];
> @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
>                 }
>         }
>
> -       if (!mem_region)
> +       if (!mem_region) {
> +               ath10k_warn(ar, "No memory region");
>                 return -ENOMEM;
> +       }
>
>         for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
>                 if (ar->wmi.mem_chunks[i].req_id ==
> @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>                 if (status) {
>                         ath10k_warn(ar, "failed to copy target iram contents: %d",
>                                     status);
> -                       goto err_hif_stop;
>                 }
>         }
>
> --
> 2.32.0
