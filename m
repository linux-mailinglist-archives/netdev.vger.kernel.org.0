Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0879242AD1A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 21:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhJLTP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 15:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhJLTP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 15:15:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5D3C061765;
        Tue, 12 Oct 2021 12:13:26 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q5so47375pgr.7;
        Tue, 12 Oct 2021 12:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LWhftMTVyAsSdyLdLH53bG9mvFxsamqOiTeUX4ipYWk=;
        b=NrO9dsQAze4SZBsIpOhMLVETCfo6Ls+KyZu2Oouh5T/SsdN4nh2ATRKVCsXOkxug/X
         e+qtVFM5y6X/fll8gNJJ+eGD+qsWQyBH7TMdpclycO6drdFdhg0GyimRLnQ2CL+niX32
         HX1Mjsn0b83qkyFv4PBjbapwcAw7ct8aXDdhg515vVskf/9oPD+VgrjFPrxdKI3Y5D2r
         F/Acw6lesWzFFx9fhsscE4rn6a5sEVcZ9c4Egv2QJDUcJk9kweqY+pjglHkQWzhRVBaF
         Nd36/h0O7KmOegp5asWCs5unTR35f+xaCb79PoAoy74MCr+UVpIL7vq6StG74Mc3n8Qr
         Nfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LWhftMTVyAsSdyLdLH53bG9mvFxsamqOiTeUX4ipYWk=;
        b=FEoIK76gess2VtukcxNXOynpXzAY5pi0l0iSB3Rs2RzGz2hyOy3eV0xGh8I2vZs+Jc
         dlVCt72+6abG/YlrHENSHFm98lZourZlGUhG6PZKcMR2m3/JpEqBNt7QVFqqVYye4wIm
         MdDeobGW8vQiNRaJ9TDuzp/iW9JvzuarOicmr+ShoPKzFzR13l//Q/iRy86NG3EN7GxK
         xXZDcnaYYnXbdlP64nG5eFK5vtVcTK5nB119ggPIBI/cHwIV6A+evrDLaPe89WDXDvGz
         iZinWkHI4BhXDbbHIi9Gzk1TITFps85HNENGz2bE7gydNfEXOF6SJuyx44HxvP87RMQ2
         U1Cw==
X-Gm-Message-State: AOAM530gmSKqGH2ottT6gGjSwJTxJlJHl2J1vnrayEL0HthTQ+ivWydq
        7To9CYR8xZvr5cn09mrXpSyxy12M8b0=
X-Google-Smtp-Source: ABdhPJzsnYDhwHqckYrxaBHeGiCU23l4gEHiYhgBBihhWwTPAa3XOMpQxy1H7jxOF/oHoFYupxfJfw==
X-Received: by 2002:a63:fe4f:: with SMTP id x15mr23905799pgj.424.1634066005286;
        Tue, 12 Oct 2021 12:13:25 -0700 (PDT)
Received: from [10.69.36.38] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a20sm11508008pfn.136.2021.10.12.12.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 12:13:25 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow
 control
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
 <20210926032114.1785872-5-f.fainelli@gmail.com> <YVCDL9WEATFOIGpH@lunn.ch>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <3db6137d-7679-4ef3-23ab-197070428960@gmail.com>
Date:   Tue, 12 Oct 2021 12:13:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVCDL9WEATFOIGpH@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your review, and sorry for the delayed response (Florian
submitted this while I was on vacation).

You may remember that a while back I submitted a more general patch set
with the goal of improving the implementation of ethernet pause for all
network drivers while maintaining backward compatibility for network
drivers that preferred their current behavior:
https://www.lkml.org/lkml/2020/5/11/1408

I would summarize the previous discussion as follows:
Russell King has kindly documented the known deficiencies with the
current common implementation of ethernet pause support, and believes
that it is necessary to live with them to provide the consistency
necessary for his phylink implementation.

This leaves me in the position of having to choose between consistency
and IEEE standard compliance for the bcmgenet driver that I co-maintain
with Florian Fainelli. Having spent decades of my career focused on
producing IEEE 802 standard compliant implementations it is difficult
for me to accept submitting an implementation of ethernet pause frame
support that I believe does not comply with the IEEE 802.3 standard.

