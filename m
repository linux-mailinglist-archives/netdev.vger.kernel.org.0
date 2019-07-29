Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB7F79A7E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfG2U54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:57:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43869 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729766AbfG2U5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:57:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so63299451wru.10;
        Mon, 29 Jul 2019 13:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SEuaVqeqIen5ST+BepOc65oc/tfL5GJRQmltFmt0zpk=;
        b=LBFb5zz1LSYHWsxkt6YHg5XRL7rMYsm9XyuMdDIkIquvH4CgIQ38vEbK0W/cNDjHKF
         waGC5mXhT7lzy56X3jYIgV8y9Dmedr2zGafCW0UCgSjne9Rjj8r3poliJFjjHRtgd1rz
         VKEsrk6ZUzbACaOhQo23qWUhPNCMVdKjle9lu0e64ltXR7/5x1RRpNXW3qZS+P+tdHmt
         Pzwal1KgtJbauPwhMXDot6q985ltShPjQfj6iJEO9PBiE90ZWmUHgNIwcO8yrIU80lnn
         StkRzt2t4h0HKGM21fU7kFZudykXrfhyAslW6GUGdbLfe93iFm8vwnR6ihPs5ZjXah9W
         jpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SEuaVqeqIen5ST+BepOc65oc/tfL5GJRQmltFmt0zpk=;
        b=Gl1xLdrBuARlYMSS+7Z9+PLvUhofAC9spMkjTkhgS7iEgYOC9D7FH0bkNHvMhKaxRR
         5gRLDjBXTj+gRzE+trIRed9eLT/0272Z33vAK1K0cIN+XitxF+j7/Wvx495QYAtiX9iT
         ly7X4/gRwN2B1KPNhEJdTAnUPEEhl5evrAVSE7SCe6VzbQoepqmkYBFzqoo4JNeLBnUn
         PyTl5IWBP0rEmMI369zO3TNZQS2PTlCaSv+D1R9w/gSjDHyrChyiiJ7a06q6ZM2trpqR
         hNgXrBZC7YeQSo//u7qGF8r5yW0d6PZebeuzYvWQMQm9kE7M0XBjtJWkfnGIYUob3If1
         eY7Q==
X-Gm-Message-State: APjAAAVWBGPI2l9b0BTrVo6H6VhiSsLRDUDSBgdq3epGxiiXK4/3pDJO
        rCqZf5ysC9RA4CCjTRJjIHI=
X-Google-Smtp-Source: APXvYqzf8FpTCcqyJa/xIkaPbBpp0bTAs4WwFKTHQ7TQT3JVfk/duVeUulW18n4cBLyuHg0Fuaziww==
X-Received: by 2002:a05:6000:42:: with SMTP id k2mr1737578wrx.80.1564433872011;
        Mon, 29 Jul 2019 13:57:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:d48d:27cf:6853:632f? (p200300EA8F434200D48D27CF6853632F.dip0.t-ipconnect.de. [2003:ea:8f43:4200:d48d:27cf:6853:632f])
        by smtp.googlemail.com with ESMTPSA id o26sm129303630wro.53.2019.07.29.13.57.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:57:51 -0700 (PDT)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a0b26e4b-e288-cf44-049a-7d0b7f5696eb@gmail.com>
Date:   Mon, 29 Jul 2019 22:57:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4b4ba599-f160-39e7-d611-45ac53268389@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.07.2019 05:59, liuyonglong wrote:
> 
> 
> On 2019/7/27 2:14, Heiner Kallweit wrote:
>> On 26.07.2019 11:53, Yonglong Liu wrote:
>>> According to the datasheet of Marvell phy and Realtek phy, the
>>> copper link status should read twice, or it may get a fake link
>>> up status, and cause up->down->up at the first time when link up.
>>> This happens more oftem at Realtek phy.
>>>
>> This is not correct, there is no fake link up status.
>> Read the comment in genphy_update_link, only link-down events
>> are latched. Means if the first read returns link up, then there
>> is no need for a second read. And in polling mode we don't do a
>> second read because we want to detect also short link drops.
>>
>> It would be helpful if you could describe your actual problem
>> and whether you use polling or interrupt mode.
>>
> 
> [   44.498633] hns3 0000:bd:00.1 eth5: net open
> [   44.504273] hns3 0000:bd:00.1: reg=0x1, data=0x79ad -> called from phy_start_aneg
> [   44.532348] hns3 0000:bd:00.1: reg=0x1, data=0x798d -> called from phy_state_machine,update link.

