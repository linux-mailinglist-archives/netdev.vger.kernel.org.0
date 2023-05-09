Return-Path: <netdev+bounces-1116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA276FC3D9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9ABD1C20B4B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92345DDDA;
	Tue,  9 May 2023 10:28:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D368BE8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:28:00 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CCADC6C;
	Tue,  9 May 2023 03:27:58 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 349ARboc043784;
	Tue, 9 May 2023 05:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683628057;
	bh=J+aJ87Wk8u/OIKkswXL4WuenR3rbc+J67mfSul8Awmk=;
	h=Date:CC:Subject:To:References:From:In-Reply-To;
	b=ZkOdIr8VF757n5ofAIAtwfjjQuhyjRTFoziyg0Cgi3S/51UjDjcIIjwMum6MrigPo
	 b8RA534KHtulontOcyv1rh6964O8ZojM+CgglEkzzqcXv+WQXHKALYUqDt032WVfdu
	 SpT/sULc9vgb9kX8+gkTwFq4K17oIyCDJNFT9eSY=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 349ARbOj008095
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 9 May 2023 05:27:37 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 9
 May 2023 05:27:37 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 9 May 2023 05:27:36 -0500
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 349ARXah015938;
	Tue, 9 May 2023 05:27:34 -0500
Message-ID: <bb7d6644-38b9-c807-6ef2-45a9d5acefe9@ti.com>
Date: Tue, 9 May 2023 15:57:33 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
CC: <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net v2] net: phy: dp83867: add w/a for packet errors seen
 with short cables
Content-Language: en-US
To: Heiner Kallweit <hkallweit1@gmail.com>
References: <20230509052124.611875-1-s-vadapalli@ti.com>
 <7a53f0d3-3e9a-4024-6b19-72ad9c19ab97@gmail.com>
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <7a53f0d3-3e9a-4024-6b19-72ad9c19ab97@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 09/05/23 14:29, Heiner Kallweit wrote:
> On 09.05.2023 07:21, Siddharth Vadapalli wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Introduce the W/A for packet errors seen with short cables (<1m) between
>> two DP83867 PHYs.
>>
>> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
>> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
>> and soft resets as follows:
>>
>> write_reg(0x001F, 0x8000); //hard reset
>> write_reg(DSP_FFE_CFG, 0x0E81);
>> write_reg(0x001F, 0x4000); //soft reset
>>
>> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
>> affect Long Cable performance.", enable the W/A by default.
>>
>> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>
>> V1 patch at:
>> https://lore.kernel.org/r/20230508070019.356548-1-s-vadapalli@ti.com
>>
>> Changes since v1 patch:
>> - Wrap the line invoking phy_write_mmd(), limiting it to 80 characters.
>> - Replace 0X0E81 with 0x0e81 in the call to phy_write_mmd().
>> - Replace 0X012C with 0x012c in the new define for DP83867_DSP_FFE_CFG.
>>
>> RFC patch at:
>> https://lore.kernel.org/r/20230425054429.3956535-2-s-vadapalli@ti.com/
>>
>> Changes since RFC patch:
>> - Change patch subject to PATCH net.
>> - Add Fixes tag.
>> - Check return value of phy_write_mmd().
>>
>>  drivers/net/phy/dp83867.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>> index d75f526a20a4..bbdcc595715d 100644
>> --- a/drivers/net/phy/dp83867.c
>> +++ b/drivers/net/phy/dp83867.c
>> @@ -44,6 +44,7 @@
>>  #define DP83867_STRAP_STS1	0x006E
>>  #define DP83867_STRAP_STS2	0x006f
>>  #define DP83867_RGMIIDCTL	0x0086
>> +#define DP83867_DSP_FFE_CFG	0x012c
>>  #define DP83867_RXFCFG		0x0134
>>  #define DP83867_RXFPMD1	0x0136
>>  #define DP83867_RXFPMD2	0x0137
>> @@ -941,8 +942,23 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>>  
>>  	usleep_range(10, 20);
>>  
>> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
>> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
>> +	if (err < 0)
>> +		return err;
>> +
> 
> Would be good to add a comment here explaining what this magic write does.

Sure. Is the following comment acceptable?

"Configure the DSP Feedforward Equalizer Configuration register to improve short
cable (< 1 meter) performance. This will not affect long cable performance."

> 
>> +	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG,
>> +			    0x0e81);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	usleep_range(10, 20);
>> +
>> +	return 0;
>>  }
>>  
>>  static void dp83867_link_change_notify(struct phy_device *phydev)
> 

-- 
Regards,
Siddharth.

