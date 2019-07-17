Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968296C0BD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 20:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfGQSAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 14:00:54 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36277 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGQSAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 14:00:54 -0400
Received: by mail-ed1-f68.google.com with SMTP id k21so26917074edq.3;
        Wed, 17 Jul 2019 11:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ReobxpRe9VHY5L4f9NfVB9nnhocooTXTZggbbgtncpk=;
        b=sCsw9rgoxXDjz8DWzf5bwYpuAbi9hKeUQVkL5tpmf+dZRHcMcwCIbpM7Sgie2KSw5j
         P3YmRR07+qX3vJwFr+k7+mxtDb8hClJujv33tiw356LSMHnwfpDZnPltA6E+nbc9drzU
         vouWMeSCZLkNI09FOzmTpMzEKjo0zNjr4U+WRHOtylzct8Lg4dVcu7F3Kslwly20r+pe
         3q9Y0ucP5oyAL4uRN+gnHoXLsIJw2PBqxqzl6Y+crVu7RvlFZkfOVSGVv0ex5BrDyImq
         SaKi4twbCgd9uG7Ny7C8MB0RWeWwMyGD1s1w0oKjaR7CoYWH0S/JZxG+ZBy/IL1/utEL
         PeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ReobxpRe9VHY5L4f9NfVB9nnhocooTXTZggbbgtncpk=;
        b=pWiHApENEsPqF6gFv5kbGcgDKknaCZaDhuSAIAxFT1KSJedFTtuoLc7/vAQqfn42bx
         nDDoHDtw0gNnLnp/xF+4QixUPLOa1SvROfG3N/IH3G2D+pyoYVPcR/IyCgOZ8NXYARZL
         bmoXwwZwRovZcXaAjdFNBrYHuVSAKw1K6tDEMjCDi6QNYA9J6pvkEFOicJxEIq054Lhk
         Lhq+QAnv3TLflIhresIvkRP6Z8n6+eDPaQsqzRryR9LDnFEYphWbaIbw8+g/3ycyyziP
         LJTMgWpGhFE10ZQlx16XHl0BR0RPRgLjcEs4z+QLzip9UT8LmAkuLoLe1nRWFggfLEQR
         hDiQ==
X-Gm-Message-State: APjAAAWNqve0D5mgSFojsgP25SlVrJooZp5Ctqm+u8P7JVbpq/cAq2H7
        bZdvPHbaq5otgKKRrXDI0loITfpGEg1RO8PbqLI=
X-Google-Smtp-Source: APXvYqw24Shn0R6x6Jv7sP2yGyNPtf/SuxFRy/tzw84yRT+HcPnZIkqYvwpFFEaHlUWBRIzHiKt/RxZvT6CqbFzW8tA=
X-Received: by 2002:a17:906:4e8f:: with SMTP id v15mr31770171eju.47.1563386452403;
 Wed, 17 Jul 2019 11:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190717141200.46604-1-yuehaibing@huawei.com>
In-Reply-To: <20190717141200.46604-1-yuehaibing@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 17 Jul 2019 21:00:41 +0300
Message-ID: <CA+h21hq3cgg7k0=3U=dgXUCkPo+F_U9TJ=1FdkbBNcg3j_Gv=Q@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: Add missing spin_unlock
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jul 2019 at 17:12, YueHaibing <yuehaibing@huawei.com> wrote:
>
> It should call spin_unlock() before return NULL.
> Detected by Coccinelle.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: f3097be21bf1 net: ("dsa: sja1105: Add a state machine for RX timestamping")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Hi Yue,

Thanks for the patch. Wei Yongjun submitted an identical one a few
hours before yours: https://patchwork.ozlabs.org/patch/1133135/
Let's go with that version this time.

>  net/dsa/tag_sja1105.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
> index 1d96c9d..26363d7 100644
> --- a/net/dsa/tag_sja1105.c
> +++ b/net/dsa/tag_sja1105.c
> @@ -216,6 +216,7 @@ static struct sk_buff
>                 if (!skb) {
>                         dev_err_ratelimited(dp->ds->dev,
>                                             "Failed to copy stampable skb\n");
> +                       spin_unlock(&sp->data->meta_lock);
>                         return NULL;
>                 }
>                 sja1105_transfer_meta(skb, meta);
> --
> 2.7.4
>
>

Regards,
-Vladimir
