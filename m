Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F8C6D3825
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjDBNwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 09:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBNwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 09:52:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B527EEE
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 06:52:39 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cn12so107521478edb.4
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 06:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680443558;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T8jQIrR4rlb97XRRyRF9/aEtv+PY3oNNM0DXxpIcCJk=;
        b=Fe8YEQFzg47yxYy2zvx5bl9djkywYZEbQsr8SjhgFj/S7GRQktu2gSE2PSIx5yymwC
         1T82Mj3mf+6mQwxeDVlVSRedO6mQ8zWQvj1J1yHzN0Za8gcaY5tKNXc29pMM0hXaX+wB
         hTSHybNNxZ9vd+gby8lKzX1UiZhyLDPRvstjM3xi3E28yhGrdlK/MEwmSgVtKomV17L1
         JSu7ofmzhvfG9Yg2gJRCHlQiC4jxfpQ+TJCDihREhkK2y0njrmNk6OOlMwHG+GRA28wA
         HVI9CmHAkL2VMw3Ri3Mkcchy1ma+8s5WY9G7vAzLEVv5aUxVtLrFESP34HhmUvrJAwe7
         DLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680443558;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T8jQIrR4rlb97XRRyRF9/aEtv+PY3oNNM0DXxpIcCJk=;
        b=5aTtifIjy3LLuz4SINHJX6Dr3wp8Fc0ovcvOkBpQmY78I961p5Mm7FZDXXxsT0tWk+
         F9jHoQ7vIMTYetgxJP+ZP0lE+LFFADByO10KlgX29ct2entagg8/23/3aTf5mQiH06A+
         Vr2i/3fd1yUCrOljfAoLcfYW3FvHhFLChwNr2mroWn7qqXc8BIU1ARCn13GwZ+p8CcP1
         Wrfc/EsyLA2cG86cjEjQWt0xuj223IRb3sUhiR9Te7FlIfZ+h9ToXsSGOqeME+EB0Eky
         j4ZaAGylQxIe0aEj7rLCUuHvwATjNcSOMYe9zRfUaYsOviHApUNt0tCUyt4r/5VoBKju
         DAtQ==
X-Gm-Message-State: AAQBX9eBZYy85VI9xfvNiUKZuBlZRWTmj1tX00iVNu1DPtp4NN5Ogx/k
        LRiZxZIf3Lv7FuQqlgImKOQ=
X-Google-Smtp-Source: AKy350Zj0SHwc73OEBpdfBsvZOwpn/qlHA1boZmobG0tvvtmNJsDgsNMuXghGWTL5yRG0TkKCBIHMg==
X-Received: by 2002:a17:907:7fa9:b0:947:791b:fdcb with SMTP id qk41-20020a1709077fa900b00947791bfdcbmr10657886ejc.21.1680443557863;
        Sun, 02 Apr 2023 06:52:37 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id x3-20020a50d603000000b004c06f786602sm3265454edi.85.2023.04.02.06.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 06:52:37 -0700 (PDT)
Message-ID: <a6b8bfe0-3eed-2e15-804a-7206e9e71259@gmail.com>
Date:   Sun, 2 Apr 2023 15:52:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 6/7] net: phy: smsc: add edpd tunable support
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
 <66446a75-8087-10f4-fc37-b97e13b88c27@gmail.com>
 <ZClwVbl8HeCxcHXa@corigine.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <ZClwVbl8HeCxcHXa@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.04.2023 14:08, Simon Horman wrote:
> On Sun, Apr 02, 2023 at 11:47:34AM +0200, Heiner Kallweit wrote:
>> This adds support for the EDPD PHY tunable.
>> Per default EDPD is disabled in interrupt mode, the tunable can be used
>> to override this, e.g. if the link partner doesn't use EDPD.
>> The interval to check for energy can be chosen between 1000ms and
>> 2000ms. Note that this value consists of the 1000ms phylib interval
>> for state machine runs plus the time to wait for energy being detected.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/smsc.c  | 82 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/smscphy.h |  4 ++
>>  2 files changed, 86 insertions(+)
>>
>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> index 0cd433f01..cca5bf46f 100644
>> --- a/drivers/net/phy/smsc.c
>> +++ b/drivers/net/phy/smsc.c
>> @@ -34,6 +34,8 @@
>>  #define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
>>  
>>  #define EDPD_MAX_WAIT_DFLT		640
> 
> nit: Maybe this could be EDPD_MAX_WAIT_DFLT_MS for consistency
>      with PHY_STATE_MACH_MS.
> 
Yes, this would be better.

