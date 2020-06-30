Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9783520FA86
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733273AbgF3R1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731302AbgF3R1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:27:12 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A5CC03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 10:27:12 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t4so5280687iln.1
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 10:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P/6ggX/DjO7JyGRB7ILRQXrlpUGxsT78zYZwYWr0lA0=;
        b=FRiG9jl4akAaLUI0ni0jYoUFNyKPc1muVrGYFyS8YLrPAzq6ooxogL2dX0RGjQXsQs
         CQfiZDFUkWzofbrpqWC4Yf9FooQuS+kGlNr7OwDpLVljuM+juCT4M/y9+d7rj2WKMRdU
         ZHIK/kRNeaRYOHTJAhA3/Us4aWRc16JzHewGGT9fMwJICvupDRw0NQwmkisCic3DLn98
         6EYNm+4/Cm2BghYPJ84iUZoeaiUQ9/ekSTJj1crv8FW060J/nWm79b7iLNsynAcDZlBd
         LNWMwIxJ2zajN+zoESQx221TRczAewa5ahK/H83phUR0+47MTrL7Z4yx9A0iqFiBl6Tn
         ngfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P/6ggX/DjO7JyGRB7ILRQXrlpUGxsT78zYZwYWr0lA0=;
        b=AOVT/p9u2DlC3OIFR1LZ50UWO4B6bPV/JsMznjaa5259x3yMeOrernoZvZxgocoZAC
         ouewHwSEokph9anRdA5imQoqsRseHNxsTIp6YqwEuXtH+s95Fj1WJSxzd6LWKUTX4zwB
         MSEaKDD4lCRRUEOHCFVkS2r3t5YEqgz5MWy5TF0CNDZ8LlRioqlVFj5R6pYxw4JvfiXZ
         A74rTw8FZLGHyRIAMtMyKLapcXUUoEQrZRQcVd/OzD59zto5PMpQsKzgk0VjIE/zbt4J
         8lzUNFcntEqegt+SHEZSbvbNYoyAIWgR8i+ofAVBt2X/fsqxSDhwCdKv7N2Nq6JHsvZh
         ys2w==
X-Gm-Message-State: AOAM530h4+Oy7ERpzCnxwsuOCLuZqo5JuuVE9B83wqdwcTmnfG1ft/ON
        IEkGM3JoZegtKvtMcYFI6AFKJw==
X-Google-Smtp-Source: ABdhPJzRBdOcavVEwFGxrZQi79JeB/m+Y89BJkfTn6HtUTZ61xR8um/46wrWwphQNYlZ0iTIajXYjQ==
X-Received: by 2002:a92:7792:: with SMTP id s140mr3585647ilc.66.1593538031396;
        Tue, 30 Jun 2020 10:27:11 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id z9sm1936501ilb.41.2020.06.30.10.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 10:27:10 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jqK2I-001vsb-1W; Tue, 30 Jun 2020 14:27:10 -0300
Date:   Tue, 30 Jun 2020 14:27:10 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200630172710.GJ25301@ziepe.ca>
References: <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 10:24:04AM -0700, Ranjani Sridharan wrote:
> On Tue, 2020-06-30 at 08:32 -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 30, 2020 at 11:31:41AM +0100, Mark Brown wrote:
> > > On Mon, Jun 29, 2020 at 07:59:59PM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> > > > > On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:
> > > > > > Ok, that's good to hear.  But platform devices should never
> > > > > > be showing
> > > > > > up as a child of a PCI device.  In the "near future" when we
> > > > > > get the
> > > > > > virtual bus code merged, we can convert any existing users
> > > > > > like this to
> > > > > > the new code.
> > > > > What are we supposed to do with things like PCI attached FPGAs
> > > > > and ASICs
> > > > > in that case?  They can have host visible devices with physical
> > > > > resources like MMIO ranges and interrupts without those being
> > > > > split up
> > > > > neatly as PCI subfunctions - the original use case for MFD was
> > > > > such
> > > > > ASICs, there's a few PCI drivers in there now. 
> > > > Greg has been pretty clear that MFD shouldn't have been used on
> > > > top of
> > > > PCI drivers.
> > > 
> > > The proposed bus lacks resource handling, an equivalent of
> > > platform_get_resource() and friends for example, which would be
> > > needed
> > > for use with physical devices.  Both that and the name suggest that
> > > it's
> > > for virtual devices.
> > 
> > Resource handling is only useful if the HW has a hard distinction
> > between it's functional blocks. This scheme is intended for devices
> > where that doesn't exist. The driver that attaches to the PCI device
> > and creates the virtual devices is supposed to provide SW
> > abstractions
> > for the other drivers to sit on.
> >  
> > I'm not sure why we are calling it virtual bus.
> Hi Jason,
> 
> We're addressing the naming in the next version as well. We've had
> several people reject the name virtual bus and we've narrowed in on
> "ancillary bus" for the new name suggesting that we have the core
> device that is attached to the primary bus and one or more sub-devices
> that are attached to the ancillary bus. Please let us know what you
> think of it.

It is sufficiently vauge

I wonder if SW_MFD might me more apt though? Based on Mark's remarks
current MFD is 'hw' MFD where the created platform_devices expect a
MMIO pass through, while this is a MFD a device-specific SW
interfacing layer.

MFD really is the best name for this kind of functionality,
understanding how it is different from the current MFD might also help
justify why it exists and give it a name.

Jason
