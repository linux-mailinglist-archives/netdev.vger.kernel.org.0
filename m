Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0483B434548
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 08:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhJTGmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 02:42:35 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:63786 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229846AbhJTGma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 02:42:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634712016; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: References: Cc: To:
 Subject: From: Sender; bh=izrFRDPPIJzzSEpnDqJmdzIPU5ZzreLatzyS3F4RNbo=;
 b=dnQQDjjESUHTEI1WjQkFh3y+WVV1dXf2BNutUM3JzgtpK2t0trB3Mpmp2uhDaBK/+Q/wbPe4
 XXURY351JwXd33JP3YduRHz7Y9JZEyLZfXxmfqI/wRFaL9NqYFS2gYFILESJsE4SI9T5H3AD
 idMnR33tw3WzK53l+ya25P7f8HM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 616fb9c559612e010088f259 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 06:40:05
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B9A90C4360D; Wed, 20 Oct 2021 06:40:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 118FCC4338F;
        Wed, 20 Oct 2021 06:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 118FCC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
From:   Jie Luo <quic_luoj@quicinc.com>
Subject: Re: [PATCH v3 07/13] net: phy: add qca8081 get_features
To:     Andrew Lunn <andrew@lunn.ch>, Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-8-luoj@codeaurora.org> <YW3qrFRzvPlFrms0@lunn.ch>
Message-ID: <cf1c8c0a-eeab-d5d2-fa04-ff6e4d37b960@quicinc.com>
Date:   Wed, 20 Oct 2021 14:39:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YW3qrFRzvPlFrms0@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 5:44 AM, Andrew Lunn wrote:
> On Mon, Oct 18, 2021 at 11:33:27AM +0800, Luo Jie wrote:
>> Reuse the at803x phy driver get_features excepting
>> adding 2500M capability.
>>
>> Signed-off-by: Luo Jie<luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/at803x.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
>> index 42d3f8ccca94..0c22ef735230 100644
>> --- a/drivers/net/phy/at803x.c
>> +++ b/drivers/net/phy/at803x.c
>> @@ -719,6 +719,15 @@ static int at803x_get_features(struct phy_device *phydev)
>>   	if (err)
>>   		return err;
>>   
>> +	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
>> +		err = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
>> +		if (err < 0)
>> +			return err;
>> +
>> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
>> +				err & MDIO_PMA_NG_EXTABLE_2_5GBT);
>> +	}
> genphy_c45_pma_read_abilities()?
>
> 	Andrew

Hi Andrew,

Thanks for this comment, if we use genphy_c45_pma_read_abilities here, 
the ETHTOOL_LINK_MODE_Autoneg_BIT

will be lost, since MDIO_MMD_AN.MDIO_STAT1 does not have bit 
MDIO_AN_STAT1_ABLE.


