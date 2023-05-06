Return-Path: <netdev+bounces-663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8642C6F8D54
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 03:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEEB0281136
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 01:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DE910E7;
	Sat,  6 May 2023 01:05:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1CA10E6
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:05:15 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7685FD9
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=2VZscCelssuKDLnU3Fk/n5DrL42kCGA58csQs6YeA90=; b=2wikdlGGNR8ZOwGNRKj+ou1mPw
	kXCrdkt6S3cCuhh4FZ/tQLvjAX/lF91g5s8yoHO63j/1UacNGZcrwVbogSzZNkgGQdvTrS4eDwslF
	z4fU9783W+a7BrnBqUZWXjE1ZzBoKM5p7HYFLIJVixKu08DKLCtqxv1aifPd0siBu/04=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pv6MI-00C2XV-EH; Sat, 06 May 2023 03:05:10 +0200
Date: Sat, 6 May 2023 03:05:10 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lorenz Brun <lorenz@brun.one>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Quirks for exotic SFP module
Message-ID: <8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
 <CQF7UR.5191D6UPT6U8@brun.one>
 <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
 <DVN7UR.QEVJPHB8FG6I1@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DVN7UR.QEVJPHB8FG6I1@brun.one>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I tested and I got a bunch of addresses showing up on i2c master connected
> to the module. 1b, 30, 31, 34, 35, 36, 50 and 53. But I'm still not sure why
> we'd want to talk MDIO with this module. AFAIK MDIO is an Ethernet thing,
> the module is talking G.fast to the outside which is a completely different
> protocol from a completely different family of protocols. It has its own
> management protocol which runs over Ethernet.

One reason you might want to talk to the PHY is to correct is
configuration. 1000Base-X includes inband signalling. There are some
Copper SFP which have the inband signalling disabled. And that can
make the host unhappy, it fails to link up. It varies from host to
host. Some work, some don't.

> OT but my messages to Russell King cannot be delivered
> mx0.armlinux.org.uk: <lorenz@brun.one> is locally blocked. If this is
> incorrect, please contact the postmaster.
> 
> I haven't knowingly sent any messages to him before so I have no idea why
> I'd be blocked. My sender IP isn't on any public blacklist MultiRBL knows
> about. My DKIM/DMARC setup is also working.

Russell, what do your mail logs say?

	 Andrew

