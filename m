Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367DD629B66
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiKOOC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238294AbiKOOC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:02:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B122F2AE1B
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668520975; x=1700056975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Hjd1rUR4NX66NbZyLLto8JKEeGu4hl5UvC80BnOy2jg=;
  b=fMWbUpYt03Cq3nvhGUyRZ8JpZ/VVuM+yjz4Egc1r8cL1jNtSXftzkNhf
   9ZuANZl3efx8j5wdhxbg0M2HupDRQMVM4b6McA+svrSszd+mqz5st412C
   KaQ0BlQM95JrQl5hn5+hgDOAvjs+p+F65UEonoEG2l79sdU1/3f1u+mbM
   HXQKZVZVBLQekHtdl16M4V0avo3cBpPDKLj2WXbwxTJ9sUvuL2yC+rDSH
   4AOurqujCTiuN7P64R6V8ZkamzPOHb6LD8lwpruMN41+jzBshOS1vs6+M
   FP+bs+qOzNccNKHQHL7LPQkUi94rqYtVq7AEo6i8/DNaKLNfSZC+m5lI7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="398547566"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="398547566"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 06:02:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="883968954"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="883968954"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 06:02:51 -0800
Date:   Tue, 15 Nov 2022 15:02:40 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3OcAJBfzgggVll9@localhost.localdomain>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <Y3JBaQ7+p5ncsjuW@unreal>
 <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
 <Y3J16ueuhwYeDaww@unreal>
 <Y3M79CuAQNLkFV0S@localhost.localdomain>
 <Y3NJnhxetoSIvqYV@unreal>
 <Y3NWMVF2LV/0lqJX@localhost.localdomain>
 <Y3NcnnNtmL+SSLU+@unreal>
 <Y3NnGk7DCo/1KfpD@localhost.localdomain>
 <Y3OCHLiCzOUKLlHa@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3OCHLiCzOUKLlHa@unreal>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 02:12:12PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 15, 2022 at 11:16:58AM +0100, Michal Swiatkowski wrote:
