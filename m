Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803065F81C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfGDM3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfGDM3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:29:55 -0400
Received: from localhost (unknown [89.205.128.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CFDB20673;
        Thu,  4 Jul 2019 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562243394;
        bh=cCA734VwPTICEaI1cmL5+rdDiipXZEg0/8PoB29Wtek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BW/VwhEpy7xItdMoud2x9A4L/D196EuzHEmR+FKfdvcBeJ7dzqgt9VqXNte3QlywX
         WS5PjUxkXsaRB1WqshDoTW1tmwj30TFxVWVqYH8nT0xBYHTYeb0FU1tGy3pCl7SmvF
         sgvJZRPmww3SZqknHO/eV8IYduPV1nQifV7nmW7w=
Date:   Thu, 4 Jul 2019 14:29:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Message-ID: <20190704122950.GA6007@kroah.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704121632.GB3401@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > 
> > The RDMA block does not advertise on the PCI bus or any other bus.
> > Thus the ice driver needs to provide access to the RDMA hardware block
> > via a virtual bus; utilize the platform bus to provide this access.
> > 
> > This patch initializes the driver to support RDMA as well as creates
> > and registers a platform device for the RDMA driver to register to. At
> > this point the driver is fully initialized to register a platform
> > driver, however, can not yet register as the ops have not been
> > implemented.
> 
> I think you need Greg's ack on all this driver stuff - particularly
> that a platform_device is OK.

A platform_device is almost NEVER ok.

Don't abuse it, make a real device on a real bus.  If you don't have a
real bus and just need to create a device to hang other things off of,
then use the virtual one, that's what it is there for.

thanks,

greg k-h
