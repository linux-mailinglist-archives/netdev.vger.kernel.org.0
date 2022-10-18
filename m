Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD246020A5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiJRB4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJRB4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:56:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4276C57248;
        Mon, 17 Oct 2022 18:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D22EA6134F;
        Tue, 18 Oct 2022 01:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43951C43470;
        Tue, 18 Oct 2022 01:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666058176;
        bh=FOFyrGguuAOD/IHXQEvTGpKrPLp+v+QdALq0Zhe3cVU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RLdSFgN1hi/d3+qjFng384+/YgqBUngmj69R/qQHdJSIEv9vWG9xJqMFaDizSinXy
         Phps5SsVpVqfGTgKFY5hj0TAEVOMSCvCphlQJoopszIcCg3V10M3CQqT8tgqIeuGB1
         Za8kSwFrhXB1AqfxAQw/y1mfUHk8tE1DGM2o6hMAfX4EX7GsnW0iQ0mlC+zhIFC4yC
         wAugcTUc76sF3vxPd60LkR2A9fa5XNEHZ5O5abJW1ZJrHtXNaOowyV/VhEFsMTR5mz
         X+RuSa5HxLHdSWjeiuEH7hcDkfqlGXRDWZIQzTVj7U5TFiav/cFF8N8oC9mkbB+Ieb
         BsX9LGiArh5oQ==
Received: by mail-oi1-f176.google.com with SMTP id g130so14130622oia.13;
        Mon, 17 Oct 2022 18:56:16 -0700 (PDT)
X-Gm-Message-State: ACrzQf31QP1oh9Fh0QA/+XW58cIaot4b//aQLhp53GYt5l7A015ar/fo
        g43xk4rLwlBJBlFgJUwR1QHV6mUy111lfNrBaG4=
X-Google-Smtp-Source: AMsMyM7iCW1MDbycsw+DlbQixQNxQ7zwZfAvDGS5mz8uTUYhYpyIc3SPVD51yQqot0rQjmd/FO1S9OOK+7Fn41Vlat4=
X-Received: by 2002:a05:6808:10c3:b0:354:db1e:c4a8 with SMTP id
 s3-20020a05680810c300b00354db1ec4a8mr14273459ois.112.1666058175349; Mon, 17
 Oct 2022 18:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221015130548.3634468-1-guoren@kernel.org> <20221015165017.GA1034513@roeck-us.net>
 <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com>
 <3e3e23a4-574a-166f-78fe-9113abec4d6b@roeck-us.net> <CAJF2gTTz=Whg+heB95doVnQWVvjNC1bCx1bYLMW4CtybABBGNA@mail.gmail.com>
 <20221017125320.18b54147@kernel.org>
In-Reply-To: <20221017125320.18b54147@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 18 Oct 2022 09:56:02 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSQrH-sZqSo+0Ky=4cJOKFV8BxzR2e7W6sUnGN=0rj40Q@mail.gmail.com>
Message-ID: <CAJF2gTSQrH-sZqSo+0Ky=4cJOKFV8BxzR2e7W6sUnGN=0rj40Q@mail.gmail.com>
Subject: Re: [PATCH] Revert "cpumask: fix checking valid cpu range"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 3:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 17 Oct 2022 10:56:05 +0800 Guo Ren wrote:
> > Ping Jakub Kicinski <kuba@kernel.org>.
> >
> > You seem to miss this Revert fixup on cpumask_check(n + 1).
> >
> > Your patch has merged in v6.1-rc1, but that is not enough.
> > https://lore.kernel.org/netdev/166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org/T/#m0111a76380626b2f91e072ecdd5827578d5cbf60
> >
> > Without the patch, there still is a warning.
>
> Sorry, I don't know what you mean. I was only putting a workaround back
> into the core networking code - I'm guessing this patch will silence
> the warning that comes from virtio? I haven't looked into that one.

