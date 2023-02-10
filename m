Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF46369196C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjBJHzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjBJHzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:55:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A787AE23
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 23:55:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bk16so4153676wrb.11
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 23:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/6gjy2/ayGlIUN6d7HJsRO/8721H4Uk3UYbewsc8uVM=;
        b=of56NT6oPJCsoaBa9ByW45nIdHA00eXhiS1oIi/AR8aLd8kwAnrnHK9Vh0y+AZBU3F
         hPleelQQ7+HjRoMXJD0WEMIMNT1FoEKHFAl3/2hsveLFvhfXmjOiDjzXE5mbBI2phBKZ
         VDvjIYsnyYYrmRJGqLa9oRIXkJCZ54hXcsu5ppyROYXB1I8VCqUhqhfVcCaUMxsKurTK
         2+dd3kglTKUTB43eQoQWngt0eRMGUqq2BrsyX9xzaBoZcGp9wDdbjICe8sl3bX5mzMvi
         ASU0Z5p/4M0PPgqyzfl1NZ5KV0S0IPqOo/vWU7X2IqZD4ZkSj6KCdgoEg4vMCLmoLVSn
         I4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6gjy2/ayGlIUN6d7HJsRO/8721H4Uk3UYbewsc8uVM=;
        b=T899R+QKMBDLBqb1Y+nVobdwpXxYTeh0uM/rWIh0F4iVqDxcGQNDTzCi4kz/2i4ueZ
         sUV9pymCVbA1QJr40JgbTGUE6Dg0s9u5lxm4GNoIkYwQssz0KE8nakwLzIzLEB8RFqly
         p9aGwnD7ee/8BKuIJK4Iph1jKELk2EjjlF2na3xY9kx3ysCqKZFvy4y9aO9EdFPJQxb5
         ycxD8/o6vRlnqIdUe7H1QTXEkIYYONZDjBXZO2javYgGPoeIoZuQ84udpNRcFZaOhxIm
         XfjELIT5c5PZjam/jgAFLaD3MDwlgV1/KjINm89J1yb/YgcquSABk1VTRFFgCf0Nb9hm
         wCaQ==
X-Gm-Message-State: AO0yUKWs7Y72eVFM5xpFDITBkHkl9lcMfPtR+5DMJpApSdYZB9KzJ66x
        oR/pMGRaJspykybTbNsnRNuskQ==
X-Google-Smtp-Source: AK7set8P+ETbmH6ZaF5v2C/QAKP86Frl1Yp1YDSlMwWW+GwlyN+DFgj9/UClTz1bII3JVUhHWTUorQ==
X-Received: by 2002:a05:6000:12cb:b0:2bd:e13f:48b8 with SMTP id l11-20020a05600012cb00b002bde13f48b8mr12319089wrx.3.1676015749167;
        Thu, 09 Feb 2023 23:55:49 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b4-20020adfee84000000b002bfb0c5527esm2997050wro.109.2023.02.09.23.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 23:55:48 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:55:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        tariqt@nvidia.com, saeedm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
Message-ID: <Y+X4gx1eARMJECVT@nanopsycho>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <81b9453b-87e4-c4d4-f083-bab9d7a85cbe@amd.com>
 <20230209133144.3e699727@kernel.org>
 <34be65a9-a741-7e4e-c7f3-a80d3e660528@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34be65a9-a741-7e4e-c7f3-a80d3e660528@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 09, 2023 at 11:37:13PM CET, kim.phillips@amd.com wrote:
