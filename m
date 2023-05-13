Return-Path: <netdev+bounces-2341-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B8A70159B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB460281881
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 09:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3921385;
	Sat, 13 May 2023 09:24:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF567137B
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 09:24:19 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CB3448A
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 02:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XVh8KT9gVBykDIb1/H0Lx91tru6ENRaXWSfNY5scpLw=; b=ULaLP4WVTvp3xqw5S9/DZpOhGg
	k78QwHicUmyKSk3wyiVD9ylMk0D7L0odUvTyR8oatnle9bgtpnirIBZtnbZimTxCLfO29xuc/x0OU
	B/ENMWUpQySBiy4m1hJPx8ERt8lOGnGBjnIwHMb0pN6V7DMjC7LpDRyiOCtNnuub7UkoKwq7qPLYD
	bng2648049SGkdeWXdXHvEdBfbndfOqbkXXkeCAe/RdvXHMSsNmxJpBXWwGVg+NVuz2/IfetE0X+H
	gqX0PtUBfAwn9YyOBuTh5rVltozfJaPCLKrnac5BEgFiE59gk/5kCM8NontaFMmVDJvXESTk0ITkE
	MdYYF2pw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48936)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxlU1-0001AI-76; Sat, 13 May 2023 10:24:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxlTy-0005zE-FT; Sat, 13 May 2023 10:24:06 +0100
Date: Sat, 13 May 2023 10:24:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 3/9] net: phylink: add function to resolve
 clause 73 negotiation
Message-ID: <ZF9XNhXthYfALp44@shell.armlinux.org.uk>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWXz-002Qs5-0N@rmk-PC.armlinux.org.uk>
 <7cec3e9f-e614-43b4-abe9-c423d5f63563@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cec3e9f-e614-43b4-abe9-c423d5f63563@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 01:57:46AM +0200, Andrew Lunn wrote:
> > +void phylink_resolve_c73(struct phylink_link_state *state)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(phylink_c73_priority_resolution); i++) {
> > +		int bit = phylink_c73_priority_resolution[i].bit;
> > +		if (linkmode_test_bit(bit, state->advertising) &&
> > +		    linkmode_test_bit(bit, state->lp_advertising))
> > +			break;
> > +	}
> > +
> > +	if (i < ARRAY_SIZE(phylink_c73_priority_resolution)) {
> > +		state->speed = phylink_c73_priority_resolution[i].speed;
> > +		state->duplex = DUPLEX_FULL;
> > +	} else {
> > +		/* negotiation failure */
> > +		state->link = false;
> > +	}
> 
> Hi Russell
> 
> This looks asymmetric in that state->link is not set true if a
> resolution is found.
> 
> Can that set be moved here? Or are there other conditions which also
> need to be fulfilled before it is set?

It's intentionally so because it's a failure case. In theory, the
PHY shouldn't report link-up if the C73 priority resolution doesn't
give a valid result, but given that there are C73 advertisements
that we don't support, and that the future may add further
advertisements, if our software resolution fails to find a speed,
we need to stop the link coming up. Also... PHYs... hardware
bugs...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

