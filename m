Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080BB439D3D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhJYRSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhJYRSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:18:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC25C061745;
        Mon, 25 Oct 2021 10:16:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so552438pjb.4;
        Mon, 25 Oct 2021 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qUhHp4IxX+yuhN9/umi+KWaWfY9CGHebSRNLA8B9hRU=;
        b=ZfHw1p6QTh9eSvoTQiQ8nvFljiNitjsEeF4Pp0cw3Js1N9rQcx0u4Zwy3MZIX1fr24
         1pWxsLvAooRmhJV05PaUmxVJfLiSTtq5vc2Dg6sRPmnIG0a+WIFZhEHFuVO2aT7zitlC
         BcEb2fLLCrWJcuumKf8IxRXUJjn2QqMkNxkGI8KQZfqAng2Wk/OR8WQR7gUY3cQQxsh0
         wckVWc3fx3DEmg2YgtltX2fyT36767lL9F+kUdjzbm8LotH23i0mbEBoyCLFJNt5ws0/
         K1xw9Oz4UFaZ5mDmFyeqLKpqPMeyKgDxpQE9E6zOKaJE+PKXdFwk0380YEAsqwijRH/p
         gAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qUhHp4IxX+yuhN9/umi+KWaWfY9CGHebSRNLA8B9hRU=;
        b=ICZ5tTv45gGKb/EkkHrLEwb7cJEiuE5li4jVSjW4Yh/B9LHNydcfCTzMzbf8QVmdxp
         3a1M2dgT1eOY7oA7+5SOVY2cp8BSg3VpEdGIGtNjyznAnWo6NJN62qin++Md4fXoT3bc
         kCoaQnYwJOXokwpmYyN1YPgme+he4XW//LznE9TcGFtINGqBsrkApB6F0dPjAgCxCxma
         HqaMkQ2Wp3NZDANTOjix8C8ULvwL7Cq1u3HnVKH1FSx28Ul3hYrInYwr5YNWJ8HBW8Gp
         gcrhCW6qIam/gM6WC22R2m1dslY4Q3lLDwWYTjAeUxNH6/DpMtZZlVmMkQLglEizkoyg
         E8Rg==
X-Gm-Message-State: AOAM531BP/YhSGi9ypXRMLYqV85Arxs0I95drlgim4ah8SAuHaNV/agd
        EtcZhdgbEAx7a/iY4VMQewK5TUXba6s=
X-Google-Smtp-Source: ABdhPJzOfp9lYp3IOU9p8ebqT3hSjBiJpuLQIvHP07Q+96jRONwRwZLSdFg/UY7u4qPA9KqPUMHUug==
X-Received: by 2002:a17:90a:9418:: with SMTP id r24mr21958931pjo.238.1635182159408;
        Mon, 25 Oct 2021 10:15:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z15sm8190392pga.16.2021.10.25.10.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 10:15:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow
 control
To:     Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
 <20210926032114.1785872-5-f.fainelli@gmail.com> <YVCDL9WEATFOIGpH@lunn.ch>
 <3db6137d-7679-4ef3-23ab-197070428960@gmail.com>
Message-ID: <abb79236-9424-acad-a5b2-c6f415f127da@gmail.com>
Date:   Mon, 25 Oct 2021 10:15:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3db6137d-7679-4ef3-23ab-197070428960@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, and Doug,

