Return-Path: <netdev+bounces-6569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E91D716F67
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF5A22810BA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC37028C1D;
	Tue, 30 May 2023 21:09:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E145121CF3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:09:35 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510CF97;
	Tue, 30 May 2023 14:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Xv/on1soQm2WiaudXE9Ed1L5dqZ5lX/VHutFpckjEf8=; b=v/F0MO7kTnFLgfWviJwwuTazXY
	35YFXB+g6jUUg4Ee0LruI/Ve2e+42tdpOAVL/B4+bEuljps5xkStKaz+JfGbA7nN5mws95kqAP4s9
	RrjYw+D3BSlrzx1G0zbRsD8nBfBo22n0/Wl23WCv7omNXNSc/T1VP1IrTjC350Hj6EypFue65IvlY
	PhZ8LPqVCzY88KVrRjElX9ETMFVx1Y6j7gtmUEO1olNRk+6s4FWSMhOpIRIDkz6/eoGhF+XDxojSH
	jdTvJaiyb8iEZvkMrA9AUdokGZw0fLfvecA10AYKh3MWjwNwobuGiib86IH+m8PB02O7RBhgvqdA9
	oAngFbcw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58388)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q46at-0003TZ-G4; Tue, 30 May 2023 22:09:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q46aq-0008Ov-UE; Tue, 30 May 2023 22:09:24 +0100
Date: Tue, 30 May 2023 22:09:24 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <ZHZmBBDSVMf1WQWI@shell.armlinux.org.uk>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
 <20230530121910.05b9f837@kernel.org>
 <ZHZQ+1KNGB7KYZGi@shell.armlinux.org.uk>
 <0851bc91-6a7c-4333-ad8a-3a18083411e3@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0851bc91-6a7c-4333-ad8a-3a18083411e3@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:04:52PM +0200, Andrew Lunn wrote:
> > > This is what I meant FWIW:
> > > 
> > > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > > index 7addde5d14c0..829bd57b8794 100644
> > > --- a/include/linux/phy.h
> > > +++ b/include/linux/phy.h
> > > @@ -1206,10 +1206,13 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
> > >  #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
> > >  				timeout_us, sleep_before_read) \
> > >  ({ \
> > > -	int __ret = read_poll_timeout(phy_read, val, val < 0 || (cond), \
> > > +	int __ret, __val;						\
> > > +									\
> > > +	__ret = read_poll_timeout(phy_read, __val, __val < 0 || (cond),	\
> > >  		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
> > > -	if (val < 0) \
> > > -		__ret = val; \
> > > +	val = __val;
> 
> This results in the sign being discarded if val is unsigned. Yes, the
> test is remove, which i assume will stop Smatch complaining, but it is
> still broken.

I was going to ask you to explain that, but having thought about
this more, there's much bigger problems with the proposal.

First, if I'm understanding you correctly, your point doesn't seem
relevant, because if val is unsigned, we have an implicit cast from a
signed int to an unsigned int _at_ _some_ _point_. With the existing
code, that implicit cast is buried inside read_poll_timeout(), here
to be exact:

	(val) = op(args);

because "op" will be one of the phy_read*() functions that returns an
"int", but "val" is unsigned - which means there's an implicit cast
here. Jakub's patch moves that cast after read_poll_timeout().

The elephant in the room has nothing to do with this, but everything
to do with "cond". "cond" is an expression to be evaluated inside the
loop, which must have access to the value read from the phy_read*()
function, and that value is referenced via whatever variable was
provided via "val". So changing "val" immediately breaks "cond".


Having thought about this, the best I can come up with is this, which
I think gives us everything we want without needing BUILD_BUG_ONs:

#define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
                                timeout_us, sleep_before_read) \
({ \
        int __ret, __val;
	__ret = read_poll_timeout(__val = phy_read, val, __val < 0 || (cond), \
                sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
        if (__val < 0) \
                __ret = __val; \
        if (__ret) \
                phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
        __ret; \
})

This looks rather horrid, but what it essentially does is:

                (val) = op(args); \
                if (cond) \
                        break; \

expands to:

		(val) = __val = phy_read(args);
		if (__val < 0 || (cond))
			break;

As phy_read() returns an int, there is no cast or loss assigning it
to __val, since that is also an int. The conversion from int to
something else happens at the same point it always has.

Hmm?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

