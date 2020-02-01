Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44A914FA85
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 21:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgBAU1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 15:27:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43044 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgBAU1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 15:27:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id z9so584394wrs.10
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 12:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GDCMtwBmUE7qILa35rfBJYt2gG2oe/ebxx4HyAGiLzQ=;
        b=Uav4YU6/TK0W0ZsRYDIVDv9Zdl8sGsEiA8r49RRSZTbzFJ6MyFmLgIwcv8w8f8yHql
         v7OtRU/lD8lyEvBpWPdR2Wu4fSiD6VNeiWY+ljZcnBK0nSSovF4ThU4ExDXNhxHnEUVt
         bPOXAvFLWzwSzXD2IYLDlDVnHG30oSYwmMK7UNQBpLxXBJVmATEm//QyYOP0CMHm/80Z
         uYFgNZCh13y6Q3rrONoNrfGANeuYvECMvN6WzyRQu9Y50GQGC7dB7cS6QeZneSqBlnAZ
         RDGWofxFdD399kVuyRlShkHHyFUGn51Cp8iaBixp78oLvqZkl2LJlhIM6DKbKs+7ed4L
         BLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GDCMtwBmUE7qILa35rfBJYt2gG2oe/ebxx4HyAGiLzQ=;
        b=qByffyxRJ1TrdLrb/5IhhMvisQyAvhV/CsH5G3wIS298rKRNw53lDecEn9pL4lI0qZ
         6wJyHTpGJby0FkKT1LbguWVnS+D8PFXiJIAKwypt38G8DM19IZafHrDVxmuQnuQ4TzKa
         eaDwNPa15a/RUqYDTO7DkmBrE+B+VWeLkeiEC2z7lPQrIrX0N7xUpBXi4xapFA00nYOc
         BePYLZ5yYturdVVghDxRCLnJkPQSxG7IzvcMuhrr6hQokkewTDsDaF+jNA9s6cVj9zDB
         e3iYNAOdJYPNEDjQfQFVCznDMQ81bg/LdghmzGppb0gP2Jlt4GrScrbN7SgSqaqGaFOH
         oUfg==
X-Gm-Message-State: APjAAAVsUKOEgsnVhhSb9fDeFb522KnNvmxVKEMtsS6cFZgFoyjJ2nYS
        qBl3bPL10qwWtIXyaSUgmiY=
X-Google-Smtp-Source: APXvYqzrtX5DBd5KBhYiYUmWc1aQoHl1U2MecNdVJmYTfWCLmXDlytmSc1Z8RrVZAM8DMhKmYaVqrw==
X-Received: by 2002:adf:9b87:: with SMTP id d7mr6019768wrc.64.1580588827170;
        Sat, 01 Feb 2020 12:27:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:f82c:2d27:4c50:9d00? (p200300EA8F296000F82C2D274C509D00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f82c:2d27:4c50:9d00])
        by smtp.googlemail.com with ESMTPSA id i2sm16898704wmb.28.2020.02.01.12.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 12:27:06 -0800 (PST)
Subject: Re: [PATCH net v2] phy: avoid unnecessary link-up delay in polling
 mode
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     poros@redhat.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
References: <20200129101308.74185-1-poros@redhat.com>
 <20200129121955.168731-1-poros@redhat.com>
 <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
 <7d2c26ac18d0ce7b76024fec86a9b1a084ad3fd3.camel@redhat.com>
 <414b2dc1-2421-e4c8-ea81-1177545fb327@gmail.com>
 <20200201112554.6d2b3a53@ceranb>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <74acc406-00b2-0e1e-1390-d30d380815aa@gmail.com>
Date:   Sat, 1 Feb 2020 21:26:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200201112554.6d2b3a53@ceranb>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.02.2020 11:25, Ivan Vecera wrote:
> On Fri, 31 Jan 2020 21:50:48 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>>> 0x7949
>>> [   24.154174] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0
>>>
>>> . supressed 3 same messages in T0+1,2,3s
>>>
>>> [   28.609822] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
>>> [   28.629906] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
>>> 0x7969
>>> ^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
>>> [   28.644590] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
>>> 0x796d
>>> ^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
>>> [   28.658681] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1
>>>   
>>
>> I see, thanks. Strange behavior of the PHY. Did you test also with other PHY's
>> whether they behave the same?
> 
> Yeah, it's strange... we could try different PHYs but anyway the double read was
> removed for polling mode to detect momentary link drops but it make sense only
> when phy->link is not 0. Thoughts?
> 
> Ivan
> 
I checked with the internal PHY of a Realtek NIC and it showed the same behavior.
So it seems that Realtek PHY's behave like this in general. Therefore I'm fine
with the patch. Just two things:
- Add details about this quirky behavior to the commit description.
- Resubmit annotated as net-next once net-next is open again. It's an improvement,
  not a fix.

Heiner
