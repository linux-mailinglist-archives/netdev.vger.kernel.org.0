Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F36327661
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 04:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhCADRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 22:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCADRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 22:17:30 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3292AC06174A;
        Sun, 28 Feb 2021 19:16:50 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id g8so11465940otk.4;
        Sun, 28 Feb 2021 19:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trM9Hw6F/8BdnuCHEMW3BcGPyI0dBakVgMcEAabB39c=;
        b=OpBe4h7RXJZfLfeGas1y+gfHJChx3UikyHMtAHXrwapnv9piV4ucMppKQNHzd8UWxO
         cU71Hejufg3OwsozHy/OcHbFUMJcxNiMylHqQHGv51qk/D6AF8xb2wO/XgBLa685PhD1
         bTaVvM14jyhm9LEFz+wvt9WtDI/IePyt7eD94+I+0Z5oIA9E1yVriY179Fg3mWH2Vetc
         ARBSNApQbfEaDOCproHFC3sr1jpQJ2kN/N0yElb55M/5sA1e/j/ezPIC5lyTd5WdBlDr
         Nkv5ITdCjFEcO82Pdx15lzjanYnrwCFqVS3k5M7jDCS0sLiibWUElsMlxNG0WL/cZltJ
         DcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trM9Hw6F/8BdnuCHEMW3BcGPyI0dBakVgMcEAabB39c=;
        b=gRCWes95MJT1qjHMqabAEJ1ORnJBKLy9+DctIEPdLVv1gTlCpW4/KBq3C/4hYDrulV
         l0epC6d9vEa2550JfJDjyRPTj/Onx3bthgiAzB0FMXTITgqcyKh9EuDOxUo8kXC/VjXM
         uygV785WjLK6ZS/AiIKwKTDSIJwyUxrVIukINcAKdmHK3qrxGcWKUVJImE/PGBruD9aW
         6Yws0gZDDtB3nwjNzGTn4puIA7L+2xae9d5kg9qhaz+PuP4MqW2Oflr8cLuiRbt/fx4a
         ICTHDzRPbAIrJjg2GVefcjlWDYCbJaFmMSHFJe5v8gT20447PYzndT+IvL8CN/OWqss/
         +B0w==
X-Gm-Message-State: AOAM532Ro0uXmLnX+sqJpjuvbH6Kt/KZvhuhSowe6vRfEUloYOOdPymk
        OvLOtsx2fOSPMjPMI6v9/dfSPFTMnTlL7JrhNWJnKr31V68hhw==
X-Google-Smtp-Source: ABdhPJyITr121oeGVjWZWoCM41JlRGzYN9E81U0RQ1iMRMDSHJORCpq7VoR85XiMvKeGPJ70w0uTWkvY72EDKUS+T24=
X-Received: by 2002:a9d:63d1:: with SMTP id e17mr11835784otl.183.1614568609597;
 Sun, 28 Feb 2021 19:16:49 -0800 (PST)
MIME-Version: 1.0
References: <20210228151817.95700-1-aahringo@redhat.com> <20210228151817.95700-3-aahringo@redhat.com>
In-Reply-To: <20210228151817.95700-3-aahringo@redhat.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 28 Feb 2021 22:16:38 -0500
Message-ID: <CAB_54W4Lo7TKnqWm_xH=SncTYXTrvT3JCGxTNamagPQ4e0Vs0g@mail.gmail.com>
Subject: Re: [PATCH wpan 02/17] net: ieee802154: fix memory leak when deliver
 monitor skbs
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Sun, 28 Feb 2021 at 10:21, Alexander Aring <aahringo@redhat.com> wrote:
>
> This patch adds a missing consume_skb() when deliver a skb to upper
> monitor interfaces of a wpan phy.
>
> Reported-by: syzbot+44b651863a17760a893b@syzkaller.appspotmail.com
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  net/mac802154/rx.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index b8ce84618a55..18abc1f49323 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -244,6 +244,8 @@ ieee802154_monitors_rx(struct ieee802154_local *local, struct sk_buff *skb)
>                         sdata->dev->stats.rx_bytes += skb->len;
>                 }
>         }
> +
> +       consume_skb(skb);

Please drop this patch. It's not correct. I will look next weekend at
this one again.
The other patches should be fine, I hope.

- Alex