On 10/12/21 12:13 PM, Doug Berger wrote:
> Thank you for your review, and sorry for the delayed response (Florian
> submitted this while I was on vacation).
> 
> You may remember that a while back I submitted a more general patch set
> with the goal of improving the implementation of ethernet pause for all
> network drivers while maintaining backward compatibility for network
> drivers that preferred their current behavior:
> https://www.lkml.org/lkml/2020/5/11/1408
> 
> I would summarize the previous discussion as follows:
> Russell King has kindly documented the known deficiencies with the
> current common implementation of ethernet pause support, and believes
> that it is necessary to live with them to provide the consistency
> necessary for his phylink implementation.
> 
> This leaves me in the position of having to choose between consistency
> and IEEE standard compliance for the bcmgenet driver that I co-maintain
> with Florian Fainelli. Having spent decades of my career focused on
> producing IEEE 802 standard compliant implementations it is difficult
> for me to accept submitting an implementation of ethernet pause frame
> support that I believe does not comply with the IEEE 802.3 standard.
> 
> Consistency with other drivers interpretations of ethtool flow control
> is not particularly relevant to the users of current systems that make
> use of the bcmgenet driver. As a result we have chosen to implement
> ethtool flow control for the bcmgenet driver in our downstream kernels
> in the manner documented by this patch set, which favors correctness
> over consistency.
> 
> Florian would like this implementation to be added to the upstream
> kernel to benefit other potential users and to ease a minor maintenance
> burden for us.
> 
> It would probably be useful to include a more complete description of
> the behavior of this implementation in the commit message of this fourth
> part of the patch, and I can do that in a resubmission if desired.
> 
> Here is the description I provided in the email discussion of the
> previous submission:
> "The Pause and AsymPause bits as defined by the IEEE 802.3 standard are
> for the purpose of advertising a capability. While the Tx_Pause and
> Rx_Pause parameters of ethtool allow a user to indicate whether the
> feature should be used on a link that is capable of the feature.
> 
> When pause autonegotiation is enabled the local and peer Pause and
> AsymPause bits should be used to negotiate the CAPABILITY of using the
> pause feature for each direction. This is not the same as enabling pause
> in those directions.
> 
> So for the problematic cases:
> 
> If you specify Tx_Pause = 0, Rx_Pause = 1 you advertise that the link is
> capable of both Symmetric PAUSE and Asymmetric PAUSE toward local device
> according to Table 37-2 in IEEE Std 802.3-2018. If the result of link
> autonegotiation indicates that both directions are capable of supporting
> pause control frames you choose not to send pause control frames because
> the user asked you not to by setting Tx_Pause = 0.
> 
> If you specify Tx_Pause = 1, Rx_Pause = 1 you advertise that the link is
> capable of both Symmetric PAUSE and Asymmetric PAUSE toward local device
> according to Table 37-2 in IEEE Std 802.3-2018. If the far end supports
> only AsymPause, then the link autonegotiation will indicate that only
> the receive direction is capable of supporting the pause feature and you
> should not send pause control frames to the peer even though the user
> has set Tx_Pause = 1.
> 
> If link autonegotiation is disabled, then the capability of the link to
> support pause frames cannot be negotiated and therefore pause control
> frames should not be used.
> 
> When pause autonegotiation is disabled the local peer does not care what
> its peer is capable of and it can choose to send and process pause
> control frames based entirely, on the users requested Tx_Pause and
> Rx_Pause parameters. However, if link autonegotiation is enabled it
> might as well not be rude and should advertise its intended usage."
> 
> Responses to feedback below.
> 
> On 9/26/2021 7:26 AM, Andrew Lunn wrote:
>> On Sat, Sep 25, 2021 at 08:21:14PM -0700, Florian Fainelli wrote:
>>> From: Doug Berger <opendmb@gmail.com>
>>>
>>> This commit extends the supported ethtool operations to allow MAC
>>> level flow control to be configured for the bcmgenet driver.
>>>
>>> The ethtool utility can be used to change the configuration of
>>> auto-negotiated symmetric and asymmetric modes as well as manually
>>> configuring support for RX and TX Pause frames individually.
>>>
>>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>  .../net/ethernet/broadcom/genet/bcmgenet.c    | 51 +++++++++++++++++++
>>>  .../net/ethernet/broadcom/genet/bcmgenet.h    |  4 ++
>>>  drivers/net/ethernet/broadcom/genet/bcmmii.c  | 44 +++++++++++++---
>>>  3 files changed, 92 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>> index 3427f9ed7eb9..6a8234bc9428 100644
>>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>> @@ -935,6 +935,48 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
>>>  	return 0;
>>>  }
>>>  
>>> +static void bcmgenet_get_pauseparam(struct net_device *dev,
>>> +				    struct ethtool_pauseparam *epause)
>>> +{
>>> +	struct bcmgenet_priv *priv;
>>> +	u32 umac_cmd;
>>> +
>>> +	priv = netdev_priv(dev);
>>> +
>>> +	epause->autoneg = priv->autoneg_pause;
>>> +
>>> +	if (netif_carrier_ok(dev)) {
>>> +		/* report active state when link is up */
>>> +		umac_cmd = bcmgenet_umac_readl(priv, UMAC_CMD);
>>> +		epause->tx_pause = !(umac_cmd & CMD_TX_PAUSE_IGNORE);
>>> +		epause->rx_pause = !(umac_cmd & CMD_RX_PAUSE_IGNORE);
>>> +	} else {
>>> +		/* otherwise report stored settings */
>>> +		epause->tx_pause = priv->tx_pause;
>>> +		epause->rx_pause = priv->rx_pause;
>>> +	}
>>> +}
>>> +
>>> +static int bcmgenet_set_pauseparam(struct net_device *dev,
>>> +				   struct ethtool_pauseparam *epause)
>>> +{
>>> +	struct bcmgenet_priv *priv = netdev_priv(dev);
>>> +
>>> +	if (!dev->phydev)
>>> +		return -ENODEV;
>>> +
>>> +	if (!phy_validate_pause(dev->phydev, epause))
>>> +		return -EINVAL;
>>> +
>>> +	priv->autoneg_pause = !!epause->autoneg;
>>> +	priv->tx_pause = !!epause->tx_pause;
>>> +	priv->rx_pause = !!epause->rx_pause;
>>> +
>>> +	bcmgenet_phy_pause_set(dev, priv->rx_pause, priv->tx_pause);
>>
>> I don't think this is correct. If epause->autoneg is false, you
>> probably want to pass false, false here, so that the PHY will not
>> announce any modes. And then call bcmgenet_mac_config() to set the
>> manual pause bits. But watch out that you don't hold the PHY lock, so
>> you should not access any phydev members.
> As noted above, it is my belief that when epause->autoneg is false it is
> more polite for the local node to advertise the mode it will be using
> even if it doesn't respect its peer's advertised capability. This at
> least gives the peer the opportunity to negotiate its pause behavior if
> it happens to be running Linux and its epause->autoneg is true.
> 
> I also do hold the PHY lock within bcmgenet_phy_pause_set() below.
> 
>>
>>> +	} else {
>>> +		/* pause capability defaults to Symmetric */
>>> +		if (priv->autoneg_pause) {
>>> +			bool tx_pause = 0, rx_pause = 0;
>>> +
>>> +			if (phydev->autoneg)
>>> +				phy_get_pause(phydev, &tx_pause, &rx_pause);
>>>  
>>> -	/* pause capability */
>>> -	if (!phydev->pause)
>>> -		cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
>>> +			if (!tx_pause)
>>> +				cmd_bits |= CMD_TX_PAUSE_IGNORE;
>>> +			if (!rx_pause)
>>> +				cmd_bits |= CMD_RX_PAUSE_IGNORE;
>>> +		}
>>
>> Looks like there should be an else here?
> It may look like that is the case, but it is not necessary. The cmd_bits
> are initialized to enable tx and rx (as the comment is intended to
> clarify). If autoneg_pause is true then the negotiation will disable
> pause where the capability does not exist. Regardless of autoneg_pause
> if the user does not want to use pause it should not be enabled.

Maybe a comment should be in place to prevent a drive by reviewer from
thinking that there should be an else being placed here?

> 
>>
>>> +
>>> +		/* Manual override */
>>> +		if (!priv->rx_pause)
>>> +			cmd_bits |= CMD_RX_PAUSE_IGNORE;
>>> +		if (!priv->tx_pause)
>>> +			cmd_bits |= CMD_TX_PAUSE_IGNORE;
>>> +	}
>>>  
>>>  	/* Program UMAC and RGMII block based on established
>>>  	 * link speed, duplex, and pause. The speed set in
>>> @@ -101,6 +118,21 @@ static int bcmgenet_fixed_phy_link_update(struct net_device *dev,
>>>  	return 0;
>>>  }
>>>  
>>> +void bcmgenet_phy_pause_set(struct net_device *dev, bool rx, bool tx)
>>> +{
>>> +	struct phy_device *phydev = dev->phydev;
>>> +
>>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising, rx);
>>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising,
>>> +			 rx | tx);
>>> +	phy_start_aneg(phydev);
>>> +
>>> +	mutex_lock(&phydev->lock);
>>> +	if (phydev->link)
>>> +		bcmgenet_mac_config(dev);
>>> +	mutex_unlock(&phydev->lock);
>>
>> It is a bit oddly named, but phy_set_asym_pause() does this, minus the
>> lock. Please use that, rather than open coding this.
> This is, in fact, the crux of the matter. It is subtle, but
> phy_set_asym_pause() does NOT do this. phy_set_asym_pause() uses an
> EXCLUSIVE OR of rx and tx to set Asym_Pause which leads to incorrect
> advertisement of capability. That is why this code needs to use an
> INCLUSIVE OR of rx and tx to comply with the IEEE standard.

Would it be worthwhile introducing something like this then (not compile
tested, comments not updated):

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f1db6699f81f..3465db9a5769 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3114,7 +3114,7 @@ static void hclge_update_pause_advertising(struct
hclge_dev *hdev)
 		break;
 	}

-	linkmode_set_pause(mac->advertising, tx_en, rx_en);
+	linkmode_set_pause(mac->advertising, tx_en, rx_en, false);
 }

 static void hclge_update_advertising(struct hclge_dev *hdev)
diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
index f60560fe3499..96582eb65ca0 100644
--- a/drivers/net/phy/linkmode.c
+++ b/drivers/net/phy/linkmode.c
@@ -48,6 +48,7 @@ EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
  * @advertisement: advertisement in ethtool format
  * @tx: boolean from ethtool struct ethtool_pauseparam tx_pause member
  * @rx: boolean from ethtool struct ethtool_pauseparam rx_pause member
+ * @ieee_compliant: Resolve according to IEEE 802.3-2018
  *
  * Configure the advertised Pause and Asym_Pause bits according to the
  * capabilities of provided in @tx and @rx.
@@ -86,10 +87,14 @@ EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
  *  rx=1 tx=1 gives Pause only, which will only allow tx+rx pause
  *            if the other end also advertises Pause.
  */
