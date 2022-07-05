Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7765668B5
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiGEK4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiGEKz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:55:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980617070
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 03:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AA6860AF1
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EE4C341C7;
        Tue,  5 Jul 2022 10:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657018509;
        bh=Ki3Il3DnBY0QlDat/5g0CnbI0kYoYCMqVu2X4F/0W8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pBsF4oVT5py0/qMuyBsxVgtedQGhBDne/OXAPKU/IEJoN5H42JRBhW8WJURZKgc+V
         7WSeFv3FMQ8x563aq0wH4F/S3XQQxaVaVL1o3Ko+DhQGVWrAXBozU9gaRfBuwYWYgc
         3NRog0EEQJ6wqC3y8oe0DPtm8FdsmhXtavcuZfS+cLCnlRsMkJHfAGFyrlSNua8YhP
         c3IGt0c8pzLxrbbaymOB4Vzj/BHGHRKbcJIgUjaKhUONXkzUQ+ZBdGcPM8DHVK0v6O
         ygxCSlYx7YwvNhwPQVyqq418FBk6Sktf5InQNQKHiZ1Alf/WS61f68HA1ThIg2Khe3
         B041Mqp8Lz71w==
Date:   Tue, 5 Jul 2022 12:55:00 +0200
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
Subject: Re: [PATCH RFC net-next 2/5] net: dsa: mv88e6xxx: report the
 default interface mode for the port
Message-ID: <20220705125500.3c57b531@thinkpad>
In-Reply-To: <E1o8f9s-0059a6-3S@rmk-PC.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
        <E1o8f9s-0059a6-3S@rmk-PC.armlinux.org.uk>
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

On Tue, 05 Jul 2022 10:47:52 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Report the maximum speed interface mode for the port, or if we don't
> have that information, the hardware configured interface mode for
> the port.
>=20
> This allows phylink to know which interface mode CPU and DSA ports
> are operating, which will be necessary when we want to select the
> maximum speed for the port (required for such ports without a PHY or
> fixed-link specified in firmware.)
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
