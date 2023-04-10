Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4236DC7EE
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDJOhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDJOha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:37:30 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919B855A1;
        Mon, 10 Apr 2023 07:37:25 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1plsdn-0007c2-2F;
        Mon, 10 Apr 2023 16:37:07 +0200
Date:   Mon, 10 Apr 2023 15:37:04 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH v2 net-next 13/14] net: dsa: mt7530: fix port
 capabilities for MT7988
Message-ID: <ZDQfEAY8UWI6tgrY@makrotopia.org>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-14-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230407134626.47928-14-arinc.unal@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:46:25PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> On the switch on the MT7988 SoC, there are only 4 PHYs. That's port 0 to 3.
> Set the internal phy cases to '0 ... 3'.
> 
> There's no need to clear the config->supported_interfaces bitmap before
> reporting the supported interfaces as all bits in the bitmap will already
> be initialized to zero when the phylink_config structure is allocated.
> There's no code that would change the bitmap beforehand. Remove it.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
>  drivers/net/dsa/mt7530.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 6fbbdcb5987f..903e39b7b772 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2545,10 +2545,8 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
>  				     struct phylink_config *config)
>  {
> -	phy_interface_zero(config->supported_interfaces);
> -
>  	switch (port) {
> -	case 0 ... 4: /* Internal phy */
> +	case 0 ... 3: /* Internal phy */
>  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>  			  config->supported_interfaces);
>  		break;
> -- 
> 2.37.2
> 
