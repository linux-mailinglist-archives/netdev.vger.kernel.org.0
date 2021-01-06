Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769682EC6A7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbhAFXQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbhAFXQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:16:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1CFC061757
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:15:27 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id t16so7193493ejf.13
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=EbVf7v1YnLvmPMtYJarY+D0DTFGnkRcSKHX6D4wWDlc=;
        b=Bk50huFIQaQN24lpgvhos9qSSzWqJNbxhmEhvNPMZRXLJai3FaNQSmccwYLLH5ECkq
         lmaVhZXKGSkdk07zFQWIaaA/RwvmoTMQmhEJROa4GOFkkz8v3og5JhOYd7/wmLBNYre6
         6m1WhvK4Ok9a8jKhpFRKRNe5yKD4F/yddY8VtFx0Sdkr2UbWPebA5lGoMbQx7bAKDLr5
         At3YziZ4i7c9ZvPWJW9JjjH8x4mljb52P3Qqy4L/QYXDP67g0Lv5pbz9YP5MaPJl073H
         rF8J5YFQ7NmE8sZs9owzXd94aarHxLyDZMPGYQ9FDd2nuAeCPg5Gog8hM3U5RcsNMU4M
         y/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=EbVf7v1YnLvmPMtYJarY+D0DTFGnkRcSKHX6D4wWDlc=;
        b=fpIeVV4dDzJfyjbW25VyMo3mG15mRMO8mOr7zHbJrEt3hgOn5XFqTaR9Kc/aFVrAPm
         DQlRDTM7+0rrjnDxgKkhvXUsSlm/F+aE3psU3STL05jlnlz/XMIDRll3ylsYHqksGlXY
         FV7vm/fcbl/nsxAOZvvUR9YLyH8PM4Ho8N1RK8AxEv3OK37MunLiu0zkROZZn1yYndtt
         GVRQn0cnc0NGcJ9HBplP7p0wbd9HKInhk6WMCDsnehb+nBTjQ+H9VXxXW4NrphPmlfxh
         j7mBgI8JpEzStTa6Lys5buoCAhzWb9R9kpurIuZcWdvTPH1NS8RHDBt2FC4jMLGbDC61
         D9nA==
X-Gm-Message-State: AOAM531qLOdt8cQBlihMN+6gR1X05uhJQbOD+niT20mt/vR34WIbSYlZ
        b77CXzJy7vJMrSobi8oZ/Y2D8vgNgy6yEw==
X-Google-Smtp-Source: ABdhPJxu/Q1QuoiQftaZglGxShksLpq0PvvNxP12fTVYMPV1pbaDwKCYasVhEpwvmFEcCdk5fBAJeg==
X-Received: by 2002:a17:906:4fcd:: with SMTP id i13mr4310494ejw.455.1609974925635;
        Wed, 06 Jan 2021 15:15:25 -0800 (PST)
Received: from [192.168.1.2] (ip4-83-240-21-69.cust.nbox.cz. [83.240.21.69])
        by smtp.gmail.com with ESMTPSA id 35sm1977087ede.0.2021.01.06.15.15.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:15:25 -0800 (PST)
Message-ID: <ecd964430ff124469ba48e289cf2e7404fcdc068.camel@gmail.com>
Subject: Kernel panic on shutdown (qede+bond+bridge) - KASAN: use-after-free
 in netif_skb_features+0x90a/0x9b0
From:   Igor Raits <igor.raits@gmail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Thu, 07 Jan 2021 00:15:24 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hello,

