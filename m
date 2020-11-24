Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51A2C33B7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389140AbgKXWNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:13:30 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39054 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgKXWNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:13:30 -0500
Received: by mail-ot1-f65.google.com with SMTP id z24so358841oto.6;
        Tue, 24 Nov 2020 14:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4NdMQ4yWfzJCtXYI2s+4TXDn7xCnpiLuS+IirY06Dw=;
        b=JmU5Y0ma9Zj/9KSRC31GJkMk/9EyJvP3aBU8P3Lij41DkSXORlKkb/ShE9KMVCbeNo
         +XTi/qWUA+xkkUs36TE5yfiXjKrPlTOS5hnwQgSOek5N2KZRkH4xym/H4Zs7/GdAdktp
         rwPOuMN1W0TjO6cTGMH6/1vOim2Y0+lpl1lzCqQFkfewRUrYOiwhBvncGUZND4ZgDu/4
         K9wk7IWHb7xvnUx2D+Cg15wjmMnX4+QP/enSItMhMBSWoprOk3Q8Ry7IiYgVAPRPlE9e
         7eHDuUTSBopJWCxvBbZLybot2t2zgHh1tgf6FlB50lHDoDTfza3Z0YXUS92UGyu+616X
         fzVg==
X-Gm-Message-State: AOAM531XgiWae1PqcuIcg1e1mPTE7YeZwCmZRAhNq1azTPZ+jwZsS/3X
        rf5ETaxs+EnHTy3Bl1z2XCmojGcAZByFIw==
X-Google-Smtp-Source: ABdhPJymahaU5thYHy9sF6jJ6/HofLmRfypt3du4R/eRkzYlHAKd3N1/APudREayjUXF9BehHNAs7w==
X-Received: by 2002:a9d:1e82:: with SMTP id n2mr629619otn.204.1606256008378;
        Tue, 24 Nov 2020 14:13:28 -0800 (PST)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id s131sm222219oie.58.2020.11.24.14.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 14:13:28 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id 92so367535otd.5;
        Tue, 24 Nov 2020 14:13:27 -0800 (PST)
X-Received: by 2002:a05:6830:4035:: with SMTP id i21mr571145ots.221.1606256007099;
 Tue, 24 Nov 2020 14:13:27 -0800 (PST)
MIME-Version: 1.0
References: <20201124062234.678-1-liwei391@huawei.com> <CADRPPNQDW4w-4so=smxqLnkBpDzF82NPXmpZ-pyVz_aTwVzREw@mail.gmail.com>
In-Reply-To: <CADRPPNQDW4w-4so=smxqLnkBpDzF82NPXmpZ-pyVz_aTwVzREw@mail.gmail.com>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Tue, 24 Nov 2020 16:13:15 -0600
X-Gmail-Original-Message-ID: <CADRPPNTpOsp-mrzvR-=c6SqHuNfyx7y9+1p+x0ft4qu-mD_xcA@mail.gmail.com>
Message-ID: <CADRPPNTpOsp-mrzvR-=c6SqHuNfyx7y9+1p+x0ft4qu-mD_xcA@mail.gmail.com>
Subject: Re: [PATCH] net/ethernet/freescale: Fix incorrect IS_ERR_VALUE macro usages
To:     Wei Li <liwei391@huawei.com>, Zhao Qiang <qiang.zhao@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Timur Tabi <timur@freescale.com>,
        Netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, guohanjun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 3:44 PM Li Yang <leoyang.li@nxp.com> wrote:
>
> On Tue, Nov 24, 2020 at 12:24 AM Wei Li <liwei391@huawei.com> wrote:
> >
> > IS_ERR_VALUE macro should be used only with unsigned long type.
> > Especially it works incorrectly with unsigned shorter types on
> > 64bit machines.
>
> This is truly a problem for the driver to run on 64-bit architectures.
> But from an earlier discussion
> https://patchwork.kernel.org/project/linux-kbuild/patch/1464384685-347275-1-git-send-email-arnd@arndb.de/,
> the preferred solution would be removing the IS_ERR_VALUE() usage or
> make the values to be unsigned long.
>
> It looks like we are having a bigger problem with the 64-bit support
> for the driver that the offset variables can also be real pointers
> which cannot be held with 32-bit data types(when uf_info->bd_mem_part
> == MEM_PART_SYSTEM).  So actually we have to change these offsets to
> unsigned long, otherwise we are having more serious issues on 64-bit
> systems.  Are you willing to make such changes or you want us to deal
> with it?

