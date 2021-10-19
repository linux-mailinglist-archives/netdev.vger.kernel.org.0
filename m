Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A62E433605
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhJSMeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:34:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhJSMeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=naCPatSPieFjm2idIBaHbGp+IymFwGkWn28jPFF7KI0=; b=uO
        tUMMJv9BIdVH2emRu5mLcEcSC9Hm1vOnC7j01Qws+ZecyjE3t5JEyTGU/LCMT6HXkbv9LS48mZ8X4
        Sc0+Q7peY8uioYke6w1/G2J/YE9Lch5XfBqpS9bygP/M1fAITutQ8bynnbScRDgzODK4aqPQm7SNQ
        4MsVO0aUVozyWGA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcoHd-00B4in-O5; Tue, 19 Oct 2021 14:31:57 +0200
Date:   Tue, 19 Oct 2021 14:31:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jie Luo <quic_luoj@quicinc.com>
Cc:     Luo Jie <luoj@codeaurora.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v3 06/13] net: phy: add qca8081 read_status
Message-ID: <YW66vT1HQsVfjZDz@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-7-luoj@codeaurora.org>
 <YW3qLe8iHe1wdMev@lunn.ch>
 <0472b75b-9fd7-55e3-dc1b-f33786643103@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0472b75b-9fd7-55e3-dc1b-f33786643103@quicinc.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 08:10:15PM +0800, Jie Luo wrote:
> 
> On 10/19/2021 5:42 AM, Andrew Lunn wrote:
> > > +static int qca808x_read_status(struct phy_device *phydev)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_STAT);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->lp_advertising,
> > > +			ret & MDIO_AN_10GBT_STAT_LP2_5G);
> > > +
> > Could genphy_c45_read_lpa() be used here?
> > 
> >        Andrew
> 
> Hi Andrew,
> 
> Thanks for the comments,  the MDIO_STAT1 of PHY does not follow the
> standard, bit0~bit6 of MDIO_STAT1 are
> 
> always 0, genphy_c45_read_lpa can't be used.

O.K. It is a shame the hardware partially follow the standard, but
breaks it as well. Why go to the effort of partially following it,
when you don't gain anything from it because you need custom code
anyway?

	Andrew
