Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D689D1763FA
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCBTbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBTbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:31:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35FD82084E;
        Mon,  2 Mar 2020 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583177469;
        bh=EuJ5sUlja1CELple3+kpsbLdUOG/2PNmTZzvEsBPMKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=awiz1o7xvNe+WVjlaywbmbnV63cp7eXlzIBC6iAwUaxRh1YxvJp20fTYF+Ayg+ngW
         gc6+xJIUPjHrdspQZ4CCzIvFM4grenpaJ7XNVJkcvFSnsXtH+Xw2Z8b5SM/mEHQpoT
         oqNq7ZSU3HdeZqd1VqWaA8Ji2KgwbJZni0xIW4cw=
Date:   Mon, 2 Mar 2020 11:31:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: Re: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Message-ID: <20200302113107.479f3171@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <646c4248586b419fd9ca483aa13fb774d8b08195.camel@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
        <20200228004446.159497-9-saeedm@mellanox.com>
        <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <646c4248586b419fd9ca483aa13fb774d8b08195.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020 18:48:22 +0000 Saeed Mahameed wrote:
> On Fri, 2020-02-28 at 11:10 -0800, Jakub Kicinski wrote:
> > On Thu, 27 Feb 2020 16:44:38 -0800 Saeed Mahameed wrote:  
> > > The size of each large group can be calculated according to the
> > > following
> > > formula: size = 4M / (fdb_large_groups + 1).
> >
> > Slicing memory up sounds like something that should be supported via
> > the devlink-resource API, not by params and non-obvious calculations
> > :(  
> 
> Hi Jakub, you have a point, but due to to the non-triviality of the
> internal mlnx driver and FW architecture of handling internal FDB table
> breakdown, we preferred to go with one driver-specific parameter to
> simplify the approach, instead of 3 or 4 generic params, which will not
> make any sense to other vendors for now.

Actually I was hoping this can be made into some resource attribute,
rather than a generic parameter. The formula in the commit message looks
very much like there is a resource of 4M "things" which is subdivided
into "large groups".

Maybe if Jiri acked it it's not a great fit.

> As always we will keep an eye on what other vendors are doing and will
> try to unify with a generic set of params once other vendors show
> interest of a similar thing.

Ah, yes :)