>On 2/9/23 3:31 PM, Jakub Kicinski wrote:
>> On Thu, 9 Feb 2023 15:05:46 -0600 Kim Phillips wrote:
>> > Is there a different tree the series can be rebased on, until net-next
>> > gets fixed?
>> 
>> merge in net-next, the fix should be there but was merged a couple of
>> hours ago so probably not yet in linux-next
>
>I=Ok, I took next-20230209, git merged net-next/master, fixed a merge
>conflict to use the latter net-next/master version:
>
><<<<<<< HEAD
>	if (err == NOTIFY_BAD) {
>		dl_trap->trap.action = action_orig;
>		err = trap_event_ctx.err;
>	}
>out:
>	return err;
>=======
>	if (err == NOTIFY_BAD)
>		dl_trap->trap.action = action_orig;
>
>	return trap_event_ctx.err;
>>>>>>>> net-next/master
>
>...and unfortunately still get a splat on that same Rome system:
>
>[   22.647832] mlx5_core 0000:21:00.0: firmware version: 14.22.1002
>[   22.653879] mlx5_core 0000:21:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
>[   23.228950] mlx5_core 0000:21:00.0: E-Switch: Total vports 10, per vport: max uc(1024) max mc(16384)
>[   23.245100] mlx5_core 0000:21:00.0: Port module event: module 0, Cable plugged
>[   23.570053] mlx5_core 0000:21:00.0: Supported tc offload range - chains: 1, prios: 1
>[   23.577812] mlx5_core 0000:21:00.0: mlx5e_tc_post_act_init:40:(pid 9): firmware level support is missing
>[   23.594377] mlx5_core 0000:21:00.0: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0 basic)
>[   23.605492] mlx5_core 0000:21:00.1: firmware version: 14.22.1002
>[   23.611536] mlx5_core 0000:21:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
>[   24.199756] mlx5_core 0000:21:00.1: E-Switch: Total vports 10, per vport: max uc(1024) max mc(16384)
>[   24.216876] mlx5_core 0000:21:00.1: Port module event: module 1, Cable unplugged
>[   24.555670] mlx5_core 0000:21:00.1: Supported tc offload range - chains: 1, prios: 1
>[   24.563428] mlx5_core 0000:21:00.1: mlx5e_tc_post_act_init:40:(pid 9): firmware level support is missing
>[   24.580084] mlx5_core 0000:21:00.1: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0 basic)
>[   24.593808] systemd-udevd[1974]: Using default interface naming scheme 'v245'.
>[   24.602595] systemd-udevd[1974]: ethtool: autonegotiation is unset or enabled, the speed and duplex are not writable.
>[   24.613314] mlx5_core 0000:21:00.0 enp33s0f0np0: renamed from eth0
>[   24.701259] ------------[ cut here ]------------
>[   24.705888] WARNING: CPU: 228 PID: 2318 at net/devlink/leftover.c:9643 devl_param_driverinit_value_get+0xe5/0x1f0

Odd as this patchset removes this warning. I think you forgot to apply.