Without the patch, Linux-v6.1-rc1 would warn when
CONFIG_DEBUG_PER_CPU_MAPS was enabled.

[    2.130438] virtio_blk virtio0: 1/0/0 default/read/poll queues
[    2.137585] virtio_blk virtio0: [vda] 122880 512-byte logical
blocks (62.9 MB/60.0 MiB)
[    2.196181] lkdtm: No crash points registered, enable through debugfs
[    2.246658] ------------[ cut here ]------------
[    2.247468] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:110
__netif_set_xps_queue+0x14e/0x792
[    2.248738] Modules linked in:
[    2.249323] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc1 #336
[    2.250038] Hardware name: riscv-virtio,qemu (DT)
[    2.250697] epc : __netif_set_xps_queue+0x14e/0x792
[    2.251538]  ra : __netif_set_xps_queue+0x56c/0x792
[    2.252029] epc : ffffffff806f2972 ra : ffffffff806f2d90 sp :
ff600000023279d0
[    2.252664]  gp : ffffffff81603d88 tp : ff600000023a0000 t0 :
ff60000003068a40
[    2.253270]  t1 : 0000000000000003 t2 : 0000000000000000 s0 :
ff60000002327a90
[    2.253878]  s1 : 0000000000000000 a0 : ff60000003068a00 a1 :
ff60000003068a00
[    2.254491]  a2 : ff600000030687e8 a3 : 0000000000000004 a4 :
0000000000000000
[    2.255521]  a5 : 0000000000000000 a6 : 0000000000000000 a7 :
0000000000000000
[    2.256506]  s2 : 0000000000000000 s3 : 0000000000000000 s4 :
ff60000002327aa0
[    2.257161]  s5 : ffffffff816071c0 s6 : 0000000000000000 s7 :
0000000000000001
[    2.257761]  s8 : 0000000000000000 s9 : 0000000000000004 s10:
ff600000030687c0
[    2.258369]  s11: 0000000000000004 t3 : 0000000000000000 t4 :
0000000000000014
[    2.259368]  t5 : 0000000000000000 t6 : 0000000000000000
[    2.260270] status: 0000000200000120 badaddr: 0000000000000000
cause: 0000000000000003
[    2.261200] [<ffffffff805d941e>] virtnet_set_affinity+0x14a/0x1c0
[    2.261837] [<ffffffff805db734>] virtnet_probe+0x832/0xf1e
[    2.262319] [<ffffffff804ff5d0>] virtio_dev_probe+0x164/0x2de
[    2.263055] [<ffffffff8054d478>] really_probe+0x82/0x224
[    2.263858] [<ffffffff8054d674>] __driver_probe_device+0x5a/0xaa
[    2.264445] [<ffffffff8054d6f0>] driver_probe_device+0x2c/0xb8
[    2.264987] [<ffffffff8054dd1a>] __driver_attach+0x76/0x108
[    2.265495] [<ffffffff8054b436>] bus_for_each_dev+0x52/0x9a
[    2.265996] [<ffffffff8054ce40>] driver_attach+0x1a/0x28
[    2.266475] [<ffffffff8054c94a>] bus_add_driver+0x154/0x1c2
[    2.267383] [<ffffffff8054e546>] driver_register+0x52/0x108
[    2.268198] [<ffffffff804ff0d4>] register_virtio_driver+0x1c/0x2c
[    2.268778] [<ffffffff80a291a0>] virtio_net_driver_init+0x7a/0xb0
[    2.269323] [<ffffffff80002854>] do_one_initcall+0x66/0x2e4
[    2.269834] [<ffffffff80a01226>] kernel_init_freeable+0x28a/0x304
[    2.270372] [<ffffffff808cc8b6>] kernel_init+0x1e/0x110
[    2.271099] [<ffffffff80003d42>] ret_from_exception+0x0/0x10
[    2.272015] ---[ end trace 0000000000000000 ]---

-- 
Best Regards
 Guo Ren
