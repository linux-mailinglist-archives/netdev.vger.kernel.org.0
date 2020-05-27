Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F531E43EA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbgE0Nhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387627AbgE0Nhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:37:52 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826E6C08C5C2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 06:37:52 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id y1so8433545qtv.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 06:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K5fHO02+PN/2Q6ZCPK4dYN19pxbY+Th3EZc6EUW67vk=;
        b=D9iYOTuJuftIfysOzhwmQ0vn4d/vsEei6RY106AsYqM+lY2JkboSBXkTeZABIrmuxA
         767ViAm38EWF6tO26zBKiyf6W+hmOrYxdHQBw4nEUtjSeqYWHHXf/kXKzamdnyqE+B0/
         NcN6NfN9X+hx601WT5qZpx844inwztmEtCS5m3mE2eThHgNWjuM7Cjlr61cosLwzjU84
         bfVc91qe0YOmWi/Oeb+6nLrWWrGErBHH26EzrhxqM7p0pCb8MaMuVOxX7aEgBjhO4l/p
         rQrt4YogqHaPQJSlS86Uiw3CtXzfIQnRG8unL3g8T/mG4LMJUi/6R7d2NEiR8Kn45trT
         YiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K5fHO02+PN/2Q6ZCPK4dYN19pxbY+Th3EZc6EUW67vk=;
        b=C/8NTN/M7iE9Kxfg+qJIW7OfnxKjw/1MslruLswDjQCUB7zR83vx/lLOaMTBDLtCvX
         mBOVZf3DeJnrsV9UHxJX+jGDvR4ThRTEqJdcLaUbO8M/9fWdKchtwEYmxvsVRYCThVr3
         sRp2Ca0AB3dRXELFed48XNoa1MkRh1fgxPnf2mcT9KeH7OhwNka3BSvyv8LKrnPtIFLq
         HWOU4M2cZCfnurTaFv/lncb++W+NEcnewkxCN27iJGZMNDepZu7fMS1GYY/H3G1ThCS0
         GAW6cvazPBis6AP0BfCemsfeDv/Q3mED8MYbzIHCweRi2d9XK+0/ppJZpZdSqvoBNvgo
         r+2g==
X-Gm-Message-State: AOAM532nIGo0R2oQF4enY5EqHN8imbJ7EJsUW7xQ7Jt20dnHLElUwnhG
        w+nNXGZu67Wz75TePaNxhjwXSt0zAbqU1o5JPglz1g==
X-Google-Smtp-Source: ABdhPJyF4EYb3EdIRy+uh7qF8OG1s7b7hlCQ5K73FZQQ2Hmzwq6yKclZidEBmqETHn2raBDlYd3qdYAOxeSVU4PKrjE=
X-Received: by 2002:ac8:2242:: with SMTP id p2mr4052242qtp.27.1590586671749;
 Wed, 27 May 2020 06:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200527133513.579367-1-arnd@arndb.de>
In-Reply-To: <20200527133513.579367-1-arnd@arndb.de>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Wed, 27 May 2020 15:37:41 +0200
Message-ID: <CAMpxmJU63A2O_JE6G42FwVBN8hj6YQjKuQDFhmJLOMkDqtX=tA@mail.gmail.com>
Subject: Re: [PATCH] [net-next] mtk-star-emac: mark PM functions as __maybe_unused
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Felix Fietkau <nbd@openwrt.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 27 maj 2020 o 15:35 Arnd Bergmann <arnd@arndb.de> napisa=C5=82(a)=
:
>
> Without CONFIG_PM, the compiler warns about two unused functions:
>
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1472:12: error: unused func=
tion 'mtk_star_suspend' [-Werror,-Wunused-function]
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1488:12: error: unused func=
tion 'mtk_star_resume' [-Werror,-Wunused-function]
>
> Mark these as __maybe_unused.
>
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/=
ethernet/mediatek/mtk_star_emac.c
> index b18ce47c4f2e..3223567fe1cb 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -1469,7 +1469,7 @@ static int mtk_star_mdio_init(struct net_device *nd=
ev)
>         return ret;
>  }
>
> -static int mtk_star_suspend(struct device *dev)
> +static __maybe_unused int mtk_star_suspend(struct device *dev)
>  {
>         struct mtk_star_priv *priv;
>         struct net_device *ndev;
> @@ -1485,7 +1485,7 @@ static int mtk_star_suspend(struct device *dev)
>         return 0;
>  }
>
> -static int mtk_star_resume(struct device *dev)
> +static __maybe_unused int mtk_star_resume(struct device *dev)
>  {
>         struct mtk_star_priv *priv;
>         struct net_device *ndev;
> --
> 2.26.2
>

Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
