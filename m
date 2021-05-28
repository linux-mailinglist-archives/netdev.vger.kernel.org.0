Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6BA39482A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhE1VNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhE1VNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 17:13:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33763C061574;
        Fri, 28 May 2021 14:12:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v12so2195591plo.10;
        Fri, 28 May 2021 14:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=BnGRCKdXDqfiQGFDmU9i+cr+BFC4hLAeOTS+cmpsUMA=;
        b=QUkT24auWcFKNvY5piEnHAiT8vPOF3xWeKIBvO+1n9IsX8nlVAjBUHLeIKqZVZkKDs
         VHX5Ueoc/ZcWNWSX3DGmVKK+XpjYEeDTbAJen5x+LilJCAW2Wq22k/bOjqCpBcjbMH3l
         NH2vBx8IweRp4Fwqa2dWgtQlS3Wdav8fAFDUyoS9ObT70gE15QOZd67FOkFee5Afyz+A
         1vym+pb3HPUbzJDEdqOrrd20LyhFyJes71V2KEq3G/Asa4pFxgg8F+gOxK3Wi6S4TtQs
         WvNmDOyD23P6HosAjvfZMqPv0IygozkiUPfEtsT6qAK6n1IR+YoYXJ73zIRWIZu8Z0aC
         in0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BnGRCKdXDqfiQGFDmU9i+cr+BFC4hLAeOTS+cmpsUMA=;
        b=W/p+OzUGBbnTTBOQFGOEoWYj4UjZro81daXqv3E8D/yCcwGRf4SQ288CRBmbS0fYhV
         /gNC8HN6pyEUKaQxw8DMKdS6TRFVfOlGtFkhktGhxqns/Yv6rK9dGki87XvYrekxrI+t
         kFIR+DKpGhmuNDEOCZfMgvyhiglWbJTyD4GO+flZudK8TsYSu4bDIiTzM19VkKf61aaq
         TfgKfutEKFSXr3kz2rFI4Kbh0AbiHk4TzkQF9/mkXWNzqPxQzSKRUStff1KlI7NoLhVy
         DTSswGYNTPzh/cavphXcP/Yxd1xMWIuTEaIk2/ZR2UzhZsT1gJZ5CeBXI/VNUkFo3ZvA
         9ZTQ==
X-Gm-Message-State: AOAM533z/fbZwzBCO+B1ebLOsIfyI34unh2B6fUNV6K8bC+HFoV4k4P5
        kXU0xU2/pxWU8ZAnGhXhVqbkX3AGzoNDIw==
X-Google-Smtp-Source: ABdhPJz7HDkZ12WTXbsE+dJcjc92XBzacgTRaOjSsp6qo7mpljo+eVvehMUkkJEXV4/4xqrHVPk99g==
X-Received: by 2002:a17:902:9302:b029:f6:32d3:e10a with SMTP id bc2-20020a1709029302b02900f632d3e10amr10027251plb.29.1622236323522;
        Fri, 28 May 2021 14:12:03 -0700 (PDT)
Received: from [192.168.1.41] (097-090-198-083.res.spectrum.com. [97.90.198.83])
        by smtp.gmail.com with ESMTPSA id d15sm4991806pfd.35.2021.05.28.14.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 14:12:03 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To:     syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000adea7f05abeb19cf@google.com>
From:   SyzScope <syzscope@gmail.com>
Message-ID: <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
Date:   Fri, 28 May 2021 14:12:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <000000000000adea7f05abeb19cf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the confusion on our last email. We did a little more analysis 
after then and hope to help developers fix this bug.

The bug was reported by syzbot first in Aug 2020. Since it remains 
unpatched to this date, we have conducted some analysis to determine its 
security impact and root causes, which hopefully can help with the 
patching decisions.
Specifically, we find that even though it is labeled as "UAF read" by 
syzbot, it can in fact lead to double free and control flow hijacking as 
well. Here is our analysis below (on this kernel version: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?id=af5043c89a8ef6b6949a245fff355a552eaed240)

