Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A5C467E95
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 21:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382978AbhLCUGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 15:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353557AbhLCUGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 15:06:52 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF37C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 12:03:27 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y8so2857710plg.1
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 12:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FW0hrJpjceL/mxaGmLjKzD8cucFO2qTxLAh5+loCnRM=;
        b=kfl6BmM5Bu5cRIa4cr4Uep9JYzpXKEUZOhL9WUnBQJ9MDINEsf7DAIL+LV1y0cjvAG
         HgwQtbNgJCRqGpRI5+2scOL3B86cIl2BkyHPfHI9toZWk/72PgnwbP4P6SGKqo4aiYsd
         O3RvCOFfSBhlbBunJkDyad9zr+jGOiUoXuIgj0UGOfomYqm/ZVHD+E3quNCfZWZ8m6pF
         Usg3ol1zJKr0gofaFJosogt1RzMZqfjHaRFoE1J/5/ATC+GyKh68zVUHZicttg0ktq59
         28mKmiYkq+8fUxyXQaFjJbMkQYrqsaWj5b1k52w9gQ9H0j7iCePqxqpikHz6OkOdSotw
         XeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FW0hrJpjceL/mxaGmLjKzD8cucFO2qTxLAh5+loCnRM=;
        b=SRmiCT1S0622TY31jXL1JEC6mq/ZkPV31Z6FxiYEPKpMGORhH3TpMDMpZ5g03ctzzJ
         dtM5jkOoPuCOfAuFHZiYoo2yr2Cn8YDnPLkVkHphnOH/5aAcLVmiALcLcbnczosFGlZ3
         /dWK0UcV6KW+1fwYCPmbQ986c1zEa0YxztAholfNgZ55GhlJU+Ndd6E8ZvFXLpMz5EeM
         iik7iLB+wGCpkFT4y/zhygBokGZfcYycBPgvouzjrHgqhejOcsJox1tcsUieXOoMNJjP
         uR9e1+UJ9DU+YmQ3xNH1ZoY/aksMFhJKjOIU7PLMlByFfDEUFFyAoxGUjrObr940xUZv
         5xNg==
X-Gm-Message-State: AOAM5321Xpo4KQVJaLN+Q+AiyMFFaIIdq+WiQphekuvdLJLKXwsA4oGg
        ur+n075AVo7ULU72K0b5DQg=
X-Google-Smtp-Source: ABdhPJw4y74E/bj3alm95TB+WgEHDZ1pZnDCJLCpaq8jqKihtn6ScPjU4cDuAhg7RG9fwk2CBDWNSg==
X-Received: by 2002:a17:90b:1d0e:: with SMTP id on14mr16615733pjb.3.1638561807432;
        Fri, 03 Dec 2021 12:03:27 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j20sm1156878pjl.3.2021.12.03.12.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 12:03:26 -0800 (PST)
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
Date:   Fri, 3 Dec 2021 12:03:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/21 9:52 AM, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the bcm_sf2
> DSA switch and remove the old validate implementation to allow DSA to
> use phylink_generic_validate() for this switch driver.
> 
> The exclusion of Gigabit linkmodes for MII and Reverse MII links is
> handled within phylink_generic_validate() in phylink, so there is no
> need to make them conditional on the interface mode in the driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

but it looks like the fixed link ports are reporting some pretty strange
advertisement values one of my two platforms running the same kernel image:

# ethtool rgmii_2
Settings for rgmii_2:
        Supported ports: [ MII ]
        Supported link modes:   1000baseKX/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseKX/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: No
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Supports Wake-on: gsf
        Wake-on: d
        SecureOn password: 00:00:00:00:00:00
        Link detected: yes
#

These should be 1000BaseT/Full since these are RGMII fixed links:

# ethtool rgmii_2
Settings for rgmii_2:
        Supported ports: [ MII ]
        Supported link modes:   1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseT/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: No
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Supports Wake-on: gsf
        Wake-on: d
        SecureOn password: 00:00:00:00:00:00
        Link detected: yes
#

There is no problem with Linus' master branch at
net-5.16-rc4-173-ga51e3ac43ddb, let me see if I can bisect this and/or
fix it in the next days.

Thanks!
-- 
Florian
