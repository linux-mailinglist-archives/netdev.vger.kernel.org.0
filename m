Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F337600580
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 04:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiJQC4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 22:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiJQC4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 22:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFBF48A19;
        Sun, 16 Oct 2022 19:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F61760EFC;
        Mon, 17 Oct 2022 02:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09071C43146;
        Mon, 17 Oct 2022 02:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665975379;
        bh=X5UDt4vqMWaN6iV0s0AyD/9vX91684ppRxBuCeB3NGE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CS9d1SjgetKTs1ARmlBn0nq6shVETt7Y8bM00b4QLf4K8sLAmmWbxwdVcRa78PfOP
         ZDSpabBr9CQbodl6/CFUUttQZIzeOO6ylayeSDFjKMUwqpy6Y1L3M6QesU0HSO+XWp
         qG1YjjlVbo2cAVOFH1+g8vSsi7ZbTqnS3gHJE5BN3oJmlJ+QjVP+MAAKEirI/wpYy6
         /GfMYQFaMBHzvgvR+a8cp18yxRRO98/TULzbZzzaRFfj+7cYpXoM4doZRv9rQYhAeE
         PvtbDmSKLGhRiDP7MDaiC7WbQ771yZqajCYHKyAIqNaQ2NXnslSKcseYmdp4O4ELUY
         i6QUVqxxb2aVA==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1321a1e94b3so11989747fac.1;
        Sun, 16 Oct 2022 19:56:18 -0700 (PDT)
X-Gm-Message-State: ACrzQf1uJo9OlFBMY6JmYJDKEa1yB4dYSmTPXjj7P4wG+ej52VyLp4yD
        H5309mTEie3x4aBRSSA84fGF1YtKe9Z4GJWk9Nw=
X-Google-Smtp-Source: AMsMyM4eNckggxZwIH1ide7sewatyTGemrJIdnknZo/3q3XjS0gzS8sgHkJCCCwvf4JuycVafWbfKv2aIUafZP8zUTg=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr14463152oah.112.1665975378067; Sun, 16
 Oct 2022 19:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221015130548.3634468-1-guoren@kernel.org> <20221015165017.GA1034513@roeck-us.net>
 <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com> <3e3e23a4-574a-166f-78fe-9113abec4d6b@roeck-us.net>
In-Reply-To: <3e3e23a4-574a-166f-78fe-9113abec4d6b@roeck-us.net>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 17 Oct 2022 10:56:05 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTz=Whg+heB95doVnQWVvjNC1bCx1bYLMW4CtybABBGNA@mail.gmail.com>
Message-ID: <CAJF2gTTz=Whg+heB95doVnQWVvjNC1bCx1bYLMW4CtybABBGNA@mail.gmail.com>
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

Ping Jakub Kicinski <kuba@kernel.org>.

You seem to miss this Revert fixup on cpumask_check(n + 1).

Your patch has merged in v6.1-rc1, but that is not enough.
https://lore.kernel.org/netdev/166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org/T/#m0111a76380626b2f91e072ecdd5827578d5cbf60

Without the patch, there still is a warning.

On Sun, Oct 16, 2022 at 11:49 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 10/15/22 19:58, Guo Ren wrote:
> > On Sun, Oct 16, 2022 at 12:50 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> On Sat, Oct 15, 2022 at 09:05:48AM -0400, guoren@kernel.org wrote:
> >>> From: Guo Ren <guoren@linux.alibaba.com>
> >>>
> >>> This reverts commit 78e5a3399421ad79fc024e6d78e2deb7809d26af.
> >>>
> >>> ------------[ cut here ]------------
> >>> WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> >>>
> >>> Let's back this out and retry with a larger clean up in -next.
> >>>
> >>
> >> Unfortunately the revert triggers (or exposes ?) another backtrace.
> > This should be fixed by another Revert patch.
> >
> > https://lore.kernel.org/netdev/166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org/T/#m0111a76380626b2f91e072ecdd5827578d5cbf60
> >
> > Please have a try.
> >
>
> Yes, I already tested that one and confirmed that it fixes the warning below.
> Thanks for the pointer.
>
> Guenter
>
> >>
> >> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x194/0x976
> >> Modules linked in:
> >> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-12199-g277163563de8 #1
> >> Hardware name: riscv-virtio,qemu (DT)
> >> epc : __netif_set_xps_queue+0x194/0x976
> >> ra : __netif_set_xps_queue+0x3b0/0x976
> >> epc : c089a664 ra : c089a880 sp : c2515c60
> >> gp : c1d8e760 tp : c2578040 t0 : c364f980
> >> t1 : 00000000 t2 : 00001fff s0 : c2515cd0
> >> s1 : c2515ce4 a0 : c364f940 a1 : 00000000
> >> a2 : c364f940 a3 : 00000000 a4 : c364f950
> >> a5 : c364f890 a6 : 00000003 a7 : 00000000
> >> s2 : 00000001 s3 : c1d382c0 s4 : 00000000
> >> s5 : 00000000 s6 : 00000000 s7 : c364f880
> >> s8 : 00000000 s9 : 00000001 s10: 00000001
> >> s11: 00000000 t3 : 00000018 t4 : 7fd38a0e
> >> t5 : 00000007 t6 : c3639470
> >> status: 00000120 badaddr: 00000000 cause: 00000003
> >> [<c074548a>] virtnet_set_affinity+0x13a/0x1a2
> >> [<c07478de>] virtnet_probe+0x884/0xfdc
> >> [<c063ce9a>] virtio_dev_probe+0x1d6/0x354
> >> [<c0683d6e>] really_probe+0x82/0x214
> >> [<c0683f58>] __driver_probe_device+0x58/0xa2
> >> [<c0683fd2>] driver_probe_device+0x30/0xaa
> >> [<c0684596>] __driver_attach+0x56/0x11c
> >> [<c0681f26>] bus_for_each_dev+0x52/0x90
> >> [<c06837c0>] driver_attach+0x1a/0x22
> >> [<c068331a>] bus_add_driver+0x148/0x1b6
> >> [<c0684d70>] driver_register+0x52/0xea
> >> [<c063c924>] register_virtio_driver+0x1a/0x28
> >> [<c0c2428e>] virtio_net_driver_init+0x7a/0xa6
> >> [<c0002824>] do_one_initcall+0x5e/0x2e2
> >> [<c0c01130>] kernel_init_freeable+0x298/0x306
> >> [<c0aa0ac2>] kernel_init+0x1e/0x10e
> >> [<c0003ad8>] ret_from_exception+0x0/0x10
> >> irq event stamp: 106012
> >> hardirqs last  enabled at (106011): [<c0aa9284>] _raw_spin_unlock_irqrestore+0x54/0x62
> >> hardirqs last disabled at (106012): [<c0007534>] __trace_hardirqs_off+0xc/0x14
> >> softirqs last  enabled at (105764): [<c0886392>] napi_get_frags_check+0x0/0x50
> >> softirqs last disabled at (105758): [<c0886392>] napi_get_frags_check+0x0/0x50
> >>
> >> This is the result of commit 854701ba4c39 ("net: fix cpu_max_bits_warn()
> >> usage in netif_attrmask_next{,_and}").
> >>
> >> Guenter
> >
> >
> >
>


--
Best Regards
 Guo Ren
