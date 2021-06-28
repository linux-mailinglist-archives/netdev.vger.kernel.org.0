Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF093B6955
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhF1T43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhF1T43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:56:29 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D2BC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 12:54:02 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a13so22690699wrf.10
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 12:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LFw1QqjyJejEeYE4DGi/MVa4Zn6Yq8WbqAZ4BmTQ98E=;
        b=hTtYC17Q1q7jO7KFMkpBA7ygWbh8iLZ90j4Hn0uyWkKul43a+1MvxzcXVly1QWkv24
         vPxq1AT+W6NYzkYWPQBG9sMTge1iLnsu9Krxpf9ctbaw0qR9iHxg3bW2bMPUndYxKNTW
         chPF/mp5fpnI5KvtYKVj5NPrG8cqvauoVjMr59jX32QI21yC+zaGFFE0W/DQH7JD4jXV
         +8mkBHr63EjBN9y0DHBshePX9S0NDSER1sl0mPHUOEDzcdAQiSSDaeyEB+tIYwqnltAH
         2mlwxzOvtQ74Iw2DT/Pegf+KqWDgTh7d7p/MzhumtNT7TIz0Nkie7YsCpX3Dnuvqng16
         FQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFw1QqjyJejEeYE4DGi/MVa4Zn6Yq8WbqAZ4BmTQ98E=;
        b=qGhz1F+FeDIQCSTlwZ7XMwikVZ9Ysoj2cTvPH2hJm0Rp3wpGWJOzTJaOyNEUEb/I9r
         RbnW84kqpdPEoMnzhHZLeYJtV7+Lm3QL+jBRT/EWld4EiDrdlC1ybDRzdZmHAFamrgXW
         sYDJfnFmyLgvAvZlmYoMNOFxNbmI3YlED7pd5In8n+0KVDFmjUVZpEiK1HDaEM1LpD6Q
         tt/d+dFcKgNf6TiK6zb7vjJHhELaVAUX9MgqDpv9Gkg7gVuHlOCSpk+hh/5iRNLbfTXS
         gKhoT8Yx2M6s6I0f5ziKNp7QCqFYXnIptAaejUstzBBeHu2BwvJq67e2KbHd0uEszZYA
         HFtQ==
X-Gm-Message-State: AOAM531XzSCPmS5y9Sa6jyUGSCutXgwk4EntGMxDswQ2hYlO5cdBGJP2
        fqLTHK+OymKgEAMOLkDQ7gk=
