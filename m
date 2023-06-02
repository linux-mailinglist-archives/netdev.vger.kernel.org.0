Return-Path: <netdev+bounces-7503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 968257207AA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E5BF281957
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57698332E3;
	Fri,  2 Jun 2023 16:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46539332E1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:34:41 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04201AB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JROnAh9uM+2iqyKp52V/ZLKTj/qwnj5KPDtEO4yRNyY=; b=xPtQ6YpISPHemnswmpZ2szvsxh
	apkT+jg6L2P+luE/0aqhyL9tJLMamoiCnWWrDHNxuBcyqWcL+nlBojkCjJzLLiKSCSXHGAgC5ZU6Z
	e6QQ2ihTa4i19RBkkV+ZBKanPjIejuuKMpaYxZawWwNRcc65O+Ww2UrsvJRLSHM+qV0VXLN6OF1bT
	OIRHddeKpmSyeHEBSdkv2tXYaCOncCHid9n1FgVgj6sumpwiyUJW2dvQ4GrJBjeBoBE0giLXFpQPG
	WAy64E4YbkNeXGMILxX4e7U2NVRXG9jNpo2HF7VxgRhBfUPssTOe94cuDbmU8ZiT33N8FUA+7TJzx
	6pqLDyIw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37720)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q57jV-0008IB-Ij; Fri, 02 Jun 2023 17:34:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q57jT-00036L-V3; Fri, 02 Jun 2023 17:34:31 +0100
Date: Fri, 2 Jun 2023 17:34:31 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <ZHoaF6O0Vlq9pikF@shell.armlinux.org.uk>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
 <20230601213345.3aaee66a@kernel.org>
 <20230601213509.7ef8f199@kernel.org>
 <ZHmt9c9VsYxcoXaI@shell.armlinux.org.uk>
 <20230602090539.6a4fa374@kernel.org>
 <ZHoWN0uO30P/y9hv@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHoWN0uO30P/y9hv@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 05:17:59PM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 02, 2023 at 09:05:39AM -0700, Jakub Kicinski wrote:
> > On Fri, 2 Jun 2023 09:53:09 +0100 Russell King (Oracle) wrote:
> > > > Yes it is :)  All this to save the single line of assignment
> > > > after the read_poll_timeout() "call" ?  
> > > 
> > > Okay, so it seems you don't like it. We can't fix it then, and we'll
> > > have to go with the BUILD_BUG_ON() forcing all users to use a signed
> > > varable (which better be larger than a s8 so negative errnos can fit)
> > > or we just rely on Dan to report the problems.
> > 
> > Wait, did the version I proposed not work?
> > 
> > https://lore.kernel.org/all/20230530121910.05b9f837@kernel.org/
> 
> If we're into the business of throwing web URLs at each other for
> messages we've already read, here's my one for you which contains
> the explanation why your one is broken, and proposing my solution.
> 
> https://lore.kernel.org/all/ZHZmBBDSVMf1WQWI@shell.armlinux.org.uk/
> 
> To see exactly why yours is broken, see the paragraph starting
> "The elephant in the room..."
> 
> If it needs yet more explanation, which clearly it does, then let's
> look at what genphy_loopback is doing:
> 
>                 ret = phy_read_poll_timeout(phydev, MII_BMSR, val,
>                                             val & BMSR_LSTATUS,
>                                     5000, 500000, true);
> 
> Now, with your supposed "fix" of:
> 
> +	int __ret, __val;						\
> +									\
> +	__ret = read_poll_timeout(phy_read, __val, __val < 0 || (cond),	\
>  		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
> 
> This ends up being:
> 
> 	int __ret, __val;
> 
> 	__ret = read_poll_timeout(phy_read, __val, __val < 0 || (val & BMSR_LSTATUS),
>  		sleep_us, timeout_us, sleep_before_read, phydev, regnum);
> 
> and that expands to something that does this:
> 
> 	__val = phy_read(phydev, regnum);
> 	if (__val < 0 || (val & BMSR_LSTATUS))
> 		break;
> 
> Can you spot the bug yet? Where does "val" for the test "val & BMSR_LSTATUS"
> come from?
> 
> A bigger hint. With the existing code, this would have been:
> 
> 	val = phy_read(phydev, regnum);
> 	if (val < 0 || (val & BMSR_LSTATUS))
> 		break;
> 
> See the difference? val & BMSR_LSTATUS is checking the value that was
> returned from phy_read() here, but in yours, it's checking an
> uninitialised variable.
> 
> With my proposal, this becomes:
> 
> 	val = __val = phy_read(phydev, regnum);
> 	if (__val < 0 || (val & BMSR_LSTATUS))
> 		break;
> 
> where "val" is whatever type the user chose, which has absolutely _no_
> bearing what so ever on whether the test for __val < 0 can be correctly
> evaluated, and makes that test totally independent of whatever type the
> user chose.

If you don't like my solution, then I suppose another possibility would
be:

#define __phy_poll_read(phydev, regnum, val) \
	({ \
		int __err; \
		__err = phy_read(phydev, regnum); \
		if (__err >= 0) \
			val = __err; \
		__err; \
	})

#define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
                                timeout_us, sleep_before_read) \
({ \
	int __ret, __err; \
	__ret = read_poll_timeout(__phy_poll_read, __err, \
				  __err < 0 || (cond), \
		sleep_us, timeout_us, sleep_before_read, phydev, regnum, val); \
	if (__err < 0) \
		__ret = __err; \
...

but that brings with it the possibility of using an uninitialised
"val" (e.g. if phy_read() returns an error on the first iteration.)
and is way more horrid and even less easy to understand.

Remember that we default to *not* warning about uninitialised variables
when building the kernel, so this won't produce a warning - which I
guess is probably why you didn't notice that your suggestion left "val"
uninitialised.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

