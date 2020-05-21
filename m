Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D791DD26A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgEUPz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgEUPz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:55:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4673EC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:55:26 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so1997817plv.9
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 08:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CRV7UL+kTXX1vMOraYoevV1kAZTs6Actk/7tOMORPn4=;
        b=PfiyRoCDe6wZR5itRA/WBdHnCjoAOSS7P3cXywGhTtDsX0biIa+oyXYDIK+Xh1kXHk
         rv6oF21Oc1xUIHDaOmgnia/QgW/ucYfJs7i/1RqRBYySgCn7z02Fecr302NmCKUnfy3G
         q29cwGikolpi4tgLRmtl55/VTgC2OEBmTos+VYTiQ5Wf++yT7ipJf97JVy558Lopv77n
         soXDjteHkpI2qd1MeyTG28H52BRAk0kiBdw4dtydJ1SpSls35a4oVaobNzHKjmFQAA2l
         Mfrl0CFJjquh9kvbOXb7czIPabq+BpZcICUJqwaQiw0iXcEoBpWfb9gR/kHMm9sXprIb
         SQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CRV7UL+kTXX1vMOraYoevV1kAZTs6Actk/7tOMORPn4=;
        b=LHPsMLp0MAVNnLZC5oPNTCUZ6PylxVgdADHC4K6HKulwObyRll+/5p26Cq4uxWl0EP
         k1TG9azTScip0zY+nIdLUcN1DkDDcDRoZgiwh4LEt8t+Q8LI4efKE1vLreHHRD+w+gfi
         xYOldlbqzcRA5GSuAVXMk4tW5o7dNWvZzH34gmK1cVicoS2c0ZirzjDKK2StfahocNHl
         G7tDcFH7B3Qo6Y6OuL94559q0lnieadsrBb2iEvlsF9DDFjXNaPLJsRnRC9+DAY3FKGx
         ry0DYMuZcyyxZ+31o3nXTet1FssrhS49SDiWr1m5daGpwTcO2e31lVDldzJ5mgF6d4+l
         xO8w==
X-Gm-Message-State: AOAM533awppWCF4civ45sb8Q0rOKV0DiFcF9gFj4YR1SKseT4TI6toca
        FWoTu4+321hRe8dLRKZONhbBJqT+
X-Google-Smtp-Source: ABdhPJx9N7k8n59o1Plq/UKvotCsROYWk9fkg9AYprNcyq+KePy8bhxJWCOo/tXibvntyz1PVT+ZVg==
X-Received: by 2002:a17:90a:a60a:: with SMTP id c10mr11820390pjq.143.1590076525720;
        Thu, 21 May 2020 08:55:25 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm4771325pfl.28.2020.05.21.08.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 08:55:24 -0700 (PDT)
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com
References: <3268996.Ej3Lftc7GC@tool> <20200521151916.GC677363@lunn.ch>
 <20200521152656.GU1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b9073792-940f-4f82-60fb-03c69a0ccca0@gmail.com>
Date:   Thu, 21 May 2020 08:55:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521152656.GU1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/2020 8:26 AM, Russell King - ARM Linux admin wrote:
> On Thu, May 21, 2020 at 05:19:16PM +0200, Andrew Lunn wrote:
>>>  drivers/net/ethernet/marvell/mvneta.c | 7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
>>> index 41d2a0eac..f9170bc93 100644
>>> --- a/drivers/net/ethernet/marvell/mvneta.c
>>> +++ b/drivers/net/ethernet/marvell/mvneta.c
>>> @@ -3567,8 +3567,9 @@ static void mvneta_start_dev(struct mvneta_port *pp)
>>>  
>>>  	phylink_start(pp->phylink);
>>>  
>>> -	/* We may have called phy_speed_down before */
>>> -	phy_speed_up(pp->dev->phydev);
>>> +	if(pp->dev->phydev)
>>> +		/* We may have called phy_speed_down before */
>>> +		phy_speed_up(pp->dev->phydev);
>>
>> I don't think it is as simple as this. You should not really be mixing
>> phy_ and phylink_ calls within one driver. You might of noticed there
>> are no other phy_ calls in this driver. So ideally you want to add
>> phylink_ calls which do the right thing.
> 
> And... what is mvneta doing getting the phydev?  I removed all that
> code when converting it to phylink, since the idea with phylink is
> that the PHY is the responsibility of phylink not the network driver.
> 
> I hope the patch adding pp->dev->phydev hasn't been merged as it's
> almost certainly wrong.

This is already merged, this is a follow from a bisection that Andrew run.

There should be a phylink_phy_speed_{up,down} to maintain the PHYLINK
abstraction, and the functionality is useful beyond PHYLIB.
--
Florian
