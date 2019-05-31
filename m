Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63B531697
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfEaV0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:26:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35187 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaV0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:26:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so3815851wml.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 14:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JmWr8ASX+reUPjGIMAfmVkEKv9pX9VT/43p94jKrcO8=;
        b=Yvh7gKOLcma7UFWupLVM/EU3/JFOk9lH/Y1quK1Y9h/V6jNKm+mluVMqWld+t7ox12
         efyR2u54AWg8qAQ1fRB2lTmsaxVgBo0LnE44Bj2caZmG+79f67pSa5Mci12QO7BWMOfA
         rSI1bQytEA7izF7Y2o41okEVey3MKsLyCBJFGDFJkPxLMJeXJw6Xobzgb34TIg8Xe+wS
         8zxoYMlyfH1ov0EihNjY4hbwePMPbY/PmyQX50jgHz/FFKUHUjjCkwQ3Qkt714rDTCcW
         6RMp95n8ULfKCBagoVkD+UCSD4lkhXVtuIoJ/tK4MRmRUr2vVkBW2TrAe6yMTl4EOnxh
         IhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JmWr8ASX+reUPjGIMAfmVkEKv9pX9VT/43p94jKrcO8=;
        b=UFWPr6G6MBkeGT4FH/jA0FtsSMkbViVwq4VUw2CJJVvehDmNhqGqSjX7QpdEK8TTTu
         i07Ijkb5GqkPZzJwGdvt5l2/hBqJr7dvrHgPSX8EsjL6Uj7W33+7wgg5yRIg8XI7D7hY
         aTQqHPPL7wpFIQiFZIDQ2/qGDksownlXsC5i2ru0+sbQYt17q+FA6sggLH6LwPmeXRef
         BE4r5t8TXP0qAnq10C0Doh9yNUNsGtplTH7m2uq7/tSBKI/vLiUacUq8HA6vfbGc5WJr
         6bG5r+lv6FXjftMIGtMrj1L6tKkmZySVnQPgszOSuHuRhF+79616+RkkXxKk994OJaNp
         Hbwg==
X-Gm-Message-State: APjAAAWdR/5bcKAbHAWWkiKUEXd2HyGyMy3WwXOF3YiBSbT5cGPAdAk3
        ytrAgQVCfVbc1yF7seRpOvA=
X-Google-Smtp-Source: APXvYqzpDJq5wGoVH9zgZtXoXYOC/SwBo0GXgYEg+UnNC1z3VQ/sCWe2849fls1lI5Ww1iCqjCWdoA==
X-Received: by 2002:a1c:254:: with SMTP id 81mr6992212wmc.151.1559338011821;
        Fri, 31 May 2019 14:26:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id y132sm11402619wmd.35.2019.05.31.14.26.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 14:26:51 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: Ensure scheduled work is cancelled
 during removal
To:     Andrew Lunn <andrew@lunn.ch>,
        Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
References: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
 <1559330150-30099-2-git-send-email-hancock@sedsystems.ca>
 <20190531205421.GC3154@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <49e18fde-5ac4-22ad-90ec-0cbad64d743a@gmail.com>
Date:   Fri, 31 May 2019 23:26:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531205421.GC3154@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.2019 22:54, Andrew Lunn wrote:
> Robert
> 
> Please make sure you Cc: PHY patches to the PHY maintainers.
> 
> Heiner, this one is for you.
> 
> 	Andrew
> 
> On Fri, May 31, 2019 at 01:15:50PM -0600, Robert Hancock wrote:
>> It is possible that scheduled work started by the PHY driver is still
>> outstanding when phy_device_remove is called if the PHY was initially
>> started but never connected, and therefore phy_disconnect is never
>> called. phy_stop does not guarantee that the scheduled work is stopped
>> because it is called under rtnl_lock. This can cause an oops due to
>> use-after-free if the delayed work fires after freeing the PHY device.
>>
The patch itself at least shouldn't do any harm. However the justification
isn't fully convincing yet.
PHY drivers don't start any scheduled work. This queue is used by the
phylib state machine. phy_stop usually isn't called under rtnl_lock,
and it calls phy_stop_machine that cancels pending work.
Did you experience such an oops? Can you provide a call chain where
your described scenario could happen?

>> Ensure that the state_queue work is cancelled in both phy_device_remove
>> and phy_remove paths.
>>
>> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
>> ---
>>  drivers/net/phy/phy_device.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 2c879ba..1c90b33 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -877,6 +877,8 @@ int phy_device_register(struct phy_device *phydev)
>>   */
>>  void phy_device_remove(struct phy_device *phydev)
>>  {
>> +	cancel_delayed_work_sync(&phydev->state_queue);
>> +
>>  	device_del(&phydev->mdio.dev);
>>  
>>  	/* Assert the reset signal */
>> -- 
>> 1.8.3.1
>>
> 

