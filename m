Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FD549F259
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345974AbiA1ET7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:19:59 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:54766
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236875AbiA1ET4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:19:56 -0500
Received: from [192.168.1.9] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 6587341988;
        Fri, 28 Jan 2022 04:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643343594;
        bh=qJivR/0SfF6KYekc1Fj6mI+NGXa+UlyMrVTHUfa7zAc=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=hpseaTnQ9pHxaszHmm9QXlN3a3Hv3HapEBtlQzEy+ZnjdwAopDUhD6xZd9vQ2qhc6
         wVv52sx1elMogbVW8/Q4nCoGvFS0EQB8qYvKO7na9uZ2ZkATYEvL5O3zUaupatU+Pt
         WOGeJ8vK8gOA77pNoSH8WfW3ayyhi/hRWfMhLOHQiNhAIxqDuza4p/XNTtERhdPwPH
         sU4As/zB8/mhJQGsIiHBPcAl5O/wDo22MIABFtvDuWnYcUP4gaSLwG88M9pEL4A/R9
         VwBWShO0aCZnRzcII47CiBplGz6qd+9cWJJMFWl0Kq4kNBUP8/A+aPMsyMeOLoJfZq
         Fa3O/OLNV4L0w==
Message-ID: <e75d006c-c9ae-9479-28b4-4cdacf1c51db@canonical.com>
Date:   Fri, 28 Jan 2022 12:19:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mario.Limonciello@amd.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220127100109.12979-1-aaron.ma@canonical.com>
 <YfKp81yJWd95Jrg7@lunn.ch>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <YfKp81yJWd95Jrg7@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/27/22 22:19, Andrew Lunn wrote:
> On Thu, Jan 27, 2022 at 06:01:09PM +0800, Aaron Ma wrote:
>> RTL8153-BL is used in Lenovo Thunderbolt4 dock.
>> Add the support of MAC passthrough.
>> This is ported from Realtek Outbox driver r8152.53.56-2.15.0.
>>
>> There are 2 kinds of rules for MAC passthrough of Lenovo products,
>> 1st USB vendor ID belongs to Lenovo, 2nd the chip of RTL8153-BL
>> is dedicated for Lenovo. Check the ocp data first then set ACPI object
>> names.
>>
>> Suggested-by: Hayes Wang <hayeswang@realtek.com>
>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>> ---
>>   drivers/net/usb/r8152.c | 44 ++++++++++++++++++++++-------------------
>>   1 file changed, 24 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
>> index ee41088c5251..df997b330ee4 100644
>> --- a/drivers/net/usb/r8152.c
>> +++ b/drivers/net/usb/r8152.c
>> @@ -718,6 +718,7 @@ enum spd_duplex {
>>   #define AD_MASK			0xfee0
>>   #define BND_MASK		0x0004
>>   #define BD_MASK			0x0001
>> +#define BL_MASK                 BIT(3)
> 
> Just to be sure, this is defined by Realtek? This is not just Lenovo
> just misusing a reserved bit?
> 

 From what I know, It's defined by Realtek to identify customized product.
It shouldn't be misusing.
Also it's used by Realtek outbox driver.

Aaron

>       Andrew
