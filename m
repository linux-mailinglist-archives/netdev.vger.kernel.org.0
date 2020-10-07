Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30362867CC
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgJGS4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJGS4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:56:07 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C3CC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 11:56:07 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ly6so4486142ejb.8
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfiJ5nD/cUmyiqlzNZewJWZjW4mmc4Boj3zx3Rxdevw=;
        b=F89nKzkhVw+pwSxd4I+Ro29bXc2Yy4aOTB0aRdedpGp4Xf5mIKcUUeC4WmcHJUQJhT
         UmyJ5u0llCJiofg5m/aBddvUXcqKgw19yZWf2cFnhojQASzzrRtifWjlVLdkVTE2uFt0
         f3r2Gr1CFfl4iERMNNQNTk+RiZo68CSSTSeHrj3xhWY6hGPtSy+eN0gPGg9at54tggYn
         Xxd1PwlQsNUZMa5HsqCTBWAfgRGNsYKdj9jkf+QR8E28eeYFJZRGgn2VW/7oY5PJ/sjZ
         vAb5jAvQBmIVvqj93TjfKNqcJNJ2OOqcgAgufr6IGab7ZF182lxt3MbvDJknrgJcxDId
         ZXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfiJ5nD/cUmyiqlzNZewJWZjW4mmc4Boj3zx3Rxdevw=;
        b=UQlusYfx8+V9+1RQhr+hHfYi0BQFXLRbVtfD+vFaqMadM3qCgREmRwvd1X/891RPmi
         qgOLlhX3Ryu0eozEU5UWicXx2G/KuK1sFRFgUAeEYApnc15QwOnRf4DazGGDbwrxNmKe
         Vt5hchsokO6NHCmBTKha55wSiE6yA/OEhhjMxsn0U50T88jL8e/YHGendYNmXdPuTxhN
         9cd8kCxRnyOqYXPHwTlZG/sjVNRfQZnhZgqEh7WaHH1uS5YGIauychnAm9rFvUGxXFuw
         +zbepBIzvxBL9rvpFuBDlTVWHT1/10MoLE8HtERsFtAeYLgSb7yI+dc63XGlckhaHg9S
         ivOQ==
X-Gm-Message-State: AOAM531peJcln696qMdwQg/r2UPG/htaw2DFRFTj7x2LJsn0zw3AsR/w
        BjROiHhwVUE5ZmZb6fvV+8Vy7oUj6RNK/zYd0bnEow==
X-Google-Smtp-Source: ABdhPJyNpzrYFZKJNGR3LOKY++IvBFmX8qfeS5JqUyOBjoxQwDjRp/d7m0uUE6VIQpOeEI+tD7+gLGvhR+0lRO7kp6k=
X-Received: by 2002:a17:906:1a0b:: with SMTP id i11mr4831823ejf.472.1602096965738;
 Wed, 07 Oct 2020 11:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal> <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal> <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201006172650.GO1874917@unreal> <3ff1445d86564ef3aae28d1d1a9a19ea@intel.com>
 <20201006192036.GQ1874917@unreal> <CAPcyv4iC_KGOx7Jwax-GWxFJbfUM-2+ymSuf4zkCxG=Yob5KnQ@mail.gmail.com>
 <cd80aad674ee48faaaedc8698c9b23e2@intel.com> <20201007133633.GB3964015@unreal>
In-Reply-To: <20201007133633.GB3964015@unreal>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 7 Oct 2020 11:55:53 -0700
Message-ID: <CAPcyv4j1VrPkX_=61S7pdCPdDGy+xFGMkHHNnR-FT+TXXvbOWA@mail.gmail.com>
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

On Wed, Oct 7, 2020 at 6:37 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Oct 07, 2020 at 01:09:55PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > >
> > > On Tue, Oct 6, 2020 at 12:21 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Tue, Oct 06, 2020 at 05:41:00PM +0000, Saleem, Shiraz wrote:
> > > > > > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > > > > >
> > > > > > On Tue, Oct 06, 2020 at 05:09:09PM +0000, Parav Pandit wrote:
> > > > > > >
> > > > > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > > > > Sent: Tuesday, October 6, 2020 10:33 PM
> > > > > > > >
> > > > > > > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > > > > > > > Thanks for the review Leon.
> > > > > > > > >
> > > > > > > > > > > Add support for the Ancillary Bus, ancillary_device and
> > > ancillary_driver.
> > > > > > > > > > > It enables drivers to create an ancillary_device and
> > > > > > > > > > > bind an ancillary_driver to it.
> > > > > > > > > >
> > > > > > > > > > I was under impression that this name is going to be changed.
> > > > > > > > >
> > > > > > > > > It's part of the opens stated in the cover letter.
> > > > > > > >
> > > > > > > > ok, so what are the variants?
> > > > > > > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > > > > > > Since the intended use of this bus is to
> > > > > > > (a) create sub devices that represent 'functional separation'
> > > > > > > and
> > > > > > > (b) second use case for subfunctions from a pci device,
> > > > > > >
> > > > > > > I proposed below names in v1 of this patchset.
> > > > > >
> > > > > > > (a) subdev_bus
> > > > > >
> > > > > > It sounds good, just can we avoid "_" in the name and call it subdev?
> > > > > >
> > > > >
> > > > > What is wrong with naming the bus 'ancillary bus'? I feel it's a fitting name.
> > > > > An ancillary software bus for ancillary devices carved off a parent device
> > > registered on a primary bus.
> > > >
> > > > Greg summarized it very well, every internal conversation about this
> > > > patch with my colleagues (non-english speakers) starts with the question:
> > > > "What does ancillary mean?"
> > > > https://lore.kernel.org/alsa-devel/20201001071403.GC31191@kroah.com/
> > > >
> > > > "For non-native english speakers this is going to be rough, given that
> > > > I as a native english speaker had to go look up the word in a
> > > > dictionary to fully understand what you are trying to do with that
> > > > name."
> > >
> > > I suggested "auxiliary" in another splintered thread on this question.
> > > In terms of what the kernel is already using:
> > >
> > > $ git grep auxiliary | wc -l
> > > 507
> > > $ git grep ancillary | wc -l
> > > 153
> > >
> > > Empirically, "auxiliary" is more common and closely matches the intended function
> > > of these devices relative to their parent device.
> >
> > auxiliary bus is a befitting name as well.
>
> Let's share all options and decide later.
> I don't want to find us bikeshedding about it.

Too late we are deep into bikeshedding at this point... it continued
over here [1] for a bit, but let's try to bring the discussion back to
this thread.

[1]: http://lore.kernel.org/r/10048d4d-038c-c2b7-2ed7-fd4ca87d104a@linux.intel.com
