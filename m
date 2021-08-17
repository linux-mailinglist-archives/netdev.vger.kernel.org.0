Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A473EED21
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbhHQNLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:11:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:54415 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237479AbhHQNLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:11:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629205866; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=qeQ3kQpA0NVaU7cj530jwrf8XFdaBaVRKdyN6YU5ws0=; b=PvFiDaoegXLFBvokHGZeTa4jY2h2t3kkyAk4tBiuXntuL7l7LQZVudWEpNMz8Zy+ul3HtxcM
 ng/FRL+0EHAInTH33TAI+nMsh4E3eY0qGp6D08vGzHCr5MKU7lCQmzCOgVRYMbJRMn6iAvX6
 DYJ1+slLRQloByL37MUpkZm+YsY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 611bb55a454b7a558f6c3824 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 17 Aug 2021 13:10:50
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EDC2BC43618; Tue, 17 Aug 2021 13:10:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.0
Received: from [10.92.1.52] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9CDD2C4338F;
        Tue, 17 Aug 2021 13:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 9CDD2C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
References: <20210816113440.22290-1-luoj@codeaurora.org>
 <YRpuhIcwN2IsaHzy@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
Date:   Tue, 17 Aug 2021 21:10:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YRpuhIcwN2IsaHzy@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/16/2021 9:56 PM, Andrew Lunn wrote:
> On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
>> qca8081 is industry’s lowest cost and power 1-port 2.5G/1G Ethernet PHY
>> chip, which implements SGMII/SGMII+ for interface to SoC.
> Hi Luo
>
> No Marketing claims in the commit message please. Even if it is
> correct now, it will soon be wrong with newer generations of
> devices.
>
> And what is SGMII+? Please reference a document. Is it actually
> 2500BaseX?

Hi Andrew,

thanks for the comments, will remove the claims in the next patch.

SGMII+ is for 2500BaseX, which is same as SGMII, but the clock frequency 
of SGMII+ is 2.5 times SGMII.

>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/Kconfig   |   6 +
>>   drivers/net/phy/Makefile  |   1 +
>>   drivers/net/phy/qca808x.c | 573 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 580 insertions(+)
>>   create mode 100644 drivers/net/phy/qca808x.c
>>
>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>> index c56f703ae998..26cb1c2ffd17 100644
>> --- a/drivers/net/phy/Kconfig
>> +++ b/drivers/net/phy/Kconfig
>> @@ -343,3 +343,9 @@ endif # PHYLIB
>>   config MICREL_KS8995MA
>>   	tristate "Micrel KS8995MA 5-ports 10/100 managed Ethernet switch"
>>   	depends on SPI
>> +
>> +config QCA808X_PHY
>> +	tristate "Qualcomm Atheros QCA808X PHYs"
>> +	depends on REGULATOR
>> +	help
>> +	  Currently supports the QCA8081 model
> This file is sorted on the tristate text. So it should appear directly
> after AT803X_PHY.
will update it in the next patch.
>
>> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
>> index 172bb193ae6a..9ef477d79588 100644
>> --- a/drivers/net/phy/Makefile
>> +++ b/drivers/net/phy/Makefile
>> @@ -84,3 +84,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
>>   obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
>>   obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
>>   obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
>> +obj-$(CONFIG_QCA808X_PHY)	+= qca808x.o
> And this file is sorted by CONFIG_ so should be after
> CONFIG_NXP_TJA11XX_PHY.
>
> Keeping things sorted reduces the likelyhood of a merge conflict.
will update it in the next patch.
>
>> +#include <linux/module.h>
>> +#include <linux/etherdevice.h>
>> +#include <linux/phy.h>
>> +#include <linux/bitfield.h>
>> +
>> +#define QCA8081_PHY_ID					0x004DD101
>> +
>> +/* MII special status */
>> +#define QCA808X_PHY_SPEC_STATUS				0x11
>> +#define QCA808X_STATUS_FULL_DUPLEX			BIT(13)
>> +#define QCA808X_STATUS_LINK_PASS			BIT(10)
>> +#define QCA808X_STATUS_SPEED_MASK			GENMASK(9, 7)
>> +#define QCA808X_STATUS_SPEED_100MBS			1
>> +#define QCA808X_STATUS_SPEED_1000MBS			2
>> +#define QCA808X_STATUS_SPEED_2500MBS			4
>> +
>> +/* MII interrupt enable & status */
>> +#define QCA808X_PHY_INTR_MASK				0x12
>> +#define QCA808X_PHY_INTR_STATUS				0x13
>> +#define QCA808X_INTR_ENABLE_FAST_RETRAIN_FAIL		BIT(15)
>> +#define QCA808X_INTR_ENABLE_SPEED_CHANGED		BIT(14)
>> +#define QCA808X_INTR_ENABLE_DUPLEX_CHANGED		BIT(13)
>> +#define QCA808X_INTR_ENABLE_PAGE_RECEIVED		BIT(12)
>> +#define QCA808X_INTR_ENABLE_LINK_FAIL			BIT(11)
>> +#define QCA808X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
>> +#define QCA808X_INTR_ENABLE_POE				BIT(1)
>> +#define QCA808X_INTR_ENABLE_WOL				BIT(0)
>> +
>> +/* MII DBG address & data */
>> +#define QCA808X_PHY_DEBUG_ADDR				0x1d
>> +#define QCA808X_PHY_DEBUG_DATA				0x1e
>> +
> A lot of these registers look the same as the at803x. So i'm thinking
> you should merge these two drivers. There is a lot of code which is
> identical, or very similar, which you can share.

