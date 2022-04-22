Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE4950BD3E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354009AbiDVQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449758AbiDVQlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:41:10 -0400
X-Greylist: delayed 337 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 09:38:15 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C775F25C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:38:14 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 596A1232801
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 16:32:37 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C6C6BA006D;
        Fri, 22 Apr 2022 16:32:35 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7B9A1200097;
        Fri, 22 Apr 2022 16:32:35 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DD18713C2B0;
        Fri, 22 Apr 2022 09:32:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DD18713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1650645154;
        bh=5DHZdyMM5UTb92LDu2Xz85opGIjnjg9poNxq3m5d+78=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=bJKvkOc+3tPaW1qXg4dyZyq15QZfIUyLcgNEHBpvCRrsgIFCj8W57ElSavBmpsOxU
         72S/bDiHblQgECVOrVtWdKDYEZfZREZ5dFwVwFHu5gTLfTttk4lic2R2/V81iEs4Ko
         PnDzdjprs4duPFxxmIOVT1nipwjs6CCDWjE4nxf8=
Subject: Re: 5.10.4+ hang with 'rmmod nf_conntrack'
From:   Ben Greear <greearb@candelatech.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>
References: <41dbfc93-0d57-6d78-f6fa-529dd5e0685c@candelatech.com>
 <20210108061653.GB19605@breakpoint.cc>
 <0fa45356-7c63-bb01-19c8-9447cf2cad39@candelatech.com>
Organization: Candela Technologies
Message-ID: <cdddd527-c25d-c581-cea7-d1f13a0d9948@candelatech.com>
Date:   Fri, 22 Apr 2022 09:32:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0fa45356-7c63-bb01-19c8-9447cf2cad39@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1650645156-WA44SrTyj4v2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/21 5:07 AM, Ben Greear wrote:
> On 1/7/21 10:16 PM, Florian Westphal wrote:
>> Ben Greear <greearb@candelatech.com> wrote:
>>> I noticed my system has a hung process trying to 'rmmod nf_conntrack'.
>>>
>>> I've generally been doing the script that calls rmmod forever,
>>> but only extensively tested on 5.4 kernel and earlier.
>>>
>>> If anyone has any ideas, please let me know.  This is from 'sysrq t'.  I don't see
>>> any hung-task splats in dmesg.
>>
>> rmmod on conntrack loops forever until the active conntrack object count reaches 0.
>> (plus a walk of the conntrack table to evict/put all entries).

Hello Florian,

I keep hitting this bug in a particular test case in 5.17.4+, so I added some debug to
try to learn more.

