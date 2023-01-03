Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E44B65C363
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjACP4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjACP4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:56:39 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A233DA1AD;
        Tue,  3 Jan 2023 07:56:38 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b88so37104941edf.6;
        Tue, 03 Jan 2023 07:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUgk7t5CLogpADp6v+03F2a0C4ndvH9yI7BzPUoVTz8=;
        b=Nlop0vV2rhk/Y14mg/LYKMI/LgbnDu0LklT8ZlGkVGT6ndSrTIzsmfL+UKV+rctl7C
         LTgsO6ABsOsdupP0jMFKDPkeJOR/AjFdfRo1Kg92jTO3bYdUXQy0W2AOAvF67poVg1Ax
         M1E36j+goZnA9IKiW00QGwlwffPb/29IZCIUJRj5YM3kGL/tOGPHmNWLJ32If2ZsqA6V
         P1G2DWN8BnASIEwuGtlrA933d7Yn9FSU/Z3x+ITFmaWt+G4dhW7kYHic9RylMsTtx5f2
         h0dZVKaxxZc4PhVmuSZ6Qtq4+903piGIKgA58TaiWTJ4GgrOy0O/gWNWrVTaOitxuPgL
         bavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUgk7t5CLogpADp6v+03F2a0C4ndvH9yI7BzPUoVTz8=;
        b=7qF6lGZgptzaH3MVXs0Ccj3PeoiAZt3SQiSb1CnRmL2AJg8x3gw2vJ38HWJntW4Lb0
         WwPEaiyQnpUkYJ2HQMaIQNSNOwhSaVhL9v57eIjpPrKxwe3a/en0oI1qGcQdkHfh9jr1
         /Mdz/JvCPeeJZIUjbvMRtR76UxFT9O0B3FY7FcZuDpGBVfSUnu7iAATmE23UcLRqfDwf
         s8cPnJq0pLFZYxJJCZg4G1myhlSk5cQBPq1Yy00RMkLPlVPDgwagalgJV+Ia6B02UyhB
         O2W0YBEDnuGEwxHu5tRa2/1aO+7FPIaOnrlufOTb/ulroh6dnO6m69AuooEdQx0sI39N
         RGzw==
X-Gm-Message-State: AFqh2ko2hUbURT1JZqAoLc1ylPp5cKaF3dCF9PVZkfNb0vKLOAlmfRZl
        MLcFlsEPv28/BMY/7QxlRD0=
X-Google-Smtp-Source: AMrXdXtoAYN/JnDVDN1YkdRe3Sjl9+sUDPRbeIocCAM+QeCzmE90ykdzaDAgpT+gUrrkq+LbtncKDA==
X-Received: by 2002:aa7:d04d:0:b0:46c:d905:b9e8 with SMTP id n13-20020aa7d04d000000b0046cd905b9e8mr37622928edo.23.1672761396798;
        Tue, 03 Jan 2023 07:56:36 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm14252877ejo.6.2023.01.03.07.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 07:56:36 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:56:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: Re: [PATCH RFC net-next v2 11/12] net: dsa: Separate C22 and C45
 MDIO bus transaction methods
Message-ID: <20230103155633.tfdxncl75s4tb2ln@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20230103153134.utalc6kw3l34dp4s@skbuf>
 <Y7ROa8ql9R5SHPsK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7ROa8ql9R5SHPsK@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 04:48:59PM +0100, Andrew Lunn wrote:
> > Since clause 45 PHYs are identified by the "ethernet-phy-ieee802.3-c45"
> > compatible string (otherwise they are C22), then a PHY which is not
> > described in the device tree can only be C22. So this is why
> > ds->slave_mii_bus only deals with clause 22 methods, and the true reason
> > behind the comment above.
> > 
> > But actually this premise is no longer true since Luiz' commit
> > fe7324b93222 ("net: dsa: OF-ware slave_mii_bus"), which introduced the
> > strange concept of an "OF-aware helper for internal PHYs which are not
> > described in the device tree". After his patch, it is possible to have
> > something like this:
> > 
> > 	ethernet-switch {
> > 		ethernet-ports {
> > 			port@1 {
> > 				reg = <1>;
> > 			};
> > 		};
> > 
> > 		mdio {
> > 			ethernet-phy@1 {
> > 				compatible = "ethernet-phy-ieee802.3-c45"
> > 				reg = <1>;
> > 			};
> > 		};
> > 	};
> > 
> > As you can see, this is a clause 45 internal PHY which lacks a
> > phy-handle, so its bus must be put in ds->slave_mii_bus in order for
> > dsa_slave_phy_connect() to see it without that phy-handle (based on the
> > port number matching with the PHY number). After Luiz' patch, this kind
> > of device tree is possible, and it invalidates the assumption about
> > ds->slave_mii_bus only driving C22 PHYs.
> 
> My memory is hazy, but i think at the time i wrote these patches,
> there was no DSA driver which made use of ds->slave_mii_bus with
> C45. So i took the short cut of only supporting C22.

Actually I believe that in v1 you did extend ds->ops with C45 methods,
but it's me who told you to remove them:
https://patchwork.kernel.org/project/netdevbpf/patch/20220508153049.427227-10-andrew@lunn.ch/#24852813

> 
> Those DSA drivers which do support C45 all register their bus directly
> with the MDIO core.

And rightfully so. IMHO, letting DSA allocate ds->slave_mii_bus out of
driver writer sheer convenience (a secondary purpose) should be deprecated,
unless the reason for using ds->slave_mii_bus is the lack of a phy-handle
(the primary purpose). It becomes that more confusing to have to extend
dsa_switch_ops with 2 more methods which serve the secondary purpose but
not the primary one.

> So Luiz patches may allow a C45 bus, but are there any drivers today
> actually using it?

I sent a private email to Luiz a few minutes ago asking him to confirm.
