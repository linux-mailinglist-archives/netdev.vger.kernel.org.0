Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA85639A1
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiGATU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiGATU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A19510FCE
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5DAE61F20
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 19:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D10C3411E;
        Fri,  1 Jul 2022 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656703224;
        bh=zY2qYSxISx4hCMQU0t0luuI8qiBU93KBahj0z1z59vM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNiv0701zDuP4hNtkFPn0GmsHGXoppx+x1YbNyw1DIfzUQDFVYwPT8uA/cscBrllB
         fja9TFWuvFPrWhnkn6z2kKV9oY2+fSZ04lcDD1EJyn9QbfKa3Bn87B/zgISLsQod5u
         4suqjA2GDyaVhUrHZvbxHCvnfkvO52uVDTvmHQOobzRfsgB9JR2EBohJtTABUP26ux
         2ghokLvkpbDz0W/bA03ZKXGBDzwew0SOryECDUJrc7da56ni+qx7Gsp+/Ccqa0J3y/
         ef/wwWtyq3k2+8wtzP37QrOmdVGZ4j3eoaM18mb6EcqxV6geviPY8BRIKhJpL0MyeJ
         eMFDPjYWjNkVg==
Date:   Fri, 1 Jul 2022 21:20:15 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 1/6] net: dsa: add support for retrieving
 the interface mode
Message-ID: <20220701212015.638e163c@thinkpad>
In-Reply-To: <E1o6XAA-004pVc-Pd@rmk-PC.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
        <E1o6XAA-004pVc-Pd@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 13:51:22 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> DSA port bindings allow for an optional phy interface mode. When an
> interface mode is not specified, DSA uses the NA interface mode type.
>=20
> However, phylink needs to know the parameters of the link, and this
> will become especially important when using phylink for ports that
> are devoid of all properties except the required "reg" property, so
> that phylink can select the maximum supported link settings. Without
> knowing the interface mode, phylink can't truely know the maximum
> link speed.
>=20
> Update the prototype for the phylink_get_caps method to allow drivers
> to report this information back to DSA, and update all DSA
> implementations function declarations to cater for this change. No
> code is added to the implementations.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
