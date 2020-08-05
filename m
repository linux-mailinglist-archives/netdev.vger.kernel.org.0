Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8DC23D7D8
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 10:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHFILG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 04:11:06 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53686 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHFILG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 04:11:06 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 075Cxspb067403;
        Wed, 5 Aug 2020 07:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596632394;
        bh=4QWwt3HdGPXGSLQ2YCzTnntvsM9Q0HSMpYe033Mlev0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=FSTxf3OBqjqNyOqjSb6LlO6TVPd8qSNj0bnz2P08uGYRwP3Nm1LpcBpgxA0Y3jNFm
         puhWegR0dYVmjAB7+U7v2LMM6SOdJmOW3/1T8PNn8ahoZ5Y0qNxRBSJ+BI5qiP9+7R
         VQZyYUjy1UPKGBCt0eRCffiEFGVGukWXCaDA3SwM=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 075CxsTP114153
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 5 Aug 2020 07:59:54 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 5 Aug
 2020 07:59:53 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 5 Aug 2020 07:59:53 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 075CxnVa130998;
        Wed, 5 Aug 2020 07:59:50 -0500
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, <netdev@vger.kernel.org>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com>
 <87pn8c0zid.fsf@kurt> <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com>
 <20200804210759.GU1551@shell.armlinux.org.uk>
 <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com>
 <20200804214448.GV1551@shell.armlinux.org.uk>
 <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com>
 <20200804231429.GW1551@shell.armlinux.org.uk> <875z9x1lvn.fsf@kurt>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <4d9aeb50-e8df-369a-7e3d-87ff9ba86079@ti.com>
Date:   Wed, 5 Aug 2020 15:59:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <875z9x1lvn.fsf@kurt>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/08/2020 12:29, Kurt Kanzenbach wrote:
> On Wed Aug 05 2020, Russell King - ARM Linux admin wrote:
>> On Wed, Aug 05, 2020 at 01:04:31AM +0300, Grygorii Strashko wrote:
>>> On 05/08/2020 00:44, Russell King - ARM Linux admin wrote:
>>>> On Wed, Aug 05, 2020 at 12:34:47AM +0300, Grygorii Strashko wrote:
>>>>> On 05/08/2020 00:07, Russell King - ARM Linux admin wrote:
>>>>>> On Tue, Aug 04, 2020 at 11:56:12PM +0300, Grygorii Strashko wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 31/07/2020 13:06, Kurt Kanzenbach wrote:
>>>>>>>> On Thu Jul 30 2020, Petr Machata wrote:
>>>>>>>>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>>>>>>>>
>>>>>>>>>> @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
>>>>>>>>>>      }
>>>>>>>>>>      EXPORT_SYMBOL_GPL(ptp_classify_raw);
>>>>>>>>>> +struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
>>>>>>>>>> +{
>>>>>>>>>> +	u8 *data = skb_mac_header(skb);
>>>>>>>>>> +	u8 *ptr = data;
>>>>>>>>>
>>>>>>>>> One of the "data" and "ptr" variables is superfluous.
>>>>>>>>
>>>>>>>> Yeah. Can be shortened to u8 *ptr = skb_mac_header(skb);
>>>>>>>
>>>>>>> Actually usage of skb_mac_header(skb) breaks CPTS RX time-stamping on
>>>>>>> am571x platform PATCH 6.
>>>>>>>
>>>>>>> The CPSW RX timestamp requested after full packet put in SKB, but
>>>>>>> before calling eth_type_trans().
>>>>>>>
>>>>>>> So, skb->data pints on Eth header, but skb_mac_header() return garbage.
>>>>>>>
>>>>>>> Below diff fixes it for me.
>>>>>>
>>>>>> However, that's likely to break everyone else.
>>>>>>
>>>>>> For example, anyone calling this from the mii_timestamper rxtstamp()
>>>>>> method, the skb will have been classified with the MAC header pushed
>>>>>> and restored, so skb->data points at the network header.
>>>>>>
>>>>>> Your change means that ptp_parse_header() expects the MAC header to
>>>>>> also be pushed.
>>>>>>
>>>>>> Is it possible to adjust CPTS?
>>>>>>
>>>>>> Looking at:
>>>>>> drivers/net/ethernet/ti/cpsw.c... yes.
>>>>>> drivers/net/ethernet/ti/cpsw_new.c... yes.
>>>>>> drivers/net/ethernet/ti/netcp_core.c... unclear.
>>>>>>
>>>>>> If not, maybe cpts should remain unconverted - I don't see any reason
>>>>>> to provide a generic function for one user.
>>>>>>
>>>>>
>>>>> Could it be an option to pass "u8 *ptr" instead of "const struct sk_buff *skb" as
>>>>> input parameter to ptp_parse_header()?
>>>>
>>>> It needs to read from the buffer, and in order to do that, it needs to
>>>> validate that the buffer contains sufficient data.  So, at minimum it
>>>> needs to be a pointer and size of valid data.
>>>>
>>>> I was thinking about suggesting that as a core function, with a wrapper
>>>> for the existing interface.
>>>>
>>>
>>> Then length can be added.
>>
>> Actually, it needs more than that, because skb->data..skb->len already
>> may contain the eth header or may not.
>>
>>> Otherwise not only CPTS can't benefit from this new API, but also
>>> drivers like oki-semi/pch_gbe/pch_gbe_main.c -> pch_ptp_match()
>>
>> Again, this looks like it can be solved easily by swapping the position
>> of these two calls:
>>
>>                          pch_rx_timestamp(adapter, skb);
>>
>>                          skb->protocol = eth_type_trans(skb, netdev);

Sry, it will not be so "easily", because there is ptp_classify_raw() inside.

So every such case, will require rework and adding magic like this

	__skb_push(skb, ETH_HLEN);

	type = ptp_classify_raw(skb);

	__skb_pull(skb, ETH_HLEN);

in Hot path.

>>
>>> or have to two have two APIs (name?).
>>>
>>> ptp_parse_header1(struct sk_buff *skb, unsigned int type)
>>> {
>>> 	u8 *data = skb_mac_header(skb);
>>>
>>> ptp_parse_header2(struct sk_buff *skb, unsigned int type)
>>> {
>>> 	u8 *data = skb->data;
>>>
>>> everything else is the same.
>>
>> Actually, I really don't think we want 99% of users doing:
>>
>> 	hdr = ptp_parse_header(skb_mac_header(skb), skb->data, skb->len, type)
>>
>> or
>>
>> 	hdr = ptp_parse_header(skb_mac_header(skb), skb->data + skb->len, type);
>>
>> because that is what it will take, and this is starting to look
>> really very horrid.
> 
> True.
> 
>>
>> So, I repeat my question again: can netcp_core.c be adjusted to
>> ensure that the skb mac header field is correctly set by calling
>> eth_type_trans() prior to calling the rx hooks?  The other two
>> cpts cases look easy to change, and the oki-semi also looks the
>> same.
> 
> I think it's possible to adjust the netcp core. So, the time stamping is
> done via
> 
>   gbe_rxhook() -> gbe_rxtstamp() -> cpts_rx_timestamp()
> 
> The hooks are called in netcp_process_one_rx_packet(). So, moving
> eth_type_trans() before executing the hooks should work. Only one hook
> is registered.
> 
> What do you think about it?

I really do not want touch netcp, sry.
There are other internal code based on this even if there is only one hooks in LKML now.
+ my comment above.

I'll try use skb_reset_mac_header(skb);
As spectrum does:
  	skb_reset_mac_header(skb);
	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, true);

if doesn't help PATCH 6 is to drop.

-- 
Best regards,
grygorii