----------------------------- Root cause analysis: 
--------------------------
The use-after-free bug happened because the object has two different 
references. But when it was freed, only one reference was removed, 
allowing the other reference to be used incorrectly.

Specifically, the object of type "struct hci_chan" can be referenced in 
two places from an object called hcon(or conn in hci_chan_create)of type 
struct hci_conn : "hcon->chan_list" and "hcon->l2cap_data->hchan". But 
only one of them (conn->chan_list) was deleted when freeing "struct 
hci_chan" from "hci_disconn_loglink_complete_evt()".

The function "hci_chan_create" shows how the first reference is created.

struct hci_chan *hci_chan_create(struct hci_conn *conn)
{
     struct hci_dev *hdev = conn->hdev;
     struct hci_chan *chan;

     ...
     chan = kzalloc(sizeof(*chan), GFP_KERNEL);
     ...
     list_add_rcu(&chan->list, &conn->chan_list); // Assign chan to 
hcon->chan_list. This is the first reference created.

     return chan;
}

"l2cap_conn_add" is the caller of the previous function which shows how 
the second reference is created.

static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
{
     struct l2cap_conn *conn = hcon->l2cap_data;
     struct hci_chan *hchan;

     ...

     hchan = hci_chan_create(hcon); //"hchan" was created in hci_chan_create
     if (!hchan)
         return NULL;

     conn = kzalloc(sizeof(*conn), GFP_KERNEL);
     ...
     kref_init(&conn->ref);
     hcon->l2cap_data = conn;
     conn->hcon = hci_conn_get(hcon);
     conn->hchan = hchan; // "chan" was assigned to 
"hcon->l2cap_data->hchan". This is the second reference.
     ...
}

When the chan was freed in "hci_disconn_loglink_complete_evt" 
(hci_disconn_loglink_complete_evt()->amp_destroy_logical_link()->hci_chan_del()), 
we only deleted the reference of "((struct hci_conn *)hcon)->chan_list" 
(effectively removing the entry from the list), but the reference of 
"((struct hci_conn *)hcon)->l2cap_data->hchan" is still valid.

The function below shows exactly how the free of the object occurs and 
how its first reference is removed.

void hci_chan_del(struct hci_chan *chan)
{

     struct hci_conn *conn = chan->conn;
     struct hci_dev *hdev = conn->hdev;

     BT_DBG("%s hcon %p chan %p", hdev->name, conn, chan);
     list_del_rcu(&chan->list); // removed "chan" from the list (the 
first reference). The second reference((struct hci_conn 
*)hcon->l2cap_data->hchan) remains however.
     synchronize_rcu();
     set_bit(HCI_CONN_DROP, &conn->flags);
     hci_conn_put(conn);

     skb_queue_purge(&chan->data_q);

     kfree(chan); // free "chan"
}

----------------------------- Potential fix: --------------------------
Based on the analysis, it appears that in hci_chan_del(), we should 
remove the second reference of (struct hci_conn 
*)hcon->l2cap_data->hchan,e.g., setting it to NULL

-------------------------- Control flow hijacking Primitve: 
-----------------------------

This function is where the bug impact was originally reported on syzbot

void hci_chan_del(struct hci_chan *chan) //"chan" was freed
{

     struct hci_conn *conn = chan->conn; // Syzbot reported the UAF read
     struct hci_dev *hdev = conn->hdev;

     ...

     skb_queue_purge(&chan->data_q); // "data_q" comes from the freed 
object "chan" therefore it can point to an arbitrary memory address
     kfree(chan);
}


The skb was dequeued from the list, however the list is controllable by 
an attacker and it can point to an arbitrary memory address.

void skb_queue_purge(struct sk_buff_head *list)
{
     struct sk_buff *skb;

     while ((skb = skb_dequeue(list)) != NULL) // skb is also controllable
         kfree_skb(skb); // dangerous use of skb further down
}

After going through a long call chain: 
skb_queue_purge->kfree_skb->__kfree_skb->skb_release_all->skb_release_data, 
skb enters "skb_zcopy_clear".

