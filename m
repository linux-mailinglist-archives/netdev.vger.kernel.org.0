Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241D75D2D4
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGBP17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:27:59 -0400
Received: from ivanoab6.miniserver.com ([5.153.251.140]:60224 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfGBP17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:27:59 -0400
X-Greylist: delayed 2440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2019 11:27:59 EDT
Received: from [192.168.17.6] (helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <anton.ivanov@kot-begemot.co.uk>)
        id 1hiK3v-0006sv-PN; Tue, 02 Jul 2019 14:47:15 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.89)
        (envelope-from <anton.ivanov@kot-begemot.co.uk>)
        id 1hiK3t-000517-8t; Tue, 02 Jul 2019 15:47:15 +0100
Subject: Re: [PATCH] User mode linux bump maximum MTU tuntap interface
 [RESAND]
To:     Richard Weinberger <richard.weinberger@gmail.com>,
        =?UTF-8?B?0JDQu9C10LrRgdC10Lk=?= <ne-vlezay80@yandex.ru>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org
References: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru>
 <fc526c78-2d3f-90ca-8317-a89eb653cbf9@yandex.ru>
 <CAFLxGvytDC1TFdT0m9vvijz_93B8TziWURcR-3mskWB-7TzFag@mail.gmail.com>
From:   Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Message-ID: <86215743-4340-7d54-6657-19546de2377a@kot-begemot.co.uk>
Date:   Tue, 2 Jul 2019 15:47:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAFLxGvytDC1TFdT0m9vvijz_93B8TziWURcR-3mskWB-7TzFag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/07/2019 15:40, Richard Weinberger wrote:
> CC'ing um folks.
> 
> On Tue, Jul 2, 2019 at 3:01 PM Алексей <ne-vlezay80@yandex.ru> wrote:
>>
>> Hello, the parameter  ETH_MAX_PACKET limited to 1500 bytes is the not
>> support jumbo frames.
>>
>> This patch change ETH_MAX_PACKET the 65535 bytes to jumbo frame support
>> with user mode linux tuntap driver.
>>
>>
>> PATCH:
>>
>> -------------------
>>
>>
>> diff -ruNP ../linux_orig/linux-5.1/arch/um/include/shared/net_user.h
>> ./arch/um/include/shared/net_user.h
>> --- a/arch/um/include/shared/net_user.h    2019-05-06 00:42:58.000000000
>> +0000
>> +++ b/arch/um/include/shared/net_user.h    2019-07-02 07:14:13.593333356
>> +0000
>> @@ -9,7 +9,7 @@
>>   #define ETH_ADDR_LEN (6)
>>   #define ETH_HEADER_ETHERTAP (16)
>>   #define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for
>> crazy people */
>> -#define ETH_MAX_PACKET (1500)
>> +#define ETH_MAX_PACKET (65535)
>>
>>   #define UML_NET_VERSION (4)
>>
>> -------------------
>>
>>
> 
> 

The vector version for tap already allows mtu > 1500. It does not have a 
check to limit it to 65535 max though and it should.

I will add this one to the queue of stuff for the network drivers. IMHO 
we should start migrating some of the older ones to vector IO.

-- 
Anton R. Ivanov
https://www.kot-begemot.co.uk/
