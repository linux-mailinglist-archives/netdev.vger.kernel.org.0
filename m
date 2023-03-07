Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A626AE284
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCGOcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCGOcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:32:00 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39CA8A53
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 06:27:40 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZYHT-00012B-1d;
        Tue, 07 Mar 2023 15:27:07 +0100
Date:   Tue, 7 Mar 2023 14:27:02 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <ZAdJtvKe1txMjp3f@makrotopia.org>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
 <ZAcnjXxLfeE9UIsO@shell.armlinux.org.uk>
 <ZAc7Q4VMzLjzQbRC@makrotopia.org>
 <ZAdEi2TsIw8Vjsh8@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAdEi2TsIw8Vjsh8@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 02:04:59PM +0000, Russell King (Oracle) wrote:
> On Tue, Mar 07, 2023 at 01:25:23PM +0000, Daniel Golle wrote:
> > A quick grep through the device trees of the more than 650 ramips and
> > mediatek boards we support in OpenWrt has revealed that *none* of them
> > uses either reduced-MII or reverse-MII PHY modes. I could imaging that
> > some more specialized ramips boards may use the RMII 100M PHY mode to
> > connect with exotic PHYs for industrial or automotive applications
> > (think: for 100BASE-T1 PHY connected via RMII). I have never seen or
> > touched such boards, but there are hints that they do exist.
> > 
> > For reverse-MII there are cases in which the Ralink SoC (Rt305x, for
> > example) is used in iNIC mode, ie. connected as a PHY to another SoC,
> > and running only a minimal firmware rather than running Linux. Due to
> > the lack of external DRAM for the Ralink SoC on this kind of boards,
> > the Ralink SoC there will anyway never be able to boot Linux.
> > I've seen this e.g. in multimedia devices like early WiFi-connected
> > not-yet-so-smart TVs.
> > 
> > Tl;dr: I'd drop them. If anyone really needs them, it would be easy to
> > add them again and then also add them to the phylink capability mask.
> 
> Thanks! That seems to be well reasoned. Would you have any objection to
> using the above as part of the commit message removing these modes?

Sure, go ahead, sounds good to me.
