Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF0689C76
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjBCPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjBCPAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:00:21 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D4EA07D4;
        Fri,  3 Feb 2023 07:00:19 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id p26so15964764ejx.13;
        Fri, 03 Feb 2023 07:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Hs+VSiLtw/0ycdRLnref8xrRHiTeKna2LFz/+6QKUM=;
        b=SsFWjrzkDBkMP+/hywWuJ2cMsYTnLdbgvmIoBD+PNXOVxNALzCD443cghDI+XabBee
         qXmdXSgVUd6uubZXh1LdhkT0tHgc1HHS2icDerWEvhlOx3DPNfE+MFET3vntSeI4SpCP
         Wh6Nihwct+YW2YazN94lMwrX/GuLktOGcf6BuZ+US/n2avNwHpZmJG4leg2s+qI3y8I1
         crFQiI4cs8iA6c9wjEpaWqoOlx9f0LX/4XjXOJrNSPiXxakCm+KzIft9ilruKEdJwdpI
         UelLAS+un3wbNUvYF4W5CNXLi6trXiIXIR4H1cHV8jxPHAM5bGUR52wWTeIXtLvppR5B
         IQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Hs+VSiLtw/0ycdRLnref8xrRHiTeKna2LFz/+6QKUM=;
        b=uJa6N8xMAYDBW3IeNTKRcz8BdWVgzBXu41ELrhu6YqbwaFEhpX+gLuIgX1rk/aR7Vn
         Q/xXIqHRxRUwtgcEIO0HdhCV1M1q5oaor1A6krLJrHLkLN/6TCPPOjHA7w/hBcT8yJFp
         LG354Wi55OdTdjOoT01fgtmQj8opniWjmI+l5HBUJpWOBOM46DpjKWhBzGI09XzM+NNd
         EwawW1hiqtAmvdJfX49EZHrDGJfwOvQgHOxrMlFSaOgKnyarJbfHSr/YeNH/jeXrFkr9
         v3WJ19g5azBVT435YbVbflGiCJX8StlmmFwvcSog6AunIog8o5s+kcxZiYuhGY3xqgX4
         u1bA==
X-Gm-Message-State: AO0yUKXGvOC8ef846qnxK3fvwW+LhoaU65O/s43EkYiwdE1jW9UKju4u
        MY6s3AsmP2sDuDBWtp0x2Tc=
X-Google-Smtp-Source: AK7set9j91UKcYEbur5rEMc26mRxeJGocDFMSWfjHwCaDkxjCaw5J1ct9ODqrAKzioMF3HcmNiA/Zg==
X-Received: by 2002:a17:906:e118:b0:878:7662:7c8e with SMTP id gj24-20020a170906e11800b0087876627c8emr10841306ejb.55.1675436417906;
        Fri, 03 Feb 2023 07:00:17 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id g6-20020a1709061c8600b007c14ae38a80sm1450453ejh.122.2023.02.03.07.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:00:17 -0800 (PST)
Date:   Fri, 3 Feb 2023 17:00:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 7/9] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <20230203150014.ugkasp4rq5arqs6s@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <30f3ff512a2082ba4cf58bf6098f2ed776051976.1675407169.git.daniel@makrotopia.org>
 <Y90Wxb8iuCRo06yr@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y90Wxb8iuCRo06yr@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 03:14:29PM +0100, Andrew Lunn wrote:
> > index 6e7e6c346a3e..cf65646656e9 100644
> > --- a/drivers/net/pcs/Kconfig
> > +++ b/drivers/net/pcs/Kconfig
> > @@ -18,6 +18,12 @@ config PCS_LYNX
> >  	  This module provides helpers to phylink for managing the Lynx PCS
> >  	  which is part of the Layerscape and QorIQ Ethernet SERDES.
> >  
> > +config PCS_MTK
> > +	tristate
> > +	help
> > +	  This module provides helpers to phylink for managing the LynxI PCS
> > +	  which is part of MediaTek's SoC and Ethernet switch ICs.
> 
> You should probably have a more specific name, for when MTK produces a
> new PCS which is completely different.
> 
> Also, how similar is this LynxI PCS to the Lynx PCS?

Probably not very similar. Here's the Mediatek 32-bit memory map,
translated by me to a 16-bit MDIO memory map:

/* SGMII subsystem config registers */
/* BMCR (low 16) BMSR (high 16) */
#define SGMSYS_PCS_CONTROL_1		0x0		// BMCR at MDIO addr 0x0, BMSR at 0x1, aka standard

#define SGMSYS_PCS_DEVICE_ID		0x4		// PHYSID1 at 0x2, PHYSID2 at 0x3, aka standard

#define SGMSYS_PCS_ADVERTISE		0x8		// MII_ADV at 0x4, MII_LPA at 0x5

#define SGMSYS_PCS_SCRATCH		0x14		// MDIO address 0xa

/* Register to programmable link timer, the unit in 2 * 8ns */
#define SGMSYS_PCS_LINK_TIMER		0x18		// MDIO address 0xc

/* Register to control remote fault */
#define SGMSYS_SGMII_MODE		0x20		// MDIO address 0x10

/* Register to reset SGMII design */
#define SGMII_RESERVED_0		0x34		// MDIO address 0x1a

/* Register to set SGMII speed, ANA RG_ Control Signals III */
#define SGMSYS_ANA_RG_CS3		0x2028		// not sure how to access this through C22, OTOH not used?

/* Register to power up QPHY */
#define SGMSYS_QPHY_PWR_STATE_CTRL	0xe8		// again, not sure how to access through C22


Compared to these definitions for Lynx, the rest being standard regs:

#define LINK_TIMER_LO			0x12
#define LINK_TIMER_HI			0x13
#define IF_MODE				0x14

So the standard bits appear to be common, the vendor extensions different.
When I say common, I only take into consideration the memory map, not
the differences in handling. For example, what Lynx handles as a single
call to phylink_mii_c22_pcs_get_state(), the Mediatek PCS handles as a
call to mtk_pcs_get_state().
