Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA3068A97
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbfGONd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:33:27 -0400
Received: from mout.web.de ([212.227.15.14]:34615 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730224AbfGONd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563197593;
        bh=NnJ/McBC1xY+rwzKCrlqJKC2Om2QgKLKoSPz2k86HZs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=lDJpYRQKu5cnV6RPREucuIc2C+kjFqX+K/O7AUztCw1LIETvORDnda7OuCBA53W1/
         fIZEwItysUbuafGbil2oGWZqhmOYyIfgWHMD1w3bzTh1l7+4rH9gw5qnS0qkTxSqzr
         4QnZy/VjwM9ekhTelGt/gYpopGw88xEHvO/jTisI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.58.28] ([62.227.175.184]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lvf5Q-1iW6qK3s9E-017SQx; Mon, 15
 Jul 2019 15:33:13 +0200
Subject: Re: [PATCH v2 1/2] rt2x00usb: fix rx queue hang
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190701105314.9707-1-smoch@web.de>
 <874l3nadjf.fsf@kamboji.qca.qualcomm.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <dd1caa78-182e-b0ce-c90c-9670f8455389@web.de>
Date:   Mon, 15 Jul 2019 15:33:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <874l3nadjf.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:djE4WeLVs9SwBsKtd/iffOLzKtax0CXU3ew0/RjUPxtGqz5u7ox
 ADBvZQTsFuUUtFrSk57QUyzDEY/v+2aWt5NmmVAlnALwq42qsVbjjuCD2cN+MTSAbfgfdm9
 gEad7au1pRtSGxj6SaNYNEXbbSZfq7H5jp4qLTgeUN/aJy1Q9HnPRcuNyIeyGXMpRq8Uuqh
 Sg6JOso+O3hgaKDkXgZkw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:88IpjVHAKF4=:FAfP5y9ry6qRspW+01MVoY
 uTosMf6N4OodFVYQ/q+FFT31SDaWWH6OUBlHd5sG+hevUXouT6lfeH3iHPpfpoNbC4Op8CYzL
 /8SeazaalhETrwEzm+VmhlGxkrQbyybKgOL4PHdnlfOY2mOyZ9/3dhmsalUeccxUEoHkjFlzh
 B6LI8BTuocvgX0cn5XEHwol2d+pYbD+u5ICQjMvVfBdAN8LC1ihXaAQcNWdSu1EE2cMJ/WyLq
 SM1A53iiXVZsvbPHTQ7Jv406P3xsj4NDJrScAJIvHdUSIT7fPcCv1reK4S89LdL1kNnNW7wQ0
 FO+N0O6j9nD4eFHUAaBPc5FM78v590lAU7zmPyY1rzMzX6hmzLHmUy/bUI7XuvexKwa8c8XgW
 FvEM6b22G+uk9REz69S/N4hWASCYoaeFWEApTOBs1UhDniQyc17IWKGtHNUpqj6y/zD++YOrA
 vJmgILErvu+jSU8HaTcMmsP7cevw4TYiIf1FtCqolK1+wnBk/vkhZNh3kFFfnWe5Q3iFm3RRI
 fK2HWF/Fvb/r7LCV0FWEDZ8kq1+Deb+tY4Z2PF2KP5KuFBlfi9feKwvp3V3DGRe+ib1g6B2sr
 ClJYUFIG8wsTg9z87TcwoPhXH+whPHUs1UbbC6vwF0FoXg1SIqfERBruUJXvrl1UJLOcLqdqx
 IcArd6Qe0t89t4mBKmfxbRiWY6l5eIatU/wPrWAAYT0FhTqPyUEdorF8i2dTUdonQQpnZuuKK
 8aCz/BDnfSWxcLYLVsDeJ+sCd7I8mM/TuckEbb/PjOXVAkoWLR1Nc40Q63sNloIkADl+/wZkA
 eYapr6XgtCdb4SGEg0G8UvH5qmlR1isUqlfLLr08nWu4y87Nx/F4SYpzR1Ci/tWdmlQ9LyF9/
 GdOhn/p//SCorO7Ykv5QWbymVmcZ0uW5qi/0fmdy9jcUIUZdWaMJ0YFX6+KYUrLc7Pry/rXS5
 cFiZlAPgaqLg6F5Qdch04z7jSYiZrrrWxFqRk5sUrIGJtkvNW8EuaKvABiOE4Vmbn8AfkmLQB
 llXXKDxW6ex9nQzD7qGmVXcGe19MAInvB+ez4fTmiEVuUzWpSDzecjNn4z1S7LnvA4MKHNR4n
 O+2GCnFLaFpztQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15.07.19 10:48, Kalle Valo wrote:
> Soeren Moch <smoch@web.de> writes:
>
>> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
>>  ->complete() handler") the handler rt2x00usb_interrupt_rxdone() is
>> not running with interrupts disabled anymore. So this completion handler
>> is not guaranteed to run completely before workqueue processing starts
>> for the same queue entry.
>> Be sure to set all other flags in the entry correctly before marking
>> this entry ready for workqueue processing. This way we cannot miss error
>> conditions that need to be signalled from the completion handler to the
>> worker thread.
>> Note that rt2x00usb_work_rxdone() processes all available entries, not
>> only such for which queue_work() was called.
>>
>> This patch is similar to what commit df71c9cfceea ("rt2x00: fix order
>> of entry flags modification") did for TX processing.
>>
>> This fixes a regression on a RT5370 based wifi stick in AP mode, which
>> suddenly stopped data transmission after some period of heavy load. Also
>> stopping the hanging hostapd resulted in the error message "ieee80211
>> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
>> Other operation modes are probably affected as well, this just was
>> the used testcase.
>>
>> Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
>> Cc: stable@vger.kernel.org # 4.20+
>> Signed-off-by: Soeren Moch <smoch@web.de>
> I'll queue this for v5.3.
>
OK, thanks,
Soeren
