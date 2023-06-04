Return-Path: <netdev+bounces-7770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3793721740
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C74C81C20A29
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1AFA95E;
	Sun,  4 Jun 2023 13:15:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8E423C6
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:15:31 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FFDB8;
	Sun,  4 Jun 2023 06:15:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685884484; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Jje0df8P4zbwlbDhGie+2XTBnM9Bx4U05TGMcsKUwz2F4tc2lfStfjc/kX6wky73w6yKQ0Ji1uG06ii8G+R1BmIbbmlNpTO+ZbshQnoQh2Wvm1CDK1FQuA4iggXMY11G7gxn87EgYqsO6YiYD3qyiT3v0PvzhiNlc+q1oTveytE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685884484; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=XxFo49ybuTfpddZUtYJZ63iLTBCwDcOWVYL/S1IUMQ8=; 
	b=ARbYLyMiA8dwgD+TSdxlbknWg2VBsHzu1jV8/jy9brYlxVeUWCIAogM8t5DFlMzAt3FNddMRpYlRXhP19nJbKWEC2WwmocrQYIAs8Kgaw0L5x5j8xTYYYipcguK2yl/mwITtf7nDs9TngZ3Y6pq4Mmm8pPFwuOM/kww8QBuKfB8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685884484;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XxFo49ybuTfpddZUtYJZ63iLTBCwDcOWVYL/S1IUMQ8=;
	b=hViB5voarrFviGYMJtj9R5ESpxU31WVKAvV8CNmBjxUKHuaAwPpnHWy7Ryogqr6S
	IbUzck8jaTvVfe6p3a4qoSs1tE5vjjAMVLHtlOUtvwb41OUtnwna1abkemGM9hf5zv8
	wKOb8YTBgvDgdxmhcI6XIxQgGTTj2o+9CJMGYc8M=
Received: from [192.168.99.249] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1685884483411181.65403632363302; Sun, 4 Jun 2023 06:14:43 -0700 (PDT)
Message-ID: <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
Date: Sun, 4 Jun 2023 16:14:31 +0300
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
To: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Vladimir Oltean <olteanv@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230524175107.hwzygo7p4l4rvawj@skbuf>
 <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
 <20230526130145.7wg75yoe6ut4na7g@skbuf>
 <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
 <ZHsxdQZLkP/+5TF0@shell.armlinux.org.uk>
 <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
 <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
 <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 4.06.2023 16:07, Russell King (Oracle) wrote:
> On Sun, Jun 04, 2023 at 03:55:17PM +0300, Vladimir Oltean wrote:
>> On Sun, Jun 04, 2023 at 01:18:04PM +0100, Russell King (Oracle) wrote:
>>> I don't remember whether Vladimir's firmware validator will fail for
>>> mt753x if CPU ports are not fully described, but that would be well
>>> worth checking. If it does, then we can be confident that phylink
>>> will always be used, and those bypassing calls should not be necessary.
>>
>> It does, I've just retested this:
>>
>> [    8.469152] mscc_felix 0000:00:00.5: OF node /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 of CPU port 4 lacks the required "phy-handle", "fixed-link" or "managed" properties
>> [    8.494571] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register DSA switch
>> [    8.502151] mscc_felix: probe of 0000:00:00.5 failed with error -22
> 
> ... which isn't listed in dsa_switches_apply_workarounds[], and
> neither is mt753x. Thanks.
> 
> So, that should be sufficient to know that the CPU port will always
> properly described, and thus bypassing phylink in mt753x for the CPU
> port should not be necessary.

Perfect! If I understand correctly, there's this code - specific to 
MT7531 and MT7988 ports being used as CPU ports - which runs in addition 
to what's in mt753x_phylink_mac_config():

	mt7530_write(priv, MT7530_PMCR_P(port),
		     PMCR_CPU_PORT_SETTING(priv->id));

This should be put on mt753x_phylink_mac_config(), under priv->id == 
ID_MT7531, priv->id == ID_MT7988, and dsa_is_cpu_port(ds, port) checks?

Arınç