Hi Andrew,

qca8081 supports IEEE1588 feature, the IEEE1588 code may be submitted in 
the near future,

so it may be a good idea to keep it out from at803x code.

>
>> +static int qca808x_get_2500caps(struct phy_device *phydev)
>> +{
>> +	int phy_data;
>> +
>> +	phy_data = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_PMA_CAP_REG);
>> +
>> +	return (phy_data & QCA808X_STATUS_2500T_FD_CAPS) ? 1 : 0;
> So the PHY ignores the standard and does not set bit
> MDIO_PMA_NG_EXTABLE_2_5GBT in MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE ?
> Please compare the registers against the standards. If they are
> actually being followed, please you the linux names for these
> registers, and try to use the generic code.
will update it to use the generic code in the next patch.
>
>> +static int qca808x_phy_ms_random_seed_set(struct phy_device *phydev)
>> +{
>> +	u16 seed_value = (prandom_u32() % QCA808X_MASTER_SLAVE_SEED_RANGE) << 2;
>> +
>> +	return qca808x_debug_reg_modify(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
>> +			QCA808X_MASTER_SLAVE_SEED_CFG, seed_value);
>> +}
>> +
>> +static int qca808x_phy_ms_seed_enable(struct phy_device *phydev, bool enable)
>> +{
>> +	u16 seed_enable = 0;
>> +
>> +	if (enable)
>> +		seed_enable = QCA808X_MASTER_SLAVE_SEED_ENABLE;
>> +
>> +	return qca808x_debug_reg_modify(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
>> +			QCA808X_MASTER_SLAVE_SEED_ENABLE, seed_enable);
>> +}
> This is interesting. I've not seen any other PHY does this. is there
> documentation? Is the datasheet available?

this piece of code is for configuring the random seed to a lower value 
to make the PHY linked

as the SLAVE mode for fixing some IOT issue, for master/slave 
auto-negotiation, please refer to

https://www.ieee802.org/3/an/public/jul04/lynskey_2_0704.pdf.

>
>> +static int qca808x_soft_reset(struct phy_device *phydev)
>> +{
>> +	int ret;
>> +
>> +	ret = genphy_soft_reset(phydev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (phydev->autoneg == AUTONEG_DISABLE) {
>> +		ret = qca808x_speed_forced(phydev);
>> +		if (ret)
>> +			return ret;
> That is unusual. After a reset, you would expect the config_aneg()
> function to be called, and it should set things like this. Why is it
> needed?
>
> I don't see anything handling the host side. Generally, devices like
> this use SGMII for 10/100/1G. When 2.5G is in use they swap their host
> interface to 2500BaseX. See mv3310_update_interface() as an example.
>
> 	  Andrew

thanks Andrew for the comments. will remove qca808x_speed_forced from 
reset function,

and add the phydev interface update in the next patch.


