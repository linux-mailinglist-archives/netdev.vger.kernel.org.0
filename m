Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEC7563A3D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiGATbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGATbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF58D218
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A2E061DDD
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 19:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C35C3411E;
        Fri,  1 Jul 2022 19:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656703897;
        bh=2qb8vhqSSIX5gIPVYerY+osM9H3IkKn7DwTR56CMqlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JBAJOMqk/toX6QQVXfsdJ/Yfyarr/eJ7izTsPsnkqk7dqpfGamryFRoF7cBp2vLsP
         Vc64zHyQ7buTSQyYBADVB4viEVcPITSpmKV+UnneMUsJAtTO835UnESZwdq/HARF9u
         9wFFWrnjKxcmJ1uJd55oGa9zfiTWqFYWR/OSRj4/i2lYXxQAZtCZ8g1qdDSZvSKUtJ
         ZNPSA3M0Vi7fbGrTmtrIL2OYAPgKHynqGRGAtTu9aFPjOTuBldjnkI4GDj2cF9yhao
         JnsY8l53UJsWeeYXTuGr80ityjHpiN/c3BNuvDv4004G5SRG2roZKxhYgUcJlO5KEV
         vBOUTjo831QzQ==
Date:   Fri, 1 Jul 2022 21:31:28 +0200
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
Subject: Re: [PATCH RFC net-next 4/6] net: phylink: add
 phylink_set_max_fixed_link()
Message-ID: <20220701213128.04adf92e@thinkpad>
In-Reply-To: <E1o6XAQ-004pVw-7o@rmk-PC.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
        <E1o6XAQ-004pVw-7o@rmk-PC.armlinux.org.uk>
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

On Wed, 29 Jun 2022 13:51:38 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Add a function for DSA to use to configure phylink, in the absence of
> any other configuration, to a fixed link operating at the maximum
> supported link speed.
>=20
> This is needed so we can support phylink usage on CPU and DSA ports.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
