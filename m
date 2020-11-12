Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BDB2B088D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgKLPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgKLPiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:38:51 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD7EC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 07:38:50 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id i19so8435738ejx.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 07:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Aw1RTDJwtnU0QAD5cESROFo1lH2Lb6BBlgHCMa384lY=;
        b=Xj6czx0oBBL6nqp8XH/gWRZ21IZ7IuDWA4s6l41icoVNK1idiekVmFtIAHm1Y4VBen
         5xp5aA/nCUJvI5G1EwwnPKmplbEkgCfs1LxlGS82AAvBFxr8po0RWj9Mt3cXbKrMFeF6
         HlQx7TaUV4+WvNOGsJdUvH30Tz9i0HEw5vAU+IZ7qZbjwxdbzj2nCUINyGbiMnYzuSMm
         X+68TzC02zTuCO8/NUaZETxGDLSSlh+1RfO3bL1mDllNOu9gA54PzcDAVdaRHC4S2Zeo
         QmsbtUfbGb6tkO+AwclRfHSEAuM67teTyqbV4Flc+kzp1ApHXHR1726Ic9hl0Kt8/8b+
         mWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Aw1RTDJwtnU0QAD5cESROFo1lH2Lb6BBlgHCMa384lY=;
        b=PYf52m3dVG19WPWb5f3ohKiuic+MSz2iYdwlandFRYpdo3p4eqFB8NZXr3BrOBy1ju
         KWfuwutls9NPjmkkXQNNrStOCMIR2zh2zcdN69bpZATAki4RCrFzOD5ilmEEkVVc+Wg4
         Mg0/wgs/ZXRlZqe3C6Pg/0EZUsnHBq2Jc9Ipsic9MMND86hhMkwELCtPjVR9wmYE+p5R
         fpNZgcNG7qpCEpQcwx5MP8aS17wX+k6mRVL/CBDxRg6OKTCbVzFaJ7BmDwCuUvGP5kZa
         TRSzRSGSQsioYDpW9S7Jszd5Aa3NTotUcCiNuquZAhhMy8b8GKHb1mTitaaEdZifMGe3
         BPXw==
X-Gm-Message-State: AOAM533hTOmHgj9XqtpaLh5Py/6ij3vTwtziz4dBI2LFfsSS3oncKPsC
        CDpJunySiZ7gG9NEue9Vqfz7e7ZyoyM=
X-Google-Smtp-Source: ABdhPJxo1reMCoAfU+zziWqQMHj32Tcmou9LhGEmNhA8zOZeAkwXv8cVA55Fw/Kt5+j2pT9GUrHsNw==
X-Received: by 2002:a17:906:b202:: with SMTP id p2mr30018097ejz.483.1605195528929;
        Thu, 12 Nov 2020 07:38:48 -0800 (PST)
Received: from [10.21.182.82] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id s12sm2329554ejy.25.2020.11.12.07.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 07:38:48 -0800 (PST)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>, tariqt@nvidia.com
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Subject: bug report: WARNING in bonding
Message-ID: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
Date:   Thu, 12 Nov 2020 17:38:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

In the past ~2-3 weeks, we started seeing the following WARNING and 
traces in our regression testing systems, almost every day.

Reproduction is not stable, and not isolated to a specific test, so it's 
hard to bisect.

Any idea what could this be?
Or what is the suspected offending patch?

We can provide any info / try stuff if needed.

Regards,
Tariq


  [12288.305076] WARNING: CPU: 4 PID: 701631 at 
drivers/net/bonding/bond_main.c:4310 bond_update_slave_arr+0x498/0×560 
[bonding]

  [12288.308167] Modules linked in: bonding nf_tables ipip tunnel4 
geneve ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel mlx4_en ptp 
pps_core mlx4_ib mlx4_core rdma_ucm ib_uverbs ib_ipoib ib_umad macvlan 
vxlan ip6_udp_tunnel udp_tunnel 8021q garp mrp openvswitch nsh rpcrdma 
ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core 
xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype 
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
br_netfilter overlay [last unloaded: nf_tables]

  [12288.318333] CPU: 4 PID: 701631 Comm: python3 Not tainted 
5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12288.320069] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12288.322005] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12288.323079] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12288.326199] RSP: 0018:ffff8881b13f7c48 EFLAGS: 00010202

  [12288.327152] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
0000000000000000

  [12288.328389] RDX: 00000000fffffffe RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12288.329676] RBP: ffff8881bb5a2000 R08: 0000000000000000 R09: 
