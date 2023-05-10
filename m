Return-Path: <netdev+bounces-1375-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 088F16FDA3D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF5FA28132D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52A163E;
	Wed, 10 May 2023 09:00:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8271364
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:00:08 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C664330CF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:00:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1683709182; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=d1WNsFPlQ6GHgkwA5ctN7soCVyXHIWnY/ETsMS33vvdeyQucGSCgfEL2IkDax/KCTh57czS+kxgkniJbVYBGoCTXTV+evS/d0g2THXKmZJb4UOgwEAHH2+PTrh0YMNcwKhDD4eXuB0j0i2pbtipXjV/ht7I7i7NEgd7X6gJqHWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1683709182; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=fpIFZt0++dJMC8JRp95nIMa+gja2vGfwUkbr5rO1DzY=; 
	b=SzvpYLSU1S0vHQFfBAcIl8ZZDKKX/5Mv1N5Po4ErkkfRXYh2FfnJj/MkcRPyWDRIt1OrgaqbXIAi3Bs1BMobI4d8SkRRu6TrDy/fD2Z1OkgF1qgbS2KZ1TDdq5Kvm6pMpW1tu9MUHTTIOtH9VMXLFJxBDEkAaJx/W7oXkV4qzEs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1683709182;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=fpIFZt0++dJMC8JRp95nIMa+gja2vGfwUkbr5rO1DzY=;
	b=LLY1gNXgV9i047XU8IR62QU5QgL3smi8KIJQBM9OJmXiY08+JTGs5lxJqXOPyzrc
	qgFB4pWom6u0F2m2dH7sORVTRKEyifX7wEhOiWNFgykaewXf0Q6iRh/eByrOH8qBkQB
	Nkq4TSJPMxe5sUnIJGZKHmNEG3dEqzIXQtjud00I=
Received: from [10.1.111.147] (185.242.250.116-ip.operadors.cat [185.242.250.116]) by mx.zohomail.com
	with SMTPS id 1683709180717645.9189569516909; Wed, 10 May 2023 01:59:40 -0700 (PDT)
Message-ID: <21ce3015-b379-056c-e5ca-8763c58c6553@arinc9.com>
Date: Wed, 10 May 2023 10:59:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To: Daniel Golle <daniel@makrotopia.org>, Vladimir Oltean <olteanv@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, bartel.eerdekens@constell8.be,
 netdev <netdev@vger.kernel.org>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
 <20230501100930.eemwoxmwh7oenhvb@skbuf> <ZE-VEuhiPygZYGPe@makrotopia.org>
 <839003bf-477e-9c91-3a98-08f8ca869276@arinc9.com>
In-Reply-To: <839003bf-477e-9c91-3a98-08f8ca869276@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 1.05.2023 12:43, Arınç ÜNAL wrote:
> On 1.05.2023 13:31, Daniel Golle wrote:
>> On Mon, May 01, 2023 at 01:09:30PM +0300, Vladimir Oltean wrote:
>>> On Sat, Apr 29, 2023 at 10:52:12PM +0300, Arınç ÜNAL wrote:
>>>> On 29.04.2023 21:56, Vladimir Oltean wrote:
>>>>> On Sat, Apr 29, 2023 at 09:39:41PM +0300, Arınç ÜNAL wrote:
>>>>>> Are you fine with the preferred port patch now that I mentioned 
>>>>>> port 6
>>>>>> would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
>>>>>> got 1G? Would you like to submit it or leave it to me to send the 
>>>>>> diff
>>>>>> above and this?
>>>>>
>>>>> No, please tell me: what real life difference would it make to a user
>>>>> who doesn't care to analyze which CPU port is used?
>>>>
>>>> They would get 2.5 Gbps download/upload bandwidth in total to the CPU,
>>>> instead of 1 Gbps. 3 computers connected to 3 switch ports would 
>>>> each get
>>>> 833 Mbps download/upload speed to/from the CPU instead of 333 Mbps.
>>>
>>> In theory, theory and practice are the same. In practice, they aren't.
>>> Are you able to obtain 833 Mbps concurrently over 3 user ports?
>>
>> Probably the 2.5 GBit/s won't saturate, but I do manage to get more
>> than 1 Gbit/s total (using the hardware flow offloading capability to
>> NAT-route WAN<->LAN and simultanously have a WiFi client access a NAS
>> device which also connects to a LAN port. I use MT7915E+MT7975D mPCIe
>> module with BPi-R2)
>>
>> Using PHY muxing to directly map the WAN port to GMAC2 is also an
>> option, but would be limiting the bandwidth for those users who just
>> want all 5 ports to be bridged. Hence I do agree with Arınç that the
>> best would be to use the TRGMII link on GMAC1 for the 4 WAN ports and
>> prefer using RGMII link on GMAC2 for the WAN port, but keep using DSA.
> 
> You seem to be rather talking about MT7530 while I think preferring port 6
> would benefit MT7531BE the most.
> 
> Can you test the actual speed with SGMII on MT7531? Route between two 
> ports and
> do a bidirectional iperf3 speed test.
> 
> SGMII should at least provide you with 2 Gbps bandwidth in total in a
> router-on-a-stick scenario which is the current situation until the 
> changing
> DSA conduit support is added.
> 
> If we were to use port 5, download and upload speed would be capped at 500
> Mbps. With SGMII you should get 1000 Mbps on each.

I tested this on Daniel's Banana Pi BPI-R3 which has got an MT7531AE 
switch. I can confirm I get more than 500 Mbps for RX and TX on a 
bidirectional speed test.

[SUM][RX-S]   0.00-18.00  sec  1.50 GBytes   715 Mbits/sec 
    receiver

[SUM][TX-S]   0.00-18.00  sec  1.55 GBytes   742 Mbits/sec  6996 
     sender

The test was run between two computers on different networks, 
192.168.1.0/24 and 192.168.2.0/24, both computers had static routes to 
reach each other. I tried iperf3 as the server and client on both 
computers with similar results.

This concludes preferring port 6 is practically beneficial for MT7531BE.

Arınç