static void skb_release_data(struct sk_buff *skb)
{
     ...
     skb_zcopy_clear(skb, true); // skb entered skb_zcopy_clear() and 
will dereference a function pointer inside.
     skb_free_head(skb);
}



static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
{
     struct ubuf_info *uarg = skb_zcopy(skb); // uarg comes from skb, 
therefore it also controllable by attacker

     if (uarg) {
         if (skb_zcopy_is_nouarg(skb)) {
             /* no notification callback */
         } else if (uarg->callback == sock_zerocopy_callback) {
             uarg->zerocopy = uarg->zerocopy && zerocopy;
             sock_zerocopy_put(uarg); // uarg enters sock_zerocopy_put()
         }
...
     }
}

Inside the function below, uarg's function pointer will be dereferenced. 
This makes a control flow hijacking possible because uarg is totally 
controllable by attackers.

void sock_zerocopy_put(struct ubuf_info *uarg)

{
     if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
         if (uarg->callback)
             uarg->callback(uarg, uarg->zerocopy); // uarg dereferences 
a function pointer, and thus we grant a control flow hijacking primitive
         ...
     }

}


SyzScope Team.

On 8/2/2020 1:45 PM, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
> dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
>
> IPVS: ftp: loaded support on port[0] = 21
> ==================================================================
> BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
> Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793
>
> CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 5.8.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>   print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>   __kasan_report mm/kasan/report.c:513 [inline]
>   kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>   hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
>   l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
>   hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
>   hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
>   hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
>   hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
>   vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
>   __fput+0x2f0/0x750 fs/file_table.c:281
>   task_work_run+0x137/0x1c0 kernel/task_work.c:135
>   exit_task_work include/linux/task_work.h:25 [inline]
>   do_exit+0x601/0x1f80 kernel/exit.c:805
>   do_group_exit+0x161/0x2d0 kernel/exit.c:903
>   __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
>   __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
>   __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
>   do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x444fe8
> Code: Bad RIP value.
> RSP: 002b:00007ffe96e46e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
> RBP: 00000000004ccdd0 R08: 00000000000000e7 R09: ffffffffffffffd0
> R10: 00007f5ee25cd700 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000006e0200 R14: 0000000000000000 R15: 0000000000000000
>
> Allocated by task 6821:
>   save_stack mm/kasan/common.c:48 [inline]
>   set_track mm/kasan/common.c:56 [inline]
>   __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
>   kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
>   kmalloc include/linux/slab.h:555 [inline]
>   kzalloc include/linux/slab.h:669 [inline]
>   hci_chan_create+0x9a/0x270 net/bluetooth/hci_conn.c:1692
>   l2cap_conn_add+0x66/0xb00 net/bluetooth/l2cap_core.c:7699
>   l2cap_connect_cfm+0xdb/0x12b0 net/bluetooth/l2cap_core.c:8097
>   hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
>   hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
>   hci_event_packet+0x1164c/0x18260 net/bluetooth/hci_event.c:6061
>   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>
> Freed by task 1530:
>   save_stack mm/kasan/common.c:48 [inline]
>   set_track mm/kasan/common.c:56 [inline]
>   kasan_set_free_info mm/kasan/common.c:316 [inline]
>   __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
>   __cache_free mm/slab.c:3426 [inline]
>   kfree+0x10a/0x220 mm/slab.c:3757
>   hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 [inline]
>   hci_event_packet+0x304e/0x18260 net/bluetooth/hci_event.c:6188
>   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>
> The buggy address belongs to the object at ffff8880a9591f00
>   which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 24 bytes inside of
>   128-byte region [ffff8880a9591f00, ffff8880a9591f80)
> The buggy address belongs to the page:
> page:ffffea0002a56440 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a9591800
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea0002a5a648 ffffea00028a4a08 ffff8880aa400700
> raw: ffff8880a9591800 ffff8880a9591000 000000010000000a 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8880a9591e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8880a9591e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff8880a9591f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                              ^
>   ffff8880a9591f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8880a9592000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
