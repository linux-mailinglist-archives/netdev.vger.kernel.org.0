Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D02B30A3
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbfIOPLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 11:11:47 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33962 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfIOPLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 11:11:47 -0400
Received: by mail-oi1-f196.google.com with SMTP id 12so6384394oiq.1;
        Sun, 15 Sep 2019 08:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DKCXVIrcSzKm7mCmX8aoJe0sheT9l3FCKuW3GewAC9s=;
        b=cXT7cbb4P9rJHPdcjTbipqqH6aWUBjmJMgOPZvtQ4iPpObta2lh2/H6Ke/Q0VIYlAW
         qhRriG//gP1ggSp0J9HmN4UpVKg8I4/NLZYpMWetJZ9JIO0C9R+4ZTwJv35WbjRuwE4h
         /4wKLN8PYL3OFAMO8kF+SFMyp7HsL4a5fF/p62vk7SL5dMOOhoxRUhM1WxQKk9tAEM27
         ewbukfw1B3F22EMhqDozDTYMvRvPtLwvDEnGCImGd3cYY9AcxURd1ho+bfUWF/7TYOzN
         V2wq124MXNfQ7/pdhtaXewokFacSAHSxwIX7dvIDcsP3h33EcTUswEwc7UyH2ojIy56G
         tPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DKCXVIrcSzKm7mCmX8aoJe0sheT9l3FCKuW3GewAC9s=;
        b=Y6+MtmmLZtqA3o0JOGOv8WORl8bsfBEvcVKWlB7GnTFqDUWSJnJVAbQ5a+txlNwG5p
         2hMnMGNlMo7pLcTlPPTOWDoGlGnSgfi5kKucwbR3AbNpcsBVdgFfmeceYbNJY5vNgpSy
         +DefKKzJfCBqniUj34vXkvNuv0cXRL8SpY4+xoHintzZKpvFaFGhtaaKSqKg0+2khfwR
         8PMr/DELZlSuWuQ8NlFFJ703qasdobMBNMSRiNO9UC4Op8u7z1v+ZojthxKV8yqQduzz
         n490pccI8aHKn68O9VPALPSQTrApHh8N2JhSlkWxKXvgoV7GYGasWb4GehgQDodfpkKZ
         9OFg==
X-Gm-Message-State: APjAAAU/Lp8YBXEk0E34g/kPO0PK4LzJ5Q3mCkbxQkarYl69pQ4yuPa4
        t6dqXn9vCLE9+E4kDkLLjLw=
X-Google-Smtp-Source: APXvYqxeQV+4EpKiZcIrr/cqTHgou3n5+g9ULXCKsYlnzIsGNuCcwWUxlxPpzpvluzkImNkb2RgaMQ==
X-Received: by 2002:aca:dbd7:: with SMTP id s206mr11077351oig.79.1568560306312;
        Sun, 15 Sep 2019 08:11:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m17sm11804013otr.51.2019.09.15.08.11.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 08:11:45 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, hkallweit1@gmail.com,
        mkubecek@suse.cz
References: <20190912162812.402-1-alexandru.ardelean@analog.com>
 <20190912162812.402-3-alexandru.ardelean@analog.com>
 <20190914152931.GK27922@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <53816513-436e-b33b-99cf-18fa98e468b1@gmail.com>
Date:   Sun, 15 Sep 2019 08:11:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190914152931.GK27922@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2019 8:29 AM, Andrew Lunn wrote:
> On Thu, Sep 12, 2019 at 07:28:12PM +0300, Alexandru Ardelean wrote:
> 
>> +static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
>> +{
>> +	u16 val;
>> +
>> +	if (tx_interval == ETHTOOL_PHY_EDPD_DISABLE)
>> +		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
>> +				(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
>> +
>> +	val = ADIN1300_NRG_PD_EN;
>> +
>> +	switch (tx_interval) {
>> +	case 1000: /* 1 second */
>> +		/* fallthrough */
>> +	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
>> +		val |= ADIN1300_NRG_PD_TX_EN;
>> +		/* fallthrough */
>> +	case ETHTOOL_PHY_EDPD_NO_TX:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return phy_modify(phydev, ADIN1300_PHY_CTRL_STATUS2,
>> +			  (ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN),
>> +			  val);
>> +}
>> +
> 
>>  
>> +	rc = adin_set_edpd(phydev, 1);
>> +	if (rc < 0)
>> +		return rc;
> 
> Hi Alexandru
> 
> Shouldn't this be adin_set_edpd(phydev, 1000);

That does sound like the intended use, or use
ETHTOOL_PHY_EDPD_DFLT_TX_MSECS, with that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
