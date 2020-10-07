Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12300286844
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 21:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgJGT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 15:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgJGT0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 15:26:15 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41192173E;
        Wed,  7 Oct 2020 19:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602098774;
        bh=9Efq9BJM0KiSLLuORpyyMZ3t9JH6nYm17qQk8rQ+PLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qgUBgA3R7+nTAqG++g8VKyGQRyilQJ6UoRyHiVUvMT4DZpk9MbV2HSNwVFUJak3/I
         xepI6uJRdeQo5JbXMjMsFZ9HSv/GWk4iAuGOz0HfoKwKw67rYF+T164DG/upF8atkw
         GdbDbu56q2++rrZ4BGpT0Z++xOfgecjJcuvXKd/E=
Date:   Wed, 7 Oct 2020 22:26:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201007192610.GD3964015@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 06:06:30PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, October 6, 2020 10:03 AM
> > To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Cc: Ertman, David M <david.m.ertman@intel.com>; alsa-devel@alsa-
> > project.org; parav@mellanox.com; tiwai@suse.de; netdev@vger.kernel.org;
> > ranjani.sridharan@linux.intel.com; fred.oh@linux.intel.com; linux-
> > rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> > jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > <kiran.patil@intel.com>
> > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> >
> > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > Thanks for the review Leon.
> > >
> > > > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > > > It enables drivers to create an ancillary_device and bind an
> > > > > ancillary_driver to it.
> > > >
> > > > I was under impression that this name is going to be changed.
> > >
> > > It's part of the opens stated in the cover letter.
> >
> > ok, so what are the variants?
> > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> >
> > >
> > > [...]
> > >
> > > > > +	const struct my_driver my_drv = {
> > > > > +		.ancillary_drv = {
> > > > > +			.driver = {
> > > > > +				.name = "myancillarydrv",
> > > >
> > > > Why do we need to give control over driver name to the driver authors?
> > > > It can be problematic if author puts name that already exists.
> > >
> > > Good point. When I used the ancillary_devices for my own SoundWire test,
> > the
> > > driver name didn't seem specifically meaningful but needed to be set to
> > > something, what mattered was the id_table. Just thinking aloud, maybe we
> > can
> > > add prefixing with KMOD_BUILD, as we've done already to avoid collisions
> > > between device names?
> >
> > IMHO, it shouldn't be controlled by the drivers at all and need to have
> > kernel module name hardwired. Users will use it later for various
> > bind/unbind/autoprobe tricks and it will give predictability for them.
> >
> > >
> > > [...]
> > >
> > > > > +int __ancillary_device_add(struct ancillary_device *ancildev, const
> > char *modname)
> > > > > +{
> > > > > +	struct device *dev = &ancildev->dev;
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!modname) {
> > > > > +		pr_err("ancillary device modname is NULL\n");
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	ret = dev_set_name(dev, "%s.%s.%d", modname, ancildev->name,
> > ancildev->id);
> > > > > +	if (ret) {
> > > > > +		pr_err("ancillary device dev_set_name failed: %d\n", ret);
> > > > > +		return ret;
> > > > > +	}
> > > > > +
> > > > > +	ret = device_add(dev);
> > > > > +	if (ret)
> > > > > +		dev_err(dev, "adding ancillary device failed!: %d\n", ret);
> > > > > +
> > > > > +	return ret;
> > > > > +}
> > > >
> > > > Sorry, but this is very strange API that requires users to put
> > > > internal call to "dev" that is buried inside "struct ancillary_device".
> > > >
> > > > For example in your next patch, you write this "put_device(&cdev-
> > >ancildev.dev);"
> > > >
> > > > I'm pretty sure that the amount of bugs in error unwind will be
> > > > astonishing, so if you are doing wrappers over core code, better do not
> > > > pass complexity to the users.
> > >
> > > In initial reviews, there was pushback on adding wrappers that don't do
> > > anything except for a pointer indirection.
> > >
> > > Others had concerns that the API wasn't balanced and blurring layers.
> >
> > Are you talking about internal review or public?
> > If it is public, can I get a link to it?
> >
> > >
> > > Both points have merits IMHO. Do we want wrappers for everything and
> > > completely hide the low-level device?
> >
> > This API is partially obscures low level driver-core code and needs to
> > provide clear and proper abstractions without need to remember about
> > put_device. There is already _add() interface why don't you do
> > put_device() in it?
> >
>
> The pushback Pierre is referring to was during our mid-tier internal review.  It was
> primarily a concern of Parav as I recall, so he can speak to his reasoning.
>
> What we originally had was a single API call (ancillary_device_register) that started
> with a call to device_initialize(), and every error path out of the function performed
> a put_device().
>
> Is this the model you have in mind?

I don't like this flow:
ancillary_device_initialize()
if (ancillary_ancillary_device_add()) {
  put_device(....)
  ancillary_device_unregister()
  return err;
}

And prefer this flow:
ancillary_device_initialize()
if (ancillary_device_add()) {
  ancillary_device_unregister()
  return err;
}

In this way, the ancillary users won't need to do non-intuitive put_device();

Thanks
