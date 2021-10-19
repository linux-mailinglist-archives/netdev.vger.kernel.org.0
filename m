Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7221E43358B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhJSMPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:15:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16814 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhJSMPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:15:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634645579; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=AAP0IMAw/zT/DZZ+e/k3WPaV5KaUEEwAiUGgzytam/c=; b=aL2VbJE2yjuhEIff9iJLcqHjh0Gc+6d2IoHR8QHgJcd1PQ3hpwU2pdemoeokxpSWrT95ve4L
 h/z38zE5xbYv5z6/OySzDad6b8df/mJbIwdR+OW8SlpqY6SbXeD9IzChP8Cc4y989FLyDTsB
 PUyNTr5NsJA5saTjvlZlI9o5wd8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 616eb649bc30296958aedd55 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 12:12:57
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5C50DC43617; Tue, 19 Oct 2021 12:12:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45A6FC4338F;
        Tue, 19 Oct 2021 12:12:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 45A6FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v3 08/13] net: phy: add qca8081 config_aneg
To:     Andrew Lunn <andrew@lunn.ch>, Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-9-luoj@codeaurora.org> <YW3pMD7PD2M3lD3o@lunn.ch>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <6a7cf7c3-f79f-b142-8900-05abd44ead65@quicinc.com>
Date:   Tue, 19 Oct 2021 20:12:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW3pMD7PD2M3lD3o@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 5:37 AM, Andrew Lunn wrote:
> On Mon, Oct 18, 2021 at 11:33:28AM +0800, Luo Jie wrote:
>> Reuse at803x phy driver config_aneg excepting
>> adding 2500M auto-negotiation.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/at803x.c | 26 +++++++++++++++++++++++++-
>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
>> index 0c22ef735230..c124d3fe40fb 100644
>> --- a/drivers/net/phy/at803x.c
>> +++ b/drivers/net/phy/at803x.c
>> @@ -1084,7 +1084,30 @@ static int at803x_config_aneg(struct phy_device *phydev)
>>   			return ret;
>>   	}
>>   
>> -	return genphy_config_aneg(phydev);
>> +	/* Do not restart auto-negotiation by setting ret to 0 defautly,
>> +	 * when calling __genphy_config_aneg later.
>> +	 */
>> +	ret = 0;
>> +
>> +	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
>> +		int phy_ctrl = 0;
>> +
>> +		/* The reg MII_BMCR also needs to be configured for force mode, the
>> +		 * genphy_config_aneg is also needed.
>> +		 */
>> +		if (phydev->autoneg == AUTONEG_DISABLE)
>> +			genphy_c45_pma_setup_forced(phydev);
>> +
>> +		if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->advertising))
>> +			phy_ctrl = MDIO_AN_10GBT_CTRL_ADV2_5G;
>> +
>> +		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
>> +				MDIO_AN_10GBT_CTRL_ADV2_5G, phy_ctrl);
> Does the PHY also have MDIO_MMD_AN, MDIO_AN_ADVERTISE ? I'm wondering
> if you can use genphy_c45_an_config_aneg()
>
>     Andrew
Thanks Andrew for this comments, since the PHY does not have the regiser 
MDIO_AN_ADVERTISE,

genphy_c45_an_config_aneg can't be used here.

