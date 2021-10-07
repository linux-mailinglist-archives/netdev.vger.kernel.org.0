Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59949425A71
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243524AbhJGSOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhJGSOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 14:14:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A43C061570;
        Thu,  7 Oct 2021 11:12:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m5so6015906pfk.7;
        Thu, 07 Oct 2021 11:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zcGBIhKrON+MgfHdKChgd+MR4ouCwcsLhobVnFLjAGE=;
        b=G1mwsJ/sX9YkeHnQ5UcKRh/HCb+HTgZx08HBbarDJdy+/xzYwLjH/c9Qg6rIkh+wPS
         gecKknATnLFv5+Ot98ZL3CUyMekhKsLERP8cEfSGcb7aPVELaUzEOvF2zMNblaTX9qQK
         k0YP0ECL/3hcvTMIdW9SChZpCi/pgEzKW7++TaP6JiUR1xtq6ZcH0gik8QfqEEr20GIJ
         bMVCz8dr1eeSM9oXjE4uY7h62d0GF4MswqFWfBveV4jvIj7GmL/NiwMxudRXhfoGr+0t
         0uyHXy2HRLRJvgboIAy1hWXwS0OzznwVx2Vrru5YE8qnObWSq4pB3gGaVPa3qnoNkzs1
         HNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zcGBIhKrON+MgfHdKChgd+MR4ouCwcsLhobVnFLjAGE=;
        b=cfbhA1sLmzux+fn2Q++ff8kat28RxJ7lqX+hLfjCF/oLbfki8kMZQhj8t1gFoNhSAW
         p/vR/SvnKVPa6uV3Evp992rTfHp7lOtYn614djbRtIXmMJ68CyDyNEHKaBI7QR5B7uM9
         mG+0POklNKwW/S8EhwOOoElgEOwDC2ZoUWsIiQfa/RaS069j0W1iIy+AH/JV/96hgABL
         7Ycv5g2ts53x5dNzqjjxow3Fsc7oq47z439Kw6Ty6np0v7hnuMDi3qz/l6Hkhqxn/w5x
         g4ZgZF9mvQTN1sZGy/7n3SuSsMtyscjwzKjTbXvWUcANXDX6UeweNHA9l7E5ALgk1GhS
         uxQA==
X-Gm-Message-State: AOAM533qHUb26lzHLZFcqvnlTLo4+QcZTxRmTcu+NjIt628rySpASssw
        uz4NpEciL5FnZ9jIXQen27sMtow9gy8=
X-Google-Smtp-Source: ABdhPJwFmTWHDSMgp2ERks6179u8iTUF9h+CjBN17Qn3U3om1x2znZybadLxqJwjTlFROjrWeh4Grg==
X-Received: by 2002:a05:6a00:10cc:b0:44c:852:41d8 with SMTP id d12-20020a056a0010cc00b0044c085241d8mr5871737pfu.54.1633630378089;
        Thu, 07 Oct 2021 11:12:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12sm8831747pjr.2.2021.10.07.11.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 11:12:57 -0700 (PDT)
Subject: Re: [net-next PATCH 09/13] net: dsa: qca8k: check rgmii also on port
 6 if exchanged
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-10-ansuelsmth@gmail.com> <YV4+KDQWNhDmcaHL@lunn.ch>
 <YV72oJ/wWiiNthAs@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <90ebf1eb-89b9-3059-a6b8-87c197032e4c@gmail.com>
Date:   Thu, 7 Oct 2021 11:12:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YV72oJ/wWiiNthAs@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 6:31 AM, Ansuel Smith wrote:
> On Thu, Oct 07, 2021 at 02:24:08AM +0200, Andrew Lunn wrote:
>> On Thu, Oct 07, 2021 at 12:35:59AM +0200, Ansuel Smith wrote:
>>> Port 0 can be exchanged with port6. Handle this special case by also
>>> checking the port6 if present.
>>
>> This is messy.
>>
>> The DSA core has no idea the ports have been swapped, so the interface
>> names are going to be taken from DT unswaped. Now you appear to be
>> taking phy-mode from the other port in DT. That is inconsistent. All
>> the configuration for a port should come from the same place, nothing
>> gets swapped. Or everything needs to swap, which means you need to
>> change the DSA core.
>>
>>     Andrew
> 
> The swap is internal. So from the dts side we still use port0 as port0,
> it's just swapped internally in the switch.
> The change here is required as this scan the rgmii delay and sets the
> value to be set later in the phylink mac config.
> We currently assume that only one cpu port is supported and that can be
> sgmii or rgmii. This specific switch have 2 cpu port and we can have one
> config with cpu port0 set to sgmii and cpu port6 set to rgmii-id.
> This patch is to address this and to add the delay function to scan also
> for the secondary cpu port. (again the real value will be set in the mac
> config function)
> Honestly i think we should just rework this and move the delay logic
> directly in the mac_config function and scan there directly. What do you
> think? That way we should be able to generalize this and drop the extra
> if.

Agreed, the whole port swapping business is really hairy and seems like
it will led to unpleasant surprises down the road.
-- 
Florian
