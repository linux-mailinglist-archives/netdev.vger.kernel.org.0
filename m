Return-Path: <netdev+bounces-7750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 926897215F0
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B46F72810BC
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5314421;
	Sun,  4 Jun 2023 10:03:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0523CD
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 10:03:12 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C9ADB;
	Sun,  4 Jun 2023 03:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685872952; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=J8patjHW9ynL8BHuov7mXyIPxdNaQB4XOgPZQbfzqaeMFVaWFCtmA8kh1hF+025LELepaeK0POwe5a8c5+WbTPXXDo3/M86+GMA6z9p+joNGIGqv52dZ1PMQAQdJBhXfcylPgkULLD4DD2ayrokEnF9kRnE9WSaX1vpqAp/LTig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685872952; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=Za6ndI+MEe04AGEZDtIym5+jQuU3s03LuT4qImN10tE=; 
	b=iHfk098mpTG1ZWNHI67m0NYYESxapk35H5G8x8AqApV997bYoEDqdv/Ub+GizUsNrZaZDCzy45kBoH5grcqKqDjVEM5mNIFYANAUUze2ymFV2H27A06evvMV1Nup3ascLytQ1QIi8QGmYHdZy4viVV+ON9/sNQMPOVVmxN+JoYo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685872952;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Za6ndI+MEe04AGEZDtIym5+jQuU3s03LuT4qImN10tE=;
	b=FWtOOdjKi8oCtbl/ZrcE+FbvWQlToqcMkyOkdsmPn62ajmAt5GELk1lwNQ+jAkAa
	6Rxi2w8lVQXA9XC1NRLYZwG+PISeXhluC7io4HxRWLbpxeX0dwGlYtacU2svYx5CBJ3
	w81L5/uf3wb/WEOY12OsCCC3bNZ3oqTa34m7k0og=
Received: from [192.168.99.249] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1685872950208345.1966686433153; Sun, 4 Jun 2023 03:02:30 -0700 (PDT)
Message-ID: <886ae203-1aca-0cb3-cf32-416984a7c37c@arinc9.com>
Date: Sun, 4 Jun 2023 13:02:20 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 29/30] net: dsa: introduce
 preferred_default_local_cpu_port and use on MT7530
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-30-arinc.unal@arinc9.com>
 <20230522121532.86610-30-arinc.unal@arinc9.com>
 <20230526171755.nk643aphoojvhjpg@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230526171755.nk643aphoojvhjpg@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26.05.2023 20:17, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:31PM +0300, arinc9.unal@gmail.com wrote:
>> From: Vladimir Oltean <olteanv@gmail.com>
>>
>> When multiple CPU ports are being used, the numerically smallest CPU port
>> becomes the port all user ports become affine to. This may not be the best
>> choice for all switches as there may be a numerically greater CPU port with
>> more bandwidth than the numerically smallest one.
>>
>> Such switches are MT7530 and MT7531BE, which the MT7530 DSA subdriver
>> controls. Port 5 of these switches has got RGMII whilst port 6 has got
>> either TRGMII or SGMII.
>>
>> Therefore, introduce the preferred_default_local_cpu_port operation to the
>> DSA subsystem and use it on the MT7530 DSA subdriver to prefer port 6 as
>> the default CPU port.
>>
>> To prove the benefit of this operation, I (Arınç) have done a bidirectional
>> speed test between two DSA user ports on the MT7531BE switch using iperf3.
>> The user ports are 1 Gbps full duplex and on different networks so the SoC
>> MAC would have to do 2 Gbps TX and 2 Gbps RX to deliver full speed.
> 
> I think the real argument would sound like this:
> 
> Since the introduction of the OF bindings, DSA has always had a policy
> that in case multiple CPU ports are present in the device tree, the
> numerically first one is always chosen.
> 
> The MT7530 switch family has 2 CPU ports, 5 and 6, where port 6 is
> preferable because it has higher bandwidth.
> 
> The MT7530 driver developers had 3 options:
> - to modify DSA when the driver was introduced, such as to prefer the
>    better port
> - to declare both CPU ports in device trees as CPU ports, and live with
>    the sub-optimal performance resulting from not preferring the better
>    port
> - to declare just port 6 in the device tree as a CPU port
> 
> Of course they chose the path of least resistance (3rd option), kicking
> the can down the road. The hardware description in the device tree is
> supposed to be stable - developers are not supposed to adopt the
> strategy of piecemeal hardware description, where the device tree is
> updated in lockstep with the features that the kernel currently supports.
> 
> Now, as a result of the fact that they did that, any attempts to modify
> the device tree and describe both CPU ports as CPU ports would make DSA
> change its default selection from port 6 to 5, effectively resulting in
> a performance degradation visible to users as can be seen below vvvvv
> 
>>
>> Without preferring port 6:
>>
>> [ ID][Role] Interval           Transfer     Bitrate         Retr
>> [  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
>> [  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
>> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
>> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver
>>
>> With preferring port 6:
>>
>> [ ID][Role] Interval           Transfer     Bitrate         Retr
>> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
>> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
>> [  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
>> [  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver
>>
>> Using one port for WAN and the other ports for LAN is a very popular use
>> case which is what this test emulates.
> 
> As such, this change proposes that we retroactively modify stable
> kernels to keep the mt7530 driver preferring port 6 even with device
> trees where the hardware is more fully described.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> 
>>
>> This doesn't affect the remaining switches, MT7531AE and the switch on the
>> MT7988 SoC. Both CPU ports of the MT7531AE switch have got SGMII and there
>> is only one CPU port on the switch on the MT7988 SoC.
>>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> See the difference in intent?

Yeah, nicely put.

Arınç

