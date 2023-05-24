Return-Path: <netdev+bounces-5031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 342CD70F778
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D00F6280D2D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA15FC2C3;
	Wed, 24 May 2023 13:19:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85751FDD
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:19:06 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82649B;
	Wed, 24 May 2023 06:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LN1VY0drdJalomyEpkD7+FhVOeln3OrXx82cPKL/2rU=; b=t3YL7yHK8KVYi2L4cBWsJ4J4ST
	9wW/jJhDHimEmeAJeQoD/IlijHMm86jqdx+dPLlZNOWpQkE7odV+iIJMijP2vTJ0THDrIvZsxk9pq
	wT0aMxzjJY+4a95l3JirT5Mxo/af1B/ClkeiemevHsEMopFYWFdOTB1MvAniXO9Xv6AAH+C1QrmKU
	f8cTQfJaLUmliKvzBinpIK422UQ27i73eKXj5usn15PzEkxxK1X8Ex4fnyOEnCDmN5M29T+lWtNBM
	5TEfe6YBG111wrXbAFvdIcd2hWmxJQ4UJx77qxNEiLuoLO6pVkzQJ2O4NfnVkGPEsCleuuA8jxjwi
	vjWuWmXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51056)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1oOC-0002PQ-Rb; Wed, 24 May 2023 14:18:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1oO9-0001f6-HN; Wed, 24 May 2023 14:18:49 +0100
Date: Wed, 24 May 2023 14:18:49 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v3 2/7] net: dsa: mv88e6xxx: pass directly chip
 structure to mv88e6xxx_phy_is_internal
Message-ID: <ZG4OuWllZp3MZxO8@shell.armlinux.org.uk>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
 <20230524130127.268201-3-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524130127.268201-3-alexis.lothore@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 03:01:22PM +0200, Alexis Lothoré wrote:
> Since this function is a simple helper, we do not need to pass a full
> dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
> Doing so will allow to share this function with any other function
> not manipulating dsa_switch structure but needing info about number of
> internal phys
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> ---
> Changes since v2:
> - add reviewed-by tags
> 
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> ---

It never ceases to amaze me the way human beings can find creative ways
to mess things up, no matter how well things are documented. The above
commit message (and the others that I've looked at) are all broken
because of this creativity.

In effect, because of the really weird format you've come up with here,
your patches are in effect *not* signed off by you.

The patch format is in Documentation/process/submitting-patches.rst
under the section marked "The canonical patch format". Please review.

Please wait a while (a few days) to see if anyone responds to _this_
posting with any other comments. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

