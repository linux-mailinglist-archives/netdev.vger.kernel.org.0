Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363EAE2208
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbfJWRow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:44:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35400 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730513AbfJWRow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:44:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15so33610533qtq.2
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 10:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qFewDq5bPCn8gTmOC4SGcav3DEG85WI+XIcYsQdAE7U=;
        b=pG2uhmNcL8wYNBu+GctIkDy/CRVvgGpP+k0nm5S+WDxUzqvoft4VIalcdl1nPVUxiR
         khmVBNs2LzDznMPShV7wcXvKW88/v123jNFZLuhleGd1zSD4PSkq/HsNArSCPfnkiF7B
         Rto9oDhwvl6aNQi8GIoejo+VdQBUYnHWTpJtHGQ6duzbQDmA+Pp5Yk6e/mBt3+csrPJl
         +TjUfVl9aNHem5/ODC56xlUnxk1vrqUuyTg0FSYEAtuMvY198D3YG2SC3u4qPxU9+OW8
         RdoDISqpuadS1u3CgLo4SYJUB2fvoS0tA6mjlDY6/0HJz6fNPQY4UnpcY3tfOyeRMYLN
         237A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qFewDq5bPCn8gTmOC4SGcav3DEG85WI+XIcYsQdAE7U=;
        b=igkpjHMgXRnzgCPuHlrpmwbV7LbZrq8AmsGa3J24dDNAgQo7FQvYZeeEoetO/fo/pc
         N+6f+O/7IhL00+m26b+PgnxUmu8vWVHBtNHdCMVLsuBsdGK2bSY+gVDJujTsiU4hw8dS
         cBtSvFDZymoQI3xOnsFMN6eXjXopL5gkVmSs1knVw0h6IvNb+117Qr4P9ueBiRoomQNr
         gO3UxgaJ/qgVN6bOE+lVsgkwjLWjCAn/L8mYLkLzM/YT5o3mF4TJREE4RxRlB+ii9L3a
         tXjYMulowF3N6Nzx0HT0euy7WYKQgONZvSMH6BmK10TjXJYyLVO0ifOY91W3rknPlOeB
         ffTw==
X-Gm-Message-State: APjAAAV5nheYPM4camEhlmC+PhL6kUGZGJxHqiQIiB/bLtrvyyzNIFlE
        8iauiaDMjyGcrMgk6PQxfla4M2lwnQs=
X-Google-Smtp-Source: APXvYqyiAxNLnQZ/1JHg8vBAoT64vo+du2yyD8eQ4LYNi+HE9nc0AEIzHPH8RErAwQ2xUzI8m6Wiuw==
X-Received: by 2002:ac8:43d9:: with SMTP id w25mr10756188qtn.65.1571852690100;
        Wed, 23 Oct 2019 10:44:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u43sm13318225qte.19.2019.10.23.10.44.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Oct 2019 10:44:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iNKgj-0005uE-03; Wed, 23 Oct 2019 14:44:49 -0300
Date:   Wed, 23 Oct 2019 14:44:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20191023174448.GP23952@ziepe.ca>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 06:03:51PM +0000, Ertman, David M wrote:
> > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, September 26, 2019 10:13 PM
> > To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> > Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; jgg@mellanox.com;
> > netdev@vger.kernel.org; linux-rdma@vger.kernel.org; dledford@redhat.com;
> > Ertman, David M <david.m.ertman@intel.com>
> > Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> > provide RDMA
> > 
> > On Thu, Sep 26, 2019 at 11:39:22PM +0000, Nguyen, Anthony L wrote:
> > > On Thu, 2019-09-26 at 20:05 +0200, Greg KH wrote:
> > > > On Thu, Sep 26, 2019 at 09:45:00AM -0700, Jeff Kirsher wrote:
> > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > >
> > > > > The RDMA block does not advertise on the PCI bus or any other bus.
> > > >
> > > > Huh?  How do you "know" where it is then?  Isn't is usually assigned
> > > > to a PCI device?
> > >
> > > The RDMA block does not have its own PCI function so it must register
> > > and interact with the ice driver.
> > 
> > So the "ice driver" is the real thing controlling the pci device?  How does it
> > "know" about the RDMA block?
> > 
> > thanks,
> > 
> > greg k-h
> 
> The ICE driver loads and registers to control the PCI device.  It then
> creates an MFD device with the name 'ice_rdma'. The device data provided to
> the MFD subsystem by the ICE driver is the struct iidc_peer_dev which
> contains all of the relevant information that the IRDMA peer will need
> to access this PF's IIDC API callbacks
> 
> The IRDMA driver loads as a software only driver, and then registers a MFD
> function driver that takes ownership of MFD devices named 'ice_rdma'.
> This causes the platform bus to perform a matching between ICE's MFD device
> and IRDMA's driver.  Then the patform bus will call the IRDMA's IIDC probe
> function.  This probe provides the device data to IRDMA.

Did any resolution happen here? Dave, do you know what to do to get
Greg's approval?

Jason
