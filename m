Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09356ABFDF
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCFMur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjCFMum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:50:42 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FBE2BF03
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 04:50:19 -0800 (PST)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2086C3F765
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678107015;
        bh=d2FO6hgRo1/CyYGbMaXcyRawdkBhbAyeEbODmnEKOYk=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=WXf5OokjPgOAh/F0D7yd+977KdECrAsFzGXW61CjteHyAlujb2KDSLSF9q1mSUPpI
         77Cc9/EQhAjrj9FdC18pQsI7ZrbiZ/hTdkO1/6sUNVRlr57yiy+UoZYaB8bx0z081G
         Ukre8RK3BDQR9NK+3KRqhUQtgWRp9smDu6pOnsWoBzodOXRqyyJuHMH0tz3r7yA7yj
         2ZcK19sv3Jbmj3iuoEm70iYDzIQjk0Dfu03Cr73P4Y15ZFSbGfiwhsUolPXG0qWOYn
         EJEsHyr2uwmQyESUbkhSNC0d4hRajHo16TcR+5x1kBC7gExtyeFAsahMfENhFAID91
         ZYBXunc/W34QA==
Received: by mail-qt1-f197.google.com with SMTP id br8-20020a05622a1e0800b003c0189c37e1so3891307qtb.18
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 04:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678107014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2FO6hgRo1/CyYGbMaXcyRawdkBhbAyeEbODmnEKOYk=;
        b=nQarnJjsWSQw4mLS9kqUrLA8mBi3TF2jRiroh3JyDdVJz2TZYUsNnTQqc2s+/tXZb/
         4kq8tTb+1OPrz4kRfe4mWefo9MF3PU5E2Pjse4CoyP0SYSvDKwCMT/GC9peYorlTCAx4
         rdvR3NVakvb02WPn/PwdB6HbQ1lhUQv3yxKyzueu3Idn/DytsfPEFjobjz+uE8r2QR13
         lP5POP22Dq6yGmpaIiQCHiYF7fOBrwhNhmm2KqkdqtHkq1pUEv6UImLDbp62Pbt6hDQ7
         EPqJS5ISA+ZZ+RZHNhdyigkoqbF3EaumqTpqs6lIoIdYV7QRPQ6N97rZq+Pm9tnc2inF
         RtXQ==
X-Gm-Message-State: AO0yUKVuAxMyiGdtDbHaewByFsI34BHwKs8wYtnvy6pj9GeynahRgvFJ
        BXEOW6v06xYdRwyA8opUhdTJgWXKzRJGJguOTx0iD9Fopc7Zu6bLrn/KYu4tCAjRURWCs8FGOnY
        J40lxcai0veBiocwr6vBqSkwjrA7cJyfPzftplAb6tExr+F68lw==
X-Received: by 2002:a05:620a:683:b0:721:5339:2c89 with SMTP id f3-20020a05620a068300b0072153392c89mr2976778qkh.7.1678107014172;
        Mon, 06 Mar 2023 04:50:14 -0800 (PST)
X-Google-Smtp-Source: AK7set8VDmld3IafE+F3+OAwGB0W9Ba396r29jEuJpBrZUfobArOivBqdPyWCDAeND+TO5St5FaQQof4K7nfLDg0Cb8=
X-Received: by 2002:a05:620a:683:b0:721:5339:2c89 with SMTP id
 f3-20020a05620a068300b0072153392c89mr2976761qkh.7.1678107013895; Mon, 06 Mar
 2023 04:50:13 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-9-samin.guo@starfivetech.com> <CAJM55Z-3CCY8xx81Qr9UqSSQ+gOer3XXJzOvnAe7yyESk23pQw@mail.gmail.com>
 <bc79afab-17d1-8789-3325-8e6d62123dce@starfivetech.com>
