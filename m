Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510544339F5
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhJSPQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:16:21 -0400
Received: from mail-vk1-f178.google.com ([209.85.221.178]:33723 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbhJSPQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:16:19 -0400
Received: by mail-vk1-f178.google.com with SMTP id r26so1161098vkq.0;
        Tue, 19 Oct 2021 08:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fB/2pInV/75e4NnyCMXXkeVh+Ni7M1P708BMXGlIBnc=;
        b=MhyTJSAnXTBD24vluoR/dimjofvSMbNYVkIsjRDw8AlTKPkIzbOovwr2LCKjyluweU
         pr12k5ZbMMmEMy776rFsN2h2dtSMKaRL1xovh80hVrJ5e1cakpkgebHum723oythGS+p
         mAiys1XQQ8dLw0gez7rp/8YWfQFhLwnGejghxO0uL7w9JIt1XbqwSaBrBpYTjSjWmBc0
         yH1LDmOHGVstMT9UJVhrmH4PDiTGNbxkYTx2Gvo1nFNH5Apgt9pZQ7uVughMRqgjdPwT
         8lH7T/9EsFbzr40b5G0xKn6y9eg07zJbZfSnXF8ve5LCif2wsKXVSOBlPSCaYKqKammj
         Dwdg==
X-Gm-Message-State: AOAM530m3xw/uYRdZ0M4mCPSkqtfkv3+dmDsWWHe3kK81qTDMyEB770s
        aInNzqQEEcPF/HLdSwUJZ7+QCi1sSRoHiQ==
X-Google-Smtp-Source: ABdhPJydq6bpuaLUhng8Pj+QLHtGE+AmsJAHNijPKNzByPNr8UrriJTaKkmV8krptY5FCVK/Z4oFKg==
X-Received: by 2002:a1f:1844:: with SMTP id 65mr32315692vky.3.1634656445571;
        Tue, 19 Oct 2021 08:14:05 -0700 (PDT)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com. [209.85.221.171])
        by smtp.gmail.com with ESMTPSA id o18sm11083178vkb.21.2021.10.19.08.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 08:14:04 -0700 (PDT)
Received: by mail-vk1-f171.google.com with SMTP id j12so10507435vka.4;
        Tue, 19 Oct 2021 08:14:04 -0700 (PDT)
X-Received: by 2002:a05:6122:a20:: with SMTP id 32mr32414786vkn.15.1634656444011;
 Tue, 19 Oct 2021 08:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
In-Reply-To: <20211019145719.122751-1-kory.maincent@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Oct 2021 17:13:52 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
Message-ID: <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
To:     Kory Maincent <kory.maincent@bootlin.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kory,

Thanks for your patch!

On Tue, Oct 19, 2021 at 4:57 PM Kory Maincent <kory.maincent@bootlin.com> wrote:
> Invert the configuration of the RGMII delay selected by RGMII_RXID and
> RGMII_TXID.
>
> The ravb MAC is adding RX delay if RGMII_RXID is selected and TX delay
> if RGMII_TXID but that behavior is wrong.
> Indeed according to the ethernet.txt documentation the ravb configuration

Do you mean ethernet-controller.yaml?

> should be inverted:
>   * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
>      should not add an RX delay in this case)
>   * "rgmii-txid" (RGMII with internal TX delay provided by the PHY, the MAC
>      should not add an TX delay in this case)
>
> This patch inverts the behavior, i.e adds TX delay when RGMII_RXID is
> selected and RX delay when RGMII_TXID is selected.
>
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>

Does this fix an actual problem for you?

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2114,13 +2114,13 @@ static void ravb_parse_delay_mode(struct device_node *np, struct net_device *nde
>         /* Fall back to legacy rgmii-*id behavior */

Note that in accordance with the comment above, the code section
below is only present to support old DTBs.  Contemporary DTBs rely
on the now mandatory "rx-internal-delay-ps" and "tx-internal-delay-ps"
properties instead.
Hence changing this code has no effect on DTS files as supplied with
the kernel, but may have ill effects on DTB files in the field, which
rely on the current behavior.

>         if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
>             priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> -               priv->rxcidm = 1;
> +               priv->txcidm = 1;
>                 priv->rgmii_override = 1;
>         }
>
>         if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
>             priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> -               priv->txcidm = 1;
> +               priv->rxcidm = 1;
>                 priv->rgmii_override = 1;
>         }
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
