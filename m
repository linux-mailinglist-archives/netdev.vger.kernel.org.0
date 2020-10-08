Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9341286E13
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 07:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJHF02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 01:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgJHF02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 01:26:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48A9320708;
        Thu,  8 Oct 2020 05:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602134787;
        bh=/KC8SYmVhsAPwhDcSPWxDyKU8idi29YzN2Gwgc8ifro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+IA7WVn+08OlKm0xfQHpXE38NaYkfRfgRqCmIFQ5pOUqAYykcsQhkBx3gvYEkORZ
         eEVLnmGk4w/6TxxyWGZ/pYsSt/0D0qqJ37S2zyyXdTU0p6I6sPTLLu2gOwsxdVmUp7
         V4pmDotAL27lWCvuNpkxWztyvy9BEzi1FMyYEN08=
Date:   Thu, 8 Oct 2020 08:26:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201008052623.GB13580@unreal>
References: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 04:56:01AM +0000, Parav Pandit wrote:
>
>
> > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Sent: Thursday, October 8, 2020 3:20 AM
> >
> >
> > On 10/7/20 4:22 PM, Ertman, David M wrote:
> > >> -----Original Message-----
> > >> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > >> Sent: Wednesday, October 7, 2020 1:59 PM
> > >> To: Ertman, David M <david.m.ertman@intel.com>; Parav Pandit
> > >> <parav@nvidia.com>; Leon Romanovsky <leon@kernel.org>
> > >> Cc: alsa-devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> > >> netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com;
> > >> fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> > >> dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> > >> <jgg@nvidia.com>; gregkh@linuxfoundation.org; kuba@kernel.org;
> > >> Williams, Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > >> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > >> <kiran.patil@intel.com>
> > >> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > >>
> > >>
> > >>
> > >>>> Below is most simple, intuitive and matching with core APIs for
> > >>>> name and design pattern wise.
> > >>>> init()
> > >>>> {
> > >>>> 	err = ancillary_device_initialize();
> > >>>> 	if (err)
> > >>>> 		return ret;
> > >>>>
> > >>>> 	err = ancillary_device_add();
> > >>>> 	if (ret)
> > >>>> 		goto err_unwind;
> > >>>>
> > >>>> 	err = some_foo();
> > >>>> 	if (err)
> > >>>> 		goto err_foo;
> > >>>> 	return 0;
> > >>>>
> > >>>> err_foo:
> > >>>> 	ancillary_device_del(adev);
> > >>>> err_unwind:
> > >>>> 	ancillary_device_put(adev->dev);
> > >>>> 	return err;
> > >>>> }
> > >>>>
> > >>>> cleanup()
> > >>>> {
> > >>>> 	ancillary_device_de(adev);
> > >>>> 	ancillary_device_put(adev);
> > >>>> 	/* It is common to have a one wrapper for this as
> > >>>> ancillary_device_unregister().
> > >>>> 	 * This will match with core device_unregister() that has precise
> > >>>> documentation.
> > >>>> 	 * but given fact that init() code need proper error unwinding,
> > >>>> like above,
> > >>>> 	 * it make sense to have two APIs, and no need to export another
> > >>>> symbol for unregister().
> > >>>> 	 * This pattern is very easy to audit and code.
> > >>>> 	 */
> > >>>> }
> > >>>
> > >>> I like this flow +1
> > >>>
> > >>> But ... since the init() function is performing both device_init and
> > >>> device_add - it should probably be called ancillary_device_register,
> > >>> and we are back to a single exported API for both register and
> > >>> unregister.
> > >>
> > >> Kind reminder that we introduced the two functions to allow the
> > >> caller to know if it needed to free memory when initialize() fails,
> > >> and it didn't need to free memory when add() failed since
> > >> put_device() takes care of it. If you have a single init() function
> > >> it's impossible to know which behavior to select on error.
> > >>
> > >> I also have a case with SoundWire where it's nice to first
> > >> initialize, then set some data and then add.
> > >>
> > >
> > > The flow as outlined by Parav above does an initialize as the first
> > > step, so every error path out of the function has to do a
> > > put_device(), so you would never need to manually free the memory in
> > the setup function.
> > > It would be freed in the release call.
> >
> > err = ancillary_device_initialize();
> > if (err)
> > 	return ret;
> >
> > where is the put_device() here? if the release function does any sort of
> > kfree, then you'd need to do it manually in this case.
> Since device_initialize() failed, put_device() cannot be done here.
> So yes, pseudo code should have shown,
> if (err) {
> 	kfree(adev);
> 	return err;
> }
>
> If we just want to follow register(), unregister() pattern,
>
> Than,
>
> ancillar_device_register() should be,
>
> /**
>  * ancillar_device_register() - register an ancillary device
>  * NOTE: __never directly free @adev after calling this function, even if it returned
>  * an error. Always use ancillary_device_put() to give up the reference initialized by this function.
>  * This note matches with the core and caller knows exactly what to be done.
>  */
> ancillary_device_register()
> {
> 	device_initialize(&adev->dev);
> 	if (!dev->parent || !adev->name)
> 		return -EINVAL;
> 	if (!dev->release && !(dev->type && dev->type->release)) {
> 		/* core is already capable and throws the warning when release callback is not set.
> 		 * It is done at drivers/base/core.c:1798.
> 		 * For NULL release it says, "does not have a release() function, it is broken and must be fixed"
> 		 */
> 		return -EINVAL;
> 	}
> 	err = dev_set_name(adev...);
> 	if (err) {
> 		/* kobject_release() -> kobject_cleanup() are capable to detect if name is set/ not set
> 		  * and free the const if it was set.
> 		  */
> 		return err;
> 	}
> 	err = device_add(&adev->dev);
> 	If (err)
> 		return err;
> }
>
> Caller code:
> init()
> {
> 	adev = kzalloc(sizeof(*foo_adev)..);
> 	if (!adev)
> 		return -ENOMEM;
> 	err = ancillary_device_register(&adev);
> 	if (err)
> 		goto err;
>
> err:
> 	ancillary_device_put(&adev);
> 	return err;
> }
>
> cleanup()
> {
> 	ancillary_device_unregister(&adev);
> }
>
> Above pattern is fine too matching the core.
>
> If I understand Leon correctly, he prefers simple register(), unregister() pattern.
> If, so it should be explicit register(), unregister() API.

This is my summary
https://lore.kernel.org/linux-rdma/20201008052137.GA13580@unreal
The API should be symmetric.

Thanks
