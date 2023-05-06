Return-Path: <netdev+bounces-664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D14526F8D6C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 03:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C586428114A
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 01:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EECE10EA;
	Sat,  6 May 2023 01:15:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901CA10E6
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:15:16 +0000 (UTC)
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324DF2688
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:References:In-Reply-To:Message-Id:Cc:To:Subject:From:
	Date:From:To:Subject:Date:Message-ID:Reply-To;
	bh=URoXoNLC5/ZoioacUDvP4w5F1qb1ezwOK73xGk96/fc=; b=LcOpyL1MWbBf7+064gI1UaR3Pv
	Hnl92Z3d2c/ia4R0zfEMhP/a5oQy2XKGD3J16BoPAL7oSi+8bbyBPRaKvSNi4z4/D87D9PraQcdzX
	E7ZkFGcG3i7y+FTEy9KXZrDA31HlZMFFur/wNaDOSPuk9F3a3MLTG0BCPmHKmIMB71XVzQfEr28W1
	51sgq4dmWStCQCdGzehuvVHc0GWIpIkeqXyULpfclkEQqImXVPjI29QagscO5IZUqb9Ru+CG2F+70
	X6+YhiGOHf5lJQcAARdp5ykEp1QDq7NQNRNKacLlHj/BkRlA9ZcfNcF2TjKZU4zN88VIkgGgvJfT7
	YWokDVWQ==;
Received: from [212.51.153.89] (helo=[192.168.12.232])
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1pv6W1-000acb-1J;
	Sat, 06 May 2023 01:15:13 +0000
Date: Sat, 06 May 2023 03:15:07 +0200
From: Lorenz Brun <lorenz@brun.one>
Subject: Re: Quirks for exotic SFP module
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Message-Id: <75Q7UR.PII4PI72J55K3@brun.one>
In-Reply-To: <8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
	<7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
	<CQF7UR.5191D6UPT6U8@brun.one>
	<d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
	<DVN7UR.QEVJPHB8FG6I1@brun.one>
	<8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
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

Am Sa, 6. Mai 2023 um 03:05:10 +02:00:00 schrieb Andrew Lunn 
<andrew@lunn.ch>:
>>  I tested and I got a bunch of addresses showing up on i2c master 
>> connected
>>  to the module. 1b, 30, 31, 34, 35, 36, 50 and 53. But I'm still not 
>> sure why
>>  we'd want to talk MDIO with this module. AFAIK MDIO is an Ethernet 
>> thing,
>>  the module is talking G.fast to the outside which is a completely 
>> different
>>  protocol from a completely different family of protocols. It has 
>> its own
>>  management protocol which runs over Ethernet.
> 
> One reason you might want to talk to the PHY is to correct is
> configuration. 1000Base-X includes inband signalling. There are some
> Copper SFP which have the inband signalling disabled. And that can
> make the host unhappy, it fails to link up. It varies from host to
> host. Some work, some don't.

Oh, so you're talking about signalling on the AR8033 <-> Linux Host 
part of the link. I actually wasn't aware that 1000Base-X did in-band 
signalling, TIL. Since the I2C bus is connected to the modem SoC it 
would have to forward any MDIO to the AR8033 transceiver, right? This 
would also be a bit weird as the AR8033 is connected "backwards", i.e. 
with RGMII facing towards the Modem SoC and 1000Base-X towards the 
Linux host.

Regards,
Lorenz



