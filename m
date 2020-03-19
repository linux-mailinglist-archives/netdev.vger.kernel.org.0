Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACED18BD6B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgCSRE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:04:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55440 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgCSRE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:04:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id 6so3385340wmi.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 10:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BQR1S0XU3U3hb+ClVpBPbJLGtQbo3aw+ErNJUSCbwQ0=;
        b=SRWDCB/IC+PeCO7yzYMZdTIIBfMAefe4maN9WSCVw7Jg3BwtLh/4udwqLNsKibVkqF
         PzhIG0OO4vzDRPTsDj7gwUKCo05kC2sID5Ou/A7D/+pOXzoJna0uq8cMXNajb2qcXGes
         IURwCojbBdHYBZxInMNOTkVwxGpKEw5JxhKLQnMcZcaYtxR7J3bSCx+3Dvmy0me46xZs
         xJgNdBlGdw4aAY75HUmAXuHGNKobhqsH9WBMfhL/m2K72sfqpm7AUeLAxNx+KgRs69ld
         c736ROYIZsRY7JGuBfZXrZ30/esFP7oSBrYBImtQHTlhAArlKzrXbXK3XmU4JEGFbqaN
         lSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BQR1S0XU3U3hb+ClVpBPbJLGtQbo3aw+ErNJUSCbwQ0=;
        b=d0Yf6/gYRSfygsXTlyxA7Ue0Iiu0j0VB9Kcu0fZrfHtcm2g5nC3RtpwMt+GMn1xTbj
         /z7VStKDFRoUzl2eQBWvz47fk3VULb8MW0I71WJxA23GwEjICdXPKrsCl4YpXDtr4eFe
         XZY27LMxhw+cmqhURMzBnomxwZYFpljRolTlA1kqS0CCcbM0AkR09TCJdqQzZnzsUVIh
         ogipHpA3x0+kutrB/E5G4OzKmGbyKgOrBNto9cC/SlNgDmeL4FFbQ+5iK/GVNz+AMgCZ
         x2kzScBM4tp/JlpBdTitLLn+RKKPZX5gkW9jTHeipV6EHGUj6tk+Uky2NyukqQBajN+p
         DQbA==
X-Gm-Message-State: ANhLgQ3XmFfPINEsUAzLJcgic4OaMAQ+tCnvFRZuIDi6MH1sNsjK3gVg
        GSgmjtjNGuayepQI3Q/2xmwAKiEx
X-Google-Smtp-Source: ADFU+vu6Ke0HzWV9BIVvcwq0X0w1YBndPCdatAFtscCGtVuOY5YYRcstq6pLsFpt5leF4QY5qlQuMA==
X-Received: by 2002:a7b:c75a:: with SMTP id w26mr4715460wmk.2.1584637495102;
        Thu, 19 Mar 2020 10:04:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:f482:8f51:2469:4533? (p200300EA8F296000F4828F5124694533.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f482:8f51:2469:4533])
        by smtp.googlemail.com with ESMTPSA id i1sm4125579wrq.89.2020.03.19.10.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 10:04:54 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
 <20200319112535.GD25745@shell.armlinux.org.uk>
 <20200319130429.GC24972@lunn.ch>
 <20200319135800.GE25745@shell.armlinux.org.uk>
 <92689def-4bbf-8988-3137-f3cfb940e9fc@gmail.com>
 <5e5c647b-f05d-d9d3-0554-68af99ee3f55@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <82c01854-4571-4e4f-680d-316f7cd0870f@gmail.com>
Date:   Thu, 19 Mar 2020 18:04:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5e5c647b-f05d-d9d3-0554-68af99ee3f55@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.03.2020 17:55, Florian Fainelli wrote:
> Le 2020-03-19 à 09:36, Heiner Kallweit a écrit :
>> *Downshift reporting/warning*
>> In most cases downshift is caused by some problem with the cabling.
>> Users like the typical Ubuntu user in most cases are not familiar
>> with the concept of PHY downshift and what causes a downshift.
>> Therefore it's not sufficient to just report a downshift, we have
>> to provide the user with a hint what to do.
>> Adding the "downshifted" info to phy_print_status() is a good idea,
>> however I'd see it as an optional addition to the mentioned hint
>> to the user what to do.
>> The info "unknown downshift" IMO would just cause confusion. If we
>> have nothing to say, then why say something. Also users may interpret
>> "unknown" as "there's something wrong".
> 
> Ideally we would also have support for cable testing as well which would
> allow users to know what to do next to figure out why their link speed
> is not what they had hoped for. That does require a specific PHY driver
> though as there is no standard way to obtain that information.
> 
> FWIW, a bunch of drivers like tg3, e1000e, igc and possibly others do
> report when downshifting occurs, of course not all of those in that list
> use the PHY library.
> 
Yes, a direct link to cable testing would be nice. With the new
netlink-based ethtool support for cable testing comes closer.
AFAIK Andrew is evaluating what an API could look like.

However for the time being I think a downshift warning in phylib would
be helpful to explain to the user: Check your damned cabling instead
of spamming support forums with blaming the network driver or any other
piece of software or hardware.
