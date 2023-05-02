Return-Path: <netdev+bounces-9-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53C46F4AE3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25078280D15
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A139463;
	Tue,  2 May 2023 20:07:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0661E945F
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:07:02 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFD91997;
	Tue,  2 May 2023 13:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1683057967; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iT9g+M0S+e+kRek4sdOtHe0l/mzpHdAoLIaIEuCqJR6VKV8I3ajk8qHrspCs0wjpbn5pSvgHcRY67yOIN5xlAW17IDoGHE1e0b2CuR1sEEf9SZbQ33fy99Le56jVcI3jGOLlVhL5XHi4iaWuRGLQUlxkDo4Nb+6a9KwstviZIi0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1683057967; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=jRzQaQYMyheL6/9XvWrDvecv1EQ6rZdy4z1HdYKesGo=; 
	b=e35bLITHWvU4k3TnGL4PYr+iHwWlVDWcJxjGPRuKsdwAnZ9ClpqsOmVUccrqCQ8Y4jgDlKjxQIomNwrXIKs/q8j7g7CxinYnNw7W8ol3a5mcd49jAwL+KCeOtk19M1hfIxS16kbVI0OWtG+YLvjVFZT9RAJP0Su5ze0UG1CUBfI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1683057967;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=jRzQaQYMyheL6/9XvWrDvecv1EQ6rZdy4z1HdYKesGo=;
	b=HwUlBdNPExWNS3ZRm5TUZIeayBebk5apv+VrpEbHIRrfU6SY3qArHdodzmiSDME8
	+7xbYgJ9gLd+Xtd22VzsnsHVarFvKcD9L4hJHrdYY7gKyZ1NP+5EddBcp4H7SQsoqEI
	oyflG8ls/YY7SHqW7gO//lvUUtDVX2orxAyUqFj0=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 168305796648833.62395961631171; Tue, 2 May 2023 13:06:06 -0700 (PDT)
Message-ID: <c9765637-4601-0a7d-7e5e-4c3e9d52d90f@arinc9.com>
Date: Tue, 2 May 2023 23:05:41 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] net: dsa: mt7530: fix network connectivity with
 multiple CPU ports
To: Florian Fainelli <f.fainelli@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Daniel Golle <daniel@makrotopia.org>,
 Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc: Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230501121538.57968-1-arinc.unal@arinc9.com>
 <20230501121538.57968-2-arinc.unal@arinc9.com>
 <5e00b4c7-8d3f-e1b2-4359-5ee8fdf92ea9@gmail.com>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <5e00b4c7-8d3f-e1b2-4359-5ee8fdf92ea9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 02/05/2023 21:30, Florian Fainelli wrote:
> 
> 
> On 5/1/2023 5:15 AM, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> On mt753x_cpu_port_enable() there's code that enables flooding for the 
>> CPU
>> port only. Since mt753x_cpu_port_enable() runs twice when both CPU ports
>> are enabled, port 6 becomes the only port to forward the frames to. But
>> port 5 is the active port, so no frames received from the user ports will
>> be forwarded to port 5 which breaks network connectivity.
>>
>> Every bit of the BC_FFP, UNM_FFP, and UNU_FFP bits represents a port. Fix
>> this issue by setting the bit that corresponds to the CPU port without
>> overwriting the other bits.
>>
>> Clear the bits beforehand only for the MT7531 switch. According to the
>> documents MT7621 Giga Switch Programming Guide v0.3 and MT7531 Reference
>> Manual for Development Board v1.0, after reset, the BC_FFP, UNM_FFP, and
>> UNU_FFP bits are set to 1 for MT7531, 0 for MT7530.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> This tag is implied by your Signed-off-by tag. No Fixes tag for this one?

I've put it with v2. Let me send v3 to remove the tested-by and add your 
reviewed-by to the other patch.

Arınç