Well, it looks like this hardware block was never integrated on a
64-bit SoC and will very likely to keep so.  So probably we can keep
the driver 32-bit only.  It is currently limited to PPC32 in Kconfig,
how did you build it for 64-bit?

>
> Regards,
> Leo
> >
> > Fixes: 4c35630ccda5 ("[POWERPC] Change rheap functions to use ulongs instead of pointers")
> > Signed-off-by: Wei Li <liwei391@huawei.com>
> > ---
> >  drivers/net/ethernet/freescale/ucc_geth.c | 30 +++++++++++------------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> > index 714b501be7d0..8656d9be256a 100644
> > --- a/drivers/net/ethernet/freescale/ucc_geth.c
> > +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> > @@ -286,7 +286,7 @@ static int fill_init_enet_entries(struct ucc_geth_private *ugeth,
> >                 else {
> >                         init_enet_offset =
> >                             qe_muram_alloc(thread_size, thread_alignment);
> > -                       if (IS_ERR_VALUE(init_enet_offset)) {
> > +                       if (IS_ERR_VALUE((unsigned long)(int)init_enet_offset)) {
> >                                 if (netif_msg_ifup(ugeth))
> >                                         pr_err("Can not allocate DPRAM memory\n");
> >                                 qe_put_snum((u8) snum);
> > @@ -2223,7 +2223,7 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
> >                         ugeth->tx_bd_ring_offset[j] =
> >                             qe_muram_alloc(length,
> >                                            UCC_GETH_TX_BD_RING_ALIGNMENT);
> > -                       if (!IS_ERR_VALUE(ugeth->tx_bd_ring_offset[j]))
> > +                       if (!IS_ERR_VALUE((unsigned long)(int)ugeth->tx_bd_ring_offset[j]))
> >                                 ugeth->p_tx_bd_ring[j] =
> >                                     (u8 __iomem *) qe_muram_addr(ugeth->
> >                                                          tx_bd_ring_offset[j]);
> > @@ -2300,7 +2300,7 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
> >                         ugeth->rx_bd_ring_offset[j] =
> >                             qe_muram_alloc(length,
> >                                            UCC_GETH_RX_BD_RING_ALIGNMENT);
> > -                       if (!IS_ERR_VALUE(ugeth->rx_bd_ring_offset[j]))
> > +                       if (!IS_ERR_VALUE((unsigned long)(int)ugeth->rx_bd_ring_offset[j]))
> >                                 ugeth->p_rx_bd_ring[j] =
> >                                     (u8 __iomem *) qe_muram_addr(ugeth->
> >                                                          rx_bd_ring_offset[j]);
> > @@ -2510,7 +2510,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >         ugeth->tx_glbl_pram_offset =
> >             qe_muram_alloc(sizeof(struct ucc_geth_tx_global_pram),
> >                            UCC_GETH_TX_GLOBAL_PRAM_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->tx_glbl_pram_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->tx_glbl_pram_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_tx_glbl_pram\n");
> >                 return -ENOMEM;
> > @@ -2530,7 +2530,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >                            sizeof(struct ucc_geth_thread_data_tx) +
> >                            32 * (numThreadsTxNumerical == 1),
> >                            UCC_GETH_THREAD_DATA_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->thread_dat_tx_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->thread_dat_tx_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_thread_data_tx\n");
> >                 return -ENOMEM;
> > @@ -2557,7 +2557,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >             qe_muram_alloc(ug_info->numQueuesTx *
> >                            sizeof(struct ucc_geth_send_queue_qd),
> >                            UCC_GETH_SEND_QUEUE_QUEUE_DESCRIPTOR_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->send_q_mem_reg_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->send_q_mem_reg_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_send_q_mem_reg\n");
> >                 return -ENOMEM;
> > @@ -2597,7 +2597,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >                 ugeth->scheduler_offset =
> >                     qe_muram_alloc(sizeof(struct ucc_geth_scheduler),
> >                                    UCC_GETH_SCHEDULER_ALIGNMENT);
> > -               if (IS_ERR_VALUE(ugeth->scheduler_offset)) {
> > +               if (IS_ERR_VALUE((unsigned long)(int)ugeth->scheduler_offset)) {
> >                         if (netif_msg_ifup(ugeth))
> >                                 pr_err("Can not allocate DPRAM memory for p_scheduler\n");
> >                         return -ENOMEM;
> > @@ -2644,7 +2644,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >                     qe_muram_alloc(sizeof
> >                                    (struct ucc_geth_tx_firmware_statistics_pram),
> >                                    UCC_GETH_TX_STATISTICS_ALIGNMENT);
> > -               if (IS_ERR_VALUE(ugeth->tx_fw_statistics_pram_offset)) {
> > +               if (IS_ERR_VALUE((unsigned long)(int)ugeth->tx_fw_statistics_pram_offset)) {
> >                         if (netif_msg_ifup(ugeth))
> >                                 pr_err("Can not allocate DPRAM memory for p_tx_fw_statistics_pram\n");
> >                         return -ENOMEM;
> > @@ -2681,7 +2681,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >         ugeth->rx_glbl_pram_offset =
> >             qe_muram_alloc(sizeof(struct ucc_geth_rx_global_pram),
> >                            UCC_GETH_RX_GLOBAL_PRAM_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->rx_glbl_pram_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->rx_glbl_pram_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_rx_glbl_pram\n");
> >                 return -ENOMEM;
> > @@ -2700,7 +2700,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >             qe_muram_alloc(numThreadsRxNumerical *
> >                            sizeof(struct ucc_geth_thread_data_rx),
> >                            UCC_GETH_THREAD_DATA_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->thread_dat_rx_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->thread_dat_rx_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_thread_data_rx\n");
> >                 return -ENOMEM;
> > @@ -2721,7 +2721,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >                     qe_muram_alloc(sizeof
> >                                    (struct ucc_geth_rx_firmware_statistics_pram),
> >                                    UCC_GETH_RX_STATISTICS_ALIGNMENT);
> > -               if (IS_ERR_VALUE(ugeth->rx_fw_statistics_pram_offset)) {
> > +               if (IS_ERR_VALUE((unsigned long)(int)ugeth->rx_fw_statistics_pram_offset)) {
> >                         if (netif_msg_ifup(ugeth))
> >                                 pr_err("Can not allocate DPRAM memory for p_rx_fw_statistics_pram\n");
> >                         return -ENOMEM;
> > @@ -2741,7 +2741,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >             qe_muram_alloc(ug_info->numQueuesRx *
> >                            sizeof(struct ucc_geth_rx_interrupt_coalescing_entry)
> >                            + 4, UCC_GETH_RX_INTERRUPT_COALESCING_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->rx_irq_coalescing_tbl_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->rx_irq_coalescing_tbl_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_rx_irq_coalescing_tbl\n");
> >                 return -ENOMEM;
> > @@ -2807,7 +2807,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >                            (sizeof(struct ucc_geth_rx_bd_queues_entry) +
> >                             sizeof(struct ucc_geth_rx_prefetched_bds)),
> >                            UCC_GETH_RX_BD_QUEUES_ALIGNMENT);
> > -       if (IS_ERR_VALUE(ugeth->rx_bd_qs_tbl_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)ugeth->rx_bd_qs_tbl_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_rx_bd_qs_tbl\n");
> >                 return -ENOMEM;
> > @@ -2892,7 +2892,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >                 ugeth->exf_glbl_param_offset =
> >                     qe_muram_alloc(sizeof(struct ucc_geth_exf_global_pram),
> >                 UCC_GETH_RX_EXTENDED_FILTERING_GLOBAL_PARAMETERS_ALIGNMENT);
> > -               if (IS_ERR_VALUE(ugeth->exf_glbl_param_offset)) {
> > +               if (IS_ERR_VALUE((unsigned long)(int)ugeth->exf_glbl_param_offset)) {
> >                         if (netif_msg_ifup(ugeth))
> >                                 pr_err("Can not allocate DPRAM memory for p_exf_glbl_param\n");
> >                         return -ENOMEM;
> > @@ -3026,7 +3026,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
> >
> >         /* Allocate InitEnet command parameter structure */
> >         init_enet_pram_offset = qe_muram_alloc(sizeof(struct ucc_geth_init_pram), 4);
> > -       if (IS_ERR_VALUE(init_enet_pram_offset)) {
> > +       if (IS_ERR_VALUE((unsigned long)(int)init_enet_pram_offset)) {
> >                 if (netif_msg_ifup(ugeth))
> >                         pr_err("Can not allocate DPRAM memory for p_init_enet_pram\n");
> >                 return -ENOMEM;
> > --
> > 2.17.1
> >
