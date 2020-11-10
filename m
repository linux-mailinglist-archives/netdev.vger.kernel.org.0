Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0731B2ACAA5
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgKJBpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJBpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:45:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCBE32065D;
        Tue, 10 Nov 2020 01:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604972744;
        bh=T/Yvdn05BT4307DEEQ9E5rEvZJroGKLL5DOaAa585HU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r6H4+Y0Um3d/31K8MM18H8XDm5+VIIPbGR/3D3/qxSq/S2ZLwywc5pvJx1n6o9iZf
         0a2ze+27zNiFDIdQO4JtFE1c4H3HnLm5ZKHfh3x3wi6+xEnLvbRYRDAI6WIrqm7+P2
         aRCCp5hoVTTsb5ZP4YZ+xx3Q0dxOhyAKVIsyK/pQ=
Date:   Mon, 9 Nov 2020 17:45:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Export VTU as devlink
 region
Message-ID: <20201109174542.2ab6a3dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109174415.GD1456319@lunn.ch>
References: <20201109082927.8684-1-tobias@waldekranz.com>
        <20201109174415.GD1456319@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 18:44:15 +0100 Andrew Lunn wrote:
> >  static void
> > @@ -574,9 +670,16 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
> >  		ops = mv88e6xxx_regions[i].ops;
> >  		size = mv88e6xxx_regions[i].size;
> >  
> > -		if (i == MV88E6XXX_REGION_ATU)
> > +		switch (i) {
> > +		case MV88E6XXX_REGION_ATU:
> >  			size = mv88e6xxx_num_databases(chip) *
> >  				sizeof(struct mv88e6xxx_devlink_atu_entry);
> > +			break;
> > +		case MV88E6XXX_REGION_VTU:
> > +			size = chip->info->max_vid *
> > +				sizeof(struct mv88e6xxx_devlink_vtu_entry);
> > +			break;
> > +		}  
> 

[...]

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
