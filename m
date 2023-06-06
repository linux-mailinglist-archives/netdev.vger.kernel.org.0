Return-Path: <netdev+bounces-8635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA29724F66
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 00:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84CFB1C20BE0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BAE2DBD9;
	Tue,  6 Jun 2023 22:02:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA04294D7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:02:49 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FA810EA;
	Tue,  6 Jun 2023 15:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LRafhOMAwhAEc3nrF8NDxvakjlwyJsgz2fT7Toaugrg=; b=W3pOKu8IAVK84T7RGiHDOruiVa
	lHMxv/JjJyjOoZEpOUXzGFthgca2KPYEVma/YbrvYtbCE+slYVWAJZ9eIX9oYb8p9UkUQlnym1+Bs
	lCW+8Fb+dsiq25ZBPfQUyeLsU+lv0isotTiKt3NierZoFqegEnFSlvHBrdRzrty/JCwBQ7FxnfRop
	+GLUmj7vbpK27c4Zv240hyrZUPIsNLyR6Sd0q/M8Zgpx50w8joYM+A3ap48BFLKWpW1pD2xfPaoFg
	WQ0GXaLBojN3Izp77y61ZU7Ctxrs1qwJFoCAI+LywA28jFxiiUhtLNodqWJsQOFbiR3P7FsiofGWv
	EOu4Yv2Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53124)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6elH-0006TP-5U; Tue, 06 Jun 2023 23:02:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6elE-0007Wu-DM; Tue, 06 Jun 2023 23:02:40 +0100
Date: Tue, 6 Jun 2023 23:02:40 +0100
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
Message-ID: <ZH+tAKg4hqlosb2N@shell.armlinux.org.uk>
References: <20230606214348.2408018-1-florian.fainelli@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606214348.2408018-1-florian.fainelli@broadcom.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 02:43:47PM -0700, Florian Fainelli wrote:
> We had a number of short comings:
> 
> - EEE must be re-evaluated whenever the state machine detects a link
>   change as wight be switching from a link partner with EEE
>   enabled/disabled
> 
> - tx_lpi_enabled controls whether EEE should be enabled/disabled for the
>   transmit path, which applies to the TBUF block
> 
> - We do not need to forcibly enable EEE upon system resume, as the PHY
>   state machine will trigger a link event that will do that, too
> 
> Fixes: 6ef398ea60d9 ("net: bcmgenet: add EEE support")
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> ---
> netdev maintainers, please do not apply without Andrew, Russell and
> Oleksij reviewing first since this relates to the on-going EEE rework
> from Andrew.

Hi Florian,

Please could you include some information on the UMAC_EEE_CTRL EEE_EN
bit - is this like the main switch for EEE which needs to be set
along with the bits in the tbuf register for the transmit side to
signal LPI?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

