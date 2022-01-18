Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5299E4912E4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 01:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiARAfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 19:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiARAfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 19:35:07 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9FCC061574;
        Mon, 17 Jan 2022 16:35:07 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e9-20020a05600c4e4900b0034d23cae3f0so998513wmq.2;
        Mon, 17 Jan 2022 16:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6AOppJO/V8yvDkWhxeW7C/0hwTcrFhBc3HivDlJi72o=;
        b=eLmydbmDiA1LeCymS/o8/2xfIDkygrzgqeM9AjTALGeyFKWLswKiac0OveGH1V14ta
         csYCQSMAwF/con0OPNnGdKTHwjLgt8N5wxdVXrWzgPep5EwhpjLe6mRamJb9JlQdw8qU
         zZ3hLIbPRey2JNtR9r7V8g0qWkWfvxZ9KzSS01wNafDljHUAkOJVXdPgjRLxNBgr8QOl
         p8S4wsrR/fNDMwtJFjd/2UBz+La30QX1YcJbeorrHZjR3wnTdAj+cIoFbrhg5U8dDhjH
         9SkUA+AesTx2DSq5Pf/Q/W7PRXk0SIObZJrz8nj1+zV6bjhhnzBANiG+t/8ihQk5gAMY
         mznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6AOppJO/V8yvDkWhxeW7C/0hwTcrFhBc3HivDlJi72o=;
        b=vocmHSQ5W2IOChlKUX4Tg6HKfTCuR7p0bzcN9V5qo/EzVADakw5wcKOIZLSkj8WY4c
         8+kmwyagyg9Qs2Zp19aonVNPIukiFDMOMukwlTh3X5Ky2IVbv4xi7qjwY6UjNMYVdiWJ
         2GcakixCPEFd7d2pTM4NsoosGYHOLRP15Z+f2WbuihEE9N5e/V4a0/TzdXaHHuksMmC9
         i0GQ7zsGy6AHz6yQuX3doM8g/Li2pMojgskfPy7L01URRp9xjQS5xLPkoGoeF99t5T31
         nIk/M1ZcrVeqRzArbYibZea6kE7LrY/aLgvTIqFgxL0YnODA6hMuVsGS3p3OLHznsNg/
         mVQA==
X-Gm-Message-State: AOAM531pjiFRSc4vT7K8npvWmzZ3Asb49nuH2LiUh08ukWfZVmos4w9Z
        MbXjyhSDaQE4+F5hVDEZUuRGMxv19tvrTnK4vdk=
X-Google-Smtp-Source: ABdhPJzH6UQmktnMQ1Ci1xbJlDCPtB18E4xECiN1KoOruObTyOBUjSIDstJiVb6tdUOSJKFEuo3HwYXfqBdYxud0sHo=
X-Received: by 2002:a1c:545b:: with SMTP id p27mr29765104wmi.178.1642466106080;
 Mon, 17 Jan 2022 16:35:06 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com> <20220117115440.60296-18-miquel.raynal@bootlin.com>
In-Reply-To: <20220117115440.60296-18-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 19:34:55 -0500
Message-ID: <CAB_54W76X5vhaVMUv=s3e0pbWZgHRK3W=27N9m5LgEdLgAPAcA@mail.gmail.com>
Subject: Re: [PATCH v3 17/41] net: ieee802154: at86rf230: Call the complete
 helper when a transmission is over
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> ieee802154_xmit_complete() is the right helper to call when a
> transmission is over. The fact that it completed or not is not really a
> question, but drivers must tell the core that the completion is over,
> even if it was canceled. Do not call ieee802154_wake_queue() manually,
> in order to let full control of this task to the core.
>
> By using the complete helper we also avoid leacking the skb structure.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/at86rf230.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> index 583f835c317a..1941e1f3d2ef 100644
> --- a/drivers/net/ieee802154/at86rf230.c
> +++ b/drivers/net/ieee802154/at86rf230.c
> @@ -343,7 +343,7 @@ at86rf230_async_error_recover_complete(void *context)
>         if (ctx->free)
>                 kfree(ctx);
>
> -       ieee802154_wake_queue(lp->hw);
> +       ieee802154_xmit_complete(lp->hw, lp->tx_skb, false);

also this lp->tx_skb can be a dangled pointer, after xmit_complete()
we need to set it to NULL in a xmit_error() we can check on NULL
before calling kfree_skb().

- Alex
