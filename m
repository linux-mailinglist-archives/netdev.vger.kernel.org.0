Return-Path: <netdev+bounces-7734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D92372153F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 159FC281664
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 07:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0564815C1;
	Sun,  4 Jun 2023 07:07:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB3E17E0
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:07:00 +0000 (UTC)
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D8BCE;
	Sun,  4 Jun 2023 00:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685862356; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MaeXxhj1EARya0kutlg6dIJYkGvmpgCYqa/kPfl4vcm0yNcbRqKEh6OijB7VfrTJx7K+j2+FQ/HCEpmGiOXYkWEmpTFY0Ib4hgSo79qt3ktGFDNjvnxzE5CXglSUD5Pvl0jT4SwkQcYd0TpBtOobpBwzgFIvT/ar2iOBTgcWUjo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685862356; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=qjRmj6H2wGtXEr4zcHqv6N4BE15oNkHWiHsODHkVZ8U=; 
	b=maz+dZLgS0frMtmfzlLluHX6/IdSypC3Qw3fZu1UMJY6kMTynmEcf/KQZtOhrOxn4DY3dzVQB9qAtoFebfATQ6gSZx6jZnyaLYH2qmeW2xkI5phiEgUCzojAVeTn6oRf/C19XHTX/CG09t1Hwza7/rB0qvLMhh30DQuGBu6oAPg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685862356;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=qjRmj6H2wGtXEr4zcHqv6N4BE15oNkHWiHsODHkVZ8U=;
	b=H+h1UxFcgBzwpFYKxhEbsuRxeEoR4mVInvzkmTnWHr4px0n60ohxbeqlIlo01z0a
	uqWwNgRF1zkTNJLbgOQI2OpEEJIzDibqsycjV+SZHv7/Q9JU4GgA8tWtxSKXUv4a3w/
	MEz1n85pEZOfr6KufyG5ujVEjMl5mDreBFQeDTNs=
Received: from [192.168.83.218] (62.74.60.162 [62.74.60.162]) by mx.zohomail.com
	with SMTPS id 1685862354320242.65733119193078; Sun, 4 Jun 2023 00:05:54 -0700 (PDT)
Message-ID: <08e9c220-cf15-4c61-f7f4-ad8073a3bcf7@arinc9.com>
Date: Sun, 4 Jun 2023 10:05:44 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 16/30] net: dsa: mt7530: move lowering port 5
 RGMII driving to mt7530_setup()
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
 <20230522121532.86610-17-arinc.unal@arinc9.com>
 <20230522121532.86610-17-arinc.unal@arinc9.com>
 <20230526131739.5mso5y2d3ieelasf@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230526131739.5mso5y2d3ieelasf@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26.05.2023 16:17, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:18PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
>> driving of trgmii on port 6 on mt7530_setup().
>>
>> This way, the switch should consume less power regardless of port 5 being
>> used.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> This patch assumes that the MAC has its TXC ticking even when PMCR_TX_EN
> is unset. Why would it do that?

It wouldn't. I'll drop this patch, thanks. For reference, PMCR_TX_EN 
(bit 14) for port 5 is also set in the case of PHY muxing with this code 
on mt7530_setup_port5() which doesn't use phylink.

		/* Setup the MAC by default for the cpu port */
		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);

0x56300 = 0101 0110 0011 0000 0000

Maybe I should make a patch to use the definitions on mt7530.h for this?

Arınç

