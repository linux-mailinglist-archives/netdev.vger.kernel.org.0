Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828AD43364E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbhJSMuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:50:52 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54732 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhJSMut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:50:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634647716; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=ILJ6KUzz5UKYPnWbk1cGvixDN6iLtxb7woY6fRVqBHg=; b=dUQ1k9+GZjM+zXhfxdTN4pAu76Y7M5GBQBtjArMIBkKBsXGF0/pkhnoGR5ukQZB3FGmjJiqZ
 y1lTBh/XGg7tMX6849B3JMUXKPygyyuIZNAITymnAm1A6wourto44OtusGpTKaoCXRTUlynX
 ZfhP4JvwtK5y034SRi/vx0ZWcn4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 616ebe975ca800b6c1b80db8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 12:48:23
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5010AC4360C; Tue, 19 Oct 2021 12:48:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 98236C4338F;
        Tue, 19 Oct 2021 12:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 98236C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v3 06/13] net: phy: add qca8081 read_status
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Luo Jie <luoj@codeaurora.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-7-luoj@codeaurora.org> <YW3qLe8iHe1wdMev@lunn.ch>
 <0472b75b-9fd7-55e3-dc1b-f33786643103@quicinc.com> <YW66vT1HQsVfjZDz@lunn.ch>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <e0c4aa61-e1ac-e1f3-8a26-635784336512@quicinc.com>
Date:   Tue, 19 Oct 2021 20:48:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW66vT1HQsVfjZDz@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 8:31 PM, Andrew Lunn wrote:
> On Tue, Oct 19, 2021 at 08:10:15PM +0800, Jie Luo wrote:
>> On 10/19/2021 5:42 AM, Andrew Lunn wrote:
>>>> +static int qca808x_read_status(struct phy_device *phydev)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_STAT);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->lp_advertising,
>>>> +			ret & MDIO_AN_10GBT_STAT_LP2_5G);
>>>> +
>>> Could genphy_c45_read_lpa() be used here?
>>>
>>>         Andrew
>> Hi Andrew,
>>
>> Thanks for the comments,  the MDIO_STAT1 of PHY does not follow the
>> standard, bit0~bit6 of MDIO_STAT1 are
>>
>> always 0, genphy_c45_read_lpa can't be used.
> O.K. It is a shame the hardware partially follow the standard, but
> breaks it as well. Why go to the effort of partially following it,
> when you don't gain anything from it because you need custom code
> anyway?
>
> 	Andrew

Hi Andrew,

Thanks for the suggestion. qca8081 PHY indeed add 2.5G capability based 
on the

general 1G PHY, i will feedback this to the HW design team, thanks for 
this comments.

