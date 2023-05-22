Return-Path: <netdev+bounces-4362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5E4870C318
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 954571C20B01
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C441E16402;
	Mon, 22 May 2023 16:16:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B365514286
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 16:16:13 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EBAE9;
	Mon, 22 May 2023 09:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=1oYReIb21gx1lPn/zOspt867lqTrE9boyBC6cBnhc5M=; b=AV4hSZlfawpDM8oTuN7UkXIApw
	SF2R8kXwSp2pzbHldYbTZj6T+X71XjBjJEDHx1nLw22MMmUZxJwHoBfFi54awY/51YCekOG6qJjmN
	We9HBof4Sg/MUrD8PLSl4M1jPW8XX04Z5FhXZgCHAWKFY1pPhtHuQ22IM0t0nxkPbDbE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q18CS-00DZ3h-AB; Mon, 22 May 2023 18:15:56 +0200
Date: Mon, 22 May 2023 18:15:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Dan Murphy <dmurphy@ti.com>
Subject: Re: DP83867 ethernet PHY regression
Message-ID: <07037ce6-8d1c-4a1d-9fdd-2cd9e68c4594@lunn.ch>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
 <e0d4b397-a8d9-4546-a8a2-14cf07914e64@lunn.ch>
 <ZGuLxSJwXbSE/Rbb@francesco-nb.int.toradex.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGuLxSJwXbSE/Rbb@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 05:35:33PM +0200, Francesco Dolcini wrote:
> On Mon, May 22, 2023 at 05:15:56PM +0200, Andrew Lunn wrote:
> > On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> > > Hello all,
> > > commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> > > established link") introduces a regression on my TI AM62 based board.
> > > 
> > > I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> > > testing the DTS with v6.4-rc in preparation of sending it to the mailing
> > > list I noticed that ethernet is working only on a cold poweron.
> > 
> > Do you have more details about how it does not work.
> > 
> > Please could you use:
> > 
> > mii-tool -vvv ethX
> 
> please see the attached files:
> 
> working_da9ef50f545f_reverted.txt
>   this is on a v6.4-rc, with da9ef50f545f reverted
> 
> not_working.txt
>   v6.4-rc not working
> 
> working.txt
>   v6.4-rc working
> 
> 
> It looks like, even on cold boot, it's not working in a reliable way.
> Not sure the exact difference when it's working and when it's not.

> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-FD flow-control, link ok
>   registers for MII PHY 0: 
>     1140 796d 2000 a231 05e1 c5e1 006f 2001
>     5806 0200 3800 0000 0000 4007 0000 3000
>     5048 ac02 ec10 0004 2bc7 0000 0000 0040
>     6150 4444 0002 0000 0000 0000 0282 0000

>     1140 796d 2000 a231 05e1 c5e1 006d 2001
>     5806 0200 3800 0000 0000 4007 0000 3000
>     5048 af02 ec10 0000 2bc7 0000 0000 0040
>     6150 4444 0002 0000 0000 0000 0282 0000

Register  6: 006f vs 006d
Register 17: ac02 vs 1f02
Register 19: 0004 vs 0000

Register 6 is MII_EXPANSION. Bit 1 is

#define EXPANSION_LCWP          0x0002  /* Got new RX page code word   */

So that is probably not relevant here.

Register 17 is MII_DP83867_PHYSTS, and bits 8 and 9 are not documented
in the driver. Do you have the datasheet?

Register 19 is MII_DP83867_ISR. The interrupt bits are not documented
in the driver either.

This driver also uses C45 registers, which are not shown here. At some
point, we might need to look at those. But first it would be good to
understand what these differences mean.

	Andrew