In-Reply-To: <bc79afab-17d1-8789-3325-8e6d62123dce@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Mon, 6 Mar 2023 13:49:57 +0100
Message-ID: <CAJM55Z8zYUQc33r9tJB1du-FSp+uDf40720taMuGTuPcPU+aZg@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] net: stmmac: starfive_dmac: Add phy interface settings
To:     Guo Samin <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Mar 2023 at 04:07, Guo Samin <samin.guo@starfivetech.com> wrote:
> =E5=9C=A8 2023/3/4 0:50:54, Emil Renner Berthing =E5=86=99=E9=81=93:
> > On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wro=
te:
> >>
> >> dwmac supports multiple modess. When working under rmii and rgmii,
> >> you need to set different phy interfaces.
> >>
> >> According to the dwmac document, when working in rmii, it needs to be
> >> set to 0x4, and rgmii needs to be set to 0x1.
> >>
> >> The phy interface needs to be set in syscon, the format is as follows:
> >> starfive,syscon: <&syscon, offset, mask>
> >>
> >> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> >> ---
> >>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 46 ++++++++++++++++++=
+
> >>  1 file changed, 46 insertions(+)
> >>
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/dr=
ivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >> index 566378306f67..40fdd7036127 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >> @@ -7,10 +7,15 @@
> >>   *
> >>   */
> >>
> >> +#include <linux/mfd/syscon.h>
> >>  #include <linux/of_device.h>
> >> +#include <linux/regmap.h>
> >>
> >>  #include "stmmac_platform.h"
> >>
> >> +#define MACPHYC_PHY_INFT_RMII  0x4
> >> +#define MACPHYC_PHY_INFT_RGMII 0x1
> >
> > Please prefix these with something like STARFIVE_DWMAC_
> >
> Hi, Emil, These definitions come from the datasheet of dwmac. However, ad=
d STARDRIVE_ DWMAC is a good idea. I will fix it,thanks.
> >>  struct starfive_dwmac {
> >>         struct device *dev;
> >>         struct clk *clk_tx;
> >> @@ -53,6 +58,46 @@ static void starfive_eth_fix_mac_speed(void *priv, =
unsigned int speed)
> >>                 dev_err(dwmac->dev, "failed to set tx rate %lu\n", rat=
e);
> >>  }
> >>
> >> +static int starfive_dwmac_set_mode(struct plat_stmmacenet_data *plat_=
dat)
> >> +{
> >> +       struct starfive_dwmac *dwmac =3D plat_dat->bsp_priv;
> >> +       struct of_phandle_args args;
> >> +       struct regmap *regmap;
> >> +       unsigned int reg, mask, mode;
> >> +       int err;
> >> +
> >> +       switch (plat_dat->interface) {
> >> +       case PHY_INTERFACE_MODE_RMII:
> >> +               mode =3D MACPHYC_PHY_INFT_RMII;
> >> +               break;
> >> +
> >> +       case PHY_INTERFACE_MODE_RGMII:
> >> +       case PHY_INTERFACE_MODE_RGMII_ID:
> >> +               mode =3D MACPHYC_PHY_INFT_RGMII;
> >> +               break;
> >> +
> >> +       default:
> >> +               dev_err(dwmac->dev, "Unsupported interface %d\n",
> >> +                       plat_dat->interface);
> >> +       }
> >> +
> >> +       err =3D of_parse_phandle_with_fixed_args(dwmac->dev->of_node,
> >> +                                              "starfive,syscon", 2, 0=
, &args);
> >> +       if (err) {
> >> +               dev_dbg(dwmac->dev, "syscon reg not found\n");
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       reg =3D args.args[0];
> >> +       mask =3D args.args[1];
> >> +       regmap =3D syscon_node_to_regmap(args.np);
> >> +       of_node_put(args.np);
> >
> > I think the above is basically
> > unsigned int args[2];
> > syscon_regmap_lookup_by_phandle_args(dwmac->dev_of_node,
> > "starfive,syscon", 2, args);
> >
> > ..but as Andrew points out another solution is to use platform match
> > data for this. Eg.
> >
> > static const struct starfive_dwmac_match_data starfive_dwmac_jh7110_dat=
a {
> >   .phy_interface_offset =3D 0xc,
> >   .phy_interface_mask =3D 0x1c0000,
> > };
> >
> > static const struct of_device_id starfive_dwmac_match[] =3D {
> >   { .compatible =3D "starfive,jh7110-dwmac", .data =3D
> > &starfive_dwmac_jh7110_data },
> >   { /* sentinel */ }
> > };
> >
> > and in the probe function:
> >
> Hi Emil, Yes=EF=BC=8Cthis is usually a good solution, and I have consider=
ed this plan before.
> However, gmac0 of jh7110 is different from the reg/mask of gmac1.
> You can find it in patch-9:
>
> &gmac0 {
>         starfive,syscon =3D <&aon_syscon 0xc 0x1c0000>;
> };
>
> &gmac1 {
>         starfive,syscon =3D <&sys_syscon 0x90 0x1c>;
> };
>
> In this case, using match_data of starfive,jh7110-dwma does not seem to b=
e compatible.

Ugh, you're right. Both the syscon block, the register offset and the
bit position in those registers are different from gmac0 to gmac1, and
since we need a phandle to the syscon block anyway passing those two
other parameters as arguments is probably the nicest solution. For the
next version I'd change the 2nd argument from mask to the bit position
though. It seems the field is always 3 bits wide and this makes it a
little clearer that we're not just putting register values in the
device tree. Eg. something like

regmap =3D syscon_regmap_lookup_by_phandle_args(dev->of_node,
"starfive,syscon", 2, args);
...
err =3D regmap_update_bits(regmap, args[0], 7U << args[1], mode << args[1])=
;
...

Alternatively we'd put data for each gmac interface in the platform
data including the syscon compatible string, and use
syscon_regmap_lookup_by_compatible("starfive,jh7110-aon-syscon"); for
gmac0 fx. This way the dependency from the gmac nodes to the syscon
nodes won't be recorded is the device tree though.

@Andrew is this what you were suggesting?

> > struct starfive_dwmac_match_data *pdata =3D device_get_match_data(&pdev=
->dev);
> >
> >> +       if (IS_ERR(regmap))
> >> +               return PTR_ERR(regmap);
> >> +
> >> +       return regmap_update_bits(regmap, reg, mask, mode << __ffs(mas=
k));
> >> +}
> >> +
> >>  static int starfive_dwmac_probe(struct platform_device *pdev)
> >>  {
> >>         struct plat_stmmacenet_data *plat_dat;
> >> @@ -93,6 +138,7 @@ static int starfive_dwmac_probe(struct platform_dev=
ice *pdev)
> >>         plat_dat->bsp_priv =3D dwmac;
> >>         plat_dat->dma_cfg->dche =3D true;
> >>
> >> +       starfive_dwmac_set_mode(plat_dat);
> >
> > The function returns errors in an int, but you never check it :(
> >
> Thank you for pointing out that it will be added in the next version.
> >>         err =3D stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> >>         if (err) {
> >>                 stmmac_remove_config_dt(pdev, plat_dat);
>
>
> Best regards,
> Samin
>
> >> --
> >> 2.17.1
> >>
> >>
> >> _______________________________________________
> >> linux-riscv mailing list
> >> linux-riscv@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> --
> Best regards,
> Samin
