Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39262B8A0E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 03:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKSCXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 21:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbgKSCXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 21:23:21 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0199622202;
        Thu, 19 Nov 2020 02:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605752600;
        bh=5LppGWHxFo/NEqVsTAKTLLiwBp8s7Av+9Kmo2PYqnFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vmOF0Cncvkkwgw5BSUzrXrK6NCa4V6QCiVLQ/XWw2G2t331tdLqL7DhnNniLUqW5o
         PmXDRJ3Z46ck6TtoSJCsQd87juAGb/xBxnJtC6qgUImlrIBKV23gEnWSvmcUvqo2Tm
         zQZ2DbiXXvd4y3v+p5hGhueQfY8hEALbh0WLO4xg=
Date:   Wed, 18 Nov 2020 18:23:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 18:50:57 +0000 Parav Pandit wrote:
> At this point vdpa tool of [1] can create one or more vdpa net devices on this subfunction device in below sequence.
> 
> $ vdpa parentdev list
> auxiliary/mlx5_core.sf.4
>   supported_classes
>     net
> 
> $ vdpa dev add parentdev auxiliary/mlx5_core.sf.4 type net name foo0
> 
> $ vdpa dev show foo0
> foo0: parentdev auxiliary/mlx5_core.sf.4 type network parentdev vdpasim vendor_id 0 max_vqs 2 max_vq_size 256
> 
> > I'm asking how the vdpa API fits in with this, and you're showing me the two
> > devlink commands we already talked about in the past.  
> Oh ok, sorry, my bad. I understood your question now about relation of vdpa commands with this.
> Please look at the above example sequence that covers the vdpa example also.
> 
> [1] https://lore.kernel.org/netdev/20201112064005.349268-1-parav@nvidia.com/

I think the biggest missing piece in my understanding is what's the
technical difference between an SF and a VDPA device.

Isn't a VDPA device an SF with a particular descriptor format for the
queues?
