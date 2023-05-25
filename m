Return-Path: <netdev+bounces-5257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72C9471071D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A84982814AA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08DEC8DF;
	Thu, 25 May 2023 08:16:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941861FB8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:16:13 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0E4122
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8AhKvPYDDe+OwfLxGgQDNwaPPycIR0LgME1YS5cozeQ=; b=HsBU8VhkE2R1TAJHxsFxwdtCA7
	T41hcWIrE1Zb0uT7d8OVtpULcJpnDofNMnR1Q05bzLM4JmZGFrCQLK4z/140SYMf3aY7XyFqxVDt0
	ehl6za+uC5XLQXXcvIw/Wd2bMaH1OZumfaqiQiJVyVar5TsirXyF5aYnTchw8jp+zX3IH0U65VFML
	DnQZeF9fz3owZwwJibOh50QMJl2TsAvfKoXA/1wuEaY7Tz0ay6s7V6SQgUtx6NkSYXDlsQXv7wBtS
	j0Fy1o5j7nIr/koAVB3pL/U96WS41nQz6ciEc6d64QQzz+hBe3C1KBq5HVAYK92ur60BYM33aGpPf
	6FWYG7Ew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40694)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q268T-0003ko-Aq; Thu, 25 May 2023 09:15:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q268O-0002Vn-2R; Thu, 25 May 2023 09:15:44 +0100
Date: Thu, 25 May 2023 09:15:44 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC 0/9] Add and use helper for PCS negotiation modes
Message-ID: <ZG8ZMO/HRFVFdOll@shell.armlinux.org.uk>
References: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
 <20230524072619.dnzfy3lmgobqmu2k@soft-dev3-1>
 <ZG3GZ59MUqATsKVm@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG3GZ59MUqATsKVm@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 09:10:15AM +0100, Russell King (Oracle) wrote:
> On Wed, May 24, 2023 at 09:26:19AM +0200, Horatiu Vultur wrote:
> > The 05/23/2023 16:54, Russell King (Oracle) wrote:
> > 
> > Hi Russell,
> > 
> > I have tried this series on lan966x and it seems to be working fine.
> 
> Thanks for testing.
> 
> > There was a small issue applying the patch 3, as the function
> > 'phylink_resolve_c73' doesn't exist yet.
> 
> It's for applying after my XPCS cleanup series that has been sent as RFC
> twice and now been sent for merging. Sorry for not stating that in the
> cover message.

... which is now in net-next.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