>> +/* interval between phylib state machine runs in ms */
>> +#define PHY_STATE_MACH_MS		1000
>>  
>>  struct smsc_hw_stat {
>>  	const char *string;
>> @@ -295,6 +297,86 @@ static void smsc_get_stats(struct phy_device *phydev,
>>  		data[i] = smsc_get_stat(phydev, i);
>>  }
>>  
>> +static int smsc_phy_get_edpd(struct phy_device *phydev, u16 *edpd)
>> +{
>> +	struct smsc_phy_priv *priv = phydev->priv;
>> +
>> +	if (!priv)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (!priv->edpd_enable)
>> +		*edpd = ETHTOOL_PHY_EDPD_DISABLE;
>> +	else if (!priv->edpd_max_wait_ms)
>> +		*edpd = ETHTOOL_PHY_EDPD_NO_TX;
>> +	else
>> +		*edpd = PHY_STATE_MACH_MS + priv->edpd_max_wait_ms;
>> +
>> +	return 0;
>> +}
>> +
>> +static int smsc_phy_set_edpd(struct phy_device *phydev, u16 edpd)
>> +{
>> +	struct smsc_phy_priv *priv = phydev->priv;
>> +	int ret;
>> +
>> +	if (!priv)
>> +		return -EOPNOTSUPP;
>> +
>> +	mutex_lock(&phydev->lock);
> 
> I am a little confused by this as by my reasoning this code is called via
> the first arm of the following in set_phy_tunable(), and phydev->lock is
> already held.
> 

You're right of course. So we can remove the locking in the driver.

>         if (phy_drv_tunable) {
>                 mutex_lock(&phydev->lock);
>                 ret = phydev->drv->set_tunable(phydev, &tuna, data);
>                 mutex_unlock(&phydev->lock);
>         } else {
>                 ret = dev->ethtool_ops->set_phy_tunable(dev, &tuna, data);
>         }
> 
>> +
>> +	switch (edpd) {
>> +	case ETHTOOL_PHY_EDPD_DISABLE:
>> +		priv->edpd_enable = false;
>> +		break;
>> +	case ETHTOOL_PHY_EDPD_NO_TX:
>> +		priv->edpd_enable = true;
>> +		priv->edpd_max_wait_ms = 0;
>> +		break;
>> +	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
>> +		edpd = PHY_STATE_MACH_MS + EDPD_MAX_WAIT_DFLT;
>> +		fallthrough;
>> +	default:
>> +		if (phydev->irq != PHY_POLL)
>> +			return -EOPNOTSUPP;
> 
> This returns without releasing phydev->lock.
> Is that intended?
> 
>> +		if (edpd < PHY_STATE_MACH_MS || edpd > PHY_STATE_MACH_MS + 1000)
>> +			return -EINVAL;
> 
> Ditto.
> 
>> +		priv->edpd_enable = true;
>> +		priv->edpd_max_wait_ms = edpd - PHY_STATE_MACH_MS;
>> +	}
>> +
>> +	priv->edpd_mode_set_by_user = true;
>> +
>> +	ret = smsc_phy_config_edpd(phydev);
>> +
>> +	mutex_unlock(&phydev->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +int smsc_phy_get_tunable(struct phy_device *phydev,
>> +			 struct ethtool_tunable *tuna, void *data)
>> +{
>> +	switch (tuna->id) {
>> +	case ETHTOOL_PHY_EDPD:
>> +		return smsc_phy_get_edpd(phydev, data);
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(smsc_phy_get_tunable);
>> +
>> +int smsc_phy_set_tunable(struct phy_device *phydev,
>> +			 struct ethtool_tunable *tuna, const void *data)
>> +{
>> +	switch (tuna->id) {
>> +	case ETHTOOL_PHY_EDPD:
>> +		return smsc_phy_set_edpd(phydev, *(u16 *)data);
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(smsc_phy_set_tunable);
>> +
>>  int smsc_phy_probe(struct phy_device *phydev)
>>  {
>>  	struct device *dev = &phydev->mdio.dev;
>> diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
>> index 80f37c1db..e1c886277 100644
>> --- a/include/linux/smscphy.h
>> +++ b/include/linux/smscphy.h
>> @@ -32,6 +32,10 @@ int smsc_phy_config_intr(struct phy_device *phydev);
>>  irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev);
>>  int smsc_phy_config_init(struct phy_device *phydev);
>>  int lan87xx_read_status(struct phy_device *phydev);
>> +int smsc_phy_get_tunable(struct phy_device *phydev,
>> +			 struct ethtool_tunable *tuna, void *data);
>> +int smsc_phy_set_tunable(struct phy_device *phydev,
>> +			 struct ethtool_tunable *tuna, const void *data);
>>  int smsc_phy_probe(struct phy_device *phydev);
>>  
>>  #endif /* __LINUX_SMSCPHY_H__ */
>> -- 
>> 2.40.0
>>
>>

