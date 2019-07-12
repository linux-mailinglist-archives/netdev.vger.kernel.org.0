Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430FA66A87
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 11:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfGLJ57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 05:57:59 -0400
Received: from ivanoab6.miniserver.com ([5.153.251.140]:38034 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfGLJ57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 05:57:59 -0400
Received: from [192.168.17.6] (helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1hlrlL-0007qc-UO; Fri, 12 Jul 2019 09:22:44 +0000
Received: from [192.168.4.1]
        by jain.kot-begemot.co.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1hlrlJ-0002Q0-N2; Fri, 12 Jul 2019 10:22:43 +0100
Subject: Re: [PATCH] User mode linux bump maximum MTU tuntap interface
 [RESAND]
To:     Richard Weinberger <richard.weinberger@gmail.com>,
        =?UTF-8?B?0JDQu9C10LrRgdC10Lk=?= <ne-vlezay80@yandex.ru>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org
References: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru>
 <fc526c78-2d3f-90ca-8317-a89eb653cbf9@yandex.ru>
 <CAFLxGvytDC1TFdT0m9vvijz_93B8TziWURcR-3mskWB-7TzFag@mail.gmail.com>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Organization: Cambridge Greys
Message-ID: <1fb36224-81c0-0c4c-72c4-5a60dfe207ef@cambridgegreys.com>
Date:   Fri, 12 Jul 2019 10:22:41 +0100
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

This does not quite work because in some of the drivers you get extra 
added on top of this constant.

I am going to see what can be done to fix the old net* drivers, imho we 
should start phasing them out in favor of the vector ones.

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
