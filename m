Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1E324AA06
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHSXym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:54:42 -0400
Received: from mx.0dd.nl ([5.2.79.48]:54730 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgHSXyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 19:54:40 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2020 19:54:38 EDT
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 622575FB19;
        Thu, 20 Aug 2020 01:46:13 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="qGHOkhBi";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 1AE02687EC9;
        Thu, 20 Aug 2020 01:46:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 1AE02687EC9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1597880773;
        bh=yV6u6+GKP89ZhLaPI4Lclma8HJH4chY3sZJwJgORk04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qGHOkhBi2BTnqCwqZeHEocVi0xr7Hlg1vEMcqqjBkt7QaRBDN87wOOJsh+wstepJc
         BLBrC0D257eGFvdyNvkLXFw7tnEgF9TlxcWZNKHcWzxamHDQkgWmFMvNev3biAagL+
         obPPQiN1S161exlA+7gLw44fgJ1tA3e1wannKNZUl+omiK78VI73vMbmpdKL2JCf8M
         jEg9PcmXnsGis7G4+BRnCdGye6An3tITSzJohT4BePTEVfdsqqsu5769Kx/vFCx4xM
         KUMF64MUQNhaVummXc5au5TALXk37O4RdLEY22WLMnjDgzkX7ww7Je19UbkJ2njkTf
         dYy2Z1eIRviMQ==
Received: from pc-rene.lan.vdorst.com (pc-rene.lan.vdorst.com
 [192.168.2.14]) by www.vdorst.com (Horde Framework) with HTTPS; Wed, 19 Aug
 2020 23:46:13 +0000
Date:   Wed, 19 Aug 2020 23:46:13 +0000
Message-ID: <20200819234613.Horde.oQiJhMCnUINwnQP-5_MyHh-@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, Sean Wang <Sean.Wang@mediatek.com>,
        frank-w@public-files.de, dqfext@gmail.com
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mt7530: Add the support of
 MT7531 switch
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <e980fda45e0fb478f55e72765643bb641f352c65.1597729692.git.landen.chao@mediatek.com>
 <20200818160901.GF2330298@lunn.ch> <1597830248.31846.78.camel@mtksdccf07>
In-Reply-To: <1597830248.31846.78.camel@mtksdccf07>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Landen Chao <landen.chao@mediatek.com>:

> On Wed, 2020-08-19 at 00:09 +0800, Andrew Lunn wrote:
>> On Tue, Aug 18, 2020 at 03:14:10PM +0800, Landen Chao wrote:
>> > Add new support for MT7531:
>> >
>> > MT7531 is the next generation of MT7530. It is also a 7-ports switch with
>> > 5 giga embedded phys, 2 cpu ports, and the same MAC logic of MT7530. Cpu
>> > port 6 only supports SGMII interface. Cpu port 5 supports either RGMII
>> > or SGMII in different HW sku. Due to SGMII interface support, pll, and
>> > pad setting are different from MT7530. This patch adds different initial
>> > setting, and SGMII phylink handlers of MT7531.
>> >
>> > MT7531 SGMII interface can be configured in following mode:
>> > - 'SGMII AN mode' with in-band negotiation capability
>> >     which is compatible with PHY_INTERFACE_MODE_SGMII.
>> > - 'SGMII force mode' without in-bnad negotiation
>>
>> band
> Sorry, I'll fix it.
>>
>> >     which is compatible with 10B/8B encoding of
>> >     PHY_INTERFACE_MODE_1000BASEX with fixed full-duplex and fixed pause.
>> > - 2.5 times faster clocked 'SGMII force mode' without in-bnad negotiation
>>
>> band
> Sorry, I'll fix it.
>>
>> > +static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
>> > +			      phy_interface_t interface)
>> > +{
>> > +	u32 val;
>> > +
>> > +	if (!mt7531_is_rgmii_port(priv, port)) {
>> > +		dev_err(priv->dev, "RGMII mode is not available for port %d\n",
>> > +			port);
>> > +		return -EINVAL;
>> > +	}
>> > +
>> > +	val = mt7530_read(priv, MT7531_CLKGEN_CTRL);
>> > +	val |= GP_CLK_EN;
>> > +	val &= ~GP_MODE_MASK;
>> > +	val |= GP_MODE(MT7531_GP_MODE_RGMII);
>> > +	val &= ~(TXCLK_NO_REVERSE | RXCLK_NO_DELAY);
>> > +	switch (interface) {
>> > +	case PHY_INTERFACE_MODE_RGMII:
>> > +		val |= TXCLK_NO_REVERSE;
>> > +		val |= RXCLK_NO_DELAY;
>> > +		break;
>> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
>> > +		val |= TXCLK_NO_REVERSE;
>> > +		break;
>> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> > +		val |= RXCLK_NO_DELAY;
>> > +		break;
>> > +	case PHY_INTERFACE_MODE_RGMII_ID:
>> > +		break;
>> > +	default:
>> > +		return -EINVAL;
>> > +	}
>>
>> You need to be careful here. If the MAC is doing the RGMII delays, you
>> need to ensure the PHY is not. What interface mode is passed to the
>> PHY?
> Hi Andrew,
>
> mt7531 RGMII port is a MAC-only port, it can be connected to CPU MAC or
> external phy. In bpi-r64 board, mt7531 RGMII is connected to CPU MAC, so
> I tend to implement RGMII logic for use case of bpi-r64.
>
> In general, according to phy.rst, RGMII delay should be done by phy, but
> some MoCA product need RGMII delay in MAC. These two requirements
> conflict. Is there any suggestion to solve the conflict?
>
> If mt7531 RGMII implementation needs to satisfy either phy.rst or
> special MoCA product, I would like to satisfy phy.rst and remove MAC
> RGMII delay in v3. For special product needs MAC RGMII delay, this patch
> can be used in its local codebase.

Hi Landen,

With the current mainline code [1], the dsa code tries to detect how the MAC5
is used. All the three modes are supported. MAC5 -> PHY0, MAC5 ->  
PHY4, MAC5 ->
EXTERNAL PHY and MAC5 to external MAC.

When MAC5 is a DSA port it skips settings the delay settings. See [2].

Maybe you can use a similar concept.

Greats,

René


[1]  
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n1303
[2]  
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n598

>
> Landen
>>
>> 	Andrew



