Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816C5607E4C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 20:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJUScU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 14:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJUScT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 14:32:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75D3272106;
        Fri, 21 Oct 2022 11:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bv4YI8sSgHvwniEnSXvaz0DDBkZlp+9CNcDod+TFfKw=; b=12I3Ud5kvQPhpdSlXRIqfJDNKS
        6jKrzdwfEmBkdaJ/G/BHpwlAPxUHA/9AZUxKfcZ0+xuK5dA7IilLovhlR87MWqUS88sH8tUxwdvlk
        8fPlmPgVUkLKBewzgswYL8LS4cXxaZkC3Y7e+KJb70THzJ1daIv152U40UbwrxV3+O6tDiMsTChuB
        phGR3u+mibTuXYkaYpFrL+H8f3qxfL0Kr1vmEqURr1/5ehkVQioqYvZbLSI9gNe/FmyXZme5uCZzl
        fOYU2B/MyAcj1iGKcofxWgvhwqp4fnu5BO3GnY4FAjyF6vw8iwFPprB2EEAgZ4tPhzdnrTeOJXXJT
        8VH8T7kQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34876)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olwoM-0000aJ-UI; Fri, 21 Oct 2022 19:32:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olwoG-0004Mo-Hd; Fri, 21 Oct 2022 19:31:56 +0100
Date:   Fri, 21 Oct 2022 19:31:56 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
 <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
 <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
 <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 07:47:47PM +0200, Frank Wunderlich wrote:
> > Gesendet: Freitag, 21. Oktober 2022 um 11:06 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > An: "Frank Wunderlich" <frank-w@public-files.de>
> > On Fri, Oct 21, 2022 at 08:04:51AM +0200, Frank Wunderlich wrote:
> > > I have no register documentation to check if there is any way to read out pause/duplex setting. Maybe MTK can answer this or extend function later.
> >
> > I suspect we can probably guess.
> >
> > Looking at SGMSYS_PCS_CONTROL_1, this is actually the standard BMCR in
> > the low 16 bits, and BMSR in the upper 16 bits, so:
> >
> > At address 4, I'd expect the PHYSID.
> > At address 8, I'd expect the advertisement register in the low 16 bits
> > and the link partner advertisement in the upper 16 bits.
> >
> > Can you try an experiment, and in mtk_sgmii_init() try accessing the
> > regmap at address 0, 4, and 8 and print their contents please?
> 
> is this what you want to see?
> 
>  int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
>  {
>         struct device_node *np;
> +       unsigned int val;
>         int i;
> 
>         for (i = 0; i < MTK_MAX_DEVS; i++) {
> @@ -158,6 +159,12 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
>                 if (IS_ERR(ss->pcs[i].regmap))
>                         return PTR_ERR(ss->pcs[i].regmap);
> 
> +               regmap_read(ss->pcs[i].regmap, SGMSYS_PCS_CONTROL_1, &val);
> +               printk(KERN_ALERT "dev: %d offset:0 0x%x",i,val);
> +               regmap_read(ss->pcs[i].regmap, SGMSYS_PCS_CONTROL_1+4, &val);
> +               printk(KERN_ALERT "dev: %d offset:4 0x%x",i,val);
> +               regmap_read(ss->pcs[i].regmap, SGMSYS_PCS_CONTROL_1+8, &val);
> +               printk(KERN_ALERT "dev: %d offset:8 0x%x",i,val);
>                 ss->pcs[i].pcs.ops = &mtk_pcs_ops;
>         }
> 
> 
> [    1.083359] dev: 0 offset:0 0x840140
> [    1.083376] dev: 0 offset:4 0x4d544950
> [    1.086955] dev: 0 offset:8 0x1
> [    1.090697] dev: 1 offset:0 0x81140
> [    1.093866] dev: 1 offset:4 0x4d544950
> [    1.097342] dev: 1 offset:8 0x1

Thanks. Decoding these...

dev 0:
 BMCR: fixed, full duplex, 1000Mbps, !autoneg
 BMSR: link up
 Phy ID: 0x4d54 0x4950
 Advertise: 0x0001 (which would correspond with the MAC side of SGMII)
 Link partner: 0x0000 (no advertisement received, but we're not using
    negotiation.)

dev 1:
 BMCR: autoneg (full duplex, 1000Mbps - both would be ignored)
 BMSR: able to do autoneg, no link
 Phy ID: 0x4d54 0x4950
 Advertise: 0x0001 (same as above)
 Link partner: 0x0000 (no advertisement received due to no link)

Okay, what would now be interesting is to see how dev 1 behaves when
it has link with a 1000base-X link partner that is advertising
properly. If this changes to 0x01e0 or similar (in the high 16-bits
of offset 8) then we definitely know that this is an IEEE PHY register
set laid out in memory, and we can program the advertisement and read
the link partner's abilities.

At that point, we should try programming the low 16-bits of offset 8
to see whether that advertisement makes it to the far end of the link.

It would be well worth trying to work this out, because it will then
vastly improve the knowledge of this hardware, and improve the
driver no end.

Is this something you could investigate please?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