0000000000000000

  [12288.330986] R10: 0000000000000000 R11: ffffffff8237e060 R12: 
0000000000000001

  [12288.332228] R13: 0000000000000000 R14: ffff8881bb5a2b40 R15: 
0000000000000000

  [12288.333505] FS:  00007f84faffd700(0000) GS:ffff8882f5c00000(0000) 
knlGS:0000000000000000

  [12288.334844] mlx4_en: eth2: Link Up

  [12288.334989] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

  [12288.336959] CR2: 00007f850e19ddb0 CR3: 00000001bc654004 CR4: 
0000000000370ea0

  [12288.338256] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000

  [12288.339607] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400

  [12288.340910] Call Trace:

  [12288.341451]  bond_enslave+0x1038/0×13e0 [bonding]

  [12288.342355]  ? __kernel_text_address+0xe/0×30

  [12288.343194]  ? unwind_get_return_address+0x1b/0×30

  [12288.344097]  ? sscanf+0x49/0×70

  [12288.344745]  bond_option_slaves_set+0xf3/0×1a0 [bonding]

  [12288.345773]  __bond_opt_set+0xe8/0×380 [bonding]

  [12288.346646]  __bond_opt_set_notify+0x27/0×80 [bonding]

  [12288.347606]  bond_opt_tryset_rtnl+0x51/0×90 [bonding]

  [12288.348553]  bonding_sysfs_store_option+0x4f/0×90 [bonding]

  [12288.349609]  kernfs_fop_write+0x114/0×1b0

  [12288.350385]  vfs_write+0xc1/0×1f0

  [12288.351058]  ksys_write+0xa7/0xe0

  [12288.351729]  do_syscall_64+0x2d/0×40

  [12288.352438]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

  [12288.353408] RIP: 0033:0×7f851b74456f

  [12288.354117] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 09 4b 
f9 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 
0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 3c 4b f9 ff 48

  [12288.357411] RSP: 002b:00007f84faffb310 EFLAGS: 00000293 ORIG_RAX: 
0000000000000001

  [12288.358834] RAX: ffffffffffffffda RBX: 00007f84faffd680 RCX: 
00007f851b74456f

  [12288.360134] RDX: 0000000000000006 RSI: 00007f84ec006670 RDI: 
0000000000000007

  [12288.361463] RBP: 0000000000000006 R08: 0000000000000000 R09: 
00007f851b631960

  [12288.362729] R10: 0000000000000002 R11: 0000000000000293 R12: 
00007f8504234400

  [12288.364000] R13: 0000000000000007 R14: 00007f84ec006670 R15: 
00007f85004c15e0

  [12288.365358] CPU: 4 PID: 701631 Comm: python3 Not tainted 
5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12288.367126] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12288.369127] Call Trace:

  [12288.369659]  dump_stack+0x77/0×97

  [12288.370321]  __warn+0x8c/0xf0

  [12288.370932]  ? bond_update_slave_arr+0x498/0×560 [bonding]

  [12288.371947]  report_bug+0xbb/0×130

  [12288.372621]  handle_bug+0x3f/0×70

  [12288.373276]  exc_invalid_op+0x13/0×60

  [12288.383632]  asm_exc_invalid_op+0x12/0×20

  [12288.384429] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12288.385526] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12288.388672] RSP: 0018:ffff8881b13f7c48 EFLAGS: 00010202

  [12288.389579] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
0000000000000000

  [12288.389725] mlx4_en: eth3: Link Down

  [12288.390776] RDX: 00000000fffffffe RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12288.390778] RBP: ffff8881bb5a2000 R08: 0000000000000000 R09: 
0000000000000000

  [12288.394137] R10: 0000000000000000 R11: ffffffff8237e060 R12: 
0000000000000001

  [12288.395318] R13: 0000000000000000 R14: ffff8881bb5a2b40 R15: 
