Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF94C67B410
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbjAYORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjAYORP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:17:15 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381645896E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:17:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m12so1756620edq.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7PAjlRWnZAL3/rPN1yPsa0rk4kaOwtI7jNh2qhfaglA=;
        b=AlnoL7Vu7l80hIqc10OFaC9x15Xs8hilVZ6zVtiCKg5p+zShCVgyjDqIyYrOlX0owH
         V9lTNbhA7O/kgZEO0CDpaBX2s+oYC2G561qz9VXJT3uN+MqXTtg6O9KJaHtzDoCQpCsz
         8hYBGNyMXYSYPmPi6hOk6pUyQvMxaC1HIBRtM15LVJJK3Jkp0DpKCUzjG/yBivSLzwRE
         aVzUVIeLj5snR+wyAWNK33Dcy22Kq6pRTbLrK5JkoebVEctKs6Ux/t/Q5sFIhSe5DNqX
         rLX82DFZFNhU8xCeZ6vBeZaDhaBz/KprtUFd9+/6Qo0v0xAa6Avx0FTohSNRocaJ8247
         xE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PAjlRWnZAL3/rPN1yPsa0rk4kaOwtI7jNh2qhfaglA=;
        b=RxVB23232ov6HIAdMN1YDsuu5DhcAVWvxfADwWAKE+T8rt9QUQpY8B1ghwmR9tnL7U
         kI9PpYFM9Ct0cBvS8o8jZtTJQsB+ql2hlp/X0iZSi0eoEwvZXSbM5Zn8vJ3Dh5e2VYIS
         YOGuh9P+XF1tJBVDse4R1Id9lmzT/vccM6LI21RsDWL4Eg9EJEKIhRMmFKzyNUlwsa7J
         MYKCXuiuGGRad9dQ5o2SMP4tf68OpM12r1LQc2rF6lMRg1kVKo4/naSjgywgwWgcBZ5t
         3xA7BpUku9S7cfhM4Mc+0wxww6UINIX6sV5qFHJp6pGEnwxNPYiw4NECvFbGqSFsLQOe
         KJwQ==
X-Gm-Message-State: AO0yUKVdQFO3ypNbsEMBSa4X8ocDmc9cU37WbgmdHjqAxBBZmt6XyHaL
        jdnA7Zq4faABlzkWYJ/T5MOcdA==
X-Google-Smtp-Source: AK7set87k59AlZ/+F44OfkBQvWNM84AbxdH3PJ57jkorQaMwvnixW1Nf/VkMKk23ea8IjU2oYFKZyg==
X-Received: by 2002:aa7:c688:0:b0:4a0:8f64:aa8c with SMTP id n8-20020aa7c688000000b004a08f64aa8cmr5785401edq.6.1674656227698;
        Wed, 25 Jan 2023 06:17:07 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n19-20020a05640204d300b004954c90c94bsm2436933edw.6.2023.01.25.06.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:17:06 -0800 (PST)
Date:   Wed, 25 Jan 2023 15:17:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: bnxt devl_assert_locked warning
Message-ID: <Y9E54SibGQ2HSCPT@nanopsycho>
References: <Y9EwWk7jn5+VATav@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9EwWk7jn5+VATav@x1-carbon>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 25, 2023 at 02:36:27PM CET, Niklas.Cassel@wdc.com wrote:
>Hello there,
>
>When testing next-20230124 and next-20230125 I get a warning about devlink
>lock not being held in the bnxt driver, at boot or when modprobing the driver.
>See trace below.
>
>I haven't seen this when testing just 1-2 weeks ago, so I assume that something
>that went in recently caused this.
>
>Searching lore.kernel.org/netdev shows that Jiri has done a lot of refactoring
>with regards to devlink locking recently, could that be related?

Oh yeah, this is due to:
63ba54a52c417a0c632a5f85a2b912b8a2320358

I just set a patches that is fixing this taking devlink instance lock
for params operations:
https://lore.kernel.org/netdev/20230125141412.1592256-1-jiri@resnulli.us/