This should not happen. The PHY indicates link up w/o having aneg finished.

> 
> According to the datasheet:
> reg 1.5=0 now, means copper auto-negotiation not complete
> reg 1.2=1 now, means link is up
> 
> We can see that, when we read the link up, the auto-negotiation
> is not complete yet, so the speed is invalid.
> 
> I don't know why this happen, maybe this state is keep from bios?
> Or we may do something else in the phy initialize to fix it?
> And also confuse that why read twice can fix it?
> 
I suppose that basically any delay would do.

> [   44.554063] hns3 0000:bd:00.1: invalid speed (-1)
> [   44.560412] hns3 0000:bd:00.1 eth5: failed to adjust link.
> [   45.194870] hns3 0000:bd:00.1 eth5: link up
> [   45.574095] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
> [   46.150051] hns3 0000:bd:00.1 eth5: link down
> [   46.598074] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x7989
> [   47.622075] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79a9
> [   48.646077] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
> [   48.934050] hns3 0000:bd:00.1 eth5: link up
> [   49.702140] hns3 0000:bd:00.1: phyid=3, reg=0x1, data=0x79ad
> 
>>> I add a fake status read, and can solve this problem.
>>>
>>> I also see that in genphy_update_link(), had delete the fake
>>> read in polling mode, so I don't know whether my solution is
>>> correct.
>>>

Can you test whether the following fixes the issue for you?
Also it would be interesting which exact PHY models you tested
and whether you built the respective PHY drivers or whether you
rely on the genphy driver. Best use the second patch to get the
needed info. It may make sense anyway to add the call to
phy_attached_info() to the hns3 driver.


diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6b5cb87f3..fbecfe210 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1807,7 +1807,8 @@ int genphy_read_status(struct phy_device *phydev)
 
 	linkmode_zero(phydev->lp_advertising);
 
-	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+	if (phydev->autoneg == AUTONEG_ENABLE &&
+	    (phydev->autoneg_complete || phydev->link)) {
 		if (phydev->is_gigabit_capable) {
 			lpagb = phy_read(phydev, MII_STAT1000);
 			if (lpagb < 0)
-- 
2.22.0


diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index abb1b4385..dc4dfd460 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -231,6 +231,8 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle)
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 			   phydev->advertising);
 
+	phy_attached_info(phydev);
+
 	return 0;
 }
 
-- 
2.22.0




>>> Or provide a phydev->drv->read_status functions for the phy I
>>> used is more acceptable?
>>>
>>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>>> ---
>>>  drivers/net/phy/phy.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index ef7aa73..0c03edc 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -1,4 +1,7 @@
>>>  // SPDX-License-Identifier: GPL-2.0+
>>> +	err = phy_read_status(phydev);
>>> +	if (err)
>>> +		return err;
>>
>> This seems to be completely wrong at that place.
>>
> 
> Sorry, this can be ignore.
> 
>>>  /* Framework for configuring and reading PHY devices
>>>   * Based on code in sungem_phy.c and gianfar_phy.c
>>>   *
>>> @@ -525,6 +528,11 @@ static int phy_check_link_status(struct phy_device *phydev)
>>>  
>>>  	WARN_ON(!mutex_is_locked(&phydev->lock));
>>>  
>>> +	/* Do a fake read */
>>> +	err = phy_read(phydev, MII_BMSR);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>>  	err = phy_read_status(phydev);
>>>  	if (err)
>>>  		return err;
>>>
>>
>>
>> .
>>
> 
> 

