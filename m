Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489602B8A06
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 03:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbgKSCO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 21:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgKSCO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 21:14:26 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E1A246B5;
        Thu, 19 Nov 2020 02:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605752065;
        bh=s65eomXoth173lx3IsI0oIEDLCbBX4gTRbWURxjy9cI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kgtA4WOGfnOoDmWdDcamKNe4NQAx584obD4P71XlmG71sw2S3WwGqQspqk/ZK7hPa
         AVSQhZ/qetClkKQigHeDMhcMlp+p8d/AGAyODAVbTX3kN2fo8wEIt7sUs8EiRVlcTN
         xh6UXNdrRMsOeLGpslZOoqkQluYmR59elIoYThg0=
Date:   Wed, 18 Nov 2020 18:14:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117184954.GV917484@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201117184954.GV917484@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
> On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
> 
> > > Just to refresh all our memory, we discussed and settled on the flow
> > > in [2]; RFC [1] followed this discussion.
> > > 
> > > vdpa tool of [3] can add one or more vdpa device(s) on top of already
> > > spawned PF, VF, SF device.  
> > 
> > Nack for the networking part of that. It'd basically be VMDq.  
> 
> What are you NAK'ing? 

Spawning multiple netdevs from one device by slicing up its queues.

> It is consistent with the multi-subsystem device sharing model we've
> had for ages now.
> 
> The physical ethernet port is shared between multiple accelerator
> subsystems. netdev gets its slice of traffic, so does RDMA, iSCSI,
> VDPA, etc.

Right, devices of other subsystems are fine, I don't care.

Sorry for not being crystal clear but quite frankly IDK what else can
be expected from me given the submissions have little to no context and
documentation. This comes up every damn time with the SF patches, I'm
tired of having to ask for a basic workflow.
