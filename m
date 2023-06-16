Return-Path: <netdev+bounces-11260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B07F87324E7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D40B2815C2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852A662B;
	Fri, 16 Jun 2023 01:54:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E88627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:54:28 +0000 (UTC)
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA11AA;
	Thu, 15 Jun 2023 18:54:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686880419; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=m+nnBfugsNBznT7IutrdBGotmA+2gZJZusj3kV8dAdwgR58dJtKViavtiMrUaNhIN0g/4P+xi0/f3tx216Cr9LBhMrtUEtUXnutoLUWAqTPWf6SB9XIkOSleQUr6+hVCZfPEqyTxYsTgBQh9xt+CU3d3k6Et4vfNoCYXhfX7MCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686880419; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=5iC11FXcCYPbKNk31aFC8ArpZJL4rMW3qp7yEOxRpQ8=; 
	b=EpwBGrtHpG7E0eA/PSpEGMZ4bMtONx6/vJNDZ2ZCK/GQPfhZCqC0K7CbTvMC7m78sWzdalRWClsCBR9P6Ukt6YeClTbQKk9O1ArwNqHWKsIYNVwP5JLtw1dMQ2SeRNg1k1quDC50PA8iZcHlq3fiEEXEQyaK3G2RbRd7fahzM3s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686880419;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=5iC11FXcCYPbKNk31aFC8ArpZJL4rMW3qp7yEOxRpQ8=;
	b=HVK/JeR9CfAt2gOActnJdBtByysaM07nrkvskmhtqwC7oUnYgrtIoNd0D+jJBS7E
	+wZrnbZrh6JoR85q494XWwpbYs+S9TAvdi7smlpwovB6FzDKYaSPpMeIDhZgEVhdy1h
	3TMIHIJBWf7+SW+vCsQAVmNpQ7DvKBqyh9TjL47s=
Received: from [192.168.68.166] (athedsl-404045.home.otenet.gr [79.131.130.75]) by mx.zohomail.com
	with SMTPS id 1686880416484951.0122965686879; Thu, 15 Jun 2023 18:53:36 -0700 (PDT)
Message-ID: <0d57c035-b6da-08be-8f47-0afb5ddfec58@arinc9.com>
Date: Fri, 16 Jun 2023 04:53:29 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
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
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CABRLg09hXm3=mca70TdZLuxA1d8YzOcWj31NvFG0ZWoStn_w9Q@mail.gmail.com>
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

On 15.06.2023 15:45, Bartel Eerdekens wrote:
> On Wed, Jun 14, 2023 at 6:42 PM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
>>
>> On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>
>>> LLDP frames are link-local frames, therefore they must be trapped to the
>>> CPU port. Currently, the MT753X switches treat LLDP frames as regular
>>> multicast frames, therefore flooding them to user ports. To fix this, set
>>> LLDP frames to be trapped to the CPU port(s).
>>>
>>> The mt753x_bpdu_port_fw enum is universally used for trapping frames,
>>> therefore rename it and the values in it to mt753x_port_fw.
>>>
>>> For MT7530, LLDP frames received from a user port will be trapped to the
>>> numerically smallest CPU port which is affine to the DSA conduit interface
>>> that is up.
>>>
>>> For MT7531 and the switch on the MT7988 SoC, LLDP frames received from a
>>> user port will be trapped to the CPU port that is affine to the user port
>>> from which the frames are received.
>>>
>>> The bit for R0E_MANG_FR is 27. When set, the switch regards the frames with
>>> :0E MAC DA as management (LLDP) frames. This bit is set to 1 after reset on
>>> MT7530 and MT7531 according to the documents MT7620 Programming Guide v1.0
>>> and MT7531 Reference Manual for Development Board v1.0, so there's no need
>>> to deal with this bit. Since there's currently no public document for the
>>> switch on the MT7988 SoC, I assume this is also the case for this switch.
>>>
>>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
>>
>>
>> Patch 4 claims to be a fix for this commit, and introduces one of these
>> modifications to MT753X_BPC, which this patch then changes.
> 
> Let me chime in on this one, as mentioned by Arinç, I am one of the
> requesters of having this patch (and patch 4).
> Patch 4 enables the trapping of BPDU's to the CPU, being STP (Spanning
> Tree) frames. Maybe that should be mentioned, to be clear.

Sure, I can quote the first sentence on the wikipedia page "Bridge 
protocol data unit".

> 
>>
>> On the face of it, it seems this patch is actually a fix to patch 4 as
>> well as the original patch, so does that mean that patch 4 only half
>> fixes a problem?
> 
> This patch then also adds trapping for LLDP frames (Link Layer
> Discovery Protocol) which is a completely different protocol.
> But both rely on trapping frames, instead of forwarding them.

Flooding is a better term. "Trapped" frames are still forwarded, the 
difference is they are forwarded only to the CPU port.

Arınç

