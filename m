Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F90883A6
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHIUFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:05:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34625 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfHIUFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:05:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so99325121wrm.1;
        Fri, 09 Aug 2019 13:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5aZ6nPjZggF+jzuY+IlnKBeULmKBMTJ+DxW3V3rlEc0=;
        b=NDHhR8NCG8Qn1R2Bt1HpyvZvJcLxlsMyMAN//KNAm8gvOGnrr7l6q95SaBk4dWXNuE
         MYZHrSikm6xpum4FWCgD/uRL6vwAmqTDDyXlFWZzl4LAwHU54n+eLMXIbCos5R+qcj6U
         okX6qvnSTNEC12ysbEYZcrdFGJ2Xx0RJ98Op+8ZqzWgdJqO05dmh4E6VC855hf10+AlL
         g4CDLeAo6IqS/05oRlVzj/on/if6iAsJ2gJDMdZee0m31Jv/QM1OnUaET22UXMdDL6pG
         o7s9QByFsmQSz7gL2zWRuyEOiTtaR/5MzJ0wWb6lPtD2CKumnLAaaYqkfXTBJ+iBDiU9
         7LJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5aZ6nPjZggF+jzuY+IlnKBeULmKBMTJ+DxW3V3rlEc0=;
        b=TgcJiK96zIRIxjSOTQ6xiEUDWl9LG2v3wi+B/tbISjxzvpoY7NYY77kNVe2XKo1RqD
         fKkHY0MbtkzjiHqKHvHNZybINt1Hz1BkPozuIZ9M5lr88/iTRIRJ534hnoRIKw2V62qj
         5REzS0SXCnselER/Krns1xptO4zZGWDzFKQH0Vcrg7hXjVOfRRpZ+eET341RD9wEOih+
         8RAA6EJITKpcc7ci0ZXyGTqpOXC+nZLY6VMuT1ThTtg1+5YPk00AOmKzJOEzNWrYp3FI
         wyDepBr3wTi/700SjVC7c82eBJ+cCHdG9MJn4aDr2soodHOXQ8qqi3fhJ/KPoaUqLITd
         uNGA==
X-Gm-Message-State: APjAAAXKDUW4sOBdeD1tUJR8JvYQkrSuXxfE2bEqjwMDT4wUMkenEBnr
        G7ZQgsNOAYpJac3Ifv1lu98=
X-Google-Smtp-Source: APXvYqzu6i93OF14Xy9akpmrTnshCEIKOhybVPy7hWroeZ+iNCczRiVKBZubbPzytFq4Fp4E+Y0D7A==
X-Received: by 2002:a5d:4804:: with SMTP id l4mr14135722wrq.111.1565381146938;
        Fri, 09 Aug 2019 13:05:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id o11sm269068wrw.19.2019.08.09.13.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 13:05:46 -0700 (PDT)
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real time
 link status
To:     Yonglong Liu <liuyonglong@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        shiju.jose@huawei.com
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
 <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
 <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
 <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
 <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
 <b1140603-f05b-2373-445f-c1d7a43ff012@gmail.com>
 <20190808194049.GM27917@lunn.ch>
 <26e2c5c9-915c-858b-d091-e5bfa7ab6a5b@gmail.com>
 <20190808203415.GO27917@lunn.ch>
 <414c6809-86a3-506c-b7b0-a32b7cd72fd6@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7f18113e-268b-6a4a-af83-236cfa337fcd@gmail.com>
Date:   Fri, 9 Aug 2019 22:05:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <414c6809-86a3-506c-b7b0-a32b7cd72fd6@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.08.2019 06:57, Yonglong Liu wrote:
> 
> 
> On 2019/8/9 4:34, Andrew Lunn wrote:
>> On Thu, Aug 08, 2019 at 10:01:39PM +0200, Heiner Kallweit wrote:
>>> On 08.08.2019 21:40, Andrew Lunn wrote:
>>>>> @@ -568,6 +568,11 @@ int phy_start_aneg(struct phy_device *phydev)
>>>>>  	if (err < 0)
>>>>>  		goto out_unlock;
>>>>>  
>>>>> +	/* The PHY may not yet have cleared aneg-completed and link-up bit
>>>>> +	 * w/o this delay when the following read is done.
>>>>> +	 */
>>>>> +	usleep_range(1000, 2000);
>>>>> +
>>>>
>>>> Hi Heiner
>>>>
>>>> Does 802.3 C22 say anything about this?
>>>>
>>> C22 says:
>>> "The Auto-Negotiation process shall be restarted by setting bit 0.9 to a logic one. This bit is self-
>>> clearing, and a PHY shall return a value of one in bit 0.9 until the Auto-Negotiation process has been
>>> initiated."
>>>
>>> Maybe we should read bit 0.9 in genphy_update_link() after having read BMSR and report
>>> aneg-complete and link-up as false (no matter of their current value) if 0.9 is set.
>>
>> Yes. That sounds sensible.
>>
>>      Andrew
>>
>> .
>>
> 
> Hi Heiner:
> 	I have test more than 50 times, it works. Previously less
> than 20 times must be recurrence. so I think this patch solved the
> problem.
> 	And I checked about 40 times of the time gap between read
> and autoneg started, all of them is more than 2ms, as below:
> 
>   kworker/u257:1-670   [015] ....    27.182632: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
>   kworker/u257:1-670   [015] ....    27.184670: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
> 
> 

Instead of using this fixed delay, the following experimental patch
considers that fact that between triggering aneg start and actual
start of aneg (incl. clearing aneg-complete bit) Clause 22 requires
a PHY to keep bit 0.9 (aneg restart) set.
Could you please test this instead of the fixed-delay patch?

Thanks, Heiner

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b039632de..163295dbc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1741,7 +1741,17 @@ EXPORT_SYMBOL(genphy_aneg_done);
  */
 int genphy_update_link(struct phy_device *phydev)
 {
-	int status;
+	int status = 0, bmcr;
+
+	bmcr = phy_read(phydev, MII_BMCR);
+	if (bmcr < 0)
+		return bmcr;
+
+	/* Autoneg is being started, therefore disregard BMSR value and
+	 * report link as down.
+	 */
+	if (bmcr & BMCR_ANRESTART)
+		goto done;
 
 	/* The link state is latched low so that momentary link
 	 * drops can be detected. Do not double-read the status
-- 
2.22.0


