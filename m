Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794182819C2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgJBRjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:39:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388499AbgJBRjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 13:39:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOP1c-00HH4W-SB; Fri, 02 Oct 2020 19:39:20 +0200
Date:   Fri, 2 Oct 2020 19:39:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Colin King <colin.king@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: dp83869: fix unsigned comparisons
 against less than zero values
Message-ID: <20201002173920.GF3996795@lunn.ch>
References: <20201002165422.94328-1-colin.king@canonical.com>
 <1ffbf497-cb07-4302-8a79-236338f00383@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ffbf497-cb07-4302-8a79-236338f00383@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 12:26:49PM -0500, Dan Murphy wrote:
> Colin
> 
> On 10/2/20 11:54 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Currently the comparisons of u16 integers value and sopass_val with
> > less than zero for error checking is always false because the values
> > are unsigned. Fix this by making these variables int.  This does not
> > affect the shift and mask operations performed on these variables
> > 
> > Addresses-Coverity: ("Unsigned compared against zero")
> > Fixes: 49fc23018ec6 ("net: phy: dp83869: support Wake on LAN")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >   drivers/net/phy/dp83869.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> > index 0aee5f645b71..cf6dec7b7d8e 100644
> > --- a/drivers/net/phy/dp83869.c
> > +++ b/drivers/net/phy/dp83869.c
> > @@ -305,7 +305,7 @@ static int dp83869_set_wol(struct phy_device *phydev,
> >   static void dp83869_get_wol(struct phy_device *phydev,
> >   			    struct ethtool_wolinfo *wol)
> >   {
> > -	u16 value, sopass_val;
> > +	int value, sopass_val;
> >   	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
> >   			WAKE_MAGICSECURE);
> 
> Wonder why this was not reported before as the previous comparison issue
> reported by zero day.

I think it needs W=1

  Andrew
