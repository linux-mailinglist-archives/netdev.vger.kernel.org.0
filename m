Return-Path: <netdev+bounces-7776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF42721772
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B14E281158
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5013EAD43;
	Sun,  4 Jun 2023 13:34:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213233F2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:34:09 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9100ADA;
	Sun,  4 Jun 2023 06:34:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685885608; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DPnm3klMFsV5I+wpRudckd2hAgFIn6ljkvX/NMTxREfdp5cxEvlcc28W8zn3rqInhGaONTvdWZI+7CIVnsyn80IlY5WFjxzEh3vgwIQtQGguGyggQU4dYfAQ6HAQs+yPV2oXw6auRPNe0E0sK6/weNzbadAjwOGvdPGyawby8/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685885608; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=BzcElPlulU+8xjoOMrgsQgOCoANsPHLfjay0Dt8SHEY=; 
	b=NKGrUXTER60OMO2P6gB4dCh5pQFottY0WzoXZwJPNbvD9nE9LpQMqtq9PSTKoOLtJhkuZB9ZxZPc3284YIAcCxrKep8YMJtZsTk4MQruLz+Xpc1ec94i/W3kyK9Dr8R1RqN164rj/mBR8DoI9DRp1jBvEfhv+VykkLmIW6h2zto=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685885608;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=BzcElPlulU+8xjoOMrgsQgOCoANsPHLfjay0Dt8SHEY=;
	b=fndRkYd6lUAGZrs3zb0Cco21VEpzO/i+OsXd3S2j6P+YDuEBxRJ2zHnt5sMGQsVK
	CwSC66PgCJ/1vExUMGWTL6wq+Jf7TkApctmM0ObIoLgO43bmXX27udCLcfpiwjPdci6
	QUMuEPLlf7ssYtCX6X24XzpPpLGHe+74VPq5m8VQ=
Received: from [192.168.99.249] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1685885607262824.205537190085; Sun, 4 Jun 2023 06:33:27 -0700 (PDT)
Message-ID: <9ce13208-a20d-44ef-8b47-456801c075a1@arinc9.com>
Date: Sun, 4 Jun 2023 16:33:17 +0300
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
 <9423a818-f9c0-d867-7f7d-27f05e1536b9@arinc9.com>
 <20230604130808.3lxuz5ezsouhku57@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230604130808.3lxuz5ezsouhku57@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 4.06.2023 16:08, Vladimir Oltean wrote:
> On Sun, Jun 04, 2023 at 11:21:48AM +0300, Arınç ÜNAL wrote:
>>> Stylistically, the existence of an indirect call to priv->info->cpu_port_config()
>>> per switch family is a bit dissonant with an explicit check for device id later
>>> in the same function.
>>
>> mt753x_cpu_port_enable() is not being called from priv->info->cpu_port_config()
>> though.
> 
> Quite the other way around. I'm saying that mt753x_cpu_port_enable(),
> the function whose logic you're changing, already has a mechanism to
> execute code specific to one switch family.

Ah, makes sense.

> 
>> I'm not sure how I would do this without the device ID check here.
> 
> Hmm, by defining a new mt7530_cpu_port_config() procedure for ID_MT7621
> and ID_MT7530?
> 
> Although in a different thread we are perhaps challenging the idea that
> what is currently in priv->info->cpu_port_config() is useful - at least
> half of it are manual invocations of phylink methods which are possibly
> not needed. If after the removal of those, it no longer makes sense to
> have priv->info->cpu_port_config() at all, then I'm not saying that the
> explicit check for device id here doesn't make sense. Just that it's not
> in harmony with what currently exists 3 lines above.

Regardless of the outcome of that conversation, I would like to avoid 
structural changes like this since this patch will go to net.

> 
>>>> -#define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
>>>> +#define  MT7531_CPU_PMAP(x)		((x) & 0xff)
>>>
>>> You can leave this as ((x) & GENMASK(7, 0))
>>
>> Now that I've read Russell's comment on the previous patch, the below would
>> be even better?
>>
>> MT7531_CPU_PMAP(x)		FIELD_PREP(MT7531_CPU_PMAP_MASK, x)
>>
>>>
>>>> +#define  MT7531_CPU_PMAP_MASK		MT7531_CPU_PMAP(~0)
>>>
>>> There's no other user of MT7531_CPU_PMAP_MASK, you can remove this.
>>
>> Should I do above or remove this?
> 
> No specific preference. If you want to make this driver start using
> FIELD_PREP() then go ahead.

Will do.

Arınç