My debugging patch looks like this:

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7552e1e9fd62..29724114caef 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2543,6 +2543,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
  {
         int busy;
         struct net *net;
+       unsigned long loops = 0;

         /*
          * This makes sure all current packets have passed through
@@ -2556,12 +2557,30 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
                 struct nf_conntrack_net *cnet = nf_ct_pernet(net);

                 nf_ct_iterate_cleanup(kill_all, net, 0, 0);
-               if (atomic_read(&cnet->count) != 0)
+               if (atomic_read(&cnet->count) != 0) {
+                       if (loops > 50010)
+                               pr_err("nf-conntrack-cleanup-net-list, loops: %ld  cnet-count: %d, expect-count: %d users4: %d users6: %d  users_bridge: %d\n",
+                                      loops, atomic_read(&cnet->count), cnet->expect_count,
+                                      cnet->users4, cnet->users6, cnet->users_bridge);
                         busy = 1;
+               }
         }
         if (busy) {
+               loops++;
+               if (loops > 50000) {
+                       msleep(500);
+               }
                 schedule();
-               goto i_see_dead_people;
+               if (loops > 50020) {
+                       /* This thing is wedged, going to require a reboot to recover, so attempt
+                        * to just ignore the bad count and see if system works OK.
+                        */
+                       WARN_ON_ONCE(1);
+                       pr_err("ERROR:  nf_conntrack_cleanup_net cannot make progress.  Ignoring stale reference count and will continue.\n");
+               }
+               else {
+                       goto i_see_dead_people;
+               }
         }

         list_for_each_entry(net, net_exit_list, exit_list) {


Do you (or anyone else), have some ideas for how to debug this further to help find where the reference
is leaked (or not released)?


[ 1486.101795] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50011  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1486.620464] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50012  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1487.141700] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50013  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1487.660248] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50014  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1488.180352] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50015  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1488.700485] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50016  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1489.220488] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50017  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1489.741310] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50018  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1490.260216] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50019  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1490.780219] nf_conntrack: nf-conntrack-cleanup-net-list, loops: 50020  cnet-count: 1, expect-count: 0 users4: 0 users6: 0  users_bridge: 0
[ 1491.299594] ------------[ cut here ]------------
[ 1491.299598] WARNING: CPU: 6 PID: 25447 at net/netfilter/nf_conntrack_core.c:2578 nf_conntrack_cleanup_net_list+0x105/0x210 [nf_conntrack]
[ 1491.299651] Modules linked in: nfnetlink nf_conntrack(-) nf_defrag_ipv6 nf_defrag_ipv4 bpfilter vrf 8021q garp mrp stp llc macvlan pktgen f71882fg 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio uvcvideo videobuf2_vmalloc snd_hda_intel videobuf2_memops snd_intel_dspcfg 
videobuf2_v4l2 videobuf2_common snd_hda_codec coretemp intel_rapl_msr intel_rapl_common iTCO_wdt ch341 cp210x ftdi_sio videodev snd_hda_core ee1004 snd_hwdep 
intel_pmc_bxt mc iTCO_vendor_support mt7915e mt76_connac_lib snd_seq mt76 snd_seq_device intel_wmi_thunderbolt snd_pcm intel_tcc_cooling mac80211 snd_timer 
x86_pkg_temp_thermal snd intel_powerclamp i2c_i801 soundcore i2c_smbus cfg80211 mei_wdt mei_hdcp mei_pxp intel_pch_thermal acpi_pad sch_fq_codel nfsd 
auth_rpcgss nfs_acl lockd grace sunrpc raid1 dm_raid raid456 libcrc32c async_raid6_recov async_memcpy async_pq async_xor async_tx raid6_pq i915 intel_gtt 
drm_kms_helper cec rc_core ttm igb i2c_algo_bit drm ixgbe mdio agpgart xhci_pci
[ 1491.299839]  hwmon i2c_core xhci_pci_renesas dca wmi video fuse [last unloaded: nf_conntrack_netlink]
[ 1491.299862] CPU: 6 PID: 25447 Comm: rmmod Tainted: G        W         5.17.4+ #30
[ 1491.299869] Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
[ 1491.299873] RIP: 0010:nf_conntrack_cleanup_net_list+0x105/0x210 [nf_conntrack]
[ 1491.299918] Code: 00 00 77 0a e8 6c 3b 05 e1 e9 30 ff ff ff bf f4 01 00 00 e8 ad d9 f3 df e8 58 3b 05 e1 49 81 fd 65 c3 00 00 0f 85 14 ff ff ff <0f> 0b 48 c7 
c7 c0 3c 36 a1 e8 d4 f1 fc e0 4c 89 e7 e8 05 ea 18 e0
[ 1491.299925] RSP: 0018:ffff888126fffd78 EFLAGS: 00010246
[ 1491.299931] RAX: 0000000000400100 RBX: ffff888126fffdd8 RCX: ffffffff823a27ba
[ 1491.299936] RDX: 0000000000000007 RSI: dffffc0000000000 RDI: ffff888145cb212c
[ 1491.299941] RBP: ffff8881179c8f00 R08: ffffed1028b96421 R09: ffffed1028b96421
[ 1491.299946] R10: ffff888145cb2107 R11: ffffed1028b96420 R12: ffff888126fffe08
[ 1491.299951] R13: 000000000000c365 R14: 0000000000000001 R15: ffff888134155500
[ 1491.299955] FS:  00007fcbb8644740(0000) GS:ffff88841e100000(0000) knlGS:0000000000000000
[ 1491.299961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1491.299965] CR2: 00000000090c6000 CR3: 00000001370bd003 CR4: 00000000003706e0
[ 1491.299970] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1491.299974] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1491.299978] Call Trace:
[ 1491.299982]  <TASK>
[ 1491.299987]  free_exit_list+0x77/0xc0
[ 1491.299996]  unregister_pernet_operations+0x130/0x1a0
[ 1491.300004]  ? free_exit_list+0xc0/0xc0
[ 1491.300011]  ? __mutex_unlock_slowpath.isra.21+0x230/0x230
[ 1491.300021]  unregister_pernet_subsys+0x18/0x30
[ 1491.300028]  nf_conntrack_standalone_fini+0x11/0x47f [nf_conntrack]
[ 1491.300076]  __x64_sys_delete_module+0x1f5/0x310
[ 1491.300086]  ? __ia32_sys_delete_module+0x310/0x310
[ 1491.300096]  do_syscall_64+0x34/0xb0
[ 1491.300104]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1491.300112] RIP: 0033:0x7fcbb876ca9b
[ 1491.300117] Code: 73 01 c3 48 8b 0d ed 33 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 
ff ff 73 01 c3 48 8b 0d bd 33 0c 00 f7 d8 64 89 01 48
[ 1491.300124] RSP: 002b:00007ffcbddd8928 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1491.300130] RAX: ffffffffffffffda RBX: 0000560cfea95820 RCX: 00007fcbb876ca9b
[ 1491.300135] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000560cfea95888
[ 1491.300140] RBP: 00007ffcbddd8988 R08: 0000000000000000 R09: 0000000000000000
[ 1491.300144] R10: 00007fcbb87e0ac0 R11: 0000000000000206 R12: 00007ffcbddd8b50
[ 1491.300148] R13: 00007ffcbdddabc5 R14: 0000560cfea952a0 R15: 0000560cfea95820
[ 1491.300157]  </TASK>
[ 1491.300159] ---[ end trace 0000000000000000 ]---
[ 1491.300163] nf_conntrack: ERROR:  nf_conntrack_cleanup_net cannot make progress.  Ignoring stale reference count and will continue.
[ 1491.437516] =============================================================================
[ 1491.444783] BUG nf_conntrack (Tainted: G        W        ): Objects remaining in nf_conntrack on __kmem_cache_shutdown()
[ 1491.454650] -----------------------------------------------------------------------------

