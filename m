Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FFB62A0CB
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiKOR5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKOR5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:57:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A993F2DA8C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:57:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36518B81A16
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 17:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14661C433B5;
        Tue, 15 Nov 2022 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668535033;
        bh=ytdtL8Krb2Fy+/2ovCnOJ064N/5g/txm0wO9lFhbuEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Drq5vCtOJRGwbRZCxWide6MhePg2ScL3R5k+u9p6hnOHu8D4qr/jFiWcjJXcsRDqJ
         Nk9oW4pWOjxHVrx1dWQtW0O75Xju4XkMrqEhqgFoVgNjs96jK274/vq+6KI9KHgWvk
         rkHH2ajFs2Yr/JvszpCtsd4eVgjQlGaj5FleJDRJAdkA++JhRohUXX8vfAQ5CaCHm1
         I0+d9j1wOglnZgEk36o2vFGRJztKi0oKzUmArduQQCtMq+x1vLGC52kpeOnfIkR+4L
         hAp8SNBfExwmmOm3lcUcXy7XGtdoe/X5T78eXWjUVbdkzY2nrhIcQvbHzdVNwf/Gol
         FKOWlsEqIfG7g==
Date:   Tue, 15 Nov 2022 19:57:09 +0200
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
Message-ID: <Y3PS9e9MJEZo++z5@unreal>
References: <Y3JBaQ7+p5ncsjuW@unreal>
 <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
 <Y3J16ueuhwYeDaww@unreal>
 <Y3M79CuAQNLkFV0S@localhost.localdomain>
 <Y3NJnhxetoSIvqYV@unreal>
 <Y3NWMVF2LV/0lqJX@localhost.localdomain>
 <Y3NcnnNtmL+SSLU+@unreal>
 <Y3NnGk7DCo/1KfpD@localhost.localdomain>
 <Y3OCHLiCzOUKLlHa@unreal>
 <Y3OcAJBfzgggVll9@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3OcAJBfzgggVll9@localhost.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 03:02:40PM +0100, Michal Swiatkowski wrote:
