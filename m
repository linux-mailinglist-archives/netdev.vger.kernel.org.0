Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07552B709C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKQVFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKQVFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 16:05:09 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A914CC0617A7
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 13:05:08 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id k27so4024277ejs.10
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 13:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kPEScT6gyGX81QUKHxjlw3b2BBUYfWDEeiwl2fVm1wc=;
        b=p+pnzb/QV2PtGwSdlBCCfgAyW8YeNSqAdFBepLZnfBYuN8ZsISPTLreqLJrA1uF2a7
         JIXpiidK8x1BZ3q54txbRPbxcTBDky4tJDzlsTVAhQKBxJoobg/6zPaXV7Vl+QSryYTW
         soZx7D0rcc+lDUmhEejuFMzf1msPmPpBn+PNoxSblv6bfenihydjzscQsDUgo2sREyOU
         qvJ+nDebS94wyW7FnAt3NR3eDkvEdqhOn/DNfQmD7fC/TZImL/cMErCXf/K8W5yTtYga
         1ue9DHOUJDF5V2UGiwF6AIAXecxfsnCmkUuDOPjFFBFpbofxmE7TOC7SUS5j4hF6t4B1
         rXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPEScT6gyGX81QUKHxjlw3b2BBUYfWDEeiwl2fVm1wc=;
        b=Yfv4IodDwEppez566qnWDOIXXXdZkhG3abmWOdbdFx2pKgAct9tQiRLjJL6i4e2KL3
         OAvJDXol+R3Pq4FrASXdl9qwo5KJLWxZLQuMPM3pBlWOIoz4ITgR8TpIJFc+zYRC4dnN
         fla9gwPfbdCuoRkXN6UMUEFNekOdr0RKdS0s2tfkmGnp/EOLaFRivS/RPwq4yHciU9w5
         cFlVpxvUopVeQh5sCkXfdwWvKr1zGJxu+U17eDkA7R6qQJXSanx1Z2lYoiOBr8sa/I5x
         DcqckejxkpKzkKdt12kyvEHDma04Bso96T0xzeQ02cIeaplJZyknrnv2qXe3acPdrZEb
         X9rg==
X-Gm-Message-State: AOAM533YHHmAf3fCGWM320hv7iifQvkfSHgSGIiMFzfWmfZXqc2BkKSO
        Z+XWUX1UApMI2h21k2FYeAFvKWt+cWiwvXYKFS6yOxIHEzms+Q==
X-Google-Smtp-Source: ABdhPJxIPEbRet7rRI98nHMy4znmKu8Wwkus/v7GOUPBHi9d8SdQldIDo6o+qUCd10IbSYlqVfJ2O+BKKa6GUrV8c6Y=
X-Received: by 2002:a17:906:ad8e:: with SMTP id la14mr17989866ejb.264.1605647107261;
 Tue, 17 Nov 2020 13:05:07 -0800 (PST)
MIME-Version: 1.0
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com> <20201117053000.GM47002@unreal>
 <X7N1naYOXodPsP/I@kroah.com>
In-Reply-To: <X7N1naYOXodPsP/I@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 17 Nov 2020 13:04:56 -0800
Message-ID: <CAPcyv4jXinvaLgtdpXTLLQ3sDOhvoBjF=7v7pba5rAd0g_rdow@mail.gmail.com>
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 11:02 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 17, 2020 at 07:30:00AM +0200, Leon Romanovsky wrote:
> > On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:
> > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > It enables drivers to create an auxiliary_device and bind an
> > > auxiliary_driver to it.
> > >
> > > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > > Each auxiliary_device has a unique string based id; driver binds to
> > > an auxiliary_device based on this id through the bus.
> > >
> > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > ---
> >
> > Greg,
> >
> > This horse was beaten to death, can we please progress with this patch?
> > Create special topic branch or ack so I'll prepare this branch.
> >
> > We are in -rc4 now and we (Mellanox) can't hold our submissions anymore.
> > My mlx5_core probe patches [1] were too intrusive and they are ready to
> > be merged, Parav's patches got positive review as well [2] and will be
> > taken next.
> >
> > We delayed and have in our internal queues the patches for VDPA, eswitch
> > and followup for mlx5_core probe rework, but trapped due to this AUX bus
> > patch.
>
> There are no deadlines for kernel patches here, sorry.  Give me some
> time to properly review this, core kernel changes should not be rushed.
>
> Also, if you really want to blame someone for the delay, look at the
> patch submitters not the reviewers, as they are the ones that took a
> very long time with this over the lifecycle of this patchset, not me.  I
> have provided many "instant" reviews of this patchset, and then months
> went by between updates from them.

Please stop this finger pointing. It was already noted that the team,
out of abundance of caution / deference to the process, decided not to
push the patches while I was out on family leave. It's cruel to hold
that against them, and if anyone is to blame it's me for not
clarifying it was ok to proceed while I was out.
