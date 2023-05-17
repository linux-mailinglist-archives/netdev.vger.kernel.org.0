Return-Path: <netdev+bounces-3339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C64270682F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86D681C20F35
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A6131EE2;
	Wed, 17 May 2023 12:32:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA75D31120
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:32:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0456F10DA;
	Wed, 17 May 2023 05:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=d9Jyhk81zn7WltFy5aQXb+UcMGaz+x/ng/IdaUhmVLs=; b=ZhPWGvqOzM8ULB/L4Cl8lFdgzs
	6cdLPiVigOP3Z5UQa4kwgLMwInf2GiCiBKnZOHOKDYNrJDan2Tj2l5LjGLMnnR2fpGaT9B37rjSTv
	WACOhbywCgCEyneTr2aGA4+vUkUh8MSry8fwMPOEfwRQitRvNvYIi2o2qgUfPIGr1GFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzGKH-00D8MZ-Un; Wed, 17 May 2023 14:32:17 +0200
Date: Wed, 17 May 2023 14:32:17 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <doug.berger@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: broadcom: Register dummy IRQ handler
Message-ID: <e6817987-f788-4567-8406-c257f3b81caf@lunn.ch>
References: <20230516225640.2858994-1-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516225640.2858994-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 03:56:39PM -0700, Florian Fainelli wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> In order to have our interrupt descriptor fully setup, and in particular
> the action, ensure that we register a full fledged interrupt handler.
> This is in particular necessary for the kernel to properly manage early
> wake-up scenarios and arm the wake-up interrupt, otherwise there would
> be risks of missing the interrupt and leaving it in a state where it
> would not be handled correctly at all, including for wake-up purposes.

Hi Florian

I've not seen any other driver do this. Maybe that is just my
ignorance.

Please could you Cc: the interrupt and power management
Maintainers. This seems like a generic problem, and should have a
generic solution.

In the setup which needs this, does the output from the PHY go to a
PMIC, not a SoC interrupt? And i assume the PMIC is not interrupt
capable?

	Andrew

