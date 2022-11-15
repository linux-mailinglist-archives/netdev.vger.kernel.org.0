Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E112629301
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKOIL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiKOILZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:11:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5261CB25
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:11:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75AC1CE1375
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F70C433C1;
        Tue, 15 Nov 2022 08:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668499879;
        bh=YU9O8BXzL5RZdjnkaA1Jic3PC7zvof9cNShn8gDmYcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPLoMgeNlwWr3z4BmGuQ4CyiSn5/iKfrTLg11E4+FYQC4WlUq7aYSJOGq0ZAx5r/L
         KKRGV3cGmDLVZsW2H+HWTats3YoXtWX3M9/uqoMxqYNRzyGVC1SyvgEklt+XCAFcYX
         I0f0UduvmgDmLkpsq/ijyjIcP00mo5Eq4MkRuElPTtnhwCCjKp/dlRAzPL5xLKswK8
         EwSnYr5PD+chq3m7BJ8a3vT6IfkgFd4vdOBfdsyTUL3QF4ph9U5FTLMHyXosBG9Z0b
         tTQXWS5+3U1W9exj7enmTqPm1iAK2rCVrkmjy0Uui7E3ipOpHr7fSLqKlPRmoyTWUh
         MyT6iRkATKjig==
Date:   Tue, 15 Nov 2022 10:11:10 +0200
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
Message-ID: <Y3NJnhxetoSIvqYV@unreal>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <Y3JBaQ7+p5ncsjuW@unreal>
 <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
 <Y3J16ueuhwYeDaww@unreal>
 <Y3M79CuAQNLkFV0S@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3M79CuAQNLkFV0S@localhost.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 08:12:52AM +0100, Michal Swiatkowski wrote:
> On Mon, Nov 14, 2022 at 07:07:54PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 14, 2022 at 09:31:11AM -0600, Samudrala, Sridhar wrote:
> > > On 11/14/2022 7:23 AM, Leon Romanovsky wrote:
> > > > On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> > > > > Currently the default value for number of PF vectors is number of CPUs.
> > > > > Because of that there are cases when all vectors are used for PF
> > > > > and user can't create more VFs. It is hard to set default number of
> > > > > CPUs right for all different use cases. Instead allow user to choose
> > > > > how many vectors should be used for various features. After implementing
> > > > > subdevices this mechanism will be also used to set number of vectors
> > > > > for subfunctions.
> > > > > 
> > > > > The idea is to set vectors for eth or VFs using devlink resource API.
> > > > > New value of vectors will be used after devlink reinit. Example
> > > > > commands:
> > > > > $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > > > > $ sudo devlink dev reload pci/0000:31:00.0
> > > > > After reload driver will work with 16 vectors used for eth instead of
> > > > > num_cpus.
> > > > By saying "vectors", are you referring to MSI-X vectors?
> > > > If yes, you have specific interface for that.
> > > > https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/
> > > 
> > > This patch series is exposing a resources API to split the device level MSI-X vectors
> > > across the different functions supported by the device (PF, RDMA, SR-IOV VFs and
> > > in future subfunctions). Today this is all hidden in a policy implemented within
> > > the PF driver.
> > 
> > Maybe we are talking about different VFs, but if you refer to PCI VFs,
> > the amount of MSI-X comes from PCI config space for that specific VF.
> > 
> > You shouldn't set any value through netdev as it will cause to
> > difference in output between lspci (which doesn't require any driver)
> > and your newly set number.
> 
> If I understand correctly, lspci shows the MSI-X number for individual
> VF. Value set via devlink is the total number of MSI-X that can be used
> when creating VFs. 

Yes and no, lspci shows how much MSI-X vectors exist from HW point of
view. Driver can use less than that. It is exactly as your proposed
devlink interface.


> As Jake said I will fix the code to track both values. Thanks for pointing the patch.
> 
> > 
> > Also in RDMA case, it is not clear what will you achieve by this
> > setting too.
> >
> 
> We have limited number of MSI-X (1024) in the device. Because of that
> the amount of MSI-X for each feature is set to the best values. Half for
> ethernet, half for RDMA. This patchset allow user to change this values.
> If he wants more MSI-X for ethernet, he can decrease MSI-X for RDMA.

RDMA devices doesn't have PCI logic and everything is controlled through
you main core module. It means that when you create RDMA auxiliary device,
it will be connected to netdev (RoCE and iWARP) and that netdev should
deal with vectors. So I still don't understand what does it mean "half
for RDMA".

Thanks