> > On Tue, Nov 15, 2022 at 11:32:14AM +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 15, 2022 at 10:04:49AM +0100, Michal Swiatkowski wrote:
> > > > On Tue, Nov 15, 2022 at 10:11:10AM +0200, Leon Romanovsky wrote:
> > > > > On Tue, Nov 15, 2022 at 08:12:52AM +0100, Michal Swiatkowski wrote:
> > > > > > On Mon, Nov 14, 2022 at 07:07:54PM +0200, Leon Romanovsky wrote:
> > > > > > > On Mon, Nov 14, 2022 at 09:31:11AM -0600, Samudrala, Sridhar wrote:
> > > > > > > > On 11/14/2022 7:23 AM, Leon Romanovsky wrote:
> > > > > > > > > On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> > > > > > > > > > Currently the default value for number of PF vectors is number of CPUs.
> > > > > > > > > > Because of that there are cases when all vectors are used for PF
> > > > > > > > > > and user can't create more VFs. It is hard to set default number of
> > > > > > > > > > CPUs right for all different use cases. Instead allow user to choose
> > > > > > > > > > how many vectors should be used for various features. After implementing
> > > > > > > > > > subdevices this mechanism will be also used to set number of vectors
> > > > > > > > > > for subfunctions.
> > > > > > > > > > 
> > > > > > > > > > The idea is to set vectors for eth or VFs using devlink resource API.
> > > > > > > > > > New value of vectors will be used after devlink reinit. Example
> > > > > > > > > > commands:
> > > > > > > > > > $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > > > > > > > > > $ sudo devlink dev reload pci/0000:31:00.0
> > > > > > > > > > After reload driver will work with 16 vectors used for eth instead of
> > > > > > > > > > num_cpus.
> > > > > > > > > By saying "vectors", are you referring to MSI-X vectors?
> > > > > > > > > If yes, you have specific interface for that.
> > > > > > > > > https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/
> > > > > > > > 
> > > > > > > > This patch series is exposing a resources API to split the device level MSI-X vectors
> > > > > > > > across the different functions supported by the device (PF, RDMA, SR-IOV VFs and
> > > > > > > > in future subfunctions). Today this is all hidden in a policy implemented within
> > > > > > > > the PF driver.
> > > > > > > 
> > > > > > > Maybe we are talking about different VFs, but if you refer to PCI VFs,
> > > > > > > the amount of MSI-X comes from PCI config space for that specific VF.
> > > > > > > 
> > > > > > > You shouldn't set any value through netdev as it will cause to
> > > > > > > difference in output between lspci (which doesn't require any driver)
> > > > > > > and your newly set number.
> > > > > > 
> > > > > > If I understand correctly, lspci shows the MSI-X number for individual
> > > > > > VF. Value set via devlink is the total number of MSI-X that can be used
> > > > > > when creating VFs. 
> > > > > 
> > > > > Yes and no, lspci shows how much MSI-X vectors exist from HW point of
> > > > > view. Driver can use less than that. It is exactly as your proposed
> > > > > devlink interface.
> > > > > 
> > > > > 
> > > > 
> > > > Ok, I have to take a closer look at it. So, are You saing that we should
> > > > drop this devlink solution and use sysfs interface fo VFs or are You
> > > > fine with having both? What with MSI-X allocation for subfunction?
> > > 
> > > You should drop for VFs and PFs and keep it for SFs only.
> > > 
> > 
> > I understand that MSI-X for VFs can be set via sysfs interface, but what
> > with PFs? 
> 
> PFs are even more tricker than VFs, as you are changing that number
> while driver is bound. This makes me wonder what will be lspci output,
> as you will need to show right number before driver starts to load.
> 
> You need to present right value if user decided to unbind driver from PF too.
>

In case of ice driver lspci -vs shows:
Capabilities: [70] MSI-X: Enable+ Count=1024 Masked

so all vectors that hw supports (PFs, VFs, misc, etc). Because of that
total number of MSI-X in the devlink example from cover letter is 1024.

I see that mellanox shows:
Capabilities: [9c] MSI-X: Enable+ Count=64 Masked

I assume that 64 is in this case MSI-X ony for this one PF (it make
sense).
To be honest I don't know why we show maximum MSI-X for the device
there, but because of that the value will be the same afer changing
allocation of MSI-X across features.

Isn't the MSI-X capabilities read from HW register?

> > Should we always allow max MSI-X for PFs? So hw_max - used -
> > sfs? Is it save to call pci_enable_msix always with max vectors
> > supported by device?
> 
> I'm not sure. I think that it won't give you much if you enable
> more than num_online_cpu().
> 

Oh, yes, correct, I missed that.

> > 
> > I added the value for PFs, because we faced a problem with MSI-X
> > allocation on 8 port device. Our default value (num_cpus) was too big
> > (not enough vectors in hw). Changing the amount of vectors that can be
> > used on PFs was solving the issue.
> 
> We had something similar for mlx5 SFs, where we don't have enough vectors.
> Our solution is simply to move to automatic shared MSI-X mode. I would
> advocate for that for you as well. 
>

Thanks for proposing solution, I will take a look how this work in mlx5.

> > 
> > Let me write an example. As default MSI-X for PF is set to num_cpus, the
> > platform have 128 CPUs, we have 8 port device installed there and still
> > have 1024 vectors in HW (I simplified because I don't count additional
> > interrupts). We run out of vectors, there is 0 vectors that can be used
> > for VFs. Sure, it is easy to handle, we can divide PFs interrupts by 2
> > and will end with 512 vectors for VFs. I assume that with current sysfs
> > interface in this situation MSI-X for VFs can be set from 0 to 512? What
> > if user wants more? If there is a PFs MSI-X value which can be set by
> > user, user can decrease the value and use more vectors for VFs. Is it
> > possible in current VFs sysfs interface? I mean, setting VFs MSI-X
> > vectors to value that will need to decrease MSI-X for PFs.
> 
> You can't do it and this limitation is because PF is bound. You can't change
> that number while driver is running. AFAIR, such change will be PCI spec
> violation.
>

As in previous comment, we have different value in MSI-X capabilities
field (max number of vectors), so I won't allow user to change this
value. I don't know why it is done like that (MSI-X amount for whole
device in PCI caps). I will try to dig into it.

