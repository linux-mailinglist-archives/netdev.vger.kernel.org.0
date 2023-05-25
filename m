Return-Path: <netdev+bounces-5237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6269D7105A1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC966281476
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2C5A932;
	Thu, 25 May 2023 06:21:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9D88477
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:21:09 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99587139;
	Wed, 24 May 2023 23:21:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684995622; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PMYlw8HNIORs6O71agJRG6kN/o5Gdaqc/Q6WI0OGFxBB084gH7qPo8ZYJsksMRIbOdhqNIBZmci9WTTEjB8yd/oNBxzkAGA2ihoR5jKXn7FDW71ffEzlNS+bGsqtdFKbyJGUcuUuz2aAdW66/+G+V2tnkfmeRBXAEqoIiGuimrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684995622; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=T+zgrtDe2vx2LT7iA9VVOVQz2rx8LBh9zMLhK+oLZuk=; 
	b=SpbduvPkD1iSXDEfwNu4KjEG9HT4f3PLSf4TW7+iEysPbiEykWDFmPuShumcaIeerwIDPlPCOu3MKZ/V5HJcLiRd55JnuvNxZSx2r5VhPsVMNfuhr2JDPYKY0PDKzHAWy7B+8iiNkF4ZZl6Ct3YqqJoe5gHkf0ZD/CxwzRzT8nk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684995622;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=T+zgrtDe2vx2LT7iA9VVOVQz2rx8LBh9zMLhK+oLZuk=;
	b=B69arnkMEs140Qlr+wkfQzzcENArNjqdJD3UAmCxEVoVh/GqGbY95tp3A/hzfsVX
	Sjn/3b82zGorWrZYT1FAV5RYjz/wvOTS0q982mpQsRWCbdFag9P4uuPSp9fitGp43w/
	tg587m02KXk+DqzGLykcXha07Tu2XxgchBLE0NIU=
Received: from [10.10.10.217] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684995620524912.9368149177582; Wed, 24 May 2023 23:20:20 -0700 (PDT)
Message-ID: <7c915d5b-56c9-430d-05ac-544f76966eb1@arinc9.com>
Date: Thu, 25 May 2023 09:20:08 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 05/30] net: dsa: mt7530: read XTAL value from
 correct register
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
 <20230522121532.86610-6-arinc.unal@arinc9.com>
 <20230524165701.pbrcs4e74juzb4r3@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230524165701.pbrcs4e74juzb4r3@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24.05.2023 19:57, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:07PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> On commit 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
>> macros for reading the crystal frequency were added under the MT7530_HWTRAP
>> register. However, the value given to the xtal variable on
>> mt7530_pad_clk_setup() is read from the MT7530_MHWTRAP register instead.
>>
>> Although the document MT7621 Giga Switch Programming Guide v0.3 states that
>> the value can be read from both registers, use the register where the
>> macros were defined under.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> I'm sorry, but I refuse this patch, mainly as a matter of principle -
> because that's just not how we do things, and you need to understand why.
> 
> The commit title ("read XTAL value from correct register") claims that
> the process of reading a field which cannot be changed by software is
> any more correct when it is read from HWTRAP rather than MHWTRAP
> (modified HWTRAP).
> 
> Your justification is that it's confusing to you if two registers have
> the same layout, and the driver has a single set of macros to decode the
> fields from both. You seem to think it's somehow not correct to decode
> fields from the MHWTRAP register using macros which have just HWTRAP in
> the name.

No, it doesn't confuse me that two registers share the same layout. My 
understanding was that the MHWTRAP register should be used for modifying 
the hardware trap, and the HWTRAP register should be used for reading 
from the hardware trap. I see that the XTAL constants were defined under 
the HWTRAP register so I thought it would make sense to change the code 
to read the XTAL values from the HWTRAP register instead. Let me know if 
you disagree with this.

> 
> While in this very particular case there should be no negative effect
> caused by the change (*because* XTAL_FSEL is read-only), your approach
> absolutely does not scale to the other situations that you will be faced
> with.
> 
> If it was any other r/w field from HWTRAP vs MHWTRAP, you would have
> needed to get used to that coding pattern (or do something about the
> coding pattern itself), and not just decide to change the register to
> what you think is correct - which is a *behavior* change and not just
> a *coding style* change. You don't change the *behavior* when you don't
> like the *coding style* !!! because that's not a punctual fix to your
> problem.
> 
> I'm sorry that it is like this, but you can't expect the Linux kernel to
> be written for the level of understanding of a beginner C programmer.
> It's simply too hard for everyone to change, and much easier, and more
> beneficial overall, for you to change.
> 
> I understand that you're poking sticks at everything in order to become
> more familiar with the driver. That's perfectly normal and fine. But not
> everything that comes as a result of that is of value for sharing back
> to the mainline kernel's mailing lists.

Makes sense.

> 
> Seriously, please first share these small rewrites with someone more
> senior than you, and ask for a preliminary second opinion.

Would submitting this as an RFC had been a similar action to your 
describing here? Because I already did that:

https://lore.kernel.org/netdev/20230421143648.87889-6-arinc.unal@arinc9.com/

> 
> As they say, "on the Internet, nobody knows you're a dog". If reviewers
> don't take into account that you're a newbie with C (which is a badge
> that you don't carry everywhere - because you don't have to), it's easy
> for patches like this (and most of this series) to come across as:
> "I have no consideration for the fact that the existing code works, and
> the way in which it works, I'm just gonna rewrite all of it according to
> my own sensibilities and subjective justifications, and throw baseless
> words at it such as: fix this, correct that, when in fact all I'm doing
> is make silly changes with no effect to the observable behavior".
> 
> Because I know that the above isn't the case, I try to be as polite as
> possible expressing my frustration that I am looking at a large volume
> of worthless and misguided refactoring.

I should've given more effort to explain my reasons for this patch. I 
disagree that the series is a large volume of worthless and misguided 
refactoring and am happy to discuss it patch by patch.

Arınç

