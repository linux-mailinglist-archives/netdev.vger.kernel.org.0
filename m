Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1174271608
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgITQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 12:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITQp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 12:45:29 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4DEC061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 09:45:29 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so10213315wmj.5
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 09:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzl9zPCs8H2BtZaJntghTFMfMfHZHrqcOSC3Zyznv/Q=;
        b=cFm69Xob+MUQJhW/KRFfRcPqMhAb2iePNT2ryLzJYKs5zDuH7IhCeiRNrjn/WOFfZk
         O18sx+H7rc7XeTHxE4vcrqywuiyUsISU8LRDiwOA8e6Cv5AbLGVJlOEmRnJ+QN1x4Go1
         1GOS2VhnrpqW3DX+9s6IZZjBDXagdrRVwEyXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=qzl9zPCs8H2BtZaJntghTFMfMfHZHrqcOSC3Zyznv/Q=;
        b=OrYkFZmuZh6P4nPOX9yazl88x++HXVRMfl4eHQvmj7Uf2PAHvlVMAtqHAJYh87eELj
         ySEL8LCD26w6z5G6LQ8M6Zk9NOr2m0UtSP1ITKxdptP+6BNJ+WzKtAaBrMcAB/8vsqng
         jlUauCQfi+ogD/qVG0/NLhTOR3uh2trfABKG6KIaI7E6yZ5RAVhMNtYBAdrGsZa9Ah5B
         7P/cdvsooUWUXeSOQWX02YCA6228EcGFTpZPSxkN1+xJUi/9xh/EjISJ8wcLZqSwZlc7
         7CPwYp/kmH9PYm3ieKbXcCwpiGb2Qp2Js5NbUfuUhZPmRqrxfaWpIWN33jr6szq3ibq9
         gy4g==
X-Gm-Message-State: AOAM533sKhFR6kDfnRI8MKSUy5iVkbh6sbe2X/wj8AEKFt+GJbH4hRXw
        Py3vF2TGoPPIUDgGzZU09Bw56Q==
X-Google-Smtp-Source: ABdhPJwU7eMdQh3XSVJaPGYj+0mfXFKRGE2Mauhd5cKQ5YFxLoykFKT8T3FgelDXYKCADsmSZm8nhQ==
X-Received: by 2002:a05:600c:220f:: with SMTP id z15mr12988715wml.87.1600620327700;
        Sun, 20 Sep 2020 09:45:27 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id m18sm14787218wmg.32.2020.09.20.09.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 09:45:26 -0700 (PDT)
Date:   Sun, 20 Sep 2020 18:45:24 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200920164524.GH438822@phenom.ffwll.local>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
 <20200916062614.GF142621@kroah.com>
 <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
 <20200916074217.GB189144@kroah.com>
 <CAFCwf10zLR9v65sgGGdkcf+JzZaw_WORAbQvEw-hbbfj=dy2Xg@mail.gmail.com>
 <20200916082226.GA509119@kroah.com>
 <CAFCwf1366_GoTj1gpneJBSqVxJ1mOnsdZiC+DJLG85GHGfZrzw@mail.gmail.com>
 <20200916120054.GA2753544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916120054.GA2753544@kroah.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 02:00:54PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 16, 2020 at 11:47:58AM +0300, Oded Gabbay wrote:
