Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D0E68B10F
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 18:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBERK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 12:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBERK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 12:10:28 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC3A18AB5
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 09:10:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hx15so28059213ejc.11
        for <netdev@vger.kernel.org>; Sun, 05 Feb 2023 09:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klCqJCKU4YLr6uGmleTACmUyvOyGwUQhX/9UP4DM7Dw=;
        b=Rz2iYph9wWaeiZPI7rcG7tDKZsNnWrHFv5ndYh2tjZgpaTicp+n+18ntYrHnCUNB95
         rT8SuVdzQkCEEpN4/kJLZbiiLDTWt12GMu3mN0Zgk2FEX5O+nyyUObA5roQIE38L//IU
         m27NBZIoFxV6Txm9M/9aRK8jBtqz1N1zXAMJ98zUBh46A9FRpc/4e+bZLqgeAoHiIi5m
         6dFiWWCpkzKcuDxM9iZxxpOPTbVNcgxFIiG1MyrguY2rVmSFVIVlQvvv18vUfjUAA+MN
         8sxnHJE1B93uu0TLzId6phMpIJ/U/L7HP1503zq/75zqPYN5ZRMKTdXAJ/CpHQerKfS/
         zKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=klCqJCKU4YLr6uGmleTACmUyvOyGwUQhX/9UP4DM7Dw=;
        b=zl4PyDBN2a5pk/zrv6isnqCQSfzoHXy6sKl4ppk4XE2y1PGP6y/fM0o+YKOoDPZdph
         EL6atye1KV+PIxT57PFE5fRaCRj8ek/a2XxQykcl2DDg/ihupgDJaDKSZ9/pu1ySiNUx
         OnFuxSdZePxGjTrJJg3RVs02aitV+FshjGCM67VV3HL08rui5j26lJkNBDqPMRxbbts4
         GMcZ2zv2PN03jK3bPAIkIWRtd3wnBvbHvYITve1moT+nN5+oZhoOtHH5KeSjPc9Lszo/
         iDoPx3OPGE5KBamgs3IFqwm1TN4sOjAWrr5oL0ggzgxzKZYVnJSUiHKRQkX5hg/TQs1u
         3CwA==
X-Gm-Message-State: AO0yUKX5PPnGYfNEyDIW20u6zNxbNmTr1S/CQMNQMb47lMS8ldx8Ss9W
        dkR5Y5cNCeuyXYSrdHgYbMTbrrWd4B1DBsQCl+M=
X-Google-Smtp-Source: AK7set9MAljKQlSqW2AI1ooXfb1KOc7muvAQxtzQ38AQtH8RaYyfNY1vzn3NWRqj/RfOw0654Ou/RiJv/LS5lkQu7Vc=
X-Received: by 2002:a17:906:7c9:b0:881:a4b2:c93e with SMTP id
 m9-20020a17090607c900b00881a4b2c93emr5147058ejc.222.1675617025785; Sun, 05
 Feb 2023 09:10:25 -0800 (PST)
MIME-Version: 1.0
References: <719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com> <20230203101157.450d41eb@kernel.org>
In-Reply-To: <20230203101157.450d41eb@kernel.org>
From:   Moshe Shemesh <moshes20.il@gmail.com>
Date:   Sun, 5 Feb 2023 19:10:15 +0200
Message-ID: <CALBF4T_KgcwuTwMAHBBD-49+7v0e07+vu+ZFuC6xAMOeWeS+XQ@mail.gmail.com>
Subject: Re: WARNING: CPU: 83 PID: 2098 at net/devlink/leftover.c:10904 devl_param_driverinit_value_get+0xe5/0x1f0
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, Jiri Pirko <jiri@resnulli.us>,
        Networking <netdev@vger.kernel.org>, moshe@nvidia.com,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got it, will send a fix.

Moshe.

On Fri, Feb 3, 2023 at 8:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Cc: Jiri
>
> On Fri, 3 Feb 2023 11:14:10 -0600 Kim Phillips wrote:
> > Hi,
> >
> > I took today's linux-next (next-20230202) for a test drive on an
> > AMD Rome reference system and saw this splat.  Full dmesg and
> > config attached.
> >
> > Thanks,
> >
> > Kim
> >
> > [   23.675173] ------------[ cut here ]------------
> > [   23.679803] WARNING: CPU: 83 PID: 2098 at net/devlink/leftover.c:109=
04 devl_param_driverinit_value_get+0xe5/0x1f0
> > [   23.690069] Modules linked in: mlx5_ib(+) ib_uverbs ib_core crct10di=
f_pclmul ast crc32_pclmul i2c_algo_bit ghash_clmulni_intel sha512_ssse3 aes=
ni_intel crypto_simd cryptd drm_shmem_helper mlx5_core drm_kms_helper sysco=
pyarea sysfillrect hid_generic pci_hyperv_intf sysimgblt mlxfw usbhid psamp=
le ahci drm hid libahci tls i2c_piix4 wmi
> > [   23.719505] CPU: 83 PID: 2098 Comm: systemd-udevd Not tainted 6.2.0-=
rc6-next-20230202 #3
> > [   23.727596] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS=
 RDY1009A 09/16/2020
