Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E82F563A0C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiGAT3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiGAT26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:28:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B171F2
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85260B8311E
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 19:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BD8C341C8;
        Fri,  1 Jul 2022 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656703684;
        bh=XFiF9O9nMK8GrdCfNShtw8oBQenyZQmibCsOZ29A9r4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tkkXlGlONtnoseVjaFV48gdmxxETQ/kFmhvroW0xIWGyGNdq6KinGzwR7rPo/eFlt
         n5WNQzZAXoy86TDSL/9svpokOVHlWCIBqwl2bkTr6JywulCjgGpRafA6Io/E5ZIGjo
         crS/VpuaFloSOWpHgKgVAflAkCV7ZPe9HXUDxbiiUnmwxhSYmc19RdiwQYx1zmReHu
         BAOJociFxItbUyLr5odQWvZDlQ/IPB0bIgb33/vNkc5518n7x+weSYdgZNgBT9q29j
         vasGkL1IL9QpjkO8liZl2rEpZlVQzOlqNTkChx1yiFQnsgf8ZOF/gmi4SzkWdp1ncC
         bBkKo4iFK6LVw==
Date:   Fri, 1 Jul 2022 21:27:55 +0200
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
Subject: Re: [PATCH RFC net-next 3/6] net: phylink: split out interface to
 caps translation
Message-ID: <20220701212755.156da4ff@thinkpad>
In-Reply-To: <E1o6XAL-004pVp-36@rmk-PC.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
        <E1o6XAL-004pVp-36@rmk-PC.armlinux.org.uk>
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

On Wed, 29 Jun 2022 13:51:33 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> phylink_get_linkmodes() translates the interface mode into a set of
> speed and duplex capabilities which are masked with the MAC modes
> to then derive the link modes that are available.
>=20
> Split out the initial transformation into a new function
> phylink_interface_to_caps(), which will be useful when setting the
> maximum fixed link speed.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
