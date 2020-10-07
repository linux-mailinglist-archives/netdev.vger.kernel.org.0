Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8002856C0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 04:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgJGCtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 22:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgJGCtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 22:49:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDA9C0613D2
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 19:49:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dt13so743773ejb.12
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 19:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KnwfFVKsKp11ELDJ3Gxt20tWc3hKiUpWDIgCeiCPHN8=;
        b=MRl1ZMYOEbwZeFSOJvelImWo3hXPk8iz21nm8/a1AV9HzB+TM/1DyFiGY04cS/YTeP
         zqoWdPJjsOwnYPHyJdSg1ic2dS4ggzbTOdQRTJXzEeqYn2n659guFCAty0M6ZKwUgo3u
         ZvjV+kHy7oIOtPzIHH45mqZvYE4/iW4Mb2Ov6ys79xm6PsuP8Wwg0ecVcHOW66LAY7nS
         aaGkUOiiE0NwUSkTlvGO+1nsVgJpeLLxwT2GGGlvn/RDLpo7XGRLp+QQuBAXlHzx1AZC
         rSjXVOyAkflDvsIGjG3v+vP27q1d9yWJlEj6PsEcqonLqZ0uSfPy80Ae45yDvpRJNsaD
         3gmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KnwfFVKsKp11ELDJ3Gxt20tWc3hKiUpWDIgCeiCPHN8=;
        b=oWq0uApSplSm4LQUqhie148LNwNK2ids97leya8J/JNTNPjZdiKCd5JRmbZdKj+vbd
         Mf0Lo4cVwmpBvbS04Aiz6U7R+caq0wgFhHX5zVsTdbGIiG67u2rfUxiJEcVQh/5DGmtU
         djT6DC5psonEoIDaJ5jxkmfO19IFi+/509Coc+FtFVGzrt3E/SqGZ+ausiANnfXi4IzQ
         FMxx2FMX8vkTboMHxnPCyTYBCnXUGPdpQLTlZTM4nbR5+2qgh3HvBEcx8gSf8RDIxnOb
         DIRtJEOTw9Ik2k5CIkd+lJ9Eh9uEpOhenqzvCL1VDeFzLXUa6xOoVDHN2XZ6HouOGkVk
         kDNg==
X-Gm-Message-State: AOAM531FfHKobW1tciQtOGGiFLPfQQKRtjWy4YIuNCK9FP+3/Zbjjt28
        4h5JVE132jAE3K2K1S6L3y7UMXYsPjgPLkVPySAWiA==
X-Google-Smtp-Source: ABdhPJz5q3MciR3ka21H9LsrtLuU6IAfrbeFeHtNQjJAqUG6AF5ysugJFjVS8y9CektO40ja+AxQrmlnqqKlaTNAyEw=
X-Received: by 2002:a17:906:4306:: with SMTP id j6mr1137224ejm.523.1602038978549;
 Tue, 06 Oct 2020 19:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com> <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com> <20201006170241.GM1874917@unreal>
 <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201006172650.GO1874917@unreal> <3ff1445d86564ef3aae28d1d1a9a19ea@intel.com>
 <20201006192036.GQ1874917@unreal>
In-Reply-To: <20201006192036.GQ1874917@unreal>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 6 Oct 2020 19:49:27 -0700
Message-ID: <CAPcyv4iC_KGOx7Jwax-GWxFJbfUM-2+ymSuf4zkCxG=Yob5KnQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 12:21 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Oct 06, 2020 at 05:41:00PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > >
> > > On Tue, Oct 06, 2020 at 05:09:09PM +0000, Parav Pandit wrote:
> > > >
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > Sent: Tuesday, October 6, 2020 10:33 PM
> > > > >
> > > > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > > > > Thanks for the review Leon.
> > > > > >
> > > > > > > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > > > > > > It enables drivers to create an ancillary_device and bind an
> > > > > > > > ancillary_driver to it.
> > > > > > >
> > > > > > > I was under impression that this name is going to be changed.
> > > > > >
> > > > > > It's part of the opens stated in the cover letter.
> > > > >
> > > > > ok, so what are the variants?
> > > > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > > > Since the intended use of this bus is to
> > > > (a) create sub devices that represent 'functional separation' and
> > > > (b) second use case for subfunctions from a pci device,
> > > >
> > > > I proposed below names in v1 of this patchset.
> > > >
> > > > (a) subdev_bus
> > >
> > > It sounds good, just can we avoid "_" in the name and call it subdev?
> > >
> >
> > What is wrong with naming the bus 'ancillary bus'? I feel it's a fitting name.
> > An ancillary software bus for ancillary devices carved off a parent device registered on a primary bus.
>
> Greg summarized it very well, every internal conversation about this patch
> with my colleagues (non-english speakers) starts with the question:
> "What does ancillary mean?"
> https://lore.kernel.org/alsa-devel/20201001071403.GC31191@kroah.com/
>
> "For non-native english speakers this is going to be rough,
> given that I as a native english speaker had to go look up
> the word in a dictionary to fully understand what you are
> trying to do with that name."

I suggested "auxiliary" in another splintered thread on this question.
In terms of what the kernel is already using:

$ git grep auxiliary | wc -l
507
$ git grep ancillary | wc -l
153

Empirically, "auxiliary" is more common and closely matches the
intended function of these devices relative to their parent device.