I've been trying out the latest CentOS 8 Stream kernel and found that I
get kernel panic (https://bugzilla.redhat.com/show_bug.cgi?id=1913481)
when trying to reboot the server. With debug kernel I've got following:

[  531.818434]
==================================================================
[  531.818435] BUG: KASAN: use-after-free in
netif_skb_features+0x90a/0x9b0
[  531.818436] Read of size 8 at addr ffff893c74d54b50 by task systemd-
shutdow/1
[  531.818436]                            
[  531.818437] CPU: 20 PID: 1 Comm: systemd-shutdow Tainted: G        W
I      --------- -  - 4.18.0-259.el8.x86_64+debug #1
[  531.818438] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
Gen10, BIOS U30 07/16/2020
[  531.818438] Call Trace:                                            
[  531.818438]  dump_stack+0x8e/0xd0                                  
[  531.818439]  print_address_description.constprop.3+0x1f/0x300
[  531.818439]  __kasan_report.cold.7+0x76/0xbf                    
[  531.818440]  ? netif_skb_features+0x90a/0x9b0    
[  531.818440]  kasan_report+0xe/0x20                                 
[  531.818441]  netif_skb_features+0x90a/0x9b0        
[  531.818441]  ? unwind_get_return_address+0x56/0xa0                 
[  531.818442]  ? __skb_gso_segment+0x620/0x620                       
[  531.818442]  ? do_raw_spin_unlock+0x54/0x230              
[  531.818442]  netpoll_start_xmit+0x28/0x680
[  531.818443]  ? netdev_pick_tx+0x13b/0x310        
[  531.818443]  netpoll_send_skb+0x50f/0x760                          
[  531.818444]  ? save_stack+0x19/0x80                                
[  531.818444]  netpoll_start_xmit+0x335/0x680                        
[  531.818444]  netpoll_send_skb+0x50f/0x760                    
[  531.818445]  ? rcu_read_lock_sched_held+0xe0/0xe0                  
[  531.818445]  __br_forward+0x680/0x730 [bridge]                     
[  531.818446]  ? br_forward_finish+0x330/0x330 [bridge]              
[  531.818446]  ? br_flood+0x2ce/0x560 [bridge]  
[  531.818447]  br_dev_xmit+0x9db/0x1150 [bridge]
[  531.818447]  ? br_poll_controller+0x10/0x10 [bridge]
[  531.818448]  ? dev_loopback_xmit+0x120/0x550
[  531.818448]  ? __skb_gso_segment+0x620/0x620
[  531.818448]  ? memset+0x1f/0x40
[  531.818449]  netpoll_start_xmit+0x335/0x680
[  531.818449]  netpoll_send_skb+0x50f/0x760
[  531.818450]  write_msg+0x1e2/0x240 [netconsole]
[  531.818450]  console_unlock+0x602/0x9b0
[  531.818450]  vprintk_emit+0x158/0x490
[  531.818451]  printk+0x9f/0xc5
[  531.818451]  ? kmsg_dump_rewind_nolock+0xd9/0xd9
[  531.818452]  ? qede_free_fp_array+0x24c/0x3b0 [qede]
[  531.818452]  qede_unload+0x133e/0x1ae0 [qede]
[  531.818453]  ? lock_downgrade+0x740/0x740
[  531.818453]  ? qede_free_mem_fp+0xa00/0xa00 [qede]
[  531.818454]  ? lock_contended+0xcd0/0xcd0
[  531.818454]  ? __local_bh_enable_ip+0xb3/0x100
[  531.818455]  ? dev_reset_queue.constprop.16+0xa5/0xd0
[  531.818455]  ? trace_hardirqs_on+0x20/0x195
[  531.818455]  ? __local_bh_enable_ip+0xb3/0x100
[  531.818456]  ? dev_deactivate_many+0x6d1/0x9a0
[  531.818456]  ? __local_bh_enable_ip+0xb3/0x100
[  531.818457]  ? dev_deactivate_many+0x6d1/0x9a0
[  531.818457]  qede_close+0x1f/0xe0 [qede]
[  531.818457]  __dev_close_many+0x18e/0x2b0
[  531.818458]  ? netdev_lower_state_changed+0x110/0x110
[  531.818458]  dev_close_many+0x1e2/0x5b0
[  531.818459]  ? unregister_netdevice_notifier_dev_net+0x190/0x190
[  531.818459]  ? unregister_netdev+0xe/0x20
[  531.818460]  rollback_registered_many+0x365/0xfe0
[  531.818460]  ? lock_contended+0xcd0/0xcd0
[  531.818461]  ? netif_set_real_num_tx_queues+0x700/0x700
[  531.818461]  ? __mutex_lock+0xe03/0x13d0
[  531.818462]  ? lock_acquire+0x1a3/0x970
[  531.818462]  ? quarantine_put+0xa0/0x290
[  531.818462]  ? unregister_netdev+0xe/0x20
[  531.818463]  ? mutex_lock_io_nested+0x12a0/0x12a0
[  531.818463]  rollback_registered+0xd1/0x180
[  531.818464]  ? rollback_registered_many+0xfe0/0xfe0
[  531.818464]  ? rpm_callback+0x210/0x210
[  531.818464]  ? _raw_spin_unlock_irq+0x24/0x40
[  531.818465]  unregister_netdevice_queue+0x18b/0x250
[  531.818465]  unregister_netdev+0x18/0x20
[  531.818466]  __qede_remove+0x1e2/0x4c0 [qede]
[  531.818466]  pci_device_shutdown+0x76/0x120
[  531.818467]  device_shutdown+0x35f/0x690
[  531.818467]  ? __blocking_notifier_call_chain+0x80/0xc0
[  531.818467]  kernel_restart+0xe/0x30
[  531.818468]  __do_sys_reboot+0x298/0x2e0
[  531.818468]  ? kernel_power_off+0xa0/0xa0
[  531.818469]  ? security_file_free+0x3f/0x70
[  531.818469]  ? kmem_cache_free+0x2ac/0x360
[  531.818470]  ? __fget_light+0x55/0x1f0
[  531.818470]  ? do_writev+0xc1/0x220
[  531.818470]  ? vfs_writev+0x2d0/0x2d0
[  531.818471]  ? trace_hardirqs_on_thunk+0x1a/0x20
[  531.818471]  ? trace_hardirqs_on_caller+0x22/0x1a0
[  531.818472]  ? do_syscall_64+0x22/0x420
[  531.818472]  do_syscall_64+0xa5/0x420
[  531.818473]  entry_SYSCALL_64_after_hwframe+0x6a/0xdf
[  531.818473] RIP: 0033:0x7f108ffbb097
[  531.818474] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00
00 90 f3 0f 1e fa 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00 00 0f
05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 c1 7d 2c 00 f7 d8 64 89 02 b8
[  531.818475] RSP: 002b:00007ffedba60838 EFLAGS: 00000202 ORIG_RAX:
00000000000000a9
[  531.818476] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f108ffbb097
[  531.818476] RDX: 0000000001234567 RSI: 0000000028121969 RDI:
00000000fee1dead
[  531.818477] RBP: 00007ffedba608e0 R08: 0000000000000000 R09:
00007ffedba5fa57
[  531.818478] R10: 00007ffedba5fe00 R11: 0000000000000202 R12:
0000000000000000
[  531.818478] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000006
[  531.818478]
[  531.818479] Allocated by task 1:
[  531.818479]  save_stack+0x19/0x80
[  531.818480]  __kasan_kmalloc.constprop.10+0xc1/0xd0
[  531.818480]  kmem_cache_alloc_node+0xe5/0x380
[  531.818480]  __alloc_skb+0x97/0x530
[  531.818481]  netpoll_send_udp+0x19b/0x17c0
[  531.818481]  write_msg+0x1e2/0x240 [netconsole]
[  531.818482]  console_unlock+0x602/0x9b0
[  531.818482]  vprintk_emit+0x158/0x490
[  531.818482]  printk+0x9f/0xc5
[  531.818483]  qede_unload+0x133e/0x1ae0 [qede]
[  531.818483]  qede_close+0x1f/0xe0 [qede]
[  531.818484]  __dev_close_many+0x18e/0x2b0
[  531.818484]  dev_close_many+0x1e2/0x5b0
[  531.818485]  rollback_registered_many+0x365/0xfe0
[  531.818485]  rollback_registered+0xd1/0x180
[  531.818485]  unregister_netdevice_queue+0x18b/0x250
[  531.818486]  unregister_netdev+0x18/0x20
[  531.818486]  __qede_remove+0x1e2/0x4c0 [qede]
[  531.818487]  pci_device_shutdown+0x76/0x120
[  531.818487]  device_shutdown+0x35f/0x690
[  531.818488]  kernel_restart+0xe/0x30
[  531.818488]  __do_sys_reboot+0x298/0x2e0
[  531.818488]  do_syscall_64+0xa5/0x420
[  531.818489]  entry_SYSCALL_64_after_hwframe+0x6a/0xdf
[  531.818489]
[  531.818490] Freed by task 1:
[  531.818490]  save_stack+0x19/0x80
[  531.818490]  __kasan_slab_free+0x125/0x170
[  531.818491]  kmem_cache_free+0xcd/0x360
[  531.818491]  zap_completion_queue+0x22a/0x300
[  531.818492]  bond_poll_controller+0x214/0x3b0 [bonding]
[  531.818492]  netpoll_poll_dev+0x110/0x5b0
[  531.818492]  netpoll_send_skb+0x2f9/0x760
[  531.818493]  netpoll_start_xmit+0x335/0x680
[  531.818493]  netpoll_send_skb+0x50f/0x760
[  531.818494]  __br_forward+0x680/0x730 [bridge]
[  531.818494]  br_dev_xmit+0x9db/0x1150 [bridge]
[  531.818495]  netpoll_start_xmit+0x335/0x680
[  531.818495]  netpoll_send_skb+0x50f/0x760
[  531.818495]  write_msg+0x1e2/0x240 [netconsole]
[  531.818496]  console_unlock+0x602/0x9b0
[  531.818496]  vprintk_emit+0x158/0x490
[  531.818497]  printk+0x9f/0xc5
[  531.818497]  qede_unload+0x133e/0x1ae0 [qede]
[  531.818497]  qede_close+0x1f/0xe0 [qede]
[  531.818498]  __dev_close_many+0x18e/0x2b0
[  531.818498]  dev_close_many+0x1e2/0x5b0
[  531.818499]  rollback_registered_many+0x365/0xfe0
[  531.818499]  rollback_registered+0xd1/0x180
[  531.818499]  unregister_netdevice_queue+0x18b/0x250
[  531.818500]  unregister_netdev+0x18/0x20
[  531.818500]  __qede_remove+0x1e2/0x4c0 [qede]
[  531.818501]  pci_device_shutdown+0x76/0x120
[  531.818501]  device_shutdown+0x35f/0x690
[  531.818502]  kernel_restart+0xe/0x30
[  531.818502]  __do_sys_reboot+0x298/0x2e0
[  531.818502]  do_syscall_64+0xa5/0x420
[  531.818503]  entry_SYSCALL_64_after_hwframe+0x6a/0xdf
[  531.818503]
[  531.818504] The buggy address belongs to the object at
ffff893c74d54b40
[  531.818504]  which belongs to the cache skbuff_head_cache of size
256
[  531.818505] The buggy address is located 16 bytes inside of
[  531.818505]  256-byte region [ffff893c74d54b40, ffff893c74d54c40)
[  531.818506] The buggy address belongs to the page:
[  531.818506] page:ffffea02f1d35500 refcount:1 mapcount:0
mapping:ffff88c6abf6d100 index:0x0 compound_mapcount: 0
[  531.818507] flags: 0x57ffffc0008100(slab|head)
[  531.818508] raw: 0057ffffc0008100 dead000000000100 dead000000000200
ffff88c6abf6d100
[  531.818508] raw: 0000000000000000 0000000080330033 00000001ffffffff
0000000000000000
[  531.818509] page dumped because: kasan: bad access detected
[  531.818509]
[  531.818509] Memory state around the buggy address:
[  531.818510]  ffff893c74d54a00: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  531.818511]  ffff893c74d54a80: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  531.818511] >ffff893c74d54b00: fc fc fc fc fc fc fc fc fb fb fb fb
fb fb fb fb
[  531.818512]                                                  ^
[  531.818512]  ffff893c74d54b80: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  531.818513]  ffff893c74d54c00: fb fb fb fb fb fb fb fb fc fc fc fc
fc fc fc fc
[  531.818513]
==================================================================
[  532.636252] kasan: CONFIG_KASAN_INLINE enabled

