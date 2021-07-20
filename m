Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AEA3CFD9A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbhGTOvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240085AbhGTOXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 10:23:19 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E505C0610D2;
        Tue, 20 Jul 2021 08:00:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id f190so10884509wmf.4;
        Tue, 20 Jul 2021 08:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KvKWv3m+3/O+KfgXxGnf6Z7M6amfCLjyOgh1hPeDLe4=;
        b=pzN7dtUWMsapJMCTh0j8ayvYfwR0gdPosmF1b6XWS0ub3tKqj0gNCQ+u+0FA2ztdCA
         LUxSJijgQDFXnPeaTERcfqvGty6SrdgJYGvyiNSijPW44KteRGooTT60K7K7E+dr+fcd
         QDWYDo4rSbnqFu75QjVUAGo+w8kdAoM4d3MirlQbsXLlrXSj38npjfMQMUkdzvobgpLU
         n9qbPTxhQ6h/mIAIW8LfwbKsnESt/bxEGM8NOzFOFniDLNDWOF4zl0A49tzRG01y0Mnz
         a7miP9K8/1SduEHCQYTQ0aGf8WCuoo5E3mQFbZ/Y3lhpDi3vzfgxRVk/sLNs62a8g3e9
         0BIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KvKWv3m+3/O+KfgXxGnf6Z7M6amfCLjyOgh1hPeDLe4=;
        b=f+KD5KIB4lH2HpK1xAMtVZ701mNWvrBWoSkQpQDs7dPi+2VqA49Oopt7hgFqLW3f14
         +y/Y2sfmluy+ajPjYhzbTtA3ywtP9MbhkbVBA+kpVfTjrgoBGhw/Teznl1MB2R3qFCs1
         3/g35Vw3eyLaJiI84846p15Khen/3jue4WazItNCiYLILwDzVZ4X+W0Zo4VtmJviNvgX
         bcgiXb/EB4ab0XIhA+4WJUul85YV/PA6aMT3r0pH5WJDcBWACG0iOacbtBpLcnyhI2wh
         j3wRpaRP2IpmyOIC7OOP3Vf2o/bOjXq1lEHBRzPr8i3pDIeHB4i2qOFisUfooqHPjp6U
         E8eA==
X-Gm-Message-State: AOAM530TUE8cSRZGxg3pmaQI7kh1gPnF6TnIpGYYL1BEdwvLqEPYpHto
        X2qWAksqhYGpavFUjvFfTFCQKKcUK0gnMg==
X-Google-Smtp-Source: ABdhPJwF2LktpUgEaW3OD9HP4J08A6T0a1VJOnN7/0q08ld+7RT3xfD/Q5OOlOOO5lriaWMlp6ZZIg==
X-Received: by 2002:a1c:416:: with SMTP id 22mr38537277wme.59.1626793212645;
        Tue, 20 Jul 2021 08:00:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:a102:e8a2:ba65:fd0b? (p200300ea8f3f3d00a102e8a2ba65fd0b.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:a102:e8a2:ba65:fd0b])
        by smtp.googlemail.com with ESMTPSA id j9sm1751020wms.47.2021.07.20.08.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 08:00:12 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com> <YPTKB0HGEtsydf9/@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
Date:   Tue, 20 Jul 2021 17:00:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPTKB0HGEtsydf9/@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.07.2021 02:40, Andrew Lunn wrote:
>> In general I'm not sure using the LED API provides a benefit here.
>> The brightness attribute is simply misused. Maybe better add
>> a sysfs attribute like led_mode under the netdev sysfs entry?
> 
> I _think_ you can put LED sys files other places than
> /sys/class/led. It should be possible to put them into netdev sysfs
> directory. However you need to consider what affect network name
> spaces have on this and what happens when an interface changes
> namespace.
> 

I checked the LED subsystem and didn't find a way to place the LED
sysfs files in a place other than /sys/class/leds. Maybe Pavel can
comment on whether I just missed something.
To avoid the network namespace issues we could use the PCI device
name in the LED name, but this would be quite unfriendly to the
user.

For r8169 I'm facing a similar challenge like Kurt. Most family
members support three LED's:
- Per LED a mode 0 .. 15 can be set that defines which link speed(s)
  and/or activity is indicated.
- Period and duty cycle for blinking can be controlled, but this
  setting applies to all three LED's.

For testing purposes I created sysfs attributes led0, led1, led2,
period, duty and assigned the attribute group to netdev->sysfs_groups[0].
This works fine and all attributes are under /sys/class/net/<ifname>.
Only drawback is that you need to know which trigger mode is set by
values 0..15. However this can be documented in sysfs attribute
documentation under Documentation/ABI/testing.

For using the LED subsystem and triggers two things would have to be
solved:
- How to deal with network device name changes so that the user still
  can identify that a LED belongs to a certain network device.
- How to properly deal with attributes that are shared by a group of
  LED's?

>      Andrew
> .
> 
Heiner
