Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30FB6A509B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 02:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjB1BXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 20:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB1BXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 20:23:03 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Feb 2023 17:23:01 PST
Received: from ma-mailsvcp-mx-lapp02.apple.com (ma-mailsvcp-mx-lapp02.apple.com [17.32.222.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CF75B90
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 17:23:00 -0800 (PST)
Received: from rn-mailsvcp-mta-lapp01.rno.apple.com
 (rn-mailsvcp-mta-lapp01.rno.apple.com [10.225.203.149])
 by ma-mailsvcp-mx-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.21.20230112 64bit (built Jan 12
 2023)) with ESMTPS id <0RQR00RI7L29ER30@ma-mailsvcp-mx-lapp02.apple.com> for
 netdev@vger.kernel.org; Mon, 27 Feb 2023 16:22:58 -0800 (PST)
X-Proofpoint-ORIG-GUID: 15ocCDIBRd_MlfakUEL0TmuOR3_Ov7tW
X-Proofpoint-GUID: 15ocCDIBRd_MlfakUEL0TmuOR3_Ov7tW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.562,18.0.930
 definitions=2023-02-27_18:2023-02-27,2023-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=interactive_user_notspam
 policy=interactive_user score=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302280000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com;
 h=content-type : mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=JcRNgRl4/ZUUH1KRwnsH72rjHu1nGSnaJQamXExgt+8=;
 b=UYZYDGJIcX5ajnzdBQYnYuCk51J2wB0crLGn7p0QyTn1H0VlbuZj5yNfHM777ogZ8qd+
 UmowK5S3TLd1N7/0R9/u3mCvDsfQFLjh0VJmhJD34pCUeMsCrqcgYW3n/RCjPoCoN0rR
 4FH++zc7hANr1bxAcOK9+GIoxaQikTKr9+4htWobl5TN9ObkVVanlkJ0w/4EO4WcoEW/
 Wt52arK2QDE01OFwlSm0cKqS32E7o4GAc/uzMtQIXe7USNltsUDKKQkUpcs6wHI72yny
 XIdcmRxYI/07MvlfnFRCaAw9m8Lsi+2eG1t7l7pyL/q90Z3bzSd4AhoT83TD3Uq2zvbg sQ==
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.21.20230112 64bit (built Jan 12
 2023)) with ESMTPS id <0RQR00284L27V4B0@rn-mailsvcp-mta-lapp01.rno.apple.com>;
 Mon, 27 Feb 2023 16:22:57 -0800 (PST)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.20.20220923 64bit (built Sep 23
 2022)) id <0RQR00700KQWRD00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Mon,
 27 Feb 2023 16:22:55 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 855586c8d5f7d663fc00a15054a9e46c
X-Va-E-CD: 27abb18f3b73f8a15ada62376b64770a
X-Va-R-CD: f77aa1b6adb3dcd53d518dbb8cb27760
X-Va-ID: 5d9455ce-7d35-474e-b44a-deac8b5173d9
X-Va-CD: 0
X-V-A:  
X-V-T-CD: 855586c8d5f7d663fc00a15054a9e46c
X-V-E-CD: 27abb18f3b73f8a15ada62376b64770a
X-V-R-CD: f77aa1b6adb3dcd53d518dbb8cb27760
X-V-ID: f54a1b32-4068-4b5a-8224-e9c4b24323c3
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.562,18.0.930
 definitions=2023-02-27_18:2023-02-27,2023-02-27 signatures=0
Received: from smtpclient.apple (unknown [17.192.155.178])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.20.20220923 64bit (built Sep 23
 2022))
 with ESMTPSA id <0RQR00R0OL27MR00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Mon,
 27 Feb 2023 16:22:55 -0800 (PST)
Content-type: text/plain; charset=us-ascii
MIME-version: 1.0 (Mac OS X Mail 16.0 \(3731.500.161\))
Subject: Re: [PATCH net] net: avoid skb end_offset change in
 __skb_unclone_keeptruesize()
