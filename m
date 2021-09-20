Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F631412982
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 01:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhITXol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 19:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbhITXmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 19:42:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB78DC035474
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:46:33 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id bb10so11590922plb.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=37XwHM7uw4pv3Glo5SjzQH5TyQr7cTuldQTWA9M+0ro=;
        b=T3jPqZSOVUwiB/tt9sGYmEpZRk3Glof46zaALXvdOOCpJhfcem1yM8UCp7CCfR3Ok3
         kdWECpTAGaYgQH4zgMiPj8UKspQUabhzzV2jIfrKVauX/YJe8zNgdOzjPnMKt8VTOdUw
         wupA27/4nW7mvzW2t0AvBHfVYjHUDEQQO1J3eJhNObuiacOAiXE/pPm07/eaOvR3Rxqd
         Y1Ss5TcObY1ZSKUszO2xm8oCrLKncrXQItxeRNP0KwEwctxGT8GiuxpKxmyXL2tLvX3a
         o2k0eR+hRCjIrtqWYRVGu/X4jfR3tKJof1KpzBq6NChrhgDgo9rvhiBD6na1+/w8NQZl
         ZSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=37XwHM7uw4pv3Glo5SjzQH5TyQr7cTuldQTWA9M+0ro=;
        b=L8swZQ4eJhQW8npcIaSdg3uWXAlGFdV5xykD11B5mHMonqJ+8e1EWFTxHnnJf0zqhp
         OThJBwPapXvvUfNbpdbTw5fViM5dx6kBEQI+FMEqxR4pJu4Fss1IsoKjjBHu4gPth/Kz
         1SyY0RTxUdImAkZ394TucG+55dp/83zwj2SAJAxsWelRVNTlDVg0yvtlRye1LmTofi09
         Awq3Y6iP5O4N7S9PB+Vm6OvN0K4pSj/wMtHKNG5WGfSsFkwSdOkJ3TEmsQMlq8yIdwXj
         LKavxpBpzOQz/2zOIoD21WYM08eraPxZTa1E48drmvSUQkEISlL6FP5VoS/v0m86ANe9
         zUdA==
X-Gm-Message-State: AOAM533C1XmUx2hafH4z1/GTyxQwXsNzXdcDt2q8kgyU8rKCCRnLrGm/
        ulb1EGx2hkz2V38avaNZu/M=
X-Google-Smtp-Source: ABdhPJwCBI9JxP4HpzzX8kVF/BA0/p6WOUlBlGr/wykO36vR+MX+posSlht30ASIMeFjGZJBCik+Nw==
X-Received: by 2002:a17:90b:1b52:: with SMTP id nv18mr274644pjb.54.1632159993347;
        Mon, 20 Sep 2021 10:46:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x1sm15455244pfc.53.2021.09.20.10.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 10:46:32 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
Date:   Mon, 20 Sep 2021 10:46:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920174022.uc42krhj2on3afud@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 10:40 AM, Vladimir Oltean wrote:
> On Mon, Sep 20, 2021 at 10:14:48AM -0700, Florian Fainelli wrote:
>> The SPROM is a piece of NVRAM that is intended to describe in a set of
>> key/value pairs various platform configuration details. There can be up
>> to 3 GMACs on the SoC which you can connect in a variety of ways towards
>> internal/external PHYs or internal/external Ethernet switches. The SPROM
>> is used to describe whether you connect to a regular PHY (not at PHY
>> address 30 decimal, so not the Broadcom pseudo-PHY) or an Ethernet
>> switch pseudo-PHY via MDIO.
>>
>> What appears to be missing here is that we should not be executing this
>> block of code for phyaddr == BGMAC_PHY_NOREGS because we will not have a
>> PHY device proper to begin with and this collides with registering the
>> b53_mdio driver.
> 
> Who provisions the SPROM exactly? It still seems pretty broken to me
> that one of the GMACs has a bgmac->phyaddr pointing to a switch.

The OEMs are typically responsible for that. It is not "broken" per-se,
and you will find additional key/value pairs that e.g.: describe the
initial switch configuration something like:

vlan0ports="0 1 2 3 5t"
vlan1ports="4 5t"

So this has been used as a dumping ground of "how I want the device to
be configured eventually". 0x1e/30 is sort of "universally" within
Broadcom's own universe that this designates an Ethernet switch
pseudo-PHY MDIO bus address, and we all know that nobody in their right
mind would design a Wi-Fi router with a discrete Ethernet switch that is
not from Broadcom, right?

> Special-casing the Broadcom switch seems not enough, the same thing
> could happen with a Marvell switch or others. How about looking up the
> device tree whether the bgmac->mii_bus' OF node has any child with a
> "reg" of bgmac->phyaddr, and if it does, whether of_mdiobus_child_is_phy
> actually returns true for it?

We could do that, however I don't know whether this will break the
arch/mips/bcm47xx devices which are still in active use by the OpenWrt
community and for which there is no Device Tree (no technical
limitation, just no motivation since devices are EOL'd), but maybe out
of tree patches can be carried in the OpenWrt tree to revert anything
that upstream came up with.
-- 
Florian