>[   24.716153] Modules linked in: mlx5_ib(+) ib_uverbs ib_core mlx5_core ast i2c_algo_bit drm_shmem_helper hid_generic drm_kms_helper syscopyarea sysfillrect sysimgblt usbhid pci_hyperv_intf crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd mlxfw hid psample drm ahci tls libahci i2c_piix4 wmi
>[   24.745589] CPU: 228 PID: 2318 Comm: systemd-udevd Not tainted 6.2.0-rc7-next-20230209+ #4
>[   24.753856] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
>[   24.761943] RIP: 0010:devl_param_driverinit_value_get+0xe5/0x1f0
>[   24.767955] Code: 00 5b b8 ea ff ff ff 41 5c 41 5d 5d e9 58 cd 08 00 48 8d bf 28 02 00 00 be ff ff ff ff e8 03 2a 07 00 85 c0 0f 85 43 ff ff ff <0f> 0b 49 8b 84 24 18 01 00 00 48 83 78 18 00 0f 85 41 ff ff ff 0f
>[   24.786702] RSP: 0018:ffffc217dfff7a28 EFLAGS: 00010246
>[   24.791925] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000000
>[   24.799058] RDX: 0000000000000000 RSI: ffff9d7458b00228 RDI: ffff9d835f588d50
>[   24.806194] RBP: ffffc217dfff7a40 R08: 0000000000000000 R09: ffff9d8316157c00
>[   24.813325] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9d7458b00000
>[   24.820455] R13: ffffc217dfff7a50 R14: 0000000000000001 R15: 0000000000000002
>[   24.827589] FS:  00007f03c4b0a880(0000) GS:ffff9d92c8c00000(0000) knlGS:0000000000000000
>[   24.835677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[   24.841422] CR2: 00007ffd0c160f48 CR3: 000080109f420000 CR4: 0000000000350ee0
>[   24.848557] Call Trace:
>[   24.851003]  <TASK>
>[   24.853117]  mlx5_is_roce_on+0x3a/0xb0 [mlx5_core]
>[   24.858010]  ? __kmalloc+0x53/0x1b0
>[   24.861512]  mlx5r_probe+0x149/0x170 [mlx5_ib]
>[   24.865974]  ? __pfx_mlx5r_probe+0x10/0x10 [mlx5_ib]
>[   24.870957]  auxiliary_bus_probe+0x45/0xa0
>[   24.875059]  really_probe+0x17b/0x3e0
>[   24.878731]  __driver_probe_device+0x7e/0x180
>[   24.883090]  driver_probe_device+0x23/0x80
>[   24.887191]  __driver_attach+0xcb/0x1a0
>[   24.891027]  ? __pfx___driver_attach+0x10/0x10
>[   24.895475]  bus_for_each_dev+0x89/0xd0
>[   24.899311]  driver_attach+0x22/0x30
>[   24.902894]  bus_add_driver+0x1b9/0x240
>[   24.906735]  driver_register+0x66/0x130
>[   24.910584]  __auxiliary_driver_register+0x73/0xe0
>[   24.915385]  mlx5_ib_init+0xda/0x110 [mlx5_ib]
>[   24.919846]  ? __pfx_init_module+0x10/0x10 [mlx5_ib]
>[   24.924831]  do_one_initcall+0x7a/0x2b0
>[   24.928677]  ? kmalloc_trace+0x2e/0xe0
>[   24.932433]  do_init_module+0x6a/0x260
>[   24.936191]  load_module+0x1e90/0x2050
>[   24.939942]  ? ima_post_read_file+0xd6/0xf0
>[   24.944138]  __do_sys_finit_module+0xc8/0x140
>[   24.948497]  ? __do_sys_finit_module+0xc8/0x140
>[   24.953036]  __x64_sys_finit_module+0x1e/0x30
>[   24.957399]  do_syscall_64+0x3f/0x90
>[   24.960987]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>[   24.966047] RIP: 0033:0x7f03c513673d
>[   24.969628] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 23 37 0d 00 f7 d8 64 89 01 48
>[   24.988380] RSP: 002b:00007ffd0c1665f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
>[   24.995943] RAX: ffffffffffffffda RBX: 0000556e1aec4d30 RCX: 00007f03c513673d
>[   25.003078] RDX: 0000000000000000 RSI: 00007f03c5016ded RDI: 000000000000000e
>[   25.010210] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000556e1ae664e8
>[   25.017343] R10: 000000000000000e R11: 0000000000000246 R12: 00007f03c5016ded
>[   25.024477] R13: 0000000000000000 R14: 0000556e1aeee320 R15: 0000556e1aec4d30
>[   25.031621]  </TASK>
>[   25.033815] ---[ end trace 0000000000000000 ]---
>[   25.072333] ------------[ cut here ]------------
>[   25.076971] WARNING: CPU: 100 PID: 2318 at net/devlink/leftover.c:9643 devl_param_driverinit_value_get+0xe5/0x1f0
>[   25.087406] Modules linked in: mlx5_ib(+) ib_uverbs ib_core mlx5_core ast i2c_algo_bit drm_shmem_helper hid_generic drm_kms_helper syscopyarea sysfillrect sysimgblt usbhid pci_hyperv_intf crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd mlxfw hid psample drm ahci tls libahci i2c_piix4 wmi
>[   25.116844] CPU: 100 PID: 2318 Comm: systemd-udevd Tainted: G        W          6.2.0-rc7-next-20230209+ #4
>[   25.126576] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
>[   25.134665] RIP: 0010:devl_param_driverinit_value_get+0xe5/0x1f0
>[   25.140676] Code: 00 5b b8 ea ff ff ff 41 5c 41 5d 5d e9 58 cd 08 00 48 8d bf 28 02 00 00 be ff ff ff ff e8 03 2a 07 00 85 c0 0f 85 43 ff ff ff <0f> 0b 49 8b 84 24 18 01 00 00 48 83 78 18 00 0f 85 41 ff ff ff 0f
>[   25.159421] RSP: 0018:ffffc217dfff7a28 EFLAGS: 00010246
>[   25.164646] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000000
>[   25.171779] RDX: 0000000000000000 RSI: ffff9d745c680228 RDI: ffff9d835f588d50
>[   25.178910] RBP: ffffc217dfff7a40 R08: 0000000000000000 R09: ffff9d835e860400
>[   25.186045] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9d745c680000
>[   25.193178] R13: ffffc217dfff7a50 R14: 0000000000000001 R15: 0000000000000002
>[   25.200310] FS:  00007f03c4b0a880(0000) GS:ffff9d92b8c00000(0000) knlGS:0000000000000000
>[   25.208395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[   25.214141] CR2: 00007f03c520d52c CR3: 000080109f420000 CR4: 0000000000350ee0
>[   25.221275] Call Trace:
>[   25.223726]  <TASK>
>[   25.225831]  mlx5_is_roce_on+0x3a/0xb0 [mlx5_core]
>[   25.230678]  ? __kmalloc+0x53/0x1b0
>[   25.234172]  mlx5r_probe+0x149/0x170 [mlx5_ib]
>[   25.238641]  ? __pfx_mlx5r_probe+0x10/0x10 [mlx5_ib]
>[   25.243624]  auxiliary_bus_probe+0x45/0xa0
>[   25.247724]  really_probe+0x17b/0x3e0
>[   25.251393]  __driver_probe_device+0x7e/0x180
>[   25.255761]  driver_probe_device+0x23/0x80
>[   25.259868]  __driver_attach+0xcb/0x1a0
>[   25.263707]  ? __pfx___driver_attach+0x10/0x10
>[   25.268159]  bus_for_each_dev+0x89/0xd0
>[   25.272001]  driver_attach+0x22/0x30
>[   25.275577]  bus_add_driver+0x1b9/0x240
>[   25.279421]  driver_register+0x66/0x130
>[   25.283264]  __auxiliary_driver_register+0x73/0xe0
>[   25.288062]  mlx5_ib_init+0xda/0x110 [mlx5_ib]
>[   25.292519]  ? __pfx_init_module+0x10/0x10 [mlx5_ib]
>[   25.297496]  do_one_initcall+0x7a/0x2b0
>[   25.301337]  ? kmalloc_trace+0x2e/0xe0
>[   25.305088]  do_init_module+0x6a/0x260
>[   25.308841]  load_module+0x1e90/0x2050
>[   25.312595]  ? ima_post_read_file+0xd6/0xf0
>[   25.316797]  __do_sys_finit_module+0xc8/0x140
>[   25.321155]  ? __do_sys_finit_module+0xc8/0x140
>[   25.325696]  __x64_sys_finit_module+0x1e/0x30
>[   25.330057]  do_syscall_64+0x3f/0x90
>[   25.333635]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>[   25.338687] RIP: 0033:0x7f03c513673d
>[   25.342266] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 23 37 0d 00 f7 d8 64 89 01 48
>[   25.361015] RSP: 002b:00007ffd0c1665f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
>[   25.368579] RAX: ffffffffffffffda RBX: 0000556e1aec4d30 RCX: 00007f03c513673d
>[   25.375713] RDX: 0000000000000000 RSI: 00007f03c5016ded RDI: 000000000000000e
>[   25.382843] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000556e1ae664e8
>[   25.389976] R10: 000000000000000e R11: 0000000000000246 R12: 00007f03c5016ded
>[   25.397109] R13: 0000000000000000 R14: 0000556e1aeee320 R15: 0000556e1aec4d30
>[   25.404249]  </TASK>
>[   25.406437] ---[ end trace 0000000000000000 ]---
>
>Did I do the merge wrong, or is the problem still there?
>
>Thanks,
>
>Kim
