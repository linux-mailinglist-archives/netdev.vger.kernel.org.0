Return-Path: <netdev+bounces-1961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17FE46FFBAA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E185C1C21077
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD2016403;
	Thu, 11 May 2023 21:06:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993312918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:06:52 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C080719AF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yYxGGqDp6A5mnrGXuYx6g5+Gf7ut9+2cTP5UOBlKIT8=; b=itwmzR0PH1YXtRRUZNIhsB8I1+
	gsyaXUXk2pgh6w33acaSHVDyopxSyMJdcBT0VGoEu0nVuDeCC8JJoAs7EsZprnGMDZQ9pZMQh/LdV
	b4g8yx28AQlVUCqPi1bSgZ746jJvB3ZDEw8inZFDUo4IatlkKSl/TJEU6UmExpneStlw+SD3AyEhj
	WAWcmroQOH+YQDuegaYmPVdu2Opd8hIAJd0OTR4YaW0qRhcoZeS0OxD+KryOhmh+yT1mUHgxyg5pU
	ou0G+AC0zKqM0WTW6zWd5hBWfneu64qlpp+2706qadLYD7Vf/WJfXZS5Ead+zokplnfUYjfgH1Izo
	AUWpaxeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41604)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxDUk-0007Gt-Hd; Thu, 11 May 2023 22:06:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxDUi-0004Lz-60; Thu, 11 May 2023 22:06:36 +0100
Date: Thu, 11 May 2023 22:06:36 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <ZF1Y3OurlvukFBs1@shell.armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230429175807.wf3zhjbpa4swupzc@skbuf>
 <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
 <20230511134807.v4u3ofn6jvgphqco@skbuf>
 <20230511083620.15203ebe@kernel.org>
 <20230511155640.3nqanqpczz5xwxae@skbuf>
 <20230511092539.5bbc7c6a@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511092539.5bbc7c6a@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 09:25:39AM -0700, Jakub Kicinski wrote:
> Yes, we don't want to lose the simplification benefit for the common
> cases. I think we should make the "please call me for PHY requests"
> an opt in.
> 
> Annoyingly the "please call me for PHY/all requests" needs to be
> separate from "this MAC driver supports PHY timestamps". Because in
> your example the switch driver may not in fact implement PHY stamping,
> it just wants to know about the configuration.
> 
> So we need a bit somewhere (in ops? in some other struct? in output 
> of get_ts?) to let the driver declare that it wants to see all TS
> requests. (I've been using bits in ops, IDK if people find that
> repulsive or neat :))

I haven't thought this through fully, but just putting this out there
as a potential suggestion...

Would it help at all if we distilled the entire timestamping interface
into a separate set of ops which are registered independently from the
NDO, and NDO has a call to get the ops for the layer being configured?

That would allow a netdev driver to return the ops appropriate for the
MAC layer or its own PHY layer, or maybe phylib.

In the case of phylib, as there is a raft of drivers that only bind to
their phylib PHY in the NDO open method, we'd need to figure out how
to get the ops for the current mode at that time.

There's probably lots I've missed though...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