I quickly checked the upstream kernel tree and could not find anything
related to this. Do you have any ideas other than trying the latest
kernel? Any other additional information I could provide?

Thanks!
- -- 
Igor Raits <igor.raits@gmail.com>
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEcwgJ58gsbV5f5dMcEV1auJxcHh4FAl/2RIwACgkQEV1auJxc
Hh5DDBAAryTjDd5rre0nD1f1CMccK+AdFYu1piSwRM8Mp/SMf4rJUdIr0fS3KiKq
TffflZ3IRM+W57wOLuCjpe6OxC2j+6CNR2zJW4Tfb2bOjzKSfeiGwyW5jc6J2qnz
WN1CnZX3Cb3CnUA6LXnouA1yciy/tYo4G63oc3DT0mwk5Ti9Lp8+9jKOvF4NEu4C
IHRD0VcmCPbhyPkA3ka//NoV3h+foeSQdJth+feOxpTlBLMD88i/qIVsHWRl+V+l
jD6+sv9vkS15oJRDYoiOZnwHDiW36ssJcq0wOwE7ZZ1W9Q377QXR+bYa4tlIEUpb
YRRfpNMREUeUgD3VAAYWtHKPnvb64k5KijL1M+Up5sNB7SiCbZhnXIJ4LFOLWSaE
JizbrqgaTflCSi3b/ZQr4jrcQiGJu0lWjuMOaC3srtQTyg3tNPB6Iy9taF992ySS
m3FdR7d8A3snPW8wXSTmzng+qpd+r1zcDUSWS8zcDrk7M3piQNy6lVAV+rDf9ycL
0fHzkaCYvfN+j2pnZFqpDN83IrqeA3bt4jCniGOS75af+JXJpL+PRCVPJLM14Dpq
j3r3QRkASrxhWNXkIZEwMeTV8ldtdgUV86QK3Z31SPCEY+J62lzeM7SwCZ3jaVZ3
u4tgNsPQkezVYw2HTGAlmu+Whsy73KBy5oFAmoZBjSwgSMg7lXo=
=uvWj
-----END PGP SIGNATURE-----

