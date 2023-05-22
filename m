Return-Path: <netdev+bounces-4385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3844570C4FF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0012E1C20B4D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C8B16438;
	Mon, 22 May 2023 18:14:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F9616414
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:14:07 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621AFC6;
	Mon, 22 May 2023 11:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xMDWNdtDyX2oslr/W+4USsKREfXUGofI9zp56SMdPdE=; b=gS1aYzGLL9GL7wcQZdImWvvfx6
	5hL51LptKMQj6jIj8fRcKt1cjpOI66ZtPT29tPsEQIjfZCh/coNN6OaFeM/DK0xgGmrLs2OEX7Syt
	MsEsrCO8NimtuR9XptngCd9yUY1FWlE+/OvGIyYF1gNEemLzc1tpP30crcrMUk3b56npFpW4nyKcD
	nAekpw9AcYmlJ7mvA8eUh5/G3jdYrl6k2Z0D6Va5AuFeVQNBDEHYJsiaiMdGxB7qGgBHZCV7PtYBC
	FpyrYF1tVY6U7+GuK4OXweUyznNtHaoInIYI7tAAP6dCSif83xJBB702Zj/U0zA72OwbY/mK+CiNV
	GYXQyvvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38236)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1A2P-0007Im-0M; Mon, 22 May 2023 19:13:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1A2F-0008AI-3m; Mon, 22 May 2023 19:13:31 +0100
Date: Mon, 22 May 2023 19:13:31 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: arinc9.unal@gmail.com, Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 00/30] net: dsa: mt7530: improve, trap BPDU &
 LLDP, and prefer CPU port
Message-ID: <ZGuwy/0FGh0c4wXk@shell.armlinux.org.uk>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522140917.er7f5ws24b2eeyvs@soft-dev3-1>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522140917.er7f5ws24b2eeyvs@soft-dev3-1>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 04:09:17PM +0200, Horatiu Vultur wrote:
> The 05/22/2023 15:15, arinc9.unal@gmail.com wrote:
> 
> Hi,
> 
> > 
> > Hello!
> > 
> > This patch series simplifies the code, improves the logic of the switch
> > hardware support, traps LLDP frames and BPDUs for MT7530, MT7531, and
> > MT7988 SoC switches, and introduces the preferring local CPU port
> > operation.
> > 
> > There's also a patch for fixing the port capabilities of the switch on the
> > MT7988 SoC.
> > 
> 
> I have noticed that in many patches of the series you have:
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Where you also have:
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> I think you can drop Tested-by as the SoB will imply that. I think you
> got a similar comment some time ago to a different patch series.

Signed-off-by in no way implies a tested-by. Signed-off-by has a very
distinct definition that is in submitting-patches.rst.

Clearly, if one is working on infrastructure where there are numerous
drivers involved, one probably doesn't have all the hardware, and one
may have to send patches that have only been build tested, but never
tested against real hardware.

While we may attempt to elicit testing, most of the time this seems
to be a waste of time and effort - or at least that's my experience.
Even if you Cc people who have recently been active with hardware,
that is no guarantee that there will be any reaction.

That has got to the point now where I just don't bother trying to
elicit help from others to test driver changes. If people want to
test, they need to do so when they see a patch on the mailing list,
preferably before it gets applied. If not, and if it breaks something,
then we'll have to generate a patch to fix the breakage.

So no, please stop thinking that SoB implies that the patch has been
tested.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

