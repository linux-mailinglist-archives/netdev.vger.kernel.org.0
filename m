Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B193C3E1E
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhGKQ4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKQ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 12:56:34 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710EBC0613DD;
        Sun, 11 Jul 2021 09:53:47 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GNCf16kVVzQjxW;
        Sun, 11 Jul 2021 18:53:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id QyD4CyZlz4gw; Sun, 11 Jul 2021 18:53:39 +0200 (CEST)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
 <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
 <20210710000756.4j3tte63t5u6bbt4@pali>
 <1d45c961-d675-ea80-abe4-8d4bcf3cf8d4@gmail.com>
 <20210710003826.clnk5sh3cvlamwjr@pali>
 <2d7eef37-aab3-8986-800f-74ffc27b62c5@gmail.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <fc1f39b0-2d61-387f-303f-9715781a2c4a@mailbox.org>
Date:   Sun, 11 Jul 2021 18:53:32 +0200
MIME-Version: 1.0
In-Reply-To: <2d7eef37-aab3-8986-800f-74ffc27b62c5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6E94D1842
X-Rspamd-UID: 54db4e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/21 3:07 AM, Maximilian Luz wrote:
> On 7/10/21 2:38 AM, Pali Rohár wrote:
>> On Saturday 10 July 2021 02:18:12 Maximilian Luz wrote:
>>> On 7/10/21 2:07 AM, Pali Rohár wrote:
>>>
>>> [...]
>>>
>>>>> Interesting, I was not aware of this. IIRC we've been experimenting 
>>>>> with
>>>>> the mwlwifi driver (which that lrdmwl driver seems to be based 
>>>>> on?), but
>>>>> couldn't get that to work with the firmware we have.
>>>>
>>>> mwlwifi is that soft-mac driver and uses completely different firmware.
>>>> For sure it would not work with current full-mac firmware.
>>>>
>>>>> IIRC it also didn't
>>>>> work with the Windows firmware (which seems to be significantly
>>>>> different from the one we have for Linux and seems to use or be 
>>>>> modeled
>>>>> after some special Windows WiFi driver interface).
>>>>
>>>> So... Microsoft has different firmware for this chip? And it is working
>>>> with mwifiex driver?
>>>
>>> I'm not sure how special that firmware really is (i.e. if it is Surface
>>> specific or just what Marvell uses on Windows), only that it doesn't
>>> look like the firmware included in the linux-firmware repo. The Windows
>>> firmware doesn't work with either mwlwifi or mwifiex drivers (IIRC) and
>>> on Linux we use the official firmware from the linux-firmware repo.
>>
>> Version available in the linux-firmware repo is also what big companies
>> (like google) receive for their systems... sometimes just only older
>> version as Marvell/NXP is slow in updating files in linux-firmware.
>> Seems that it is also same what receive customers under NDA as more
>> companies dropped "proprietary" ex-Marvell/NXP driver on internet and it
>> contained this firmware with some sources of driver which looks like a
>> fork of mwifiex (or maybe mwifiex is "cleaned fork" of that driver :D)
>>
>> There is old firmware documentation which describe RPC communication
>> between OS and firmware:
>> http://wiki.laptop.org/images/f/f3/Firmware-Spec-v5.1-MV-S103752-00.pdf
>>
>> It is really old for very old wifi chips and when I checked it, it still
>> matches what mwifiex is doing with new chips. Just there are new and
>> more commands. And documentation is OS-neutral.
>>
>> So if Microsoft has some "incompatible" firmware with this, it could
>> mean that they got something special which nobody else have? Maybe it
>> can explain that "connected standby" and maybe also better stability?
>>
>> Or just windows distribute firmware in different format and needs to
>> "unpack" or "preprocess" prior downloading it to device?
> 
> If memory serves me right, Jonas did some reverse engineering on the
> Windows driver and found that it uses the "new" WDI Miniport API: It
> seems that originally both Windows and Linux drivers (and firmware)
> were pretty much the same (he mentioned there were similarities in
> terminology), but then they switched to that new API on Windows and
> changed the firmware with it, so that the driver now essentially only
> forwards the commands from that API to the firmware and the firmware
> handles the rest.
> 
> By reading the Windows docs on that API, that change might have been
> forced on them as some Windows 10 features apparently only work via
> that API.
> 
> He'll probably know more about that than I do.

Not much I can add there, it seemed a lot like both mwifiex and the 
Windows 10 WDI miniport driver were both derived from the same codebase 
originally, but in order to be compatible with the WDI miniport API and 
other stuff Windows requires from wifi devices (I recall there was some 
SAR-value control/reporting stuff too), some parts of the firmware had 
to be rewritten.

In the end, the Windows firmware is updated a lot more often and likely 
includes a bunch of bugfixes the linux firmware doesn't have, but it 
can't be used on linux without a ton of work that would probably include 
rebuilding proprietary APIs from Windows.

Also, from my testing with custom APs and sniffing packets with 
Wireshark, the functionality, limitations and weird 
"semi-spec-compliant" behaviors were exactly the same with the Windows 
firmware: It doesn't support WPA3, it can't connect to fast transition 
APs (funnily enough that's opposed to what MS claims) and it also can't 
spawn an AP with WPA-PSK-SHA256 AKM ciphers. So not sure there's a lot 
of sense in spending more time trying to go down that path.
