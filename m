Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46203DFF6E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbhHDKee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbhHDKed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:34:33 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0908AC0613D5;
        Wed,  4 Aug 2021 03:34:18 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y34so3599796lfa.8;
        Wed, 04 Aug 2021 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+7ciGaRMfUF94s9lJW0K67EkufMEpRy8bFINtyJ0c7o=;
        b=stqhLIvFLFb002c+Fddaoan4sFwOWOf7V5DU94GYEsyittmg98N9IfZ8S4lnbDS/5L
         L6XN+4CEMjHIYSt6/K6195Tg+7GXQO4L+CT+AxSmZiOY5S6OzjMQWURFk4763Jhm8tnw
         f+gytotMQzVy+Q8Xe6F2nDeNKybYppunCmLWHGdDi6dMuoQeLztpgpiK+yDO6ATcxPEq
         Z4iNYyemHLXDrpzyToyEfSlB/bPgAdgZyutZXAzAocwIrMYYIcaFG94JXX/W+rfDckop
         yZT4YafuZDb7K0DqcYqncfcStuHzES0eEaXrlFCv/KcypxX09RjErNsuzQrRB8s965fC
         sbGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+7ciGaRMfUF94s9lJW0K67EkufMEpRy8bFINtyJ0c7o=;
        b=iDcHfz0QbAuMVX7zzhpYgWVoaweod6PTO+Lfh2k1SDJdeCynVAwiUnftog+crM3TlH
         i+jdjAxqptZFhjEl+NJAOe212U22SxHZVxOXgKGC59wUTBTfqt49k2gJpVgHPU0Q5IA1
         vITIs9wEsI01M4venL0HfNlAU88mgzpjr/r9TdBQXOu+spRrFlR3nbMPZRq+X+rb3mLw
         QyY/J8PH6sBOJnpeZBlqch4ZoWM0bsipk5PshV9Wozy+lSoyYLekqW0g1pSwBCRNhztq
         LDfWp/fhTwo0e9EnCyhUjRpdWQjiPVl7y5ND1UaiSQyQXn0xu5LaGWffZfgYyBwgETjW
         UQFg==
X-Gm-Message-State: AOAM531NRcSNG0Yqe9L4N2neQJWaNQHLIiy7lzSj/0giwKAg3z/g2BV6
        d1PdzDBp8lBiGkAiFjmOxXY=
X-Google-Smtp-Source: ABdhPJy8ISmN/rhEzaOxK6LBCfb4v/RaGwHtRU0ry0LgenGfaDyKzYaDAwGvK3+7Jc3CFOXhgW3Btg==
X-Received: by 2002:ac2:5195:: with SMTP id u21mr16379805lfi.148.1628073256371;
        Wed, 04 Aug 2021 03:34:16 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.87.148])
        by smtp.gmail.com with ESMTPSA id b41sm128009ljr.67.2021.08.04.03.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 03:34:16 -0700 (PDT)
Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
 <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <de0a9df3-11ac-0630-8933-922012b39264@omp.ru>
 <OS0PR01MB5922F0ACBC41881139B3C03E86F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <bdfeb1c1-98bf-25ed-a4db-6ca3c5abc099@gmail.com>
Date:   Wed, 4 Aug 2021 13:34:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <OS0PR01MB5922F0ACBC41881139B3C03E86F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.08.2021 13:08, Biju Das wrote:
> Hi Sergei,
> 
> Thanks for feedback
> 
>> Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature
>> to struct ravb_hw_info
>>
>> On 04.08.2021 8:13, Biju Das wrote:
>>> Hi Sergei,
>>>
>>> Thanks for the feedback
>>>
>>>> Subject: Re: [PATCH net-next v2 7/8] ravb: Add internal delay hw
>>>> feature to struct ravb_hw_info
>>>>
>>>> On 8/2/21 1:26 PM, Biju Das wrote:
>>>>
>>>>> R-Car Gen3 supports TX and RX clock internal delay modes, whereas
>>>>> R-Car
>>>>> Gen2 and RZ/G2L do not support it.
>>>>> Add an internal_delay hw feature bit to struct ravb_hw_info to
>>>>> enable this only for R-Car Gen3.
>>>>>
>>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>>> ---
>>>>> v2:
>>>>>    * Incorporated Andrew and Sergei's review comments for making it
>>>> smaller patch
>>>>>      and provided detailed description.
>>>>> ---
>>>>>    drivers/net/ethernet/renesas/ravb.h      | 3 +++
>>>>>    drivers/net/ethernet/renesas/ravb_main.c | 6 ++++--
>>>>>    2 files changed, 7 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>>> index 3df813b2e253..0d640dbe1eed 100644
>>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>>> @@ -998,6 +998,9 @@ struct ravb_hw_info {
>>>>>    	int num_tx_desc;
>>>>>    	int stats_len;
>>>>>    	size_t skb_sz;
>>>>> +
>>>>> +	/* hardware features */
>>>>> +	unsigned internal_delay:1;	/* RAVB has internal delays */
>>>>
>>>>      Oops, missed it initially:
>>>>      RAVB? That's not a device name, according to the manuals. It
>>>> seems to be the driver's name.
>>>
>>> OK. will change it to AVB-DMAC has internal delays.
>>
>>      Please don't -- E-MAC has them, not AVB-DMAC.
> 
> By looking at HW manual for R-Car AVB-DMAC (APSR register, offset:-0x08C) has TDM and RDM registers for Setting internal delay mode which can give TX clock delay up to 2.0ns and RX Clock delay 2.8ns.
> 
> Please correct me, if this is not the case.

    You're correct indeed -- though being counter-intuitive, APSR belongs to 
the AVB-DMAC block. Sorry about that. :-/

>  Regards,
> Biju

NBR, Sergei
