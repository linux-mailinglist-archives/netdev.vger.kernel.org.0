Return-Path: <netdev+bounces-637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5ACF6F8B14
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62EE3281071
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2565CD524;
	Fri,  5 May 2023 21:30:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1989DBE73
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:30:29 +0000 (UTC)
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA90BDF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 14:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:References:In-Reply-To:Message-Id:Cc:To:Subject:From:
	Date:From:To:Subject:Date:Message-ID:Reply-To;
	bh=xBEnvuZboEejFcZNrXYVgb3rwZNE8nAdhtJqx4L608M=; b=dNP8wrH08POO4isNItLMVguXzj
	UjQrY3aJTacREaqvmKUj2tsuh1JEsCb3Tt8gD27Xc/jLj61PKTk8HEhRqzs+keGcYXmnQZB5KZk2P
	VHH3FV3kn00SGaKSaWdQm6UPex+/ifzedMZVTAvQNH0IZadl3cMDa17kxGlLRS5jfnzws5AsPBbWP
	YyzP1jWaf8X4kCtSFUQvS0xKE8REa+Kelav4wEr32OA8BZIvWyJyaBPjfjh5UxOf/886m9v+Ym3PW
	U3d3bYlUD7637qKhIW/C1OaHkCH1wLps0dXcNBuyblMZLs7Sy4b9OrV06MCFeIHI+qYZmDiet1qaw
	k18rn+sw==;
Received: from [212.51.153.89] (helo=[192.168.12.232])
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1pv30M-000aJk-1J;
	Fri, 05 May 2023 21:30:18 +0000
Date: Fri, 05 May 2023 23:30:12 +0200
From: Lorenz Brun <lorenz@brun.one>
Subject: Re: Quirks for exotic SFP module
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Message-Id: <CQF7UR.5191D6UPT6U8@brun.one>
In-Reply-To: <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
	<7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: lorenz@dolansoft.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net




Am Fr, 5. Mai 2023 um 20:53:43 +02:00:00 schrieb Andrew Lunn 
<andrew@lunn.ch>:
> On Fri, May 05, 2023 at 07:39:12PM +0200, Lorenz Brun wrote:
>>  Hi netdev members,
> 
> For SFP matters, please Cc: SFP maintainer, and the PHY
> maintainers. See the MAINTAINERS file.
Thanks, I'll check that next time.

> 
>>  I have some SFP modules which contain a G.fast modem (Metanoia 
>> MT5321). In
>>  my case I have ones without built-in flash, which means that they 
>> come up in
>>  bootloader mode. Their EEPROM is emulated by the onboard CPU/DSP 
>> and is
>>  pretty much completely incorrect, the claimed checksum is 0x00. 
>> Luckily
>>  there seems to be valid vendor and part number information to quirk 
>> off of.
> 
> It is amazing how many SFP manufactures cannot get the simple things
> like CRC right.
> 
>>  I've implemented a detection mechanism analogous to the Cotsworks 
>> one, which
>>  catches my modules. Since the bootloader is in ROM, we sadly cannot
>>  overwrite the bad data, so I just made it skip the CRC check if 
>> this is an
>>  affected device and the expected CRC is zero.
> 
> Sounds sensible. Probably pointless, because SFP manufactures don't
> seem to care about quality, but please do print an warning that the
> bad checksum is being ignored.
I'm doing that in my WIP patch already.

> 
>>  There is also the issue of the module advertising 1000BASE-T:
> 
> Probably something for Russell, but what should be advertised?
> 1000Base-X?
I'd have gone for 1000Base-X as well, but I'll let others weigh in. 
1000BASE-T is definitely wrong IMO as there is no twisted pair Ethernet 
layer anywhere (there is twisted pair, but it's G.fast). AFAIK 
1000Base-X should stop Linux from messing with anything as it does not 
have any non-EEPROM-based management, right?

> 
>>  But the module internally has an AR8033 1000BASE-X to RGMII 
>> converter which
>>  is then connected to the modem SoC, so as far as I am aware this is
>>  incorrect and could cause Linux to do things like autonegotiation 
>> which
>>  definitely does not work here.
> 
> Is there anything useful to be gained by talking to the PHY? Since it
> appears to be just a media converter, i guess the PHY having link is
> not useful. Does the LOS GPIO tell you about the G.Fast modem status?
AFAIK you cannot talk to the PHY as there isn't really an Ethernet PHY. 
The RGMII doesn't go to a PHY, it goes to the host interface which is a 
MAC of the modem SoC. Think of the modem SoC more of a computer then a 
plain modem.
While the SFP in its entirety behaves similar to a media converter the 
G.fast link is L2-agnostic and, even though it does in most cases carry 
Ethernet frames, any Ethernet managment interfaces (autoneg, ...) can't 
and shouldn't be extended to it.

I actually haven't checked the LOS GPIO. This thing runs ~1MiB of 
firmware and two different proprietary management protocols which I've 
reverse-engineered over which you can get tons of data about the 
current modem and link status. You need those to boot the SoC anyways. 
The TX disable GPIO puts the modem SoC into reset state and is used in 
case you use a host-based watchdog for the module.

Regards,
Lorenz



