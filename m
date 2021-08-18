Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7743F048A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 15:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhHRNW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 09:22:57 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27205 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236676AbhHRNW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 09:22:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629292942; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=7+Ab/9z1rA+iXhTGMj2XCyz3LmnToltqWhfqUmQZaZg=; b=fkLrUaVVe0AV37jygLOYrfnhXJt723S6yUy3i65lBXXA7N9/IaxcjOigbfUgbVDOA/oYY1Xm
 hAWvyFXk2gGhozl+kx3t9wNnSsqu6xJU8PPeqZQT4J4vtJYL9YdUQkgQYd7ziubF4+58qyp5
 Rz/NHdbnQRoGxVMlP28SoCX00tc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 611d096f2892f803bc36d822 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Aug 2021 13:21:51
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DB9F0C43617; Wed, 18 Aug 2021 13:21:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.52] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0AE05C4338F;
        Wed, 18 Aug 2021 13:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0AE05C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
References: <20210816113440.22290-1-luoj@codeaurora.org>
 <YRpuhIcwN2IsaHzy@lunn.ch>
 <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
 <YRu6n49p/Evecd8P@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <92c80a0b-87ad-252b-7a9a-30176e7f06cf@codeaurora.org>
Date:   Wed, 18 Aug 2021 21:21:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YRu6n49p/Evecd8P@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/17/2021 9:33 PM, Andrew Lunn wrote:
> On Tue, Aug 17, 2021 at 09:10:44PM +0800, Jie Luo wrote:
>> On 8/16/2021 9:56 PM, Andrew Lunn wrote:
>>> On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
>>>> qca8081 is industry’s lowest cost and power 1-port 2.5G/1G Ethernet PHY
>>>> chip, which implements SGMII/SGMII+ for interface to SoC.
>>> Hi Luo
>>>
>>> No Marketing claims in the commit message please. Even if it is
>>> correct now, it will soon be wrong with newer generations of
>>> devices.
>>>
>>> And what is SGMII+? Please reference a document. Is it actually
>>> 2500BaseX?
>> Hi Andrew,
>>
>> thanks for the comments, will remove the claims in the next patch.
>>
>> SGMII+ is for 2500BaseX, which is same as SGMII, but the clock frequency of
>> SGMII+ is 2.5 times SGMII.
> 25000BaseX is not SGMII over clocked at 2.5GHz.
>
> If it is using 2500BaseX then call it 2500BaseX, because 2500BaseX is
> well defined in the standards, and SGMII overclocked to 2.5G is not
> standardised.

will update it to use 2500BaseX in the next patch, thanks for this comment.

>
>>> A lot of these registers look the same as the at803x. So i'm thinking
>>> you should merge these two drivers. There is a lot of code which is
>>> identical, or very similar, which you can share.
>> Hi Andrew,
>>
>> qca8081 supports IEEE1588 feature, the IEEE1588 code may be submitted in the
>> near future,
>>
>> so it may be a good idea to keep it out from at803x code.
> Please merge it. A lot of the code is the same, and a lot of the new
> code you are adding will go away once you use the helpers. And
> probably you can improve the features of the older PHYs at the same
> time, where features are the same between them.
thanks for the comment, will update the patch to merge it into at803x code.
>
>>>> +static int qca808x_phy_ms_seed_enable(struct phy_device *phydev, bool enable)
>>>> +{
>>>> +	u16 seed_enable = 0;
>>>> +
>>>> +	if (enable)
>>>> +		seed_enable = QCA808X_MASTER_SLAVE_SEED_ENABLE;
>>>> +
>>>> +	return qca808x_debug_reg_modify(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
>>>> +			QCA808X_MASTER_SLAVE_SEED_ENABLE, seed_enable);
>>>> +}
>>> This is interesting. I've not seen any other PHY does this. is there
>>> documentation? Is the datasheet available?
>> this piece of code is for configuring the random seed to a lower value to
>> make the PHY linked
>>
>> as the SLAVE mode for fixing some IOT issue, for master/slave
>> auto-negotiation, please refer to
>>
>> https://www.ieee802.org/3/an/public/jul04/lynskey_2_0704.pdf.
> And what happens when this device is used in an Ethernet switch? A
> next generation of a qca8k? Take a look at
> genphy_setup_master_slave().  Use MASTER_SLAVE_CFG_MASTER_PREFERRED or
> MASTER_SLAVE_CFG_SLAVE_PREFERRED to decide how to bias the
> master/slave decision.
>
>       Andrew

Hi Andrew, thanks for this comment, qca8081 is mainly used in the IPQ 
SOC chip currently.

qca801 is configured as MASTER_SLAVE_CFG_SLAVE_PREFERRED by default.

the SEED random lower value is for making the qca8081 linked as SLAVE 
mode when the link

partner is also configured as MASTER_SLAVE_CFG_SLAVE_PREFERRED in 
auto-negotiation.

.


