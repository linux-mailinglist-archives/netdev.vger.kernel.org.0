Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB882B0415
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgKLLlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728178AbgKLLku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:40:50 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A89CC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:40:44 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so5776527edt.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IIySD8jHl2ntyqnjJAOFKaUih7w1tKAQSN79AIHZfZo=;
        b=dqbKVY5k33G1WoYnR62WXmoVtTMoFzHvqgC1qm9WJiYf+SRL//ogYuYTKCSHCfwD8v
         a7l+KLPdbh7jqpOLH57Ay87ksd3xUMo5DFIYS9VyC9/zJyn0PubVWxXCzfjBibTZbaFE
         hUVfIYxPPdBT6KLHD6EyFFUnoeUGMUFkdKeoFwoCLQsoiDFZf7MZTRMrNjsqU7INwS1l
         IQ52TQxxBK/9l1hYB+e3ZvRNzJLYFz91+84FGYeT99Dh6mrwKXMQriLBFJdSjQEhTIy7
         VTFAJiGwiW5KBQ2Fpro3akfU4dVOzIir9L7Q6Zsdz0rCsFH/zjQudmBBBeABReILJLA3
         5jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IIySD8jHl2ntyqnjJAOFKaUih7w1tKAQSN79AIHZfZo=;
        b=q16D2jSD5+8aVoaoN3bLPv585ZZ363vPzT8H4N0PBMkBDs/7+4hkv4AhjgIPaeKGWp
         BtpL65f/Y2ZvPJGSA7+5ldG2t4dayNv3B2yBBbMpclEuiQ6yJBuTXcicqWEkUe/GZ1au
         nOAGEISFtwVIRH3dF2C4pban385Pi6gRmlZsaoSN6VNJoVN1Ggo3SHwjWDa0dGnfLKLW
         TmchqF+hxdsPXMYrLdK0sEZloq07dXbKCSMTqhlHdXt/+y1KZQ1jb4QXmf2DYwzm88zg
         Y3f1JQQlVipGGyZqJaycpE8lKgs/ZTkt32i3xhPSP+9H4G14IRjZsvI8HGZ4NeKEl3xq
         8ecQ==
X-Gm-Message-State: AOAM532z2neJhG86HDz9W9kjcAONkgpg1NpfrNl0aSjGL1hNeOg8c1FT
        1ruORFOq/zXsDd0v2gLNCWTQBdNN6RpSzcSPp1rSIg==
X-Google-Smtp-Source: ABdhPJxtq2C8/Sp32xjRsm7unrZdZ2HhAmdm7V9p1LI14Tk4zl6dE5puqEGBsiXHGyN6RLJc7tHoMPBJfCsWylIeQhg=
X-Received: by 2002:a50:ab15:: with SMTP id s21mr4635654edc.88.1605181243548;
 Thu, 12 Nov 2020 03:40:43 -0800 (PST)
MIME-Version: 1.0
References: <20201112084833.21842-1-vincent.stehle@laposte.net>
In-Reply-To: <20201112084833.21842-1-vincent.stehle@laposte.net>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 12 Nov 2020 12:40:32 +0100
Message-ID: <CAMpxmJWVSfZwukjWGMwBvPxcrWUeeMyyh+SpLAg6bNJdEiga7g@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: return ok when xmit drops
To:     =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>
Cc:     netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:35 PM Vincent Stehl=C3=A9
<vincent.stehle@laposte.net> wrote:
>
> The ndo_start_xmit() method must return NETDEV_TX_OK if the DMA mapping
> fails, after freeing the socket buffer.
> Fix the mtk_star_netdev_start_xmit() function accordingly.
>
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/=
ethernet/mediatek/mtk_star_emac.c
> index 13250553263b5..e56a26f797f28 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -1053,7 +1053,7 @@ static int mtk_star_netdev_start_xmit(struct sk_buf=
f *skb,
>  err_drop_packet:
>         dev_kfree_skb(skb);
>         ndev->stats.tx_dropped++;
> -       return NETDEV_TX_BUSY;
> +       return NETDEV_TX_OK;
>  }
>
>  /* Returns the number of bytes sent or a negative number on the first
> --
> 2.28.0
>

Good catch, thanks!

Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
