Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EA862945D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiKOJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiKOJc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:32:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA98FACF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36E47CE13BB
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7191EC433D6;
        Tue, 15 Nov 2022 09:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668504739;
        bh=wPyDIlafVi9vwn2PVi5AiLba67I8BO9eLvWZrnYixeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bc60fjHO2SboRDsO85q+8M7zLw9VYFXIlIZpVJtINa/lKO37dUEMMgxYX0RaEjS8K
         eJKoecQRnvNJWmg7qzvC7A/MuhAyC1+20pN/V4EkHLjaG3l1JPvTDpKiQvXlskekux
         XAdw+bO8H8PiamM/aPT9fTr/j9sw4Kn0ZqB7CljIS/J9QvGE+NHvV+4V4EM9LYgGik
         9GCZLXe8QHfwSWRUQYb/+3DyQ86zoyFd8s9+dW99zedlS46BbyT+lBPvAzxRlOnT/G
         EZzj7GM2ugb0GZ5Z18LJT9n0a3URunZQMyzO0p6YStyuX9ruk4dXq7TjE9WNeF7qSX
         dsboRdnVKznMw==
Date:   Tue, 15 Nov 2022 11:32:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
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
Message-ID: <Y3NcnnNtmL+SSLU+@unreal>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <Y3JBaQ7+p5ncsjuW@unreal>
 <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
 <Y3J16ueuhwYeDaww@unreal>
 <Y3M79CuAQNLkFV0S@localhost.localdomain>
 <Y3NJnhxetoSIvqYV@unreal>
 <Y3NWMVF2LV/0lqJX@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3NWMVF2LV/0lqJX@localhost.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:04:49AM +0100, Michal Swiatkowski wrote:
> On Tue, Nov 15, 2022 at 10:11:10AM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 15, 2022 at 08:12:52AM +0100, Michal Swiatkowski wrote:
> > > On Mon, Nov 14, 2022 at 07:07:54PM +0200, Leon Romanovsky wrote:
> > > > On Mon, Nov 14, 2022 at 09:31:11AM -0600, Samudrala, Sridhar wrote:
> > > > > On 11/14/2022 7:23 AM, Leon Romanovsky wrote:
> > > > > > On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> > > > > > > Currently the default value for number of PF vectors is number of CPUs.
> > > > > > > Because of that there are cases when all vectors are used for PF
> > > > > > > and user can't create more VFs. It is hard to set default number of
> > > > > > > CPUs right for all different use cases. Instead allow user to choose
> > > > > > > how many vectors should be used for various features. After implementing
> > > > > > > subdevices this mechanism will be also used to set number of vectors
> > > > > > > for subfunctions.
> > > > > > > 
> > > > > > > The idea is to set vectors for eth or VFs using devlink resource API.
> > > > > > > New value of vectors will be used after devlink reinit. Example
> > > > > > > commands:
> > > > > > > $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > > > > > > $ sudo devlink dev reload pci/0000:31:00.0
> > > > > > > After reload driver will work with 16 vectors used for eth instead of
> > > > > > > num_cpus.
> > > > > > By saying "vectors", are you referring to MSI-X vectors?
> > > > > > If yes, you have specific interface for that.
> > > > > > https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/
> > > > > 
> > > > > This patch series is exposing a resources API to split the device level MSI-X vectors
> > > > > across the different functions supported by the device (PF, RDMA, SR-IOV VFs and
> > > > > in future subfunctions). Today this is all hidden in a policy implemented within
> > > > > the PF driver.
> > > > 
> > > > Maybe we are talking about different VFs, but if you refer to PCI VFs,
> > > > the amount of MSI-X comes from PCI config space for that specific VF.
> > > > 
> > > > You shouldn't set any value through netdev as it will cause to
> > > > difference in output between lspci (which doesn't require any driver)
> > > > and your newly set number.
> > > 
> > > If I understand correctly, lspci shows the MSI-X number for individual
> > > VF. Value set via devlink is the total number of MSI-X that can be used
> > > when creating VFs. 
> > 
> > Yes and no, lspci shows how much MSI-X vectors exist from HW point of
> > view. Driver can use less than that. It is exactly as your proposed
> > devlink interface.
> > 
> > 
> 
> Ok, I have to take a closer look at it. So, are You saing that we should
> drop this devlink solution and use sysfs interface fo VFs or are You
> fine with having both? What with MSI-X allocation for subfunction?

You should drop for VFs and PFs and keep it for SFs only.

> 
> > > As Jake said I will fix the code to track both values. Thanks for pointing the patch.
> > > 
> > > > 
> > > > Also in RDMA case, it is not clear what will you achieve by this
> > > > setting too.
> > > >
> > > 
> > > We have limited number of MSI-X (1024) in the device. Because of that
> > > the amount of MSI-X for each feature is set to the best values. Half for
> > > ethernet, half for RDMA. This patchset allow user to change this values.
> > > If he wants more MSI-X for ethernet, he can decrease MSI-X for RDMA.
> > 
> > RDMA devices doesn't have PCI logic and everything is controlled through
> > you main core module. It means that when you create RDMA auxiliary device,
> > it will be connected to netdev (RoCE and iWARP) and that netdev should
> > deal with vectors. So I still don't understand what does it mean "half
> > for RDMA".
> >
> 
> Yes, it is controlled by module, but during probe, MSI-X vectors for RDMA
> are reserved and can't be used by ethernet. For example I have
> 64 CPUs, when loading I get 64 vectors from HW for ethernet and 64 for
> RDMA. The vectors for RDMA will be consumed by irdma driver, so I won't
> be able to use it in ethernet and vice versa.
> 
> By saing it can't be used I mean that irdma driver received the MSI-X
> vectors number and it is using them (connected them with RDMA interrupts).
> 
> Devlink resource is a way to change the number of MSI-X vectors that
> will be reserved for RDMA. You wrote that netdev should deal with
> vectors, but how netdev will know how many vectors should go to RDMA aux
> device? Does there an interface for setting the vectors amount for RDMA
> device?

When RDMA core adds device, it calls to irdma_init_rdma_device() and
num_comp_vectors is actually the number of MSI-X vectors which you want
to give to that device.

I'm trying to say that probably you shouldn't reserve specific vectors
for both ethernet and RDMA and simply share same vectors. RDMA applications
that care about performance set comp_vector through user space verbs anyway.

Thanks

> 
> Thanks
> 
> > Thanks
