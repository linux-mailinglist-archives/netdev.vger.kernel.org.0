Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877C1AFC34
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDSQvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:51:37 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:33125 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgDSQvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:51:36 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id F0C0323059;
        Sun, 19 Apr 2020 18:51:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587315094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2HyE6TBA3XUAdH/omLPdoIHFpzwyQMgKdLGgjukg4lo=;
        b=Ob1/31ZFRYQJJPTGK82mDe3+zpDvyCoCyRVnIVhqOJ0fLqI2fzCUsB/DgeXj/j7cmy7DxP
        U5wVZfro1sgJ533gBycwNf3jqMfQvfTHzhJjhMEM3yCZgF1EhSAe21Obgb6v8hIfX/7Y3m
        1cXZISHxzUFdBDu1DU82lb8QbRSkEfQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Apr 2020 18:51:33 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 3/3] net: phy: bcm54140: add hwmon support
In-Reply-To: <20200419155655.GK836632@lunn.ch>
References: <20200419101249.28991-1-michael@walle.cc>
 <20200419101249.28991-3-michael@walle.cc> <20200419155655.GK836632@lunn.ch>
Message-ID: <4fd6d06636898560c405713eb91327e3@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: F0C0323059
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         NEURAL_HAM(-0.00)[-0.975];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,suse.com,roeck-us.net,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-19 17:56, schrieb Andrew Lunn:
> On Sun, Apr 19, 2020 at 12:12:49PM +0200, Michael Walle wrote:
> 
> Hi Michael
> 
> You have an #if here...
> 
>> +#if IS_ENABLED(CONFIG_HWMON)
>> +static umode_t bcm54140_hwmon_is_visible(const void *data,
>> +					 enum hwmon_sensor_types type,
>> +					 u32 attr, int channel)
>> +{
>> +	switch (type) {
>> +	case hwmon_in:
>> +		switch (attr) {
>> +		case hwmon_in_min:
>> +		case hwmon_in_max:
>> +			return 0644;
>> +		case hwmon_in_label:
>> +		case hwmon_in_input:
>> +		case hwmon_in_alarm:
>> +			return 0444;
>> +		default:
>> +			return 0;
>> +		}
>> +	case hwmon_temp:
>> +		switch (attr) {
>> +		case hwmon_temp_min:
>> +		case hwmon_temp_max:
>> +			return 0644;
>> +		case hwmon_temp_input:
>> +		case hwmon_temp_alarm:
>> +			return 0444;
>> +		default:
>> +			return 0;
>> +		}
>> +	default:
>> +		return 0;
>> +	}
>> +}
> 
> ...
> 
> 
>> +static const struct hwmon_chip_info bcm54140_chip_info = {
>> +	.ops = &bcm54140_hwmon_ops,
>> +	.info = bcm54140_hwmon_info,
>>  };
>> 
>>  static int bcm54140_phy_base_read_rdb(struct phy_device *phydev, u16 
>> rdb)
>> @@ -203,6 +522,72 @@ static int bcm54140_get_base_addr_and_port(struct 
>> phy_device *phydev)
>>  	return 0;
>>  }
> 
> 
> Still inside the #if. Some original code is now inside the #if/#endif.
> Is this correct? Hard to see from just the patch.

Whoops you're correct, something got messed up here. Will
fix that in the next version.

-michael


> 
>> 
>> +/* Check if one PHY has already done the init of the parts common to 
>> all PHYs
>> + * in the Quad PHY package.
>> + */
>> +static bool bcm54140_is_pkg_init(struct phy_device *phydev)
>> +{
>> +	struct bcm54140_phy_priv *priv = phydev->priv;
>> +	struct mii_bus *bus = phydev->mdio.bus;
>> +	int base_addr = priv->base_addr;
>> +	struct phy_device *phy;
>> +	int i;
>> +
> 
> ...
> 
>> +static int bcm54140_phy_probe_once(struct phy_device *phydev)
>> +{
>> +	struct device *hwmon;
>> +	int ret;
>> +
>> +	/* enable hardware monitoring */
>> +	ret = bcm54140_enable_monitoring(phydev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	hwmon = devm_hwmon_device_register_with_info(&phydev->mdio.dev,
>> +						     "BCM54140", phydev,
>> +						     &bcm54140_chip_info,
>> +						     NULL);
>> +	return PTR_ERR_OR_ZERO(hwmon);
>> +}
>> +#endif
> 
> 
> Thanks
>   Andrew
