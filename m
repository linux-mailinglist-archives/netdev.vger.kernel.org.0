Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBB3BF40D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 04:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhGHCv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 22:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhGHCv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 22:51:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E14C061574;
        Wed,  7 Jul 2021 19:48:47 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t9so4429169pgn.4;
        Wed, 07 Jul 2021 19:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LLrZ4lTpT4PEvSU3gdKzg7LM4Q2Cp5vNhAVdG3/aQjY=;
        b=jyedqtdGm3wvc522gvEi2b4S3HVvgIylzg7YEv8XdcknfvzIREqlMGxSzg2aqhCRA0
         7UzvpoisARucy2cR5nEbBdlIh91sRfm+KSIeBZnoBfN/4FFjYOER+Wwckw7GYq4jOq9I
         LnP/ekV9zCjMyhGeeALWi+ItJxIMXXoOtjhIO/ovDMvU2yZwNCIfE7jsFtsb8hy53LV8
         G3S3DT7v8WC61mOhdeJRdvXz4DVkNcOlbFyn7HhEQlFu5DaBzUDDB0QwQJh7ScBLS99m
         HA5jEhVLtGZ20P7DgaukMeplc+zh4uz1gAgnQOrDHRdZ6vW2fYFiKKiv6NFcopTIazMg
         ODMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LLrZ4lTpT4PEvSU3gdKzg7LM4Q2Cp5vNhAVdG3/aQjY=;
        b=Jcsr/s5vps7hMNFZt/vxcjuRxCrlJmxYBhAm4WSWe6LHbwdZJGU245GDiZ+rEEVlyP
         6Qmr2/kEJoB4akhI0F0IcTPiSqofLCgIbUXRG15rgK1l00+ZfbEftkbX3XD/9lufPy2b
         RzSnzkHgCtiYYT2R6TYIG4Xg/Th2Eraer6pkF9G/qd/rgnA1bj5bNaglOkuRmH3yoBMu
         jxLtk9tIgfLLFepMLxXPh+ARPivWGR+wIBA/6GyHb3KQiir2LJDIBZX7w1Ms+Rmo0h1w
         ec3x9uO587CU3cQc8hoSUUmSzqLGP7AKPlnrvN8oRKDdDVCqH17dAPKN9OC8nTX1FwnQ
         6/fQ==
X-Gm-Message-State: AOAM532nIygQy1wyatRulG8vEZW28wvnqf+mob+NENTkazFGEJaaSq5R
        /wMVyqZTwLJLgeTX+P4QI1RIbnrwuGY=
X-Google-Smtp-Source: ABdhPJx5Ith6l4JzgYf8r40HEJ1j3MkQm9itNCUbid/QNdp9IUieUfq290x/eJLiGbAA4LQSf5SgcQ==
X-Received: by 2002:a05:6a00:1709:b029:308:747d:b7be with SMTP id h9-20020a056a001709b0290308747db7bemr29167852pfc.41.1625712526020;
        Wed, 07 Jul 2021 19:48:46 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n23sm504945pjq.2.2021.07.07.19.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 19:48:45 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
To:     Andrew Lunn <andrew@lunn.ch>, mohammad.athari.ismail@intel.com
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
Date:   Wed, 7 Jul 2021 19:48:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOZTmfvVTj9eo+to@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2021 6:23 PM, Andrew Lunn wrote:
> On Thu, Jul 08, 2021 at 08:42:53AM +0800, mohammad.athari.ismail@intel.com wrote:
>> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
>>
>> When the PHY wakes up from suspend through WOL event, there is a need to
>> reconfigure the WOL if the WOL option still enabled. The main operation
>> is to clear the WOL event status. So that, subsequent WOL event can be
>> triggered properly.
>>
>> This fix is needed especially for the PHY that operates in PHY_POLL mode
>> where there is no handler (such as interrupt handler) available to clear
>> the WOL event status.
> 
> I still think this architecture is wrong.
> 
> The interrupt pin is wired to the PMIC. Can the PMIC be modelled as an
> interrupt controller? That would allow the interrupt to be handled as
> normal, and would mean you don't need polling, and you don't need this
> hack.

I have to agree with Andrew here, and if the answer is that you cannot 
model this PMIC as an interrupt controller, cannot the config_init() 
callback of the driver acknowledge then disable the interrupts as it 
normally would if you were cold booting the system? This would also 
allow you to properly account for the PHY having woken-up the system.
-- 
Florian
