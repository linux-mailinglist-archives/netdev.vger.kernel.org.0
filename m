Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775B8573930
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiGMOu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiGMOu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:50:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F4B2A95D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:50:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j29-20020a05600c1c1d00b003a2fdafdefbso797726wms.2
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kW1hN8oeFURFbw423Tpy3tN2RurXYC9iMT41cmyEfos=;
        b=lZbzmp5yJ8cZtVxdvN/Zw7O5NMJeB1p9DfpTYObB7m/m4PZUnrTvwE0YlcPCCISFVl
         3Lnl6tIgn5jUc/WgbszdgT6TbMT7MFz/HTqIFDmAY0PrlsomEGG2IXeRstmr3nrkTeJR
         Eiwz3DEg8YGdNHPHny+tlJhJSOxyicPd7G6+VBSdAQ+sknd7EbZOzLYNSfjjykzFomrA
         iVw4fRYhHWySeKcl28FliVB1WLeCaEuv3lmJzUg2If4jsfUKvSfYQ2/px3pgoRog1/iy
         2IPVOeMBV9x1Ey3X9S28/tnAh8WO8T3MbWZ936tsllpgbGlii9f8r+pSP6Eq6cj0mCJb
         WBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=kW1hN8oeFURFbw423Tpy3tN2RurXYC9iMT41cmyEfos=;
        b=ccdWXHFyVF3QIjC04WWb+poBD1V9ANu9mFZY+y7Ztlc/Num0DAgrAsL1w93H2eLbIU
         +oGp3rzCqFHYrTgBym0VHoQgpjuTH4ton8uME7AjSl8bLzzMrmN1f74m4FcOtRTWPKBb
         U+FwX4swAsITzAab5y2Q2AsvvjvRzgluW1EKSbL2e5/A8ymNX4BajSsiXMAwchfkhSj8
         MR1Lb6t0VwPqQFk1MudhgacMnB9Jhja4k/1VLnGIkUW/fWM552CyU3PFpYAWuucO4Kbu
         LZ6qmBlVadAce+Ob4hsExh/h78/1fhGHofo1RBaCk2C0G00ced9unKQn+9pTIFEB+4I7
         2MQg==
X-Gm-Message-State: AJIora9jt1DnOu2SeKoVf/FlWRO0DzCnZhSRyu0Bq+MFGkEHhImYgZbN
        fpev9BtkgPqxZyRLBfWc5JA=
X-Google-Smtp-Source: AGRyM1ta2KkPRj49IS34nP+YYPlycNvduVO3dqBQUmu7+LtT8wZiqTNq77X26ng08Gs6I1zOuCH4UQ==
X-Received: by 2002:a05:600c:3c9:b0:3a2:e9e2:a5ea with SMTP id z9-20020a05600c03c900b003a2e9e2a5eamr4008030wmd.35.1657723824118;
        Wed, 13 Jul 2022 07:50:24 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id x17-20020a05600c421100b003a2e86ef806sm2326882wmh.11.2022.07.13.07.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:50:23 -0700 (PDT)
Date:   Wed, 13 Jul 2022 15:50:21 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Yanghang Liu <yanghliu@redhat.com>
Subject: Re: [PATCH v2 net] sfc: fix use after free when disabling sriov
Message-ID: <Ys7brS6tIt2+mB9m@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, Yanghang Liu <yanghliu@redhat.com>
References: <20220712062642.6915-1-ihuguet@redhat.com>
 <Ys0pNQWAJneX1gQ8@gmail.com>
 <CACT4oud_43SGMoZtRZxyAWfaFbVAPdJcLRMLcU84Q90d=8XOxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oud_43SGMoZtRZxyAWfaFbVAPdJcLRMLcU84Q90d=8XOxA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 10:55:59AM +0200, Íñigo Huguet wrote:
> Hi Martin,
> 
> On Tue, Jul 12, 2022 at 9:56 AM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 08:26:42AM +0200, Íñigo Huguet wrote:
> > > Use after free is detected by kfence when disabling sriov. What was read
> > > after being freed was vf->pci_dev: it was freed from pci_disable_sriov
> > > and later read in efx_ef10_sriov_free_vf_vports, called from
> > > efx_ef10_sriov_free_vf_vswitching.
> > >
> > > Set the pointer to NULL at release time to not trying to read it later.
> >
> > This solution just bypasses the check we have in
> > efx_ef10_sriov_free_vf_vports():
> >                 /* If VF is assigned, do not free the vport  */
> >                 if (vf->pci_dev && pci_is_dev_assigned(vf->pci_dev))
> >                         continue;
> >
> > If we don't want to detect this any more we should remove this
> > check in stead of this patch.
> 
> It doesn't really bypass it, because sriov is disabled and vf->pci_dev
> set to NULL only if there are no devices assigned: the check is done
> by the `if (!vfs_assigned)` in `efx_ef10_pci_sriov_disable`. If there
> are any assigned devices, SRIOV is not disabled and vf->pci_dev is not
> set to NULL.

You are right, I should have seen the `if (!vfs_assigned)` bit.
So for the patch:

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> 
> > There is another issue here, in efx_ef10_sriov_free_vf_vswitching()
> > we do free the memory even if a VF was still assigned. This leads me
> > to think that removing the check above is the better thing to do.
> 
> Note that `pci_is_dev_assigned` and `pci_vfs_assigned` only count VFs
> assigned to Xen, but not with other methods (kvm, vfio...). That means
> that we are not really able to know when a VF is actually assigned to
> an VM.
> 
> Right now:
> * If any VF is assigned to Xen VM: driver doesn't disable SRVIO and
> doesn't free memory of assigned VFs, but it does free memory of
> unassigned VFs
> * If any VF is assigned to a non-Xen VM: driver disables SRVIO and
> free memory of all VFs
> 
> kvm/vfio case: I don't think we can or should do anything to avoid
> disabling SRIOV.
> 
> Xen case: I didn't know very well what it should be done, so I just
> assumed that the driver was doing the right thing. If it's not, there
> are 2 possibilities:
> * Option 1: Do the same thing that in the kvm/vfio case: Free memory
> anyway, as you say, but also disable SRIOV even if there are assigned
> VFs.
> * Option 2: Continue with the current driver's behaviour (but fixing
> it): don't allow to disable SRIOV if there are assigned VFs.

