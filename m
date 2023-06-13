Return-Path: <netdev+bounces-10483-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0BF972EB3B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 954FC2811AB
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D241ED40;
	Tue, 13 Jun 2023 18:47:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5A17FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:47:38 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1908B1BDC;
	Tue, 13 Jun 2023 11:47:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686682012; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KEL7Jb5YQjmVNbB+D900PtJR3A+dy4BT/QAT7b+GjimFtPHIuXfyTgv5NIm7gxutV4x5vQKgLZUlfNBoZDEgqOcWZK/vTUosd3A+8lYkwIImMuYBVaFwATP9hZDKYc7ch1ijYGmpmTsBeejFecmqKTwKUAukLBzWl5lE4fgyb4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686682012; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=uiH7vYDdKBG27kF+I7dWBVGcjs92hl+Mhg5MODORnKY=; 
	b=WKNTsifaIG1pf29yatyQwfndRDtajYaqWJ3EJRYt0Lhxyc4m4rpelsHbFf/0vc46mHj+p4jUbX8eMt7hYiyuCeC2NNSwNFawMVD0+Um9CgwciA4owJTQh+XsJowreTyMDAe1HKr4k2VWX8ComO1u0yNbuSsWCwumT29hivI94Cg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686682012;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=uiH7vYDdKBG27kF+I7dWBVGcjs92hl+Mhg5MODORnKY=;
	b=HOq2vlqPgyUjt/haud1M/WXgc3cXGYtuMUBbyuZ1eO9umcu3CXRghUxBJLvoy7z9
	cEZMQhrDwualnycWhgKqyJxNDdEmw1lr+DLY3UJMloKpv3rCBPeLgIFd0kC4hlBsbxd
	BGxGoCCMmYQMecukmywbZftEx6PcLWCcbTW4TCIA=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686682011978174.9268291902241; Tue, 13 Jun 2023 11:46:51 -0700 (PDT)
Message-ID: <c838ed22-8bc0-9f99-ee9f-4f8dbaabb99a@arinc9.com>
Date: Tue, 13 Jun 2023 21:46:42 +0300
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
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Vladimir Oltean <olteanv@gmail.com>, Daniel Golle
 <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
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
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <ZIi1fixnNqj9Gfcg@shell.armlinux.org.uk>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZIi1fixnNqj9Gfcg@shell.armlinux.org.uk>
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

On 13.06.2023 21:29, Russell King (Oracle) wrote:
> On Tue, Jun 13, 2023 at 08:58:33PM +0300, Arınç ÜNAL wrote:
>> On 13.06.2023 20:39, Vladimir Oltean wrote:
>>> On Tue, Jun 13, 2023 at 08:30:28PM +0300, Arınç ÜNAL wrote:
>>>> That fixes port 5 on certain variants of the MT7530 switch, as it was
>>>> already working on the other variants, which, in conclusion, fixes port 5 on
>>>> all MT7530 variants.
>>>
>>> Ok. I didn't pay enough attention to the commit message.
>>>
>>>> And no, trapping works. Having only CPU port 5 defined on the devicetree
>>>> will cause the CPU_PORT bits to be set to port 5. There's only a problem
>>>> when multiple CPU ports are defined.
>>>
>>> Got it. Then this is really not a problem, and the commit message frames
>>> it incorrectly.
>>
>> Actually this patch fixes the issue it describes. At the state of this
>> patch, when multiple CPU ports are defined, port 5 is the active CPU port,
>> CPU_PORT bits are set to port 6.
> 
> Maybe it's just me being dumb, but I keep finding things difficult to
> understand, such as the above paragraph.
> 
> It sounds like you're saying that _before_ this patch, port 5 is the
> active CPU port, but the CPU_PORT *FIELD* NOT BITS are set such that
> port 6 is the active CPU port. Therefore, things are broken, and this
> patch fixes it.

Yes, CPU_PORT field, and yes this patch fixes the issue by setting the 
field to 5 when multiple CPU ports are used. Because before this patch, 
the active CPU port is 5. The CPU_PORT field must match this.

> 
> Or are you saying that after this patch is applied, port 5 is the
> active CPU port, but the CPU_PORT *FIELD* is set to port 6. If that's
> true, then I've no idea what the hell is going on here because it
> seems to be senseless.

No, when the "prefer port 6" patch is applied, the active CPU port will 
be port 6.

The CPU_PORT field will always be set to 6, regardless of "net: dsa: 
mt7530: fix trapping frames with multiple CPU ports on MT7530". 
Therefore, the "prefer port 6" patch makes "net: dsa: mt7530: fix 
trapping frames with multiple CPU ports on MT7530" redundant.

"net: dsa: mt7530: fix trapping frames with multiple CPU ports on 
MT7530" becomes important after the changing the DSA conduit support is 
introduced.

> 
> I think at this point I just give up trying to understand what the
> hell these patches are trying to do - in my opinion, the commit
> messages are worded attrociously and incomprehensively.

If that's how you feel, you can tune in to v5 where I will address the 
patch logs.

Arınç

