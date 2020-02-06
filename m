Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63551154EE5
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 23:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBFW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 17:28:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36384 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBFW2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 17:28:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so620090wma.1;
        Thu, 06 Feb 2020 14:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/XKdc786BlHsuS391XW0HO1yo5xwSNIfmNJ4CcftD44=;
        b=TUcEMnCRxzOwEQdj6EGxD1ELjXTLsU59pYxsRmSjgeWAmt8GKg9r4ujwIUg/gHS+Nd
         woIOl2FuXZDQso1roMFkgaCMdP4+5FTP2vwkW3ZSXGo5wqYpWnLyoYs4gMhgPzXjRjoC
         jigHGaLFexaoH1dT4xMxtlRZh1pNKYZa6N+u3HqIcfVlXp8C2yMH8eS8CBYs3T5whHnD
         nFh4iD9Paij/wAMUpMe05EIJK4b8tfDBYypdbU4J6zdX6u8DdfEjakpy8GcH8aBn2vFl
         /ZFWzJ7fUXtiqdyDC5MGbzjv/SzV40IZIqEtOM0K8ndOeRFwbi5CWyCs+W2PSvGriIES
         +cjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XKdc786BlHsuS391XW0HO1yo5xwSNIfmNJ4CcftD44=;
        b=hZTZNx66hmfAuc9HJrBUSUofIT7VCLo6x784dumZQBQWyF5pWyx/e7f0JEAcP/tOXC
         Mi4fe1l8KQwZLZHhsTLKOKEj63cGEqjxd7E+iTcH/hnKIz+x1KBD3wVHsyzjDksOQef2
         J5dN4fohuJ97anyUH/8ly9GzxX1Os6PqWxv6ah2gE7U7UeGbTgopzHtFhflwFiO6euiy
         zOmOYfRLdOgTJUIx4nEpkj851iS2EM27AhA84P8JdkIaTAdYYX74POuQwr8VgYrTb5/B
         RwhQX+9iMSCdlxVEGSycYr8bqzCEX2eIJRJEa5K47crexwjuLRqUVKIv2UO4xI6wL3rI
         hpww==
X-Gm-Message-State: APjAAAUF34DgTxZ0wISqppEe1hTERBS8XvT+yVD/51izEh93GXPY4q+l
        tAkFMNMf/rnhNNKAZwdzV/lUMCLi
X-Google-Smtp-Source: APXvYqydod22hrGLFmw6z29Dtgq3ueK6x6Jx7VLXKNSnCJqQEFk+pPKaNq0sd3Aos7g0pKCoVlVBGw==
X-Received: by 2002:a05:600c:54d:: with SMTP id k13mr13248wmc.188.1581028100271;
        Thu, 06 Feb 2020 14:28:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:ccdf:10a:e87a:1f49? (p200300EA8F296000CCDF010AE87A1F49.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ccdf:10a:e87a:1f49])
        by smtp.googlemail.com with ESMTPSA id 21sm990642wmo.8.2020.02.06.14.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 14:28:19 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <47b9b462-6649-39a7-809f-613ce832bd5c@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <59ce70e0-4404-cade-208d-d089ed238f30@gmail.com>
Date:   Thu, 6 Feb 2020 23:28:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <47b9b462-6649-39a7-809f-613ce832bd5c@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.02.2020 23:13, Dan Murphy wrote:
> Heiner
> 
> On 2/5/20 3:16 PM, Heiner Kallweit wrote:
>> On 04.02.2020 19:13, Dan Murphy wrote:
>>> Set the speed optimization bit on the DP83867 PHY.
>>> This feature can also be strapped on the 64 pin PHY devices
>>> but the 48 pin devices do not have the strap pin available to enable
>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>
>>> With this bit set the PHY will auto negotiate and report the link
>>> parameters in the PHYSTS register.  This register provides a single
>>> location within the register set for quick access to commonly accessed
>>> information.
>>>
>>> In this case when auto negotiation is on the PHY core reads the bits
>>> that have been configured or if auto negotiation is off the PHY core
>>> reads the BMCR register and sets the phydev parameters accordingly.
>>>
>>> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
>>> 4-wire cable.  If this should occur the PHYSTS register contains the
>>> current negotiated speed and duplex mode.
>>>
>>> In overriding the genphy_read_status the dp83867_read_status will do a
>>> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
>>> register is read and the phydev speed and duplex mode settings are
>>> updated.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> ---
>>> v2 - Updated read status to call genphy_read_status first, added link_change
>>> callback to notify of speed change and use phy_set_bits - https://lore.kernel.org/patchwork/patch/1188348/
>>>
>> As stated in the first review, it would be appreciated if you implement
>> also the downshift tunable. This could be a separate patch in this series.
>> Most of the implementation would be boilerplate code.
> 
> 
> I looked at this today and there are no registers that allow tuning the downshift attempts.  There is only a RO register that tells you how many attempts it took to achieve a link.  So at the very least we could put in the get_tunable but there will be no set.
> 
The get operation for the downshift tunable should return after how many failed
attempts the PHY starts a downshift. This doesn't match with your description of
this register, so yes: Implementing the tunable for this PHY doesn't make sense.

However this register may be useful in the link_change_notify() callback to
figure out whether a downshift happened, to trigger the info message you had in
your first version.

> So we should probably skip this for this PHY.
> 
> Dan
> 
Heiner
