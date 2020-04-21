Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E381B1AE4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDUAqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 20:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgDUAqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 20:46:30 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA90EC061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:46:30 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id y19so5781870qvv.4
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CpA8wSQ8byNPsMYVE5Rjnk8CAuAusP7U/zaZRU5KlyY=;
        b=RAZ4/McBEOeDt0IgZoJk+OWSyrUUe2pPiWJprjZy8cAZWz2tsq+ZIeRgadAXiFIEjj
         KMiFqyjh1HmzwGH4+9b0sc+1JwlbV6iddeNoDggA49LHik3/CemYfrS+Wm/UExD5zS55
         mSGEUUrREV50ev0Vh833T6Wyo7lXb8n19W5mjZzVs+l31j+H/mhOou0Aq7vQgctD8n7i
         Su+FWBMq8VSzIu9l8SCWEtglq7GD0YbR12G5VgbFnD2KadKs11tLIpKCZh4YUj13sXad
         OSKLlwMuG/SxoscHW3FjKB2qHkFsEtQCXUZJKHUe/jHEXHw2N4g8YL7dYtBApu6XkpXP
         qRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CpA8wSQ8byNPsMYVE5Rjnk8CAuAusP7U/zaZRU5KlyY=;
        b=pPSczTaR02pIJnxVRO5poQav2ABeCK/0y+MKVE2WCF+AvobCr+W5K7eK+p6Zf9hffG
         XN2oZ63Mi4pJ49HpfZmjO6KZmx+pvue8GsCx7dnlqJl8xxrUxrnX7o18djOwcefZoqeT
         t01lFSVJANRQw2DRb/t85glK8vLhyobu04wgzmXCpatKgext7vuxoF2abDYNmNmbIRwG
         KnHIPOkM7NcHyGeThMi8PZUcPlZ9g5mXAYbGGR3Yjc35Aqsu2vFJw00hCKqVeiru9IWE
         R4n3a4LFDiTRTCdsCO1iQwIA1Nhaw2//9PNZRzChcXEMWn9C7FIp7ZQkVmjqn6TW16SC
         ICng==
X-Gm-Message-State: AGi0PuZZDwkjbcb/jcs/sI7EF/M678PCzxfeaUbhVx7DrQ4IBkdFJGi/
        8z6yEBoFOf1Z9JnXWvzZmCJ9eQ==
X-Google-Smtp-Source: APiQypIbUsp30HMvlg+X8PHAkWxkcLaeW4mFWhJbvGvMy5lB6lCyQEFfI685BncrZn/EOee09Ky1XA==
X-Received: by 2002:a0c:aadc:: with SMTP id g28mr18295551qvb.0.1587429989717;
        Mon, 20 Apr 2020 17:46:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id j14sm707529qtv.27.2020.04.20.17.46.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 17:46:29 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jQh3U-0005B5-Ph; Mon, 20 Apr 2020 21:46:28 -0300
Date:   Mon, 20 Apr 2020 21:46:28 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200421004628.GQ26002@ziepe.ca>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 12:23:45AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > definitions
> > 
> > On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Register irdma as a virtbus driver capable of supporting virtbus
> > > devices from multi-generation RDMA capable Intel HW. Establish the
> > > interface with all supported netdev peer drivers and initialize HW.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > >  drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
> > > drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/main.h     | 599 +++++++++++++++++++++++++
> > >  4 files changed, 1849 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > >
> > 
> > I didn't look in too much details, but three things caught my attention immediately:
> > 1. Existence of ARP cache management logic in RDMA driver.
> 
> Our HW has an independent ARP table for the rdma block. 
> driver needs to add an ARP table entry via an rdma admin
> queue command before QP transitions to RTS.
> 
> > 2. Extensive use of dev_*() prints while we have ibdev_*() prints
> The ib device object is not available till the end of the device init
> similarly its unavailable early on in device deinit flows. So dev_*
> is all we can use in those places.

hns guys were thinking about changing this. It looks fine to just move
the name assignment to the device allocation, then we don't have this
weirdness

Alternatively, you could do as netdev does and have a special name
string when the name is NULL

Either way, I feel like this should be fixed up it is very fragile to
have two different print functions running around.

Jason