Consistency with other drivers interpretations of ethtool flow control
is not particularly relevant to the users of current systems that make
use of the bcmgenet driver. As a result we have chosen to implement
ethtool flow control for the bcmgenet driver in our downstream kernels
in the manner documented by this patch set, which favors correctness
over consistency.

Florian would like this implementation to be added to the upstream
kernel to benefit other potential users and to ease a minor maintenance
burden for us.

It would probably be useful to include a more complete description of
the behavior of this implementation in the commit message of this fourth
part of the patch, and I can do that in a resubmission if desired.

Here is the description I provided in the email discussion of the
previous submission:
"The Pause and AsymPause bits as defined by the IEEE 802.3 standard are
for the purpose of advertising a capability. While the Tx_Pause and
Rx_Pause parameters of ethtool allow a user to indicate whether the
feature should be used on a link that is capable of the feature.

When pause autonegotiation is enabled the local and peer Pause and
AsymPause bits should be used to negotiate the CAPABILITY of using the
pause feature for each direction. This is not the same as enabling pause
in those directions.

So for the problematic cases:

If you specify Tx_Pause = 0, Rx_Pause = 1 you advertise that the link is
capable of both Symmetric PAUSE and Asymmetric PAUSE toward local device
according to Table 37-2 in IEEE Std 802.3-2018. If the result of link
autonegotiation indicates that both directions are capable of supporting
pause control frames you choose not to send pause control frames because
the user asked you not to by setting Tx_Pause = 0.

If you specify Tx_Pause = 1, Rx_Pause = 1 you advertise that the link is
capable of both Symmetric PAUSE and Asymmetric PAUSE toward local device
according to Table 37-2 in IEEE Std 802.3-2018. If the far end supports
only AsymPause, then the link autonegotiation will indicate that only
the receive direction is capable of supporting the pause feature and you
should not send pause control frames to the peer even though the user
has set Tx_Pause = 1.

If link autonegotiation is disabled, then the capability of the link to
support pause frames cannot be negotiated and therefore pause control
frames should not be used.

When pause autonegotiation is disabled the local peer does not care what
its peer is capable of and it can choose to send and process pause
control frames based entirely, on the users requested Tx_Pause and
Rx_Pause parameters. However, if link autonegotiation is enabled it
might as well not be rude and should advertise its intended usage."

Responses to feedback below.

