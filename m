Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0365FE115
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJMSYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJMSYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:24:03 -0400
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A808103A;
        Thu, 13 Oct 2022 11:19:41 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id x20so1045242ual.6;
        Thu, 13 Oct 2022 11:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u8QO6eh7IeE9REMkSPhowZYbykHDujcxIxr7xuFguJk=;
        b=hgN8iV4PD8plUny+hqVkXcMPceJLNiWkgJYeq9APsBiwtWaaSK0I6mZW8ewGNWGNYo
         eayPm8kh7KfhKUPqFggsOQYLSjhLREkEW9bRGr5fO4Iw9u7dS6thwbDI/oWTfTJiq3tl
         NwRJlC6pLvSQK72sGFGhSdcz8QAkQchBU+L7veL7bJvEvo/yMPcCdS4XAdcMN1fuaAQO
         WZz9xiTzO0lQ0tpOy2EGl5jjc1j4A0kN0Hxl/pX9L7cRHSATSihGhrWP/rgO8J947XIN
         CnnTu8PZKXD/8edO19DAbWxHpr7vguLRLK8hcLs7HsCKGgdY+MZQz+KRxrir61F+J1U3
         9x9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8QO6eh7IeE9REMkSPhowZYbykHDujcxIxr7xuFguJk=;
        b=1uq7wmFgT0yuiluqJY/OEWHLCnCsCYz5T+4JR5zBRRGuEQoPeB3R+1i+xio9RqOz3a
         dMVb0jfDoOR45lEzDryIsbdIRbsTFC0g8ABvQ2GAelgYNl1DZ7AID1pAFpiCOceyN0+5
         FdIC10swKiNXF8iDculf5N+v8aT/TRqsHksDFSy3UnE+YFBOpzV6+ftYJRD8zSPXG+mG
         Pc43WMWO7NBb8TO11luj6uz8GroyQyi2gIIIHw0OSmJOmKQ3G7gXZ2KrkkbuZGqLSfPW
         PcGSJpZw5bRMqE7qh8XfECk/Wzr87VxB9cTNcPlBS54HxewkX2t9w2IHyEQ3/pz1mpj2
         yocA==
X-Gm-Message-State: ACrzQf2ae5lS9s2TEciMDfEMm5bkAjT8OyxRW4gyyWaUEBsWqzGjwX9/
        ij2bUrYoxJYMHziz9c3brHqKWJAzBHMDeskRyHk=
X-Google-Smtp-Source: AMsMyM7qDf9/C7sOZ6XleZNaYVN0HnB7Aox2LPoeLhCtUsR22LYPtoLsT3MVU2lJnoDS1fYbWVWy6oX8aaMI0sFQsFw=
X-Received: by 2002:a9f:35a9:0:b0:3df:a108:f5fd with SMTP id
 t38-20020a9f35a9000000b003dfa108f5fdmr668379uad.4.1665684782677; Thu, 13 Oct
 2022 11:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20221013171434.3132854-1-guoren@kernel.org>
In-Reply-To: <20221013171434.3132854-1-guoren@kernel.org>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Thu, 13 Oct 2022 11:12:52 -0700
Message-ID: <CAAH8bW8x15GCLkD-4=3ydLBEfbER2HeNj7ishOoPVLfsQ=C7Mw@mail.gmail.com>
Subject: Re: [PATCH] net: Fixup virtnet_set_affinity() cause cpumask warning
To:     guoren@kernel.org
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 10:14 AM <guoren@kernel.org> wrote:
>
> From: Guo Ren <guoren@linux.alibaba.com>
>
> Don't pass nr_bits-1 as arg1 for cpumask_next_wrap, which would
> cause warning now.
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-11659-ge7e38f6cce55-dirty #328
> Hardware name: riscv-virtio,qemu (DT)
> epc : cpumask_next_wrap+0x5c/0x80
>  ra : virtnet_set_affinity+0x1ba/0x1fc
> epc : ffffffff808992ca ra : ffffffff805d84ca sp : ff60000002327a50
>  gp : ffffffff81602390 tp : ff600000023a0000 t0 : 5f74656e74726976
>  t1 : 0000000000000000 t2 : 735f74656e747269 s0 : ff60000002327a90
>  s1 : 0000000000000003 a0 : 0000000000000003 a1 : ffffffff816051c0
>  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000000
>  a5 : 0000000000000004 a6 : 0000000000000000 a7 : 0000000000000000
>  s2 : 0000000000000000 s3 : ffffffff816051c0 s4 : ffffffff8160224c
>  s5 : 0000000000000004 s6 : 0000000000000004 s7 : 0000000000000000
>  s8 : 0000000000000003 s9 : ffffffff810aa398 s10: ffffffff80e97d20
>  s11: 0000000000000004 t3 : ffffffff819acc97 t4 : ffffffff819acc97
>  t5 : ffffffff819acc98 t6 : ff60000002327878
> status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> [<ffffffff805d84ca>] virtnet_set_affinity+0x1ba/0x1fc
> [<ffffffff805da7ac>] virtnet_probe+0x832/0xf1e
> [<ffffffff804fe61c>] virtio_dev_probe+0x164/0x2de
> [<ffffffff8054c4c4>] really_probe+0x82/0x224
> [<ffffffff8054c6c0>] __driver_probe_device+0x5a/0xaa
> [<ffffffff8054c73c>] driver_probe_device+0x2c/0xb8
> [<ffffffff8054cd66>] __driver_attach+0x76/0x108
> [<ffffffff8054a482>] bus_for_each_dev+0x52/0x9a
> [<ffffffff8054be8c>] driver_attach+0x1a/0x28
> [<ffffffff8054b996>] bus_add_driver+0x154/0x1c2
> [<ffffffff8054d592>] driver_register+0x52/0x108
> [<ffffffff804fe120>] register_virtio_driver+0x1c/0x2c
> [<ffffffff80a29142>] virtio_net_driver_init+0x7a/0xb0
> [<ffffffff80002854>] do_one_initcall+0x66/0x2e4
> [<ffffffff80a01222>] kernel_init_freeable+0x28a/0x304
> [<ffffffff808cb1be>] kernel_init+0x1e/0x110
> [<ffffffff80003c4e>] ret_from_exception+0x0/0x10
> ---[ end trace 0000000000000000 ]---
>
> Fixes: 78e5a3399421 ("cpumask: fix checking valid cpu range")

Please stop saying you're fixing my patch. It reveals the problem, not
creates it.

I have a deep rework for cpumask_next_wrap(). Will send v2 soon and CC you.

Thanks,
Yury

> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7106932c6f88..e4b56523b2b5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2300,6 +2300,8 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
>
>                 for (j = 0; j < group_size; j++) {
>                         cpumask_set_cpu(cpu, mask);
> +                       if (cpu == (nr_cpu_ids - 1))
> +                               break;
>                         cpu = cpumask_next_wrap(cpu, cpu_online_mask,
>                                                 nr_cpu_ids, false);
>                 }
> --
> 2.36.1
>
