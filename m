Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7C62BF4A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiKPNWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiKPNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:22:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD4240917;
        Wed, 16 Nov 2022 05:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099DE61DD3;
        Wed, 16 Nov 2022 13:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D66C433D6;
        Wed, 16 Nov 2022 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668604930;
        bh=I4Vwe0lpAnBI7PZgQVeRvPX2Vqv4G/RdbfioTYLU9k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eWXWtUwOrmGAXpvkGh1H54AphDsLoaT8fHR7GPa0YQOx5qK94rD6e4DdezcfyXqel
         JXgPnqY2zZWRgP0bQ57AGluiS1tl36gApeQGw720YqBcXVkJnvBh4+nO1PKPPQU0qo
         Tnyro4Byh4Ls5e6McmxduNq6hkf9D5DaSe8PHstIWU8bhOlsZohSYWYXLonvkFp09r
         BjDJNGGHPHalr3LaQhFligsyFx1T4Djj0nQG25BQ2L8MMpwxwlpfPMhB6S1lxhCiDV
         RfjZxmASXwtwTQ4+3RwkXZpO+b3TOkcJVtiFmk74DKrPRsMxch9LNGqI1rd6JB85/X
         lBhJIlOkslF/g==
Date:   Wed, 16 Nov 2022 15:22:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v4 0/6] Add Auxiliary driver support
Message-ID: <Y3Tj/BrskSJPuTFw@unreal>
References: <20221109184244.7032-1-ajit.khaparde@broadcom.com>
 <Y2zYPOUKgoArq7mM@unreal>
 <CACZ4nhu_2FoOTmXPuq+amRYAipusq1XcobavytN0cFK=TSE5mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ4nhu_2FoOTmXPuq+amRYAipusq1XcobavytN0cFK=TSE5mQ@mail.gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:47:31PM -0800, Ajit Khaparde wrote:
> Leon,
> We appreciate your valuable feedback.
> Please see inline.
> 
> On Thu, Nov 10, 2022 at 2:53 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Nov 09, 2022 at 10:42:38AM -0800, Ajit Khaparde wrote:
> > > Add auxiliary device driver for Broadcom devices.
> > > The bnxt_en driver will register and initialize an aux device
> > > if RDMA is enabled in the underlying device.
> > > The bnxt_re driver will then probe and initialize the
> > > RoCE interfaces with the infiniband stack.
> > >
> > > We got rid of the bnxt_en_ops which the bnxt_re driver used to
> > > communicate with bnxt_en.
> > > Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> > > In most of the cases we used the functions and entry points provided
> > > by the auxiliary bus driver framework.
> > > And now these are the minimal functions needed to support the functionality.
> > >
> > > We will try to work on getting rid of the remaining if we find any
> > > other viable option in future.
> >
> > I still see extra checks for something that was already checked in upper
> > functions, for example in bnxt_re_register_netdev() you check rdev, which
> > you already checked before.
> Sure. I will do another sweep and clean up.
> 
> >
> > However, the most important part is still existence of bnxt_ulp_ops,
> > which shows completely no-go thing - SR-IOV config in RDMA code.
> >
> >    302 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
> >    303         .ulp_sriov_config = bnxt_re_sriov_config,
> >    304         .ulp_irq_stop = bnxt_re_stop_irq,
> >    305         .ulp_irq_restart = bnxt_re_start_irq
> >    306 };
> >
> > All PCI management logic and interfaces are needed to be inside eth part
> > of your driver and only that part should implement SR-IOV config. Once
> > user enabled SR-IOV, the PCI driver should create auxiliary devices for
> > each VF. These device will have RDMA capabilities and it will trigger RDMA
> > driver to bind to them.
> I agree and once the PF creates the auxiliary devices for the VF, the RoCE
> Vf indeed get probed and created. But the twist in bnxt_en/bnxt_re
> design is that
> the RoCE driver is responsible for making adjustments to the RoCE resources.

You can still do these adjustments by checking type of function that
called to RDMA .probe. PCI core exposes some functions to help distinguish between
PF and VFs.

> 
> So once the VF's are created and the bnxt_en driver enables SRIOV adjusts the
> NIC resources for the VF,  and such, it tries to call into the bnxt_re
> driver for the
> same purpose.

If I read code correctly, all these resources are for one PCI function.

Something like this:

bnxt_re_probe()
{
  ...
	if (is_virtfn(p))
		 bnxt_re_sriov_config(p);
  ...
}



> 
> 1. We do something like this to the auxiliary_device structure:
> 
> diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
> index de21d9d24a95..4e581fbf458f 100644
> --- a/include/linux/auxiliary_bus.h
> +++ b/include/linux/auxiliary_bus.h
> @@ -148,6 +148,7 @@ struct auxiliary_device {
>   * @shutdown: Called at shut-down time to quiesce the device.
>   * @suspend: Called to put the device to sleep mode. Usually to a power state.
>   * @resume: Called to bring a device from sleep mode.
> + * @sriov_configure: Called to allow configuration of VFs .
>   * @name: Driver name.
>   * @driver: Core driver structure.
>   * @id_table: Table of devices this driver should match on the bus.
> @@ -183,6 +184,7 @@ struct auxiliary_driver {
>         void (*shutdown)(struct auxiliary_device *auxdev);
>         int (*suspend)(struct auxiliary_device *auxdev, pm_message_t state);
>         int (*resume)(struct auxiliary_device *auxdev);
> +       int (*sriov_configure)(struct auxiliary_device *auxdev, int
> num_vfs); /* On PF */
>         const char *name;
>         struct device_driver driver;
>         const struct auxiliary_device_id *id_table;
> 
> Then the bnxt_en driver could call into bnxt_re via that interface.
> 

@sriov_configure callback is PCI specific and doesn't belong to aux
devices.

> Please let me know what you feel.
> 
> 2. While it may take care of the first function in the ulp_ops, it
> leaves us with two.
> And that is where I will need some input if we need to absolutely get
> rid of the ops.
> 
> 2a. We may be able to use the auxiliary_device suspend & resume with a
> private flag
> in the driver's aux_dev pointer.
> 2b. Or just like (1) above, add another hook to auxiliary_driver
> void (*restart)(struct auxiliary_device *auxdev);
> And then use the auxiliary_driver shutdown & restart with a private flag.
> 
> Note that we may get creative right now and get rid of the ulp_ops.
> But the bnxt_en driver having a need to update the bnxt_re driver is a
> part of the
> design. So it will help if we can consider beyond the ulp_irq_stop,
> ulp_irq_restart.
> 2c. Maybe keep the bnxt_ulp_ops for that reason?

It is nicer to get rid from bnxt_ulp_ops completely, but it is not must.
To get rid from sriov_configure is the most important comment here.

Thanks

> 
> Thank you for your time.
> 
> Thanks
> Ajit
> 
> >
> > Thanks


