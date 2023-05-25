Return-Path: <netdev+bounces-5241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A4EA7105CF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2831C20BD1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931068F53;
	Thu, 25 May 2023 06:50:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879AA1FB8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:50:56 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1631B3;
	Wed, 24 May 2023 23:50:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684997412; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Q6tJGyb1DqPzT7MCeAIMcBQWCjs4JwfGu7nbsd7137sieZy6Sp3fGl8ZRV6oMVOpban4TFv4Q+ZdNY59bzgsWjNQwQQm/uua1bSKu28CEqCwQ/YmfcI6zyY3i3KAP2dqj7gvtPMNbhNoLFAXYGImrEIafrCSh283DyRMYHSm4W0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684997412; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=QmWADVtt1bAIDiV+lGyZGiUZ+bZgxA+uS3KFDsIT1TI=; 
	b=Dlqo2DyiJIMcTX9m9haJCPBk99OoXEetg/OGfW8D6B6toxUpp3NPJde9NzwB/xX89yMBetlFYckMTO0CE4OMCOfGarlu8KRaaeqCCdnIt4j0+0vBkKudgK6QQGPpWJ0nWwWGnt2BaNhOMjf2YEFKCgknXY4tI888OH9ChDTgqWA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684997412;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=QmWADVtt1bAIDiV+lGyZGiUZ+bZgxA+uS3KFDsIT1TI=;
	b=HBL2Hxc6VzTLaYZitkUWm1IU23e+z20GO7Q2tKeV+gTuVo2gcIzH1VmlOYhWPDxK
	7mO4sCjV6mavxS+wCFAn609L/ufFozIefkjLuDsUVMZEWJFgcL4mqjzb2yyV74WqOOL
	BmBvNgEl6k2svXU4FNUFOZQwquL/lGQbUSd0N1qA=
Received: from [10.10.10.217] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 168499741040714.054183633237926; Wed, 24 May 2023 23:50:10 -0700 (PDT)
Message-ID: <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
Date: Thu, 25 May 2023 09:49:58 +0300
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
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230524175107.hwzygo7p4l4rvawj@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230524175107.hwzygo7p4l4rvawj@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24.05.2023 20:51, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:10PM +0300, arinc9.unal@gmail.com wrote:
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index 710c6622d648..d837aa20968c 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2728,25 +2722,20 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>   			goto unsupported;
>>   		break;
>>   	case 5: /* Port 5, can be used as a CPU port. */
>> -		if (priv->p5_interface == state->interface)
>> +		if (priv->p5_configured)
>>   			break;
>>   
>>   		if (mt753x_mac_config(ds, port, mode, state) < 0)
>>   			goto unsupported;
>> -
>> -		if (priv->p5_intf_sel != P5_DISABLED)
>> -			priv->p5_interface = state->interface;
> 
> If you don't replace this bit with anything, who will set priv->p5_configured
> for mt7530?

I intend priv->p5_configured and priv->p6_configured to be only used for 
MT7531 as I have stated on the mt7530_priv description.

Arınç

