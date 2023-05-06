Return-Path: <netdev+bounces-705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D29F6F9241
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 15:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 050BD281193
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 13:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A02B882B;
	Sat,  6 May 2023 13:35:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698301FAF
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 13:35:45 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C9722734
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 06:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=pmXhXkFYohPNeCWQuynNPFxN4xQZqTt6S8iWSJ62Jvc=; b=EDKTDyqEEWS+OpjNCZE805M/Z1
	uvM2VZnWOsFgDonBEspqOlZ0DYHvsdJPZaijbNMIEoSPeAM134x/AuAXRYEbzSxREMoZGqkGEnCga
	KfRDLUmDibXy+M9iInUcEqWZFkc10p155He56sU2+BP1gifaR1EpU+KEpxfKV5MoUS8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pvI4c-00C4FY-Fq; Sat, 06 May 2023 15:35:42 +0200
Date: Sat, 6 May 2023 15:35:42 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lorenz Brun <lorenz@brun.one>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Quirks for exotic SFP module
Message-ID: <561dff8e-8a12-4f99-86e2-b5cdc8632d4a@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
 <CQF7UR.5191D6UPT6U8@brun.one>
 <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
 <DVN7UR.QEVJPHB8FG6I1@brun.one>
 <8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
 <75Q7UR.PII4PI72J55K3@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75Q7UR.PII4PI72J55K3@brun.one>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Oh, so you're talking about signalling on the AR8033 <-> Linux Host part of
> the link. I actually wasn't aware that 1000Base-X did in-band signalling,
> TIL. Since the I2C bus is connected to the modem SoC it would have to
> forward any MDIO to the AR8033 transceiver, right? This would also be a bit
> weird as the AR8033 is connected "backwards", i.e. with RGMII facing towards
> the Modem SoC and 1000Base-X towards the Linux host.

I2C allows for there to be multiple devices on the bus. So a PHY which
supports I2C could be placed on the bus along side the SoC
implementing the modem.

However, Russell indicated that the Atheros PHY does not have native
I2C. So it is unlikely to be on the bus. This is probably why the
Marvell PHY is used a lot, not many PHYs do have I2C.

	Andrew

