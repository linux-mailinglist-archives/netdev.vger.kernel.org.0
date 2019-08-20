Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2C95F66
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfHTNEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:04:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfHTNEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 09:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I7K/h5NF0hSsFkWTVB5gzSxkSpsigmltCouJ/cfBkkA=; b=NkPK1k5HnDT7h4r46UdJdzwq0q
        +HmBrQTNOkEQOsEV0SI+WArtAV61y4q3l5Tg/AuYDFh8k8PV9EcKKAruNd37nT0PUZBRUgT13CnTC
        CXe2nRoBlXay9178lQYG2ke7AKX3kwqECGqddrA74R2+gVAOZqy1PlXnn1y8ViLcXBMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i03nv-0005Jj-Jd; Tue, 20 Aug 2019 15:04:03 +0200
Date:   Tue, 20 Aug 2019 15:04:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Marco Hartmann <marco.hartmann@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [EXT] Re: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write
 support
Message-ID: <20190820130403.GH29991@lunn.ch>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
 <20190819225422.GD29991@lunn.ch>
 <VI1PR0402MB360079EAAE7042048B2F5AC8FFAB0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB360079EAAE7042048B2F5AC8FFAB0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 02:32:26AM +0000, Andy Duan wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> > On Mon, Aug 19, 2019 at 05:11:14PM +0000, Marco Hartmann wrote:
> > > As of yet, the Fast Ethernet Controller (FEC) driver only supports
> > > Clause 22 conform MDIO transactions. IEEE 802.3ae Clause 45 defines a
> > > modified MDIO protocol that uses a two staged access model in order to
> > > increase the address space.
> > >
> > > This patch adds support for Clause 45 conform MDIO read and write
> > > operations to the FEC driver.
> > 
> > Hi Marco
> > 
> > Do all versions of the FEC hardware support C45? Or do we need to make use
> > of the quirk support in this driver to just enable it for some revisions of FEC?
> > 
> > Thanks
> >         Andrew
> 
> i.MX legacy platforms like i.MX6/7 series, they doesn't support Write & Read Increment.
> But for i.MX8MQ/MM series, it support C45 full features like Write & Read Increment.
> 
> For the patch itself, it doesn't support Write & Read Increment, so I think the patch doesn't
> need to add quirk support.

Hi Andy

So what happens with something older than a i.MX8MQ/MM when a C45
transfer is attempted? This patch adds a new write. Does that write
immediately trigger a completion interrupt? Does it never trigger an
interrupt, and we have to wait FEC_MII_TIMEOUT?

Ideally, if the hardware does not support C45, we want it to return
EOPNOTSUPP.

Thanks
	Andrew
