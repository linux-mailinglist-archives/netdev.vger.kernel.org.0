Return-Path: <netdev+bounces-1471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4086FDDF0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFADC280BEB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E2E20B42;
	Wed, 10 May 2023 12:38:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065D320B23
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:38:27 +0000 (UTC)
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A06C1B8;
	Wed, 10 May 2023 05:38:26 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34ACc1uf053969;
	Wed, 10 May 2023 07:38:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683722281;
	bh=zFq4KccH35g8kznXC9T1SM+QYksc0Pr00h0voWgt8fg=;
	h=Date:CC:Subject:To:References:From:In-Reply-To;
	b=Ix62POBJSVlTFGSj7fmyNcZ6bzFxXGxWNG+KS937YnA9Px6Cviw2/Z9SPejSD/iJ/
	 2MAvrI9yc6CYeRI/noa3Pv/TdglLOY90w5Cvq1zGJv9i6qzolrRWN11V3KXahsNPmY
	 BmBzOe9iSoYEq6kblbz7dBzlTZs8ItRlwBF+X5FI=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34ACc1JR073481
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 10 May 2023 07:38:01 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 10
 May 2023 07:38:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 10 May 2023 07:38:01 -0500
Received: from [10.249.138.110] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34ACbvKl081301;
	Wed, 10 May 2023 07:37:58 -0500
Message-ID: <f7fe6a12-3988-16e9-272e-a88ff0d7d0c1@ti.com>
Date: Wed, 10 May 2023 18:07:56 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
CC: <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net v2] net: phy: dp83867: add w/a for packet errors seen
 with short cables
To: Heiner Kallweit <hkallweit1@gmail.com>
References: <20230509052124.611875-1-s-vadapalli@ti.com>
 <7a53f0d3-3e9a-4024-6b19-72ad9c19ab97@gmail.com>
 <bb7d6644-38b9-c807-6ef2-45a9d5acefe9@ti.com>
 <973341c8-a8b1-840d-6e6b-d8a73aa7a946@gmail.com>
Content-Language: en-US
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <973341c8-a8b1-840d-6e6b-d8a73aa7a946@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 09-05-2023 16:10, Heiner Kallweit wrote:
> On 09.05.2023 12:27, Siddharth Vadapalli wrote:
>>
>>
>> On 09/05/23 14:29, Heiner Kallweit wrote:
>>> On 09.05.2023 07:21, Siddharth Vadapalli wrote:
>>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>
>>>> Introduce the W/A for packet errors seen with short cables (<1m) between
>>>> two DP83867 PHYs.
>>>>
>>>> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
>>>> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
>>>> and soft resets as follows:
>>>>
>>>> write_reg(0x001F, 0x8000); //hard reset
>>>> write_reg(DSP_FFE_CFG, 0x0E81);
>>>> write_reg(0x001F, 0x4000); //soft reset
>>>>
>>>> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
>>>> affect Long Cable performance.", enable the W/A by default.
>>>>
>>>> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>> ---
>>>>
>>>> V1 patch at:
>>>> https://lore.kernel.org/r/20230508070019.356548-1-s-vadapalli@ti.com
>>>>
>>>> Changes since v1 patch:
>>>> - Wrap the line invoking phy_write_mmd(), limiting it to 80 characters.
>>>> - Replace 0X0E81 with 0x0e81 in the call to phy_write_mmd().
>>>> - Replace 0X012C with 0x012c in the new define for DP83867_DSP_FFE_CFG.
>>>>
>>>> RFC patch at:
>>>> https://lore.kernel.org/r/20230425054429.3956535-2-s-vadapalli@ti.com/
>>>>
>>>> Changes since RFC patch:
>>>> - Change patch subject to PATCH net.
>>>> - Add Fixes tag.
>>>> - Check return value of phy_write_mmd().
>>>>
>>>>  drivers/net/phy/dp83867.c | 18 +++++++++++++++++-
>>>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>>>> index d75f526a20a4..bbdcc595715d 100644
>>>> --- a/drivers/net/phy/dp83867.c
>>>> +++ b/drivers/net/phy/dp83867.c
>>>> @@ -44,6 +44,7 @@
>>>>  #define DP83867_STRAP_STS1	0x006E
>>>>  #define DP83867_STRAP_STS2	0x006f
>>>>  #define DP83867_RGMIIDCTL	0x0086
>>>> +#define DP83867_DSP_FFE_CFG	0x012c
>>>>  #define DP83867_RXFCFG		0x0134
>>>>  #define DP83867_RXFPMD1	0x0136
>>>>  #define DP83867_RXFPMD2	0x0137
>>>> @@ -941,8 +942,23 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>>>>  
>>>>  	usleep_range(10, 20);
>>>>  
>>>> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
>>>> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>>>>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
>>>> +	if (err < 0)
>>>> +		return err;
>>>> +
>>>
>>> Would be good to add a comment here explaining what this magic write does.
>>
>> Sure. Is the following comment acceptable?
>>
>> "Configure the DSP Feedforward Equalizer Configuration register to improve short
>> cable (< 1 meter) performance. This will not affect long cable performance."
>>
> Sounds good. Important is just that the magic value write is explained, so that
> readers of the source code don't have to scroll through the commit history.

Thank you for letting me know. I will post the v3 patch with the comment.

> 
>>>
>>>> +	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG,
>>>> +			    0x0e81);
>>>> +	if (err < 0)
>>>> +		return err;
>>>> +
>>>> +	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
>>>> +	if (err < 0)
>>>> +		return err;
>>>> +
>>>> +	usleep_range(10, 20);
>>>> +
>>>> +	return 0;
>>>>  }
>>>>  
>>>>  static void dp83867_link_change_notify(struct phy_device *phydev)
>>>
>>
> 

-- 
Regards,
Siddharth.

