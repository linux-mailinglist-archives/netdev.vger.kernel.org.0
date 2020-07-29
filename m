Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F184231E80
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 14:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgG2MYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 08:24:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60428 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2MYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 08:24:10 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06TCNX8e074308;
        Wed, 29 Jul 2020 07:23:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596025413;
        bh=BO7ozKlRvMxchUxIZF8YK9YBjHx6pd/2cLcNf8dQg1Q=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=fjWLYLgVh/n6t7svV2jwlWZPIKgfYMd2fdomoKLxY+wghe8XoytW4D6w7Y0JinZ2P
         TyJku+p2lmkUMMPOJhi7yVN3J1wdJBTZ2oPD7K7WDvLT9rCM9eoH46B+pOMw6sdhNA
         XqaoM0iBW8t+Mm/5KhEeS0N3gXbcHOXqDCJhvOmo=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06TCNXRG007341
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 07:23:33 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 29
 Jul 2020 07:23:32 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 29 Jul 2020 07:23:32 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06TCNSZA088346;
        Wed, 29 Jul 2020 07:23:29 -0500
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
To:     Petr Machata <petrm@mellanox.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>
References: <20200727090601.6500-1-kurt@linutronix.de>
 <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com>
 <875za7sr7b.fsf@kurt> <87pn8fgxj3.fsf@mellanox.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <855a0345-62c9-17b0-54fb-e74b1ef9b8b9@ti.com>
Date:   Wed, 29 Jul 2020 15:23:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87pn8fgxj3.fsf@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/07/2020 00:06, Petr Machata wrote:
> 
> Kurt Kanzenbach <kurt@linutronix.de> writes:
> 
>> On Mon Jul 27 2020, Petr Machata wrote:
>>> So this looks good, and works, but I'm wondering about one thing.
>>
>> Thanks for testing.
>>
>>>
>>> Your code (and evidently most drivers as well) use a different check
>>> than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
>>> skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e.g.
>>> this:
>>>
>>>      00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00  ..^...........E.
>>>      000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00  .H..@....Y......
>>>      00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00  ...?.?.4.....,..
>>>                              ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
>>>      00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02  ................
>>>      000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00  ................
>>>      000000000b98156e: 00 00 00 00 00 00                                ......
>>>
>>> Both UDP and PTP length fields indicate that the payload ends exactly at
>>> the end of the dump. So apparently skb->len contains all the payload
>>> bytes, including the Ethernet header.
>>>
>>> Is that the case for other drivers as well? Maybe mlxsw is just missing
>>> some SKB magic in the driver.
>>
>> So I run some tests (on other hardware/drivers) and it seems like that
>> the skb->len usually doesn't include the ETH_HLEN. Therefore, it is
>> added to the check.
>>
>> Looking at the driver code:
>>
>> |static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
>> |					void *trap_ctx)
>> |{
>> |	[...]
>> |	/* The sample handler expects skb->data to point to the start of the
>> |	 * Ethernet header.
>> |	 */
>> |	skb_push(skb, ETH_HLEN);
>> |	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
>> |}
>>
>> Maybe that's the issue here?
> 
> Correct, mlxsw pushes the header very soon. Given that both
> ptp_classify_raw() and eth_type_trans() that are invoked later assume
> the header, it is reasonable. I have shuffled the pushes around and have
> a patch that both works and I think is correct.
> 
> However, I find it odd that ptp_classify_raw() assumes that ->data
> points at Ethernet, while ptp_parse_header() makes the contrary
> assumption that ->len does not cover Ethernet. Those functions are
> likely to be used just a couple calls away from each other, if not
> outright next to each other.
> 
> I suspect that ti/cpts.c and ti/am65-cpts.c (patches 5 and 6) actually
> hit an issue in this. ptp_classify_raw() is called without a surrounding
> _push / _pull (unlike DSA), which would imply skb->data points at
> Ethernet header, and indeed, the way the "data" variable is used
> confirms it.

Both drivers, in all cases, will get
  ->data points at Ethernet header and
  ->len covers ETH_HLEN

So, yes below check is incorrect, in general, and will be false always if other
calculation are correct
(only IPV4_HLEN(data + offset) can cause issues).

if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
		return 0;

it might be good to update ptp_parse_header() documentation with expected state of skb.

  (At the same time the code adds ETH_HLEN to skb->len, but
> maybe it is just a cut'n'paste.) But then ptp_parse_header() is called,
> and that makes the assumption that skb->len does not cover the Ethernet
> header.
> 
>> I was also wondering about something else in that driver driver: The
>> parsing code allows for ptp v1, but the message type was always fetched
>> from offset 0 in the header. Is that indented?
> 
> Yeah, I noticed that as well. That was a bug in the mlxsw code. Good
> riddance :)
> 

-- 
Best regards,
grygorii
