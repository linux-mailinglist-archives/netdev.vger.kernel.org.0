Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2337B943
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfGaFxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:53:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50307 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfGaFxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:53:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so59400930wml.0;
        Tue, 30 Jul 2019 22:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2JTqLAiaEqn4jb2/kDH9to4xIdNkVzT/KRCcOQVGiWA=;
        b=XHIhXfbzV6O6NqjePEP+GAdd2O7islM48KasbZHOuxIkXfhQAsXkdqqaFiqB7LFOXa
         XBoo4F93vl//1nKoUXExjLdGOqz6wmvKO2UOnV168P9vZBz8EnT2pS1Xn47y0rLWoPER
         9Qm8yi65yiQAkWxZTquMKtVvgN6uGUEt5V9wEXHScGdU99lVp9gJzPkZ151chjigJje4
         FegQiICcEsJnpzrvt0kU017xMkL20Tg2O0fSCDsSIcInxZ79uYyIkEs5SMnvHqtTR9sv
         F1CuNuVAUlwLqfCUy0ViZQRgTFC0J2LHf+nJMrOyd6VBC9nelrW6LC5cvmSduGtgqy7O
         pkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2JTqLAiaEqn4jb2/kDH9to4xIdNkVzT/KRCcOQVGiWA=;
        b=tHMAKSuskXW+3KWr5lHm2RkpNQQF0v1GRAlewRRaNk/BA7E7l1HK0syDfl/BGsjWbW
         uWbwJq5BOZODAULOGFJR/wcS9tXLn2OGjPxRwbIqC38RodgRndfyVXLkcMGLLrc8WhiR
         VMfQW0z2cH5MvNKhy3oXds4f6C/ck9czycwVLgz4LwWJI16a0KpGSuauA0JQA/sGT5iR
         n4jCTJZRO2+rb+5VHfYRMNTIKwMHVc9c+LM4yZ6vCfgbkc+BP9CuwF3/8MxOhC6dbp8r
         EKdrYWtQZnR2GIvTmhr2qcS3EbamrixOZ2A25lnyFAUIwC5fx/kbSN9w83+TRFSUJqXo
         3ORw==
X-Gm-Message-State: APjAAAUvCuWdnQV6RYbEoQuqGhM6IajagxMrcbcV8MCHPDobQpO38SaY
        sOkqh/7uio2xZFCrVhrMlOM=
X-Google-Smtp-Source: APXvYqxADSkVC3kemNRRL16/R/vJwoRHPCEJZtJYenFRHMIsUzp2XPOTrklyEPyTCX504Hl/JSawoA==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr7155081wmb.32.1564552430383;
        Tue, 30 Jul 2019 22:53:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:f423:8074:ec73:3cf8? (p200300EA8F434200F4238074EC733CF8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:f423:8074:ec73:3cf8])
        by smtp.googlemail.com with ESMTPSA id o20sm169985833wrh.8.2019.07.30.22.53.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 22:53:49 -0700 (PDT)
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
 <9a0a8094-42ee-0a18-0e9a-d3ca783d6d4b@gmail.com>
 <6add4874-fd2b-9b21-cd78-80b6dde4dd53@huawei.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5634113b-f5b5-6fa8-851d-1402e046c3df@gmail.com>
