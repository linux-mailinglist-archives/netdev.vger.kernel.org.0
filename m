Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD070217
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfGVOTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:19:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbfGVOTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 10:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w7liDE+E5Iu1xIHWqacl7h46/XlirlaNe/zw3/PBWCk=; b=qVOsFplGBuYk4ymZhAgzpL6i71
        /wdEDJ7Aejf42R92mP3bplohaTlECg+3Zv96yKTaZH25VSn4ERUgQoNInz2f9W2vbWPA/xWF5eOhP
        wUqPRaw0PMeLwHs3cj+Kw721melKrgtIO8rh8GvT5oTpSXOVQHFujFs7hLu3G+18ikIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpZAF-0003Dn-Fp; Mon, 22 Jul 2019 16:19:43 +0200
Date:   Mon, 22 Jul 2019 16:19:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     =?utf-8?Q?Ond=C5=99ej?= Jirman <megi@xff.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Message-ID: <20190722141943.GE8972@lunn.ch>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
 <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722134023.GD8972@lunn.ch>
 <BN8PR12MB3266678A3ABD0EBF429C9766D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266678A3ABD0EBF429C9766D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 01:58:20PM +0000, Jose Abreu wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Jul/22/2019, 14:40:23 (UTC+00:00)
> 
> > Does this mean that all stmmac variants support 1G? There are none
> > which just support Fast Ethernet?
> 
> This glue logic drivers sometimes reflect a custom IP that's Synopsys 
> based but modified by customer, so I can't know before-hand what's the 
> supported max speed. There are some old versions that don't support 1G 
> but I expect that PHY driver limits this ...

If a Fast PHY is used, then yes, it would be limited. But sometimes a
1G PHY is used because they are cheaper than a Fast PHY.
 
> > I'm also not sure the change fits the problem. Why did it not
> > negotiate 100FULL rather than 10Half? You are only moving the 1G
> > speeds around, so 100 speeds should of been advertised and selected.
> 
> Hmm, now that I'm looking at it closer I agree with you. Maybe link 
> partner or PHY doesn't support 100M ?

In the working case, ethtool shows the link partner supports 10, 100,
and 1G. So something odd is going on here.

You fix does seems reasonable, and it has been reported to fix the
issue, but it would be good to understand what is going on here.

    Andrew
