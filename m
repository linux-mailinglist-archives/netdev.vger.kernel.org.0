Return-Path: <netdev+bounces-6381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4187160AB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAA011C20BED
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658AD19E5F;
	Tue, 30 May 2023 12:56:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2A5134C8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:56:08 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FD0116;
	Tue, 30 May 2023 05:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=64mK1OFe4COwzCMhVQzo8IqxnAghr5xj5oLavsN+gKE=; b=ps0Jpq5zIVKU0r+7buVHk6F1aW
	hZz075udJuzE5LaIUrotew7YmMl1daG3V5pCSGzA0SaaagB129AuEqNa3pg48otK6yibizZNcHsex
	HsGmFdTxJ/wvyBiZxpwqu9sqn01b1UFkrqXV3LGRbhIGl+rv5jJAC3l9wIP4k0gSwC54=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3yrg-00EKHq-2y; Tue, 30 May 2023 14:54:16 +0200
Date: Tue, 30 May 2023 14:54:16 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 00/13] leds: introduce new LED hw control APIs
Message-ID: <7e5d1ed6-3fd7-4110-8171-9efd19b59023@lunn.ch>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
 <20230529221722.549dfbd8@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529221722.549dfbd8@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 10:17:22PM -0700, Jakub Kicinski wrote:
> On Mon, 29 May 2023 18:32:30 +0200 Christian Marangi wrote:
> > Since this series is cross subsystem between LED and netdev,
> > a stable branch was created to facilitate merging process.
> > 
> > This is based on top of branch ib-leds-netdev-v6.5 present here [1]
> > and rebased on top of net-next since the LED stable branch got merged.
> > 
> > This is a continue of [2]. It was decided to take a more gradual
> > approach to implement LEDs support for switch and phy starting with
> > basic support and then implementing the hw control part when we have all
> > the prereq done.
> > 
> > This is the main part of the series, the one that actually implement the
> > hw control API.
> 
> Just to be 100% sure - these go into netdev/net-next directly, right?
> No stable branch needed?

From Christian and my side, yes. Ideally with Acked-by from Lee. We
have more patches to come, and we will just stack them on top in
net-next. The majority of those patches are for network drivers, not
the LED subsystem.

If there are going to be any merge conflicts, they will be to the core
LED header files. And such conflicts should be simple to resolve in
linux-next. If anybody else starts hacking on ledtrig-netdev.c then we
have problems, especially if it is an LED wide change. I don't know
how easy it is to create a stable branch from net-next, which could be
pulled into led-next, without it actually pulling in a huge number of
networking patches?

Lee?

	Andrew


