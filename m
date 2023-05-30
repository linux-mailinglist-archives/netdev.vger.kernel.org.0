Return-Path: <netdev+bounces-6548-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 566EA716E08
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 116F2281302
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8CA31EE1;
	Tue, 30 May 2023 19:49:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D096C200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:49:55 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380F6D9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=F9vcQzHWwP3OtSu/2eUsYKqDy+C4nFAj06uZ9ukWzQY=; b=bnVwnwSg8vpZ1Zjxko4tFhDumj
	NJWgvP2FzJUmyUvsaEwy67Fke4gsC8r5W1k/2FPIKXXJ3tIIoRgOipMD/pP42q7UGO8OI+JCHLAZV
	8X10lGA1Th+QaNyGHYMsqGbdXFexduReZYeZBRNxyJyZoo5Gj5lFbMzgvsyjwtYk5MamdKnacNUqu
	XsDbkrdmPG5lYzGF55yGibCI9wXr4J3sOYPvcqiz9oGKPBJCx9VJBzyHq6yYPbDAdwQFDICY6LI/0
	q1zoEfEpo3aUR9ugGo0OdlA0FERkmBksmPpG04X/pcFnaBs4GNFOMeGao4mua0F9sp3tPWXxxOaya
	0N+m8etg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37598)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q45Lr-0003Nk-OJ; Tue, 30 May 2023 20:49:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q45Lq-0008Kj-AT; Tue, 30 May 2023 20:49:50 +0100
Date: Tue, 30 May 2023 20:49:50 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <ZHZTXjnvw5nt2rSl@shell.armlinux.org.uk>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <ZHZQG+O9HkQ+5K62@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHZQG+O9HkQ+5K62@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 08:35:55PM +0100, Russell King (Oracle) wrote:
> Going back to phylib, given this, things get even more "fun" if you have
> a dual-media PHY. As there's no EEE capability bits for 1000base-X, but
> a 1000base-X PCS optionally supports EEE. So, even with a zero EEE
> advertisement with a dual-media PHY that would only affect the copper
> side, and EEE may still be possible in the fibre side... which makes
> phylib's new interpretation of "eee_enabled" rather odd.
> 
> In any case, "eee_enabled" I don't think has much meaning for the fibre
> case because there's definitely no control beyond what "tx_lpi_enabled"
> already offers.
> 
> I think this is a classic case where the EEE interface has been designed
> solely around copper without checking what the situation is for fibre!

Let me be a bit more explicit on this. If one does (e.g.) this:

# ethtool --set-eee eth0 advertise 0 tx-lpi on tx-timer 100

with a dual-media PHY, if the MAC is programmed to enable LPI, the
dual-media PHY is linked via fibre, and the remote end supports fibre
EEE, phylib will force "eee" to "off" purely on the grounds that the
advertisement was empty.

If one looks at the man page for ethtool, it says:

           eee on|off
                  Enables/disables the device support of EEE.

What does that mean, exactly, and how is it different from:

           tx-lpi on|off
                  Determines whether the device should assert its Tx LPI.

since the only control at the MAC is whether LPI can be asserted or
not and what the timer is.

The only control at the PHY end of things is what the advertisement
is, if an advertisement even exists for the media type in use.

So, honestly, I don't get what this ethtool interface actually intends
the "eee_enabled" control to do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

