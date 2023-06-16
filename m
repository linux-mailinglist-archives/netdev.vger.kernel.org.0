Return-Path: <netdev+bounces-11264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4AA732539
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6FD12815A7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B2562F;
	Fri, 16 Jun 2023 02:24:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E1A627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:24:49 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E753189;
	Thu, 15 Jun 2023 19:24:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686882253; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ThTbYxS+YkPBZVOICscx8Cx48gU+WWhlvd4G/Jpf+XvRHhA/9If8msSniYmRei6vBuumT1DOOZ0fqrNooYD1Yu2rSu+ttQtnXR3RPLPG3SoywGynOgE8sIjpZoHHbYFW54zY/Diljoq2PwxDVeUTTewXL9afGNd6vaKKO/2Z+/A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686882253; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=0Z05yeYX7+OqP7ZF+oetG3YrbAARu6gYGPG6HQXvMuU=; 
	b=RE/XsakSLfsKr0ZnKp/J0/orrwAqFf9HMVkmYp2DW9eyS1ChIqi1gFXmaOJROMPUzEP7qZM3G8pdq92z/tmVwP/hcXcmC9cvX/hgxxFRQbxadx6vg0nQeIR0bCTlhWZTYicUwBgOIvwkJ8/WZkkhzXm4fOK4Jh9g4AeBs61Gin4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686882253;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=0Z05yeYX7+OqP7ZF+oetG3YrbAARu6gYGPG6HQXvMuU=;
	b=ZRU2sMFtFpn2AXpGqdg2/rCSawjW15wo42Z/MjD3EFNCGvitJ7+cdlEKdwunRi1q
	IpKT53KajkvDaXkO5uaK3Qhh+BdRR3rwTG84dsJL5oA2FSxSBKqW4/162II1tBowpZl
	S+/p6dK6p8nbm7PcFU02jPdpCiwubpL+bFUfvcOQ=
Received: from [192.168.68.166] (athedsl-404045.home.otenet.gr [79.131.130.75]) by mx.zohomail.com
	with SMTPS id 168688225180832.64444677104484; Thu, 15 Jun 2023 19:24:11 -0700 (PDT)
Message-ID: <c7b0c22b-4132-4159-797b-c24e85b62d16@arinc9.com>
Date: Fri, 16 Jun 2023 05:24:05 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To: Bartel Eerdekens <bartel.eerdekens@constell8.be>,
 "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-6-arinc.unal@arinc9.com>
 <ZInt8mmrZ6tCGy1N@shell.armlinux.org.uk>
 <CABRLg09hXm3=mca70TdZLuxA1d8YzOcWj31NvFG0ZWoStn_w9Q@mail.gmail.com>
 <0d57c035-b6da-08be-8f47-0afb5ddfec58@arinc9.com>
In-Reply-To: <0d57c035-b6da-08be-8f47-0afb5ddfec58@arinc9.com>
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

On 16.06.2023 04:53, Arınç ÜNAL wrote:
> On 15.06.2023 15:45, Bartel Eerdekens wrote:
>> On Wed, Jun 14, 2023 at 6:42 PM Russell King (Oracle)
>> <linux@armlinux.org.uk> wrote:
>>>
>>> On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
>>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>
>>>> LLDP frames are link-local frames, therefore they must be trapped to 
>>>> the
>>>> CPU port. Currently, the MT753X switches treat LLDP frames as regular
>>>> multicast frames, therefore flooding them to user ports. To fix 
>>>> this, set
>>>> LLDP frames to be trapped to the CPU port(s).
>>>>
>>>> The mt753x_bpdu_port_fw enum is universally used for trapping frames,
>>>> therefore rename it and the values in it to mt753x_port_fw.
>>>>
>>>> For MT7530, LLDP frames received from a user port will be trapped to 
>>>> the
>>>> numerically smallest CPU port which is affine to the DSA conduit 
>>>> interface
>>>> that is up.
>>>>
>>>> For MT7531 and the switch on the MT7988 SoC, LLDP frames received 
>>>> from a
>>>> user port will be trapped to the CPU port that is affine to the user 
>>>> port
>>>> from which the frames are received.
>>>>
>>>> The bit for R0E_MANG_FR is 27. When set, the switch regards the 
>>>> frames with
>>>> :0E MAC DA as management (LLDP) frames. This bit is set to 1 after 
>>>> reset on
>>>> MT7530 and MT7531 according to the documents MT7620 Programming 
>>>> Guide v1.0
>>>> and MT7531 Reference Manual for Development Board v1.0, so there's 
>>>> no need
>>>> to deal with this bit. Since there's currently no public document 
>>>> for the
>>>> switch on the MT7988 SoC, I assume this is also the case for this 
>>>> switch.
>>>>
>>>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek 
>>>> MT7530 switch")
>>>
>>>
>>> Patch 4 claims to be a fix for this commit, and introduces one of these
>>> modifications to MT753X_BPC, which this patch then changes.
>>
>> Let me chime in on this one, as mentioned by Arinç, I am one of the
>> requesters of having this patch (and patch 4).
>> Patch 4 enables the trapping of BPDU's to the CPU, being STP (Spanning
>> Tree) frames. Maybe that should be mentioned, to be clear.
> 
> Sure, I can quote the first sentence on the wikipedia page "Bridge 
> protocol data unit".

I changed my mind. There's no reason to describe BPDUs. The familiar 
reader will know, the unfamiliar reader should just look it up. Like 
Vladimir said, context helps but at the same time, less is more.

Arınç

