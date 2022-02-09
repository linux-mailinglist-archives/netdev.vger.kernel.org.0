Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13464AF0D0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiBIMHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiBIMGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:06:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457CCE016CD8;
        Wed,  9 Feb 2022 03:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644405212; x=1675941212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLhMlvEV+rn3VwrObHpuk3rd0PNcKIyWcU6fqh61PL0=;
  b=sUIpL9FOAznQkfCu0DlA5cPaCCp9qzzxX8nzd7V1MiIgb1ilNMSTuK9u
   +zILMC1fBg4y/0JFXR4ShxsZpLLBuEhV5no/MiU5NV4gDrU3wbQfzb59k
   T2MlsCpq0iY+2SWB4xbibarGRqmyaLSN7ef/cDix06Rw9h/Sq5LHcW+3t
   5JO5V84SwikU8J8cC83keoYiA73iZQd95YCyusk/pGNtJ9ypprGwS6F6T
   tr1jKgd2DYTtudTmKGwZuZfe2akFqm1BmKkONWf/3Ptb+i3yE9KX9kFAW
   SR1iN8hoIQucSdAPnZD/oRfMvOdTrQfENAPiLDjUJzX7JYGBc9uAYzLzl
   w==;
IronPort-SDR: zRl5OBvAiM2qFDpZMrVz0fW3VW1goqRqcuNeSeAhfZACzHgjQ+wtgByg1x2AwtdZ4SFpUQnpaN
 StgWhqmeXjNMRy75MFws7T+4VM6wPt7h8P6q1wJfuIlfKj6q0U+dMdZIamZcBgxR+QinSTdAYY
 yOuKsGd06fZtQov+Cl0dL5IAdkrzYbM+FUjftmQi2OPZQzXbKMwAwjKErZNKyVwpNl0G3S5/wV
 VUVbfFAIZAK6RiBmUcRtBdB0D3wF+aBIdyqh97rhBpxrTEKxtgN0IZ1LnBv5OpBQM9gtUmb4V2
 BU/01FxaDjRWfSsfZ24sh7MR
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="152974486"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2022 04:13:31 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Feb 2022 04:13:30 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Feb 2022 04:13:27 -0700
From:   <conor.dooley@microchip.com>
To:     <harini.katakam@xilinx.com>, <andrei.pistirica@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <nicolas.ferre@microchip.com>
CC:     <harinikatakamlinux@gmail.com>, <Conor.Dooley@microchip.com>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>,
        <mstamand@ciena.com>, <netdev@vger.kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH] net: macb: Align the dma and coherent dma masks
Date:   Wed, 9 Feb 2022 11:15:56 +0000
Message-ID: <20220209111555.4022923-1-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209094325.8525-1-harini.katakam@xilinx.com>
References: <20220209094325.8525-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Marc St-Amand <mstamand@ciena.com>
> 
> Single page and coherent memory blocks can use different DMA masks
> when the macb accesses physical memory directly. The kernel is clever
> enough to allocate pages that fit into the requested address width.
> 
> When using the ARM SMMU, the DMA mask must be the same for single
> pages and big coherent memory blocks. Otherwise the translation
> tables turn into one big mess.
> 
>   [   74.959909] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
>   [   74.959989] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
>   [   75.173939] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
>   [   75.173955] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
> 
> Since using the same DMA mask does not hurt direct 1:1 physical
> memory mappings, this commit always aligns DMA and coherent masks.
> 
> Signed-off-by: Marc St-Amand <mstamand@ciena.com>
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Fixes a DMA allocation failure for me on a non arm board, seen if
I only assigned DDR to 64 bit addresses. Without the change I was
getting the following page allocation error:

Starting network:
[    2.911830] ip: page allocation failure: order:2, mode:0xcc4(GFP_KERNEL|GFP_DMA32),nodemask=(null)
[    2.921256] CPU: 3 PID: 171 Comm: ip Not tainted 5.17.0-rc1-00640-g6cc001edd9ad #1
[    2.928915] Hardware name: Microchip PolarFire-SoC Icicle Kit (DT)
[    2.935147] Call Trace:
[    2.937626] [<ffffffff800047e0>] dump_backtrace+0x1c/0x24
[    2.943087] [<ffffffff807fcfce>] dump_stack_lvl+0x40/0x58
[    2.948547] [<ffffffff807fcffa>] dump_stack+0x14/0x1c
[    2.953649] [<ffffffff80104bfc>] warn_alloc+0xd6/0x14c
[    2.958849] [<ffffffff801053e0>] __alloc_pages_slowpath.constprop.0+0x76e/0x882
[    2.966242] [<ffffffff80105618>] __alloc_pages+0x124/0x174
[    2.971783] [<ffffffff80061440>] __dma_direct_alloc_pages+0x12c/0x28c
[    2.978286] [<ffffffff800616f2>] dma_direct_alloc+0x40/0x13e
[    2.983996] [<ffffffff80060bf2>] dma_alloc_attrs+0x78/0x86
[    2.989541] [<ffffffff805cdfb6>] macb_open+0x84/0x42c
[    2.994645] [<ffffffff806e2468>] __dev_open+0xb0/0x142
[    2.999845] [<ffffffff806e2884>] __dev_change_flags+0x180/0x1ec
[    3.005827] [<ffffffff806e290e>] dev_change_flags+0x1e/0x54
[    3.011461] [<ffffffff8076960e>] devinet_ioctl+0x1fc/0x612
[    3.017015] [<ffffffff8076b27e>] inet_ioctl+0x96/0xfa
[    3.022109] [<ffffffff806bf5e2>] sock_ioctl+0x256/0x29e
[    3.027396] [<ffffffff8012bc7c>] sys_ioctl+0x340/0x7f8
[    3.032595] [<ffffffff80003014>] ret_from_syscall+0x0/0x2
<snip>
[    3.176712] macb 20110000.ethernet eth0: Unable to allocate DMA memory (error -12)
ip: SIOCSIFFLAGS: Cannot allocate memory
FAIL
