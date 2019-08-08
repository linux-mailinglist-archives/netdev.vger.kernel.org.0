Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA2E86A8D
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404362AbfHHT0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:26:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38615 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404125AbfHHT0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:26:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so96010735wrr.5;
        Thu, 08 Aug 2019 12:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDha1YP1YfCEUXIsbCdYO3IHSXU8z4kQD9ISkOmKkRY=;
        b=R6RlJ6tg9Clscak62oIbLQtG+6o1njnC4tb26XLLwwkb2xy8XfSu8DxnsxcurQle2Z
         z6N35EcDyxMSokOIiU0AP7B+hY8yQdix4lWWfelV/NcGE5nM8ffk65Jw2tWVX/82vszs
         j47Mx1Y4vTQSJcTPGZUCD1FVWJgucntlZksUi0dtsl6I74YxH29K8/wkZK2nF9d89xK+
         +dsv87ZWW8KScKUVSP70o22tvwKL6dyKYbqEwR6PXG02LcwCEElntPyzpZVn2iJypq67
         9LCCEZ5H6q5vtqbFBJwe1sBDDQiaVyOCUPJBVcpUdM/rc4BWN6PNB2fkHTB/UkG90uTa
         CriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDha1YP1YfCEUXIsbCdYO3IHSXU8z4kQD9ISkOmKkRY=;
        b=Ls81z4SJ9cUnFGezgiuPLKCeX3rNkc+mXHAO3MCdQAKtbHBKXtOfGN/Nqrsl8QY7DW
         UUz8HBYMOHUTRQVH1PkvOknddtI2EmYg07h5Yagrvm6feg39KshKe8s+TElMVdjV8hpg
         ntpXyJgy8mBOUQSccIsljrhrpGN9T/LHrkvTRX3TeIfQmbt+BHxT/2rx1HXgZlMtIDy1
         dqBXn4usV21pU0hKEKNtGR8ZeBvoyGgv/GhmhaMwTs95sWuuGX1cK3mIPNfLsOzN3O+r
         BYAR95NKgDsYBXG18ccmg+IMeAsler+vMx4EviR9sPPb4rZeZW8WK9as/1zcvT4lPK8P
         ECGw==
X-Gm-Message-State: APjAAAWtCyyvo4MXKvraPWLZPTc2WIaxGte19ilVM/+e2hlB9J2lhio1
        lIMf7nThqDi43AqfwC03gIQ=
X-Google-Smtp-Source: APXvYqyvbMYpXi1SLeExdaix8sDIhHyYGTXnrbgCOif2cO2m9VFhh/WS1T5FpKqFTwf/OU0NdYY3yw==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr18800434wrp.113.1565292394789;
        Thu, 08 Aug 2019 12:26:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id 66sm17984686wrc.83.2019.08.08.12.26.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:26:34 -0700 (PDT)
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
 <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
 <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b1140603-f05b-2373-445f-c1d7a43ff012@gmail.com>
