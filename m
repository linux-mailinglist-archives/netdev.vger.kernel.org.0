Return-Path: <netdev+bounces-10495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DBC372EB81
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEBFA28126D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352922A9D1;
	Tue, 13 Jun 2023 19:05:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A7D1ED49
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:05:00 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FF41721;
	Tue, 13 Jun 2023 12:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686683036; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YXjH8Hp6GiPPqOr9BmzuWiRGXaYXwG04v4JHck3+NkBNyrjZcu3w9X2llCQ2CKm1HKxdNEN9Q7NpmLAAolGYGGuw734ARxBgBMQq3gry4JicEyh94RdMqacv63ONtXx5omJDqjSbLdOWcLdtVkfAwk30Ptdo7aoCuE9wA/hwiUA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686683036; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=SzAqxLkMC4vpkZH2u8f1C/rpQPJMstHdNpojeB7TZMs=; 
	b=jYCHE1Pv9JQboLFV3wq2mgyP5ZMUixqjGXG0JJhjM7kNIqBlaGy6AACdR4AyRp8m6oDP60S2hxFUEPUEZpMANyFRSRaVF5tVHjovkwLK8muzwECUZYSLCmOjxqxeYDJPYKyKIQ6toPw8YixD+0oPDBnST+KLmAtbJTAZiltaS/Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686683036;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=SzAqxLkMC4vpkZH2u8f1C/rpQPJMstHdNpojeB7TZMs=;
	b=GLSs/6iiEbhuHIXTB3tNw+tiXHp1DwdF8dfmGhm7vs9VEAncIhA4v9aLimQ719xQ
	YCuW+Aqxvd3TSb0UtFCQopJCJr0YGXIHvsw1GiKtC4mXtiIcWdaOl5c9cHvVFTM7NfW
	a4CrA8BKYOkLGtlzZCUutwm6hqpNEAqRsfYWeJYI=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 16866830338181009.996857118617; Tue, 13 Jun 2023 12:03:53 -0700 (PDT)
Message-ID: <359d0825-e39a-8a12-ebbf-b8d7e941d1ef@arinc9.com>
Date: Tue, 13 Jun 2023 22:03:44 +0300
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
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vladimir Oltean <olteanv@gmail.com>, Daniel Golle
 <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
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
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <20230613111218.0e1b3e9f@kernel.org>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230613111218.0e1b3e9f@kernel.org>
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

On 13.06.2023 21:12, Jakub Kicinski wrote:
> On Tue, 13 Jun 2023 20:58:33 +0300 Arınç ÜNAL wrote:
>>> Ok. I see Russell has commented on v4, though I don't see that he particularly
>>> pointed out that this fixes a problem which isn't yet a problem. I got lost in
>>> all the versions. v2 and v3 are out of my inbox now :)
>>
>> All good, I had to quickly roll v3 as v2 had wrong author information
>> and I couldn't risk getting v2 applied.
> 
> FWIW you can reply with pw-bot: changes-requested to your own patches
> and the bot should discard them from patchwork.
> 
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#updating-patch-status
> 
> It's a new capability that nobody has used, yet, so YMMV :)

Interesting, I've got some questions regarding this.

> For example to mark a series as Changes Requested one needs to send the following line anywhere in the email thread:
> 
> pw-bot: changes-requested

I suppose a reply to the cover letter or under the cover letter thread 
applies?

> The use of the bot is restricted to authors of the patches (the From: header on patch submission and command must match!)

So, for example, if this patch series was new, Vladimir would reply to 
the patch they're the author of with 'pw-bot: changes-requested', and 
the patchworks would mark the whole patch series as changes requested?

Arınç

