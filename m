Return-Path: <netdev+bounces-10869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB7F730991
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DAFE1C20D94
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5B4125A4;
	Wed, 14 Jun 2023 21:06:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D05F2EC18
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:06:26 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD17211F;
	Wed, 14 Jun 2023 14:06:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686776751; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=N2g2WTxb4Kjk1Nrl8KDVo/5/A8G65KS+OISjUPGXTCK8ILnJ5DcSDCv4fZP46rEaHe5vvaSQ2TRaMTwaD0mh2ESBfs8cfEk2RwzO7V8Js436/Eeoxv0vS5sHYtEhee6Kt1KGB3HhiFniOdJSrx/geuFS+wdcrmK1+XHbtiNL6aI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686776751; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=HL/V6X5FJE49+oavciSGPyT8yk6vbcKidZvKruCwB98=; 
	b=fMuWpNFI++RpUKQ/Y+dSK3J6mww0qb4JpYhjIXZdrO5fxkIdeR9NQm/6/+tZbKljLyFsqKnz8h/9wAqKqNWQrq0ysAISm8ltPg7Oudo9EQGTcPw6DU8LAFVxP341zNyOSJKetgC0Vh/Qoa86SnqZYF9tNqj8LQwNMqqJozcxd/8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686776751;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=HL/V6X5FJE49+oavciSGPyT8yk6vbcKidZvKruCwB98=;
	b=EA0y4NaJwSe1P+xLC5EcWxJPJfJtEA5cjNo3h7rTW3e2PqYSjPqHS0RLDZCOfR4d
	FiAmimy+9ahEAwwc9IxwvamF+akeGHmRsvBWqjsEdxoc8MjkyhPKB/RR09PtQYzBGUH
	ULLykRFMl5i9/UhEFHRP4+s3obRRnyS8HLK80BGo=
Received: from [192.168.99.141] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686776750547832.5791071848975; Wed, 14 Jun 2023 14:05:50 -0700 (PDT)
Message-ID: <e8a0f46b-f133-c155-f0de-9046a53e6069@arinc9.com>
Date: Thu, 15 Jun 2023 00:05:44 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 4/7] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-5-arinc.unal@arinc9.com>
 <20230614205008.czro45ogsc4c6sb5@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230614205008.czro45ogsc4c6sb5@skbuf>
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

On 14.06.2023 23:50, Vladimir Oltean wrote:
> On Mon, Jun 12, 2023 at 10:59:42AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> BPDUs are link-local frames, therefore they must be trapped to the CPU
>> port. Currently, the MT7530 switch treats BPDUs as regular multicast
>> frames, therefore flooding them to user ports. To fix this, set BPDUs to be
>> trapped to the CPU port.
>>
>> BPDUs received from a user port will be trapped to the numerically smallest
>> CPU port which is affine to the DSA conduit interface that is up.
>>
>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index 2bde2fdb5fba..e4c169843f2e 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2259,6 +2259,10 @@ mt7530_setup(struct dsa_switch *ds)
>>   
>>   	priv->p6_interface = PHY_INTERFACE_MODE_NA;
>>   
>> +	/* Trap BPDUs to the CPU port */
>> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> +		   MT753X_BPDU_CPU_ONLY);
>> +
>>   	/* Enable and reset MIB counters */
>>   	mt7530_mib_reset(ds);
>>   
>> -- 
>> 2.39.2
>>
> 
> Where have you seen the BPC register in the memory map of MT7530 or MT7621?

I did not somehow dump the memory map of the switch hardware and confirm 
the BPC register is there, if that's what you're asking.

However, I can confirm the register is there and identical across all 
MT7530 variants. I have tested the function of the register on the MCM 
MT7530 on the MT7621 SoC and the standalone MT7530. The register is also 
described on the document MT7620 Programming Guide v1.0, page 262.

Arınç

