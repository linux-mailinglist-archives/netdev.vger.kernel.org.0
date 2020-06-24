Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329F1207A29
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405427AbgFXRXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405318AbgFXRXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 13:23:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 704262078D;
        Wed, 24 Jun 2020 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593019380;
        bh=AruxempfFOX1uXZ4o3BIVHKefonN71PcsL1N0+hQM+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ImfkwyVLSK6+CHis4HDZpZqjOTJxc5FXIkpjeRAwLmvZc3xZllAY0OhTaLfd/IPyb
         ghagNY3WCycW8U0eznyrwcja/HH8Te3Z2MfdBQVxL+0DSMR6ibnnxIv3RpFo+pXMww
         x6AKjARMXT0ZJYrsLkJppcp53328LrHqI76MGfOI=
Date:   Wed, 24 Jun 2020 10:22:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, linux-pci@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed
 ordering
Message-ID: <20200624102258.4410008d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <082c6bfe-5146-c213-9220-65177717c342@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
        <20200623195229.26411-11-saeedm@mellanox.com>
        <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
        <082c6bfe-5146-c213-9220-65177717c342@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 10:34:40 +0300 Aya Levin wrote:
> >> I think Michal will rightly complain that this does not belong in
> >> private flags any more. As (/if?) ARM deployments take a foothold
> >> in DC this will become a common setting for most NICs.  
> > 
> > Initially we used pcie_relaxed_ordering_enabled() to
> >   programmatically enable this on/off on boot but this seems to
> > introduce some degradation on some Intel CPUs since the Intel Faulty
> > CPUs list is not up to date. Aya is discussing this with Bjorn.  
> Adding Bjorn Helgaas

I see. Simply using pcie_relaxed_ordering_enabled() and blacklisting
bad CPUs seems far nicer from operational perspective. Perhaps Bjorn
will chime in. Pushing the validation out to the user is not a great
solution IMHO.

> > So until we figure this out, will keep this off by default.
> > 
> > for the private flags we want to keep them for performance analysis as
> > we do with all other mlx5 special performance features and flags.
