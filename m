Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6615F7B2D8
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfG3TE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:04:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50437 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfG3TE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:04:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so58231723wml.0;
        Tue, 30 Jul 2019 12:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TALZPfb+WpDqyLifGxddXyZJ7WBu0H5Rhr+N38Fz5+4=;
        b=gbFonu87CBKjpx9Pu2VVHxbjpsu1z6MMSv6AJROsYayOxJqD3BSfoa+mEHxJmc9tYW
         zVaGRHqBPM4pXeBx/oBRBubaoFMdOTzyobXDdOo1XRmOaBA8dl8qPb/32hgg464ry1fx
         SXE4metJDSJq6Y6c22uoMGTofTQZT7DJr//8WWIYELwLpw4uBsq5YjGEULUvD//oNaBb
         2mZfTqex12ufBLcgj2Ozm/E40F7hJinJ67V0f5RtUX+WNlONI8+1gIi3XvwHCG02LjiX
         6gGCy9aZKbpZrMQ9G4rZm8EsxRuxH5IGOd/FTh2quhTSwcgMmf/WoKeUCC9BIngwsvYL
         Jv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TALZPfb+WpDqyLifGxddXyZJ7WBu0H5Rhr+N38Fz5+4=;
        b=PuXasQakQXbnqVJyrhmNtx5srpiN/KqUd+jQfOfIhb8jgWZcyEizJp1EN/8OBiEYtb
         7tMeimPcaU9X37Dxmy0Cbu8nDthKB5t+2jQUkBbfqc08AGYm53D2nNFUUDwhg+4NRHgq
         tfN5eCb11gUnAB4nWRxIqbJ0Iy20r1Oez01tFNtja7sQTI2y/kAm7dENesKT5TiDd9pM
         WBot+pDJnacdSi72WYK2WmsruuhqiXlljsuRl6aYvLbVfWp+P6RjTFQquqzCuIYkJnVl
         4HmiTdK6HvY4uO7eA0LMGDHnZwLEDTbqA+aWl6to1F7jCZ+rzSfW+umUXtGGGPcgQyNr
         U2QQ==
X-Gm-Message-State: APjAAAXP17ac3dv7JWkWoG59DdIV3F3Mj+D/X/+5O7XdNmV7dfsO1pPt
        2i5kCH/QtbU1Fwb6ZEzpqP8=
X-Google-Smtp-Source: APXvYqyien46k4zmmSmEOulBYafZP1z7bgGIjIG13i3wVvfGa7eeYNDAdKvoMpvBXWSwJVxXh+LRRQ==
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr55305002wmh.58.1564513465387;
        Tue, 30 Jul 2019 12:04:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:c54:56e0:ba51:95ce? (p200300EA8F4342000C5456E0BA5195CE.dip0.t-ipconnect.de. [2003:ea:8f43:4200:c54:56e0:ba51:95ce])
        by smtp.googlemail.com with ESMTPSA id x11sm46469576wmi.26.2019.07.30.12.04.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 12:04:24 -0700 (PDT)
Subject: Re: [RFC] net: phy: read link status twice when
 phy_check_link_status()
To:     liuyonglong <liuyonglong@huawei.com>, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
 <92f42ee8-3659-87a7-ac96-d312a98046ba@gmail.com>
 <4b4ba599-f160-39e7-d611-45ac53268389@huawei.com>
 <a0b26e4b-e288-cf44-049a-7d0b7f5696eb@gmail.com>
 <1d4be6ad-ffe6-2325-ceab-9f35da617ee9@huawei.com>
 <5087ee34-5776-f02b-d7e5-bce005ba3b92@gmail.com>
 <03708d00-a8d9-4a9d-4188-9fe0e38de2b8@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9a0a8094-42ee-0a18-0e9a-d3ca783d6d4b@gmail.com>
Date:   Tue, 30 Jul 2019 21:04:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <03708d00-a8d9-4a9d-4188-9fe0e38de2b8@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.07.2019 08:35, liuyonglong wrote:
> :/sys/kernel/debug/tracing$ cat trace
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 45/45   #P:128
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>     kworker/64:2-1028  [064] ....   172.295687: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.295726: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.296902: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.296938: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.321213: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x00 val:0x1040
>     kworker/64:2-1028  [064] ....   172.343209: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.343245: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.343882: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.343918: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.362658: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>     kworker/64:2-1028  [064] ....   172.385961: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.385996: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.386646: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.386681: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.411286: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x00 val:0x1040
>     kworker/64:2-1028  [064] ....   172.433225: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x02 val:0x001c
>     kworker/64:2-1028  [064] ....   172.433260: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x03 val:0xc916
>     kworker/64:2-1028  [064] ....   172.433887: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>     kworker/64:2-1028  [064] ....   172.433922: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0f val:0x2000
>     kworker/64:2-1028  [064] ....   172.452862: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>         ifconfig-1324  [011] ....   177.325585: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>   kworker/u257:0-8     [012] ....   177.325642: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x04 val:0x01e1
>   kworker/u257:0-8     [012] ....   177.325654: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x04 val:0x05e1
>   kworker/u257:0-8     [012] ....   177.325708: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [012] ....   177.325744: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:0-8     [012] ....   177.325779: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>   kworker/u257:0-8     [012] ....   177.325788: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1240
>   kworker/u257:0-8     [012] ....   177.325843: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d

What I think that happens here:
Writing 0x1240 to BMCR starts aneg. When reading BMSR immediately after that then the PHY seems to have cleared
the "aneg complete" bit already, but not yet the "link up" bit. This results in the false "link up" notification.
The following patch is based on the fact that in case of enabled aneg we can't have a valid link if aneg isn't
finished. Could you please test whether this works for you?

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6b5cb87f3..7ddd91df9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1774,6 +1774,12 @@ int genphy_update_link(struct phy_device *phydev)
 	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
 	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
 
+	/* Consider the case that autoneg was started and "aneg complete"
+	 * bit has been reset, but "link up" bit not yet.
+	 */
+	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
+		phydev->link = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL(genphy_update_link);
-- 
2.22.0





>   kworker/u257:0-8     [003] ....   178.360488: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:0-8     [000] ....   179.384479: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:0-8     [000] ....   180.408477: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
>   kworker/u257:0-8     [000] ....   181.432474: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79a9
>   kworker/u257:0-8     [000] ....   181.432510: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x7800
>   kworker/u257:0-8     [000] ....   181.432546: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:0-8     [000] ....   181.432582: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x05 val:0xc1e1
>   kworker/u257:0-8     [000] ....   182.456510: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   182.456546: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x4800
>   kworker/u257:0-8     [000] ....   182.456582: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>   kworker/u257:0-8     [000] ....   182.456618: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x05 val:0xc1e1
>   kworker/u257:0-8     [001] ....   183.480476: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   184.504478: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   185.528486: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>   kworker/u257:0-8     [000] ....   186.552475: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>         ifconfig-1327  [011] ....   187.196036: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>         ifconfig-1327  [011] ....   187.196046: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1840
> 
> 
[...]
>>
>>>
>>>
>>>
>>
>> Heiner
>>
>> .
>>
> 
> .
> 