On 9/26/2021 7:26 AM, Andrew Lunn wrote:
> On Sat, Sep 25, 2021 at 08:21:14PM -0700, Florian Fainelli wrote:
>> From: Doug Berger <opendmb@gmail.com>
>>
>> This commit extends the supported ethtool operations to allow MAC
>> level flow control to be configured for the bcmgenet driver.
>>
>> The ethtool utility can be used to change the configuration of
>> auto-negotiated symmetric and asymmetric modes as well as manually
>> configuring support for RX and TX Pause frames individually.
>>
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  .../net/ethernet/broadcom/genet/bcmgenet.c    | 51 +++++++++++++++++++
>>  .../net/ethernet/broadcom/genet/bcmgenet.h    |  4 ++
>>  drivers/net/ethernet/broadcom/genet/bcmmii.c  | 44 +++++++++++++---
>>  3 files changed, 92 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index 3427f9ed7eb9..6a8234bc9428 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -935,6 +935,48 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
>>  	return 0;
>>  }
>>  
>> +static void bcmgenet_get_pauseparam(struct net_device *dev,
>> +				    struct ethtool_pauseparam *epause)
>> +{
>> +	struct bcmgenet_priv *priv;
>> +	u32 umac_cmd;
>> +
>> +	priv = netdev_priv(dev);
>> +
>> +	epause->autoneg = priv->autoneg_pause;
>> +
>> +	if (netif_carrier_ok(dev)) {
>> +		/* report active state when link is up */
>> +		umac_cmd = bcmgenet_umac_readl(priv, UMAC_CMD);
>> +		epause->tx_pause = !(umac_cmd & CMD_TX_PAUSE_IGNORE);
>> +		epause->rx_pause = !(umac_cmd & CMD_RX_PAUSE_IGNORE);
>> +	} else {
>> +		/* otherwise report stored settings */
>> +		epause->tx_pause = priv->tx_pause;
>> +		epause->rx_pause = priv->rx_pause;
>> +	}
>> +}
>> +
>> +static int bcmgenet_set_pauseparam(struct net_device *dev,
>> +				   struct ethtool_pauseparam *epause)
>> +{
>> +	struct bcmgenet_priv *priv = netdev_priv(dev);
>> +
>> +	if (!dev->phydev)
>> +		return -ENODEV;
>> +
>> +	if (!phy_validate_pause(dev->phydev, epause))
>> +		return -EINVAL;
>> +
>> +	priv->autoneg_pause = !!epause->autoneg;
>> +	priv->tx_pause = !!epause->tx_pause;
>> +	priv->rx_pause = !!epause->rx_pause;
>> +
>> +	bcmgenet_phy_pause_set(dev, priv->rx_pause, priv->tx_pause);
> 
> I don't think this is correct. If epause->autoneg is false, you
> probably want to pass false, false here, so that the PHY will not
> announce any modes. And then call bcmgenet_mac_config() to set the
> manual pause bits. But watch out that you don't hold the PHY lock, so
> you should not access any phydev members.
As noted above, it is my belief that when epause->autoneg is false it is
more polite for the local node to advertise the mode it will be using
even if it doesn't respect its peer's advertised capability. This at
least gives the peer the opportunity to negotiate its pause behavior if
it happens to be running Linux and its epause->autoneg is true.

I also do hold the PHY lock within bcmgenet_phy_pause_set() below.

> 
>> +	} else {
>> +		/* pause capability defaults to Symmetric */
>> +		if (priv->autoneg_pause) {
>> +			bool tx_pause = 0, rx_pause = 0;
>> +
>> +			if (phydev->autoneg)
>> +				phy_get_pause(phydev, &tx_pause, &rx_pause);
>>  
>> -	/* pause capability */
>> -	if (!phydev->pause)
>> -		cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
>> +			if (!tx_pause)
>> +				cmd_bits |= CMD_TX_PAUSE_IGNORE;
>> +			if (!rx_pause)
>> +				cmd_bits |= CMD_RX_PAUSE_IGNORE;
>> +		}
> 
> Looks like there should be an else here?
It may look like that is the case, but it is not necessary. The cmd_bits
are initialized to enable tx and rx (as the comment is intended to
clarify). If autoneg_pause is true then the negotiation will disable
pause where the capability does not exist. Regardless of autoneg_pause
if the user does not want to use pause it should not be enabled.

> 
>> +
>> +		/* Manual override */
>> +		if (!priv->rx_pause)
>> +			cmd_bits |= CMD_RX_PAUSE_IGNORE;
>> +		if (!priv->tx_pause)
>> +			cmd_bits |= CMD_TX_PAUSE_IGNORE;
>> +	}
>>  
>>  	/* Program UMAC and RGMII block based on established
>>  	 * link speed, duplex, and pause. The speed set in
>> @@ -101,6 +118,21 @@ static int bcmgenet_fixed_phy_link_update(struct net_device *dev,
>>  	return 0;
>>  }
>>  
>> +void bcmgenet_phy_pause_set(struct net_device *dev, bool rx, bool tx)
>> +{
>> +	struct phy_device *phydev = dev->phydev;
>> +
>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising, rx);
>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising,
>> +			 rx | tx);
>> +	phy_start_aneg(phydev);
>> +
>> +	mutex_lock(&phydev->lock);
>> +	if (phydev->link)
>> +		bcmgenet_mac_config(dev);
>> +	mutex_unlock(&phydev->lock);
> 
> It is a bit oddly named, but phy_set_asym_pause() does this, minus the
> lock. Please use that, rather than open coding this.
This is, in fact, the crux of the matter. It is subtle, but
phy_set_asym_pause() does NOT do this. phy_set_asym_pause() uses an
EXCLUSIVE OR of rx and tx to set Asym_Pause which leads to incorrect
advertisement of capability. That is why this code needs to use an
INCLUSIVE OR of rx and tx to comply with the IEEE standard.

> 
> Locking is something i'm looking at now. I'm trying to go through all
> the phylib calls the MAC use and checking if locks need to be added.
> 
>     Andrew
> 

Thanks again for your time (and patience ;),
    Doug