Date:   Wed, 31 Jul 2019 07:44:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6add4874-fd2b-9b21-cd78-80b6dde4dd53@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.07.2019 05:33, liuyonglong wrote:
> 
> 
> On 2019/7/31 3:04, Heiner Kallweit wrote:
>> On 30.07.2019 08:35, liuyonglong wrote:
>>> :/sys/kernel/debug/tracing$ cat trace
>>> # tracer: nop
>>> #
>>> # entries-in-buffer/entries-written: 45/45   #P:128
>>> #
>>> #                              _-----=> irqs-off
>>> #                             / _----=> need-resched
>>> #                            | / _---=> hardirq/softirq
>>> #                            || / _--=> preempt-depth
>>> #                            ||| /     delay
>>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>>> #              | |       |   ||||       |         |
>>>     kworker/64:2-1028  [064] ....   172.295687: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x02 val:0x001c
>>>     kworker/64:2-1028  [064] ....   172.295726: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x03 val:0xc916
>>>     kworker/64:2-1028  [064] ....   172.296902: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x01 val:0x79ad
>>>     kworker/64:2-1028  [064] ....   172.296938: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x0f val:0x2000
>>>     kworker/64:2-1028  [064] ....   172.321213: mdio_access: mii-0000:bd:00.0 read  phy:0x01 reg:0x00 val:0x1040
>>>     kworker/64:2-1028  [064] ....   172.343209: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x02 val:0x001c
>>>     kworker/64:2-1028  [064] ....   172.343245: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x03 val:0xc916
>>>     kworker/64:2-1028  [064] ....   172.343882: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>>>     kworker/64:2-1028  [064] ....   172.343918: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0f val:0x2000
>>>     kworker/64:2-1028  [064] ....   172.362658: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>>>     kworker/64:2-1028  [064] ....   172.385961: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x02 val:0x001c
>>>     kworker/64:2-1028  [064] ....   172.385996: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x03 val:0xc916
>>>     kworker/64:2-1028  [064] ....   172.386646: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x01 val:0x79ad
>>>     kworker/64:2-1028  [064] ....   172.386681: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x0f val:0x2000
>>>     kworker/64:2-1028  [064] ....   172.411286: mdio_access: mii-0000:bd:00.2 read  phy:0x05 reg:0x00 val:0x1040
>>>     kworker/64:2-1028  [064] ....   172.433225: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x02 val:0x001c
>>>     kworker/64:2-1028  [064] ....   172.433260: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x03 val:0xc916
>>>     kworker/64:2-1028  [064] ....   172.433887: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
>>>     kworker/64:2-1028  [064] ....   172.433922: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0f val:0x2000
>>>     kworker/64:2-1028  [064] ....   172.452862: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
>>>         ifconfig-1324  [011] ....   177.325585: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>>>   kworker/u257:0-8     [012] ....   177.325642: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x04 val:0x01e1
>>>   kworker/u257:0-8     [012] ....   177.325654: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x04 val:0x05e1
>>>   kworker/u257:0-8     [012] ....   177.325708: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x79ad
>>>   kworker/u257:0-8     [012] ....   177.325744: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
>>>   kworker/u257:0-8     [012] ....   177.325779: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
>>>   kworker/u257:0-8     [012] ....   177.325788: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1240
>>>   kworker/u257:0-8     [012] ....   177.325843: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d
>>
>> What I think that happens here:
>> Writing 0x1240 to BMCR starts aneg. When reading BMSR immediately after that then the PHY seems to have cleared
>> the "aneg complete" bit already, but not yet the "link up" bit. This results in the false "link up" notification.
>> The following patch is based on the fact that in case of enabled aneg we can't have a valid link if aneg isn't
>> finished. Could you please test whether this works for you?
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 6b5cb87f3..7ddd91df9 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1774,6 +1774,12 @@ int genphy_update_link(struct phy_device *phydev)
>>  	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
>>  	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
>>  
>> +	/* Consider the case that autoneg was started and "aneg complete"
>> +	 * bit has been reset, but "link up" bit not yet.
>> +	 */
>> +	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
>> +		phydev->link = 0;
>> +
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(genphy_update_link);
>>
> 
> This patch can solve the issue! Will it be upstream?
> 
I'll check for side effects, but in general: yes.

> So it's nothing to do with the bios, and just the PHY's own behavior,
> the "link up" bit can not reset immediately，right?
> 
Yes, it's the PHY's own behavior, and to a certain extent it may depend on speed
of the MDIO bus. At least few network chips require a delay of several microseconds
after each MDIO bus access. This may be sufficient for the PHY to reset the
link-up bit in time.

> ps: It will take 1 second more to make the link up for RTL8211F when 0x798d happend.
> 
In polling mode link-up is detected up to 1s after it happened.
You could switch to interrupt mode to reduce the aneg time.

> 
> 
Heiner