-void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx)
+void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx,
+			bool ieee_compliant)
 {
+	if (!ieee_compliant)
+		mode = rx ^ tx;
+	else
+		mode = rx | tx;
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertisement, rx);
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertisement,
-			 rx ^ tx);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertisement, mode);
 }
 EXPORT_SYMBOL_GPL(linkmode_set_pause);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..56265ec6a41b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2731,6 +2731,18 @@ void phy_set_sym_pause(struct phy_device *phydev,
bool rx, bool tx,
 }
 EXPORT_SYMBOL(phy_set_sym_pause);

+static void __phy_set_asym_pause(struct phy_device *phydev, bool rx,
bool tx,
+				 bool ieee_compliant)
+{
+
+	linkmode_copy(oldadv, phydev->advertising);
+	linkmode_set_pause(phydev->advertising, tx, rx, ieee_compliant);
+
+	if (!linkmode_equal(oldadv, phydev->advertising) &&
+	    phydev->autoneg)
+		phy_start_aneg(phydev);
+}
+
 /**
  * phy_set_asym_pause - Configure Pause and Asym Pause
  * @phydev: target phy_device struct
@@ -2744,17 +2756,27 @@ EXPORT_SYMBOL(phy_set_sym_pause);
  */
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
-
-	linkmode_copy(oldadv, phydev->advertising);
-	linkmode_set_pause(phydev->advertising, tx, rx);
-
-	if (!linkmode_equal(oldadv, phydev->advertising) &&
-	    phydev->autoneg)
-		phy_start_aneg(phydev);
+	__phy_set_asym_pause(phydev, rx, tx, false);
 }
 EXPORT_SYMBOL(phy_set_asym_pause);