X-Google-Smtp-Source: ABdhPJwwcljetF0d0p3qXkUJWhrYE7ibXXIOyFrevT+JatIRcUdH4kGHdzht8c7459urwIBrtU0o7g==
X-Received: by 2002:adf:9466:: with SMTP id 93mr8090157wrq.340.1624910040857;
        Mon, 28 Jun 2021 12:54:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:e3:ff36:7d21:a6f8? (p200300ea8f29380000e3ff367d21a6f8.dip0.t-ipconnect.de. [2003:ea:8f29:3800:e3:ff36:7d21:a6f8])
        by smtp.googlemail.com with ESMTPSA id f9sm2292514wrm.48.2021.06.28.12.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 12:54:00 -0700 (PDT)
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>
References: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: PHY vs. MAC ethtool Wake-on-LAN selection
Message-ID: <0aae6527-6b1d-31e4-1b9d-52f2174634b3@gmail.com>
Date:   Mon, 28 Jun 2021 21:53:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.06.2021 05:53, Florian Fainelli wrote:
> Hi all,
> 
> I would like to request your feedback on implementing a solution so that we can properly deal with choosing PHY or MAC Wake-on-LAN configuration.
> 
> The typical use case that I am after is the following: an Android TV box which is asleep as often as possible and needs to wake-up when a local network device wants to "cast" to the box. This happens when your phone does a mDNS query towards a multicast IPv4 address and searches for a particular service.
> 
> Now, consider the existing system's capabilities:
> 
> - system supports both "standby" (as written in /sys/power/state) with all the blocks powered on and "mem" with only a subset of the SoC powered on (a small always on island and supply)
> 
> - Ethernet MAC (bcmgenet) is capable of doing Wake-on-LAN using Magic Packets (g) with password (s) or network filters (f) and is powered on in the "standby" (as written in /sys/power/state) suspend state, and completely powered off (by hardware) in the "mem" state
> 
> - Ethernet PHY (broadcom.c, no code there to support WoL yet) is capable of doing Wake-on-LAN using Magic Packets (g) with password (s) or a 48-bit MAC destination address (f) match allowing us to match on say, Broadcom and Multicast. That PHY is on during both the "standby" and "mem" suspend states
> 
> The network filtering capability of the Ethernet MAC in the "standby" state is superior to that of the Ethernet PHY and would allow for finer filtering of the network packets, so it should be preferred when the standby state is "standby" so we can limit spurious wake-ups on multicast traffic and specifically that not matching the desired service. There may also be capability to match on all of "gsf" instead of just "g" or "s" so it is preferred.
> 
> When the standby state is "mem" however we would want to use the PHY because that is the only one in the always-on island that can be active, even if it has coarse filtering capabilities.
> 
> Since bd8c9ba3b1e2037af5af4e48aea1087212838179 ("PM / suspend: Export pm_suspend_target_state") drivers do have the ability to determine which suspend state we are about to enter at ->suspend() time, so with the knowledge about the system as to which of the MAC or the PHY will remain on (using appropriate Device Tree properties for instance: always-on) and service Wake-on-LAN, a driver could make an appropriate decision as to whether it wants to program the MAC or the PHY with the Wake-on-LAN configuration.
> 
> The programming of the Wake-on-LAN is typically done at ->suspend() time and not necessarily at the time the user is requesting it, and at the time the user configures Wake-on-LAN we do not know yet the target suspend state.
> 
> This is a problem that could be punted to user-space in that it controls which suspend mode the system will enter. We could therefore assume that user space should know which Wake-on-LAN configuration to apply, even if that could mean "double" programming of both the MAC and PHY, knowing that the MAC will be off so the PHY will take over. The problem I see with that is that approach:
> 
> - you must always toggle between Wake-on-LAN programming depending upon the system standby mode which may not always be practical
> 
> - the behavior can vary wildly between platforms depending upon capabilities of the drivers and their bugs^w implementation
> 
> - we are still missing the ability to install a specific Wake-on-LAN configuration towards the desired MAC or PHY entity
> 
> The few drivers that call phy_ethtool_{set,get}_wol() except lan743x do not actually support Wake-on-LAN at the MAC level, so that is an easy decision to make for them because it is the only way they can support Wake-on-LAN.
> 
> What I envision we could do is add a ETHTOOL_A_WOL_DEVICE u8 field and have it take the values: 0 (default), 1 (MAC), 2 (PHY), 3 (both) and you would do the following on the command line:
> 
> ethtool -s eth0 wol g # default/existing mode, leave it to the driver
> ethtool -s eth0 wol g target mac # target the MAC only
> ethtool -s eth0 wol g target phy # target the PHY only
> ethtool -s eth0 wol g target mac+phy # target both MAC and PHY
> 
> Is that over engineering or do you see other platforms possibly needing that distinction? Heiner, how about r8169, are there similar constraints with respect to which part of the controller is on/off during S2, S3 or S5?
> 
Hi Florian,

your question regarding r8169 is a little bit hard to answer because there's no public chip documentation.
What I can say is how the driver behaves. If WOL is enabled then the MAC is kept active (receiver enabled,
no PLL power-down). This indicates that for certain WOL types MAC support is needed, I didn't test yet
whether e.g. WAKE_PHY works with the MAC disabled.

> Thanks!

Heiner
