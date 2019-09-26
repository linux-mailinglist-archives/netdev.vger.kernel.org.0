Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AFDBF8CD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfIZSF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727934AbfIZSF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:05:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7131A21A4A;
        Thu, 26 Sep 2019 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569521158;
        bh=WS6JHm5RIAeOO5mY0UJvuqR3lEGtZztvNEcr2ZMIGWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UYM4RVuO3n/Fi5I4/H5Fd++R/MA6CwCbTtiicHd3yqLWLoxgGdlI+FgiW1HLzYh48
         M/S2vYk6DLpntPpZfCp0zQX3DPxGvXQ8t2vKsOuPKKWziG3O1fGD9IsDWKyFl7fXJW
         u1gnMjBySCSBBCiInQoZoOPWnjjENzcLIj1t1ZSc=
Date:   Thu, 26 Sep 2019 20:05:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Dave Ertman <david.m.ertman@intel.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20190926180556.GB1733924@kroah.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:45:00AM -0700, Jeff Kirsher wrote:
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> The RDMA block does not advertise on the PCI bus or any other bus.

Huh?  How do you "know" where it is then?  Isn't is usually assigned to
a PCI device?

> Thus the ice driver needs to provide access to the RDMA hardware block
> via a virtual bus; utilize a multi-function device to provide this access.
> 
> This patch initializes the driver to support RDMA as well as creates
> and registers a multi-function device for the RDMA driver to register to.
> At this point the driver is fully initialized to register a platform
> driver, however, can not yet register as the ops have not been
> implemented.
> 
> We refer to the interaction of this platform device as Inter-Driver
> Communication (IDC); where the platform device is referred to as the peer
> device and the platform driver is referred to as the peer driver.

Again, no platform devices, unless it REALLY IS a platform device (i.e.
you are using device tree or platform data to find it.)  Is that what
you are doing here?

confused,

greg k-h
