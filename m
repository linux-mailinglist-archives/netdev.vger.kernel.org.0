Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4AF107DF7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 11:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWJ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 04:59:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44834 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfKWJ7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 04:59:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so11497589wrn.11;
        Sat, 23 Nov 2019 01:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qK6FWHllUdp4M0m+iOoE23MtoAt3+9O1CYl7lqmkI44=;
        b=Rogs0G2XFdnxYriaaxBwZjwJP5hNcuZr8UuOIo+aeiKGfj7f3DBUSIgxZ1lcShbAvL
         jrMr4hWWUwa0nskY2qVUz0xwy5Ti1cXMMWjoh+lssxw3BM2m9P2cHB65dN7sV3Kr7iWr
         JHigOq05pJhbJ4j0J+91+ct/ZL2ysCvOamuQTUa61V8QwC+GWJarFf0LaD+MjK7J52gm
         ZubVOyzB+CLaGrmu8M7hfx+/NrBikKsrtMWBFIQJjP5B1k9Tzazpl68mkEqbp1uufNcG
         E9ShMk9KxMGNBk+IDBUOYvPROkDigMUeVZmBgOyJD9DD1i5NZdkTU7qO+vhVZgwhb2hl
         EIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qK6FWHllUdp4M0m+iOoE23MtoAt3+9O1CYl7lqmkI44=;
        b=OvRRwWSVFFVXhSFfp3fwOLdHaMi2F4Ol/AkxQN8luZfiY+Pjx9bctI844gS2kbOfAO
         GxsQdDoyKZ7nPHpzqn64c/FCRgpbcOazB6es2f14P8twPvC9b0C+sl+VZ9hHz2+U+Vtl
         Jw2WI2igMEnNgHN6Vnsx9rsPTY56oJyb0j2IMEEsI7KLACjIi8vFWJx5+7pDkR1hkZOT
         QADFEBDAsFBcb2GNiEbqyF4/Ojz2MG4XafQxfEubYdPWS9job2RybnnAsFSxJlEnP6fR
         DZIxLQIiaTzi+Mjx02XCftJEHT2YAdV9xUVLu6Hdn/LOkHbCHXgfuCEiTdG2A4omZqmq
         3u0g==
X-Gm-Message-State: APjAAAVt7ZWxWX075FnFY1bva6/PHyy6eN75Y3AYVB4ST0YmFQlDyR4O
        7z+tc8qTDgDSuEAlpf4OxgQwUGUB
X-Google-Smtp-Source: APXvYqwS+RsNvXn1x8d/YRaZzOLMrtEo9RAX18l4MEZDQ5moe51eX+KKrLN7SLXXW0lpfIdyQDwK/A==
X-Received: by 2002:adf:f18c:: with SMTP id h12mr22102851wro.122.1574503179676;
        Sat, 23 Nov 2019 01:59:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:a1d7:b364:e414:9860? (p200300EA8F2D7D00A1D7B364E4149860.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:a1d7:b364:e414:9860])
        by smtp.googlemail.com with ESMTPSA id c11sm1524858wrv.92.2019.11.23.01.59.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 01:59:38 -0800 (PST)
Subject: Re: [PATCH] [RFC] r8169: check for valid MAC before clobbering
To:     Brian Norris <briannorris@chromium.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Chun-Hao Lin <hau@realtek.com>
References: <20191113005816.37084-1-briannorris@chromium.org>
 <32422b2d-6cab-3ea2-aca3-3e74d68599a3@gmail.com>
 <20191123005054.GA116745@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <115a9e13-c7ae-a919-b61b-0ea05ed162d7@gmail.com>
