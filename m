Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10431CCCE4
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgEJSXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:23:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgEJSXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+wTTue85UKK8u9gn7iF3cdOlcPbNDEBhdVWO2JXxlzQ=; b=TRP5b82QvDQqP2q2KFGoHfEjS7
        tKugHCr0QpNjSAXmyl1xI0rg4Nz+Orp14NRtOGECL1p1jMI6KJr6XhU5rbYTcQt/B2LFzIOyAjWT8
        FVpG+lIR4UM+qhK3ixVz3jhAUliTrUSVKeWdqnzwF42i/c42Wd/CaApnOfY+tJRE/RH4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXqbE-001jJC-SH; Sun, 10 May 2020 20:22:52 +0200
Date:   Sun, 10 May 2020 20:22:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200510182252.GA411829@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
 <20200509162851.362346-7-andrew@lunn.ch>
 <20200510151226.GI30711@lion.mk-sys.cz>
 <20200510160758.GN362499@lunn.ch>
 <20200510110013.0ae22016@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510110013.0ae22016@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 11:00:13AM -0700, Jakub Kicinski wrote:
> On Sun, 10 May 2020 18:07:58 +0200 Andrew Lunn wrote:
> > On Sun, May 10, 2020 at 05:12:26PM +0200, Michal Kubecek wrote:
> > > On Sat, May 09, 2020 at 06:28:47PM +0200, Andrew Lunn wrote:  
> > > > Provide infrastructure for PHY drivers to report the cable test
> > > > results.  A netlink skb is associated to the phydev. Helpers will be
> > > > added which can add results to this skb. Once the test has finished
> > > > the results are sent to user space.
> > > > 
> > > > When netlink ethtool is not part of the kernel configuration stubs are
> > > > provided. It is also impossible to trigger a cable test, so the error
> > > > code returned by the alloc function is of no consequence.
> > > > 
> > > > v2:
> > > > Include the status complete in the netlink notification message
> > > > 
> > > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>  
> > > 
> > > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> > > 
> > > It seems you applied the changes to ethnl_cable_test_alloc() suggested
> > > in v2 review as part of patch 7 rather than here. I don't think it's
> > > necessary to fix that unless there is some actual problem that would
> > > require a resubmit.  
> > 
> > Hi Michal
> > 
> > Yes, squashed it into the wrong patch. But since all it does it change
> > one errno for another, it is unlikely to break bisect. As i agree, we
> > can live with this.
> 
> Sorry Andrew, would you mind doing one more quick spin? :(

No problem.

> More importantly we should not use the ENOTSUPP error code, AFAIU it's
> for NFS, it's not a standard error code and user space struggles to
> translate it with strerror(). Would you mind replacing all ENOTSUPPs
> with EOPNOTSUPPs?

O.K.

Would it be worth getting checkpatch warning about this?

      Andrew
