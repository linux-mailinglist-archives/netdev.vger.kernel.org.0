Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E7C166966
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgBTU6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:58:48 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33702 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgBTU6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:58:46 -0500
Received: by mail-qk1-f195.google.com with SMTP id h4so4985914qkm.0
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 12:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4CyAgS/0c7CIK/c3o2s+ouwgiJs8lhJ7U/JY1LhUPq8=;
        b=SfgEOJcz9S4c1DmySLkmUpkmGRxj9Fo77E1rINIc/HVaOoBPUEnci93WjMofj9M6uT
         RuQR3BfQDrSYcbisfz/LMlCIA4/SDa3ct5UoPx2GdfREInHQdLkaSK/Pnv+h1WLLl4Xx
         68D19U34SHi8hV3lT5faAPSSRXwtWFtKcwfP8w7vyoihec7eG/QyTSe69L9DulY7NtAT
         dTyDH8mky2Wtt0IyrNc1YqEtWzu1MuHibDvstW/s9MNBS/YyzxwEbS4D67Qz0LnXf8ci
         Oi6DVS2xHFSzvLEe9CeCCjuSmIB5vNN7zmvGDbBFemWbbq55+Y4HEwsbgTGkClYczd6q
         mBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4CyAgS/0c7CIK/c3o2s+ouwgiJs8lhJ7U/JY1LhUPq8=;
        b=dJF1dXHL+AOVRu1iDMGzvpnFpQZXozCasWPh790+SRgHwUqEX9gNTk+FYi+OcBI648
         IMVfA/CmaXcfk0W1yzjSLnC8gB92Gz7WQfTFii1n+BtcBooN8Tzaejh6PwjAxhU8WKvO
         DjVRTvU/AUsvEUmcmeYrKn2LtZWdwpbth2eAcE1of7x/PXazvqyMueEPSJPkt9lOkSin
         X9w66HynTp85A0yUVtDSLkvPtSnC5qeDYPQZi1JdL8vJqEuZkNbCynPdGmVa+ZtoD7n6
         7ncxafQ8gQJrL4TdFV7bGHwp1nGLQVNOK2R2JcTtN3s+C1XTk54MF95QY7ovd/DF81v5
         Song==
X-Gm-Message-State: APjAAAWhX0yCAmRyD8cYPAcKbbZJScO//61b7gwXghVJ+ZsERRIsoXrD
        zqFyVrbqbMuBKDFxkpCUaRiouQ==
X-Google-Smtp-Source: APXvYqz3fWCWGMmBu9dHarCF+QoS8bdclU30PNEN8Lf7uQKmDFmWWyQOr59qgzC+7sztvoPfWxwcXQ==
X-Received: by 2002:a37:4856:: with SMTP id v83mr30399147qka.350.1582232325504;
        Thu, 20 Feb 2020 12:58:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t23sm384067qto.88.2020.02.20.12.58.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Feb 2020 12:58:45 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j4suC-00010k-Hm; Thu, 20 Feb 2020 16:58:44 -0400
Date:   Thu, 20 Feb 2020 16:58:44 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [RFC PATCH v4 02/25] ice: Create and register virtual bus for
 RDMA
Message-ID: <20200220205844.GE31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-3-jeffrey.t.kirsher@intel.com>
 <20200214203932.GY31668@ziepe.ca>
 <DM6PR11MB2841C1643C0414031941D191DD130@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB2841C1643C0414031941D191DD130@DM6PR11MB2841.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 06:48:04PM +0000, Ertman, David M wrote:
> > You need to go through all of this really carefully and make some kind
> > of sane lifetime model and fix all the error unwinding :(
> 
> Thanks for catching this.  A failure in virtbus_register_device()  does
> *not* require a call virtbus_unregister_device.  The failure path for the
> register function handles this.  Also, we need to remain consistent with freeing
> on unwind.

Be careful it is all correct on v5 :)
 
> > Why doesn't the release() function of vbo trigger the free of all this
> > peer related stuff?
> > 
> > Use a sane design model of splitting into functions to allocate single
> > peices of memory, goto error unwind each function, and build things up
> > properly.
> > 
> > Jason
> 
> I am going to add this to the documentation to record the following information.

Well, there is nothing special here. All the driver core users
basically work this way. You shouldn't need to document anything
uniquely for virtbus.

The trouble I see in this patch is mixing three different lifetime
models together (devm, release, and 'until unregister'). It is just
unnecessary and is bound to create errors.

Follow the normal, proven flow of four functions, each handling one of
the lifetimes

1) 'alloc and initialize' function
   Allocates memory, and ends with device initialize().
   This gets things ready to the point that put_device() and 
   release() will work.
   Everything allocated here is valid until release.

2) Initialize stuff with a lifetime of 'until unregister'
   function

   This function starts with alloc'd memory from #1 and typically ends
   with some register()

   Every allocation is either:
     - undone by release()
       In this case the goto unwind is simply put_device()
       [discouraged, but sometimes unavoidable]
     - undone by #3, after calling unregister()
       In this case the goto unwind is a mirror of the deallocs
       in #3

   If register() fails, it does the full goto unwind ending in
   put_device().

   devm is not used.

3) unregister the device function
   call uregister and then do everything from the goto unwind
   of #2 in reverse order.

4) Release the device function
   Free all the allocations of #1 and all !NULL allocations of #2
   (mostly mirrors the goto unwind of #1)

It is easy to audit, has highly symmetric goto unwind error handling,
and is fairly easy to 'do right' once you get the idea.

There are many examples of this in the kernel, look at alloc_netdev,
ib_alloc_device, tpm_chip_alloc, register_netdevice,
ib_register_device, tpm_chip_regsiter, etc.

The schema is nestable, so if the virtbus core has these four
functions (virtbus_alloc, virtbus_register, virtbus_unregister,
release), then the driver using it can have four functions too,
'driver alloc', probe, remove, release (called by core release).

Look at the recent VDPA patches for some idea how it can look:

https://lore.kernel.org/kvm/20200220061141.29390-4-jasowang@redhat.com/

(though, IMHO, the pattern works better if the alloc also encompasses
 the caller's needed struct, ie by passing in a size_t)

Notice:
- vdpa_alloc_device() returns a memory block that is freed using put_device.
  At this point dev_info/etc work and the kref works. Having
  dev_err/etc early on is really nice
  Caller *never* does kfree()
  * Notice to get dev_info() working with the right name we have to
    call dev_set_name() and the error unwind for dev_set_name must be
    put_device()!
- vdpa_register_device() doesn't destroy the memory on failure.
  This means goto error unwind at the caller works symmetrically
- release drops the IDA because vdpa_alloc_device() created it.
  This means so long as the kref is valid the name is unique.
- Unregister does not destroy the memory. This allows the caller
  to continue on to free any other memory (#3 above) in their
  private part of the structure

Jason
