Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE4645AD6E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhKWUgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhKWUgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:36:14 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6C6C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:33:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id ay10-20020a05600c1e0a00b0033aa12cdd33so2669412wmb.1
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F5Tj+FgnBpnQfDbmAek+Y6ONmf6buuHz3OjlgZiro6s=;
        b=LphbDz8hGeUq7SGeYNFyz9zgnh4OLmg7ygwGWuSJ6NiDR8MiQxBG+UJJUJfVzKDePW
         Ntv4PEK5NcjNwrR/BLheNkjyx8T1mEYHiS2C8w+Ck4PIXRYlxFdPqcSg0FftNwv0evIC
         +LRO1zjLWgvGgWmgA44iTBlxZlI/ncHAkgZflwnZWwsjUmZT2bKH2GOWcI5/2/aEhA2T
         aXOqGgr6IQs8EYZYS9T8/kqHNuVVDrYwA7d8Kwq50rmTjEbjMC7jm1F3ZH4HRqhx48yG
         I+LMBeSC8OXhernpBFrCtA/kKwGv1QJHrQBKfrMZgOpkrPWXQl+i20d/XX+J+bPVL7WK
         HKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F5Tj+FgnBpnQfDbmAek+Y6ONmf6buuHz3OjlgZiro6s=;
        b=4Mj21gabXv8/jTycUAI6v676VJWiLhe5inMyA4B+QT7adyF50vjczk8RT3DXa3SD83
         YcFqtLeOz+CAaOTxlDOujZHfUfI8iQ8dEWg5lPmdL1Z41b0p6BsqgtYOBj+k4SEcop4+
         zcu6jKsnefTxkb0woNuKRh3gzff+VFzXlGudSnYfsEFXX9SBvWp4XbotWQ6USkqWCmJI
         7Mc1Ca6TydHAw0KPfJR6l5y6nLu/RD3DOfyFikWoDmALuPpR8VnelCdDwSV4sSHPJz0C
         vUelb+v94j2bPaaOU8kb4Oyhqm/0SS9f/8ljsCjhozlF7i2bSbz4gwEtX+4LladIHCv4
         SaDA==
X-Gm-Message-State: AOAM532TOE8fBCsxqXuL4apuYfrNN7MDcivvqv65+sF4/x9UvSykokjX
        J1Y78w9eU995hQi0iZJnINPk0vv7Lmo=
X-Google-Smtp-Source: ABdhPJz47/NKYkAcrPjOnEnSj+G2lgd9bOFAhilg2/Coxebqe1W0fUVU5DoUBcX7ftl/ed51Uw97zQ==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr7161399wma.17.1637699584078;
        Tue, 23 Nov 2021 12:33:04 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:7439:2487:e599:a391? (p200300ea8f1a0f0074392487e599a391.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:7439:2487:e599:a391])
        by smtp.googlemail.com with ESMTPSA id d1sm12406821wrz.92.2021.11.23.12.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 12:33:03 -0800 (PST)
Message-ID: <06d158a7-4b1f-d635-2de8-7b34b9c2b0c2@gmail.com>
Date:   Tue, 23 Nov 2021 21:32:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Content-Language: en-US
To:     Alessandro B Maurici <abmaurici@gmail.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
References: <20211122235548.38b3fc7c@work> <YZxrhhm0YdfoJcAu@lunn.ch>
 <20211123014946.1ec2d7ee@work>
 <017ea94f-7caf-3d4e-5900-aa23a212aa26@gmail.com> <YZz2irnGkrVQPjTb@lunn.ch>
 <20211123130634.14fa4972@work>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20211123130634.14fa4972@work>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.11.2021 17:06, Alessandro B Maurici wrote:
> On Tue, 23 Nov 2021 15:11:22 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>> Yes, that is the change i would make. When adding the extra locks i
>> missed that a driver was doing something like this. I will check all
>> other callers to see if they are using it in odd contexts.
>>
>>      Andrew
> 
> Andrew, this kinda of implementation is really hard to get in a fast review, 
> fortunately I happen to be testing one lan743x board with a 5.10.79 kernel
> that had the new locks in place, and noticed that really fast, but I wrongly 
> assumed that call was okayish since the driver was on stable.
> If you need to do some testing I will still have the hardware with me for 
> some time.
> 
> Alessandro
> 

Great that you have test hw, could you please test the following patch?
The duplex argument of lan743x_phy_update_flowcontrol() seems to be some
leftover, it isn't used and can be removed.


diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 4fc97823b..7d7647481 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -914,8 +914,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
 }
 
 static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
-					   u8 duplex, u16 local_adv,
-					   u16 remote_adv)
+					   u16 local_adv, u16 remote_adv)
 {
 	struct lan743x_phy *phy = &adapter->phy;
 	u8 cap;
@@ -943,7 +942,6 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
-		struct ethtool_link_ksettings ksettings;
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
@@ -980,18 +978,14 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		}
 		lan743x_csr_write(adapter, MAC_CR, data);
 
-		memset(&ksettings, 0, sizeof(ksettings));
-		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->advertising);
 		remote_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->lp_advertising);
 
-		lan743x_phy_update_flowcontrol(adapter,
-					       ksettings.base.duplex,
-					       local_advertisement,
+		lan743x_phy_update_flowcontrol(adapter, local_advertisement,
 					       remote_advertisement);
-		lan743x_ptp_update_latency(adapter, ksettings.base.speed);
+		lan743x_ptp_update_latency(adapter, phydev->speed);
 	}
 }
 
-- 
2.34.0