Date:   Sat, 23 Nov 2019 10:59:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191123005054.GA116745@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.11.2019 01:51, Brian Norris wrote:
> Hi Heiner,
> 
> Thanks for the response, and sorry for some delay. I've been busy in the
> last week.
> 
> On Wed, Nov 13, 2019 at 09:30:42PM +0100, Heiner Kallweit wrote:
>> On 13.11.2019 01:58, Brian Norris wrote:
>>> I have some old systems with RTL8168g Ethernet, where the BIOS (based on
>>> Coreboot) programs the MAC address into the MAC0 registers (at offset
>>> 0x0 and 0x4). The relevant Coreboot source is publicly available here:
>>>
>>> https://review.coreboot.org/cgit/coreboot.git/tree/src/mainboard/google/jecht/lan.c?h=4.10#n139
>>>
>>> (The BIOS is built off a much older branch, but the code is effectively
>>> the same.)
>>>
>>> Note that this was apparently the recommended solution in an application
>>> note at the time (I have a copy, but it's not marked for redistribution
>>> :( ), with no mention of the method used in rtl_read_mac_address().
>>>
>> The application note refers to RTL8105e which is quite different from
>> RTL8168g.
> 
> Understood. But the register mapping for this part does appear to be the
> same, and I'm really having trouble finding any other documentation, so
> I can't really blame whoever was writing the Coreboot code in the first
> place.
> 
>> For RTL8168g the BIOS has to write the MAC to the respective
>> GigaMAC registers, see rtl_read_mac_address for these registers.
> 
> I already see the code, but do you have any reference docs? For example,
> how am I to determine "has to"? I've totally failed at finding any good
> documentation.
> 
Realtek doesn't provide any public datasheets, only very few leaked
old datasheets are available. Only public source of information is
the vendor drivers: r8168/r8101/r8125.
Check the vendor drivers for where they read the MAC from.

> To the contrary, I did find an alleged RTL8169 document (no clue if it's
> legit), and it appears to describe the IDR0-5 registers (i.e., offset
> 0000h) as:
> 
>   ID Register 0: The ID registers 0-5 are only permitted to write by
>   4-byte access. Read access can be byte, word, or double word access.
>   The initial value is autoloaded from EEPROM EthernetID field. 
> 
> If that implies anything, it seems to imply that any EEPROM settings
> should be automatically applied, and that register 0-5h are the correct
> source of truth.
> 
RTL8169 is a very old chip version, and although an EEPROM interface
is specified, basically no design uses it.

> Or it doesn't really imply anything, except that some other similar IP
> doesn't specifically mention this "backup register."
> 
>> If recompiling the BIOS isn't an option,
> 
> It's not 100% impossible, but it seems highly unlikely to happen. To me
> (and likely the folks responsible for this BIOS), this looks like a
> kernel regression (this driver worked just fine for me before commit
> 89cceb2729c7).
> 
>> then easiest should be to
>> change the MAC after boot with "ifconfig" or "ip" command.
> 
> No, I think the easiest option is to apply my patch, which I'll probably
> do if I can't find anything else.
> 
> I'm curious: do you see any problem with my patch? In your
> understanding, what's the purpose of the "backup registers" (as they
> were called in commit 89cceb2729c7)? To be the primary source of MAC
> address information? Or to only be a source if the primary registers are
> empty? If the latter, then my patch should be a fine substitute.
> 
There are two types of MAC registers, first one for the currently active
MAC, and the second one for the permanent MAC.
Old chip versions don't support permanent MAC, newer ones use different
registers for it. For RTL8168g it's the mentioned GigaMAC register.
And BIOS code should set the permanent MAC.

> Brian
> 
>>> The result is that ever since commit 89cceb2729c7 ("r8169:add support
>>> more chips to get mac address from backup mac address register"), my MAC
>>> address changes to use an address I never intended.
>>>
>>> Unfortunately, these commits don't really provide any documentation, and
>>> I'm not sure when the recommendation actually changed. So I'm sending
>>> this as RFC, in case I can get any tips from Realtek on how to avoid
>>> breaking compatibility like this.
>>>
>>> I'll freely admit that the devices in question are currently pinned to
>>> an ancient kernel. We're only recently testing newer kernels on these
>>> devices, which brings me here.
>>>
>>> I'll also admit that I don't have much means to test this widely, and
>>> I'm not sure what implicit behaviors other systems were depending on
>>> along the way.
>>>
>>> Fixes: 89cceb2729c7 ("r8169:add support more chips to get mac address from backup mac address register")
>>> Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
>>> Cc: Chun-Hao Lin <hau@realtek.com>
>>> Signed-off-by: Brian Norris <briannorris@chromium.org>
> 

