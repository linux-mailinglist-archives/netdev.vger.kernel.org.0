Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF8B30FBFB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbhBDSvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:51:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239432AbhBDSvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 13:51:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E4464DE1;
        Thu,  4 Feb 2021 18:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612464637;
        bh=wQVyhdRNYLOtfcHYPyHdQOe6nKL416vQhusWYRh1wiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X6/K4PGGKz3sz6w2EJunmSU7nF8z8M6MWKYtJWWvpbW6pigiEWGNnboeaOjGvwPFX
         3Kw2V3FQxxKJhIVWfZcr3YyWY9MS2p7agYzmu3Qjy7LbDxsW2+N7PeTZmkI13cSr6L
         IWPI4Rg7vlJ5FxFsH8t6JXaM96jndNBnIhZLsmPW9H+EoOs6x4ya7NKIrbxL24cNnD
         m9VYp00Bm5fgLFBvYsTE8Gkuw/kyemb5kEwbet2o6w51RuaXGVbo3OyjEK4txgYrWC
         92zfTvN+gzEzVxN72YOq+knVp5Ad3iN9xwoHO15GXeDkvh9oXJ/XmyO+UeiuRo8j/N
         S9nql31lDQLAA==
Date:   Thu, 4 Feb 2021 10:50:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Message-ID: <20210204105036.0e6cd8a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MWHPR18MB142117DBE8659D68794E18D3DEB39@MWHPR18MB1421.namprd18.prod.outlook.com>
References: <MWHPR18MB142117DBE8659D68794E18D3DEB39@MWHPR18MB1421.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 17:37:41 +0000 Hariprasad Kelam wrote:
> > > +	req->args.speed = req_ks.base.speed;
> > > +	/* firmware expects 1 for half duplex and 0 for full duplex
> > > +	 * hence inverting
> > > +	 */
> > > +	req->args.duplex = req_ks.base.duplex ^ 0x1;
> > > +	req->args.an = req_ks.base.autoneg;
> > > +	otx2_get_advertised_mode(&req_ks, &req->args.mode);  
> > 
> > But that only returns the first bit set. What does the device actually do? What
> > if the user cleared a middle bit?
> >   
> This is initial patch series to support advertised modes. Current firmware design is such that
> It can handle only one advertised mode. Due to this limitation we are always checking
> The first set bit in advertised modes and passing it to firmware.
> Will add multi advertised mode support in near future.

Looking at patch 6 it seems like the get side already supports multiple
modes, although the example output only lists supported no advertised.

Is the device actually doing IEEE autoneg or just configures the speed,
lanes etc. according to the link mode selected?
