Return-Path: <netdev+bounces-10864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D258573096B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12A28280FDE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFBC11C86;
	Wed, 14 Jun 2023 20:49:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A692EC3F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:49:45 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789EA2128;
	Wed, 14 Jun 2023 13:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686775730; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kE1/7F46IfoXlMqgIsO/Z+JN+JGKtwmqFJux1FEPvbaOfIy0pQJ5OJ3eZqZgHS2I9DbhngLSckNeBYJeFJlPmTbwO/iWCX7srNA+c0i2d33TSATwgGZyPpg1ZqgVK5/ge3Cqa1i7VRFQU89D2TT72lwMv/GbGhl364kMQNRY2ic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686775730; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=41A9vyE5LhQe+wPF1+Q5kPhov+yOmbsk22ksW42fW7g=; 
	b=gtIlfLbW1gB9FYo5JLIxipuGNmOYhMPavFLBsJpf8LL00agnGwkAoMoatMK1/x1w4JVd0l3XQSvXU3aFN8qVYFZVRJFW3KXVRz76HxP0H7/zW9wxDWoDQVh0aFO5AkIg2NDmX5JGt7OyWCug7KSq7gEF+JMK9Rdf6V3XWP2IHFg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686775730;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=41A9vyE5LhQe+wPF1+Q5kPhov+yOmbsk22ksW42fW7g=;
	b=WBPRZeJ6ZNjdlcjcGpMfJxTH7vJpapJTdMeDZ/FIOuQQuVaS5XIamAwm5U+X5pUk
	DgCJ2gg7Ru6xCOjrUFyb2hbJbLfM0aY5AAQUTOARz2g1jVBUdS3NntQjRCH6KiEWp/8
	5UL2oXYLZ1coCbEWc8yC3bpu/EU5dQxN3W3AWAyI=
Received: from [192.168.99.141] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686775729538978.2563745005754; Wed, 14 Jun 2023 13:48:49 -0700 (PDT)
Message-ID: <d90f1658-d07e-5e0d-d8f3-24f9fcb1ef64@arinc9.com>
Date: Wed, 14 Jun 2023 23:48:42 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-6-arinc.unal@arinc9.com>
 <ZInsUm5M47p4ReF3@shell.armlinux.org.uk>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZInsUm5M47p4ReF3@shell.armlinux.org.uk>
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

On 14.06.2023 19:35, Russell King (Oracle) wrote:
> On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index e4c169843f2e..8388b058fbe4 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2261,7 +2261,11 @@ mt7530_setup(struct dsa_switch *ds)
>>   
>>   	/* Trap BPDUs to the CPU port */
>>   	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> -		   MT753X_BPDU_CPU_ONLY);
>> +		   MT753X_PORT_FW_CPU_ONLY);
>> +
>> +	/* Trap LLDP frames with :0E MAC DA to the CPU port */
>> +	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
>> +		   MT753X_R0E_PORT_FW(MT753X_PORT_FW_CPU_ONLY));
>>   
>>   	/* Enable and reset MIB counters */
>>   	mt7530_mib_reset(ds);
>> @@ -2364,7 +2368,11 @@ mt7531_setup_common(struct dsa_switch *ds)
>>   
>>   	/* Trap BPDUs to the CPU port(s) */
>>   	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
>> -		   MT753X_BPDU_CPU_ONLY);
>> +		   MT753X_PORT_FW_CPU_ONLY);
>> +
>> +	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
>> +	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
>> +		   MT753X_R0E_PORT_FW(MT753X_PORT_FW_CPU_ONLY));
> 
> Looking at the above two hunks, they look 100% identical. Given that
> they are both setting up trapping to the CPU port, maybe they should
> be moved into their own common function called from both setup()
> functions?

Good idea, I shall make a function called something like 
mt753x_trap_frames() on my net-next series. For this series which is for 
net, I'd like my patches to fix the issue with as less structural 
changes as possible.

Arınç

