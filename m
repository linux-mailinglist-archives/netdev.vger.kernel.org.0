Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3753420F399
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 13:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732974AbgF3Lcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 07:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgF3Lcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 07:32:48 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A467FC03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 04:32:48 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x9so17398512ila.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 04:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LFNwIQlNioguafFY37IupRqLbXLAuXF9749fjHUWD6Y=;
        b=gSl0z0zsFnIBoY3OckvK4tvohfguwfPws/ENYsCnGk69ebLkaMHHI70JtDAvS5aM2G
         I5qkbw/q5+3OtRtG3HkAyYbRagCndeqvAHjvRxK8l3cbjX0ijkCyUEq0VR9wx8BuctuO
         AoVSRS/hJNC2A2uJrbpl+mn04PSBPuuQtb0LV+SL5nO7z6gc3OLjS1i3QTd2OIGH8U3s
         dCgqoEo4L+EvxaTrJxRJZAVtk/ZikzY1KisFViOMr4zsFIrZQWrpBAA965Y72TK9lcwk
         p9jBThf5nOF7lDDfgJXKJKtHwaUN9vfY8gi7l7imMRxnc3lQd4UOdUvdA/eZvUOVGp24
         RDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LFNwIQlNioguafFY37IupRqLbXLAuXF9749fjHUWD6Y=;
        b=bLkH5oNugsObq2+Pu0o875cmpjFuN2+RAkR2xBR613EKl6df26juzvD9jcR+GIoOT/
         Oqp0tMhJoO3/9fC6xdot5JQozGjXjEoDcQwT8FcaSnquTYxnAqaY+7YmBosaM1pUZ9st
         RCeBOfyQoeK+pjAt8UzizGy1Bp2I/wBZDdAfFVDzhRzj8rZxS0u9dLx4rMgmMzoi0LIg
         xbelN57YrSlpWG+5CxCw1rUGtAp8R86Inns/spOKcitC5VpWLlAtA0PxPbd4aZw0qh09
         a5/dA98tjDCRknml2Qdvfc2QnFM1wRH8wHTjp+zyZjPqWitYVwQqMASQed7r8LPE9+Rp
         L59A==
X-Gm-Message-State: AOAM533lxJgIVatfs8hiI9LSVIGxDwlnrMjKiGMU5bdi9dcxRzmTJS+I
        XoNv/qBQIUVoSZj3ERzSSPMycQ==
X-Google-Smtp-Source: ABdhPJzkusHBr3wMRg2ogpxb5Zvn7cGwdVZSB2LGMkofw+oZSsKxckSuJh5mnTyHUZwhalVbUzK04w==
X-Received: by 2002:a92:410d:: with SMTP id o13mr2041308ila.298.1593516767773;
        Tue, 30 Jun 2020 04:32:47 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id x16sm1338207iob.35.2020.06.30.04.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:32:46 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jqEVJ-001XOb-QU; Tue, 30 Jun 2020 08:32:45 -0300
Date:   Tue, 30 Jun 2020 08:32:45 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200630113245.GG25301@ziepe.ca>
References: <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630103141.GA5272@sirena.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:31:41AM +0100, Mark Brown wrote:
> On Mon, Jun 29, 2020 at 07:59:59PM -0300, Jason Gunthorpe wrote:
> > On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> > > On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:
> 
> > > > Ok, that's good to hear.  But platform devices should never be showing
> > > > up as a child of a PCI device.  In the "near future" when we get the
> > > > virtual bus code merged, we can convert any existing users like this to
> > > > the new code.
> 
> > > What are we supposed to do with things like PCI attached FPGAs and ASICs
> > > in that case?  They can have host visible devices with physical
> > > resources like MMIO ranges and interrupts without those being split up
> > > neatly as PCI subfunctions - the original use case for MFD was such
> > > ASICs, there's a few PCI drivers in there now. 
> 
> > Greg has been pretty clear that MFD shouldn't have been used on top of
> > PCI drivers.
> 
> The proposed bus lacks resource handling, an equivalent of
> platform_get_resource() and friends for example, which would be needed
> for use with physical devices.  Both that and the name suggest that it's
> for virtual devices.

Resource handling is only useful if the HW has a hard distinction
between it's functional blocks. This scheme is intended for devices
where that doesn't exist. The driver that attaches to the PCI device
and creates the virtual devices is supposed to provide SW abstractions
for the other drivers to sit on.
 
I'm not sure why we are calling it virtual bus.

> The reason the MFDs use platform devices is that they end up having to
> have all the features of platform devices - originally people were
> making virtual buses for them but the code duplication is real so
> everyone (including Greg) decided to just use what was there already.

Maybe Greg will explain why he didn't like the earlier version of that
stuff that used MFD

Jason
