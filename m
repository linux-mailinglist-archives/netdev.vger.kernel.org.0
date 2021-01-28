Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511B0306D11
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 06:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhA1FmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 00:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229513AbhA1FmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 00:42:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A39E964DD1;
        Thu, 28 Jan 2021 05:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611812497;
        bh=6i5eEl7Z+gxRlXOfBW8szNzI4w5PYPyFPPyK19Mvr1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oszG4Loq4wqxah30uskOJqLnTWTSmGWaXFM0tFSk5lURhwAlrXXdQzC+mS/X/c9j+
         cMxS1eVFk+usOjaR3NeiOM+TLRIzAbXm1kPE2cIZLBO7xVrePrOh0bAFE3eNE8AKVL
         KOoCtc9UfBc3ittAl+GGwZGNtzCfGl9SYI6M0YkzRaBlWw1Rz0mXaxs4rNbgp+SOef
         osPFfOKoaP5/4mCphMku3HJbZs8TCdsN8z1qrQJcgarQc+wl/8+G/hB42LkhO31wiF
         aXsgpGRdEE59E07oj4u69hEZI0ZmKJY4o889NDp98h4ccQZ9KuFAjxX/K/HLnc84ut
         Vv5n9ItOK8Ddg==
Date:   Thu, 28 Jan 2021 07:41:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210128054133.GA1877006@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127231641.GS4147@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
>
> > Even with another core PCI driver, there still needs to be private
> > communication channel between the aux rdma driver and this PCI
> > driver to pass things like QoS updates.
>
> Data pushed from the core driver to its aux drivers should either be
> done through new callbacks in a struct device_driver or by having a
> notifier chain scheme from the core driver.

Right, and internal to driver/core device_lock will protect from
parallel probe/remove and PCI flows.

I would say that all this handmade register/unregister and peer_client
dance will be gone if driver would use properly auxbus.

Thanks

>
> Jason
