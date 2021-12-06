Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32F846A251
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhLFRLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239517AbhLFRKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:10:52 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B44CC0698CC
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 09:06:56 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q16so11063390pgq.10
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 09:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BeFbL4Mcti+UiafSvfDA+GCpuo8VAycsLuAPAodQEm4=;
        b=T3BFHyTpTvYu1YtcKV9JzPbyD9DD6cwKRCAAzBWhqnAvCLPxCafhjn6T5kXyHZdnNv
         GWKRC3e6xgDjNrep4bP1ExGGmB6FWqIt9jufBotrMvK5sWj4UMhKNmEGQg89ZYbN8KoC
         fz9hK8uSUXgP9zHR/r01RSq+KhSpthxt5FfGJw5v/FphzoSMeJTTynC1q8ANCZUNleDo
         nTr66PKAbf61SE/wqxOtgQlhmy4OgsUvoIhGiJmZpJ/v5AOxba4hFyTOvzAIvLVsBWY1
         fGKP/x+p5de7D1SfFXansz4b2PHe5DNFaERyFsUMcS47Kfy2zpo1HEkL3yE/3r9rWV+o
         vH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BeFbL4Mcti+UiafSvfDA+GCpuo8VAycsLuAPAodQEm4=;
        b=2FlQWkGlKFqvZeWu4OzlRF9DGdDDkzrzu//j8JZY3dp661dEo4OSg+Ee0q554ZlwUX
         bKaAGStm/Os4DukCAumCssrlRZCYevCSFz+7wIZDcYu8rOa8ZXrbpd9uzMUPQlh6Quh3
         QPuLelyrtcmJiu+r3rSeVV/TpOqQYilqkNgzyVf5vCSdRYqys0sLvE2C5B3vTLWkfCnE
         WNVwvaY1kfTWzYHBg/vDhktfatjqgnBC88K/hz5w3p3ibx9Ahr61ik+qZ1MrGP9eEp8u
         vhvPNCdXfbkr561yo/g1TrptdkWGXhcrkaiFRIAnB6gLQrFU2udauAuYsnT+HV3CJ1e4
         TH8Q==
X-Gm-Message-State: AOAM531xdYnaKsdhPRTdPPAUkehyxxkAJSzTFAjY/JQhOLypdc9IAXQ4
        Fanulj51FeFMotZInRxqRBw=
X-Google-Smtp-Source: ABdhPJyJggeagIK6aQSyKlVMPgK5JWljj6q8A2Laf+N7eAldBk0lHl9DZAA7DNjkwDxy8MNVfeDg9Q==
X-Received: by 2002:a05:6a00:228f:b0:49f:d8ac:2f1c with SMTP id f15-20020a056a00228f00b0049fd8ac2f1cmr37900888pfe.35.1638810415824;
        Mon, 06 Dec 2021 09:06:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id me7sm16316958pjb.9.2021.12.06.09.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 09:06:55 -0800 (PST)
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
 <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
 <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bbe1c983-788f-0561-a897-53f2ab4508df@gmail.com>
