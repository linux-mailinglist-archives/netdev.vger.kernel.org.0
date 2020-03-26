Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99441194D70
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgCZXmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:42:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53012 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCZXmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:42:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id z18so9658946wmk.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 16:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yTyJWpxYEOT9aVQa5U5K5y3BhMmYiKbM4ZtQ73RYBpA=;
        b=QuOFYREdfsd66y3ctsTTZjJ5zfBy6k6eBr+s0cEhJdaeAB18YvhumzuORLZxxgvt4A
         vloFtf5LGUEYMrRXmQZpcvwNGpRBkHwOWyTcwMDi+Af704L16sE+auKNQSTxvLbRWTB/
         12MTSm3NqrrztX31w+JQIStUl0u1m5DkUa2KBgw9ej4hh/0Nz24uySpRRI3eG79kCrEo
         kKNJmj4dfJRYjO5mOSsg1lvGtTL3nxWqZa95KOboETMBPRwyNAelOMWWJhtwB//ZgNP9
         0v6woM1/3nzu71koQ+s9DoFN4Zyy0c5DxAE4BJZDzV/IhwRCcfJ+K0wOkeDdUiVzkKin
         sVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yTyJWpxYEOT9aVQa5U5K5y3BhMmYiKbM4ZtQ73RYBpA=;
        b=jofbpNgdtqkoj0X5LNU+SGFZ3zqMFDnsTR2W4UdISJ9IOscKBUbMZZDXCJRvoyEeaP
         VkbnnUq8gLXcafs7D3ucpjmHQhf0FIll0De/Lj75d3soqaUtx8p6IP0OBH2JF9/YTBmD
         sDMyLIu4No3DKaI/9gMTmPOmfHcAP1jqpbMAfxMRgmtBuJw4lK541FdM9gVYYy3aVsP2
         YqmdZ0HRKOrkfPPXYDgZNTyIkZEiFdQ+VejCBBM272HCXOzRhN+ziXPDnHu8Nqkbc6gb
         h8qViCMQt9VKrrljUMJVxztm3K7kJOIJM0b/1eoNq5NqkrQHeQBKfFuog/vgaxEr/Twi
         wmyQ==
X-Gm-Message-State: ANhLgQ3tLQQjLEa2WVC0iGODpSYFrzZEYZbNh3+A6JCfhvjxK7HUMAMq
        OpCfk1vPf7PLu3pMhwTX+//aFsI9
X-Google-Smtp-Source: ADFU+vuNnwPFWYBuI2aHhZfYxXi1VS+G80aWZeE+jq1xGLOSuAuCrm6ey90Nc0fzIyimGegRNlCjHw==
X-Received: by 2002:a5d:4e03:: with SMTP id p3mr11619975wrt.408.1585266162435;
        Thu, 26 Mar 2020 16:42:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d031:3b7b:1a72:8f94? (p200300EA8F296000D0313B7B1A728F94.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d031:3b7b:1a72:8f94])
        by smtp.googlemail.com with ESMTPSA id l17sm5857848wrm.57.2020.03.26.16.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 16:42:41 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: probe PHY drivers synchronously
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <86582ac9-e600-bdb5-3d2e-d2d99ed544f4@gmail.com>
 <20200326233411.GG3819@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4a71aee8-370b-2a87-d549-a7fba5a5f873@gmail.com>
Date:   Fri, 27 Mar 2020 00:42:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326233411.GG3819@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2020 00:34, Andrew Lunn wrote:
> On Thu, Mar 26, 2020 at 07:16:23PM +0100, Heiner Kallweit wrote:
>> If we have scenarios like
>>
>> mdiobus_register()
>> 	-> loads PHY driver module(s)
>> 	-> registers PHY driver(s)
>> 	-> may schedule async probe
>> phydev = mdiobus_get_phy()
>> <phydev action involving PHY driver>
>>
>> or
>>
>> phydev = phy_device_create()
>> 	-> loads PHY driver module
>> 	-> registers PHY driver
>> 	-> may schedule async probe
>> <phydev action involving PHY driver>
>>
>> then we expect the PHY driver to be bound to the phydev when triggering
>> the action. This may not be the case in case of asynchronous probing.
>> Therefore ensure that PHY drivers are probed synchronously.
> 
> Hi Heiner
> 
Hi Andrew,

> We have been doing asynchronous driver loads since forever, and not
> noticed any problem. Do you have a real example of it going wrong?
> 
it's not about async driver loading, but about async probing once
the driver was loaded. See driver_allows_async_probing().
Default still is sync probing, except you explicitly request async
probing. But I saw some comments that the intention is to promote
async probing for more parallelism in boot process. I want to be
prepared for the case that the default is changed to async probing.
I'm not aware of any current issues, therefore I submitted it
for net-next.

> 	Andrew
> 
Heiner