[ 1491.461981] Slab 0x000000006b714627 objects=25 used=1 fp=0x0000000095de89c2 flags=0x5fff8000010200(slab|head|node=0|zone=2|lastcpupid=0x3fff)
[ 1491.473738] CPU: 4 PID: 25447 Comm: rmmod Tainted: G        W         5.17.4+ #30
[ 1491.473743] Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
[ 1491.473745] Call Trace:
[ 1491.473747]  <TASK>
[ 1491.473749]  dump_stack_lvl+0x47/0x5c
[ 1491.473758]  slab_err+0x8f/0xd0
[ 1491.473764]  ? _raw_read_lock_irqsave+0x10/0x50
[ 1491.473769]  ? _raw_read_lock+0x30/0x30
[ 1491.473773]  ? flush_all_cpus_locked+0xd5/0x120
[ 1491.473777]  __kmem_cache_shutdown+0x13f/0x2e0
[ 1491.473781]  ? kasan_quarantine_remove_cache+0xd1/0xe0
[ 1491.473787]  kmem_cache_destroy+0x4a/0x110
[ 1491.473793]  __x64_sys_delete_module+0x1f5/0x310
[ 1491.473800]  ? __ia32_sys_delete_module+0x310/0x310
[ 1491.473804]  do_syscall_64+0x34/0xb0
[ 1491.473809]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1491.473814] RIP: 0033:0x7fcbb876ca9b
[ 1491.473817] Code: 73 01 c3 48 8b 0d ed 33 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 
ff ff 73 01 c3 48 8b 0d bd 33 0c 00 f7 d8 64 89 01 48
[ 1491.473821] RSP: 002b:00007ffcbddd8928 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1491.473825] RAX: ffffffffffffffda RBX: 0000560cfea95820 RCX: 00007fcbb876ca9b
[ 1491.473828] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000560cfea95888
[ 1491.473830] RBP: 00007ffcbddd8988 R08: 0000000000000000 R09: 0000000000000000
[ 1491.473832] R10: 00007fcbb87e0ac0 R11: 0000000000000206 R12: 00007ffcbddd8b50
[ 1491.473834] R13: 00007ffcbdddabc5 R14: 0000560cfea952a0 R15: 0000560cfea95820
[ 1491.473838]  </TASK>
[ 1491.473840] Disabling lock debugging due to kernel taint
[ 1491.473843] Object 0x000000006989dcb9 @offset=5120
[ 1491.477761] ------------[ cut here ]------------
[ 1491.477763] kmem_cache_destroy nf_conntrack: Slab cache still has objects when called from __x64_sys_delete_module+0x1f5/0x310
[ 1491.477780] WARNING: CPU: 4 PID: 25447 at mm/slab_common.c:504 kmem_cache_destroy+0x108/0x110
[ 1491.477788] Modules linked in: nfnetlink nf_conntrack(-) nf_defrag_ipv6 nf_defrag_ipv4 bpfilter vrf 8021q garp mrp stp llc macvlan pktgen f71882fg 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio uvcvideo videobuf2_vmalloc snd_hda_intel videobuf2_memops snd_intel_dspcfg 
videobuf2_v4l2 videobuf2_common snd_hda_codec coretemp intel_rapl_msr intel_rapl_common iTCO_wdt ch341 cp210x ftdi_sio videodev snd_hda_core ee1004 snd_hwdep 
intel_pmc_bxt mc iTCO_vendor_support mt7915e mt76_connac_lib snd_seq mt76 snd_seq_device intel_wmi_thunderbolt snd_pcm intel_tcc_cooling mac80211 snd_timer 
x86_pkg_temp_thermal snd intel_powerclamp i2c_i801 soundcore i2c_smbus cfg80211 mei_wdt mei_hdcp mei_pxp intel_pch_thermal acpi_pad sch_fq_codel nfsd 
auth_rpcgss nfs_acl lockd grace sunrpc raid1 dm_raid raid456 libcrc32c async_raid6_recov async_memcpy async_pq async_xor async_tx raid6_pq i915 intel_gtt 
drm_kms_helper cec rc_core ttm igb i2c_algo_bit drm ixgbe mdio agpgart xhci_pci
[ 1491.477900]  hwmon i2c_core xhci_pci_renesas dca wmi video fuse [last unloaded: nf_conntrack_netlink]
[ 1491.477912] CPU: 4 PID: 25447 Comm: rmmod Tainted: G    B   W         5.17.4+ #30
[ 1491.477916] Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
[ 1491.477918] RIP: 0010:kmem_cache_destroy+0x108/0x110
[ 1491.477922] Code: dd 08 00 48 89 df e8 d7 dd 08 00 eb d3 c3 48 8b 53 60 48 8b 4c 24 10 48 c7 c6 c0 61 90 82 48 c7 c7 58 66 fc 82 e8 8a 8f ec 00 <0f> 0b eb b2 
0f 1f 40 00 55 53 48 83 ff 10 76 11 48 8b 74 24 10 48
[ 1491.477925] RSP: 0018:ffff888126fffe80 EFLAGS: 00010286
[ 1491.477928] RAX: 0000000000000000 RBX: ffff888109061e00 RCX: 0000000000000027
[ 1491.477931] RDX: 0000000000000027 RSI: dffffc0000000000 RDI: ffff88841e028428
[ 1491.477933] RBP: ffffffffa1381a00 R08: ffffed1083c05086 R09: ffffed1083c05086
[ 1491.477936] R10: ffff88841e02842b R11: ffffed1083c05085 R12: ffffffffa1381d08
[ 1491.477938] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1491.477940] FS:  00007fcbb8644740(0000) GS:ffff88841e000000(0000) knlGS:0000000000000000
[ 1491.477943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1491.477946] CR2: 00007efd5f2d4734 CR3: 00000001370bd003 CR4: 00000000003706e0
[ 1491.477949] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1491.477951] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1491.477953] Call Trace:
[ 1491.477955]  <TASK>
[ 1491.477957]  __x64_sys_delete_module+0x1f5/0x310
[ 1491.477961]  ? __ia32_sys_delete_module+0x310/0x310
[ 1491.477966]  do_syscall_64+0x34/0xb0
[ 1491.477971]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1491.477975] RIP: 0033:0x7fcbb876ca9b
[ 1491.477978] Code: 73 01 c3 48 8b 0d ed 33 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 
ff ff 73 01 c3 48 8b 0d bd 33 0c 00 f7 d8 64 89 01 48
[ 1491.477981] RSP: 002b:00007ffcbddd8928 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1491.477985] RAX: ffffffffffffffda RBX: 0000560cfea95820 RCX: 00007fcbb876ca9b
[ 1491.477987] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000560cfea95888
[ 1491.477989] RBP: 00007ffcbddd8988 R08: 0000000000000000 R09: 0000000000000000
[ 1491.477991] R10: 00007fcbb87e0ac0 R11: 0000000000000206 R12: 00007ffcbddd8b50
[ 1491.477994] R13: 00007ffcbdddabc5 R14: 0000560cfea952a0 R15: 0000560cfea95820
[ 1491.477997]  </TASK>
[ 1491.477999] ---[ end trace 0000000000000000 ]---


