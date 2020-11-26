Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1C62C52DA
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 12:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388910AbgKZLVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 06:21:47 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:19773 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729932AbgKZLVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 06:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606389705;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=uNCS1aFmz5+GRjbGXLATLfWOc3SHgcCVSH1L0o5r82g=;
        b=Yb5k4FHxkAX3gmnIslJIjnS8PKtNh14Lf8BlBEOpdcnnJkimu6XN5zQqeLHkrfb/u1
        5HtK/h69To3dqIHU2wWCSe3ilzYBvmIJCj0HytcCLZ/jtoDAPjWcHLiRRS2StMXIiCwk
        BNbmXAb/U/IrwnTZ9KFgxoXW58t1w73nu7VJKwFHK02hYLR3qIGWE0n7Y6En8WzQsD0b
        5/DOM46ZzPJb2Hpv8/SQFqJD1IpOqpI5MjpY2OO06onrKHPdaeuIfTxSb90Z0Vs7F4cL
        dcL61bbHCqtvAFNiJ9jkOlfWR97Zy1hfKV8ktEd2XdNvTdUNozx+i0DxrIUILg/9b6wV
        U9Cg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVxiOMVupw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwAQBLgsaF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 26 Nov 2020 12:21:42 +0100 (CET)
Subject: Re: [PATCH] can: m_can: add support for bosch mcan version 3.3.0
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sriram.dash@samsung.com, dmurphy@ti.com, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, pankaj.dubey@samsung.com
References: <CGME20201126045221epcas5p46f00cd452b8023262f5556e6f4567352@epcas5p4.samsung.com>
 <1606366302-5520-1-git-send-email-pankj.sharma@samsung.com>
 <e7a65c29-d0b0-358f-fc5f-c08944ada4df@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <e6f36ce5-1197-d93b-705b-2f7d68761f04@hartkopp.net>
Date:   Thu, 26 Nov 2020 12:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e7a65c29-d0b0-358f-fc5f-c08944ada4df@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.11.20 11:48, Marc Kleine-Budde wrote:
> On 11/26/20 5:51 AM, Pankaj Sharma wrote:
>> Add support for mcan bit timing and control mode according to bosch mcan IP
>> version 3.3.0
>> The mcan version read from the Core Release field of CREL register would be
>> 33. Accordingly the properties are to be set for mcan v3.3.0
> 
> BTW: do you have the v3.2 and v3.1 datasheets?

Unfortunately Bosch does not give access to older documents, so I tried 
to concentrate all my downloaded versions of public available 
information here:

https://github.com/hartkopp/M_CAN-User-Manual-History

PR's with updates are welcome ;-)

Best,
Oliver

ps. @Bosch Semiconductors - Read the README there! I would like to 
remove my own collection.

> 
> Marc
> 
>> Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
>> ---
>> Depends on:
>> https://marc.info/?l=linux-can&m=160624495218700&w=2
>>
>>   drivers/net/can/m_can/m_can.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
>> index 86bbbfa..7652175 100644
>> --- a/drivers/net/can/m_can/m_can.c
>> +++ b/drivers/net/can/m_can/m_can.c
>> @@ -1385,6 +1385,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
>>   						&m_can_data_bittiming_const_31X;
>>   		break;
>>   	case 32:
>> +	case 33:
>> +		/* Support both MCAN version v3.2.x and v3.3.0 */
>>   		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
>>   			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
>>   
>>
> 
> 