> > [   23.735683] RIP: 0010:devl_param_driverinit_value_get+0xe5/0x1f0
> > [   23.741695] Code: 00 5b b8 ea ff ff ff 41 5c 41 5d 5d e9 e8 c5 08 00=
 48 8d bf 28 02 00 00 be ff ff ff ff e8 93 22 07 00 85 c0 0f 85 43 ff ff ff=
 <0f> 0b 49 8b 84 24 18 01 00 00 48 83 78 18 00 0f 85 41 ff ff ff 0f
> > [   23.760442] RSP: 0018:ffff9efb1cdeba28 EFLAGS: 00010246
> > [   23.765667] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000=
000000000
> > [   23.772798] RDX: 0000000000000000 RSI: ffff8a0f12580228 RDI: ffff8a0=
eff520d50
> > [   23.779934] RBP: ffff9efb1cdeba40 R08: 0000000000000000 R09: ffff8a1=
dd43a4e00
> > [   23.787066] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8a0=
f12580000
> > [   23.794198] R13: ffff9efb1cdeba50 R14: 0000000000000001 R15: 0000000=
000000002
> > [   23.801332] FS:  00007f85f8d0c880(0000) GS:ffff8a2d74800000(0000) kn=
lGS:0000000000000000
> > [   23.809417] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   23.815162] CR2: 00007f85f9281f70 CR3: 0000800185aec000 CR4: 0000000=
000350ee0
> > [   23.822292] Call Trace:
> > [   23.824747]  <TASK>
> > [   23.826849]  mlx5_is_roce_on+0x3a/0xb0 [mlx5_core]
> > [   23.831740]  ? __kmalloc+0x53/0x1b0
> > [   23.835246]  mlx5r_probe+0x149/0x170 [mlx5_ib]
> > [   23.839719]  ? __pfx_mlx5r_probe+0x10/0x10 [mlx5_ib]
> > [   23.844698]  auxiliary_bus_probe+0x45/0xa0
> > [   23.848806]  really_probe+0x17b/0x3e0
> > [   23.852471]  __driver_probe_device+0x7e/0x180
> > [   23.856829]  driver_probe_device+0x23/0x80
> > [   23.860929]  __driver_attach+0xcb/0x1a0
> > [   23.864770]  ? __pfx___driver_attach+0x10/0x10
> > [   23.869214]  bus_for_each_dev+0x89/0xd0
> > [   23.873056]  driver_attach+0x22/0x30
> > [   23.876642]  bus_add_driver+0x1b9/0x240
> > [   23.880483]  driver_register+0x66/0x130
> > [   23.884322]  __auxiliary_driver_register+0x73/0xe0
> > [   23.889114]  mlx5_ib_init+0xda/0x110 [mlx5_ib]
> > [   23.893575]  ? __pfx_init_module+0x10/0x10 [mlx5_ib]
> > [   23.898559]  do_one_initcall+0x7a/0x2b0
> > [   23.902412]  ? kmalloc_trace+0x2e/0xe0
> > [   23.906168]  do_init_module+0x52/0x220
> > [   23.909930]  load_module+0x209d/0x2380
> > [   23.913685]  ? ima_post_read_file+0xd6/0xf0
> > [   23.917885]  __do_sys_finit_module+0xc8/0x140
> > [   23.922243]  ? __do_sys_finit_module+0xc8/0x140
> > [   23.926783]  __x64_sys_finit_module+0x1e/0x30
> > [   23.931147]  do_syscall_64+0x3f/0x90
> > [   23.934731]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [   23.939785] RIP: 0033:0x7f85f933773d
> > [   23.943366] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa=
 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05=
 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 23 37 0d 00 f7 d8 64 89 01 48
> > [   23.962116] RSP: 002b:00007fff3da2b718 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000139
> > [   23.969685] RAX: ffffffffffffffda RBX: 000055777d8371e0 RCX: 00007f8=
5f933773d
> > [   23.976818] RDX: 0000000000000000 RSI: 00007f85f9217ded RDI: 0000000=
00000000e
> > [   23.983949] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000557=
77d7d3868
> > [   23.991086] R10: 000000000000000e R11: 0000000000000246 R12: 00007f8=
5f9217ded
> > [   23.998222] R13: 0000000000000000 R14: 000055777d8330f0 R15: 0000557=
77d8371e0
> > [   24.005363]  </TASK>
> > [   24.007557] ---[ end trace 0000000000000000 ]---
>
