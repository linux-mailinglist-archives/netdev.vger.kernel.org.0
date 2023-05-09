Return-Path: <netdev+bounces-1119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E27B6FC41A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E75E21C20B26
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2708DDC1;
	Tue,  9 May 2023 10:40:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67F67C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:40:42 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DBA2D40;
	Tue,  9 May 2023 03:40:41 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so57509124a12.0;
        Tue, 09 May 2023 03:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683628839; x=1686220839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++f64RefmcF670/7QkgzMP/ms5dP0hwMYh5e7sZ2Wfs=;
        b=PlAKhuJfjPNioANrQ5U//3syWfdWU1yA1rz+TwN/CPDPZKU/slaXnAcT47GvezaVR6
         acGF9nnGWreoIYPRyqnlMg2NIMrThVsTI4SosaYEOjht4n/7Ey3I8Zl9+zso9Sj+HyoU
         F8SFJ9AAZvXX39D8JhlNIcAq6ZXGsouTj68xS7Vn/RxQ5AYac/3kpum9rBjyPqZwEk8l
         GqiM6qxFRca58G70aR1geH/oB13R7GNG6tHDzhW9G+QC07uwpxtlu9ZZXSKp8Fn2LoSB
         Jd9hpZ4eCRcEBAGFOjPeqxCu6rlZfvfncj/ZAUQGgRJQ+y2Hh4Qadz0aRYtDZ8Vg7SdZ
         TNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628839; x=1686220839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++f64RefmcF670/7QkgzMP/ms5dP0hwMYh5e7sZ2Wfs=;
        b=BW1BMY04kmkuCVpXCrk47echH+X3wxUkLO0aN0y5gz87rGfAqXVna2Ecbs/BmFUeih
         7aER4NmqQ4I6AxHj1Qygj14vvuaZocD/IqeULeVn/tKp4MnyU1H3MFL0SiyPcVdiBEN3
         nJuRnplz6jDfogbVs2vWJrgVwBWAyn/nNiXcgB4JDEuuHxs3TnjzcbTmDkbCZtELFNil
         kNJeZUR06Iee5sciFb2O8jkqkKlKxYoB8YNV/3wEbi+PEO+PM/HQdC0R6CAQfIh/RLbc
         Zkxze/1g/E4Vtn6zH47+ZIW0DnOAe5TUejbTrSL93RmI+URjJfYovav73KerZgWXizpO
         jQcA==
X-Gm-Message-State: AC+VfDzNKlA0cQTbhpKfr1NfDugZ75JcHv9OsLnyty9tLryBPX5WBQGc
	NeUmeaM4sMPjq101nhbkaOI=
X-Google-Smtp-Source: ACHHUZ6NhGDoFk1rVzFxBjdZCzHQUPjukBjnaZ96rq8x5tr7nqUVpC7Fq9ztcxDWUyChf1eSchS/+g==
X-Received: by 2002:aa7:dd42:0:b0:50c:804:20bb with SMTP id o2-20020aa7dd42000000b0050c080420bbmr12166306edw.16.1683628839225;
        Tue, 09 May 2023 03:40:39 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7655:7200:7d37:a922:8b7f:288b? (dynamic-2a01-0c22-7655-7200-7d37-a922-8b7f-288b.c22.pool.telefonica.de. [2a01:c22:7655:7200:7d37:a922:8b7f:288b])
        by smtp.googlemail.com with ESMTPSA id s24-20020aa7d798000000b0050bc37ff74asm632741edq.44.2023.05.09.03.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 03:40:38 -0700 (PDT)
Message-ID: <973341c8-a8b1-840d-6e6b-d8a73aa7a946@gmail.com>
Date: Tue, 9 May 2023 12:40:37 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2] net: phy: dp83867: add w/a for packet errors seen
 with short cables
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230509052124.611875-1-s-vadapalli@ti.com>
 <7a53f0d3-3e9a-4024-6b19-72ad9c19ab97@gmail.com>
 <bb7d6644-38b9-c807-6ef2-45a9d5acefe9@ti.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <bb7d6644-38b9-c807-6ef2-45a9d5acefe9@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09.05.2023 12:27, Siddharth Vadapalli wrote:
> 
> 
> On 09/05/23 14:29, Heiner Kallweit wrote:
>> On 09.05.2023 07:21, Siddharth Vadapalli wrote:
>>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>>
>>> Introduce the W/A for packet errors seen with short cables (<1m) between
>>> two DP83867 PHYs.
>>>
>>> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
>>> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
>>> and soft resets as follows:
>>>
>>> write_reg(0x001F, 0x8000); //hard reset
>>> write_reg(DSP_FFE_CFG, 0x0E81);
>>> write_reg(0x001F, 0x4000); //soft reset
>>>
>>> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
>>> affect Long Cable performance.", enable the W/A by default.
>>>
>>> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>> ---
>>>
>>> V1 patch at:
>>> https://lore.kernel.org/r/20230508070019.356548-1-s-vadapalli@ti.com
>>>
>>> Changes since v1 patch:
>>> - Wrap the line invoking phy_write_mmd(), limiting it to 80 characters.
>>> - Replace 0X0E81 with 0x0e81 in the call to phy_write_mmd().
>>> - Replace 0X012C with 0x012c in the new define for DP83867_DSP_FFE_CFG.
>>>
>>> RFC patch at:
>>> https://lore.kernel.org/r/20230425054429.3956535-2-s-vadapalli@ti.com/
>>>
>>> Changes since RFC patch:
>>> - Change patch subject to PATCH net.
>>> - Add Fixes tag.
>>> - Check return value of phy_write_mmd().
>>>
>>>  drivers/net/phy/dp83867.c | 18 +++++++++++++++++-
>>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>>> index d75f526a20a4..bbdcc595715d 100644
>>> --- a/drivers/net/phy/dp83867.c
>>> +++ b/drivers/net/phy/dp83867.c
>>> @@ -44,6 +44,7 @@
>>>  #define DP83867_STRAP_STS1	0x006E
>>>  #define DP83867_STRAP_STS2	0x006f
>>>  #define DP83867_RGMIIDCTL	0x0086
>>> +#define DP83867_DSP_FFE_CFG	0x012c
>>>  #define DP83867_RXFCFG		0x0134
>>>  #define DP83867_RXFPMD1	0x0136
>>>  #define DP83867_RXFPMD2	0x0137
>>> @@ -941,8 +942,23 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>>>  
>>>  	usleep_range(10, 20);
>>>  
>>> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
>>> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>>>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>
>> Would be good to add a comment here explaining what this magic write does.
> 
> Sure. Is the following comment acceptable?
> 
> "Configure the DSP Feedforward Equalizer Configuration register to improve short
> cable (< 1 meter) performance. This will not affect long cable performance."
> 
Sounds good. Important is just that the magic value write is explained, so that
readers of the source code don't have to scroll through the commit history.

>>
>>> +	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG,
>>> +			    0x0e81);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>> +	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>> +	usleep_range(10, 20);
>>> +
>>> +	return 0;
>>>  }
>>>  
>>>  static void dp83867_link_change_notify(struct phy_device *phydev)
>>
> 