> > On Wed, Sep 16, 2020 at 11:21 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Sep 16, 2020 at 11:02:39AM +0300, Oded Gabbay wrote:
> > > > On Wed, Sep 16, 2020 at 10:41 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Wed, Sep 16, 2020 at 09:36:23AM +0300, Oded Gabbay wrote:
> > > > > > On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
> > > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> > > > > > > > On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> > > > > > > > >
> > > > > > > > > From: Oded Gabbay <oded.gabbay@gmail.com>
> > > > > > > > > Date: Tue, 15 Sep 2020 20:10:08 +0300
> > > > > > > > >
> > > > > > > > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > > > > > > > into the habanalabs driver.
> > > > > > > > > >
> > > > > > > > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > > > > > > > are in that patch's commit message.
> > > > > > > > > >
> > > > > > > > > > Link to v2 cover letter:
> > > > > > > > > > https://lkml.org/lkml/2020/9/12/201
> > > > > > > > >
> > > > > > > > > I agree with Jakub, this driver definitely can't go-in as it is currently
> > > > > > > > > structured and designed.
> > > > > > > > Why is that ?
> > > > > > > > Can you please point to the things that bother you or not working correctly?
> > > > > > > > I can't really fix the driver if I don't know what's wrong.
> > > > > > > >
> > > > > > > > In addition, please read my reply to Jakub with the explanation of why
> > > > > > > > we designed this driver as is.
> > > > > > > >
> > > > > > > > And because of the RDMA'ness of it, the RDMA
> > > > > > > > > folks have to be CC:'d and have a chance to review this.
> > > > > > > > As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> > > > > > > > the kernel and we can't connect to it due to the lack of H/W support
> > > > > > > > we have
> > > > > > > > Therefore, I don't see why we need to CC linux-rdma.
> > > > > > > > I understood why Greg asked me to CC you because we do connect to the
> > > > > > > > netdev and standard eth infrastructure, but regarding the RDMA, it's
> > > > > > > > not really the same.
> > > > > > >
> > > > > > > Ok, to do this "right" it needs to be split up into separate drivers,
> > > > > > > hopefully using the "virtual bus" code that some day Intel will resubmit
> > > > > > > again that will solve this issue.
> > > > > > Hi Greg,
> > > > > > Can I suggest an alternative for the short/medium term ?
> > > > > >
> > > > > > In an earlier email, Jakub said:
> > > > > > "Is it not possible to move the files and still build them into a single
> > > > > > module?"
> > > > > >
> > > > > > I thought maybe that's a good way to progress here ?
> > > > >
> > > > > Cross-directory builds of a single module are crazy.  Yes, they work,
> > > > > but really, that's a mess, and would never suggest doing that.
> > > > >
> > > > > > First, split the content to Ethernet and RDMA.
> > > > > > Then move the Ethernet part to drivers/net but build it as part of
> > > > > > habanalabs.ko.
> > > > > > Regarding the RDMA code, upstream/review it in a different patch-set
> > > > > > (maybe they will want me to put the files elsewhere).
> > > > > >
> > > > > > What do you think ?
> > > > >
> > > > > I think you are asking for more work there than just splitting out into
> > > > > separate modules :)
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > > Hi Greg,
> > > >
> > > > If cross-directory building is out of the question, what about
> > > > splitting into separate modules ? And use cross-module notifiers/calls
> > > > ? I did that with amdkfd and amdgpu/radeon a couple of years back. It
> > > > worked (that's the best thing I can say about it).
> > >
> > > That's fine with me.
> > >
> > > > The main problem with this "virtual bus" thing is that I'm not
> > > > familiar with it at all and from my experience I imagine it would take
> > > > a considerable time and effort to upstream this infrastructure work.
> > >
> > > It shouldn't be taking that long, but for some unknown reason, the
> > > original author of that code is sitting on it and not resending it.  Go
> > > poke them through internal Intel channels to find out what the problem
> > > is, as I have no clue why a 200-300 line bus module is taking so long to
> > > get "right" :(
> > >
> > > I'm _ALMOST_ at the point where I would just do that work myself, but
> > > due to my current status with Intel, I'll let them do it as I have
> > > enough other things on my plate...
> > >
> > > > This could delay the NIC code for a couple of years, which by then
> > > > this won't be relevant at all.
> > >
> > > Why wouldn't this code be relevant in a year?  It's going to be 2+ years
> > > before any of this shows up in an "enterprise distro" based on their
> > > release cycles anyway :)
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Hi Greg,
> > ok, I'll take a look. Do you happen to have the name of the patch-set / author ?
> 
> Here's at least one copy:
> 	https://lore.kernel.org/linux-rdma/20200520070227.3392100-2-jeffrey.t.kirsher@intel.com/
> 
> there might have been a newer one, can't remember, sorry.

Maybe I'm missing something or maybe the in-tree code we have already
should be refactored to use more buses and drivers, but
drivers/base/component.c is made for this. We use this to glue all kinds
of things across all kinds of subsystems already.

Of course it really should be only used for one-off problems, as soon as
you have a standard interface/interaction there should be some kind of
standard lookup way to get at your thing (and the driver behind it), e.g.
in drivers/gpu we're now building up drm_bridge and trying to get away
from componenent.c for these things.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