> > 
> > > > 
> > > > > > As Jake said I will fix the code to track both values. Thanks for pointing the patch.
> > > > > > 
> > > > > > > 
> > > > > > > Also in RDMA case, it is not clear what will you achieve by this
> > > > > > > setting too.
> > > > > > >
> > > > > > 
> > > > > > We have limited number of MSI-X (1024) in the device. Because of that
> > > > > > the amount of MSI-X for each feature is set to the best values. Half for
> > > > > > ethernet, half for RDMA. This patchset allow user to change this values.
> > > > > > If he wants more MSI-X for ethernet, he can decrease MSI-X for RDMA.
> > > > > 
> > > > > RDMA devices doesn't have PCI logic and everything is controlled through
> > > > > you main core module. It means that when you create RDMA auxiliary device,
> > > > > it will be connected to netdev (RoCE and iWARP) and that netdev should
> > > > > deal with vectors. So I still don't understand what does it mean "half
> > > > > for RDMA".
> > > > >
> > > > 
> > > > Yes, it is controlled by module, but during probe, MSI-X vectors for RDMA
> > > > are reserved and can't be used by ethernet. For example I have
> > > > 64 CPUs, when loading I get 64 vectors from HW for ethernet and 64 for
> > > > RDMA. The vectors for RDMA will be consumed by irdma driver, so I won't
> > > > be able to use it in ethernet and vice versa.
> > > > 
> > > > By saing it can't be used I mean that irdma driver received the MSI-X
> > > > vectors number and it is using them (connected them with RDMA interrupts).
> > > > 
> > > > Devlink resource is a way to change the number of MSI-X vectors that
> > > > will be reserved for RDMA. You wrote that netdev should deal with
> > > > vectors, but how netdev will know how many vectors should go to RDMA aux
> > > > device? Does there an interface for setting the vectors amount for RDMA
> > > > device?
> > > 
> > > When RDMA core adds device, it calls to irdma_init_rdma_device() and
> > > num_comp_vectors is actually the number of MSI-X vectors which you want
> > > to give to that device.
> > > 
> > > I'm trying to say that probably you shouldn't reserve specific vectors
> > > for both ethernet and RDMA and simply share same vectors. RDMA applications
> > > that care about performance set comp_vector through user space verbs anyway.
> > > 
> > 
> > Thanks for explanation, appriciate that. In our driver num_comp_vectors for
> > RDMA is set during driver probe. Do we have any interface to change
> > num_comp_vectors while driver is working?
> 
> No, as this number is indirectly exposed to the user space.
> 

Ok, thanks.

> > 
> > Sorry, I am not fully familiar with RDMA. Can user app for RDMA set
> > comp_vector to any value or only to max which is num_comp_vectors given
> > for RDMA while creating aux device?
> 
> comp_vector logically equal to IRQ number and this is how RDMA
> applications controls to which interrupt deliver completions.
> 
> " The CQ will use the completion vector comp_vector for signaling
>   completion events; it must be at least zero and less than
>   context->num_comp_vectors. "
> https://man7.org/linux/man-pages/man3/ibv_create_cq.3.html
>

Thank You

> > 
> > Assuming that I gave 64 MSI-X for RDMA by setting num_comp_vectors to
> > 64, how I will know if I can or can't use these vectors in ethernet?
> 
> Why should you need to know? Vectors are not exclusive and they can be
> used by many applications at the same time. The thing is that it is far
> fetch to except that high performance RDMA applications and high
> performance ethernet can coexist on same device at the same time.
>

Yes, but after loading aux device part of vectors (num_comp_vectors) are
reserved for only RDMA use case (at least in ice driver). We though that
devlink resource interface can be a good way to change the
num_comp_vectors in this case.

Maybe I am wrong, but I think that vectors that we reserved for RDMA
can't be used by ethernet (in ice driver). We sent specific MSI-X entries
to rdma driver, so I don't think that the same entries can be reuse by
ethernet. I am talking only about ice + irdma case, am I wrong (probably
question to Intel devs)?

Huge thanks for Your comments here, I understnad more now.

> Thanks
> 
> > 
> > Thanks
> > 
> > > Thanks
> > > 
> > > > 
> > > > Thanks
> > > > 
> > > > > Thanks
