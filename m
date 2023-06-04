Return-Path: <netdev+bounces-7737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3798572154E
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 675021C20AD2
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 07:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E526D23CF;
	Sun,  4 Jun 2023 07:19:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6AA15C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:19:08 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A18D2;
	Sun,  4 Jun 2023 00:19:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685863111; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Du25Szoeq7xfXqGzr1DFoJ2H6FK1MGnor4r1Es1MjuKbi/OTLokEFgD9W8YMF8dDhi2/haKqJBQwx2Klwg9E2BcZzkrq1MMdaUPR3tMyRsZ0i7/2jBU4tZ4ApncIU97x2LB3n/tVsy3ByEqgQqbidck0MKZtElHu69xauBwRnwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685863111; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=kxiz5zm70BezbuNN8v6JP8irFq1B+lspoXHQDQtRgY8=; 
	b=IZiqA7xnNyrietBNPyKPoWFW5JgzzXWn+ffU/xeZ4iwTU0Er7pX4JSF5sommXubs/yARDCDyBx0tc3TYIUVHS5KJX3jFK4KWc+Emez4OF+lsxNB4fZdztXbE3uxvTlbGleKGe8+vtGn3Ac3LIQh1JQemQ8lutcmALSqDXlc7Xr0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685863111;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=kxiz5zm70BezbuNN8v6JP8irFq1B+lspoXHQDQtRgY8=;
	b=WqnPFherLeb3ujWwy+TWDONE0esDoCe9Hni1i8msdr7WjxD3Rld6yT243QyesWW8
	FSsar+Kqm3hVIkvyFZ9VvLJXVdMsavztoFI1xafRplkHthXrzTms8qVVNNRlQc+y5eb
	i7ot0nsqDNtRoxUbjYPJY0NPDUXOaN4JjhBd/QgQ=
Received: from [192.168.83.218] (62.74.60.162 [62.74.60.162]) by mx.zohomail.com
	with SMTPS id 1685863109616710.6883935588407; Sun, 4 Jun 2023 00:18:29 -0700 (PDT)
Message-ID: <4d2bd4fb-923a-96c9-395c-5e2127695933@arinc9.com>
Date: Sun, 4 Jun 2023 10:18:20 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 19/30] net: dsa: mt7530: set interrupt register
 only for MT7530
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
 <20230522121532.86610-20-arinc.unal@arinc9.com>
 <20230526132508.fxgljrpozuuzelal@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230526132508.fxgljrpozuuzelal@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26.05.2023 16:25, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:21PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Setting this register related to interrupts is only needed for the MT7530
>> switch. Make an exclusive check to ensure this.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Acked-by: Daniel Golle <daniel@makrotopia.org>
>> Tested-by: Daniel Golle <daniel@makrotopia.org>
>> ---
> 
> Why does it matter? What prompted you to make this change? I guess it's
> not needed for MT7988? Or the register is not present? Or?...

It's not needed for the switch on the MT7988 SoC. The register is also 
likely specific to the MT7530 switch.

Arınç

