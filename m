Return-Path: <netdev+bounces-9804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D0C72AA51
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 10:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C493F1C20AE7
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA041FD5;
	Sat, 10 Jun 2023 08:33:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3CE2F53
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 08:33:53 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7AD30F9;
	Sat, 10 Jun 2023 01:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686385977; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mzasCzeVniEzTN+y/39+PDdNiCUBC6eMKYj4FWjNnjpNxK7FVFXcKmZq0JtPF708VYUkoog+YvLBKNBmM+wjQrxNX+rdLLrgFDT+whic/JInHrfnXkxtPzfd7ttYCd/Nx3ovrwGy5XWp93Gh7BTa+KPGROpIvpi6u9Zyj/OxMAs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686385977; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=vdOs5mAE/4Z92ZVApF6lsqm3ESAZtt4qbsdKymUSsy8=; 
	b=gVBsM0+2FcnvG3bVzciwhnU06qjgwR4J4FOkyzxB5YzsCos/+tpCuNodm1gm9qvV/Wjjbvf9sU0IPcUZDq66ejBVwLsG8Mv69iXnoN/F8tIBk+/j2qa9p3ldTiiygCaf0GtiUU8bO/o6l4fDq6vS9FC00UhntqceeBN68BmIym8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686385977;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vdOs5mAE/4Z92ZVApF6lsqm3ESAZtt4qbsdKymUSsy8=;
	b=Dv2eB1Wtw+Fyp5d5/MP0TnVUpiWG6LUuYza4XoA/eq5ShXa4ujBXwpQ1ULLHRyV4
	0R4TRWoVnLspsmhMCurtry5hTwJXsq/aLUAI35aHwdbeAteP44GfwSAExyBWDlAT0rF
	h+aYRMUofnaN+9sjHCihcnV4t6Tw4Q55LYPJ8NEE=
Received: from [192.168.99.249] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686385976069223.85040573382184; Sat, 10 Jun 2023 01:32:56 -0700 (PDT)
Message-ID: <6a64db9e-ac6c-c571-fb8b-ae3aa2da07b7@arinc9.com>
Date: Sat, 10 Jun 2023 11:32:45 +0300
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
 <cc21196b-a18a-ce3c-e3f3-4303abf4b9a3@arinc9.com>
 <20230604124701.svt2r3aveyybajc3@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230604124701.svt2r3aveyybajc3@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 4.06.2023 15:47, Vladimir Oltean wrote:
> On Sun, Jun 04, 2023 at 12:39:33PM +0300, Arınç ÜNAL wrote:
>> On 4.06.2023 12:23, Vladimir Oltean wrote:
>>> On Sun, Jun 04, 2023 at 11:51:33AM +0300, Arınç ÜNAL wrote:
>>>>> If the switch doesn't currently trap BPDUs, isn't STP broken?
>>>>
>>>> No, the BPDU_PORT_FW bits are 0 after reset. The MT7620 programming guide
>>>> states that frames with 01:80:C2:00:00:00 MAC DA (which is how the BPDU
>>>> distinction is being made) will follow the system default which means the
>>>> BPDUs will be treated as normal multicast frames.
>>>>
>>>> Only if all 3 bits are set will the BPDUs be dropped.
>>>
>>> Right, if you don't trap BPDUs just to the CPU but flood them, I believe
>>> the STP protocol won't behave properly with switching loops. Worth testing.
>>
>> I've got no interest spending time playing around with STP at the moment so
>> I'm going to pass.
> 
> You can at the very least move it towards the beginning of the net-next patch
> set, so that we can be sure it doesn't depend on the other refactoring work,
> in case someone in the future makes a request for the patch to be backported
> to stable.

Maybe I should submit this and LLDP trapping to net? Currently, the 
MT7530 subdriver on the stable kernels treat LLDP frames and BPDUs as 
regular multicast frames, therefore flooding them to user ports, which 
is wrong. These patches could count as bug fixes.

Arınç

