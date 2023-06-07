Return-Path: <netdev+bounces-8751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D64725861
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD51D2812BE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2E6883E;
	Wed,  7 Jun 2023 08:46:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150896FB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:46:43 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BD011F;
	Wed,  7 Jun 2023 01:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=s4MbmFqXBHLby6hrFobQYZmOb5HK3o02YxuG4peZWhY=; b=CPqPJkSGuRreFI6Et5QWmfEthB
	tRdKjHpMPY3b5gynsRsH+yU/Gi32jVoqT7nnWi0ZeN/Wq32mkt6AoEFcaGrYLOG/Ai1+l52W0PGiB
	po1w6XmNaz81C8jSerbkoqTEA1fmv6VyBuaj7gzoa5KGecNMVgywyOywz6L7//AJWdnHQ14GPJgrj
	beYqlZ2FN1i33HHkd/j4UnnpYCJqz5bCRaEh2pZz8mUitK4H4+5POZVv+wTds2sgt+/Lp2GYVtJ7K
	Yuu5LYz4ddDooT0FJGsVwFMWISbbVruuyKFauGz/ImkKImJNAWaVGOwYwCKzrzFn+X7ThrrLvQKC2
	fNF5oR+A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38184)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6ooR-00074x-2r; Wed, 07 Jun 2023 09:46:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6ooO-00084c-Q3; Wed, 07 Jun 2023 09:46:36 +0100
Date: Wed, 7 Jun 2023 09:46:36 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, o.rempel@pengutronix.de, andrew@lunn.ch,
	hkallweit1@gmail.com, Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: bcmgenet: Fix EEE implementation
Message-ID: <ZIBD7B8cwSjjFWuq@shell.armlinux.org.uk>
References: <20230606214348.2408018-1-florian.fainelli@broadcom.com>
 <ZH+tAKg4hqlosb2N@shell.armlinux.org.uk>
 <1074c668-3e75-dff7-9d23-d43fbeb98d84@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1074c668-3e75-dff7-9d23-d43fbeb98d84@broadcom.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 03:16:03PM -0700, Florian Fainelli wrote:
> On 6/6/23 15:02, Russell King (Oracle) wrote:
> > On Tue, Jun 06, 2023 at 02:43:47PM -0700, Florian Fainelli wrote:
> > > We had a number of short comings:
> > > 
> > > - EEE must be re-evaluated whenever the state machine detects a link
> > >    change as wight be switching from a link partner with EEE
> > >    enabled/disabled
> > > 
> > > - tx_lpi_enabled controls whether EEE should be enabled/disabled for the
> > >    transmit path, which applies to the TBUF block
> > > 
> > > - We do not need to forcibly enable EEE upon system resume, as the PHY
> > >    state machine will trigger a link event that will do that, too
> > > 
> > > Fixes: 6ef398ea60d9 ("net: bcmgenet: add EEE support")
> > > Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> > > ---
> > > netdev maintainers, please do not apply without Andrew, Russell and
> > > Oleksij reviewing first since this relates to the on-going EEE rework
> > > from Andrew.
> > 
> > Hi Florian,
> > 
> > Please could you include some information on the UMAC_EEE_CTRL EEE_EN
> > bit - is this like the main switch for EEE which needs to be set
> > along with the bits in the tbuf register for the transmit side to
> > signal LPI?
> 
> EEE_EN is described as:
> 
> If set, the TX LPI policy control engine is enabled and the MAC inserts
> LPI_idle codes if the link is idle. The rx_lpi_detect assertion is
> independent of this configuration.
> 
> in the RBUF, EEE_EN is described as:
> 
> 1: to enable Energy Efficient feature between Unimac and PHY for Rx Path
> 
> and in the TBUF, EEE_EN is described as:
> 
> 1: to enable Energy Efficient feature between Unimac and PHY for Tx Path
> 
> The documentation is unfortunately scare about how these two signals connect
> :/

Thanks for the clarification. Squaring this with my understanding of
EEE, the transmit side makes sense. LPI on the transmit side is only
asserted only when EEE_EN and TBUF_EEE_EN are both set, so this is
the behaviour we want. If we were evaluating this in software, my
understanding is it would be:

	if (eee_enabled && eee_active && tx_lpi_enabled)
		enable LPI generation at MAC;
	else
		disable LPI generation at MAC;

and the code here treats eee_enabled && eee_active as the "enabled"
flag controlling EEE_EN, and tx_lpi_enabled controls TBUF_EEE_EN.
The hardware effectively does the last && operation for us. So
this all seems fine.

On the receive side, if the link partner successfully negotiates
EEE, then it can assert LPI, and the local end will see that
assertion (hence, rx_lpi_detect may become true.) If the transmit
side doesn't generate LPI, then this won't have any effect other
than maybe setting status bits, so I don't see that setting
RBUF_EEE_EN when eee_enabled && eee_active would be wrong.

Moving the phy_init_eee() (as it currently stands) into the adjust_link
path is definitely the right thing, since it provides the resolution
of the negotiated EEE state.

So, all round, I think your patch makes complete sense as far as the
logic goes.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

However, one thing I will ask is whether the hardware has any
configuration of the various timers for EEE operation, and if it does,
are they dependent on the negotiated speed of the interface? In
Marvell's neta and pp2 drivers, the timers scale with link speed and
thus need reprogramming accordingly. In any case, 802.3 specifies
different timer settings depending on link speed and media type.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

