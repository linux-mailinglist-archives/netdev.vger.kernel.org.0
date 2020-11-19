Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEFF2B8B6E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 07:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgKSGMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 01:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgKSGMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 01:12:24 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E562469D;
        Thu, 19 Nov 2020 06:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605766343;
        bh=EMwAU+PKwI7LGEKTzbsmROHCGamV0k1Ogm7FOaFnXxs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n0KUUnmSLASbcaIjW7Eoo3np26UDrNo5/EUID3COlEXhvKwWnMUTYGmgdpDyH4V7L
         808j9sDRCBJ3jnrPiO58/sTVeYC8z89BhpH9Tajhwrre3RWMXEgBJK0AQES57JzTP8
         eXfSskeBLQbdW33ZqdWuJNG2HFff+n3gWpDQaW6A=
Message-ID: <533a8308c25b62d213990e5a7e44562f4dc7b66f.camel@kernel.org>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Wed, 18 Nov 2020 22:12:22 -0800
In-Reply-To: <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201112192424.2742-1-parav@nvidia.com>
         <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
         <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <20201117184954.GV917484@nvidia.com>
         <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 18:14 -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
> > On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
> > 
> > It is consistent with the multi-subsystem device sharing model
> > we've
> > had for ages now.
> > 
> > The physical ethernet port is shared between multiple accelerator
> > subsystems. netdev gets its slice of traffic, so does RDMA, iSCSI,
> > VDPA, etc.

not just a slice of traffic, a whole HW domain.

> 
> Right, devices of other subsystems are fine, I don't care.
> 

But a netdev will be loaded on SF automatically just through the
current driver design and modularity, since SF == VF and our netdev is
abstract and doesn't know if it runs on a PF/VF/SF .. we literally have
to add code to not load a netdev on a SF. why ? :/

> Sorry for not being crystal clear but quite frankly IDK what else can
> be expected from me given the submissions have little to no context
> and
> documentation. This comes up every damn time with the SF patches, I'm
> tired of having to ask for a basic workflow.

From how this discussion is going, i think you are right, we need to
clarify what we are doing in a more high level simplified and generic
documentation to give some initial context, Parav, let's add the
missing documentation, we can also add some comments regarding how this
is very different from VMDq, but i would like to avoid that, since it
is different in almost every way:) .. 