0000000000000000

  [12288.396502]  ? bond_update_slave_arr+0x37/0×560 [bonding]

  [12288.397477]  bond_enslave+0x1038/0×13e0 [bonding]

  [12288.398371]  ? __kernel_text_address+0xe/0×30

  [12288.399200]  ? unwind_get_return_address+0x1b/0×30

  [12288.400092]  ? sscanf+0x49/0×70

  [12288.400747]  bond_option_slaves_set+0xf3/0×1a0 [bonding]

  [12288.401722]  __bond_opt_set+0xe8/0×380 [bonding]

  [12288.402608]  __bond_opt_set_notify+0x27/0×80 [bonding]

  [12288.403561]  bond_opt_tryset_rtnl+0x51/0×90 [bonding]

  [12288.404525]  bonding_sysfs_store_option+0x4f/0×90 [bonding]

  [12288.405538]  kernfs_fop_write+0x114/0×1b0

  [12288.406300]  vfs_write+0xc1/0×1f0

  [12288.406972]  ksys_write+0xa7/0xe0

  [12288.407640]  do_syscall_64+0x2d/0×40

  [12288.408339]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

  [12288.409272] RIP: 0033:0×7f851b74456f

  [12288.409977] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 09 4b 
f9 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 
0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 3c 4b f9 ff 48

  [12288.413250] RSP: 002b:00007f84faffb310 EFLAGS: 00000293 ORIG_RAX: 
0000000000000001

  [12288.414652] RAX: ffffffffffffffda RBX: 00007f84faffd680 RCX: 
00007f851b74456f

  [12288.415923] RDX: 0000000000000006 RSI: 00007f84ec006670 RDI: 
0000000000000007

  [12288.417202] RBP: 0000000000000006 R08: 0000000000000000 R09: 
00007f851b631960

  [12288.418477] R10: 0000000000000002 R11: 0000000000000293 R12: 
00007f8504234400

  [12288.419758] R13: 0000000000000007 R14: 00007f84ec006670 R15: 
00007f85004c15e0

  [12288.421029] irq event stamp: 0

  [12288.421654] hardirqs last  enabled at (0): [<0000000000000000>] 0×0

  [12288.422837] hardirqs last disabled at (0): [] copy_process+0x4c2/0×1c00

  [12288.424359] softirqs last  enabled at (0): [] copy_process+0x4c2/0×1c00

  [12288.425904] softirqs last disabled at (0): [<0000000000000000>] 0×0

  [12288.427075] -[ end trace 5c51515ebbf2daa8 ]—-

  [12288.427974] eth3bond13: (slave eth3): Enslaving as an active 
interface with a down link

  [12291.019456] mlx4_en: eth3: Link Up

  [12291.022221] -————-[ cut here ]——————

  [12291.025000] WARNING: CPU: 4 PID: 577432 at 
drivers/net/bonding/bond_main.c:4310 bond_update_slave_arr+0x498/0×560 
[bonding]

  [12291.028671] Modules linked in: bonding nf_tables ipip tunnel4 
geneve ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel mlx4_en ptp 
pps_core mlx4_ib mlx4_core rdma_ucm ib_uverbs ib_ipoib ib_umad macvlan 
vxlan ip6_udp_tunnel udp_tunnel 8021q garp mrp openvswitch nsh rpcrdma 
ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core 
xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype 
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
br_netfilter overlay [last unloaded: nf_tables]

  [12291.038684] CPU: 4 PID: 577432 Comm: kworker/4:0 Tainted: G 
W         5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12291.040625] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12291.042458] Workqueue: events linkwatch_event

  [12291.043269] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12291.044293] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12291.047286] RSP: 0018:ffff8881c1c6fd00 EFLAGS: 00010202

  [12291.048184] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
0000000000000001

  [12291.049363] RDX: 00000000fffffffe RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12291.050561] RBP: 0000000000000004 R08: 0000000000000000 R09: 
0000000000000000

  [12291.051758] R10: ffff888163495870 R11: 0000000000000000 R12: 
ffff88811a38fc00

  [12291.052953] R13: 0000000000000000 R14: ffff8881bb5a2000 R15: 
0000000000000000

  [12291.054148] FS:  0000000000000000(0000) GS:ffff8882f5c00000(0000) 
knlGS:0000000000000000

  [12291.055584] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

  [12291.056557] CR2: 000055b13935e010 CR3: 0000000002412003 CR4: 
