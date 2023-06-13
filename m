Return-Path: <netdev+bounces-10471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4872472EA67
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F1FA1C20835
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06E53D387;
	Tue, 13 Jun 2023 17:59:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47563C0B2
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:59:24 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0349919B6;
	Tue, 13 Jun 2023 10:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686679125; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=E7lSMWkV7b5ODjNO7BK5WP5Ssg4jm20tHSnNq/e3F9lHXNxeIlmwoSoBR79du19K4HJBsz/NY7xLrBq4BY5Dv83G5zU/eXRcx/uWMTt0/w7o13+qeZNLlQz/0GWML34ZeLAXieAZH78br5N906djoyVXwz5Gc5/7zGDZw1XL4vE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686679125; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=WzrVqvh/dDTqDYcbmTwhWyO6VLQD1qgqToUYYDQ/RoE=; 
	b=DtJuxPts/TzNr9xeoUahNfThapMuO2eo2mUqa5Nmvt/jUvnYSp9o7C/ZPCJDg9B9ObR3/u6M2/AxlI4Sn48NaezK8RQtC4iMd+tjQ5W/yXOEhOFvFXZBleRxIUK2layNPRZ67qMxGRz7awboUPUlhb6qoOK+zBf+/ZzswG2/Vkk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686679125;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=WzrVqvh/dDTqDYcbmTwhWyO6VLQD1qgqToUYYDQ/RoE=;
	b=aE8QH8mAUu0WeIZHkrvypJMCH0MvzmPSDKBFMrxb7+q+Ug54uKZ6MC3vCEintK5O
	7Bua4EQOsHjCxOFzPoFOxf7ie5q8e5a9Vf6/eYTijXyUjvdx7jM4SA26lo4unyN+iCs
	cNQ5At/73sitHYeJmMULF4wy3WATlBZneo3L1IWM=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686679123743537.1638599900879; Tue, 13 Jun 2023 10:58:43 -0700 (PDT)
Message-ID: <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
Date: Tue, 13 Jun 2023 20:58:33 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
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
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230613173908.iuofbuvkanwyr7as@skbuf>
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

On 13.06.2023 20:39, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 08:30:28PM +0300, Arınç ÜNAL wrote:
>> That fixes port 5 on certain variants of the MT7530 switch, as it was
>> already working on the other variants, which, in conclusion, fixes port 5 on
>> all MT7530 variants.
> 
> Ok. I didn't pay enough attention to the commit message.
> 
>> And no, trapping works. Having only CPU port 5 defined on the devicetree
>> will cause the CPU_PORT bits to be set to port 5. There's only a problem
>> when multiple CPU ports are defined.
> 
> Got it. Then this is really not a problem, and the commit message frames
> it incorrectly.

Actually this patch fixes the issue it describes. At the state of this 
patch, when multiple CPU ports are defined, port 5 is the active CPU 
port, CPU_PORT bits are set to port 6.

Once "the patch that prefers port 6, I could easily find the exact name 
but your mail snipping makes it hard" is applied, this issue becomes 
redundant.

> 
>>> So how about settling on that as a more modest Fixes: tag, and
>>> explaining clearly in the commit message what's affected?
>>
>> I don't see anything to change in the patch log except addressing Russell's
>> comments.
> 
> Ok. I see Russell has commented on v4, though I don't see that he particularly
> pointed out that this fixes a problem which isn't yet a problem. I got lost in
> all the versions. v2 and v3 are out of my inbox now :)

All good, I had to quickly roll v3 as v2 had wrong author information 
and I couldn't risk getting v2 applied.

Arınç

