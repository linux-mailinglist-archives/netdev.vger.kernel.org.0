Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3076C4FD2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCVQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCVQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:00:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660AB50F93;
        Wed, 22 Mar 2023 09:00:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l7so1878405pjg.5;
        Wed, 22 Mar 2023 09:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679500806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7fsNSRb4r7+1es6jl4TDUEgI6uhuTdjKz7luKjMrgiE=;
        b=jS5bLdTjwhg+BEt0oGwmsHaFi7ZsfoDqG6WH3EglecB+0CDexv7d4XFOe/MlF8WZwQ
         dwD9N29dvNPcYZ1CwN7t0/mPkISYARzglYWG8binEEdyZQeUeduXMXb2YG4Euk6oBeQ3
         LpN2REnLg6NIeSrMETjwRJ/ElRZ8fdRYytQCx9dD4K9tF4eCsZ9sLotoB3japT3mqirL
         dv59HgIL2ksOcHHy6fo4/+E8TKmDAVIn8KRqdw53du0flgoUMwdJwec4kIP2aRfjizW3
         5S2QuXNx3SX6aAp/ipDdaoweJxrP1qlWnz49sD8MoTJncskfqPAuk/QE8mWjUq3RRCqx
         gdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679500806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fsNSRb4r7+1es6jl4TDUEgI6uhuTdjKz7luKjMrgiE=;
        b=LEFVZHDJ65infeNS8Np6ZyVvYp+DQSFbrUGxIgdDfOcZoAF11VyXpfoxMaMCZ6XoBt
         mbIoayQlB/tQVOITBrnonkkGLzfjzW1iBu6wSWOKPEMCeniRI+UNSK+FmKNAR2KLNtW+
         5VAjloaE7La16YDHuqET6Hy5oD0S0sEyHqkuLyfJ7qz86fTv38Mw6mDZHwgUhymLnd5R
         m9th5katSQ87re2xcMO7++2yz8ZiBiqV8yTpizzKboA69VWFA68+vNYaom4PgcpBYcXK
         2bCCOTJUQX1fjfACd9Zji6+Gw3Xgp9D0zQpwkRiDuLNKQwQjmj4qXseu0nvqy8ZqwluN
         A9fw==
X-Gm-Message-State: AO0yUKU3vgG9BN7ddVy9fqdVXu8phBwtD57MJgHLzDNjl0PH/9MPWkkC
        QafwqF+VPMBvkgQ9uSc3HSk=
X-Google-Smtp-Source: AK7set+X6Vh7hPC+IqH2RMIDGpUxhrDw5EBkXQ/ogkXL366bKHCV95bigzMdhhQmaq5xtBed9jTsZQ==
X-Received: by 2002:a17:90b:3ec7:b0:23e:feef:38ef with SMTP id rm7-20020a17090b3ec700b0023efeef38efmr3997903pjb.41.1679500805706;
        Wed, 22 Mar 2023 09:00:05 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001a1a18a678csm10811329plk.148.2023.03.22.09.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 09:00:04 -0700 (PDT)
Message-ID: <95ee76d7-7668-43b2-29e8-aab8a4281ab5@gmail.com>
Date:   Wed, 22 Mar 2023 09:00:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net: phy: Improved phy_error() with function and
 error code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230320213451.2579608-1-f.fainelli@gmail.com>
 <20230321214124.19f29406@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321214124.19f29406@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/21/2023 9:41 PM, Jakub Kicinski wrote:
> On Mon, 20 Mar 2023 14:34:51 -0700 Florian Fainelli wrote:
>> +static inline void phy_error(struct phy_device *phydev)
>> +{
>> +	phy_error_precise(phydev, (const void *)_RET_IP_, -EIO);
>> +}
> 
> LGTM apart from this _RET_IP_ here. Wouldn't this make @func
> sometimes the function that returned the error and sometimes
> the caller? The caller is in the stack trace already, so no
> need to duplicate. Besides how dependable is using _RET_IP_
> inside a static inline?

You have a point that the existing phy_error() already has a WARN_ON() 
that will tell us which function it has been invoked from whenever 
phy_error() is used outside of the phy_state_machine(), expect a v2 shortly.
-- 
Florian