0000000000370ea0

  [12291.057762] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000

  [12291.058987] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400

  [12291.060186] Call Trace:

  [12291.060699]  bond_netdev_event+0x1d1/0×3d0 [bonding]

  [12291.061562]  raw_notifier_call_chain+0x3e/0×50

  [12291.062357]  netdev_state_change+0x5a/0×90

  [12291.063191]  ? linkwatch_do_dev+0x3c/0×50

  [12291.063934]  linkwatch_do_dev+0x3c/0×50

  [12291.064613]  __linkwatch_run_queue+0x10f/0×1f0

  [12291.065407]  linkwatch_event+0x21/0×30

  [12291.066153]  process_one_work+0x27c/0×610

  [12291.066897]  ? process_one_work+0x610/0×610

  [12291.067652]  worker_thread+0x2d/0×3c0

  [12291.068332]  ? process_one_work+0x610/0×610

  [12291.069072]  kthread+0x128/0×140

  [12291.069681]  ? kthread_insert_work_sanity_check+0x60/0×60

  [12291.070615]  ret_from_fork+0x1f/0×30

  [12291.071293] CPU: 4 PID: 577432 Comm: kworker/4:0 Tainted: G 
W         5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12291.073130] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12291.075064] Workqueue: events linkwatch_event

  [12291.075844] Call Trace:

  [12291.076334]  dump_stack+0x77/0×97

  [12291.076947]  __warn+0x8c/0xf0

  [12291.077518]  ? bond_update_slave_arr+0x498/0×560 [bonding]

  [12291.078466]  report_bug+0xbb/0×130

  [12291.079118]  handle_bug+0x3f/0×70

  [12291.079746]  exc_invalid_op+0x13/0×60

  [12291.080423]  asm_exc_invalid_op+0x12/0×20

  [12291.081145] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12291.082162] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12291.085107] RSP: 0018:ffff8881c1c6fd00 EFLAGS: 00010202

  [12291.085991] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
0000000000000001

  [12291.087169] RDX: 00000000fffffffe RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12291.088361] RBP: 0000000000000004 R08: 0000000000000000 R09: 
0000000000000000

  [12291.089539] R10: ffff888163495870 R11: 0000000000000000 R12: 
ffff88811a38fc00

  [12291.090745] R13: 0000000000000000 R14: ffff8881bb5a2000 R15: 
0000000000000000

  [12291.091978]  bond_netdev_event+0x1d1/0×3d0 [bonding]

  [12291.092817]  raw_notifier_call_chain+0x3e/0×50

  [12291.093588]  netdev_state_change+0x5a/0×90

  [12291.094339]  ? linkwatch_do_dev+0x3c/0×50

  [12291.095094]  linkwatch_do_dev+0x3c/0×50

  [12291.095805]  __linkwatch_run_queue+0x10f/0×1f0

  [12291.096572]  linkwatch_event+0x21/0×30

  [12291.097269]  process_one_work+0x27c/0×610

  [12291.097996]  ? process_one_work+0x610/0×610

  [12291.098782]  worker_thread+0x2d/0×3c0

  [12291.099450]  ? process_one_work+0x610/0×610

  [12291.100212]  kthread+0x128/0×140

  [12291.100833]  ? kthread_insert_work_sanity_check+0x60/0×60

  [12291.101787]  ret_from_fork+0x1f/0×30

  [12291.102463] irq event stamp: 0

  [12291.103061] hardirqs last  enabled at (0): [<0000000000000000>] 0×0

  [12291.104143] hardirqs last disabled at (0): [] copy_process+0x4c2/0×1c00

  [12291.105547] softirqs last  enabled at (0): [] copy_process+0x4c2/0×1c00

  [12291.106979] softirqs last disabled at (0): [<0000000000000000>] 0×0

  [12291.108088] -[ end trace 5c51515ebbf2daa9 ]—-

  [12292.862376] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.862387] -————-[ cut here ]——————

  [12292.864501] WARNING: CPU: 5 PID: 701638 at 
drivers/net/bonding/bond_main.c:4310 bond_update_slave_arr+0x498/0×560 
[bonding]

  [12292.866324] Modules linked in: bonding nf_tables ipip tunnel4 
geneve ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel mlx4_en ptp 
pps_core mlx4_ib mlx4_core rdma_ucm ib_uverbs ib_ipoib ib_umad macvlan 
vxlan ip6_udp_tunnel udp_tunnel 8021q garp mrp openvswitch nsh rpcrdma 
ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core 
xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype 
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
br_netfilter overlay [last unloaded: nf_tables]

  [12292.873158] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.876996] CPU: 5 PID: 701638 Comm: ip Tainted: G        W 
5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12292.882361] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12292.884251] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12292.885141] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.885321] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12292.889803] RSP: 0018:ffff8881bb2eb4a0 EFLAGS: 00010202

  [12292.890778] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
0000000000000000

  [12292.891983] RDX: 00000000fffffffe RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12292.893149] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.893176] RBP: ffff8881bb5a2000 R08: 0000000000000000 R09: 