Date:   Thu, 8 Aug 2019 21:26:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 08:21, Yonglong Liu wrote:
> 
> 
> On 2019/8/8 14:11, Heiner Kallweit wrote:
>> On 08.08.2019 03:15, Yonglong Liu wrote:
>>>
>>>
>>> On 2019/8/8 0:47, Heiner Kallweit wrote:
>>>> On 07.08.2019 15:16, Yonglong Liu wrote:
>>>>> [   27.232781] hns3 0000:bd:00.3 eth7: net open
>>>>> [   27.237303] 8021q: adding VLAN 0 to HW filter on device eth7
>>>>> [   27.242972] IPv6: ADDRCONF(NETDEV_CHANGE): eth7: link becomes ready
>>>>> [   27.244449] hns3 0000:bd:00.3: invalid speed (-1)
>>>>> [   27.253904] hns3 0000:bd:00.3 eth7: failed to adjust link.
>>>>> [   27.259379] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change UP -> RUNNING
>>>>> [   27.924903] hns3 0000:bd:00.3 eth7: link up
>>>>> [   28.280479] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change RUNNING -> NOLINK
>>>>> [   29.208452] hns3 0000:bd:00.3 eth7: link down
>>>>> [   32.376745] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change NOLINK -> RUNNING
>>>>> [   33.208448] hns3 0000:bd:00.3 eth7: link up
>>>>> [   35.253821] hns3 0000:bd:00.3 eth7: net stop
>>>>> [   35.258270] hns3 0000:bd:00.3 eth7: link down
>>>>>
>>>>> When using rtl8211f in polling mode, may get a invalid speed,
>>>>> because of reading a fake link up and autoneg complete status
>>>>> immediately after starting autoneg:
>>>>>
>>>>>         ifconfig-1176  [007] ....    27.232763: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>>>   kworker/u257:1-670   [015] ....    27.232805: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x04 val:0x01e1
>>>>>   kworker/u257:1-670   [015] ....    27.232815: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x04 val:0x05e1
>>>>>   kworker/u257:1-670   [015] ....    27.232869: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>>>   kworker/u257:1-670   [015] ....    27.232904: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>>>>>   kworker/u257:1-670   [015] ....    27.232940: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>>>   kworker/u257:1-670   [015] ....    27.232949: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
>>>>>   kworker/u257:1-670   [015] ....    27.233003: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>>>   kworker/u257:1-670   [015] ....    27.233039: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x3002
>>>>>   kworker/u257:1-670   [015] ....    27.233074: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
>>>>>   kworker/u257:1-670   [015] ....    27.233110: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0x0000
>>>>>   kworker/u257:1-670   [000] ....    28.280475: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>>>>   kworker/u257:1-670   [000] ....    29.304471: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
>>>>>
>>>>> According to the datasheet of rtl8211f, to get the real time
>>>>> link status, need to read MII_BMSR twice.
>>>>>
>>>>> This patch add a read_status hook for rtl8211f, and do a fake
>>>>> phy_read before genphy_read_status(), so that can get real link
>>>>> status in genphy_read_status().
>>>>>
>>>>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>>>>> ---
>>>>>  drivers/net/phy/realtek.c | 13 +++++++++++++
>>>>>  1 file changed, 13 insertions(+)
>>>>>
>>>> Is this an accidental resubmit? Because we discussed this in
>>>> https://marc.info/?t=156413509900003&r=1&w=2 and a fix has
>>>> been applied already.
>>>>
>>>> Heiner
>>>>
>>>> .
>>>>
>>>
>>> In https://marc.info/?t=156413509900003&r=1&w=2 , the invalid speed
>>> recurrence rate is almost 100%, and I had test the solution about
>>> 5 times and it works. But yesterday it happen again suddenly, and than
>>> I fount that the recurrence rate reduce to 10%. This time we get 0x79ad
>>> after autoneg started which is not 0x798d from last discussion.
>>>
>>>
>>>
>> OK, I'll have a look.
>> However the approach is wrong. The double read is related to the latching
>> of link-down events. This is done by all PHY's and not specific to RT8211F.
>> Also it's not related to the problem. I assume any sufficient delay would
>> do instead of the read.
>>
>> .
>>
> 
> So you will send a new patch to fix this problem? I am waiting for it,
> and can do a full test this time.
> 
> 
Can you try the following? This delay should give thy PHY enough time
to clear both bits before the following read is done.

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef7aa738e..32f327a44 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -568,6 +568,11 @@ int phy_start_aneg(struct phy_device *phydev)
 	if (err < 0)
 		goto out_unlock;
 
+	/* The PHY may not yet have cleared aneg-completed and link-up bit
+	 * w/o this delay when the following read is done.
+	 */
+	usleep_range(1000, 2000);
+
 	if (phy_is_started(phydev))
 		err = phy_check_link_status(phydev);
 out_unlock:
-- 
2.22.0


