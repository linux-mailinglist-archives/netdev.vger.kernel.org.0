Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8400F43CF7A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhJ0RLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239323AbhJ0RLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 13:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F198860230;
        Wed, 27 Oct 2021 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635354539;
        bh=u63jCG7PKoPnj5a6mybY0lrZ4Jl2BniZJ7hpbW4xXO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ExF7H//8pMJigLax08dw2fMG0q4nxEUHGellfj5okQ/540hY13iXyxpXuW9EeAbJ9
         pfS46kN50M0RmZPmZ5DFPxUuOrY5VwN0VI+DvqGuzx5AMkhQ12aESsyFFtlmDBNWdW
         PzBZYC6w0jS8I0QEGEWX6Jvqqe+YgjsG3Hy+pb20dk/hRWSDV0IS8/E6yH+yo3r4mp
         k1ZZowWzcp/v0p6UhkDR1N86muZZLKydnw3lvqa3Vg4Bapt2EQ3hGNjGAqVB/3+oSS
         /hE6SZo1G/P9Dgd4mzaXP8N2h6Xwoh3zT6GesKfvbbx9k26+zPKBKLxMoNkC0OYRV0
         bpI9fByaoP3qQ==
Date:   Wed, 27 Oct 2021 10:08:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
        <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
        <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
        <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 22:13:32 +0530 sundeep subbaraya wrote:
> > On Wed, 27 Oct 2021 16:01:14 +0530 Subbaraya Sundeep wrote:  
> > > From: Rakesh Babu <rsaladi2@marvell.com>
> > >
> > > The physical/SerDes link of an netdev interface is not
> > > toggled on interface bring up and bring down. This is
> > > because the same link is shared between PFs and its VFs.
> > > This patch adds devlink param to toggle physical link so
> > > that it is useful in cases where a physical link needs to
> > > be re-initialized.  
> >
> > So it's a reset? Or are there cases where user wants the link
> > to stay down?  
> 
> There are cases where the user wants the link to stay down and debug.
> We are adding this to help customers to debug issues wrt physical links.

Intel has a similar thing, they keep adding a ethtool priv flag called 
"link-down-on-close" to all their drivers. Maybe others do this, too. 
It's time we added a standard API for this.
