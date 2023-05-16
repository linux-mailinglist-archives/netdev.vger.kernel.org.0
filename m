Return-Path: <netdev+bounces-3108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DADF3705839
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C619281165
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A151DDC1;
	Tue, 16 May 2023 20:01:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48EEF500
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:01:31 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34A0B9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:01:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684267270; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=IABH9u7HpAtdPTQECiBn5k/05DvvPASabbRaDyreJJXcpfIOYaFxdX4jeF7tG70ZHTccs5pebTTYBzduexb6TiCKuEDv0OO3Es4puiadylHQEhPo/lAYNN5eUdcVDTk2ByvsHJae5taicMo/RDiZajaYnJoWDCVZzg0GpqmJHXE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684267270; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=rTdYbA9kgaq7J+X3vLykvgdcKdhXZlFLf+a6SCLa5/Q=; 
	b=QgRscTsLWHgkDX3xnUsYSte3i8YAtQvaG71p7fzBpB0qylxfMcM9cULfvmDjPcUWnDdxZGfxAXZy3kKaHjL9z30lf0EtTS/OjpIGZ7S3jYTr2bBEbKDrFQY5ZHUssxW2sLFKlbSfZMZeHLN0R4CwsR3uZfatCTQC8Io4eiWt1ig=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684267270;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rTdYbA9kgaq7J+X3vLykvgdcKdhXZlFLf+a6SCLa5/Q=;
	b=UeBfY/6Te+UdK6Ynb1bduYgDz6Ho1uQcmIrZ1FtdWvX6K5PdiAOsDj1JXPb5uThW
	PYzf4Lg2VQWAx4PmdDJCAJ0rN/jSTDB8p0yIV8f3BwblRNpbXOa3pZsJtsoSMURCYv9
	4o9IqO7GjBEVSe/63Iln5gXeL07EGw14JhSLr60M=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684267268778278.3824139093447; Tue, 16 May 2023 13:01:08 -0700 (PDT)
Message-ID: <6c83136a-8303-7e3b-9f3f-e214e2bfc66f@arinc9.com>
Date: Tue, 16 May 2023 23:01:02 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Daniel Golle <daniel@makrotopia.org>, DENG Qingfang <dqfext@gmail.com>,
 Greg Ungerer <gerg@kernel.org>, Richard van Schagen
 <richard@routerhints.com>, Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, bartel.eerdekens@constell8.be,
 netdev <netdev@vger.kernel.org>
References: <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
 <20230501100930.eemwoxmwh7oenhvb@skbuf> <ZE-VEuhiPygZYGPe@makrotopia.org>
 <839003bf-477e-9c91-3a98-08f8ca869276@arinc9.com>
 <21ce3015-b379-056c-e5ca-8763c58c6553@arinc9.com>
 <20230510140258.44oobynufb3auzw2@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230510140258.44oobynufb3auzw2@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10.05.2023 17:02, Vladimir Oltean wrote:
> On Wed, May 10, 2023 at 10:59:36AM +0200, Arınç ÜNAL wrote:
>>> You seem to be rather talking about MT7530 while I think preferring port 6
>>> would benefit MT7531BE the most.
>>>
>>> Can you test the actual speed with SGMII on MT7531? Route between two ports and
>>> do a bidirectional iperf3 speed test.
>>>
>>> SGMII should at least provide you with 2 Gbps bandwidth in total in a
>>> router-on-a-stick scenario which is the current situation until the changing
>>> DSA conduit support is added.
>>>
>>> If we were to use port 5, download and upload speed would be capped at 500
>>> Mbps. With SGMII you should get 1000 Mbps on each.
>>
>> I tested this on Daniel's Banana Pi BPI-R3 which has got an MT7531AE switch.
>> I can confirm I get more than 500 Mbps for RX and TX on a bidirectional
>> speed test.
>>
>> [SUM][RX-S]   0.00-18.00  sec  1.50 GBytes   715 Mbits/sec    receiver
>>
>> [SUM][TX-S]   0.00-18.00  sec  1.55 GBytes   742 Mbits/sec  6996     sender
>>
>> The test was run between two computers on different networks, 192.168.1.0/24
>> and 192.168.2.0/24, both computers had static routes to reach each other. I
>> tried iperf3 as the server and client on both computers with similar
>> results.
>>
>> This concludes preferring port 6 is practically beneficial for MT7531BE.
> 
> One thing you seem to not realize is that "1 Gbit/sec full duplex" means
> that there is 1Gbps of bandwidth in the TX direction and 1 Gbps of
> bandwidth of throughput in the RX direction. So, I don't see how your
> test proves anything, since a single SGMII full duplex link to the CPU
> should be able to absorb your 715 RX + 742 TX traffic just fine.

I'm talking about 1 Gbps TX and RX (bidirectional) traffic between two 
DSA user ports. We're doing routing so bridge offloading is out of 
question. In this case, the SoC MAC would have to do 2 Gbps TX and 2 
Gbps RX.

I have a BPI-R64 with an MT7531BE at home now, thanks to Daniel's folks. 
Here's the iperf3 bidirectional test result:

Without preferring port 6:

[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734 
    sender
[  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec 
    receiver
[  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0 
    sender
[  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec 
    receiver

With preferring port 6:

[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273 
    sender
[  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec 
    receiver
[  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15 
    sender
[  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec 
    receiver

This scenario is quite popular as you would see a lot of people using 
one port for WAN and the other ports for LAN.

Therefore, the "prefer local CPU port" operation would be useful. If you 
can introduce the operation to the DSA subsystem, I will make a patch to 
start using it on the MT7530 DSA subdriver.

Arınç

