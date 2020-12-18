Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D071B2DE372
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 14:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLRNrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 08:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgLRNrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 08:47:05 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7590CC061248
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 05:46:07 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r7so2223631wrc.5
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 05:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ka1x3IgXnDKEVbUNgJSUcPN8PzFVanlFrtTuT6E8rts=;
        b=D86dpjGakhZl+5XAKRbJimghynE7rov8qUJl/t75gAK4y/Fp5ssvHO49HPwJtIaWW7
         X0ZJnoyYSQEoJHAhiXySsnJJYjhmZB45KowbpkHybNPtkPHbDggsC/oXZOIjNV0OxfIP
         JtLk8ioNSYQNcBqUgcvb8hGzTjMFok0Z5d20D9TGp+gj3yAWd0tBwAcawAEAoclM3CeV
         hlVaCtzhQlhb3gLpgfbarf5Mch5uuBb3PuxZXm6+Qk42SmEjVCjqSdKkAl+v/+V8XpWa
         kzHRKLbBkT4RUsGzpF0vZVjKR15UffhOdqNzvt5OEAGmcdsDkI4BoE2RGEi1CeWWnZHq
         NPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ka1x3IgXnDKEVbUNgJSUcPN8PzFVanlFrtTuT6E8rts=;
        b=WYQSG6xc7hrIuhQghj5GKsdzgoAbTl8pukPsGUMVu88mB+JclRAhiD3lyP5p2Uoz4G
         IXj1wt3hn1Z4cMPiG5qrsRt5lik9r+ghgLULXt04QOJBB52lY+ALOYwW0DikgRfxxmCT
         Fow/9E6X6295P0aWxeRvQzS5BfSHo9GkYMpqNSF/ZIC2e32Z1Y1XpNk2hCcu5qtFEKaQ
         +O1uLdp+fO2ZdVCUJAF5nmWURlbbJWEFkgoBTAjUN+G/jAVeKEM+vwi2+cIs0OIJ7fIO
         zcTUbOfEnUSv4DxxGgNzVLknwiY0YOF8r/QNZIj7EMBchc9B7Ox3M7rgXPL8+IuF90S4
         Fq0Q==
X-Gm-Message-State: AOAM533eQPmuMjdWgw6gTph5Xy5QoICJaU34NrZ9cJviUvdTLudULvV0
        aHQwU0xA+n69BZ6boUINUNKcAQ==
X-Google-Smtp-Source: ABdhPJzuzueQDnbBnCkvc22NOc11UsjLlpycV2v2yPaJ9/Pn3FrNYBjDBsPM3Sqix1VPGW3J6EwCWQ==
X-Received: by 2002:a5d:52c1:: with SMTP id r1mr4590809wrv.255.1608299166077;
        Fri, 18 Dec 2020 05:46:06 -0800 (PST)
Received: from dell ([91.110.221.216])
        by smtp.gmail.com with ESMTPSA id l1sm14124574wrq.64.2020.12.18.05.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:46:05 -0800 (PST)
Date:   Fri, 18 Dec 2020 13:46:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201218134603.GS207743@dell>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201218131709.GA5333@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Dec 2020, Mark Brown wrote:

> On Fri, Dec 18, 2020 at 08:10:51AM +0100, Greg KH wrote:
> > On Thu, Dec 17, 2020 at 10:19:37PM +0100, Alexandre Belloni wrote:
> 
> > > There is something I don't get from the documentation and it is what is
> > > this introducing that couldn't already be done using platform drivers
> > > and platform devices?
> 
> > Because platform drivers and devices should ONLY be for actual platform
> > devices.  Do NOT use that interface to fake up a non-platform device
> > (i.e. something that is NOT connected to a cpu through a memory-mapped
> > or direct-firmware interface).
> 
> > Do not abuse the platform code anymore than it currently is, it's bad
> > enough what has been done to it over time, let's not make it any worse.
> 
> I am not clear on why you're giving direct-firmware devices (which I
> assume means things like ARM SCMI where we're talking directly to some
> firmware?) a pass here but not for example a GPIO controlled devices.
> If this is mainly about improving abstractions it seems like the
> boundary here isn't great.  Or perhaps I'm just missing what
> direct-firmware is supposed to mean?
> 
> In any case, to be clear part of what you're saying here is that all
> I2C and SPI MFDs should be rewritten to use this new bus - I've just
> copied Lee in again since he keeps getting missed from these threads.
> As previously discussed this will need the auxilliary bus extending to
> support at least interrupts and possibly also general resources.

Thanks Mark.

Not entirely sure why this needed an entirely new subsystem to handle
non-MMIO Multi-Functional Devices (MFD).  Or why I was not approached
by any of the developers during the process.

Having 2 entirely separate subsystems where MFDs can now be registered
sounds confusing and convoluted at best.  Why not simply extend actual
MFD to be capable of registering non-pure platform devices via other
means?  By doing so you keep things bound to a central location
resulting in less chance of misuse.

I turn away MFD implementation abuses all the time.  Seeing as the 2
subsystems are totally disjoint, this just unwittingly opened up
another back-channel opportunity for those abuses to make it into the
mainline kernel.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
