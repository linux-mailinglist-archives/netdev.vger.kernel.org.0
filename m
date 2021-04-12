Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F202335BA70
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhDLG5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:57:32 -0400
Received: from mx.i2x.nl ([5.2.79.48]:42388 "EHLO mx.i2x.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhDLG5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 02:57:31 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id BC68F5FB39;
        Mon, 12 Apr 2021 08:57:10 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="BXQxPyhD";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 77118BC9FEE;
        Mon, 12 Apr 2021 08:57:10 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 77118BC9FEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1618210630;
        bh=qdbtM/DvTGQNCLjIn3AIhiOwyFmkZ6jhIqw4Qg8DRuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BXQxPyhDS9m7NBLFQYXfxTe5/Ef18Jmqr2NBuq/RKrNTUDN1gt9RsrjEYnB8t6Jp2
         fAvUnDeOKjGxIgyIwOFON+WErgcbX3XF8A4Qy76yKXV1pzDVCS+obfsqxCTtkz0plf
         N+34eRzvAnueCw7qwuVBPN+QAdj2qdw3eQerT4sF0loCCx2zzPQJW3kvzMXLfWl0vZ
         tNuK2Dli4JsSYL+pNNx0c97UqjP86sbvTCAjPK4eyvCpzXyPcWyM1qTEAlTOPe0JSM
         tKmFT/DuZINGWbSc+VpNoWP7mWpAlrFGrPpp6fTRdTGpoyMLL1gKd0w6gJphOFuDe7
         O0jMm9z1mTdWw==
Received: from 48.79.2.5.in-addr.arpa (48.79.2.5.in-addr.arpa [5.2.79.48])
 by www.vdorst.com (Horde Framework) with HTTPS; Mon, 12 Apr 2021 06:57:10
 +0000
Date:   Mon, 12 Apr 2021 06:57:10 +0000
Message-ID: <20210412065710.Horde.HvZraNbocBxpaaNQLf6FJkk@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next] net: dsa: mt7530: Add support for EEE features
References: <20210409225346.432312-1-opensource@vdorst.com>
 <CALW65jZRs4DBOpWiY+CxWZmX9wXhSP1cM-qeftC=xY2=Tr+HoA@mail.gmail.com>
In-Reply-To: <CALW65jZRs4DBOpWiY+CxWZmX9wXhSP1cM-qeftC=xY2=Tr+HoA@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting DENG Qingfang <dqfext@gmail.com>:

Hi Qingfang,

Thanks for the review.

> Hi René,
>
> On Sat, Apr 10, 2021 at 6:54 AM René van Dorst <opensource@vdorst.com> wrote:
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2568,6 +2568,11 @@ static void  
>> mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
>>                         mcr |= PMCR_TX_FC_EN;
>>                 if (rx_pause)
>>                         mcr |= PMCR_RX_FC_EN;
>> +
>> +               if (mode == MLO_AN_PHY && phydev &&
>> +                   !(priv->eee_disabled & BIT(port)) &&
>> +                   phy_init_eee(phydev, 0) >= 0)
>> +                       mcr |= PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100;
>
> You should adjust this according to e->advertised.

I now better understand EEE part in phylink.
I refactor the code a lot and also tested with different
port with various eee-broken-1000t and eee-broken-100tx set
in the device tree.

Looking at mcr value, in all the cases the bit are set right.

>
>>         }
>>
>>         mt7530_set(priv, MT7530_PMCR_P(port), mcr);
>> @@ -2800,6 +2805,49 @@ mt753x_phy_write(struct dsa_switch *ds, int  
>> port, int regnum, u16 val)
>>         return priv->info->phy_write(ds, port, regnum, val);
>>  }
>>
>> +static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
>> +                             struct ethtool_eee *e)
>> +{
>> +       struct mt7530_priv *priv = ds->priv;
>> +       u32 eeecr, pmsr;
>> +
>> +       e->eee_enabled = !(priv->eee_disabled & BIT(port));
>> +
>> +       if (e->eee_enabled) {
>> +               eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
>> +               e->tx_lpi_enabled = !(eeecr & LPI_MODE_EN);
>> +               e->tx_lpi_timer = GET_LPI_THRESH(eeecr);
>> +               pmsr = mt7530_read(priv, MT7530_PMSR_P(port));
>> +               e->eee_active = e->eee_enabled && !!(pmsr & PMSR_EEE1G);
>
> eee_enabled and eee_active will be set in phy_ethtool_get_eee, no need
> to set them here.

Thanks for pointing that out.
I refactor the code so it only set/report the LPI settings.

I already sended v2 with these changes.

>
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
>> +                             struct ethtool_eee *e)
>> +{
>> +       struct mt7530_priv *priv = ds->priv;
>> +       u32 eeecr;
>> +
>> +       if (e->eee_enabled) {
>> +               if (e->tx_lpi_timer > 0xFFF)
>> +                       return -EINVAL;
>> +               priv->eee_disabled &= ~BIT(port);
>> +               eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
>> +               eeecr &= ~(LPI_THRESH_MASK | LPI_MODE_EN);
>> +               if (!e->tx_lpi_enabled)
>> +                       /* Force LPI Mode without a delay */
>> +                       eeecr |= LPI_MODE_EN;
>> +               eeecr |= SET_LPI_THRESH(e->tx_lpi_timer);
>> +               mt7530_write(priv, MT7530_PMEEECR_P(port), eeecr);
>> +       } else {
>> +               priv->eee_disabled |= BIT(port);
>> +       }
>> +
>> +       return 0;
>> +}


Greats,

René

