Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF7768A153
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 19:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBCSMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 13:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbjBCSMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 13:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA0EADB9A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 10:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D42661FC6
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 18:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ACCC433EF;
        Fri,  3 Feb 2023 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675447918;
        bh=vZzVlHauxVoQz4I5UYqHxQYxfJumsczgZ5OSqei6SH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E2/qBbaOeA5msAQOEIqArvz3aqJRniPei2S1nbs5o8MkqCF+JjLMgfsfWrj7gNFnw
         qkbYYDm4Qz7MLMmZuiMlE/XWdrdHLJf1uO+U+KWPXn24ZKIsym4DyX+wjE59mAMK0z
         tGYYfKwDNUb6aVULImDGe2sqUlTzBtpkYKgfPl1ZKR2+DrKvP09OWNdeP8hNLVHhXV
         IOzrClfWlIGJ+KDDizVXyXcoGrnmDoaZhJf3IRUYfZ+emYXDo1mudjeasInXZtRHlA
         ItsOPElr2bfH7o4iFEabVY4hl2oaA85tOCFic+OdKA93jMk+47z06RtapMqZ+gahrX
         fw7oiLLK3b9PQ==
Date:   Fri, 3 Feb 2023 10:11:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Networking <netdev@vger.kernel.org>
Subject: Re: WARNING: CPU: 83 PID: 2098 at net/devlink/leftover.c:10904
 devl_param_driverinit_value_get+0xe5/0x1f0
Message-ID: <20230203101157.450d41eb@kernel.org>
In-Reply-To: <719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com>
References: <719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Jiri

On Fri, 3 Feb 2023 11:14:10 -0600 Kim Phillips wrote:
> Hi,
> 
> I took today's linux-next (next-20230202) for a test drive on an
> AMD Rome reference system and saw this splat.  Full dmesg and
> config attached.
> 
> Thanks,
> 
> Kim
> 
> [   23.675173] ------------[ cut here ]------------
> [   23.679803] WARNING: CPU: 83 PID: 2098 at net/devlink/leftover.c:10904 devl_param_driverinit_value_get+0xe5/0x1f0
> [   23.690069] Modules linked in: mlx5_ib(+) ib_uverbs ib_core crct10dif_pclmul ast crc32_pclmul i2c_algo_bit ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd drm_shmem_helper mlx5_core drm_kms_helper syscopyarea sysfillrect hid_generic pci_hyperv_intf sysimgblt mlxfw usbhid psample ahci drm hid libahci tls i2c_piix4 wmi
> [   23.719505] CPU: 83 PID: 2098 Comm: systemd-udevd Not tainted 6.2.0-rc6-next-20230202 #3
> [   23.727596] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
> [   23.735683] RIP: 0010:devl_param_driverinit_value_get+0xe5/0x1f0
> [   23.741695] Code: 00 5b b8 ea ff ff ff 41 5c 41 5d 5d e9 e8 c5 08 00 48 8d bf 28 02 00 00 be ff ff ff ff e8 93 22 07 00 85 c0 0f 85 43 ff ff ff <0f> 0b 49 8b 84 24 18 01 00 00 48 83 78 18 00 0f 85 41 ff ff ff 0f
> [   23.760442] RSP: 0018:ffff9efb1cdeba28 EFLAGS: 00010246
> [   23.765667] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000000
> [   23.772798] RDX: 0000000000000000 RSI: ffff8a0f12580228 RDI: ffff8a0eff520d50
> [   23.779934] RBP: ffff9efb1cdeba40 R08: 0000000000000000 R09: ffff8a1dd43a4e00
> [   23.787066] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8a0f12580000
> [   23.794198] R13: ffff9efb1cdeba50 R14: 0000000000000001 R15: 0000000000000002
> [   23.801332] FS:  00007f85f8d0c880(0000) GS:ffff8a2d74800000(0000) knlGS:0000000000000000
> [   23.809417] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   23.815162] CR2: 00007f85f9281f70 CR3: 0000800185aec000 CR4: 0000000000350ee0
> [   23.822292] Call Trace:
> [   23.824747]  <TASK>
> [   23.826849]  mlx5_is_roce_on+0x3a/0xb0 [mlx5_core]
> [   23.831740]  ? __kmalloc+0x53/0x1b0
> [   23.835246]  mlx5r_probe+0x149/0x170 [mlx5_ib]
> [   23.839719]  ? __pfx_mlx5r_probe+0x10/0x10 [mlx5_ib]
> [   23.844698]  auxiliary_bus_probe+0x45/0xa0
> [   23.848806]  really_probe+0x17b/0x3e0
> [   23.852471]  __driver_probe_device+0x7e/0x180
> [   23.856829]  driver_probe_device+0x23/0x80
> [   23.860929]  __driver_attach+0xcb/0x1a0
> [   23.864770]  ? __pfx___driver_attach+0x10/0x10
> [   23.869214]  bus_for_each_dev+0x89/0xd0
> [   23.873056]  driver_attach+0x22/0x30
> [   23.876642]  bus_add_driver+0x1b9/0x240
> [   23.880483]  driver_register+0x66/0x130
> [   23.884322]  __auxiliary_driver_register+0x73/0xe0
> [   23.889114]  mlx5_ib_init+0xda/0x110 [mlx5_ib]
> [   23.893575]  ? __pfx_init_module+0x10/0x10 [mlx5_ib]
> [   23.898559]  do_one_initcall+0x7a/0x2b0
> [   23.902412]  ? kmalloc_trace+0x2e/0xe0
> [   23.906168]  do_init_module+0x52/0x220
> [   23.909930]  load_module+0x209d/0x2380
> [   23.913685]  ? ima_post_read_file+0xd6/0xf0
> [   23.917885]  __do_sys_finit_module+0xc8/0x140
> [   23.922243]  ? __do_sys_finit_module+0xc8/0x140
> [   23.926783]  __x64_sys_finit_module+0x1e/0x30
> [   23.931147]  do_syscall_64+0x3f/0x90
> [   23.934731]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [   23.939785] RIP: 0033:0x7f85f933773d
> [   23.943366] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 23 37 0d 00 f7 d8 64 89 01 48
> [   23.962116] RSP: 002b:00007fff3da2b718 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   23.969685] RAX: ffffffffffffffda RBX: 000055777d8371e0 RCX: 00007f85f933773d
> [   23.976818] RDX: 0000000000000000 RSI: 00007f85f9217ded RDI: 000000000000000e
> [   23.983949] RBP: 0000000000020000 R08: 0000000000000000 R09: 000055777d7d3868
> [   23.991086] R10: 000000000000000e R11: 0000000000000246 R12: 00007f85f9217ded
> [   23.998222] R13: 0000000000000000 R14: 000055777d8330f0 R15: 000055777d8371e0
> [   24.005363]  </TASK>
> [   24.007557] ---[ end trace 0000000000000000 ]---