+/**
+ * phy_set_asym_pause_ieee - Configure Pause and Asym Pause in IEEE
compliance mode
+ * @phydev: target phy_device struct
+ * @rx: Receiver Pause is supported
+ * @tx: Transmit Pause is supported
+ *
+ * Description: Configure advertised Pause support depending on if
+ * transmit and receiver pause is supported. If there has been a
+ * change in adverting, trigger a new autoneg. Generally called from
+ * the set_pauseparam .ndo.
+ */
+void phy_set_asym_pause_ieee(struct phy_device *phydev, bool rx, bool tx)
+{
+	__phy_set_asym_pause(phydev, rx, tx, true);
+}
+EXPORT_SYMBOL(phy_set_asym_pause_ieee);
+
 /**
  * phy_validate_pause - Test if the PHY/MAC support the pause configuration
  * @phydev: phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 14c7d73790b4..443f383d3589 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1770,7 +1770,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	 * rx/tx pause resolution.
 	 */
 	linkmode_set_pause(config->advertising, pause->tx_pause,
-			   pause->rx_pause);
+			   pause->rx_pause, true);

 	manual_changed = (config->pause ^ pause_state) & MLO_PAUSE_AN ||
 			 (!(pause_state & MLO_PAUSE_AN) &&
diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index f8397f300fcd..2bce29cb2605 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -98,6 +98,7 @@ void linkmode_resolve_pause(const unsigned long
*local_adv,
 			    const unsigned long *partner_adv,
 			    bool *tx_pause, bool *rx_pause);

-void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx);
+void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx,
+			bool ieee_compliant);

 #endif /* __LINKMODE_H */



Andrew what do you think?
-- 
Florian
