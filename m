Return-Path: <netdev+bounces-7748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973667215DC
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13D9828122E
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5D3441B;
	Sun,  4 Jun 2023 09:40:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B723A8
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:40:37 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39413C4;
	Sun,  4 Jun 2023 02:40:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685871585; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gSgzJn5CL+O8JRGQl9k63DOoj9fWKcId1L3nQggvd1gIHzIwYxWTywtLT/a02TJ7LRrecXnCC5c0dpEhZ8RSxBqZ/OjLSwZRIfpd8GOI9H6HafFgA6uVsz7ttsQWKJk0BS6JJxg6+l0Fj/9M56+7pBbcTXlfvYyzJgGN8EpIzAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685871585; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=Fr/61BSJkRBxnPIU/JaeVp9SfOJCht1lutLoKEyNQ14=; 
	b=Pwa4aYUItn0lfVIAXIIQnf2PlKXweoSkeHOsX49H7wIgV177CfEaKoNKBTzfnYEtNnyq11QSRdyn3JCrLYF/8wIvAJg36yMkwyGK6MMrPRPX5Tbncl2UdmydgjidE/oPKMwK7Ul7HN1VF95Ps/VAH+8vDBZpogsN1V4gPafFdKE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685871585;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Fr/61BSJkRBxnPIU/JaeVp9SfOJCht1lutLoKEyNQ14=;
	b=XvCCgXYOXJbcaYICu8ov2yD6s6INX/5B14mgo4bFrS7DKgv688oGNU6UrBl7guFo
	qf+VcpMlYJ3R+o34qTJEl8bHvzmL6fEffBFca7Mr5rbql59/kemX2VRIJts8NGkoedR
	w6MH1IK7sKpbHy0T8Sn3cFFvoqjo5ku5EeACGQoY=
Received: from [192.168.99.249] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 168587158327044.95124558097791; Sun, 4 Jun 2023 02:39:43 -0700 (PDT)
Message-ID: <cc21196b-a18a-ce3c-e3f3-4303abf4b9a3@arinc9.com>
Date: Sun, 4 Jun 2023 12:39:33 +0300
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
 <f22d1ddd-b3a4-25da-b681-e0790913f526@arinc9.com>
 <20230604092304.gkcdccgfda5hjitf@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230604092304.gkcdccgfda5hjitf@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 4.06.2023 12:23, Vladimir Oltean wrote:
> On Sun, Jun 04, 2023 at 11:51:33AM +0300, Arınç ÜNAL wrote:
>>> If the switch doesn't currently trap BPDUs, isn't STP broken?
>>
>> No, the BPDU_PORT_FW bits are 0 after reset. The MT7620 programming guide
>> states that frames with 01:80:C2:00:00:00 MAC DA (which is how the BPDU
>> distinction is being made) will follow the system default which means the
>> BPDUs will be treated as normal multicast frames.
>>
>> Only if all 3 bits are set will the BPDUs be dropped.
> 
> Right, if you don't trap BPDUs just to the CPU but flood them, I believe
> the STP protocol won't behave properly with switching loops. Worth testing.

I've got no interest spending time playing around with STP at the moment 
so I'm going to pass.

Arınç