>
>
>Kind regards,
>Niklas
>
>
>[71257.565758] WARNING: CPU: 27 PID: 87838 at net/devlink/core.c:39 devl_assert_locked+0x58/0x70
>[71257.580972] CPU: 27 PID: 87838 Comm: sh Kdump: loaded Tainted: G        W          6.2.0-rc5-next-20230124+ #134
>[71257.592344] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.4 04/14/2022
>[71257.601028] RIP: 0010:devl_assert_locked+0x58/0x70
>[71257.607009] Code: 04 84 d2 75 2d 8b 05 a3 99 31 02 85 c0 75 06 5b e9 6d 7f 40 00 48 8d bb 18 02 00 00 be ff ff ff ff e8 bc 38 3d 00 85 c0 75 e5 <0f> 0b 5b e9 50 7f 40 00 48 c7 c7 6c 18 90 92 e8 a4 bc 5e fd eb c5
>[71257.628221] RSP: 0018:ffffc900220ef758 EFLAGS: 00010246
>[71257.634684] RAX: 0000000000000000 RBX: ffff8881cb6bd800 RCX: 0000000000000001
>[71257.643070] RDX: 0000000000000000 RSI: ffffffff90cd0d20 RDI: ffffffff90ff34c0
>[71257.651433] RBP: ffff8881f58e5740 R08: 0000000000000001 R09: ffffffff94347b47
>[71257.659801] R10: fffffbfff2868f68 R11: 0000000000000004 R12: 0000000000000028
>[71257.668153] R13: ffff8881cb6bd800 R14: 0000000000000005 R15: ffff8881cb6bd898
>[71257.676510] FS:  00007efcff4be740(0000) GS:ffff889f8ef80000(0000) knlGS:0000000000000000
>[71257.685847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[71257.692838] CR2: 000055933adcc268 CR3: 0000000138c5a000 CR4: 0000000000350ee0
>[71257.701236] Call Trace:
>[71257.704900]  <TASK>
>[71257.708199]  devlink_param_notify.constprop.0+0x1d/0x1f0
>[71257.714742]  ? __kasan_kmalloc+0xa6/0xb0
>[71257.719899]  devlink_param_register+0x358/0x630
>[71257.725666]  devlink_params_register+0x3b/0xa0
>[71257.731318]  bnxt_dl_register+0x37a/0x4e0
>[71257.736532]  ? __pfx_bnxt_dl_register+0x10/0x10
>[71257.742266]  ? bnxt_init_tc+0x959/0xae0
>[71257.747287]  bnxt_init_one+0x18e2/0x3070
>[71257.752382]  ? __pfx_bnxt_init_one+0x10/0x10
>[71257.757828]  ? mark_held_locks+0x9e/0xe0
>[71257.762901]  ? _raw_spin_unlock_irqrestore+0x30/0x60
>[71257.769021]  ? lockdep_hardirqs_on+0x7d/0x100
>[71257.774523]  ? _raw_spin_unlock_irqrestore+0x40/0x60
>[71257.780628]  ? __pfx_bnxt_init_one+0x10/0x10
>[71257.786033]  local_pci_probe+0xdb/0x170
>[71257.790992]  pci_device_probe+0x46a/0x740
>[71257.796115]  ? __pfx_pci_device_probe+0x10/0x10
>[71257.801758]  ? kernfs_create_link+0x167/0x230
>[71257.807211]  ? do_raw_spin_unlock+0x54/0x1f0
>[71257.812598]  really_probe+0x1e3/0xa00
>[71257.817365]  __driver_probe_device+0x18c/0x460
>[71257.822919]  driver_probe_device+0x4a/0x120
>[71257.828178]  __device_attach_driver+0x15e/0x270
>[71257.833795]  ? __pfx___device_attach_driver+0x10/0x10
>[71257.839919]  bus_for_each_drv+0x114/0x190
>[71257.844994]  ? __pfx_bus_for_each_drv+0x10/0x10
>[71257.850579]  ? lockdep_hardirqs_on+0x7d/0x100
>[71257.855985]  ? _raw_spin_unlock_irqrestore+0x40/0x60
>[71257.862030]  __device_attach+0x189/0x380
>[71257.867007]  ? __pfx___device_attach+0x10/0x10
>[71257.872496]  ? bus_find_device+0x13e/0x1a0
>[71257.877624]  ? __pfx_bus_find_device+0x10/0x10
>[71257.883081]  bus_rescan_devices_helper+0xca/0x1c0
>[71257.888791]  drivers_probe_store+0x30/0x60
>[71257.893857]  kernfs_fop_write_iter+0x359/0x530
>[71257.899278]  vfs_write+0x51c/0xc70
>[71257.903594]  ? __pfx_vfs_write+0x10/0x10
>[71257.908416]  ? lock_is_held_type+0xe3/0x140
>[71257.913483]  ? __fget_light+0x51/0x230
>[71257.918118]  ksys_write+0xe7/0x1b0
>[71257.922377]  ? __pfx_ksys_write+0x10/0x10
>[71257.927278]  ? syscall_enter_from_user_mode+0x22/0xc0
>[71257.933193]  ? lockdep_hardirqs_on+0x7d/0x100
>[71257.938405]  do_syscall_64+0x5b/0x80
>[71257.942802]  ? lock_is_held_type+0xe3/0x140
>[71257.947813]  ? asm_exc_page_fault+0x22/0x30
>[71257.952806]  ? lockdep_hardirqs_on+0x7d/0x100
>[71257.957977]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>[71257.963841] RIP: 0033:0x7efcff5bc284
>[71257.968217] Code: 15 b1 7b 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 80 3d 7d 03 0e 00 00 74 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24 18 48
>[71257.988714] RSP: 002b:00007ffe85ebbb78 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
>[71257.997224] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007efcff5bc284
>[71258.005275] RDX: 000000000000000d RSI: 000055933adcb260 RDI: 0000000000000001
>[71258.013335] RBP: 000055933adcb260 R08: 0000000000001000 R09: 0000000000000000
>[71258.021408] R10: 0000000000001000 R11: 0000000000000202 R12: 000000000000000d
>[71258.029473] R13: 00007efcff695780 R14: 000000000000000d R15: 00007efcff690a00
>[71258.037572]  </TASK>
>[71258.040650] irq event stamp: 17759
>[71258.044970] hardirqs last  enabled at (17773): [<ffffffff8d567cee>] __up_console_sem+0x5e/0x70
>[71258.054551] hardirqs last disabled at (17786): [<ffffffff8d567cd3>] __up_console_sem+0x43/0x70
>[71258.064119] softirqs last  enabled at (17712): [<ffffffff8d3d48fe>] __irq_exit_rcu+0xfe/0x260
>[71258.073613] softirqs last disabled at (17809): [<ffffffff8d3d48fe>] __irq_exit_rcu+0xfe/0x260
>[71258.083099] ---[ end trace 0000000000000000 ]---
