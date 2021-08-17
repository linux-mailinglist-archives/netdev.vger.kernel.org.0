Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46E83EED38
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhHQNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:21:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:33562 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235267AbhHQNVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:21:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629206453; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=FlGPwg1kyi05VPgPSDR9GtaHsFXAyJ6llF/JVEFOnPE=; b=XOTjHY1Ra1EF7LFARIRVxuE/JKxCfp3FwLCwJqqd2JMyCu5rxexR5jUidriQirUhyB02KLlu
 lxWuvjwzDfuky0l3EIO9nEcdOs+mGRp4pd24UOB4xWbh6NWegOV/P6AgDHIgZPiRWHRAQ7ov
 3V0wuvZJmh80RNn3NWJ3/VcfOns=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 611bb69f9507ca1a348370c8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 17 Aug 2021 13:16:15
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8843DC43616; Tue, 17 Aug 2021 13:16:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.92.1.52] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 077A2C4338F;
        Tue, 17 Aug 2021 13:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 077A2C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
References: <20210816113440.22290-1-luoj@codeaurora.org>
 <20210816140103.GK22278@shell.armlinux.org.uk>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <5f517769-8987-385d-1a0c-48c3e808636c@codeaurora.org>
Date:   Tue, 17 Aug 2021 21:16:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210816140103.GK22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/16/2021 10:01 PM, Russell King (Oracle) wrote:
> On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
>> +/* PMA control */
>> +#define QCA808X_PHY_MMD1_PMA_CONTROL			0x0
>> +#define QCA808X_PMA_CONTROL_SPEED_MASK			(BIT(13) | BIT(6))
>> +#define QCA808X_PMA_CONTROL_2500M			(BIT(13) | BIT(6))
>> +#define QCA808X_PMA_CONTROL_1000M			BIT(6)
>> +#define QCA808X_PMA_CONTROL_100M			BIT(13)
>> +#define QCA808X_PMA_CONTROL_10M				0x0
> I don't think this is (a) correct, (b) any different from the IEEE 802.3
> standard definitions. Please use the standard definitions in
> include/uapi/linux/mdio.h.
thanks Russell, will update it in the next patch.
>
>> +/* PMA capable */
>> +#define QCA808X_PHY_MMD1_PMA_CAP_REG			0x4
>> +#define QCA808X_STATUS_2500T_FD_CAPS			BIT(13)
> Again, this is IEEE 802.3 standard, nothing special here. As this is
> a standard bit, include/uapi/linux/mdio.h should be augmented with
> it rather than introducing private definitions. Note that this is
> _not_ 2500T but merely indicates that the "PMA/PMD is capable of
> operating at 2.5 Gb/s". IEEE 802.3 makes no mention of the underlying
> technology used to achieve 2.5Gbps.
thanks for the comments, will update it to use the standard register for 
the 2.5G capability.
>> +/* PMA type */
>> +#define QCA808X_PHY_MMD1_PMA_TYPE			0x7
>> +#define QCA808X_PMA_TYPE_MASK				GENMASK(5, 0)
>> +#define QCA808X_PMA_TYPE_2500M				0x30
>> +#define QCA808X_PMA_TYPE_1000M				0xc
>> +#define QCA808X_PMA_TYPE_100M				0xe
>> +#define QCA808X_PMA_TYPE_10M				0xf
> This is the PMA type selection register... another IEEE 802.3 standard
> register. You omit the underlying technology for these definitions.
>  From the IEEE 802.3 standard:
>
> 0x30 2.5GBASE-T PMA
> 0x0f 10BASE-T PMA/PMD
> 0x0e 100BASE-TX PMA/PMD
> 0x0c 1000BASE-T PMA/PMD
>
> and we have definitions for all these already:
>
> #define MDIO_PMA_CTRL2_1000BT           0x000c  /* 1000BASE-T type */
> #define MDIO_PMA_CTRL2_100BTX           0x000e  /* 100BASE-TX type */
> #define MDIO_PMA_CTRL2_10BT             0x000f  /* 10BASE-T type */
> #define MDIO_PMA_CTRL2_2_5GBT           0x0030  /* 2.5GBaseT type */
>
> Please make use of these.
will use it in the next patch.
>
>> +/* AN 2.5G */
>> +#define QCA808X_PHY_MMD7_AUTONEGOTIATION_CONTROL	0x20
>> +#define QCA808X_ADVERTISE_2500FULL			BIT(7)
>> +#define QCA808X_FAST_RETRAIN_2500BT			BIT(5)
>> +#define QCA808X_ADV_LOOP_TIMING				BIT(0)
>> +
>> +/* Fast retrain related registers */
>> +#define QCA808X_PHY_MMD1_FAST_RETRAIN_STATUS_CTL	0x93
>> +#define QCA808X_FAST_RETRAIN_CTRL			0x1
> I suspect I'm going to find that the above are standard registers
> as well.
>
> I think I'll also ask that once you've corrected the above, that you
> also look to see which of the Clause 45 generic support functions you
> can make use of in this driver, and switch it over to those - and then
> post a revised version.
>
> Thanks.

thanks Russell for review comments, will refer to the standard registers 
and update

it in the next patch.

>
