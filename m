Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9388F340A8D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhCRQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhCRQsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:48:46 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF0C06174A;
        Thu, 18 Mar 2021 09:48:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x13so6268789wrs.9;
        Thu, 18 Mar 2021 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CqL/d3l/NRGUjaNstaW/nJgxQdVdoEya8rVF4Se8eAE=;
        b=dPD/y+iW7JgIszhQUFHl+wvt/kT/lUWlOjL9Xsv+izSBknFKRRNV+eO7jcYHA4hhZp
         Q97CbcAXTKo37pErFkO762c+OcYjwBPRtqSP/LkT61I3Y+K40MG+sBfuF4OvEE2K0rcE
         eISxlKkoZBIbWZzq8t1Iu5ZEtEsE+0Q5dGuxV9MX5VRpqr6xQjH51jIetXIOeR85CMzG
         Hi8ZsBYGm8NCP2qgqZFiHYi6+gfQhzN+YB/IjdburiYpLj1nmh1V7LA4+CnElhFy63we
         V2+pgiC4e8kYt3QSak4sPF5JpdFJmt5hiqWM59gLsfUUQvlvf187hDh5UVzfZFFM3Y1j
         nffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CqL/d3l/NRGUjaNstaW/nJgxQdVdoEya8rVF4Se8eAE=;
        b=meW6SsugL9rm5MLdKL91IgV7xy1C5XMehKI7oEmqa3N1fl1C66diHfuyig4IFqk0gC
         YiTyDcgRbKdwvHKIRwE4Ajh6dai20/AJpO0KC8GGIz6gyAdSsDwTVrfR320Wrb+TqL9V
         9FuAx3x9s0DEDbLnZX8jmM6XEca51DPaY4v83SZyP0uMrTBHO3SlY/VsalZXCUk6XSc3
         diBiuAaFY+31EK3hYXEVrC3qy1QPQqIzsdQqp1zv6sdwzRuy/z8L60WBiqm0B+clg6mX
         ZatRw7sSxxFZ4NAlrj9grnRxUaDvnzH/K1JrEps0goZKEIboLt9BLKQT+UZpBuaFNTcc
         iI+A==
X-Gm-Message-State: AOAM533nOJE+KZvNzPrIIPfTom/3+KTk4vckhd0j31HvcAyjVc4RSr6O
        fm5fOyVckFm0lAuyRoG81cmwDdmi6iY0gg==
X-Google-Smtp-Source: ABdhPJyuKXci1y6hxqauOoDzq04F8AARyc69iJjchp4jCo+1TRlKfyb8PGbbJlshfH35GM6BmiWnvg==
X-Received: by 2002:adf:fa08:: with SMTP id m8mr242594wrr.12.1616086124746;
        Thu, 18 Mar 2021 09:48:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84? (p200300ea8f1fbb008d2c08cc6c7f1a84.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84])
        by smtp.googlemail.com with ESMTPSA id y18sm3784948wrq.61.2021.03.18.09.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:48:44 -0700 (PDT)
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
 <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <50224899-4abe-5874-7ea5-bde66bbe1d18@gmail.com>
Date:   Thu, 18 Mar 2021 17:48:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 17:02, Florian Fainelli wrote:
> 
> 
> On 3/18/2021 6:25 AM, Heiner Kallweit wrote:
>> On 18.03.2021 10:09, Wong Vee Khee wrote:
>>> When using Clause-22 to probe for PHY devices such as the Marvell
>>> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
>>> which caused the PHY framework failed to attach the Marvell PHY
>>> driver.
>>>
>>> Fixed this by adding a check of PHY ID equals to all zeroes.
>>>
>>
>> I was wondering whether we have, and may break, use cases where a PHY,
>> for whatever reason, reports PHY ID 0, but works with the genphy
>> driver. And indeed in swphy_read_reg() we return PHY ID 0, therefore
>> the patch may break the fixed phy.
>> Having said that I think your patch is ok, but we need a change of
>> the PHY ID reported by swphy_read_reg() first.
>> At a first glance changing the PHY ID to 0x00000001 in swphy_read_reg()
>> should be sufficient. This value shouldn't collide with any real world
>> PHY ID.
> 
> It most likely would not, but it could be considered an ABI breakage,
> unless we filter out what we report to user-space via SIOGCMIIREG and
> /sys/class/mdio_bus/*/*/phy_id
> 
> Ideally we would have assigned an unique PHY OUI to the fixed PHY but
> that would have required registering Linux as a vendor, and the process
> is not entirely clear to me about how to go about doing that.
> --

In the OUI list I found entry 58-9C-FC, belonging to FreeBSD Foundation.
Not sure what they use it for, but it seems adding Linux as a vendor
wouldn't be a total exception.

> Florian
> 
Heiner