0000000000000000

  [12292.898267] R10: 0000000000000000 R11: 0000000000000148 R12: 
ffff8881bb5a2b40

  [12292.899478] R13: 0000000000000000 R14: ffff8881bb2ebba8 R15: 
0000000000000001

  [12292.900687] FS:  00007f802af94800(0000) GS:ffff8882f5c80000(0000) 
knlGS:0000000000000000

  [12292.902047] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

  [12292.903044] CR2: 00000000004d2780 CR3: 00000001c3242006 CR4: 
0000000000370ea0

  [12292.904313] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000

  [12292.905113] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.905501] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400

  [12292.909217] Call Trace:

  [12292.909732]  ? trace_hardirqs_on+0x33/0xd0

  [12292.910467]  bond_open+0x183/0×310 [bonding]

  [12292.911275]  __dev_open+0xed/0×180

  [12292.911932]  __dev_change_flags+0x174/0×1c0

  [12292.913138] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.922284]  dev_change_flags+0x23/0×60

  [12292.924414]  do_setlink+0x3af/0×1160

  [12292.925089]  ? lock_acquire+0x209/0×3b0

  [12292.925797]  ? lock_acquire+0x209/0×3b0

  [12292.926505]  ? lock_release+0x1d5/0×2a0

  [12292.927218]  ? __nla_validate_parse.part.7+0x57/0xac0

  [12292.928099]  ? is_bpf_text_address+0x86/0xf0

  [12292.928878]  ? kernel_text_address+0xb6/0xc0

  [12292.929041] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.929661]  ? __thaw_task+0x50/0×50

  [12292.931767]  __rtnl_newlink+0x53d/0×8d0

  [12292.932472]  ? lock_release+0x1d5/0×2a0

  [12292.933185]  ? lock_release+0x1d5/0×2a0

  [12292.933894]  ? lock_release+0x1d5/0×2a0

  [12292.934602]  ? trace_hardirqs_on+0x33/0xd0

  [12292.935347]  ? lock_acquire+0x209/0×3b0

  [12292.936056]  ? trace_hardirqs_on+0x33/0xd0

  [12292.936806]  ? lock_acquire+0x209/0×3b0

  [12292.937101] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.937526]  ? lock_acquire+0x209/0×3b0

  [12292.939752]  ? lock_release+0x1d5/0×2a0

  [12292.940462]  ? lock_acquire+0x209/0×3b0

  [12292.941187]  ? kmem_cache_alloc_trace+0x64e/0×890

  [12292.942018]  ? lock_acquire+0x209/0×3b0

  [12292.942743]  ? security_capable+0x32/0×50

  [12292.943481]  rtnl_newlink+0x47/0×70

  [12292.944146]  rtnetlink_rcv_msg+0x279/0×490

  [12292.944893]  ? lock_acquire+0x209/0×3b0

  [12292.945098] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.945609]  ? lock_release+0x1d5/0×2a0

  [12292.948412]  ? validate_linkmsg+0x370/0×370

  [12292.949201]  netlink_rcv_skb+0x4e/0×100

  [12292.949900]  netlink_unicast+0x1ac/0×270

  [12292.950641]  netlink_sendmsg+0x336/0×450

  [12292.951368]  sock_sendmsg+0x30/0×40

  [12292.952040]  ____sys_sendmsg+0x1dd/0×1f0

  [12292.952744]  ? copy_msghdr_from_user+0x5c/0×90

  [12292.953098] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.953537]  ? lock_acquire+0x209/0×3b0

  [12292.957067]  ___sys_sendmsg+0x87/0xd0

  [12292.957744]  ? lock_acquire+0x209/0×3b0

  [12292.958439]  ? lock_acquire+0x209/0×3b0

  [12292.959184]  ? lock_release+0x1d5/0×2a0

  [12292.959903]  ? lock_acquire+0x209/0×3b0

  [12292.960608]  ? lock_release+0x1d5/0×2a0

  [12292.961100] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.961301]  ? lock_acquire+0x209/0×3b0

  [12292.964795]  ? lock_release+0x1d5/0×2a0

  [12292.965506]  ? lock_acquire+0x209/0×3b0

  [12292.966217]  ? lock_release+0x1d5/0×2a0

  [12292.966945]  ? lock_release+0x1d5/0×2a0

  [12292.967695]  ? __sys_sendmsg+0x51/0×90

  [12292.968377]  __sys_sendmsg+0x51/0×90

  [12292.969056]  do_syscall_64+0x2d/0×40

  [12292.969115] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.969766]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

  [12292.969771] RIP: 0033:0×7f802b170e57

  [12292.972837] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 
