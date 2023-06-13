Return-Path: <netdev+bounces-10456-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19A272E935
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 372AA281013
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ED830B66;
	Tue, 13 Jun 2023 17:17:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A7A33E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:17:54 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F211721;
	Tue, 13 Jun 2023 10:17:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686676631; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gJxyZRLWD4NEl61gqVvN2lIfwlk/b7+kmWYt9mavIXZNAacZgCz58hAqyazjZ7GGeo17941q76PNu1MAq8WfhO1cI1rFrv+XjVCdngJKnhPgSaEjIvX9YvywQGJGlMLnEqeWrcCb2ss4WmB0vJQNdM1NsG5c2tEBKOi0YI3TYNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686676631; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=UKSb0ThZcnVNrqrSeSS4LEbZcnEV/yq3xqSOWPk24oE=; 
	b=edPcE07xNz5ZvQ6emtagoSRyB9OQsSfTjvUuaVBJtxTWKt4aZQWTYP7lhA4E5DY49JhzPIzpnnwF5Vlbjo///gFeWe7vSDL+T3y+JiikESP4LTF5QiOhcDaOA9BYqX6pq6iWFqRNPxIcYcKCe2Z1kUmL6sNQCIkFoznhUmkOtXQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686676631;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=UKSb0ThZcnVNrqrSeSS4LEbZcnEV/yq3xqSOWPk24oE=;
	b=IZfOyOQol/sZZsLldaT9J02YcIrVE5+kTwhPF0q23W8i3v/OoJUmPTV8uy79ipiM
	lMSkPAJHeoYYU/JeUR9ydr7Qo4DfFvDTOgc06mMBg9DxYuE96+rPccgBBBWcQS2ZxlM
	U4brMNIUNegE6x7Y8/kcFM1IwhgLTc18LeC72IWc=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 168667662928564.21626010639807; Tue, 13 Jun 2023 10:17:09 -0700 (PDT)
Message-ID: <e64e21a2-aaac-a5f7-65db-f5f41d36cca5@arinc9.com>
Date: Tue, 13 Jun 2023 20:16:59 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Content-Language: en-US
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
 <20230612075945.16330-3-arinc.unal@arinc9.com>
 <ZIeJmF2eVi5nCLIU@shell.armlinux.org.uk>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZIeJmF2eVi5nCLIU@shell.armlinux.org.uk>
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

On 13.06.2023 00:09, Russell King (Oracle) wrote:
> On Mon, Jun 12, 2023 at 10:59:40AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The CPU_PORT bits represent the CPU port to trap frames to for the MT7530
>> switch. This switch traps frames received from a user port to the CPU port
>> set on the CPU_PORT bits, regardless of the affinity of the user port from
>> which the frames are received.
> 
> I think:
> 
> "On the MT7530, the CPU_PORT() field indicates which CPU port to trap
> frames to, regardless of the affinity of the inbound user port."
> 
> covers everything necessary in the first paragraph? Sorry to be a pain
> about this, but commit logs should be understandable.

Sounds good to me.

> 
>> When multiple CPU ports are being used, the trapped frames won't be
>> received when the DSA conduit interface, which the frames are supposed to
>> be trapped to, is down because it's not affine to any user port. This
>> requires the DSA conduit interface to be manually set up for the trapped
>> frames to be received.
> 
> "When multiple CPU ports are in use, if the DSA conduit interface is
> down, trapped frames won't be passed to the conduit interface."

Ok.

> 
>> To fix this, implement ds->ops->master_state_change() on this subdriver and
>> set the CPU_PORT bits to the CPU port which the DSA conduit interface its
> 
> ... "to the first CPU port" - isn't that what the code is doing with
> __ffs(priv->active_cpu_ports)? You're giving priority to the lowest
> numbered port, and I think that should be stated in the commit message.

Will do.

Arınç

