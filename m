Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9846CD9BC7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437157AbfJPU1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:27:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53696 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437132AbfJPU1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:27:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so184988wmd.3
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 13:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RRN89Fix5e7YrEplTlLJmKFX2WKU9BEAczcfyLdQP34=;
        b=A8ew3kHIjWf/OCJki6qW5dYo6ceod6gEmVmsj2YLDkK4WQQNC+FOuVmb9qw8cOPzzB
         ftt7KRNCytsA2Z8MQpdI2J7FLqEIs6VV5Fu764zhSPqVDCsOTTIZmyWEeUdYuIQSBqhg
         6L7z1hucEWNgM2/RT5c7LW+47d1XVJaiM4sD3uKXaqLHevob97xKG8/nwXYMFjZxhu18
         xSVYW5kcYZRER55Q5h/hKxOZKPBsbu+NjKmeA7spxm+BYhXFuNQz2tbTi8HfAO/dDJ2I
         OIe3DbPD+KALYqeamEjvYXv84MjMhhkT3lUgpcdd1S4pSFwv2GbEa441h3U/fCXiYxo5
         SvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RRN89Fix5e7YrEplTlLJmKFX2WKU9BEAczcfyLdQP34=;
        b=Ibr5acXGkWk4OS5xnTtrYNi8Aoqx28GVVZG+UQhumd4FBsEefWOLK8p85LGTGmtrZP
         T9FAyGC/MPycdUjk1HIEDYns94/r7jNLe2gjiVy70zbqNJzYUyG6bX8ZrRdX/d/tuw0a
         O/4bIEyXoTHl5iMTd8/9MEy1s6KOuPfI3fwz6T2rnoQwSpkEZgocGsxt33xJjctoiu12
         46wjTGlxuQ0ck2cFHTrkXscS6NplCRovcl7qrejKxBnJ5w+sIVaeSBoqjp9qyOGlqhbm
         ewdgIQa591TisiW0OnBHACFglYyYqUW+0vwGHPFf4NRNM7diBCYKK6yS+uMI71wYQcIu
         7fvg==
X-Gm-Message-State: APjAAAVHs8tCgH4+/8ADE6zP0xKFu5MEN67zhYcGHkyTjUIButmFr4er
        VH7eDoRmR7E4lebCURmSPikl/4B7
X-Google-Smtp-Source: APXvYqzVejX2SN/g8IJUSnpUg+w+PnEo5GN+4wMwih7mJ2QPPIPuBKDKjOkdNKXP8TbSXyg9bM7v7g==
X-Received: by 2002:a7b:c3d2:: with SMTP id t18mr5262087wmj.52.1571257622470;
        Wed, 16 Oct 2019 13:27:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:d1a1:ef77:d584:db28? (p200300EA8F266400D1A1EF77D584DB28.dip0.t-ipconnect.de. [2003:ea:8f26:6400:d1a1:ef77:d584:db28])
        by smtp.googlemail.com with ESMTPSA id g1sm23276322wrv.68.2019.10.16.13.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 13:27:01 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: avoid NPE if read_page/write_page
 callbacks are not available
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <41aba46c-6d75-9a15-9360-1336110dd28e@gmail.com>
 <fd0cf2fb-22f4-44b6-8559-25bfe61609bd@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <756c3ea2-dd22-7963-bf02-264d6cebc22b@gmail.com>
Date:   Wed, 16 Oct 2019 22:26:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fd0cf2fb-22f4-44b6-8559-25bfe61609bd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.10.2019 22:20, Florian Fainelli wrote:
> On 10/16/19 12:53 PM, Heiner Kallweit wrote:
>> Currently there's a bug in the module subsystem [0] preventing load of
>> the PHY driver module on certain systems (as one symptom).
>> This results in a NPE on such systems for the following reason:
>> Instead of the correct PHY driver the genphy driver is loaded that
>> doesn't implement the read_page/write_page callbacks. Every call to
>> phy_read_paged() et al will result in a NPE therefore.
>>
>> In parallel to fixing the root cause we should make sure that this one
>> and maybe similar issues in other subsystems don't result in a NPE
>> in phylib. So let's check for the callbacks before using them and warn
>> once if they are not available.
> 
> Everywhere else in the PHY library we tend to do:
> 
> if (!phydev->drv)
> 	return -EIO;
> 
A driver is bound, but genphy instead of the dedicated one.
I think this check won't catch the error.

> maybe not the best choice for an error code, but we should be consistent.
> 
> Is the issue really that we do have a driver we are bound to, but
> somehow we cannot resolve the read_page/write_page callbacks to a valid
> function pointer?
> 
The issue is that loading the dedicated PHY driver module fails, therefore
the (built-in) genphy driver is bound. Code in the r8169 driver expects
that the dedicated driver for the internal PHY is bound and uses
phy_read_page() et al what fails miserably with the genphy driver.

>>
>> [0] https://marc.info/?t=157072642100001&r=1&w=2
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy-core.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 9412669b5..0ae1722ba 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -689,11 +689,17 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>>  
>>  static int __phy_read_page(struct phy_device *phydev)
>>  {
>> +	if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
>> +		return -EOPNOTSUPP;
>> +
>>  	return phydev->drv->read_page(phydev);
>>  }
>>  
>>  static int __phy_write_page(struct phy_device *phydev, int page)
>>  {
>> +	if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
>> +		return -EOPNOTSUPP;
>> +
>>  	return phydev->drv->write_page(phydev, page);
>>  }
>>  
>>
> 
> 