From:   Christoph Paasch <cpaasch@apple.com>
In-reply-to: <20230227141706.447954-1-edumazet@google.com>
Date:   Mon, 27 Feb 2023 16:22:45 -0800
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-transfer-encoding: quoted-printable
Message-id: <9F1E9FC3-FB28-4FBE-90BB-C00C88FFEBF6@apple.com>
References: <20230227141706.447954-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.161)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 27, 2023, at 6:17 AM, Eric Dumazet <edumazet@google.com> wrote:
>=20
> Once initial skb->head has been allocated from skb_small_head_cache,
> we need to make sure to use the same strategy whenever skb->head
> has to be re-allocated, as found by syzbot [1]
>=20
> This means kmalloc_reserve() can not fallback from using
> skb_small_head_cache to generic (power-of-two) kmem caches.
>=20
> It seems that we probably want to rework things in the future,
> to partially revert following patch, because we no longer use
> ksize() for skb allocated in TX path.
>=20
> 2b88cba55883 ("net: preserve skb_end_offset() in =
skb_unclone_keeptruesize()")
>=20
> Ideally, TCP stack should never put payload in skb->head,
> this effort has to be completed.
>=20
> In the mean time, add a sanity check.
>=20
> [1]
> BUG: KASAN: invalid-free in slab_free mm/slub.c:3787 [inline]
> BUG: KASAN: invalid-free in kmem_cache_free+0xee/0x5c0 mm/slub.c:3809
> Free of addr ffff88806cdee800 by task syz-executor239/5189
>=20
> CPU: 0 PID: 5189 Comm: syz-executor239 Not tainted =
6.2.0-rc8-syzkaller-02400-gd1fabc68f8e0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 01/21/2023
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:306 [inline]
> print_report+0x15e/0x45d mm/kasan/report.c:417
> kasan_report_invalid_free+0x9b/0x1b0 mm/kasan/report.c:482
> ____kasan_slab_free+0x1a5/0x1c0 mm/kasan/common.c:216
> kasan_slab_free include/linux/kasan.h:177 [inline]
> slab_free_hook mm/slub.c:1781 [inline]
> slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
> slab_free mm/slub.c:3787 [inline]
> kmem_cache_free+0xee/0x5c0 mm/slub.c:3809
> skb_kfree_head net/core/skbuff.c:857 [inline]
> skb_kfree_head net/core/skbuff.c:853 [inline]
> skb_free_head+0x16f/0x1a0 net/core/skbuff.c:872
> skb_release_data+0x57a/0x820 net/core/skbuff.c:901
> skb_release_all net/core/skbuff.c:966 [inline]
> __kfree_skb+0x4f/0x70 net/core/skbuff.c:980
> tcp_wmem_free_skb include/net/tcp.h:302 [inline]
> tcp_rtx_queue_purge net/ipv4/tcp.c:3061 [inline]
> tcp_write_queue_purge+0x617/0xcf0 net/ipv4/tcp.c:3074
> tcp_v4_destroy_sock+0x125/0x810 net/ipv4/tcp_ipv4.c:2302
> inet_csk_destroy_sock+0x19a/0x440 net/ipv4/inet_connection_sock.c:1195
> __tcp_close+0xb96/0xf50 net/ipv4/tcp.c:3021
> tcp_close+0x2d/0xc0 net/ipv4/tcp.c:3033
> inet_release+0x132/0x270 net/ipv4/af_inet.c:426
> __sock_release+0xcd/0x280 net/socket.c:651
> sock_close+0x1c/0x20 net/socket.c:1393
> __fput+0x27c/0xa90 fs/file_table.c:320
> task_work_run+0x16f/0x270 kernel/task_work.c:179
> resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
> exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
> exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
> __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f2511f546c3
> Code: c7 c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f =
1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d =
00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
> RSP: 002b:00007ffef0103d48 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f2511f546c3
> RDX: 0000000000000978 RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000003434
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffef0103d6c
> R13: 00007ffef0103d80 R14: 00007ffef0103dc0 R15: 0000000000000003
> </TASK>
>=20
> Allocated by task 5189:
> kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> ____kasan_kmalloc mm/kasan/common.c:374 [inline]
> ____kasan_kmalloc mm/kasan/common.c:333 [inline]
> __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:383
> kasan_kmalloc include/linux/kasan.h:211 [inline]
> __do_kmalloc_node mm/slab_common.c:968 [inline]
> __kmalloc_node_track_caller+0x5b/0xc0 mm/slab_common.c:988
> kmalloc_reserve+0xf1/0x230 net/core/skbuff.c:539
> pskb_expand_head+0x237/0x1160 net/core/skbuff.c:1995
> __skb_unclone_keeptruesize+0x93/0x220 net/core/skbuff.c:2094
> skb_unclone_keeptruesize include/linux/skbuff.h:1910 [inline]
> skb_prepare_for_shift net/core/skbuff.c:3804 [inline]
> skb_shift+0xef8/0x1e20 net/core/skbuff.c:3877
> tcp_skb_shift net/ipv4/tcp_input.c:1538 [inline]
> tcp_shift_skb_data net/ipv4/tcp_input.c:1646 [inline]
> tcp_sacktag_walk+0x93b/0x18a0 net/ipv4/tcp_input.c:1713
> tcp_sacktag_write_queue+0x1599/0x31d0 net/ipv4/tcp_input.c:1974
> tcp_ack+0x2e9f/0x5a10 net/ipv4/tcp_input.c:3847
> tcp_rcv_established+0x667/0x2230 net/ipv4/tcp_input.c:6006
> tcp_v4_do_rcv+0x670/0x9b0 net/ipv4/tcp_ipv4.c:1721
> sk_backlog_rcv include/net/sock.h:1113 [inline]
> __release_sock+0x133/0x3b0 net/core/sock.c:2921
> release_sock+0x58/0x1b0 net/core/sock.c:3488
> tcp_sendmsg+0x3a/0x50 net/ipv4/tcp.c:1485
> inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:825
> sock_sendmsg_nosec net/socket.c:722 [inline]
> sock_sendmsg+0xde/0x190 net/socket.c:745
> sock_write_iter+0x295/0x3d0 net/socket.c:1136
> call_write_iter include/linux/fs.h:2189 [inline]
> new_sync_write fs/read_write.c:491 [inline]
> vfs_write+0x9ed/0xdd0 fs/read_write.c:584
> ksys_write+0x1ec/0x250 fs/read_write.c:637
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>=20
> The buggy address belongs to the object at ffff88806cdee800
> which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 0 bytes inside of
> 1024-byte region [ffff88806cdee800, ffff88806cdeec00)
>=20
> The buggy address belongs to the physical page:
> page:ffffea0001b37a00 refcount:1 mapcount:0 mapping:0000000000000000 =
index:0x0 pfn:0x6cde8
> head:ffffea0001b37a00 order:3 compound_mapcount:0 subpages_mapcount:0 =
compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> raw: 00fff00000010200 ffff888012441dc0 dead000000000122 =
0000000000000000
> raw: 0000000000000000 0000000000100010 00000001ffffffff =
0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask =
0x1f2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC=
|__GFP_MEMALLOC|__GFP_HARDWALL), pid 75, tgid 75 (kworker/u4:4), ts =
96369578780, free_ts 26734162530
> prep_new_page mm/page_alloc.c:2531 [inline]
> get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
> __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
> alloc_pages+0x1aa/0x270 mm/mempolicy.c:2287
> alloc_slab_page mm/slub.c:1851 [inline]
> allocate_slab+0x25f/0x350 mm/slub.c:1998
> new_slab mm/slub.c:2051 [inline]
> ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
> __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
> __slab_alloc_node mm/slub.c:3345 [inline]
> slab_alloc_node mm/slub.c:3442 [inline]
> __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
> __do_kmalloc_node mm/slab_common.c:967 [inline]
> __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:988
> kmalloc_reserve+0xf1/0x230 net/core/skbuff.c:539
> __alloc_skb+0x129/0x330 net/core/skbuff.c:608
> __netdev_alloc_skb+0x74/0x410 net/core/skbuff.c:672
> __netdev_alloc_skb_ip_align include/linux/skbuff.h:3203 [inline]
> netdev_alloc_skb_ip_align include/linux/skbuff.h:3213 [inline]
> batadv_iv_ogm_aggregate_new+0x106/0x4e0 =
net/batman-adv/bat_iv_ogm.c:558
> batadv_iv_ogm_queue_add net/batman-adv/bat_iv_ogm.c:670 [inline]
> batadv_iv_ogm_schedule_buff+0xe6b/0x1450 =
net/batman-adv/bat_iv_ogm.c:849
> batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:868 [inline]
> batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:861 [inline]
> batadv_iv_send_outstanding_bat_ogm_packet+0x744/0x910 =
net/batman-adv/bat_iv_ogm.c:1712
> process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
> worker_thread+0x669/0x1090 kernel/workqueue.c:2436
> page last free stack trace:
> reset_page_owner include/linux/page_owner.h:24 [inline]
> free_pages_prepare mm/page_alloc.c:1446 [inline]
> free_pcp_prepare+0x66a/0xc20 mm/page_alloc.c:1496
> free_unref_page_prepare mm/page_alloc.c:3369 [inline]
> free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
> free_contig_range+0xb5/0x180 mm/page_alloc.c:9488
> destroy_args+0xa8/0x64c mm/debug_vm_pgtable.c:998
> debug_vm_pgtable+0x28de/0x296f mm/debug_vm_pgtable.c:1318
> do_one_initcall+0x141/0x790 init/main.c:1306
> do_initcall_level init/main.c:1379 [inline]
> do_initcalls init/main.c:1395 [inline]
> do_basic_setup init/main.c:1414 [inline]
> kernel_init_freeable+0x6f9/0x782 init/main.c:1634
> kernel_init+0x1e/0x1d0 init/main.c:1522
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>=20
> Memory state around the buggy address:
> ffff88806cdee700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88806cdee780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff88806cdee800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ^
> ffff88806cdee880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>=20
> Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small =
skb->head")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> net/core/skbuff.c | 31 +++++++++++++++++++++++--------
> 1 file changed, 23 insertions(+), 8 deletions(-)

FWIW - I started hitting similar issues in my syzkaller instances and =
can confirm that the patch fixes it.

Tested-by: Christoph Paasch <cpaasch@apple.com>


Christoph


