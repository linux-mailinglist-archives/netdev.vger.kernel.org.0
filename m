Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6704B6E155F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDMTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDMTqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:46:33 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCAC61BD
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:46:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i3so6009638wrc.4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681415190; x=1684007190;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FCLuFFf3NUujAkiRyxpG3Uk3xjFYCj1W2v7RnY8Ve38=;
        b=TwNsoOON2lYUqxjogLxw/FJLu0zs5Gfe1F0cTNiwusEuvnEbQESEpPrFqFpDwfVWGt
         WOpg309+rJfOzuDR5PI8+XFJtA486GiX7acG9gpDo0hUN6cH2uh8XZZQAqP3nyyGfDf5
         7d9pwXEMcIwUtuGZv0Sh85JI+j14vhWl+xq6fjmuOZDTOLM7ylYtcbE+jX69IUvAHKdx
         xpfRMQCX+ls6lXXVIo51soEm62J4kLHkVCmVxDDN5Fp3H1R2nFzRrVhwiVX6G/Ddd/Xq
         MKqGH34YY9qG81QitACQ374Y6nOvxYtCatOGx6ejiQlxaWuCaAyjQJ+0sFnc15zZ73bX
         I7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681415190; x=1684007190;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCLuFFf3NUujAkiRyxpG3Uk3xjFYCj1W2v7RnY8Ve38=;
        b=aTTPbWJ1ONQu3p4dV12F7aH6k3zxVFxynFjJ1AGeWNz+XinsCDrladS7hsuipIK8UE
         1yj2lyv7JN6K4nucRx5FOYDsGZSgHGRWeDZ1QMkkNrzg8vAumK1CL5/syQamV+16fCeK
         wiMrpsRy1xWf3aFJsf+4ivv5BNEaK6R0e6ulYvXjtCaKqDAvtlOSRh2pxN5YnulTQ1c5
         VZ/cJYB2g28yHcvBnMhTuVP1196KI7a+b3z+MCYXvDWo9O+YhXaFdybmRRGzHgQF2u3d
         Q1vDdIAJUCI3ZLhqbHtEwTbik0gzfCQfBUdUHzaT0dQIgryM6QBB7Pi7QFr0giB0nAAL
         Jfyw==
X-Gm-Message-State: AAQBX9edDYTIco2z+FsGps5E9muLH8dGqIlgFWD7fOJ7x9v7ZFqa4jyc
        3GMLFMbQri4N4vGasMG31OQ=
X-Google-Smtp-Source: AKy350b0webxHe9LEPxGh4u4M0rrq07Jkxelzt0JpfV82V71Qc9vjpuA1vNo8ONPB257K3Zes/5QmQ==
X-Received: by 2002:adf:e98f:0:b0:2ef:6d3c:ba48 with SMTP id h15-20020adfe98f000000b002ef6d3cba48mr2580634wrm.0.1681415190590;
        Thu, 13 Apr 2023 12:46:30 -0700 (PDT)
Received: from ?IPV6:2a01:c22:738e:4400:f580:be04:1a64:fc5e? (dynamic-2a01-0c22-738e-4400-f580-be04-1a64-fc5e.c22.pool.telefonica.de. [2a01:c22:738e:4400:f580:be04:1a64:fc5e])
        by smtp.googlemail.com with ESMTPSA id b3-20020adfde03000000b002efb2d861dasm1924942wrm.77.2023.04.13.12.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:46:30 -0700 (PDT)
Message-ID: <a1903ab4-1ef9-5bf5-55a1-6e039ca7712f@gmail.com>
Date:   Thu, 13 Apr 2023 21:46:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230411155706.1713311-1-vladimir.oltean@nxp.com>
 <e2ea17e9-2c6a-9a89-bb09-29eca8dbf6bc@gmail.com>
 <20230413135132.ybakyayxflai7tzy@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: add basic driver for NXP CBTX PHY
In-Reply-To: <20230413135132.ybakyayxflai7tzy@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2023 15:51, Vladimir Oltean wrote:
> Hi Heiner,
> 
> On Tue, Apr 11, 2023 at 06:49:42PM +0200, Heiner Kallweit wrote:
>>> +	return phy_set_bits(phydev, CBTX_PDOWN_CTRL,
>>> +			    CBTX_PDOWN_CTL_TRUE_PDOWN);
>>
>> A comment may be helpful explaining how true_pdown mode
>> is different from power-down mode set by C22 standard
>> bit in BMCR as part of genphy_suspend().
> 
> The NXP documentation for True Power Down vs General Power Down did not
> convince me, and I don't want to speculate and give an answer that might
> be incorrect.
> 
> There are not many people who can help me give an answer right now
> during the holidays. The high level idea is that the PHY may enter a
> mode of lower power consumption.
> 
> If it's acceptable to you, I can implement suspend and resume as direct
> calls to genphy_suspend() and genphy_resume(), and make the change later,
> if needed.
> 
No, it's no blocker for me. It may just be useful to know which additional
blocks are powered down and whether True Power Down comes with certain
constraints like e.g. parts of the register set not being accessible or
not reacting.

>>> +static int cbtx_config_intr(struct phy_device *phydev)
>>> +{
>>> +	int ret;
>>> +
>>> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
>>> +		ret = cbtx_ack_interrupts(phydev);
>>> +		if (ret < 0)
>>> +			return ret;
>>> +
>>> +		ret = phy_write(phydev, CBTX_IRQ_ENABLE,
>>> +				CBTX_IRQ_AN_COMPLETE | CBTX_IRQ_LINK_DOWN);
>>
>> I think you need also CBTX_IRQ_ENERGYON. Otherwise you won't get a
>> link-up interrupt in forced mode.
> 
> I've tested just now with "ethtool -s p1 autoneg off speed 100 duplex full",
> and you are exactly correct. I will add the media side energy detection logic
> to the enabled IRQ sources in v2. Thanks.