Date:   Mon, 6 Dec 2021 09:06:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YauArR7bd6Xh4ISt@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/21 6:52 AM, Russell King (Oracle) wrote:
> On Sat, Dec 04, 2021 at 08:59:12AM +0000, Russell King (Oracle) wrote:
>> On Fri, Dec 03, 2021 at 08:18:22PM -0800, Florian Fainelli wrote:
>>> Now, with respect to the fixed link ports reporting 1000baseKX/Full this is
>>> introduced by switching to your patch, it works before and it "breaks"
>>> after.
>>>
>>> The first part that is a bit weird is that we seem to be calling
>>> phylink_generic_validate() twice in a row from the same call site.
>>>
>>> For fixed link ports, instead of masking with what the fixed link actually
>>> supports, we seem to be using a supported mask which is all 1s which seems a
>>> bit excessive for a fixed link.
>>>
>>> This is an excerpt with the internal PHY:
>>>
>>> [    4.210890] brcm-sf2 f0b00000.ethernet_switch gphy (uninitialized):
>>> Calling phylink_generic_validate
>>> [    4.220063] before phylink_get_linkmodes: 0000000,00000000,00010fc0
>>> [    4.226357] phylink_get_linkmodes: caps: 0xffffffff mac_capabilities:
>>> 0xff
>>> [    4.233258] after phylink_get_linkmodes: c000018,00000200,00036fff
>>> [    4.239463] before anding supported with mask: 0000000,00000000,000062ff
>>> [    4.246189] after anding supported with mask: 0000000,00000000,000062ff
>>> [    4.252829] before anding advertising with mask:
>>> c000018,00000200,00036fff
>>> [    4.259729] after anding advertising with mask: c000018,00000200,00036fff
>>> [    4.266546] brcm-sf2 f0b00000.ethernet_switch gphy (uninitialized): PHY
>>> [f0b403c0.mdio--1:05] driver [Broadcom BCM7445] (irq=POLL)
>>>
>>> and this is what a fixed link port looks like:
>>>
>>> [    4.430765] brcm-sf2 f0b00000.ethernet_switch rgmii_2 (uninitialized):
>>> Calling phylink_generic_validate
>>> [    4.440205] before phylink_get_linkmodes: 0000000,00000000,00010fc0
>>> [    4.446500] phylink_get_linkmodes: caps: 0xff mac_capabilities: 0xff
>>> [    4.452880] after phylink_get_linkmodes: c000018,00000200,00036fff
>>> [    4.459085] before anding supported with mask: fffffff,ffffffff,ffffffff
>>> [    4.465811] after anding supported with mask: c000018,00000200,00036fff
>>> [    4.472450] before anding advertising with mask:
>>> c000018,00000200,00036fff
>>> [    4.479349] after anding advertising with mask: c000018,00000200,00036fff
>>>
>>> or maybe the problem is with phylink_get_ksettings... ran out of time
>>> tonight to look further into it.
>>
>> It will be:
>>
>>         s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
>>                                pl->supported, true);
>>         linkmode_zero(pl->supported);
>>         phylink_set(pl->supported, MII);
>>         phylink_set(pl->supported, Pause);
>>         phylink_set(pl->supported, Asym_Pause);
>>         phylink_set(pl->supported, Autoneg);
>>         if (s) {
>>                 __set_bit(s->bit, pl->supported);
>>                 __set_bit(s->bit, pl->link_config.lp_advertising);
>>
>> Since 1000baseKX_Full is set in the supported mask, phy_lookup_setting()
>> returns the first entry it finds in the supported table:
>>
>>         /* 1G */
>>         PHY_SETTING(   1000, FULL,   1000baseKX_Full            ),
>>         PHY_SETTING(   1000, FULL,   1000baseT_Full             ),
>>         PHY_SETTING(   1000, HALF,   1000baseT_Half             ),
>>         PHY_SETTING(   1000, FULL,   1000baseT1_Full            ),
>>         PHY_SETTING(   1000, FULL,   1000baseX_Full             ),
>>
>> Consequently, 1000baseKX_Full is preferred over 1000baseT_Full.
>>
>> Fixed links don't specify their underlying technology, only the speed
>> and duplex, so going from speed and duplex to an ethtool link mode is
>> not easy. I suppose we could drop 1000baseKX_Full from the supported
>> bitmap in phylink_parse_fixedlink() before the first phylink_validate()
>> call. Alternatively, the table could be re-ordered. It was supposed to
>> be grouped by speed and sorted in descending match priority as specified
>> by the comment above the table. Does it really make sense that
>> 1000baseKX_Full is supposed to be preferred over all the other 1G
>> speeds? I suppose that's a question for Tom Lendacky
>> <thomas.lendacky@amd.com>, who introduced this in 3e7077067e80
>> ("phy: Expand phy speed/duplex settings array") back in 2014.
> 
> Here's a patch for one of my suggestions above. Tom, I'd appreciate
> if you could look at this please. Thanks.

I don't have objections on the patch per-se, but I am still wary that
this is going to break another driver in terms of what its fixed link
ports are supposed to report, so maybe the generic validation approach
needs to be provided some additional hints as to what port link modes
are supported, or rather, not supported.

So I would suggest we have bcm_sf2 continue to implement
ds->ops->validate which does call phylink_generic_validate() but also
prunes unsupported link modes for its fixed link ports, what do you think?
-- 
Florian