The current driver is doing the right thing for Xen. It already does not
disable SRIOV due to this check:
        if (!vfs_assigned)
                pci_disable_sriov(dev);

> 
> For option1, I don't know what happens if VFs assigned to Xen suddenly
> disappear. This option could have more unintended side effects than
> option 2....
> 
> For option 2, my guess is that we shouldn't free any memory at all if
> we don't disable SRIOV. So we should move the call to
> `efx_ef10_sriov_free_vf_vswitching` into the `if (!vfs_assigned)`
> block. Also, remove that "is_assigned" check inside
> `efx_ef10_sriov_free_vf_vswitching`, as you say.

If the user does 'echo 0 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs'
the driver has to free the memory, as later they could echo something > 0
in there again (and the initial nic_data->vf memory would be leaked).
So I think the call to efx_ef10_sriov_free_vf_vswitching is ok, the existing
VFs will keep on working.

Martin

> 
> What do you think? Option 1 or option 2?
> 
> >
> > Martin
> >
> > > Reproducer and dmesg log (note that kfence doesn't detect it every time):
> > > $ echo 1 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
> > > $ echo 0 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
> > >
> > >  BUG: KFENCE: use-after-free read in efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
> > >
> > >  Use-after-free read at 0x00000000ff3c1ba5 (in kfence-#224):
> > >   efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
> > >   efx_ef10_pci_sriov_disable+0x38/0x70 [sfc]
> > >   efx_pci_sriov_configure+0x24/0x40 [sfc]
> > >   sriov_numvfs_store+0xfe/0x140
> > >   kernfs_fop_write_iter+0x11c/0x1b0
> > >   new_sync_write+0x11f/0x1b0
> > >   vfs_write+0x1eb/0x280
> > >   ksys_write+0x5f/0xe0
> > >   do_syscall_64+0x5c/0x80
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > >  kfence-#224: 0x00000000edb8ef95-0x00000000671f5ce1, size=2792, cache=kmalloc-4k
> > >
> > >  allocated by task 6771 on cpu 10 at 3137.860196s:
> > >   pci_alloc_dev+0x21/0x60
> > >   pci_iov_add_virtfn+0x2a2/0x320
> > >   sriov_enable+0x212/0x3e0
> > >   efx_ef10_sriov_configure+0x67/0x80 [sfc]
> > >   efx_pci_sriov_configure+0x24/0x40 [sfc]
> > >   sriov_numvfs_store+0xba/0x140
> > >   kernfs_fop_write_iter+0x11c/0x1b0
> > >   new_sync_write+0x11f/0x1b0
> > >   vfs_write+0x1eb/0x280
> > >   ksys_write+0x5f/0xe0
> > >   do_syscall_64+0x5c/0x80
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > >  freed by task 6771 on cpu 12 at 3170.991309s:
> > >   device_release+0x34/0x90
> > >   kobject_cleanup+0x3a/0x130
> > >   pci_iov_remove_virtfn+0xd9/0x120
> > >   sriov_disable+0x30/0xe0
> > >   efx_ef10_pci_sriov_disable+0x57/0x70 [sfc]
> > >   efx_pci_sriov_configure+0x24/0x40 [sfc]
> > >   sriov_numvfs_store+0xfe/0x140
> > >   kernfs_fop_write_iter+0x11c/0x1b0
> > >   new_sync_write+0x11f/0x1b0
> > >   vfs_write+0x1eb/0x280
> > >   ksys_write+0x5f/0xe0
> > >   do_syscall_64+0x5c/0x80
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > Fixes: 3c5eb87605e85 ("sfc: create vports for VFs and assign random MAC addresses")
> > > Reported-by: Yanghang Liu <yanghliu@redhat.com>
> > > Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> > > ---
> > > v2: add missing Fixes tag
> > >
> > >  drivers/net/ethernet/sfc/ef10_sriov.c | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
> > > index 7f5aa4a8c451..92550c7e85ce 100644
> > > --- a/drivers/net/ethernet/sfc/ef10_sriov.c
> > > +++ b/drivers/net/ethernet/sfc/ef10_sriov.c
> > > @@ -408,8 +408,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
> > >  static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
> > >  {
> > >       struct pci_dev *dev = efx->pci_dev;
> > > +     struct efx_ef10_nic_data *nic_data = efx->nic_data;
> > >       unsigned int vfs_assigned = pci_vfs_assigned(dev);
> > > -     int rc = 0;
> > > +     int i, rc = 0;
> > >
> > >       if (vfs_assigned && !force) {
> > >               netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
> > > @@ -417,10 +418,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
> > >               return -EBUSY;
> > >       }
> > >
> > > -     if (!vfs_assigned)
> > > +     if (!vfs_assigned) {
> > > +             for (i = 0; i < efx->vf_count; i++)
> > > +                     nic_data->vf[i].pci_dev = NULL;
> > >               pci_disable_sriov(dev);
> > > -     else
> > > +     } else {
> > >               rc = -EBUSY;
> > > +     }
> > >
> > >       efx_ef10_sriov_free_vf_vswitching(efx);
> > >       efx->vf_count = 0;
> > > --
> > > 2.34.1
> >
> 
> 
> --
> Íñigo Huguet

-- 
