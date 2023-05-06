Return-Path: <netdev+bounces-655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A34CC6F8D25
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:26:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42A5F28110C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF80F19A;
	Sat,  6 May 2023 00:26:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3007E0
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:26:14 +0000 (UTC)
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE007289
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 17:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:References:In-Reply-To:Message-Id:Cc:To:Subject:From:
	Date:From:To:Subject:Date:Message-ID:Reply-To;
	bh=W1JiP4NLVMJZ5ynfyc1LUBY4qJvZ8I8s0GYRbsyKYKA=; b=gIUbT61pZH0RrgEndksrQ7PDG0
	Vm5pgisY9KbtndBDmKlsl4U8WBJCKE5pJ7u7WKTF9/As5GSF1NvTGR9pQcoeNseJsVdlalbugt3r9
	ZBVVp2XI+9A5tEQFf0IOAnAQR/1gd5wpd2BtU4pqLFO0n0dALgjj5ypAOQLdUXduMVIdCm8EsGC/x
	p8FGGAQEisi+O4mfGe5CBh7Mgmcsl8CD5SttFKSVEk9VVoI1GMknqF8T8YDhyV5bC5pgxsAxd+CIZ
	WxoFkYQ697akQq7po90uIGRDl3eeIC8TGLiXL3UbpA4jDjp4mPwGO3+ny8RiUKRprNjuxY3s0lcQ7
	JC4FU9hQ==;
Received: from [212.51.153.89] (helo=[192.168.12.232])
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1pv5kV-000aaA-1J;
	Sat, 06 May 2023 00:26:07 +0000
Date: Sat, 06 May 2023 02:26:01 +0200
From: Lorenz Brun <lorenz@brun.one>
Subject: Re: Quirks for exotic SFP module
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Message-Id: <DVN7UR.QEVJPHB8FG6I1@brun.one>
In-Reply-To: <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
	<7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
	<CQF7UR.5191D6UPT6U8@brun.one>
	<d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net




Am Sa, 6. Mai 2023 um 02:03:32 +02:00:00 schrieb Andrew Lunn 
<andrew@lunn.ch>:
>>  >
>>  > >  But the module internally has an AR8033 1000BASE-X to RGMII
>>  > > converter which
>>  > >  is then connected to the modem SoC, so as far as I am aware 
>> this is
>>  > >  incorrect and could cause Linux to do things like 
>> autonegotiation
>>  > > which
>>  > >  definitely does not work here.
>>  >
>>  > Is there anything useful to be gained by talking to the PHY? 
>> Since it
>>  > appears to be just a media converter, i guess the PHY having link 
>> is
>>  > not useful. Does the LOS GPIO tell you about the G.Fast modem 
>> status?
> 
>>  AFAIK you cannot talk to the PHY as there isn't really an Ethernet 
>> PHY.
> 
> So i2c-detect does not find anything other than at address 0x50?
> 
> Often the PHY can be access via an MDIO bus over I2C at some other
> address on the bus. The linux SFP code might be trying, even
> succeeding, in instantiating such a bus and finding the PHY. And then
> a PHY driver will be loaded to drive the PHY. This is how Copper SFP
> modules work. However, most Copper SFP use a Marvell PHY, not
> Atheros. And RollBall SFP use a different MDIO over i2c protocol.

I tested and I got a bunch of addresses showing up on i2c master 
connected to the module. 1b, 30, 31, 34, 35, 36, 50 and 53. But I'm 
still not sure why we'd want to talk MDIO with this module. AFAIK MDIO 
is an Ethernet thing, the module is talking G.fast to the outside which 
is a completely different protocol from a completely different family 
of protocols. It has its own management protocol which runs over 
Ethernet.

> 
>>  I actually haven't checked the LOS GPIO. This thing runs ~1MiB of 
>> firmware
>>  and two different proprietary management protocols which I've
>>  reverse-engineered over which you can get tons of data about the 
>> current
>>  modem and link status. You need those to boot the SoC anyways. The 
>> TX
>>  disable GPIO puts the modem SoC into reset state and is used in 
>> case you use
>>  a host-based watchdog for the module.
> 
> So i guess you are not passing the GPIO for TX disable in your DT
> blob. And maybe not LOS. If you do, it must be doing something
> sensible, because phylink does not allow the carrier to go up if LOS
> is active. Although the EEPROM can indicate LOS is not
> implemented. But that assumes the EEPROM contents are sane.

TX disable works, but in a quite drastic way by just putting the entire 
SoC into reset.
LOS is wired up, but I am currently not able to test its behavior.

> Russell King will be interested in a binary dump from ethtool -m.
The output of that command is already included in the top post.

OT but my messages to Russell King cannot be delivered
mx0.armlinux.org.uk: <lorenz@brun.one> is locally blocked. If this is 
incorrect, please contact the postmaster.

I haven't knowingly sent any messages to him before so I have no idea 
why I'd be blocked. My sender IP isn't on any public blacklist MultiRBL 
knows about. My DKIM/DMARC setup is also working.

Regards,
Lorenz
> 



