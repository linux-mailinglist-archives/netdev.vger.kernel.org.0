Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F7F85160
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbfHGQrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 12:47:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51435 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGQrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 12:47:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so722738wma.1;
        Wed, 07 Aug 2019 09:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=akLvufD3EkGjHJTFV1gz/uYhaLH62lK4qFV6ud8HiEw=;
        b=I8a/KDP93d/rbkNxHq4aDhLqc8vBR3gtRg8BFmAiGGFV2EjE61sHIc2RA6ry9xW3XR
         av8SgzYu1TsjhP5noZ6c3RiU4Cj5JRKJn4JZH2iCLO/NvOY1L9PpHx9hvejGbB+nlxEY
         1Q6sa6BRN35DRWB+QmGI+UwUu9GYJgprhoV6mmH1pRkcY3ID5AJAF55GilXpkVwCpayb
         CW6RPiVowEE3YHJkre3dGMiSB6n44l8r3DiJ/uDAlRrMJKmKzVUQ3TTlvxfQ4fGAev6Z
         sqbcNSxXlF41I/n/lUM+Tf7R4HGOEONh8ux9YLJVCAgdGXssuxSbUAPKF2HIdAcgq8DL
         b3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akLvufD3EkGjHJTFV1gz/uYhaLH62lK4qFV6ud8HiEw=;
        b=GraPpCqqvPOvfOpAdHzL5DS2OWpoYTMW0TJdV4p3+fbfg04S8QMu1bOzIem4w59ueI
         kP38YTNr1Ct3rYHRuy1mSCFeyvKcr5xdeyRLfZGYXRExvMaBC7Tt9YeaDIIAGmAX7oY+
         FykVJ0MwfIePYKDqoW61+P/yrCEenWt8QMeSf4Py5bmXucR9i3ERxyuaRL4ACoCS4kwx
         aEFugoSfjPCizWZsz7WhvREN/tLt+eqN+/upA9gGTMEGrc+HmKZiGEa00fF7eWcOdkF8
         WFSH9DohMQLJqByRMQrBGJo9bW6baxCYYiAYSMo+ur3ZKjDALusH8I6OyKo4n8X7GkTD
         Whkg==
X-Gm-Message-State: APjAAAXFoleltL+muxD1DellZGXrtmFPfgr57/wdsMGFy3gXiqyISZm8
        omuE5qxAyHORimim0zstgSMXlr/c
X-Google-Smtp-Source: APXvYqwb+InCsQeyKw/kTeV4kPspqtZ0bOwlPhVYzCValMnY81scF3HtYoNXtEphDhBvxzBRMLIOug==
X-Received: by 2002:a1c:a8c9:: with SMTP id r192mr834222wme.43.1565196439338;
        Wed, 07 Aug 2019 09:47:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f05:8600:b42b:6698:8ac6:22d3? (p200300EA8F058600B42B66988AC622D3.dip0.t-ipconnect.de. [2003:ea:8f05:8600:b42b:6698:8ac6:22d3])
        by smtp.googlemail.com with ESMTPSA id p13sm17489432wrw.90.2019.08.07.09.47.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 09:47:18 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Yonglong Liu <liuyonglong@huawei.com>, davem@davemloft.net,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
Date:   Wed, 7 Aug 2019 18:47:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.08.2019 15:16, Yonglong Liu wrote:
> [   27.232781] hns3 0000:bd:00.3 eth7: net open
> [   27.237303] 8021q: adding VLAN 0 to HW filter on device eth7
> [   27.242972] IPv6: ADDRCONF(NETDEV_CHANGE): eth7: link becomes ready
> [   27.244449] hns3 0000:bd:00.3: invalid speed (-1)
> [   27.253904] hns3 0000:bd:00.3 eth7: failed to adjust link.
> [   27.259379] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change UP -> RUNNING
> [   27.924903] hns3 0000:bd:00.3 eth7: link up
> [   28.280479] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change RUNNING -> NOLINK
> [   29.208452] hns3 0000:bd:00.3 eth7: link down
> [   32.376745] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change NOLINK -> RUNNING
> [   33.208448] hns3 0000:bd:00.3 eth7: link up
> [   35.253821] hns3 0000:bd:00.3 eth7: net stop
> [   35.258270] hns3 0000:bd:00.3 eth7: link down
> 
> When using rtl8211f in polling mode, may get a invalid speed,
> because of reading a fake link up and autoneg complete status
> immediately after starting autoneg:
> 
>         ifconfig-1176  [007] ....    27.232763: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>   kworker/u257:1-670   [015] ....    27.232805: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x04 val:0x01e1
>   kworker/u257:1-670   [015] ....    27.232815: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x04 val:0x05e1
>   kworker/u257:1-670   [015] ....    27.232869: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>   kworker/u257:1-670   [015] ....    27.232904: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>   kworker/u257:1-670   [015] ....    27.232940: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>   kworker/u257:1-670   [015] ....    27.232949: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
>   kworker/u257:1-670   [015] ....    27.233003: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>   kworker/u257:1-670   [015] ....    27.233039: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x3002
>   kworker/u257:1-670   [015] ....    27.233074: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>   kworker/u257:1-670   [015] ....    27.233110: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0x0000
>   kworker/u257:1-670   [000] ....    28.280475: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>   kworker/u257:1-670   [000] ....    29.304471: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
> 
> According to the datasheet of rtl8211f, to get the real time
> link status, need to read MII_BMSR twice.
> 
> This patch add a read_status hook for rtl8211f, and do a fake
> phy_read before genphy_read_status(), so that can get real link
> status in genphy_read_status().
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> ---
>  drivers/net/phy/realtek.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
Is this an accidental resubmit? Because we discussed this in
https://marc.info/?t=156413509900003&r=1&w=2 and a fix has
been applied already.

Heiner
