Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00523677739
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjAWJRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjAWJRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:17:00 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC9A1EFE0;
        Mon, 23 Jan 2023 01:16:58 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id h15so5383036ilh.4;
        Mon, 23 Jan 2023 01:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=85ijn7vYPCOE7OcuuEa7nG/7FhvAgHuIdbSA+ZZxQyo=;
        b=DzLRo2Dbso8NlEly7wAqKN9zLUeceO/rl+TeFr+KpnxuQmGjTI8A8d+sSUJqXw6J8n
         M3RfdZHeh/0mbC138zdAo6UiCBpbkrSOlCHuISN2pChFCgDlKD/g7tGoDgksH44pN/0Z
         gtQ22IWyLA0bIcI00K4IqqWJE6bFLM+jNQKDYzdy5++FwFe1JcERgyl3jxhM8o4zBvVa
         gNDWEuE1rj/9tC89HKg7S/PyP1QgGnHHtxXhTTpMWFhgk7c2ALGrGBXnUY+BDdUIBnBZ
         vCkR+fqfR7c05fRdtnI3vjHLdgKuULjmbCEhD13EVLr2GeRJhKPk7ze8gcyFTvfsnbvV
         +myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=85ijn7vYPCOE7OcuuEa7nG/7FhvAgHuIdbSA+ZZxQyo=;
        b=jPpzm0CUoHTQtJxuX2zCCQ9MUdJLRBhgJUYs7S8dBCxMCbl9pbJJ8sgVMYbnkIip6p
         l42anDi2HrEaahDsV4ytPihrVgSAHcgNvNHpwXk0JYXlpP6u7+1YgsiIskUM1Ew/DTFc
         c3PCBPNA2+WfW9mBgJnfX8flUjzDEx9jb56P8A/uYknN+9R7UDh2ppAEyxtk8gEM0LvH
         Dh51nHIRMOWxb2LmNdPZndzU7/mG5NOJ4qIEwu3opnpy5ozgm2Wo76MexJqlx+0tDrci
         RvJo/APM8IkiITizFEn2+onFeuR8wccH7QKqVWbpeOLO4ZOT8xiFoxKjfC7WFTDIy3/w
         d6uw==
X-Gm-Message-State: AFqh2kqKAf6IdwLVCUGThz1bWzLh1NnkH9fhYQGe3kgxUF5VHMumlBUS
        qsBBQMIlMZ2/ikdlAb9bgkM=
X-Google-Smtp-Source: AMrXdXtGLVfuwrR5oQIz47G9r+m6obQtdCl0B3fHV+9SsbpLoX1gQ7TcfXTl7/moZHEL/NH17nWVhQ==
X-Received: by 2002:a05:6e02:1a2b:b0:30f:5d64:cc3 with SMTP id g11-20020a056e021a2b00b0030f5d640cc3mr9050524ile.9.1674465417940;
        Mon, 23 Jan 2023 01:16:57 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id m3-20020a923f03000000b00300b9b7d594sm13851891ila.20.2023.01.23.01.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:16:57 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
Cc:     wuruoyu@me.com, benquike@gmail.com, daveti@purdue.edu,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: Bluetooth: L2cap: use-after-free in l2cap_sock_ready_cb
Date:   Mon, 23 Jan 2023 04:15:57 -0500
Message-Id: <20230123091556.4109694-1-git@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a racy bug. e1000_clean() forcefully frees a socket even if
l2cap_sock_ready_cb() already have the socket lock, resulting in
use-after-free for accessing the socket.
I don't have a clever idea to handle this, since it looks beyond
the Bluetooth system.
For the l2cap_sock.c in the stack trace, please refer this file
for your convenience:
https://gist.github.com/swkim101/5c3b8cb7c7d7172aef23810c9412f323

This is discovered by FuzzBT on top of Syzkaller with Sungwoo Kim (me).
Other contributors for FuzzBT project are Ruoyu Wu(wuruoyu@me.com)
and Hui Peng(benquike@gmail.com).

==================================================================
BUG: KASAN: use-after-free in l2cap_sock_ready_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1685) 
Read of size 8 at addr ffff88800f6efaa8 by task kworker/u3:0/76
CPU: 0 PID: 76 Comm: kworker/u3:0 Not tainted 6.1.0-rc2 #129
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Workqueue: hci0 hci_rx_work
Call Trace:
 <TASK>
