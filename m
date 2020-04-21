Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92B1B21A0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgDUIaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgDUIaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:30:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950CF2084D;
        Tue, 21 Apr 2020 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587457806;
        bh=vsiOnnLYbbBCAd4J6fXIOLziqke0F8QVm3amieyYgzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xRJbIQCnSEfRnHfgR0eDiv6NHRtYCm/pqm4s6rjx7QQtBYFyc8iqkO5avAKz85cP9
         YoVl2EL+OPsWDnZtGzcK8Lt4igQQTDV0yTTAmRbX7MU197QEU0rSwC7KVVZTv5TDtp
         lI4QvgMjlCdgYQM0iUd1UGn+kmlDhd/Xoafbok80=
Date:   Tue, 21 Apr 2020 10:30:04 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
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
Subject: Re: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
Message-ID: <20200421083004.GB716720@kroah.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <61CC2BC414934749BD9F5BF3D5D940449866D71D@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D940449866D71D@ORSMSX112.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 08:15:59AM +0000, Kirsher, Jeffrey T wrote:
> > -----Original Message-----
> > From: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Sent: Tuesday, April 21, 2020 01:02
> > To: davem@davemloft.net; gregkh@linuxfoundation.org
> > Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org;
> > linux-rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> > jgg@ziepe.ca; parav@mellanox.com; galpress@amazon.com;
> > selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> > benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> > yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> > aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> > louis.bossart@linux.intel.com
> > Subject: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver Updates
> > 2020-04-20
> > 
> > This series contains the initial implementation of the Virtual Bus, virtbus_device,
> > virtbus_driver, updates to 'ice' and 'i40e' to use the new Virtual Bus.
> > 
> > The primary purpose of the Virtual bus is to put devices on it and hook the
> > devices up to drivers.  This will allow drivers, like the RDMA drivers, to hook up
> > to devices via this Virtual bus.
> > 
> > This series currently builds against net-next tree.
> > 
> > Revision history:
> > v2: Made changes based on community feedback, like Pierre-Louis's and
> >     Jason's comments to update virtual bus interface.
> [Kirsher, Jeffrey T] 
> 
> David Miller, I know we have heard from Greg KH and Jason Gunthorpe on the patch
> series and have responded accordingly, I would like your personal opinion on the
> patch series.  I respect your opinion and would like to make sure we appease all the
> maintainers and users involved to get this accepted into the 5.8 kernel.

Wait, you haven't gotten my ack on that code, why are you asking for it
to be merged already???

{sigh}

greg k-h
