Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21EB286E0C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 07:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgJHFVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 01:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgJHFVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 01:21:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CA720659;
        Thu,  8 Oct 2020 05:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602134501;
        bh=vJb76P79pOLUgt2vBkS0qzTujOiqXJm1lL7ssRNU9Es=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RBF3g3CswRDNpEr82rgRvvml4H/p0PJrI5Ff7RKqRDparZzSHv5o/iTC1uVIQmRXv
         SQ1HkXq3Kn2lUR0tfsdQ4jZEJNh7QhXkUg7zgdC7hN21Etd3u4akovBCK/Igrecsdo
         BFWxC6epCnv+/951Ucd5ZOuQQAw2NQjjj7nUt7so=
Date:   Thu, 8 Oct 2020 08:21:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
Message-ID: <20201008052137.GA13580@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 08:46:45PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Parav Pandit <parav@nvidia.com>
> > Sent: Wednesday, October 7, 2020 1:17 PM
> > To: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> > <david.m.ertman@intel.com>
> > Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; alsa-
> > devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> > netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com;
> > fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> > dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> > <jgg@nvidia.com>; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > <kiran.patil@intel.com>
> > Subject: RE: [PATCH v2 1/6] Add ancillary bus support
> >
> >
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Thursday, October 8, 2020 12:56 AM
> > >
> > > > > This API is partially obscures low level driver-core code and needs
> > > > > to provide clear and proper abstractions without need to remember
> > > > > about put_device. There is already _add() interface why don't you do
> > > > > put_device() in it?
> > > > >
> > > >
> > > > The pushback Pierre is referring to was during our mid-tier internal
> > > > review.  It was primarily a concern of Parav as I recall, so he can speak to
> > his
> > > reasoning.
> > > >
> > > > What we originally had was a single API call
> > > > (ancillary_device_register) that started with a call to
> > > > device_initialize(), and every error path out of the function performed a
> > > put_device().
> > > >
> > > > Is this the model you have in mind?
> > >
> > > I don't like this flow:
> > > ancillary_device_initialize()
> > > if (ancillary_ancillary_device_add()) {
> > >   put_device(....)
> > >   ancillary_device_unregister()
> > Calling device_unregister() is incorrect, because add() wasn't successful.
> > Only put_device() or a wrapper ancillary_device_put() is necessary.
> >
> > >   return err;
> > > }
> > >
> > > And prefer this flow:
> > > ancillary_device_initialize()
> > > if (ancillary_device_add()) {
> > >   ancillary_device_unregister()
> > This is incorrect and a clear deviation from the current core APIs that adds the
> > confusion.
> >
> > >   return err;
> > > }
> > >
> > > In this way, the ancillary users won't need to do non-intuitive put_device();
> >
> > Below is most simple, intuitive and matching with core APIs for name and
> > design pattern wise.
> > init()
> > {
> > 	err = ancillary_device_initialize();
> > 	if (err)
> > 		return ret;
> >
> > 	err = ancillary_device_add();
> > 	if (ret)
> > 		goto err_unwind;
> >
> > 	err = some_foo();
> > 	if (err)
> > 		goto err_foo;
> > 	return 0;
> >
> > err_foo:
> > 	ancillary_device_del(adev);
> > err_unwind:
> > 	ancillary_device_put(adev->dev);
> > 	return err;
> > }
> >
> > cleanup()
> > {
> > 	ancillary_device_de(adev);
> > 	ancillary_device_put(adev);
> > 	/* It is common to have a one wrapper for this as
> > ancillary_device_unregister().
> > 	 * This will match with core device_unregister() that has precise
> > documentation.
> > 	 * but given fact that init() code need proper error unwinding, like
> > above,
> > 	 * it make sense to have two APIs, and no need to export another
> > symbol for unregister().
> > 	 * This pattern is very easy to audit and code.
> > 	 */
> > }
>
> I like this flow +1
>
> But ... since the init() function is performing both device_init and
> device_add - it should probably be called ancillary_device_register,
> and we are back to a single exported API for both register and
> unregister.
>
> At that point, do we need wrappers on the primitives init, add, del,
> and put?

Let me summarize.
1. You are not providing driver/core API but simplification and obfuscation
of basic primitives and structures. This is new layer. There is no room for
a claim that we must to follow internal API.
2. API should be symmetric. If you call to _register()/_add(), you will need
to call to _unregister()/_del(). Please don't add obscure _put().
3. You can't "ask" from users to call internal calls (put_device) over internal
fields in ancillary_device.
4. This API should be clear to drivers authors, "device_add()" call (and
semantic) is not used by the drivers (git grep " device_add(" drivers/).

Thanks

>
> -DaveE