dump_stack_lvl (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/lib/dump_stack.c:105) 
print_address_description+0x7e/0x360 
print_report (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:187 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:389) 
? __virt_addr_valid (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/mmzone.h:1855 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/mm/physaddr.c:65) 
? kasan_complete_mode_report_info (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report_generic.c:104 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report_generic.c:127 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report_generic.c:136) 
? l2cap_sock_ready_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1685) 
kasan_report (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:? /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:484) 
? l2cap_sock_ready_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1685) 
__asan_load8 (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:45 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:67 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:151 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:180 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:256) 
l2cap_sock_ready_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1685) 
l2cap_bredr_sig_cmd (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:4703 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:5884) 
? vprintk_default (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/printk/printk.c:2279) 
? vprintk (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/printk/printk_safe.c:50) 
? _printk (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/printk/printk.c:2289) 
? bt_err (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/lib.c:?) 
? bt_err (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/lib.c:249) 
l2cap_recv_frame (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:7851 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:7919) 
? _printk (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/printk/printk.c:2289) 
? bt_err (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/lib.c:?) 
? __wake_up_klogd (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/printk/printk.c:3481) 
l2cap_recv_acldata (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:8601 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:8631) 
? hci_conn_enter_active_mode (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/hci_conn.c:?) 
hci_rx_work (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/bluetooth/hci_core.h:1121 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/hci_core.c:3937 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/hci_core.c:4189) 
process_one_work (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2225) 
worker_thread (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:816 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2107 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2159 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2408) 
kthread (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/kthread.c:361) 
? process_one_work (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2321) 
? kthread_blkcg (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/kthread.c:76 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/kthread.c:1519) 
ret_from_fork (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/entry_64.S:306) 
 </TASK>
Allocated by task 328:
kasan_set_track (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:51) 
kasan_save_alloc_info (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:432 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:498) 
__kasan_kmalloc (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:356) 
__kmalloc_node_track_caller (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slab_common.c:943 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slab_common.c:975) 
__alloc_skb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/skbuff.c:516) 
__tcp_send_ack (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/sock.h:1010 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/tcp_output.c:3961) 
tcp_send_ack (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/tcp_output.c:3992) 
__tcp_cleanup_rbuf (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/tcp.c:1579) 
tcp_recvmsg_locked (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/skbuff.h:2324 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/tcp.c:1633 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/tcp.c:2633) 
tcp_recvmsg (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/busy_poll.h:107 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/tcp.c:2676) 
inet_recvmsg (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/ipv4/af_inet.c:859) 
sock_read_iter (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/socket.c:1073) 
vfs_read (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/uio.h:345 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/fs/read_write.c:387 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/fs/read_write.c:470) 
ksys_read (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/fs/read_write.c:?) 
__x64_sys_read (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/fs/read_write.c:621) 
do_syscall_64 (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/common.c:49 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/common.c:80) 
entry_SYSCALL_64_after_hwframe (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/entry_64.S:120) 
Freed by task 328:
kasan_set_track (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:51) 
kasan_save_free_info (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:508) 
____kasan_slab_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/slub_def.h:164 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:214) 
__kasan_slab_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:244) 
slab_free_freelist_hook (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:381 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:1747) 
__kmem_cache_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:3656 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:3674) 
kfree (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slab_common.c:1007) 
skb_release_data (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/skbuff.c:782) 
napi_consume_skb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/skbuff.c:?) 
e1000_clean (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/drivers/net/ethernet/intel/e1000/e1000_main.c:3855 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/drivers/net/ethernet/intel/e1000/e1000_main.c:3801) 
__napi_poll (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./arch/x86/include/asm/bitops.h:207 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./arch/x86/include/asm/bitops.h:239 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/asm-generic/bitops/instrumented-non-atomic.h:142 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/dev.c:6497) 
net_rx_action (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/dev.c:6639 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/dev.c:6667) 
__do_softirq (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./arch/x86/include/asm/current.h:?) 
The buggy address belongs to the object at ffff88800f6ef800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 680 bytes inside of
 1024-byte region [ffff88800f6ef800, ffff88800f6efc00)
The buggy address belongs to the physical page:
page:00000000b954ec57 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xf6ec
head:00000000b954ec57 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0010200 ffffea0000864c00 dead000000000003 ffff888005841dc0
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88800f6ef980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800f6efa00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88800f6efa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88800f6efb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800f6efb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
