Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B86B85A49
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbfHHGLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:11:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35756 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfHHGLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 02:11:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so1151494wmg.0;
        Wed, 07 Aug 2019 23:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mMFe6N5rGAQL4xugeXf4jUCNrDrEI+HfMzmjEgPHykI=;
        b=EddoiczG0iEDxUrnZLmFmAqNUTIAcKmvU1h79i/77dDoNiShA1mWQ6EQ5Xkqr+wJsu
         gTBhutzRW+eKJMaJ9Jr3zDluF4xkAJQVA31ZY2jqSkIpobAV6lWikvowheyJwe2rc3fP
         BJiNDd0/M8RwqlE+Z+/RXa5vUqR1D1e1PzjdK4/qMyhEZZSumHDubiZJhZMlvslFYPXt
         b6gl5BP1Hy6mJ/wMxSzrjdQUTuNm3tj+jKSVAny582eC+DeD5W9dnVj7/vTc6hydXYjO
         FbXnynw5E4LGkICuX+phbOdBTg/yEE/ZsG9SOvj/fAAkcJR4gHkc4seNhFuUBXcVHi20
         80fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mMFe6N5rGAQL4xugeXf4jUCNrDrEI+HfMzmjEgPHykI=;
        b=XoGjFWpZvl2dkhayYT+e9uJIMQN6SmIoaYaLO5/gyf7Ptrsdn/Ph73KVywpKzEW7Tf
         5uIL+mgrrdPTJqrSBJZZqfsP01OOcuR82sgWG3rcOEEU2WHOfYS1/cbDJHDJQdcskxKl
         LlJD5ySyeCddnKl0ZN/1PImot5WRP137fCV3sg0o8tIfL+sKJXS2IIbBzb0t87waSScD
         /5ARzapN35rlNAga3vxRbNg95OhXprZIyvMtxk7vco1BKsw3FxRgAQPlBDt6J85Ly9YL
         9uxEGZkUF7ViXP/xANVpUsfdCqLXVh4waofTlOKv9vHB3f4oWVrioiKW/O4npzKHMSKR
         9nPg==
X-Gm-Message-State: APjAAAXO9zy4DrWTsHvv4xDsdF4ZVqHMZHkzf3837nfUmUftYd4VAdVp
        R7UZAXX7i2sl+G1nHbU78ZIPQmN3
X-Google-Smtp-Source: APXvYqyIoZr6LyMXbISicANkZCBY6Cts5JbF7pVB+ooQLCrXp3GC7DZv9SZsT/o+TOM8UmbrkTebPA==
X-Received: by 2002:a1c:c747:: with SMTP id x68mr2155419wmf.138.1565244704272;
        Wed, 07 Aug 2019 23:11:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b0d6:7b82:d784:3855? (p200300EA8F2F3200B0D67B82D7843855.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b0d6:7b82:d784:3855])
        by smtp.googlemail.com with ESMTPSA id 66sm13484231wrc.83.2019.08.07.23.11.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 23:11:43 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Yonglong Liu <liuyonglong@huawei.com>, davem@davemloft.net,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
 <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
 <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
Date:   Thu, 8 Aug 2019 08:11:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 03:15, Yonglong Liu wrote:
> 
> 
> On 2019/8/8 0:47, Heiner Kallweit wrote:
>> On 07.08.2019 15:16, Yonglong Liu wrote:
>>> [   27.232781] hns3 0000:bd:00.3 eth7: net open
>>> [   27.237303] 8021q: adding VLAN 0 to HW filter on device eth7
>>> [   27.242972] IPv6: ADDRCONF(NETDEV_CHANGE): eth7: link becomes ready
>>> [   27.244449] hns3 0000:bd:00.3: invalid speed (-1)
>>> [   27.253904] hns3 0000:bd:00.3 eth7: failed to adjust link.
>>> [   27.259379] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change UP -> RUNNING
>>> [   27.924903] hns3 0000:bd:00.3 eth7: link up
>>> [   28.280479] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change RUNNING -> NOLINK
>>> [   29.208452] hns3 0000:bd:00.3 eth7: link down
>>> [   32.376745] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change NOLINK -> RUNNING
>>> [   33.208448] hns3 0000:bd:00.3 eth7: link up
>>> [   35.253821] hns3 0000:bd:00.3 eth7: net stop
>>> [   35.258270] hns3 0000:bd:00.3 eth7: link down
>>>
>>> When using rtl8211f in polling mode, may get a invalid speed,
>>> because of reading a fake link up and autoneg complete status
>>> immediately after starting autoneg:
>>>
>>>         ifconfig-1176  [007] ....    27.232763: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>   kworker/u257:1-670   [015] ....    27.232805: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x04 val:0x01e1
>>>   kworker/u257:1-670   [015] ....    27.232815: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x04 val:0x05e1
>>>   kworker/u257:1-670   [015] ....    27.232869: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>   kworker/u257:1-670   [015] ....    27.232904: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>>>   kworker/u257:1-670   [015] ....    27.232940: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>   kworker/u257:1-670   [015] ....    27.232949: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
>>>   kworker/u257:1-670   [015] ....    27.233003: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>   kworker/u257:1-670   [015] ....    27.233039: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x3002
>>>   kworker/u257:1-670   [015] ....    27.233074: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>>>   kworker/u257:1-670   [015] ....    27.233110: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0x0000
>>>   kworker/u257:1-670   [000] ....    28.280475: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>>   kworker/u257:1-670   [000] ....    29.304471: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>>
>>> According to the datasheet of rtl8211f, to get the real time
>>> link status, need to read MII_BMSR twice.
>>>
>>> This patch add a read_status hook for rtl8211f, and do a fake
>>> phy_read before genphy_read_status(), so that can get real link
>>> status in genphy_read_status().
>>>
>>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>>> ---
>>>  drivers/net/phy/realtek.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>> Is this an accidental resubmit? Because we discussed this in
>> https://marc.info/?t=156413509900003&r=1&w=2 and a fix has
>> been applied already.
>>
>> Heiner
>>
>> .
>>
> 
> In https://marc.info/?t=156413509900003&r=1&w=2 , the invalid speed
> recurrence rate is almost 100%, and I had test the solution about
> 5 times and it works. But yesterday it happen again suddenly, and than
> I fount that the recurrence rate reduce to 10%. This time we get 0x79ad
> after autoneg started which is not 0x798d from last discussion.
> 
> 
> 
OK, I'll have a look.
However the approach is wrong. The double read is related to the latching
of link-down events. This is done by all PHY's and not specific to RT8211F.
Also it's not related to the problem. I assume any sufficient delay would
do instead of the read.