0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 
0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10

  [12292.975853] RSP: 002b:00007ffe5d2f7218 EFLAGS: 00000246 ORIG_RAX: 
000000000000002e

  [12292.977101] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.977148] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007f802b170e57

  [12292.980651] RDX: 0000000000000000 RSI: 00007ffe5d2f7280 RDI: 
0000000000000003

  [12292.981819] RBP: 000000005f8f49a5 R08: 0000000000000001 R09: 
00007f802b231a40

  [12292.983026] R10: 0000000000405caf R11: 0000000000000246 R12: 
0000000000000001

  [12292.984223] R13: 00007ffe5d2f7920 R14: 00007ffe5d2f7d94 R15: 
0000000000488500

  [12292.985113] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.985411] CPU: 5 PID: 701638 Comm: ip Tainted: G        W 
5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12292.989976] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12292.991824] Call Trace:

  [12292.992340]  dump_stack+0x77/0×97

  [12292.992977]  __warn+0x8c/0xf0

  [12292.993109] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12292.993565]  ? bond_update_slave_arr+0x498/0×560 [bonding]

  [12292.993572]  report_bug+0xbb/0×130

  [12292.997995]  handle_bug+0x3f/0×70

  [12292.998634]  exc_invalid_op+0x13/0×60

  [12292.999326]  asm_exc_invalid_op+0x12/0×20

  [12293.000069] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12293.001108] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.001117] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12293.001121] RSP: 0018:ffff8881bb2eb4a0 EFLAGS: 00010202

  [12293.006637] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
0000000000000000

  [12293.007832] RDX: 00000000fffffffe RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12293.009013] RBP: ffff8881bb5a2000 R08: 0000000000000000 R09: 
0000000000000000

  [12293.009112] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.010226] R10: 0000000000000000 R11: 0000000000000148 R12: 
ffff8881bb5a2b40

  [12293.010230] R13: 0000000000000000 R14: ffff8881bb2ebba8 R15: 
0000000000000001

  [12293.014896]  ? trace_hardirqs_on+0x33/0xd0

  [12293.015634]  bond_open+0x183/0×310 [bonding]

  [12293.016400]  __dev_open+0xed/0×180

  [12293.017040]  __dev_change_flags+0x174/0×1c0

  [12293.017108] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.017792]  dev_change_flags+0x23/0×60

  [12293.020802]  do_setlink+0x3af/0×1160

  [12293.021491]  ? lock_acquire+0x209/0×3b0

  [12293.022193]  ? lock_acquire+0x209/0×3b0

  [12293.022897]  ? lock_release+0x1d5/0×2a0

  [12293.023598]  ? __nla_validate_parse.part.7+0x57/0xac0

  [12293.024486]  ? is_bpf_text_address+0x86/0xf0

  [12293.025111] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.025285]  ? kernel_text_address+0xb6/0xc0

  [12293.025293]  ? __thaw_task+0x50/0×50

  [12293.028247]  __rtnl_newlink+0x53d/0×8d0

  [12293.028944]  ? lock_release+0x1d5/0×2a0

  [12293.029657]  ? lock_release+0x1d5/0×2a0

  [12293.030356]  ? lock_release+0x1d5/0×2a0

  [12293.031084]  ? trace_hardirqs_on+0x33/0xd0

  [12293.031832]  ? lock_acquire+0x209/0×3b0

  [12293.032552]  ? trace_hardirqs_on+0x33/0xd0

  [12293.033102] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.033294]  ? lock_acquire+0x209/0×3b0

  [12293.033298]  ? lock_acquire+0x209/0×3b0

  [12293.037019]  ? lock_release+0x1d5/0×2a0

  [12293.037720]  ? lock_acquire+0x209/0×3b0

  [12293.038441]  ? kmem_cache_alloc_trace+0x64e/0×890

  [12293.039275]  ? lock_acquire+0x209/0×3b0

  [12293.039999]  ? security_capable+0x32/0×50

  [12293.040739]  rtnl_newlink+0x47/0×70

  [12293.041126] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.041407]  rtnetlink_rcv_msg+0x279/0×490

  [12293.041412]  ? lock_acquire+0x209/0×3b0

  [12293.045846]  ? lock_release+0x1d5/0×2a0

  [12293.046549]  ? validate_linkmsg+0x370/0×370

  [12293.047306]  netlink_rcv_skb+0x4e/0×100

  [12293.048013]  netlink_unicast+0x1ac/0×270

  [12293.048730]  netlink_sendmsg+0x336/0×450

  [12293.049108] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.049452]  sock_sendmsg+0x30/0×40

  [12293.053171]  ____sys_sendmsg+0x1dd/0×1f0

  [12293.053923]  ? copy_msghdr_from_user+0x5c/0×90

  [12293.054731]  ? lock_acquire+0x209/0×3b0

  [12293.055439]  ___sys_sendmsg+0x87/0xd0

  [12293.056122]  ? lock_acquire+0x209/0×3b0

  [12293.056839]  ? lock_acquire+0x209/0×3b0

  [12293.057108] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.057543]  ? lock_release+0x1d5/0×2a0

  [12293.057546]  ? lock_acquire+0x209/0×3b0

  [12293.060408]  ? lock_release+0x1d5/0×2a0

  [12293.061130]  ? lock_acquire+0x209/0×3b0

  [12293.061825]  ? lock_release+0x1d5/0×2a0

  [12293.062524]  ? lock_acquire+0x209/0×3b0

  [12293.063232]  ? lock_release+0x1d5/0×2a0

  [12293.063928]  ? lock_release+0x1d5/0×2a0

  [12293.064629]  ? __sys_sendmsg+0x51/0×90

  [12293.065110] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.065321]  __sys_sendmsg+0x51/0×90

  [12293.065325]  do_syscall_64+0x2d/0×40

  [12293.068968]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

  [12293.069850] RIP: 0033:0×7f802b170e57

  [12293.070513] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 
