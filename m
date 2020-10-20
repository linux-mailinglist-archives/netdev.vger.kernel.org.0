Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDDE29404B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394507AbgJTQOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394501AbgJTQOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 12:14:44 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D4522224A;
        Tue, 20 Oct 2020 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603210484;
        bh=GH5eLxFTIak/Bl39mkFyPnKqsM5t7joc+f3vvBIjjzs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X/Dm/TF/p/o/v790VzKzgi5JdH9WH3frVzAgXrYVIoZdvtXYul2P07y5uz9L/hK7H
         oQmgzgZ4o7QT4FVP4CBkJRnXJkVIvSp+6uSN1kZPJLytHCnOMEZGI1VhczR+8EyoVt
         Hgvvs0NvIp7RH9w2oP8dZ7+yuE+z438TOmqhl190=
Date:   Tue, 20 Oct 2020 18:14:38 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: [PATCH russell-kings-net-queue v2 2/3] net: phy: sfp: add
 support for multigig RollBall modules
Message-ID: <20201020181438.1b3e972a@kernel.org>
In-Reply-To: <20201020155126.GH139700@lunn.ch>
References: <20201020150615.11969-1-kabel@kernel.org>
        <20201020150615.11969-3-kabel@kernel.org>
        <20201020155126.GH139700@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 17:51:26 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > @@ -2006,6 +2040,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
> >  
> >  	sfp->id = id;
> >  
> > +	sfp->phy_addr = SFP_PHY_ADDR;
> > +
> > +	rollball = ((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
> > +		     !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> > +		    (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> > +		     !memcmp(id.base.vendor_pn, "RTSFP-10", 8)));  
> 
> Are you customising the SFP, so that it has your vendor name?
> 
> Is the generic SFP OEM/SFP-10G-T, and your customized one Turris/ 
> RTSFP-10?
> 
> 	Andrew

Hilink puts OEM/SFP-10G-T into their modules.
RollBall puts OEM/RTSFP-10 and sometimes OEM/RTSFP-10G.
They are rebranding these modules for us to Turris/RTSFP-10.

Marek
