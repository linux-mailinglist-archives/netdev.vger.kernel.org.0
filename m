Return-Path: <netdev+bounces-7744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F317215A6
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7E642810FB
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC86C3C21;
	Sun,  4 Jun 2023 08:52:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E7223CD
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:52:26 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EECDE;
	Sun,  4 Jun 2023 01:52:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685868704; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FJsGTPaNwwLnQwoJVsvCPFellmYOjV14iN908lyrurZRKgxf5YHa0VuJG3E4gogNkzVAGqgPHZdYMcULSg2rDWi2FaNwh5nT6Cd/hENl1sSLjPk1qCMxPQUFJY33L42+JHbJ8i+CGRfZg2SO/pT1lqr7Lpzr1s/gOKXCjPC4W14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685868704; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=JDuiXLCGzzO/Sa1SkbOMDLd2Wht81ovWaQRXAtnD/UY=; 
	b=BVIEPJjLJEfUGbTGUhG+66kDFe3C3gg3pvbdGd6NDrCWAkh7/s+TRKcoVVI9OL4oRU6Mhk1IDSGBrloGG7W/ZHNdhE//urc8faVS90EmrtE/9ma918V7HDN5710SshgP4iwuqwhG5E2wbwH73Upk/LuXrTSyxuPIRoPsNuRLQQI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685868704;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=JDuiXLCGzzO/Sa1SkbOMDLd2Wht81ovWaQRXAtnD/UY=;
	b=LqF5sL3TmyHAitUrJneiLnfE4Lvk/E8L8XFUtOYTTAB0VhJrNSo2vx60b9z9fhlr
	bko64Va5Z+U4CFn2PXRp4eVTS9qHUlOTzTtncl4wSOk+Kg2bVrhC0mhBBtjk9Ke6RlN
	TgbRAoCTyZjj5MKPfxtZgIQ5oeUkzh0I0UF0FxFw=
Received: from [192.168.66.198] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1685868703012472.04727499914725; Sun, 4 Jun 2023 01:51:43 -0700 (PDT)
Message-ID: <f22d1ddd-b3a4-25da-b681-e0790913f526@arinc9.com>
Date: Sun, 4 Jun 2023 11:51:33 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 27/30] net: dsa: mt7530: introduce BPDU trapping
 for MT7530 switch
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
 <20230522121532.86610-28-arinc.unal@arinc9.com>
 <20230526170223.gjdek6ob2w2kibzr@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230526170223.gjdek6ob2w2kibzr@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26.05.2023 20:02, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:29PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The MT753X switches are capable of trapping certain frames. Introduce
>> trapping BPDUs to the CPU port for the MT7530 switch.
>>
>> BPDUs will be trapped to the numerically smallest CPU port which is affine
>> to the DSA conduit interface that is set up. The BPDUs won't necessarily be
>> trapped to the CPU port the user port, which these BPDUs are received from,
>> is affine to.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index cd16911fcb01..2fb4b0bc6335 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2223,6 +2223,10 @@ mt7530_setup(struct dsa_switch *ds)
>>   	val |= MHWTRAP_MANUAL;
>>   	mt7530_write(priv, MT7530_MHWTRAP, val);
>>   
>> +	/* Trap BPDUs to the CPU port */
>> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> +		   MT753X_BPDU_CPU_ONLY);
>> +
> 
> If the switch doesn't currently trap BPDUs, isn't STP broken?

No, the BPDU_PORT_FW bits are 0 after reset. The MT7620 programming 
guide states that frames with 01:80:C2:00:00:00 MAC DA (which is how the 
BPDU distinction is being made) will follow the system default which 
means the BPDUs will be treated as normal multicast frames.

Only if all 3 bits are set will the BPDUs be dropped.

> 
> ip link add br0 type bridge stp_state 1
> (with or without a userspace helper installed at /sbin/bridge-stp
> for more modern protocols than the original 802.1D STP)

For reference, the mstpd package on Buildroot includes this.

Arınç

