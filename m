Return-Path: <netdev+bounces-9879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B2872B09B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 09:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 801E31C20B2F
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 07:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159ED1FCC;
	Sun, 11 Jun 2023 07:25:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0564D10F5
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 07:25:08 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A019D;
	Sun, 11 Jun 2023 00:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686468247; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PJkYnfjHIt5lSfIJXPdoc7Puw9GEgilIkPV+6m3bXd/Ko3iqoTSSzBGGdsZD0y5Fc0CLXL8dAZZYfMiotfZBFtDJiphfto2DswoGaYOXDq14fzZSZB2ELbH8cNYuAh/Wh0rV1UHJeh4Spam0ATULLKuJLbMNz3i1JampIMc03D8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686468247; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=TvnIt1NPnY/M+Hzkk3Jlxpw9Z7EFJCUPe2Xg0xI+ZqE=; 
	b=as8JIftOtZLAtiBlsmfOAjPgWEoq2vdwhT4qnwHagx8/YF6gGWSrKyfs+/MQSEMQOvMU8IOXC/IlZb1h0xrFwfKPbzWfQe8otlFtTuKO+AVey0bMFcYMmWvI2QHaynO1KsxOLNk8PWKTwH/ukxoDzzT7khpCDB3NEwc2JTQuhs4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686468247;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TvnIt1NPnY/M+Hzkk3Jlxpw9Z7EFJCUPe2Xg0xI+ZqE=;
	b=bQlIEsRWRnryhQpIcskUtUB62Vi8AeLxHqUYVnH+ydQdkifbabL+nWiz6m6UQV9J
	L9e0L9h+ahZmzsV0feXXnTsYtuW5c1uuepzRLc5Pk0JcseiagDx0NJvF2LBAuonI+E0
	IlOeGFNVGT/rKR7N2xGCVJsrbF7K+Clf6x830fBY=
Received: from [192.168.99.249] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686468245416961.631805529769; Sun, 11 Jun 2023 00:24:05 -0700 (PDT)
Message-ID: <22fba48c-054d-ff0a-ae2c-b38f192b26f7@arinc9.com>
Date: Sun, 11 Jun 2023 10:23:55 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Sean Wang <sean.wang@mediatek.com>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Daniel Golle <daniel@makrotopia.org>,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
 <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
 <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
 <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
 <ZHyqI2oOI4KkvgB8@shell.armlinux.org.uk>
 <ZHy1C7wzqaj5KCmy@shell.armlinux.org.uk>
 <ZHy2jQLesdYFMQtO@shell.armlinux.org.uk>
 <0542e150-5ff4-5f74-361a-1a531d19eb7d@arinc9.com>
 <7c224663-7588-988d-56cb-b9de5b43b504@arinc9.com>
 <20230610175553.hle2josd5s5jfhjo@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230610175553.hle2josd5s5jfhjo@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10.06.2023 20:55, Vladimir Oltean wrote:
> On Sat, Jun 10, 2023 at 01:57:27PM +0300, Arınç ÜNAL wrote:
>> I was able to confirm all user ports of the MT7531BE switch transmit/receive
>> traffic to/from the SGMII CPU port and computer fine after getting rid of
>> priv->info->cpu_port_config().
>>
>> Tried all user ports being affine to the RGMII CPU port, that works too.
>>
>> https://github.com/arinc9/linux/commit/4e79313a95d45950cab526456ef0030286ba4d4e
> 
> Did you do black-box testing after removing the code, or were you
> also able to independently confirm that the configurations done by
> cpu_port_config() were later overwritten? I'm trying to disambiguate
> between "works by coincidence" and "works because the analysis was
> correct".

I did my testing, merely to make sure we didn't miss anything as Russell 
already stated that the configuration from cpu_port_config() is later 
overwritten.

I could put some dev_info around to confirm the code path that 
overwrites the configuration.

Arınç

