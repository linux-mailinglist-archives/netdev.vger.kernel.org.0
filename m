Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32EB8EF9A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfHOPne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:43:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47019 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730754AbfHOPnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:43:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id m3so856107pgv.13
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9HCbTE9E3+dXR5PaAmg1/nd6e97REt+InnYZP6O2Ma0=;
        b=KY9AH0rHketUSx4vEjMtuv89Rr2Lyibezia3bmj58A5oQx7DfAGUlmwOTl4FayqYXY
         R2SBvVWYaMldM/ZxXf0OHRx20KgiblShaAFsprU7KTB+NknBRcWVpKFa6LB/BFpj5a/q
         UOO911LaYtqqOsQWfP5bkdTt7eoCreNv7TM53uCYCfofokpd1GFiILfAuvSgl3MPJ1Yk
         CMIRKUgglLyEQiUjheYFtSPBPIWBI4FxsLKXp9C01x9sOLW9h8WPtD84LYh9//BdVhRe
         /MXj9EB9KB/BKnH1kKCxQmM9+lnd+FCkHoEA/i+P0PW3VzHz9zXnZpU7Uhw/7zJ9Q07p
         B2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9HCbTE9E3+dXR5PaAmg1/nd6e97REt+InnYZP6O2Ma0=;
        b=s0GlcvfOL/ShFBqXhbRFjUkz8q0bhTeGO4D31J/2+hRkBFmDIrRUrzGxHSXVksXcHT
         6ZW+ENUEkGLP3PdpbVHYrzpdw8bVHfR70y2Xh1UUQHxOUmDFVexMdQ6qJWnMaouW89h1
         ZMrTPFV+ImhzLWK6uFG1W7U8JcVTpqcUqPrA82WPrRGBBTi0nJRi2MtsQn3YCbQ2gKDZ
         vva+Nh+yETNezXG17x3N+zNFLdK9aTrO6LXg1JXDDi1QQzJoz+S6/3S2ltjz5mTQrf31
         KjcDJ1pgA5xm/2B6/ioak3KDglV7H7L8wyUTPsruU2sN5xkJYy12vd4yEwhUSDS459K3
         PDZg==
X-Gm-Message-State: APjAAAVJen4FeXxhlmU6ozUUn8ZI4IRB/qnCjHpxNs3m3MCFO3sqOho0
        h9cGio2wqq3Kkxq9bD61PneehRQH
X-Google-Smtp-Source: APXvYqzGq1+fCV5yRDiYmLPX/8weSuRDTkbdT+uRMeq+0hpTQ1rk2MoVojK6/LLpqx3Vay27T3W3eg==
X-Received: by 2002:a63:b102:: with SMTP id r2mr3933421pgf.370.1565883812516;
        Thu, 15 Aug 2019 08:43:32 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm3193440pfo.24.2019.08.15.08.43.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:43:31 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] r8169: use the generic EEE management
 functions
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
 <c5a137b1-d9d3-070c-55a1-938d6b77bdbc@gmail.com>
 <20190815123558.GA31172@lunn.ch>
 <bfd67eb3-0da7-b8a5-928a-a66802185b68@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <24146e48-c498-d13a-8c12-76519455d0d4@gmail.com>
Date:   Thu, 15 Aug 2019 08:43:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bfd67eb3-0da7-b8a5-928a-a66802185b68@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 6:02 AM, Heiner Kallweit wrote:
> On 15.08.2019 14:35, Andrew Lunn wrote:
>> On Thu, Aug 15, 2019 at 11:47:33AM +0200, Heiner Kallweit wrote:
>>> Now that the Realtek PHY driver maps the vendor-specific EEE registers
>>> to the standard MMD registers, we can remove all special handling and
>>> use the generic functions phy_ethtool_get/set_eee.
>>
>> Hi Heiner
>>
> Hi Andrew,
> 
>> I think you should also add a call the phy_init_eee()?
>>
> I think it's not strictly needed. And few things regarding
> phy_init_eee are not fully clear to me:
> 
> - When is it supposed to be called? Before each call to
>   phy_ethtool_set_eee? Or once in the drivers init path?
> 
> - The name is a little bit misleading as it's mainly a
>   validity check. An actual "init" is done only if
>   parameter clk_stop_enable is set.
> 
> - It returns -EPROTONOSUPPORT if at least one link partner
>   doesn't advertise EEE for current speed/duplex. To me this
>   seems to be too restrictive. Example:
>   We're at 1Gbps/full and link partner advertises EEE for
>   100Mbps only. Then phy_init_eee returns -EPROTONOSUPPORT.
>   This keeps me from controlling 100Mbps EEE advertisement.  

That function needs a complete rework, it does not say what its name
implies, and there is an assumption that you have already locally
advertised EEE for it to work properly, that does not make any sense
since the whole purpose is to see whether EEE can/will be active with
the link partner (that's how I read it at least).

Regarding whether the clock stop enable can be turned on or off is also
a bit suspicious, because a MAC driver does not know whether the PHY
supports doing that, I had started something in that area years ago:

https://github.com/ffainelli/linux/commits/phy-eee-tx-clk
-- 
Florian
