Return-Path: <netdev+bounces-11815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BAC734825
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 22:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E72501C208B5
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88963A952;
	Sun, 18 Jun 2023 20:28:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE4E3D74
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 20:28:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5891F7
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Nu9onYHpQbQ8D0cRj/220kWyfi4mPuPOFOyJ5eTN+vo=; b=2TmMaXWMS3aRWlzSGdkdqLVMdW
	R3s+022Neq3iRHRkBynBtwGL0Z2IW4zhfJxbXkS7R3PSy62accNV/bMIf0v8kphUWWB9XERBD+Igg
	zmKwAUzsmp03G82FqCxHvWyzMS3iS7e/gZMST4wbdSLm3hHoge9j5zlotwVRs4w68Q78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAz0a-00GrZl-SZ; Sun, 18 Jun 2023 22:28:24 +0200
Date: Sun, 18 Jun 2023 22:28:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: netdev <netdev@vger.kernel.org>, ansuelsmth@gmail.com,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 3/3] net: phy: marvell: Add support for
 offloading LED blinking
Message-ID: <d48ac5aa-c420-4d7d-97fe-e890bb8d9604@lunn.ch>
References: <20230618173937.4016322-1-andrew@lunn.ch>
 <20230618173937.4016322-3-andrew@lunn.ch>
 <ZI9X4Qe2iHc2q6QH@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZI9X4Qe2iHc2q6QH@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Hi Andrew,
> 
> What is the effect of this patch when LEDs are configured via the
> existing DT property that allows arbitary register writes in this
> driver?
> 
> There are a number of DTs that configure the LEDs this way, and
> I don't think we would wish to regress that established configuration.

These patches only do anything if there is an LED subnode in the PHY
node in DT. So there should not be an changes by default.

If you have both 'marvell,reg-init' poking values into registers, and
describe the LEDs in DT, then i would expect some change in
behaviour. But no existing DT files do that.

	 Andrew