0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 
0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10

  [12293.073043] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.073512] RSP: 002b:00007ffe5d2f7218 EFLAGS: 00000246 ORIG_RAX: 
000000000000002e

  [12293.077604] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007f802b170e57

  [12293.078784] RDX: 0000000000000000 RSI: 00007ffe5d2f7280 RDI: 
0000000000000003

  [12293.079969] RBP: 000000005f8f49a5 R08: 0000000000000001 R09: 
00007f802b231a40

  [12293.081108] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.081156] R10: 0000000000405caf R11: 0000000000000246 R12: 
0000000000000001

  [12293.081161] R13: 00007ffe5d2f7920 R14: 00007ffe5d2f7d94 R15: 
0000000000488500

  [12293.086307] irq event stamp: 0

  [12293.086908] hardirqs last  enabled at (0): [<0000000000000000>] 0×0

  [12293.087972] hardirqs last disabled at (0): [] copy_process+0x4c2/0×1c00

  [12293.089097] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.089382] softirqs last  enabled at (0): [] copy_process+0x4c2/0×1c00

  [12293.092314] softirqs last disabled at (0): [<0000000000000000>] 0×0

  [12293.093395] -[ end trace 5c51515ebbf2daaa ]—-

  [12293.094387] 8021q: adding VLAN 0 to HW filter on device eth3bond13

  [12293.097064] eth3bond13: (slave eth3): link status up, enabling it 
in 0 ms

  [12293.113267] eth3bond13: (slave eth3): link status definitely up, 
56000 Mbps full duplex

  [12293.114709] -————-[ cut here ]——————

  [12293.115539] WARNING: CPU: 6 PID: 94250 at 
drivers/net/bonding/bond_main.c:4310 bond_update_slave_arr+0x498/0×560 
[bonding]

  [12293.117352] Modules linked in: bonding nf_tables ipip tunnel4 
geneve ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel mlx4_en ptp 
pps_core mlx4_ib mlx4_core rdma_ucm ib_uverbs ib_ipoib ib_umad macvlan 
vxlan ip6_udp_tunnel udp_tunnel 8021q garp mrp openvswitch nsh rpcrdma 
ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core 
xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype 
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
br_netfilter overlay [last unloaded: nf_tables]

  [12293.124571] CPU: 6 PID: 94250 Comm: kworker/u16:7 Tainted: G 
W         5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12293.126440] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12293.128327] Workqueue: eth3bond13 bond_mii_monitor [bonding]

  [12293.129326] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12293.130371] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12293.133450] RSP: 0018:ffff88813749bda8 EFLAGS: 00010202

  [12293.134373] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
