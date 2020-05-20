Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654021DAE5B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgETJIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgETJIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 05:08:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDC8D206C3;
        Wed, 20 May 2020 09:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589965714;
        bh=XVcmCQtaYx8kTRfRKrA5z4WhelWdxVwUz/By4bYz8mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D7shveYktKRGUZbiQBcv1JyC7ruKdWkpD5T/OCgj5F60Tt2UoEca8Lc4Om+mNiTWd
         1IBOeeYf2AZQhh9aP5O6Q3D9CKUp2SjDgRKBCfaJfkkKTDcIHgcS5ms0M8cU909tlA
         66qR4JQ9PXgGJtT73W7C+T/EcA+aZgpb8m7DfYLE=
Date:   Wed, 20 May 2020 11:08:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: Re: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-19
Message-ID: <20200520090832.GG2837844@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520071707.GA2365898@kroah.com>
 <61CC2BC414934749BD9F5BF3D5D94044986C2E05@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986C2E05@ORSMSX112.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 07:25:39AM +0000, Kirsher, Jeffrey T wrote:
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, May 20, 2020 00:17
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> > rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> > jgg@ziepe.ca; parav@mellanox.com; galpress@amazon.com;
> > selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> > benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> > yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> > aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> > louis.bossart@linux.intel.com
> > Subject: Re: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN Driver
> > Updates 2020-05-19
> > 
> > On Wed, May 20, 2020 at 12:02:15AM -0700, Jeff Kirsher wrote:
> > > This series contains the initial implementation of the Virtual Bus,
> > > virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the
> > > new Virtual Bus.
> > >
> > > The primary purpose of the Virtual bus is to put devices on it and
> > > hook the devices up to drivers.  This will allow drivers, like the
> > > RDMA drivers, to hook up to devices via this Virtual bus.
> > >
> > > The associated irdma driver designed to use this new interface, is
> > > still in RFC currently and was sent in a separate series.  The latest
> > > RFC series follows this series, named "Intel RDMA Driver Updates 2020-05-
> > 19".
> > >
> > > This series currently builds against net-next tree.
> > >
> > > Revision history:
> > > v2: Made changes based on community feedback, like Pierre-Louis's and
> > >     Jason's comments to update virtual bus interface.
> > > v3: Updated the virtual bus interface based on feedback from Jason and
> > >     Greg KH.  Also updated the initial ice driver patch to handle the
> > >     virtual bus changes and changes requested by Jason and Greg KH.
> > > v4: Updated the kernel documentation based on feedback from Greg KH.
> > >     Also added PM interface updates to satisfy the sound driver
> > >     requirements.  Added the sound driver changes that makes use of the
> > >     virtual bus.
> > 
> > Why didn't you change patch 2 like I asked you to?
> > 
> > And I still have no idea why you all are not using the virtual bus in the "ice"
> > driver implementation.  Why is it even there if you don't need it?  I thought that
> > was the whole reason you wrote this code, not for the sound drivers.
> > 
> > How can you get away with just using a virtual device but not the bus?
> > What does that help out with?  What "bus" do those devices belong to?
> > 
> > Again, please fix up patch 2 to only add virtual device/bus support to, right now
> > it is just too much of a mess with all of the other functionality you are adding in
> > there to be able to determine if you are using the new api correctly.
> > 
> > And again, didn't I ask for this last time?
> [Kirsher, Jeffrey T] 
> 
> We apologize, but last submission you only commented on the first patch and the documentation.

It's as if I am shouting into the wind...

{sigh} : https://lore.kernel.org/linux-rdma/20200507081737.GC1024567@kroah.com/


Ok, as the above text was too kind and nice and not explicit enough, let
me try this again:

  - this patch series makes no sense to me in that you are creating
    a virtual bus, but not using it in your driver at all.  Why create
    it at all then?
  - If a virtual device can be used without a virtual driver, what
    driver binds to that device, and what "bus" does it live on?
  - This patch 2 is a total mess of new functionality and virtual device
    additions, making it impossible to review.  Please split it up into
    tiny, easy to understand and review pieces.
  - Why is there sound driver code being submitted to netdev?  This
    virtual bus code should stand on-its-own, and if it is not needed,
    then let the code that adds it come in through a patch series that
    actually needs it (i.e. the sound code.)
  - As I can't understand how you are using the virtual bus/dev code as
    I can't review patch 2, I have no idea if patch 1 is even written
    correctly.

So, your action items now are:
	- make patch 2 sane, in tiny pieces, and use the virtual bus
	  code.
	- review the documentation on patch 1 to see if it actually
	  makes sense (i.e. get a s-o-b from another kernel developer
	  who has never seen it before).
	- if patch 2 does not need the virtual bus code, explain the
	  heck out of it as to why that is so, and where the driver and
	  bus lives instead, when you add support for that code to patch
	  2 (as part of the split up patch series).
	- stop sending these patches out as a "pull request" for netdev
	  maintainers to pull from.  Get my ack on them all before you
	  even attempt to get a networking maintainer's review to be
	  included in their tree.  By doing this you are making me jump
	  in order to keep from this code getting merged before it
	  should be, which just makes me grumpy (as you would be if you
	  were in my position here.)
	- send Greg a bottle of good whisky in penance for wasting all
	  of his time with these reviews that seem to be ignored.
	  Expense it to Intel, it's the least they could do.

Sound reasonable?

greg k-h
