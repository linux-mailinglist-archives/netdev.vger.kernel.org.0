Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10F420E902
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgF2XAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgF2XAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 19:00:02 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E773C03E979
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 16:00:01 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so19008392iow.7
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 16:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pZa6Qls2X0ZJVuIfRFknbeFzAtLwAloZxzpTgo+EE2A=;
        b=jQnwiZcMysSH3kzi4acPuwbS4lnWtsZ+KFY3OGi9cCaDoS2N2VlCOScZLRsHNCSapH
         65vNA4m+3gvQSqWBu54Qj+J+RCaWvOdsNfgHikxGdiyPAo6vRJZUwl7YJgc9hbSVBIyE
         oEraom2DARq9ESZyKlwcs5EhJntf9PZMab+0ziopNffpDrY+EUmjz9YI/4mctTM3MTgZ
         fGOIEXvzcZQKSlW8eBvIDTwImBSfEbmCANy9xyrsGo9WGCabA5UtIdPrLNjZyQ2sepWC
         s9ZW0oX6alEDC+c0BIGhPRYaSNLGqTeSAeJtb5Ml3kaUDgUvXyF++u9TLDH9HURUO+13
         7ZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pZa6Qls2X0ZJVuIfRFknbeFzAtLwAloZxzpTgo+EE2A=;
        b=JrNcJ7q6InjQ8nfP1op0oSnDq9tymfpLuPMWVq5EfIxCyyzvX64kvDDjsJvQ9u+Ubw
         20WK5O8osUnnFJlrEI3EP7o6gb+iuFV3lUpzPRTwkBwQghUWcvibvprrNSBENKK+bz5D
         oUs31t4Nz6ja3qzbk0SL+3UCdyBdvxd/7a43yMfslXHBYCvnfPmkpdAFPafAGJgss2rC
         u6tq5YwB3ekL+olt5gb7uHfxhYWsG6UXpsyiisPNC019py3NAKFoz58FjlVHb2X10h/d
         JdK/X+YObvW96nayTG2vDcvozHdWp5AgRyXUH2kyvbF+Tj4csu66YbEq/7ggcnVGMRQj
         TESA==
X-Gm-Message-State: AOAM5320Uq0FVOFCB6MBLWjIIBwr+veq2aGtpHGJ4cX0h2XD2Icm5yvw
        8eZ2DTpJH/DkNbIWaPafRn0COw==
X-Google-Smtp-Source: ABdhPJxDbty9v4iWJpRzF3Phr/1Y/1T/ffPCEf9zLLh065Jg6UsWpebPuzbkPmz2I5e/276TKPok5A==
X-Received: by 2002:a6b:8ed4:: with SMTP id q203mr19020310iod.193.1593471600739;
        Mon, 29 Jun 2020 16:00:00 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id g1sm688406ilk.51.2020.06.29.16.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 16:00:00 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jq2kp-001Obs-4j; Mon, 29 Jun 2020 19:59:59 -0300
Date:   Mon, 29 Jun 2020 19:59:59 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200629225959.GF25301@ziepe.ca>
References: <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629203317.GM5499@sirena.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:
> 
> > Ok, that's good to hear.  But platform devices should never be showing
> > up as a child of a PCI device.  In the "near future" when we get the
> > virtual bus code merged, we can convert any existing users like this to
> > the new code.
> 
> What are we supposed to do with things like PCI attached FPGAs and ASICs
> in that case?  They can have host visible devices with physical
> resources like MMIO ranges and interrupts without those being split up
> neatly as PCI subfunctions - the original use case for MFD was such
> ASICs, there's a few PCI drivers in there now. 

Greg has been pretty clear that MFD shouldn't have been used on top of
PCI drivers.

In a sense virtual bus is pretty much MFD v2.

Jason
