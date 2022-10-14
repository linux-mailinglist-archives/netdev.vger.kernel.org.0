Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4632A5FE667
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 02:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJNAxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 20:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNAxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 20:53:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73F018C41C;
        Thu, 13 Oct 2022 17:53:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C93EB821AF;
        Fri, 14 Oct 2022 00:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F12DC433B5;
        Fri, 14 Oct 2022 00:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665708822;
        bh=hMXZhpwn2uXGvkJr9jE4p5uwZkiaKvbjHzW6FAmAFfA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fkOh/PRteI2yXoY3VrlN/Crine1xFv1ldzIx/Om9oNOgtpeYGD4D7LBaEx3Zg7/lK
         xTlxHNgDlgFUjrsTWz5yWfSsUJXtbwWqFuylMDzsU3e29Sr2YJKqoWj+5nOEh6hTSr
         Oh0Gnm0Cw+J2YJMLGQM1w5QPYeCwO31ywC2rnv9MBIlFeF5g86g0gI5wn8W8T2lngc
         ENPFMyG5CWj2Sb5liY433Z58X48YZJuxRM0GoN02Re5oEHagHq+EMe3X8tQRUhH+kp
         U/0q96YaQ8jI0iHBLlfapNe8xNctl6O3fJb4XFYDdP3yB/eWTHDCUnBjTLltUddqSs
         BJkvrn4Vq7CNA==
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-131dda37dddso4336566fac.0;
        Thu, 13 Oct 2022 17:53:42 -0700 (PDT)
X-Gm-Message-State: ACrzQf3LtUJyTjxD7lW1TeJHenk+pLEhixmGImzPsEFplMVCYuPCXLj9
        N+O7L4ajB/IPl32IouwNSDsRlIBgvTerVI9v7Eo=
X-Google-Smtp-Source: AMsMyM7ZKlQkcNbs9/Ob4NRzq5VRbqmETYm1tA3qgdxfAwpwNzCnqHQog7k1KPgO81SUe5qtsk6GBw3+DFFZ+hdVG3s=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr7168038oah.112.1665708821406; Thu, 13
 Oct 2022 17:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221013171434.3132854-1-guoren@kernel.org> <CAAH8bW8x15GCLkD-4=3ydLBEfbER2HeNj7ishOoPVLfsQ=C7Mw@mail.gmail.com>
In-Reply-To: <CAAH8bW8x15GCLkD-4=3ydLBEfbER2HeNj7ishOoPVLfsQ=C7Mw@mail.gmail.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 08:53:29 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSTkB_JCLVhu6_nNykxh5p5a7YG82+MXx7OLDwn0K4Q3w@mail.gmail.com>
Message-ID: <CAJF2gTSTkB_JCLVhu6_nNykxh5p5a7YG82+MXx7OLDwn0K4Q3w@mail.gmail.com>
Subject: Re: [PATCH] net: Fixup virtnet_set_affinity() cause cpumask warning
To:     Yury Norov <yury.norov@gmail.com>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 2:13 AM Yury Norov <yury.norov@gmail.com> wrote:
>
> On Thu, Oct 13, 2022 at 10:14 AM <guoren@kernel.org> wrote:
> >
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > Don't pass nr_bits-1 as arg1 for cpumask_next_wrap, which would
> > cause warning now.
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> > Modules linked in:
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-11659-ge7e38f6cce55-dirty #328
> > Hardware name: riscv-virtio,qemu (DT)
> > epc : cpumask_next_wrap+0x5c/0x80
> >  ra : virtnet_set_affinity+0x1ba/0x1fc
> > epc : ffffffff808992ca ra : ffffffff805d84ca sp : ff60000002327a50
> >  gp : ffffffff81602390 tp : ff600000023a0000 t0 : 5f74656e74726976
> >  t1 : 0000000000000000 t2 : 735f74656e747269 s0 : ff60000002327a90
> >  s1 : 0000000000000003 a0 : 0000000000000003 a1 : ffffffff816051c0
> >  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000000
> >  a5 : 0000000000000004 a6 : 0000000000000000 a7 : 0000000000000000
> >  s2 : 0000000000000000 s3 : ffffffff816051c0 s4 : ffffffff8160224c
> >  s5 : 0000000000000004 s6 : 0000000000000004 s7 : 0000000000000000
> >  s8 : 0000000000000003 s9 : ffffffff810aa398 s10: ffffffff80e97d20
> >  s11: 0000000000000004 t3 : ffffffff819acc97 t4 : ffffffff819acc97
> >  t5 : ffffffff819acc98 t6 : ff60000002327878
> > status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> > [<ffffffff805d84ca>] virtnet_set_affinity+0x1ba/0x1fc
> > [<ffffffff805da7ac>] virtnet_probe+0x832/0xf1e
> > [<ffffffff804fe61c>] virtio_dev_probe+0x164/0x2de
> > [<ffffffff8054c4c4>] really_probe+0x82/0x224
> > [<ffffffff8054c6c0>] __driver_probe_device+0x5a/0xaa
> > [<ffffffff8054c73c>] driver_probe_device+0x2c/0xb8
> > [<ffffffff8054cd66>] __driver_attach+0x76/0x108
> > [<ffffffff8054a482>] bus_for_each_dev+0x52/0x9a
> > [<ffffffff8054be8c>] driver_attach+0x1a/0x28
> > [<ffffffff8054b996>] bus_add_driver+0x154/0x1c2
> > [<ffffffff8054d592>] driver_register+0x52/0x108
> > [<ffffffff804fe120>] register_virtio_driver+0x1c/0x2c
> > [<ffffffff80a29142>] virtio_net_driver_init+0x7a/0xb0
> > [<ffffffff80002854>] do_one_initcall+0x66/0x2e4
> > [<ffffffff80a01222>] kernel_init_freeable+0x28a/0x304
> > [<ffffffff808cb1be>] kernel_init+0x1e/0x110
> > [<ffffffff80003c4e>] ret_from_exception+0x0/0x10
> > ---[ end trace 0000000000000000 ]---
> >
> > Fixes: 78e5a3399421 ("cpumask: fix checking valid cpu range")
>
> Please stop saying you're fixing my patch. It reveals the problem, not
> creates it.
Okay, I would change it to:
Fixes: 2ca653d607ce ("virtio_net: Stripe queue affinities across cores.")

But I still need to mention your patch, because it causes the problem
from the git bisect view. But I agree that "yours reveals the problem,
not creates it."

>
> I have a deep rework for cpumask_next_wrap(). Will send v2 soon and CC you.
>
> Thanks,
> Yury
>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Guo Ren <guoren@kernel.org>
> > ---
> >  drivers/net/virtio_net.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7106932c6f88..e4b56523b2b5 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2300,6 +2300,8 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
> >
> >                 for (j = 0; j < group_size; j++) {
> >                         cpumask_set_cpu(cpu, mask);
> > +                       if (cpu == (nr_cpu_ids - 1))
> > +                               break;
> >                         cpu = cpumask_next_wrap(cpu, cpu_online_mask,
> >                                                 nr_cpu_ids, false);
> >                 }
> > --
> > 2.36.1
> >



-- 
Best Regards
 Guo Ren
