Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2716A782F
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 01:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjCBAD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 19:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCBAD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 19:03:58 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E2E2128;
        Wed,  1 Mar 2023 16:03:56 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pXWQH-0000kl-0o;
        Thu, 02 Mar 2023 01:03:49 +0100
Date:   Thu, 2 Mar 2023 00:03:45 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [RFC PATCH v11 08/12] net: ethernet: mtk_eth_soc: fix RX data
 corruption issue
Message-ID: <Y//n4R2QuWvySDbg@makrotopia.org>
References: <cover.1677699407.git.daniel@makrotopia.org>
 <9a788bb6984c836e63a7ecbdadff11a723769c37.1677699407.git.daniel@makrotopia.org>
 <20230301233121.trnzgverxndxgunu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230301233121.trnzgverxndxgunu@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 01:31:21AM +0200, Vladimir Oltean wrote:
> On Wed, Mar 01, 2023 at 07:55:05PM +0000, Daniel Golle wrote:
> > Also set bit 12 which disabled the RX FIDO clear function when setting up
> > MAC MCR, as MediaTek SDK did the same change stating:
> > "If without this patch, kernel might receive invalid packets that are
> > corrupted by GMAC."[1]
> > This fixes issues with <= 1G speed where we could previously observe
> > about 30% packet loss while the bad packet counter was increasing.
> > 
> > [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/d8a2975939a12686c4a95c40db21efdc3f821f63
> > Tested-by: Bjørn Mork <bjorn@mork.no>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> 
> Should this patch be submitted separately from the series, to the
> net.git tree, to be backported to stable kernels?

Maybe yes, as this issue may affect e.g. the BPi-R3 board when used
with 1G SFP modules. Previously this has just never been a problem as
all practically all boards with MediaTek SoCs using SGMII also use the
MediaTek MT7531 switch connecting in 2500Base-X mode.

Should the Fixes:-tag hence reference the commit adding support for the
BPi-R3?
