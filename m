Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E32A880F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbgKEU0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731867AbgKEU0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:26:14 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B5C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 12:26:14 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id i19so4515552ejx.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 12:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElB/rrPxCKnXR5px8y5SyvZ9UfH3zJvG6zS/OQ+aa24=;
        b=ErZLZUBe+5C6NSiNMqIo5UgF39YypMZidWcizu6bHEdkOO+DrfY6zfclQDJcK+rvLF
         HZDRGBB9K0Zde2XPVSCZEZ9mBa4VuYO63KCeKx0l6J/UEFamr2GHa8ZSFPaa+iJ+B7Fy
         XJtzsHBD3yDKVHRtOTSQ+O1IAExokiNCyI1If+tR9MXH+rn+AMxXk8Ushw91ELhDnd6K
         kXzJZL4I8dwisUTNONoPoQj5feVRVi84c9hmRQnT5w7szohcp1r3hU5eRBd5GN9OygRm
         qpo0NuFIU1irs4jDeLH8gYxr+CNm7oWBvFfY/N91TkgyAdPfmdp6D5HRcaJOope9vCVe
         Juag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElB/rrPxCKnXR5px8y5SyvZ9UfH3zJvG6zS/OQ+aa24=;
        b=QA6W7hEIoaFazFzfZs7Aw00NutEARim7Z+//NMraluZ2qWf75Ew6Z0BUHcyWFTHSEp
         dZ0KdueGSksusfBVji7DXlBfAaSaJUdfUBvNxkityIbXc+ri6/i81p+cmKuiKWDno50S
         Hfsnptxs/cfppu005MrD9/RxKVKZPwji+7AV9iBZAOdu7pjBKoH/qrl0t7OorD2zHaOY
         pbX7HjmT+eOQlM3yWe71zayZudW/rIw8D7q15iAyFs4Kb5IEovKAUJcfYAbu839HC1Vb
         +LwCgnbBsC8JtLFdzIQ3V42cw2wXMoFygs0qArxQ8AUcFz5JpRER0jkB6W/goXLs7Yya
         WfvA==
X-Gm-Message-State: AOAM533oxJI93eJF+/tFwjl/cqcTkuBErPfPr8gmq3JCbuHMp45x/+hM
        R7qk/MFjNfYyhYmvy7PxrUr7PG5s9+1eS5sMTItmVw==
X-Google-Smtp-Source: ABdhPJzqBNoVTeYN8+fPRiK4rwFU6h5BHef17j5dFRZ5eF3FqBCbrAbUQXxKzQoJ0Ost2YWcFgbyrXrclIZGpF61MFA=
X-Received: by 2002:a17:906:70cf:: with SMTP id g15mr4009626ejk.323.1604607973094;
 Thu, 05 Nov 2020 12:26:13 -0800 (PST)
MIME-Version: 1.0
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com> <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <BY5PR12MB43228923300FDE8B087DC4E9DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43228923300FDE8B087DC4E9DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 Nov 2020 12:26:02 -0800
Message-ID: <CAPcyv4h1LH+ojRGqvh_R6mfuBbsibGa8DNMG5M1sN5G1BgwiHw@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 11:40 AM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Ertman, David M <david.m.ertman@intel.com>
> > Sent: Friday, November 6, 2020 12:58 AM
> > Subject: RE: [PATCH v3 01/10] Add auxiliary bus support
> >
> > > -----Original Message-----
> > > From: Dan Williams <dan.j.williams@intel.com>
> > > Sent: Thursday, November 5, 2020 1:19 AM
> > >
>
> [..]
> > > > +
> > > > +Another use case is for the PCI device to be split out into
> > > > +multiple sub functions.  For each sub function an auxiliary_device
> > > > +will be created.  A PCI sub function driver will bind to such
> > > > +devices that will create its own one or more class devices.  A PCI
> > > > +sub function auxiliary device will likely be contained in a struct
> > > > +with additional attributes such as user defined sub function number
> > > > +and optional attributes such as resources and a link to
> > > the
> > > > +parent device.  These attributes could be used by systemd/udev; and
> > > hence should
> > > > +be initialized before a driver binds to an auxiliary_device.
> > >
> > > This does not read like an explicit example like the previous 2. Did
> > > you have something specific in mind?
> > >
> >
> > This was added by request of Parav.
> >
> This example describes the mlx5 PCI subfunction use case.
> I didn't follow your question about 'explicit example'.
> What part is missing to identify it as explicit example?

Specifically listing "mlx5" so if someone reading this document thinks
to themselves "hey mlx5 sounds like my use case" they can go grep for
that.
