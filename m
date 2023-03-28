Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D446CCD48
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjC1WfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC1WfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:35:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBAA2123;
        Tue, 28 Mar 2023 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oUvWcSk4q2OtdCCFSokbqXR2MDjcWokmOFXBQXZUNrs=; b=23p5LPbwhEL8SKLaUdZHVRAOQC
        n77xT4tNz5KGDYJ33g14arqK+v/nWQECGWaL2I+DQCR/RnpvBm1V0n4y72E4RZqbHdkR5+F2l2s4s
        S7WMuLqStlge1lR4feWxBo/GqASj+AFFy9uBnKoTU9iTts8YJ+OQnKtKX4KJGG8LGWCs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phHu8-008hJt-PY; Wed, 29 Mar 2023 00:35:00 +0200
Date:   Wed, 29 Mar 2023 00:35:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v2 1/2] net: dsa: mt7530: split-off MDIO
 driver
Message-ID: <c50b91b7-4dfc-45d7-9fd2-f1afb4480acc@lunn.ch>
References: <cover.1680041193.git.daniel@makrotopia.org>
 <4acd93e451146cee593c1b91b74ee72319c63833.1680041193.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4acd93e451146cee593c1b91b74ee72319c63833.1680041193.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 11:16:51PM +0100, Daniel Golle wrote:
> In order to support the built-in switch of some MediaTek SoCs we need
> to use MMIO instead of MDIO to access the switch.
> Prepare this be splitting-off the part of the driver registering an
> MDIO driver, so we can add another module acting as MMIO/platform driver.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Hi Daniel

This is getting better.

Please try to split this patch up.  Ideally you want lots of small
patches which are obviously correct. So maybe refactor the creation of
the PCS as a patch. Move p5_intf_modes() as a patch, etc.

Also, look at mt7530_probe() and mt7988_probe() side by side and see
what is common and can be put into one shared function in the
core. Same for remove. It could be that creating that helper is a
patch done before adding mt7530-mdio.c.

      Andrew
