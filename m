Return-Path: <netdev+bounces-7743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDA172159D
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13AE5280ECD
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F8017ED;
	Sun,  4 Jun 2023 08:34:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B72A15C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:34:40 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFCACF;
	Sun,  4 Jun 2023 01:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685867627; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nKTLRYoNYP4cstW8Dk0eXjFqT7Jx1ch3Kp9VG7YHBd8N0pzN4X5CNAYoM44KTswLyUKUCZRciFus9ZSOdzcXP9IzJPPOsRTmI3Ik3jKdtsEAB63nkKeKpBC94zigYE9QXEaRVZOELr5CUVvPVQWWqjnRGY/hQwnPvYNTRBQ/o8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685867627; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=eXArTeMtajRJZgcIvygJEd3UMrFsbSRTNGeqgF3+G08=; 
	b=Ud9Wr0gh1LQ1H8fpG+Pop8dL3O5i77sXchuvDimITRkF7+0mFavfYX+hvjuOIpL9j1tEy62bXZB65PnAotNqUMQDYlV6nPTfpfd3M/JvEpNOeEV6VOb4+z48aSGjwp/y1Dm0I/TJhKk6L31UQ1cpANyMPEYGXOPwi6ah+pqbm2s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685867627;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=eXArTeMtajRJZgcIvygJEd3UMrFsbSRTNGeqgF3+G08=;
	b=Lkc9JOkNAPSzz1pr6j8GRIyBBA49zNH5D6tfCFG9aUYELYY19nqYvEja20xMqUaG
	MLRnikrd7GoSGd3lq+gUcccxCoIWj5oY0lH7O50tpPtTYy9qAnYg6GRg4eQ0pyAdIbN
	afNLmH0o1DWowFk/dmO8CYy4DwKJaqaFcATYQ+M8=
Received: from [192.168.66.198] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1685867627229424.1337302219724; Sun, 4 Jun 2023 01:33:47 -0700 (PDT)
Message-ID: <7d07e930-56a7-3517-c560-c10291dbe92e@arinc9.com>
Date: Sun, 4 Jun 2023 11:33:30 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 26/30] net: dsa: mt7530: properly set
 MT7530_CPU_PORT
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
 <20230522121532.86610-27-arinc.unal@arinc9.com>
 <20230522121532.86610-27-arinc.unal@arinc9.com>
 <20230526165548.d6ewov743orxviz3@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230526165548.d6ewov743orxviz3@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26.05.2023 19:55, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:28PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The MT7530_CPU_PORT bits represent the CPU port to trap frames to for the
>> MT7530 switch. There are two issues with the current way of setting these
>> bits. ID_MT7530 which is for the standalone MT7530 switch is not included.
> 
> It's best to say in the commit title what the change does, rather than
> the equivalent of "here, this way is proper!". Commit titles should be
> uniquely identifiable, and "properly set MT7530_CPU_PORT" doesn't say a
> lot about how proper it is. It's enough to imagine a future person
> finding something else that's perfectible and writing another "net: dsa:
> mt7530: properly set MT7530_CPU_PORT" commit. Try to be less definitive
> and at the same time more specific.
> 
> If there are 2 issues, there should be 2 changes with individual titles
> which each describes what was wrong and how that was changed.

Got it, this is a bug fix for future devicetrees so I will send a 
2-patch patch series to net. First one sets the MT7530_CPU_PORT bit to 
the active CPU port, the other adds the ID_MT7530 check.

> 
>> When multiple CPU ports are being used, the trapped frames won't be
>> received when the DSA conduit interface, which the frames are supposed to
>> be trapped to, is down because it's not affine to any user port. This
>> requires the DSA conduit interface to be manually set up for the trapped
>> frames to be received.
>>
>> Address these issues by implementing ds->ops->master_state_change() on this
>> subdriver and setting the MT7530_CPU_PORT bits there. Introduce the
>> active_cpu_ports field to store the information of active CPU ports.
>> Correct the macros, MT7530_CPU_PORT is bits 4 through 6 of the register.
>>
>> Any frames set for trapping to CPU port will be trapped to the numerically
>> smallest CPU port which is affine to the DSA conduit interface that is set
>> up. To make the understatement obvious, the frames won't necessarily be
>> trapped to the CPU port the user port, which these frames are received
>> from, is affine to. This operation is only there to make sure the trapped
>> frames always reach the CPU.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Co-developed-by: Vladimir Oltean <olteanv@gmail.com>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> 
> A single Suggested-by: is fine. As a rule of thumb, I would use Co-developed-by
> when I'm working with a patch formally pre-formatted or committed by somebody else,
> that I've changed in a significant manner. Since all I did was to comment with
> a suggestion of how to handle this, and with a code snippet written in the email
> client to a patch of yours, I don't believe that's necessary here.

Will do, thanks.

Arınç

