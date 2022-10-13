Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE235FDEB8
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJMRNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMRNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:13:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDE3BE53F;
        Thu, 13 Oct 2022 10:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77967B81FCD;
        Thu, 13 Oct 2022 17:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331EAC43140;
        Thu, 13 Oct 2022 17:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665681184;
        bh=qtUj4HOZkI60Q9GjVY9brGrEXkMR3EQ8UgD83vxXH5w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A9CJ00bqKbjgthG0ZqvCoar3VNkmpwv4SscAW/S9JY8LUyrqncfulmYD+O7JqR0yg
         ygCwPVvC79lvUBIawSMZc1WCdzp3AhQzwJZfdhWJJF0+BbvH2GcLtej5603oab4q2a
         6dmH9Uu36g+Whb4snZL2WE3/r8qzQ53wm3TDdT+2kE0Df/8Tm61YdW7bce6soPq/i7
         +zXD8e6rxNLZlaqMCuEtuQ7J5aZiJaR+E75W2oolYbxOZMetLINW9riADie0TYOdI1
         LuhLUBEnl8GdKK+YJ+F7hcxwwumaJAjXvNROqoVwBBSKt6Tj1Tvp0B5B7Vxrnu0bAZ
         1zf4IDM+BN38Q==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-136b5dd6655so3057645fac.3;
        Thu, 13 Oct 2022 10:13:04 -0700 (PDT)
X-Gm-Message-State: ACrzQf39M1CDwGMG6eVWVjB456T0cCkD1qvb2FieR4bDfFVauf8WsGkg
        Mg6G+GVYcdogt/e/KBSXUu6NLEXeGm6JQ6coPJE=
X-Google-Smtp-Source: AMsMyM7DQbyVVn9lSwhHQzzI4CguO+SXqSphIbQfVREHxCAuibjZh6Kn8I+5xZ4lObB09Jy9FhCU5LPHq3lbCFDEMkw=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr6177186oah.112.1665681183189; Thu, 13
 Oct 2022 10:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221013163857.3086718-1-guoren@kernel.org>
In-Reply-To: <20221013163857.3086718-1-guoren@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 01:12:51 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSu_SDGEYZxW7nfY8B=k_hkdxKy2TsK7C5v7cqM7qrKRA@mail.gmail.com>
Message-ID: <CAJF2gTSu_SDGEYZxW7nfY8B=k_hkdxKy2TsK7C5v7cqM7qrKRA@mail.gmail.com>
Subject: Re: [PATCH] net: Fixup netif_attrmask_next_and warning
To:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 12:39 AM <guoren@kernel.org> wrote:
>
> From: Guo Ren <guoren@linux.alibaba.com>
>
> Don't pass nr_bits as arg1, cpu_max_bits_warn would cause warning
> now.
>
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770
> Modules linked in:
> CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc4-00018-g854701ba4c39 #324
> Hardware name: riscv-virtio,qemu (DT)
> epc : __netif_set_xps_queue+0x14e/0x770
>  ra : __netif_set_xps_queue+0x552/0x770
> epc : ffffffff806fe448 ra : ffffffff806fe84c sp : ff600000023279d0
>  gp : ffffffff815fff88 tp : ff600000023a0000 t0 : ff6000000308ab40
>  t1 : 0000000000000003 t2 : 0000000000000000 s0 : ff60000002327a90
>  s1 : 0000000000000000 a0 : ff6000000308ab00 a1 : ff6000000308ab00
>  a2 : ff6000000308a8e8 a3 : 0000000000000004 a4 : 0000000000000000
>  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
>  s2 : 0000000000000000 s3 : 0000000000000000 s4 : ff60000002327aa0
>  s5 : ffffffff816031c8 s6 : 0000000000000000 s7 : 0000000000000001
>  s8 : 0000000000000000 s9 : 0000000000000004 s10: ff6000000308a8c0
>  s11: 0000000000000004 t3 : 0000000000000000 t4 : 0000000000000014
>  t5 : 0000000000000000 t6 : 0000000000000000
> status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> [<ffffffff805e5824>] virtnet_set_affinity+0x14a/0x1c0
> [<ffffffff805e7b04>] virtnet_probe+0x7fc/0xee2
> [<ffffffff8050e120>] virtio_dev_probe+0x164/0x2de
> [<ffffffff8055b69e>] really_probe+0x82/0x224
> [<ffffffff8055b89a>] __driver_probe_device+0x5a/0xaa
> [<ffffffff8055b916>] driver_probe_device+0x2c/0xb8
> [<ffffffff8055bf34>] __driver_attach+0x76/0x108
> [<ffffffff805597c0>] bus_for_each_dev+0x4a/0x8e
> [<ffffffff8055b072>] driver_attach+0x1a/0x28
> [<ffffffff8055ab8c>] bus_add_driver+0x13c/0x1a6
> [<ffffffff8055c722>] driver_register+0x4a/0xfc
> [<ffffffff8050dc34>] register_virtio_driver+0x1c/0x2c
> [<ffffffff80a2bae4>] virtio_net_driver_init+0x7a/0xb0
> [<ffffffff80002840>] do_one_initcall+0x66/0x2e4
> [<ffffffff80a01212>] kernel_init_freeable+0x28a/0x304
> [<ffffffff808b21e2>] kernel_init+0x1e/0x110
> [<ffffffff80003c46>] ret_from_exception+0x0/0x10
> ---[ end trace 0000000000000000 ]---
>
> Fixes: 944c417daeb6 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")

Sorry, the Fixes commit is 854701ba4c39.
----
commit 854701ba4c39afae2362ba19a580c461cb183e4f
Author: Yury Norov <yury.norov@gmail.com>
Date:   Mon Sep 19 14:05:54 2022 -0700

    net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}

    The functions require to be passed with a cpu index prior to one that is
    the first to start search, so the valid input range is [-1, nr_cpu_ids-1).
    However, the code checks against [-1, nr_cpu_ids).

    Acked-by: Jakub Kicinski <kuba@kernel.org>
    Signed-off-by: Yury Norov <yury.norov@gmail.com>


> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> ---
>  net/core/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index fa53830d0683..9ec8b10ae329 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2589,8 +2589,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>                 copy = true;
>
>         /* allocate memory for queue storage */
> -       for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> -            j < nr_ids;) {
> +       for (j = -1; j < nr_ids;
> +            j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {
>                 if (!new_dev_maps) {
>                         new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
>                         if (!new_dev_maps) {
> --
> 2.36.1
>


-- 
Best Regards
 Guo Ren
