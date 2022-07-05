Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB765668CF
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiGEK7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbiGEK65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E765D167D6
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 03:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8384260ED2
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790F1C341C7;
        Tue,  5 Jul 2022 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657018716;
        bh=bbDeC1AlBuTOWfz8CZE8RhaedXa7BIQPiHinMtouYyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UlpXbHB7ZZ++kGerjYF15oZgtXRRxUaGQrHVmnacNBPwa8j3eq/fMMYn36Gs87qMu
         G7UDGXmZBOEsBYTGcOyt01SXyJ6xU3QU1seAuKU257EDinBMvpusIRBC1c0XjiY+UU
         RINzLXKZ75iZuI6sckFv26LTTetgO0UcTaGUY0nc5XdXaAbFDCxfKg3Jv2pIEcmTAH
         pytVnlfQVF8P14YlhHAzigh36W4Gw3prqZpTz0wdTZYfuTJJL/kQ0HT2mIwHsniOnK
         EzXM+VOOYoqnvpvbRbmqQiEsSGnGgHLDBHi+d7duveo0DxOnLYSMJucL+avpHK5nsK
         Irv7aIWnRGdew==
Date:   Tue, 5 Jul 2022 12:58:28 +0200
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
Subject: Re: [PATCH RFC net-next 4/5] net: phylink: add
 phylink_set_max_fixed_link()
Message-ID: <20220705125828.2e7c8296@thinkpad>
In-Reply-To: <E1o8fA2-0059aI-EN@rmk-PC.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
        <E1o8fA2-0059aI-EN@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Jul 2022 10:48:02 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Add a function for DSA to use to configure phylink, in the absence of
> any other configuration, to a fixed link operating at the maximum
> supported link speed.
>=20
> This is needed so we can support phylink usage on CPU and DSA ports.
>=20
> We use the default interface that the DSA driver provides (if any)
> otherwise we attempt to find the first supported interface that gives
> the maximum speed for the link.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
