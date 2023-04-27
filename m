Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E076F0105
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbjD0Gqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjD0Gqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:46:31 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7821A6;
        Wed, 26 Apr 2023 23:46:29 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 7851F24E28D;
        Thu, 27 Apr 2023 14:46:28 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 27 Apr
 2023 14:46:28 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 27 Apr
 2023 14:46:27 +0800
Message-ID: <988e7ff1-ef0e-6224-98fb-e3d564806477@starfivetech.com>
Date:   Thu, 27 Apr 2023 14:46:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg
 support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Frank Sae <Frank.Sae@motor-comm.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-3-samin.guo@starfivetech.com>
 <11f0641a-ef6c-eee8-79f3-45654ae006d5@motor-comm.com>
 <4c935728-ab18-4941-9621-c26e3b3799f7@lunn.ch>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <4c935728-ab18-4941-9621-c26e3b3799f7@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg support
From: Andrew Lunn <andrew@lunn.ch>
to: Frank Sae <Frank.Sae@motor-comm.com>
data: 2023/4/26

>>> +	u32 val;
>>>  
>>>  	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
>>>  	if (ret < 0)
>>> @@ -1518,6 +1524,32 @@ static int yt8531_config_init(struct phy_device *phydev)
>>>  			return ret;
>>>  	}
>>>  
>>> +	if (!of_property_read_u32(node, "rx-clk-driver-strength", &val)) {
>>
>> Please check the val of "val", add the handle of default value.
> 
> You can assign val to 3, or better still some #define, before calling
> of_property_read_u32(). If the property is not found, val will retain
> that value, and you can then write it to the register.
> 
> But please do add range checks for when val is in DT. We don't want
> anybody using 42. -EINVAL should be returned.
> 
> 	Andrew

Thanks, good advice. 

Best regards,
Samin