>>
>>> I'll see if it is reproducible and if so will try
>>> with lockdep enabled...
>>
>> No idea, there was a regression in 5.6, but that was fixed by the time
>> 5.7 was released.
>>
>> Can't reproduce hangs with a script that injects a few dummy entries
>> and then removes the module:
>>
>> added=0
>>
>> add_and_rmmod()
>> {
>>          while [ $added -lt 1000 ]; do
>>                  conntrack -I -s $(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%255+1)) \
>>                          -d $(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%255+1)) \
>>                           --protonum 6 --timeout $(((RANDOM%120) + 240)) --state ESTABLISHED --sport $RANDOM --dport $RANDOM 2> /dev/null || break
>>
>>                  added=$((added + 1))
>>                  if [ $((added % 1000)) -eq 0 ];then
>>                          echo $added
>>                  fi
>>          done
>>
>>          echo rmmod after adding $added entries
>>          conntrack -C
>>          rmmod nf_conntrack_netlink
>>          rmmod nf_conntrack
>> }
>>
>> add_and_rmmod
>>
>> I don't see how it would make a difference, but do you have any special conntrack features enabled
>> at run time, e.g. reliable netlink events? (If you don't know what I mean the answer is no).
> 
> Not that I know of, but I am using lots of VRF devices, each with their own routing table, as well
> as some wifi stations and AP netdevs.
> 
> I'll let you know if I can reproduce it again..
> 
> Thanks,
> Ben
> 
> 

