Return-Path: <netdev+bounces-7652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6088472100D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 344D9281A7D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 12:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BF3C2D6;
	Sat,  3 Jun 2023 12:27:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664D2F5F
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 12:27:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60480A6;
	Sat,  3 Jun 2023 05:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NdKc/jMqGPx4GztP2rKQEhUYT+Xz1wkAFWT6ucRh7C8=; b=P2L+9i8tmKVnpGy9CqOUIgxeu0
	jy2PAiKhDLB9S6If9z/dVeyWCDAJKL82PCEWUOoDZB/xTNfdx7Duowb0pEgh9y7dmmuGgNkHOp9CS
	QghaBMsB5zwQFk7x0KRw/H11pn0N5bg2h7XeRbc4u4CsCPcGO4ivlNJQ9aODrZmtEGnGMEdkuMrKU
	TigbbfjiWTXCG330nHW2bFL2GvGo+IZNaacpD3mAIXvF0xkgO3sueYhEGUR4S46vLFxBwE0ZNoIvv
	SoqJ0kOX70n+Wn79QQzyIF+nUwCeRTo9SO64U4OtRKIuSENSrPpOHmYo+Y6936SdHTrSOG4fA5DK/
	m+j9+J+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47258)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q5QL8-0001Fn-DH; Sat, 03 Jun 2023 13:26:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q5QKz-00041Y-AO; Sat, 03 Jun 2023 13:26:29 +0100
Date: Sat, 3 Jun 2023 13:26:29 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Vladimir Oltean <olteanv@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
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
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
Message-ID: <ZHsxdQZLkP/+5TF0@shell.armlinux.org.uk>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230522121532.86610-9-arinc.unal@arinc9.com>
 <20230524175107.hwzygo7p4l4rvawj@skbuf>
 <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
 <20230526130145.7wg75yoe6ut4na7g@skbuf>
 <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 03:15:52PM +0300, Arınç ÜNAL wrote:
> On 26.05.2023 16:01, Vladimir Oltean wrote:
> > Ok, but given the premise of this patch set, that phylink is always available,
> > does it make sense for mt7531_cpu_port_config() and mt7988_cpu_port_config()
> > to manually call phylink methods?
> 
> All I know is that that's how the implementation of phylink's PCS support in
> this driver works. It expects the MAC to be set up before calling
> mt753x_phylink_pcs_link_up() and mt753x_phylink_mac_link_up().

First, do you see a message printed for the DSA device indicating that
a link is up, without identifying the interface? For example, with
mv88e6xxx:

mv88e6085 f1072004.mdio-mii:04: Link is Up - 1Gbps/Full - flow control off

as opposed to a user port which will look like this:

mv88e6085 f1072004.mdio-mii:04 lan1: Link is Up - 1Gbps/Full - flow control rx/tx

If you do, that's likely for the CPU port, and indicates that phylink
is being used for the CPU port. If not, then you need to investigate
whether you've provided the full description in DT for the CPU port.
In other words, phy-mode and a fixed-link specification or in-band
mode.

Given that, you should have no need to make explicit calls to your
mac_config, pcs_link_up and mac_link_up functions. If you need to
make these calls, it suggests that phylink is not being used for the
CPU port.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

