Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACB40BF62
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbhIOFoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:44:05 -0400
Received: from mout.gmx.net ([212.227.15.19]:37079 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbhIOFn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 01:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631684543;
        bh=k/mBnaltl0V4HhcJYi79KyqmAelVS9deee9HO0j5FQs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=eDB8TmsKSpUc9Lw8xmSOTmba+zkzvzG3kIOfIIUO5fjXE0PxbOdT2G6mpX/ycNGSU
         o6IlFgIyxJugiJLZhduBsjbPdvUqFt5tf+T8J9uSgJCqA10CVkCeDtlVSiQQ/07GP1
         U4A01NucfzdAgyAzMDYMUeTVfXlo5fclN1Ev+UH4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MStCe-1mLXKz10AA-00UIsW; Wed, 15
 Sep 2021 07:42:23 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com> <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
 <20210912202913.mu3o5u2l64j7mpwe@skbuf>
 <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
 <20210913104400.oyib42rfq5x2vc56@skbuf>
 <trinity-6fefc142-df4d-47af-b2bd-84c8212e5b1c-1631530880741@3c-app-gmx-bs55>
 <20210914184856.vmqv3je4oz5elxvp@skbuf>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <69b914bb-de19-e168-fe9c-61e125410fb6@gmx.de>
Date:   Wed, 15 Sep 2021 07:42:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210914184856.vmqv3je4oz5elxvp@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vd35W0+nzHSNT7qGL8FeWPyrHLMVo5dM9FPqJBuDiKL1nbMqzQP
 bTDxcEmPTfiAOdze/PzfY8WDp6V8iBUfQiDAG75K6uK4TeTDoEJ+bPajbvSIzhbEJXHizuy
 yYeGG1GuQYSTLIphmnyZ4X1Ir76S4tHzdDUUQHMBGTbAoHQqwUQuc05pjbOU61/JjUv/5uR
 08AE3GftuvqgXmvSQa8Eg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yn1nOXrNt0o=:lfBWm5eNqVSyXYNJQPIzpR
 o3LkFwNmD62FPVWfulYx6XQ9vGslkCFxaubBX1l1G9kcXT+BvlKxyae9uk5srJWxyN52qEntK
 1r274OxYwzhC8/iNEcS0mB4zyrYUYdH5W0XH3aJ9ImP6fnZC10DmIKSlpCCz1xZ0hzW33I+Lt
 vU1h9jVpoYT1JOQc1sGOMFlsbozS+uUU46yfQd/kMvdVd1MUx+0uyvq4HgZhx35nbplm4tXGp
 oSxuvw2OzJaA36iLVxK3zO6A6CJ8z08TWjjLQ5+CpoeL1SDf9mpgCGblJA0eVZOIltdJN16vq
 zx72bp8hH0vOO0bSeY2oYgKcZylIlwdAgh0Ud8GVEugxN2k9EFjFTsEPWlACzIiMz6iEsp3Gq
 xB/8p49EdiD4Bas3+pCbo2sxqQAi4x1bqNXFEzYRjWCDcA8wjmVgIrFgHrVKURALcf9VVGP+N
 6Zj2BHQ9wmJPerz8XYFZ8C7ZlR7dOFsk/4YYKQqBxWq8rMW62B8sKeV8zwIB3jho/etlQMFJo
 L4c1oeUrWnInr09ZPsdkDOw36RalUyNkvfQuarMIcewD3a4dWW67m8YpbBR0L8QMoqHTdgDCn
 +c8ui68kt17IW8VSLDV2KKC7cNcMoc6btaGp8uwqaJ++TCCnxmOFkLMFBbJsck/SyAhj9s1mW
 FPJf5CXh0sbw9Yqz8JvPLEImSIH9BLwu4D9lAQABycdk9et2oK/WpVjVX7JlBOS9KquviLXR3
 xTRG5ir3KWH9lIqzBqakE47mMZ7i9r1nHSJnGOYD2vFxAYlH0x4TSkHZ1Md1oKc77XbKsuPVk
 N3bwCBld2Tca4apFw0m7D70BCgZ6B0vO9soUqaK1A3U6cQ2DwfB6/63xrpZvhgsqrQr9cVdUA
 quVsTUji1iJ7PTa0Is4XJ8iaBCv0YJtLU2H1iqiR+nKBXDMlAQOqEn+6rZj3KPZX7aqerK6t3
 do1qo+Az06TLLwSsm8cI0aWKtJcldEXEH+xZ7r3xahFFkfahym1Xf3QLxCg3K68YoQQLsCD0+
 cYH3nKRtakiDgVUNVm5mtVrXG/Lds//NCY2jFf+aPWNWa1DnRu47VW+qS1je/aNGOfInQ2nFS
 +GiggS/om4SNG0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 14.09.21 at 20:48, Vladimir Oltean wrote:
> On Mon, Sep 13, 2021 at 01:01:20PM +0200, Lino Sanfilippo wrote:
>>>>> Could you post the full kernel output? The picture you've posted is
>>>>> truncated and only shows a WARN_ON in rpi_firmware_transaction and i=
s
>>>>> probably a symptom and not the issue (which is above and not shown).
>>>>>
>>>>
>>>> Unfortunately I dont see anything in the kernel log. The console outp=
ut is all I get,
>>>> thats why I made the photo.
>>>
>>> To clarify, are you saying nothing above this line gets printed? Becau=
se
>>> the part of the log you've posted in the picture is pretty much
>>> unworkable:
>>>
>>> [   99.375389] [<bf0dc56c>] (bcm2835_spi_shutdown [spi_bcm2835]) from =
[<c0863ca0>] (platform_drv_shutdown+0x2c/0x30)
>>>
>>> How do you access the device's serial console? Use a program with a
>>> scrollback buffer like GNU screen or something.
>>>
>>
>> Ah no, this is not over a serial console. This is what I see via hdmi. =
I do not have a working serial connection yet.
>> Sorry I know this trace part is not very useful, I will try to get a fu=
ll dump.
>
> Lino, are you going to provide a kernel output so I could look at your n=
ew breakage?
> If you could set up a pstore logger with a ramoops region, you could
> dump the log after the fact. Or if HDMI is all you have, you could use
> an HDMI capture card to record it. Or just record the screen you're
> looking at, as long as you don't have very shaky hands, whatever...
>

Yes, I will try to get something useful. I have already set up a serial co=
nnection
now. I still see the shutdown stopping with your patch but I have not seen=
 the
kernel dump any more. I will try further and provide a dump as soon as I a=
m successful.

Regards,
Lino
