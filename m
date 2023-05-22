Return-Path: <netdev+bounces-4321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFB370C131
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 682C81C20B3E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4388BE70;
	Mon, 22 May 2023 14:36:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EF5EA8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:36:46 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483A1A3;
	Mon, 22 May 2023 07:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684766124; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=h2hzkdS2CI6Z+pFM1kk69pxUImMUae+stETe0LFWQpY3nN4k73ZS9zxQvqCUt6ejUdoaX1fEjqxjoVadSMjm2f5NdQWRitO/CN9/YtGmTMoL7gKJ62t/+PYyxjgKnMOS1MKJ223NTlKbNm+3UBBu0mmEWFiKHzVm5UCwbUMSl+Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684766124; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=XmUQ9AU5MTRMPEErZmQ/5DPCCW/8oUmeD0bDn1GwqDg=; 
	b=jOmPbhFySazqUQwztCzWg1vcyKLAXA8pdLZTW50DIejvxQbpBM+zC4SS+3jkKEiqqYgyUaL82z1jxSUNJbb+yUfQZ1ZBj3Ihl3nRQqhfRev4+31o2GrUghHY3n4I959/E5yLozkP7smPit5TMig8Qa4GC0f+TbWw5pWiMSdbiFs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684766124;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XmUQ9AU5MTRMPEErZmQ/5DPCCW/8oUmeD0bDn1GwqDg=;
	b=NSSwN/B8POoWFVP+y7ZKK0vvVKDrbQwLyFkWPfDkx/OnEb+XY2x5f40rD4mlqmS5
	pKkZnDbTaJYFoia/98nQHQbp9qPR86IBCR4eZdzGDC4azjLEf63GQR2wrwDgna56HLc
	uQu4OHRw1kiClzHsrUWGmSgJd5lGAmVBUttAOtuU=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684766122962358.61257803096214; Mon, 22 May 2023 07:35:22 -0700 (PDT)
Message-ID: <87a5f9bc-f230-243b-e77c-9ae849008fb5@arinc9.com>
Date: Mon, 22 May 2023 17:35:13 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 00/30] net: dsa: mt7530: improve, trap BPDU &
 LLDP, and prefer CPU port
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
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
 <20230522140917.er7f5ws24b2eeyvs@soft-dev3-1>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230522140917.er7f5ws24b2eeyvs@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 22/05/2023 17:09, Horatiu Vultur wrote:
> The 05/22/2023 15:15, arinc9.unal@gmail.com wrote:
> 
> Hi,
> 
>>
>> Hello!
>>
>> This patch series simplifies the code, improves the logic of the switch
>> hardware support, traps LLDP frames and BPDUs for MT7530, MT7531, and
>> MT7988 SoC switches, and introduces the preferring local CPU port
>> operation.
>>
>> There's also a patch for fixing the port capabilities of the switch on the
>> MT7988 SoC.
>>
> 
> I have noticed that in many patches of the series you have:
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Where you also have:
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> I think you can drop Tested-by as the SoB will imply that. I think you
> got a similar comment some time ago to a different patch series.

Yes, that was for the net, therefore the stable tree. The very first 
rule for the patches going to the stable tree is that the patch must be 
tested.

I don't see a clear indication of the patches submitted to net-next 
being tested on the relevant hardware by the author. Therefore, I 
explicitly put my tag to state it. Let me know if you don't agree with this.

Arınç

