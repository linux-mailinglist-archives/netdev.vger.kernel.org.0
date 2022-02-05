Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B464AAA24
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 17:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380471AbiBEQZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 11:25:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbiBEQZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 11:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=vh9miszy1uEiFiI+TyRVRbaw95NG+kNiCTw6Ce+iMBU=; b=i5
        LaelNcPZ3l0Vo6T7ro+SULjFsg4UhuD1ol2GS3jRh54d98SbFa9T8mXhnGAKN4WnnFAyGyDg/0OBP
        ZTY+ML94umIeAWB0DXxiol7PIjthcfVYRCroxq/61UalZq/J0wSHUJaWwo/zj5vRRvRpyhXahheRA
        SVT/7fqyoNOkwfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nGNse-004PVL-5C; Sat, 05 Feb 2022 17:25:44 +0100
Date:   Sat, 5 Feb 2022 17:25:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel.Parkhomenko@baikalelectronics.ru
Cc:     Alexey.Malahov@baikalelectronics.ru,
        Sergey.Semin@baikalelectronics.ru, linux-kernel@vger.kernel.org,
        michael@stapelberg.de, afleming@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Message-ID: <Yf6lCNoBY8Lr5JWB@lunn.ch>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
 <Yf0lyGi+2mEwmrEH@lunn.ch>
 <5dd77fec0f9a2d38fd4473cd0e357e80aeafe0cb.camel@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dd77fec0f9a2d38fd4473cd0e357e80aeafe0cb.camel@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 05, 2022 at 03:22:44PM +0000, Pavel.Parkhomenko@baikalelectronics.ru wrote:
> On Fri, 04/02/2022 at 14:10 +0100, Andrew Lunn wrote:
> > Hi Pavel
> > 
> > There appears to be another path which has the same issue.
> > 
> > m88e1118_config_aneg() calls marvell_set_polarity(), which also needs
> > a reset afterwards.
> > 
> > Could you fix this case as well?
> > 
> > Thanks
> >         Andrew
> 
> m88e1118_config_aneg() was added back in 2008 and has unconditional
> genphy_soft_reset() at the very beginning. I haven't got 88E1118R or
> 88E11149R by the hand and the full documentation is also not available.
> I believe that in this case it would be safe to still issue reset
> unconditionally, but do it at the very end of m88e1118_config_aneg().
> Anyways, I'd like to post it as a separate patch as I cannot test the fix
> properly, unlike previous patch regarding 88E1510.

All the datasheets i have follow the same scheme, you need to perform
a reset at some point to get changes to actually apply. So i doubt
1118r is any different.

Posting a separate patch is fine.

Thanks
	Andrew
