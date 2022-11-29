Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7ED63BCAD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiK2JNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiK2JNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:13:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A311B3E085;
        Tue, 29 Nov 2022 01:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52941B811C1;
        Tue, 29 Nov 2022 09:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374BBC433D6;
        Tue, 29 Nov 2022 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669713229;
        bh=WJed+LUowQTwdT/KFPk89HrhM75i746wZq+c/Fp++tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=teEUDniYsLHbpZmSDgunGybkK/xtYa4EWUN9z4alStPR1Kkvz88lQ8AvXcQT3FqZT
         rhUOdYSUF6mL8tZ3fCtYFGygGdEFLTcVrPFA5DKA6kdfSwPSzdLcD0LfCrEHQGmI0g
         EA884jVmCTye504ZMlBsWGImdt+Yiqr1Snwdxx3CPSLkMzfKKegdZv3OrDslDxfwSC
         ZCkFN8bRbxVs/ZZFtEKL6pNMQpt/O7gToiHKzXRwso0Hzo0VKmpnFPGL/2caakSTnm
         hY87df//dh9sHcl8imXq6N0E7BHenrDjkB408ZPJPXCkdUyIVhU2Amgj0zJQp9F5GY
         nVLwNbz2DQ82w==
Date:   Tue, 29 Nov 2022 11:13:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v4 0/6] Add Auxiliary driver support
Message-ID: <Y4XNSBO+2/YOL9+C@unreal>
References: <20221109184244.7032-1-ajit.khaparde@broadcom.com>
 <Y2zYPOUKgoArq7mM@unreal>
 <CACZ4nhu_2FoOTmXPuq+amRYAipusq1XcobavytN0cFK=TSE5mQ@mail.gmail.com>
 <Y3Tj/BrskSJPuTFw@unreal>
 <CACZ4nhsv4zyzANrGh90WGKORz0Su=i7+Jmsk6nWoOq4or7Y0=Q@mail.gmail.com>
 <Y33ErZHAsX76y34Z@unreal>
 <CACZ4nhvJV32pmOU7mRfaYYnatN6Ef5T3M=nVTYjuk7mnqcUxtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ4nhvJV32pmOU7mRfaYYnatN6Ef5T3M=nVTYjuk7mnqcUxtw@mail.gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 06:01:13PM -0800, Ajit Khaparde wrote:
> On Tue, Nov 22, 2022 at 10:59 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Nov 22, 2022 at 07:02:45AM -0800, Ajit Khaparde wrote:
> > > On Wed, Nov 16, 2022 at 5:22 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > ::snip::
> > > > > > All PCI management logic and interfaces are needed to be inside eth part
> > > > > > of your driver and only that part should implement SR-IOV config. Once
> > > > > > user enabled SR-IOV, the PCI driver should create auxiliary devices for
> > > > > > each VF. These device will have RDMA capabilities and it will trigger RDMA
> > > > > > driver to bind to them.
> > > > > I agree and once the PF creates the auxiliary devices for the VF, the RoCE
> > > > > Vf indeed get probed and created. But the twist in bnxt_en/bnxt_re
> > > > > design is that
> > > > > the RoCE driver is responsible for making adjustments to the RoCE resources.
> > > >
> > > > You can still do these adjustments by checking type of function that
> > > > called to RDMA .probe. PCI core exposes some functions to help distinguish between
> > > > PF and VFs.
> > > >
> > > > >
> > > > > So once the VF's are created and the bnxt_en driver enables SRIOV adjusts the
> > > > > NIC resources for the VF,  and such, it tries to call into the bnxt_re
> > > > > driver for the
> > > > > same purpose.
> > > >
> > > > If I read code correctly, all these resources are for one PCI function.
> > > >
> > > > Something like this:
> > > >
> > > > bnxt_re_probe()
> > > > {
> > > >   ...
> > > >         if (is_virtfn(p))
> > > >                  bnxt_re_sriov_config(p);
> > > >   ...
> > > > }
> > > I understand what you are suggesting.
> > > But what I want is a way to do this in the context of the PF
> > > preferably before the VFs are probed.
> >
> > I don't understand the last sentence. You call to this sriov_config in
> > bnxt_re driver without any protection from VFs being probed,
> 
> Let me elaborate -
> When a user sets num_vfs to a non-zero number, the PCI driver hook
> sriov_configure calls bnxt_sriov_configure(). Once pci_enable_sriov()
> succeeds, bnxt_ulp_sriov_cfg() is issued under bnxt_sriov_configure().
> All this happens under bnxt_en.
> bnxt_ulp_sriov_cfg() ultimately calls into the bnxt_re driver.
> Since bnxt_sriov_configure() is called only for PFs, bnxt_ulp_sriov_cfg()
> is called for PFs only.
> 
> Once bnxt_ulp_sriov_cfg() calls into the bnxt_re via the ulp_ops,
> it adjusts the QPs, SRQs, CQs, MRs, GIDs and such.

Once you called to pci_enable_sriov(), PCI core created sysfs entries
and it triggers udev rules and VFs probe. Because you are calling it
in bnxt_sriov_configure(), you will have inherit protection for PF
with PCI lock, but not for VFs.

> 
> >
> > > So we are trying to call the
> > > bnxt_re_sriov_config in the context of handling the PF's
> > > sriov_configure implementation.  Having the ulp_ops is allowing us to
> > > avoid resource wastage and assumptions in the bnxt_re driver.
> >
> > To which resource wastage are you referring?
> Essentially the PF driver reserves a set of above resources for the PF,
> and divides the remaining resources among the VFs.
> If the calculation is based on sriov_totalvfs instead of sriov_numvfs,
> there can be a difference in the resources provisioned for a VF.
> And that is because a user may create a subset of VFs instead of the
> total VFs allowed in the PCI SR-IOV capability register.
> I was referring to the resource wastage in that deployment scenario.

It is ok, set all needed limits in bnxt_en. You don't need to call to
bnxt_re for that.

> 
> Thanks
> Ajit
> 
> >
> > There are no differences if same limits will be in bnxt_en driver when
> > RDMA bnxt device is created or in bnxt_re which will be called once RDMA
> > device is created.
> >
> > Thanks
> >
> > >
> > > ::snip::
> >
> >


