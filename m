Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEDF6E8659
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjDTAWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjDTAWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:22:32 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460403A82;
        Wed, 19 Apr 2023 17:22:31 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppI47-0006PU-1Z;
        Thu, 20 Apr 2023 02:22:23 +0200
Date:   Thu, 20 Apr 2023 01:22:20 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: fix support for MT7531BE
Message-ID: <ZECFvFnhW1D3IRxO@makrotopia.org>
References: <ZDvlLhhqheobUvOK@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDvlLhhqheobUvOK@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 01:08:14PM +0100, Daniel Golle wrote:
> There are two variants of the MT7531 switch IC which got different
> features (and pins) regarding port 5:
>  * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes PCS
>  * MT7531BE: RGMII
> 
> Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
> with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation
> to mt7530_probe function") works fine for MT7531AE which got two
> instances of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup
> to setup clocks before the single PCS on port 6 (usually used as CPU
> port) starts to work and hence the PCS creation failed on MT7531BE.
> 
> Fix this by introducing a pointer to mt7531_create_sgmii function in
> struct mt7530_priv and call it again at the end of mt753x_setup like it
> was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
> creation to mt7530_probe function").
> 
> Fixes: 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---

This v2 submission addresses the comments made by Jesse Brandeburg
regarding zero-initializing regmap_config as we are now not necessarily
using both of them. Comments by Arınç ÜNAL have also been discussed
and resulting in receiving Ack.

However, I can see in patchwork that the patch has been set to
"Changes Requested".

Can someone please tell me which further changes are needed?
I don't see any other comments on the mailing list or patchwork.

Thank you!


Daniel
