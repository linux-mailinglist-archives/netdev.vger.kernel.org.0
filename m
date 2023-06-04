Return-Path: <netdev+bounces-7741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD73472158C
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F303D281536
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A94B3C21;
	Sun,  4 Jun 2023 08:23:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B1A15C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:23:21 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382BFDC;
	Sun,  4 Jun 2023 01:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685866925; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=AuCOY2I/0s6oDXBcar0ULPGQGW5nDQmOr0/LEQXwRC2d2eTZOGt0+zhjg3gKQUVjLAMkkqZ06BtGZ0VQCHSiOM2/nBsTOVr7CLFPRQ/AuZqXCfnrvpRwDRHpVOjgB1InSg2m65MM6jZ7Nt2nKEUjs809LNMfe2q+0yC8jzcm5NY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685866925; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=pdL5Ne9Pz+dUQOaZMPqJzW+PoASYoCWnGHeubyQw/e4=; 
	b=ndWuuahEoBRtqPYBHvCX/C0T6zvmbXVHry2GbbxjoDW17DNJfbPf7qe6iPH/tZK8cJTBnfQOZENDpX3Z0/f6EOXU69KfPT48PdcbaqLCPNiqzu767Hkg/VLV8vEoycrbY5DiqOIAtF++2XIzAghylTW4w2vIrYsPBezMaV/g7NU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685866924;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=pdL5Ne9Pz+dUQOaZMPqJzW+PoASYoCWnGHeubyQw/e4=;
	b=kSJKviUHmtkTO7jbJFz1KsvLJDxe6R3XyfQ+eC+JncMlzoUzlQlShmZPzD38tSSc
	ur2WliWe8+vjbDR51ndPKOtlkW2iU9hN9bHlLZuO2BvoS3mLnRvI8/ddS7sJacSXOpy
	j+qDwSoqXQVuLY8mHHxBs3Fowvz0xhKtxYC97hc4=
Received: from [192.168.66.198] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1685866922808204.7165874943779; Sun, 4 Jun 2023 01:22:02 -0700 (PDT)
Message-ID: <9423a818-f9c0-d867-7f7d-27f05e1536b9@arinc9.com>
Date: Sun, 4 Jun 2023 11:21:48 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 25/30] net: dsa: mt7530: properly set
 MT7531_CPU_PMAP
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
 <20230522121532.86610-26-arinc.unal@arinc9.com>
 <20230522121532.86610-26-arinc.unal@arinc9.com>
 <20230526155124.sps74wayui6bydao@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230526155124.sps74wayui6bydao@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26.05.2023 18:51, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:27PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
>> SoC represents a CPU port to trap frames to. Currently only the bit that
>> corresponds to the first found CPU port is set on the bitmap. Introduce the
>> MT7531_CPU_PMAP macro to individually set the bits of the CPU port bitmap.
>> Set the CPU port bitmap for MT7531 and the switch on the MT7988 SoC on
>> mt753x_cpu_port_enable() which runs on a loop for each CPU port. Add
>> comments to explain this.
>>
>> According to the document MT7531 Reference Manual for Development Board
>> v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
>> beforehand. Since there's currently no public document for the switch on
>> the MT7988 SoC, I assume this is also the case for this switch.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> Is this supposed to be a bug fix? (incompatibility with past or future
> device trees also counts as bugs) If so, it needs a Fixes: tag and to be
> targeted towards the "net" tree. Also, the impact of the current behavior
> and of the change need to be explained better.

Yes, this fixes a bug for future devicetrees. I will send this to net 
with a more detailed explanation, thanks.

> 
>>   drivers/net/dsa/mt7530.c | 15 ++++++++-------
>>   drivers/net/dsa/mt7530.h |  3 ++-
>>   2 files changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index 58d8738d94d3..0b513e3628fe 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -963,6 +963,13 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>>   		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
>>   			   MT7530_CPU_PORT(port));
>>   
>> +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
>> +	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
>> +	 * trapped to the CPU port the user port is affine to.
>> +	 */
>> +	if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
>> +		mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP(BIT(port)));
>> +
> 
> Stylistically, the existence of an indirect call to priv->info->cpu_port_config()
> per switch family is a bit dissonant with an explicit check for device id later
> in the same function.

mt753x_cpu_port_enable() is not being called from 
priv->info->cpu_port_config() though. I'm not sure how I would do this 
without the device ID check here.

> 
>>   	/* CPU port gets connected to all user ports of
>>   	 * the switch.
>>   	 */
>> @@ -2315,15 +2322,9 @@ static int
>>   mt7531_setup_common(struct dsa_switch *ds)
>>   {
>>   	struct mt7530_priv *priv = ds->priv;
>> -	struct dsa_port *cpu_dp;
>>   	int ret, i;
>>   
>> -	/* BPDU to CPU port */
>> -	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
>> -		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
>> -			   BIT(cpu_dp->index));
>> -		break;
>> -	}
>> +	/* Trap BPDUs to the CPU port(s) */
>>   	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>>   		   MT753X_BPDU_CPU_ONLY);
>>   
>> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
>> index 5ebb942b07ef..fd2a2f726b8a 100644
>> --- a/drivers/net/dsa/mt7530.h
>> +++ b/drivers/net/dsa/mt7530.h
>> @@ -53,7 +53,8 @@ enum mt753x_id {
>>   #define  MT7531_MIRROR_MASK		(0x7 << 16)
>>   #define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & 0x7)
>>   #define  MT7531_MIRROR_PORT_SET(x)	(((x) & 0x7) << 16)
>> -#define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
>> +#define  MT7531_CPU_PMAP(x)		((x) & 0xff)
> 
> You can leave this as ((x) & GENMASK(7, 0))

Now that I've read Russell's comment on the previous patch, the below 
would be even better?

MT7531_CPU_PMAP(x)		FIELD_PREP(MT7531_CPU_PMAP_MASK, x)

> 
>> +#define  MT7531_CPU_PMAP_MASK		MT7531_CPU_PMAP(~0)
> 
> There's no other user of MT7531_CPU_PMAP_MASK, you can remove this.

Should I do above or remove this?

Arınç

