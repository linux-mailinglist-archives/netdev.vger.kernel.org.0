Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EF52EB4AC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbhAEVHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbhAEVHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 16:07:43 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214D6C061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 13:07:03 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id w5so502301wrm.11
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 13:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZzsQddsS+UpEQBUjQeF8o3OiMkNF0KbAGCaAU3dOgmI=;
        b=rpnYLZpfAxkInjhpXuIbuz+Mq4LsA0rXuQOrq7F4dLTH8h39K9xG3xbrIdyvhsrW8P
         vO60vDRuiy8HxK9FGDsLooB8K2ODE2H9ORCBvwiPvRCNUtiPsNl2185YL6RH94+qMM+r
         4AUIhgTSNmT/xAE6NMjLBM2if4XEITF25SfZLBRNWzv4ncues43LBmbeJowGpRaC2p5M
         pUvURwhtjxrNCoXzX0vOfL9h6QOLN/jnnzWZCdSN8m315G9pTC3XDMlguCdBcp92zkWv
         kOHR0JbmpN3/GAPjKi79PxR5u5bbzD8hW8L813mqEaKjCgMvK/L1oxFF/ROhBwKaPfnY
         58hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZzsQddsS+UpEQBUjQeF8o3OiMkNF0KbAGCaAU3dOgmI=;
        b=Gq+6rCqtTwdbqZmJWE/apEKuZy4col+dhmkFMc5Vb6DKvsOYzJttbbU2oMZgjvYMZp
         6jTFmsm2WgjtfDQ8mBiWNIrZxHqXWSjPC2oww9hQOk2ls1tWMB0btKU5VfplJ0fUHMuT
         BHFO2BBPfBshxuw08gsZNrAZTj3N7A7jBP6hjOnGlc4T3v8b1zux81Z/x9UDfjo94iHv
         ttuY4XHNsVxgemfug2RNdLbXu9BcM/Ee/B6eJlzwuJ4OFvI5SUaSv3AQKp83o7UxtxUO
         AE4D2AXnZh4Bf/ZwyP/ZchMFiXuJglO2gzozHHJyc5rjHW9lOZaS4EP09DzPqAzFhc9a
         G5Cw==
X-Gm-Message-State: AOAM530SfWHEg/bdUEAADromJ8UktOyMwvLeb+JjGV5+EkTrhynrabIu
        1qDjkIrMe+04m3KQP8JHcPg=
X-Google-Smtp-Source: ABdhPJwwa06GmzTRa3/2Escu0nciJQzCzcHO5gs46iT40ztUhy8LLCl5rQBBWMjjoOq8J3RDi5dLXQ==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr1280012wrn.245.1609880821822;
        Tue, 05 Jan 2021 13:07:01 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:303d:91bf:ac5c:51a1? (p200300ea8f065500303d91bfac5c51a1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:303d:91bf:ac5c:51a1])
        by smtp.googlemail.com with ESMTPSA id b12sm6100807wmj.2.2021.01.05.13.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 13:07:01 -0800 (PST)
Subject: Re: [PATCH] net: phy: Trigger link_change_notify on PHY_HALTED
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
References: <20210105161136.250631-1-marex@denx.de>
 <06732cde-8614-baa1-891a-b80a35cabcbc@gmail.com>
 <20210105170501.GE1551@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ce5c40cf-ae20-85d9-e188-8b097a2c7c81@gmail.com>
Date:   Tue, 5 Jan 2021 22:06:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105170501.GE1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.2021 18:05, Russell King - ARM Linux admin wrote:
> On Tue, Jan 05, 2021 at 05:58:21PM +0100, Heiner Kallweit wrote:
>> On 05.01.2021 17:11, Marek Vasut wrote:
>>> @@ -1021,8 +1022,17 @@ void phy_stop(struct phy_device *phydev)
>>>  	if (phydev->sfp_bus)
>>>  		sfp_upstream_stop(phydev->sfp_bus);
>>>  
>>> +	old_state = phydev->state;
>>>  	phydev->state = PHY_HALTED;
>>>  
>>> +	if (old_state != phydev->state) {
>>
>> This check shouldn't be needed because it shouldn't happen that
>> phy_stop() is called from status PHY_HALTED. In this case the
>> WARN() a few lines above would have fired already.
> 
> That is incorrect. If an error happens with the phy, phy_error() will
> be called, which sets phydev->state = PHY_HALTED. If you then
> subsequently take the interface down, phy_stop() will be called, but
> phydev->state will be set to PHY_HALTED.
> 
OK, so we have to fix the way phy_error() works. Still the check isn't
needed here. So far nobody is interested in transitions to PHY_HALTED,
so nothing is broken.

> This is a long standing bug since you changed the code, and I think is
> something I've reported previously, since I've definitely encountered
> it.
> 
IIRC there was a start of a discussion whether phy_error() is useful
at all regarding how it works as of today. A single failed MDIO access
(e.g. timeout) stops the state machine, when e.g. one missed PHY status
update in polling mode doesn't really cause any harm.
If we want to keep the functionality of phy_error(), then I'd say
a separate error phy state (e.g. PHY_ERROR) would make sense, as it
would make clear that the network was stopped due to an error.
