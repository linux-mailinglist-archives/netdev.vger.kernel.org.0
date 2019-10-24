Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1208E3B70
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504187AbfJXS5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390146AbfJXS5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 14:57:08 -0400
Received: from localhost (unknown [75.104.69.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBEC2054F;
        Thu, 24 Oct 2019 18:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571943427;
        bh=6rAvhoWsIv9Iq+Qlx2pe69JPP8aqVI6WaKGDBiMFCEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ykkcy/H7gKx/IcnAej6Ytk78cgJtceazuEetR1TkdzRtTRrKImXXA8XBxiPWmKaL6
         k7vJOxwI0UzExvVbln0V+o+EkyW6mmQd3GT7eaomQ4T+QwoXuGiTBaI/xQ0kr7Jfa3
         u46D506yl9oOGhkFuff6NN3gHWlLv/S+vPecMJs0=
Date:   Thu, 24 Oct 2019 14:56:59 -0400
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20191024185659.GE260560@kroah.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023180108.GQ23952@ziepe.ca>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 03:01:09PM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 23, 2019 at 05:55:38PM +0000, Ertman, David M wrote:
> > > Did any resolution happen here? Dave, do you know what to do to get Greg's
> > > approval?
> > > 
> > > Jason
> > 
> > This was the last communication that I saw on this topic.  I was taking Greg's silence as
> > "Oh ok, that works" :)  I hope I was not being too optimistic!
> > 
> > If there is any outstanding issue I am not aware of it, but please let me know if I am 
> > out of the loop!
> > 
> > Greg, if you have any other concerns or questions I would be happy to address them! 
> 
> I was hoping to hear Greg say that taking a pci_device, feeding it to
> the multi-function-device stuff to split it to a bunch of
> platform_device's is OK, or that mfd should be changed somehow..

Again, platform devices are ONLY for actual platform devices.  A PCI
device is NOT a platform device, sorry.

If MFD needs to be changed to handle non-platform devices, fine, but
maybe what you really need to do here is make your own "bus" of
individual devices and have drivers for them, as you can't have a
"normal" PCI driver for these.

Again, please stop abusing platform devices.

greg k-h
