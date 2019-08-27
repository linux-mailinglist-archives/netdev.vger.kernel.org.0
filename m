Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8589F361
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfH0TmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:42:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35445 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730421AbfH0TmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:42:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so324868wmg.0
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 12:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=52o7W1JMe6k3z859vNHKFnJOdebSaubAgKQLzHFGWVs=;
        b=YDo56Ke9KQn2eFrXxtbkWurmXFuXOPiIig4Wkl/8y6MjKUvuz3bdKnla2WnMBluh5U
         7lMZQ/3Ut1lxMKhLio335GIn7LNIIRRrza0czQFfmzjmKBoNgX6qVnYlBje5pfduQBq9
         8x1EOwD092jAXqIQCd8gHnHSctNSoWQSHfZB4gGuWtFnHsCsPGwnDsWxV6QPKOV6XMRw
         ALetwtwgBMQpuKfq8woqVS2AHqymBrGiuOdy6RsBFkVsfz2KdIQ5fCNl2EbpEqLKssDg
         hLu3Y/Xy35uMbkiEtYfesK3X69HB+4j8JBtQMn8ZGQbTiW9sMy0tiswmL69i2BvTYjhW
         MUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=52o7W1JMe6k3z859vNHKFnJOdebSaubAgKQLzHFGWVs=;
        b=CrpbyEgd/N5L8n0K+R0BwRkOaIADYmyYhsbkE6mGwgxWe7CKhv+bJb9Cz1khui7xhW
         HlgbLulSOVc2yC1LsxopueehaUKANNX0myU4wrkkMNHK1tDCjEmbOrzWDB2X+HFGGKeK
         /1JrIQUzvL1O8VPxgFyK+tJw89RJPw2BW5M+HKu7N7g0ktLmSgdYm/ut6JM64dcGKnXH
         nKbaN8f9vLm6t+QFrAvtG98JtW8RmC1Ei//R1JBhG/zodkksc/lJoLYUjHUmOPOJLOWt
         2b3X5WGo2ZZgi1PdkXwNELF9gpMpIJasf6N0+Mb2/yHfpbP/A0dw/B9MsnB1Nl4KclPp
         lj+Q==
X-Gm-Message-State: APjAAAWhe4b63sqwB1CfzKkwaGlmvDuQuajX2o1iBxBIlY5u2bVkq+6H
        HY83t+d0fkkWK+Z7YDrrzlg=
X-Google-Smtp-Source: APXvYqwKsTNhE8mrHiBZHNfnXvSWK2DxjMjxrKiM8Ut4X5/L1PZigHLeRaLeKcnDqwmQXp9+v/2GSw==
X-Received: by 2002:a1c:ef09:: with SMTP id n9mr204425wmh.23.1566934926532;
        Tue, 27 Aug 2019 12:42:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0? (p200300EA8F047C0004DC3C3331AAF4C0.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0])
        by smtp.googlemail.com with ESMTPSA id f23sm77287wmj.37.2019.08.27.12.42.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 12:42:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     "shenjian (K)" <shenjian15@huawei.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, forest.zhouchang@huawei.com,
        linuxarm@huawei.com
References: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
 <fc2a700a-9c24-b96c-df6b-c5414883d89e@gmail.com>
 <d3cd1ef1-8add-84bb-c4d9-801b65d0fba1@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <04fdbe88-8471-c023-4a0d-890667735737@gmail.com>
Date:   Tue, 27 Aug 2019 21:41:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d3cd1ef1-8add-84bb-c4d9-801b65d0fba1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2019 10:29, shenjian (K) wrote:
> 
> 
> 在 2019/8/27 13:51, Heiner Kallweit 写道:
>> On 27.08.2019 04:47, Jian Shen wrote:
>>> Some ethernet drivers may call phy_start() and phy_stop() from
>>> ndo_open and ndo_close() respectively.
>>>
>>> When network cable is unconnected, and operate like below:
>>> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
>>> autoneg, and phy is no link.
>>> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
>>> phy state machine.
>>> step 3: plugin the network cable, and autoneg complete, then
>>> LED for link status will be on.
>>> step 4: ethtool ethX --> see the result of "Link detected" is no.
>>>
>> Step 3 and 4 seem to be unrelated to the actual issue.
>> With which MAC + PHY driver did you observe this?
>>
> Thanks Heiner,
> 
> I tested this on HNS3 driver, with two phy, Marvell 88E1512 and RTL8211.
> 
> Step 3 and Step 4 is just to describe that the LED of link shows link up,
> but the port information shows no link.
> 
ethtool refers to the link at MAC level. Therefore default implementation
ethtool_op_get_link just returns the result of netif_carrier_ok().
Also using PHY link status if interface is down doesn't really make sense:
- phylib state machine isn't running, therefore PHY status doesn't get updated
- often MAC drivers shut down parts of the MAC on ndo_close, this typically
  makes the internal MDIO bus unaccessible
So just remove steps 3 and 4. The patch itself is fine with me.

> 
>>> This patch forces phy suspend even phydev->link is off.
>>>
>>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>>> ---
>>>  drivers/net/phy/phy.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index f3adea9..0acd5b4 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -911,8 +911,8 @@ void phy_state_machine(struct work_struct *work)
>>>  		if (phydev->link) {
>>>  			phydev->link = 0;
>>>  			phy_link_down(phydev, true);
>>> -			do_suspend = true;
>>>  		}
>>> +		do_suspend = true;
>>>  		break;
>>>  	}
>>>  
>>>
>> Heiner
>>
>>
> 
> 

