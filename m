Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4551DD4B0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgEURoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728542AbgEURoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AB41207F7;
        Thu, 21 May 2020 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590083040;
        bh=6nyP9nRABbr9I/+R+8UXncPfsESo3IVTz5PwLOZXbYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oP+78MBQZdAXiAp3ysB221UvjLOUd6vfKMJKlmeazoSG+cAcWSAEhfHEW49jnoAUQ
         PLkSMVv6px48fpaC1JdmBUdKUGLUEodyiZTCN3nNphL9nXBbkAV9kdLQhUh2pwV3gQ
         DW/5wIfuOqYSvJiepgHONkcH3VqKchhB8vK8hebU=
Date:   Thu, 21 May 2020 19:43:58 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v4 01/12] Implementation of Virtual Bus
Message-ID: <20200521174358.GA3679752@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-2-jeffrey.t.kirsher@intel.com>
 <c74808dc-0040-7cef-a0da-0da9caedddd9@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c74808dc-0040-7cef-a0da-0da9caedddd9@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 02:57:55PM +0000, Parav Pandit wrote:
> Hi Greg, Jason,
> 
> On 5/20/2020 12:32 PM, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> > 
> 
> > +static const
> > +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
> > +					struct virtbus_device *vdev)
> > +{
> > +	while (id->name[0]) {
> > +		if (!strcmp(vdev->match_name, id->name))
> > +			return id;
> 
> Should we have VID, DID based approach instead of _any_ string chosen by
> vendor drivers?

No, because:

> This will required central place to define the VID, DID of the vdev in
> vdev_ids.h to have unique ids.

That's not a good way to run things :)

Have the virtbus core create the "name", as it really doesn't matter
what it is, just that it is unique, right?

thanks,

greg k-h
