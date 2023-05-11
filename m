Return-Path: <netdev+bounces-1898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E29FE6FF6EE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6494E281814
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F9B46A1;
	Thu, 11 May 2023 16:17:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE12206A9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:17:24 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DFAE70;
	Thu, 11 May 2023 09:17:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64115e652eeso59152747b3a.0;
        Thu, 11 May 2023 09:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683821843; x=1686413843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hWigqkmbwjH+qj3HGTAq3LiZQSthJU7TTJei/KtCz3g=;
        b=Jp1MM5zIbOC3i2hi5NdnJJmDqd3d2Rnhtlgw5+jQUuy5eqkiQp6/+5+pp0Lvru6PcD
         b6s+xNjGNIS5mo2Vcs2gq6pLhRq6MxMQWXxnJMzKMyGPRBN6uVk0vZb1bvSiOf3o+Fk3
         i9jaGw1USscmRimFSbu3Ieqx5LSP1wd2Y+4N2agK3FRRBzvlV63EP/dHFg10g6HH9LTa
         VlMXO2N6xJOMDlqdEp8Q71knZoyCcGreepvR4xfkD1X5GPaYSQulMI9v2jgY1xy8LlMR
         OYrysA98QUxjt8zPVYuCE6wU/cwl7YuAmO9RA1pTV6RdMhJnCBuQPEDtxaOBASc0/WTW
         jezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683821843; x=1686413843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWigqkmbwjH+qj3HGTAq3LiZQSthJU7TTJei/KtCz3g=;
        b=VzFJlAVqHMoJHOmicC1aEHXVMHIlLFB18kJ2G05HBWj17IFo3fNEjqLdn9iU4+Hfh4
         F0/Fn2TVXoYQ5uYZTT70+Dq9WX287DVRW4om4hR697x9QdC8Dty5Z4ynyABBN/c6anF2
         yTQc+cvkQTq51xR57Nxlgx30iy8CfSPCaBjE9pR7eQ6fYp6+O2KbKf/f57K7RiybpFoX
         D5Rx5JnOA8BR5KYs5OFEznkru9/wyK2e+NDdLMAZl+0h0+opIXrys2taTsOmTLMiL8CE
         LLptU89gs4Ugg0Q+auviTuPNH4/KZAMYC94UQHfxScHN7WeT1iBJDMECBTsPjZ0+DbYX
         R6Sg==
X-Gm-Message-State: AC+VfDwlmoHHb2qMB3UAIJXkiBSmcAF6vg1TmkJS2QzfQT4Gy443LCgn
	I9h7lFcA34FcAIUeTaiRvqU=
X-Google-Smtp-Source: ACHHUZ4sv20ghK1eTdLmYspjK4wvNz7eoffWCAy6KbdvGlMSgAPxDSiU53v1bB/4D3cnwFEYfmG+cw==
X-Received: by 2002:a17:90b:3ece:b0:24e:3413:c7ff with SMTP id rm14-20020a17090b3ece00b0024e3413c7ffmr32458870pjb.7.1683821842539;
        Thu, 11 May 2023 09:17:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bj8-20020a17090b088800b00247164c1947sm10638556pjb.0.2023.05.11.09.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 09:17:21 -0700 (PDT)
Message-ID: <e459ad06-e261-91a0-1c42-d9135b9ca6b5@gmail.com>
Date: Thu, 11 May 2023 09:17:19 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
Content-Language: en-US
To: Paolo Abeni <pabeni@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>,
 netdev@vger.kernel.org
Cc: Doug Berger <opendmb@gmail.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
 Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
 <20230509223403.1852603-3-f.fainelli@gmail.com>
 <8aebd38cf057cf659d5133527f55e1ced0e6f70c.camel@redhat.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <8aebd38cf057cf659d5133527f55e1ced0e6f70c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 03:26, Paolo Abeni wrote:
> Hi,
> 
> On Tue, 2023-05-09 at 15:34 -0700, Florian Fainelli wrote:
>> @@ -821,7 +917,28 @@ static int bcm54xx_phy_probe(struct phy_device *phydev)
>>   	if (IS_ERR(priv->ptp))
>>   		return PTR_ERR(priv->ptp);
>>   
>> -	return 0;
>> +	/* We cannot utilize the _optional variant here since we want to know
>> +	 * whether the GPIO descriptor exists or not to advertise Wake-on-LAN
>> +	 * support or not.
>> +	 */
>> +	wakeup_gpio = devm_gpiod_get(&phydev->mdio.dev, "wakeup", GPIOD_IN);
>> +	if (PTR_ERR(wakeup_gpio) == -EPROBE_DEFER)
>> +		return PTR_ERR(wakeup_gpio);
>> +
>> +	if (!IS_ERR(wakeup_gpio)) {
>> +		priv->wake_irq = gpiod_to_irq(wakeup_gpio);
>> +		ret = irq_set_irq_type(priv->wake_irq, IRQ_TYPE_LEVEL_LOW);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	/* If we do not have a main interrupt or a side-band wake-up interrupt,
>> +	 * then the device cannot be marked as wake-up capable.
>> +	 */
>> +	if (!bcm54xx_phy_can_wakeup(phydev))
>> +		return ret;
> 
> AFAICS, as this point 'ret' is 0, so the above is confusing. Do you
> intend the probe to complete successfully? If so, would not be
> better/more clear:
> 
> 		return 0;

Yes probe needs to be successful if bcm54xx_phy_can_wakeup() returns 
false, will change to return 0 to make that clearer. Thanks!
-- 
Florian