> On Tue, Nov 15, 2022 at 02:12:12PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 15, 2022 at 11:16:58AM +0100, Michal Swiatkowski wrote:
> > > On Tue, Nov 15, 2022 at 11:32:14AM +0200, Leon Romanovsky wrote:
> > > > On Tue, Nov 15, 2022 at 10:04:49AM +0100, Michal Swiatkowski wrote:
> > > > > On Tue, Nov 15, 2022 at 10:11:10AM +0200, Leon Romanovsky wrote:
> > > > > > On Tue, Nov 15, 2022 at 08:12:52AM +0100, Michal Swiatkowski wrote:
> > > > > > > On Mon, Nov 14, 2022 at 07:07:54PM +0200, Leon Romanovsky wrote:
> > > > > > > > On Mon, Nov 14, 2022 at 09:31:11AM -0600, Samudrala, Sridhar wrote:
> > > > > > > > > On 11/14/2022 7:23 AM, Leon Romanovsky wrote:
> > > > > > > > > > On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> > > > > > > > > > > Currently the default value for number of PF vectors is number of CPUs.
> > > > > > > > > > > Because of that there are cases when all vectors are used for PF
> > > > > > > > > > > and user can't create more VFs. It is hard to set default number of
> > > > > > > > > > > CPUs right for all different use cases. Instead allow user to choose
> > > > > > > > > > > how many vectors should be used for various features. After implementing
> > > > > > > > > > > subdevices this mechanism will be also used to set number of vectors
> > > > > > > > > > > for subfunctions.
> > > > > > > > > > > 
> > > > > > > > > > > The idea is to set vectors for eth or VFs using devlink resource API.
> > > > > > > > > > > New value of vectors will be used after devlink reinit. Example
> > > > > > > > > > > commands:
> > > > > > > > > > > $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > > > > > > > > > > $ sudo devlink dev reload pci/0000:31:00.0
> > > > > > > > > > > After reload driver will work with 16 vectors used for eth instead of
> > > > > > > > > > > num_cpus.
> > > > > > > > > > By saying "vectors", are you referring to MSI-X vectors?
> > > > > > > > > > If yes, you have specific interface for that.
> > > > > > > > > > https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/
> > > > > > > > > 
> > > > > > > > > This patch series is exposing a resources API to split the device level MSI-X vectors
> > > > > > > > > across the different functions supported by the device (PF, RDMA, SR-IOV VFs and
> > > > > > > > > in future subfunctions). Today this is all hidden in a policy implemented within
> > > > > > > > > the PF driver.
> > > > > > > > 
> > > > > > > > Maybe we are talking about different VFs, but if you refer to PCI VFs,
> > > > > > > > the amount of MSI-X comes from PCI config space for that specific VF.
> > > > > > > > 
> > > > > > > > You shouldn't set any value through netdev as it will cause to
> > > > > > > > difference in output between lspci (which doesn't require any driver)
> > > > > > > > and your newly set number.
> > > > > > > 
> > > > > > > If I understand correctly, lspci shows the MSI-X number for individual
> > > > > > > VF. Value set via devlink is the total number of MSI-X that can be used
> > > > > > > when creating VFs. 
> > > > > > 
> > > > > > Yes and no, lspci shows how much MSI-X vectors exist from HW point of
> > > > > > view. Driver can use less than that. It is exactly as your proposed
> > > > > > devlink interface.
> > > > > > 
> > > > > > 
> > > > > 
> > > > > Ok, I have to take a closer look at it. So, are You saing that we should
> > > > > drop this devlink solution and use sysfs interface fo VFs or are You
> > > > > fine with having both? What with MSI-X allocation for subfunction?
> > > > 
> > > > You should drop for VFs and PFs and keep it for SFs only.
> > > > 
> > > 
> > > I understand that MSI-X for VFs can be set via sysfs interface, but what
> > > with PFs? 
> > 
> > PFs are even more tricker than VFs, as you are changing that number
> > while driver is bound. This makes me wonder what will be lspci output,
> > as you will need to show right number before driver starts to load.
> > 
> > You need to present right value if user decided to unbind driver from PF too.
> >
> 
> In case of ice driver lspci -vs shows:
> Capabilities: [70] MSI-X: Enable+ Count=1024 Masked
> 
> so all vectors that hw supports (PFs, VFs, misc, etc). Because of that
> total number of MSI-X in the devlink example from cover letter is 1024.
> 
> I see that mellanox shows:
> Capabilities: [9c] MSI-X: Enable+ Count=64 Masked
> 
> I assume that 64 is in this case MSI-X ony for this one PF (it make
> sense).

Yes and PF MSI-X count can be changed through FW configuration tool, as
we need to write new value when the driver is unbound and we need it to
be persistent. Users are expecting to see "stable" number any time they
reboot the server. It is not the case for VFs, as they are explicitly
created after reboots and start "fresh" after every boot.

So we set large enough but not too large value as a default for PFs.
If you find sane model of how to change it through kernel, you can count
on our support.

> To be honest I don't know why we show maximum MSI-X for the device
> there, but because of that the value will be the same afer changing
> allocation of MSI-X across features.
> 
> Isn't the MSI-X capabilities read from HW register?

Yes, it comes from Message Control register.

> 
> > > Should we always allow max MSI-X for PFs? So hw_max - used -
> > > sfs? Is it save to call pci_enable_msix always with max vectors
> > > supported by device?
> > 
> > I'm not sure. I think that it won't give you much if you enable
> > more than num_online_cpu().
> > 
> 
> Oh, yes, correct, I missed that.
> 
> > > 
> > > I added the value for PFs, because we faced a problem with MSI-X
> > > allocation on 8 port device. Our default value (num_cpus) was too big
> > > (not enough vectors in hw). Changing the amount of vectors that can be
> > > used on PFs was solving the issue.
> > 
> > We had something similar for mlx5 SFs, where we don't have enough vectors.
> > Our solution is simply to move to automatic shared MSI-X mode. I would
> > advocate for that for you as well. 
> >
> 
> Thanks for proposing solution, I will take a look how this work in mlx5.

BTW, PCI spec talks about something like that in short paragraph
"Handling MSI-X Vector Shortages".

<...>

> > > 
> > > Assuming that I gave 64 MSI-X for RDMA by setting num_comp_vectors to
> > > 64, how I will know if I can or can't use these vectors in ethernet?
> > 
> > Why should you need to know? Vectors are not exclusive and they can be
> > used by many applications at the same time. The thing is that it is far
> > fetch to except that high performance RDMA applications and high
> > performance ethernet can coexist on same device at the same time.
> >
> 
> Yes, but after loading aux device part of vectors (num_comp_vectors) are
> reserved for only RDMA use case (at least in ice driver). We though that
> devlink resource interface can be a good way to change the
> num_comp_vectors in this case.

It can be, but is much better to save from users devlink magic. :)

Thanks
