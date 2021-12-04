Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3E46823B
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 05:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhLDEVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 23:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhLDEVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 23:21:50 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963EC061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 20:18:25 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b68so4763649pfg.11
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 20:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=JnW+U71gVTXrF7bCS/o2U3OwcQLbkI8b1Za/NwRwDmo=;
        b=bOjXUzQ8JALdQxyUkfO6mo2AEPk8fmvR7vCy6sEP9PnH0v9GJuyA/qZspzmiAa4JgW
         tbBWV9r7WLmn+ZcdLg09FBogaWJBXnbNYG/fjMcp6OsPR9NwmhgAqqRRHJB/4RkpO4BO
         AStkKRsZ8GnW60foniE8qUVkVIqygDLq6O8sCabPK3lVyYBPxdHEfOjAzd2kcKU4v19z
         YxRRs+LIfTuAGhxId9mWEPhaxIsaeieyWTVPDeuXu3ex/izwQOllWDlFYbqmTOzSGRtJ
         VmzGOFU9/IpwS71NuRX3xSfUkX9Dy9izyIShI+MBnrto+LEZWo64NI/Zow0qhlBlGdnY
         EWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=JnW+U71gVTXrF7bCS/o2U3OwcQLbkI8b1Za/NwRwDmo=;
        b=7vAcvSo7UoZdpEH2Kx1Xcm7f6Y2/zlxZOnIhdBeKer8pK/9bRYknHuG0u9WzvlYEmT
         2rCjYG+oIYMaXgXibj7PDMgGqYPkB4EzfaY1ucdKt5gI81n3pvYQemJek9qER8ZymUWz
         Wz0bcu9SekX92uZWwDTOYqaSy3cWbIiGcLF6/a3iVJNCr7tPl/4al00RyrfHyAhA9E5V
         VU23tdjhx2zuSG5Kkbu3Kh363lRw8CP+p8lRmuH9vrcHmdm8/2SD2EeGwE43IVCVFgIl
         3w+2OFGurrUEYW+bFUwLr1koYwQzaZljufUpzkZoAOe69L8xRA2kQ9Nt2c4ENsWuR+ba
         9lgA==
X-Gm-Message-State: AOAM531NIVh0cKEzYDnJWDcbntPmXAtV75lfseHYJxBdwiAACd5QT15c
        B+m8iJ+Cuz67koySaMb9k+E=
X-Google-Smtp-Source: ABdhPJxMnwc04sePmrC0gwShoXLjRVfHCTG+iQc7H+iENwjpqyNS/f3Cyxnz/YdFlB3ER4jD4gDHHQ==
X-Received: by 2002:aa7:8611:0:b0:49f:a5b3:14b4 with SMTP id p17-20020aa78611000000b0049fa5b314b4mr23523371pfn.30.1638591504596;
        Fri, 03 Dec 2021 20:18:24 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h2sm5103672pfc.190.2021.12.03.20.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 20:18:24 -0800 (PST)
Message-ID: <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
Date:   Fri, 3 Dec 2021 20:18:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
From:   Florian Fainelli <f.fainelli@gmail.com>
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
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
Content-Language: en-US
In-Reply-To: <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 12:03 PM, Florian Fainelli wrote:
> On 11/24/21 9:52 AM, Russell King (Oracle) wrote:
>> Populate the supported interfaces and MAC capabilities for the bcm_sf2
>> DSA switch and remove the old validate implementation to allow DSA to
>> use phylink_generic_validate() for this switch driver.
>>
>> The exclusion of Gigabit linkmodes for MII and Reverse MII links is
>> handled within phylink_generic_validate() in phylink, so there is no
>> need to make them conditional on the interface mode in the driver.
>>
>> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> but it looks like the fixed link ports are reporting some pretty strange
> advertisement values one of my two platforms running the same kernel image:

We would want to amend your patch with something that caters a bit more
towards how the ports have been configured:

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index d6ef0fb0d943..88933c3feddd 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -675,12 +675,18 @@ static u32 bcm_sf2_sw_get_phy_flags(struct
dsa_switch *ds, int port)
  static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
                                 struct phylink_config *config)
  {
-       __set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
-       __set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
-       __set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
-       __set_bit(PHY_INTERFACE_MODE_INTERNAL,
config->supported_interfaces);
-       __set_bit(PHY_INTERFACE_MODE_MOCA, config->supported_interfaces);
-       phy_interface_set_rgmii(config->supported_interfaces);
+       struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+
+       if (priv->int_phy_mask & BIT(port))
+               __set_bit(PHY_INTERFACE_MODE_INTERNAL,
config->supported_interfaces);
+       else if (priv->moca_port == port)
+               __set_bit(PHY_INTERFACE_MODE_MOCA,
config->supported_interfaces);
+       else {
+               __set_bit(PHY_INTERFACE_MODE_MII,
config->supported_interfaces);
+               __set_bit(PHY_INTERFACE_MODE_REVMII,
config->supported_interfaces);
+               __set_bit(PHY_INTERFACE_MODE_GMII,
config->supported_interfaces);
+               phy_interface_set_rgmii(config->supported_interfaces);
+       }

         config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
                 MAC_10 | MAC_100 | MAC_1000;

Now, with respect to the fixed link ports reporting 1000baseKX/Full this 
is introduced by switching to your patch, it works before and it 
"breaks" after.

The first part that is a bit weird is that we seem to be calling 
phylink_generic_validate() twice in a row from the same call site.

For fixed link ports, instead of masking with what the fixed link 
actually supports, we seem to be using a supported mask which is all 1s 
which seems a bit excessive for a fixed link.

This is an excerpt with the internal PHY:

[    4.210890] brcm-sf2 f0b00000.ethernet_switch gphy (uninitialized): 
Calling phylink_generic_validate
[    4.220063] before phylink_get_linkmodes: 0000000,00000000,00010fc0
[    4.226357] phylink_get_linkmodes: caps: 0xffffffff mac_capabilities: 
0xff
[    4.233258] after phylink_get_linkmodes: c000018,00000200,00036fff
[    4.239463] before anding supported with mask: 0000000,00000000,000062ff
[    4.246189] after anding supported with mask: 0000000,00000000,000062ff
[    4.252829] before anding advertising with mask: 
c000018,00000200,00036fff
[    4.259729] after anding advertising with mask: c000018,00000200,00036fff
[    4.266546] brcm-sf2 f0b00000.ethernet_switch gphy (uninitialized): 
PHY [f0b403c0.mdio--1:05] driver [Broadcom BCM7445] (irq=POLL)

and this is what a fixed link port looks like:

[    4.430765] brcm-sf2 f0b00000.ethernet_switch rgmii_2 
(uninitialized): Calling phylink_generic_validate
[    4.440205] before phylink_get_linkmodes: 0000000,00000000,00010fc0
[    4.446500] phylink_get_linkmodes: caps: 0xff mac_capabilities: 0xff
[    4.452880] after phylink_get_linkmodes: c000018,00000200,00036fff
[    4.459085] before anding supported with mask: fffffff,ffffffff,ffffffff
[    4.465811] after anding supported with mask: c000018,00000200,00036fff
[    4.472450] before anding advertising with mask: 
c000018,00000200,00036fff
[    4.479349] after anding advertising with mask: c000018,00000200,00036fff

or maybe the problem is with phylink_get_ksettings... ran out of time 
tonight to look further into it.
-- 
Florian
