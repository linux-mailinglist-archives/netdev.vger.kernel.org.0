Return-Path: <netdev+bounces-2805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E58370400B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C9441C20C06
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC9519BC0;
	Mon, 15 May 2023 21:46:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703D0FBF9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 21:46:03 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B5F10EC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 14:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=W3TE4ccIZBaLyijVR8GPmMnmsWRf/mMHqj2NaoV8t1E=; b=Bz9orKkAmQvhzEvjgWOhLpC5+8
	XDVRWXUdjF5ad9I4IzOv+EAQMokwJuzytLihdJnn0dLiIPCeF2sOa6bffUb+m5KMC1Z8UAmLIVx2j
	zOvjxTAFiHBOpl9l5MXu8l1KhP8AJlO0SBSqQxhCYi2lbMpkVaTurrarCs36pO8DmVukTdItiYS11
	T5EZadEFot1wShkwkNMKjweQd6kFRZncw4yRJKBAzz1ETShaIuuuvzOrgBPMR6QNb4xJZscVHZSMo
	xBVwxPuFQyuhLhCzzeo4f4/cN8POmCJv7YuK/OQNYW6P9HhITDAzKVN9Eo73zeqyuBsQcr25lTDFw
	DscYXzYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51262)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pyg0W-0004fD-QR; Mon, 15 May 2023 22:45:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pyg0P-00006m-6q; Mon, 15 May 2023 22:45:21 +0100
Date: Mon, 15 May 2023 22:45:21 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>, Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] Providing a helper for PCS inband negotiation
Message-ID: <ZGKn8c2W1SI2CPq4@shell.armlinux.org.uk>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
 <20230515195616.uwg62f7hw47mktfu@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515195616.uwg62f7hw47mktfu@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 10:56:16PM +0300, Vladimir Oltean wrote:
> Hello,
> 
> On Mon, May 15, 2023 at 01:22:50PM +0100, Russell King (Oracle) wrote:
> > 1. Should 10GBASE-KR be included in the SGMII et.al. case in the code?
> >    Any other interface modes that should be there? Obviously,
> >    PHYLINK_PCS_NEG_NONE is not correct for 10GBASE-KR since it does use
> >    inband AN. Does it make sense for the user to disable inband AN for
> >    10GBASE-KR? If so, maybe it should be under the 1000base-X case.
> 
> What physical process (reference to IEEE 802.3 clause is fine) would be
> controlled by the phylink_pcs_neg_mode() function for the so-called
> 10GBASE-KR phy-mode?

Clause 73.1:

"While implementation of Auto-Negotiation is mandatory for Backplane
Ethernet PHY s, the use of Auto-Negotiation is optional."

"The Auto-Negotiation function allows the devices to switch between
the various operational modes in an orderly fashion, permits
management to disable or enable the Auto-Negotiation function, and
allows management to select a specific operational mode."

"The Auto-Negotiation function also provides a parallel detection
function to allow Backplane Ethernet devices to connect to other
Backplane Ethernet devices that have Auto-Negotiation disabled and
interoperate with legacy devices that do not support Clause 73
Auto-Negotiation."

So, my reading of these statements is that the _user_ should be
able to control via ethtool whether Clause 73 negotiation is
performed on a 10GBASE-KR (or any other backplane link that
uses clause 73 negotiation.) Having extracted that from 802.3,
I now believe it should be treated the same as 1000BASE-X, and
the Autoneg bit in ethtool should determine whether Clause 73
negotiation is used for 10GBASE-KR (and any other Clause 73
using protocol.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