ffff88811a38fc00

  [12293.135584] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12293.136786] RBP: ffff88813749be60 R08: 0000000000000000 R09: 
0000000000000000

  [12293.137998] R10: ffff88813749bde8 R11: ffff88813749bba8 R12: 
ffffffffa072b642

  [12293.139249] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000019

  [12293.140454] FS:  0000000000000000(0000) GS:ffff8882f5d00000(0000) 
knlGS:0000000000000000

  [12293.141878] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

  [12293.142874] CR2: 000055b13935e010 CR3: 0000000104440002 CR4: 
0000000000370ea0

  [12293.144079] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000

  [12293.145323] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400

  [12293.146532] Call Trace:

  [12293.147117]  bond_mii_monitor+0x574/0×900 [bonding]

  [12293.148023]  ? raw_spin_unlock_irq+0x24/0×30

  [12293.148811]  process_one_work+0x27c/0×610

  [12293.149574]  worker_thread+0x2d/0×3c0

  [12293.150310]  ? process_one_work+0x610/0×610

  [12293.151115]  kthread+0x128/0×140

  [12293.151793]  ? kthread_insert_work_sanity_check+0x60/0×60

  [12293.152745]  ret_from_fork+0x1f/0×30

  [12293.153436] CPU: 6 PID: 94250 Comm: kworker/u16:7 Tainted: G 
W         5.9.0_for_upstream_min_debug_2020_10_19_16_22 #1

  [12293.155350] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014

  [12293.157234] Workqueue: eth3bond13 bond_mii_monitor [bonding]

  [12293.158316] Call Trace:

  [12293.158876]  dumpstack+0x77/0×97

  [12293.159557]  __warn+0x8c/0xf0

  [12293.160145]  ? bond_update_slave_arr+0x498/0×560 [bonding]

  [12293.161108]  report_bug+0xbb/0×130

  [12293.161767]  handle_bug+0x3f/0×70

  [12293.162406]  exc_invalid_op+0x13/0×60

  [12293.163092]  asm_exc_invalid_op+0x12/0×20

  [12293.163818] RIP: 0010:bond_update_slave_arr+0x498/0×560 [bonding]

  [12293.164843] Code: 25 fc ff ff 48 89 fe 4c 89 fa 48 c7 c7 e0 2c 73 
a0 48 89 04 24 e8 48 7b f1 e0 45 8b 04 24 48 8b 3b 48 8b 04 24 e9 a1 fc 
ff ff <0f> 0b e9 a0 fb ff ff 44 0f b7 74 24 12 e9 0f fc ff ff 31 d2 8d 46

  [12293.167960] RSP: 0018:ffff88813749bda8 EFLAGS: 00010202

  [12293.168869] RAX: 0000000000000001 RBX: ffff8881bb5a2b40 RCX: 
ffff88811a38fc00

  [12293.170073] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 
ffff8881bb5a2b98

  [12293.171290] RBP: ffff88813749be60 R08: 0000000000000000 R09: 
0000000000000000

  [12293.172470] R10: ffff88813749bde8 R11: ffff88813749bba8 R12: 
ffffffffa072b642

  [12293.173673] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000019

  [12293.174886]  ? bond_update_slave_arr+0x37/0×560 [bonding]

  [12293.175857]  bond_mii_monitor+0x574/0×900 [bonding]

  [12293.176727]  ? raw_spin_unlock_irq+0x24/0×30

  [12293.177519]  process_one_work+0x27c/0×610

  [12293.178262]  worker_thread+0x2d/0×3c0

  [12293.178953]  ? process_one_work+0x610/0×610

  [12293.179719]  kthread+0x128/0×140

  [12293.180339]  ? kthread_insert_work_sanity_check+0x60/0×60

  [12293.181320]  ret_fromfork+0x1f/0×30

  [12293.182022] irq event stamp: 9226282

  [12293.182713] hardirqs last  enabled at (9226281): [] 
_raw_spin_unlock_irq+0x24/0×30

  [12293.184322] hardirqs last disabled at (9226282): [] 
__schedule+0x454/0×8d0

  [12293.185798] softirqs last  enabled at (9226244): [] 
tcp_sendmsg+0x31/0×40

  [12293.187320] softirqs last disabled at (9226242): [] 
release_sock+0x19/0xa0

  [12293.188754] -[ end trace 5c51515ebbf2daab ]—-

  [12293.189621] eth3bond13: active interface up!

  [12293.190415] IPv6: ADDRCONF: eth3bond13: link becomes ready
