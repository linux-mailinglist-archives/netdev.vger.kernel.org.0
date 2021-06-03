Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43DF39AA07
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFCSb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhFCSbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 14:31:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0163CC06174A;
        Thu,  3 Jun 2021 11:30:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so4398537pjq.3;
        Thu, 03 Jun 2021 11:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=E71V1Qw+CpfCyVc9M0pYK4Yc0sj2qZplV0S0OjBbfFQ=;
        b=dVz4SCvRYK2UEw/s8LyTbMyGy2MiqxlfKnW2kl28NnpOGLq3c1l8nYidNx1A7G+HJ8
         F3gG2GQNR5pgi6MhYJUfZUGwgrBzMvYORcpK1HOsCY0O2M7SenQSQvYqGfgTMTmDypjK
         /0ziuDxLzhTualXCf62nGNFyvLh7FpsPXP+HGrMlhAkQNDk0Ths+MK9gRw9LOf5TDGS7
         cBuwOfH+xokXYKph+DfHSoKMD21CvbiWxTO5XHxa9rAEeMhHMnMKWVg9OpSR9OdhleLS
         JAU2Z6Gf31iAUZcPrQzhDDH/k4CKGmSTILJ1kvyYqBibDTvra5P4i6blH5tvs7KUQHda
         j4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=E71V1Qw+CpfCyVc9M0pYK4Yc0sj2qZplV0S0OjBbfFQ=;
        b=QRrrlBpKhGxdi/dfnLzIIPY/dgPkNqW+SS+5S+wMB+TUlrGW5SWAIYUftdVMeIbmf2
         4Ok3GtxMsY4vFr6Es5O24yg4yztQYOY2FamRkZhpnuwZEric/QXTDXiHiRhU6AKpK6Jc
         qV3J1lhN7ttX7SxAvBKiLyrGz/P+ctcNptotdt6taBezfs3bUHfCRq1IZdYBfy+8bfVV
         nqXc/PuQhLW7F1VqhbLITTWenrCWeSY32fVsFslhHBV9GXEp68XJQl9UsE3Tbn9AEtpX
         EB0/Z3c+0pTnLlZ7/BDJHAJH8PPgaxtkly381fhtAzWYRulMz1EPtbFNzayLdpPFVVnR
         npxA==
X-Gm-Message-State: AOAM533tyTfkE3ZKgOpx1VRgQMgRrj9gaO0DKFZJduCWLjiaAULjwkDy
        yHIl+m4BdHhhxeTuHQPqivc=
X-Google-Smtp-Source: ABdhPJz1CspluYwZmEUY2zrALPFEJghAS97EIMbUYVG+tsVAtNNSSDlBWW7zmKanWvbzordWA0RTsQ==
X-Received: by 2002:a17:90a:4a89:: with SMTP id f9mr12725019pjh.50.1622745010413;
        Thu, 03 Jun 2021 11:30:10 -0700 (PDT)
Received: from [192.168.1.41] (096-040-190-174.res.spectrum.com. [96.40.190.174])
        by smtp.gmail.com with ESMTPSA id 4sm3219694pgn.31.2021.06.03.11.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 11:30:09 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
From:   SyzScope <syzscope@gmail.com>
To:     syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, gregkh@linuxfoundation.org
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
Message-ID: <c40de1fa-c152-4c94-041a-7e014085c66e@gmail.com>
Date:   Thu, 3 Jun 2021 11:30:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi developers,

Besides the control flow hijacking primitive we sent before, we managed 
to discover an additional double free primitive in this bug, making this 
bug even more dangerous.

We created a web page with detailed descriptions: 
https://sites.google.com/view/syzscope/kasan-use-after-free-read-in-hci_chan_del

We understand that creating a patch can be time-consuming and there is 
probably a long list of bugs pending fixes. We hope that our security 
analysis can enable an informed decision on which bugs to fix first 
(prioritization).

Since the bug has been on syzbot for over ten months (first found on 
08-03-2020 and still can be triggered on 05-08-2021), it is best to have 
the bug fixed early enough to avoid it being weaponized.


On 5/28/2021 2:12 PM, SyzScope wrote:
> Sorry for the confusion on our last email. We did a little more 
> analysis after then and hope to help developers fix this bug.
>
> The bug was reported by syzbot first in Aug 2020. Since it remains 
> unpatched to this date, we have conducted some analysis to determine 
> its security impact and root causes, which hopefully can help with the 
> patching decisions.
> Specifically, we find that even though it is labeled as "UAF read" by 
> syzbot, it can in fact lead to double free and control flow hijacking 
> as well. Here is our analysis below (on this kernel version: 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?id=af5043c89a8ef6b6949a245fff355a552eaed240)
>
> ----------------------------- Root cause analysis: 
> --------------------------
> The use-after-free bug happened because the object has two different 
> references. But when it was freed, only one reference was removed, 
> allowing the other reference to be used incorrectly.
>
> Specifically, the object of type "struct hci_chan" can be referenced 
> in two places from an object called hcon(or conn in hci_chan_create)of 
> type struct hci_conn : "hcon->chan_list" and 
> "hcon->l2cap_data->hchan". But only one of them (conn->chan_list) was 
> deleted when freeing "struct hci_chan" from 
> "hci_disconn_loglink_complete_evt()".
>
> The function "hci_chan_create" shows how the first reference is created.
>
> struct hci_chan *hci_chan_create(struct hci_conn *conn)
> {
>     struct hci_dev *hdev = conn->hdev;
>     struct hci_chan *chan;
>
>     ...
>     chan = kzalloc(sizeof(*chan), GFP_KERNEL);
>     ...
>     list_add_rcu(&chan->list, &conn->chan_list); // Assign chan to 
> hcon->chan_list. This is the first reference created.
>
>     return chan;
> }
>
> "l2cap_conn_add" is the caller of the previous function which shows 
> how the second reference is created.
>
> static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
> {
>     struct l2cap_conn *conn = hcon->l2cap_data;
>     struct hci_chan *hchan;
>
>     ...
>
>     hchan = hci_chan_create(hcon); //"hchan" was created in 
> hci_chan_create
>     if (!hchan)
>         return NULL;
>
>     conn = kzalloc(sizeof(*conn), GFP_KERNEL);
>     ...
>     kref_init(&conn->ref);
>     hcon->l2cap_data = conn;
>     conn->hcon = hci_conn_get(hcon);
>     conn->hchan = hchan; // "chan" was assigned to 
> "hcon->l2cap_data->hchan". This is the second reference.
>     ...
> }
>
> When the chan was freed in "hci_disconn_loglink_complete_evt" 
> (hci_disconn_loglink_complete_evt()->amp_destroy_logical_link()->hci_chan_del()), 
> we only deleted the reference of "((struct hci_conn 
> *)hcon)->chan_list" (effectively removing the entry from the list), 
> but the reference of "((struct hci_conn *)hcon)->l2cap_data->hchan" is 
> still valid.
>
> The function below shows exactly how the free of the object occurs and 
> how its first reference is removed.
>
> void hci_chan_del(struct hci_chan *chan)
> {
>
>     struct hci_conn *conn = chan->conn;
>     struct hci_dev *hdev = conn->hdev;
>
>     BT_DBG("%s hcon %p chan %p", hdev->name, conn, chan);
>     list_del_rcu(&chan->list); // removed "chan" from the list (the 
> first reference). The second reference((struct hci_conn 
> *)hcon->l2cap_data->hchan) remains however.
>     synchronize_rcu();
>     set_bit(HCI_CONN_DROP, &conn->flags);
>     hci_conn_put(conn);
>
>     skb_queue_purge(&chan->data_q);
>
>     kfree(chan); // free "chan"
> }
>
> ----------------------------- Potential fix: --------------------------
> Based on the analysis, it appears that in hci_chan_del(), we should 
> remove the second reference of (struct hci_conn 
> *)hcon->l2cap_data->hchan,e.g., setting it to NULL
>
> -------------------------- Control flow hijacking Primitve: 
> -----------------------------
>
> This function is where the bug impact was originally reported on syzbot
>
> void hci_chan_del(struct hci_chan *chan) //"chan" was freed
> {
>
>     struct hci_conn *conn = chan->conn; // Syzbot reported the UAF read
>     struct hci_dev *hdev = conn->hdev;
>
>     ...
>
>     skb_queue_purge(&chan->data_q); // "data_q" comes from the freed 
> object "chan" therefore it can point to an arbitrary memory address
>     kfree(chan);
> }
>
>
> The skb was dequeued from the list, however the list is controllable 
> by an attacker and it can point to an arbitrary memory address.
>
> void skb_queue_purge(struct sk_buff_head *list)
> {
>     struct sk_buff *skb;
>
>     while ((skb = skb_dequeue(list)) != NULL) // skb is also controllable
>         kfree_skb(skb); // dangerous use of skb further down
> }
>
> After going through a long call chain: 
> skb_queue_purge->kfree_skb->__kfree_skb->skb_release_all->skb_release_data, 
> skb enters "skb_zcopy_clear".
>
> static void skb_release_data(struct sk_buff *skb)
> {
>     ...
>     skb_zcopy_clear(skb, true); // skb entered skb_zcopy_clear() and 
> will dereference a function pointer inside.
>     skb_free_head(skb);
> }
>
>
>
> static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
> {
>     struct ubuf_info *uarg = skb_zcopy(skb); // uarg comes from skb, 
> therefore it also controllable by attacker
>
>     if (uarg) {
>         if (skb_zcopy_is_nouarg(skb)) {
>             /* no notification callback */
>         } else if (uarg->callback == sock_zerocopy_callback) {
>             uarg->zerocopy = uarg->zerocopy && zerocopy;
>             sock_zerocopy_put(uarg); // uarg enters sock_zerocopy_put()
>         }
> ...
>     }
> }
>
> Inside the function below, uarg's function pointer will be 
> dereferenced. This makes a control flow hijacking possible because 
> uarg is totally controllable by attackers.
>
> void sock_zerocopy_put(struct ubuf_info *uarg)
>
> {
>     if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
>         if (uarg->callback)
>             uarg->callback(uarg, uarg->zerocopy); // uarg dereferences 
> a function pointer, and thus we grant a control flow hijacking primitive
>         ...
>     }
>
> }
>
>
> SyzScope Team.
>
> On 8/2/2020 1:45 PM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ac3a0c84 Merge 
>> git://git.kernel.org/pub/scm/linux/kernel/g..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
>> kernel config: 
>> https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
>> dashboard link: 
>> https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
>> compiler:       clang version 10.0.0 
>> (https://github.com/llvm/llvm-project/ 
>> c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the 
>> commit:
>> Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
>>
>> IPVS: ftp: loaded support on port[0] = 21
>> ==================================================================
>> BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 
>> net/bluetooth/hci_conn.c:1707
>> Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793
>>
>> CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 
>> 5.8.0-rc7-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, 
>> BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>>   print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>>   __kasan_report mm/kasan/report.c:513 [inline]
>>   kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>>   hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
>>   l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
>>   hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
>>   hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
>>   hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
>>   hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
>>   vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
>>   __fput+0x2f0/0x750 fs/file_table.c:281
>>   task_work_run+0x137/0x1c0 kernel/task_work.c:135
>>   exit_task_work include/linux/task_work.h:25 [inline]
>>   do_exit+0x601/0x1f80 kernel/exit.c:805
>>   do_group_exit+0x161/0x2d0 kernel/exit.c:903
>>   __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
>>   __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
>>   __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
>>   do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x444fe8
>> Code: Bad RIP value.
>> RSP: 002b:00007ffe96e46e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
>> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
>> RBP: 00000000004ccdd0 R08: 00000000000000e7 R09: ffffffffffffffd0
>> R10: 00007f5ee25cd700 R11: 0000000000000246 R12: 0000000000000001
>> R13: 00000000006e0200 R14: 0000000000000000 R15: 0000000000000000
>>
>> Allocated by task 6821:
>>   save_stack mm/kasan/common.c:48 [inline]
>>   set_track mm/kasan/common.c:56 [inline]
>>   __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
>>   kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
>>   kmalloc include/linux/slab.h:555 [inline]
>>   kzalloc include/linux/slab.h:669 [inline]
>>   hci_chan_create+0x9a/0x270 net/bluetooth/hci_conn.c:1692
>>   l2cap_conn_add+0x66/0xb00 net/bluetooth/l2cap_core.c:7699
>>   l2cap_connect_cfm+0xdb/0x12b0 net/bluetooth/l2cap_core.c:8097
>>   hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
>>   hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
>>   hci_event_packet+0x1164c/0x18260 net/bluetooth/hci_event.c:6061
>>   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>>   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>>   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>>   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>>
>> Freed by task 1530:
>>   save_stack mm/kasan/common.c:48 [inline]
>>   set_track mm/kasan/common.c:56 [inline]
>>   kasan_set_free_info mm/kasan/common.c:316 [inline]
>>   __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
>>   __cache_free mm/slab.c:3426 [inline]
>>   kfree+0x10a/0x220 mm/slab.c:3757
>>   hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 
>> [inline]
>>   hci_event_packet+0x304e/0x18260 net/bluetooth/hci_event.c:6188
>>   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>>   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>>   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>>   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>>
>> The buggy address belongs to the object at ffff8880a9591f00
>>   which belongs to the cache kmalloc-128 of size 128
>> The buggy address is located 24 bytes inside of
>>   128-byte region [ffff8880a9591f00, ffff8880a9591f80)
>> The buggy address belongs to the page:
>> page:ffffea0002a56440 refcount:1 mapcount:0 mapping:0000000000000000 
>> index:0xffff8880a9591800
>> flags: 0xfffe0000000200(slab)
>> raw: 00fffe0000000200 ffffea0002a5a648 ffffea00028a4a08 ffff8880aa400700
>> raw: ffff8880a9591800 ffff8880a9591000 000000010000000a 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>   ffff8880a9591e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>   ffff8880a9591e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff8880a9591f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                              ^
>>   ffff8880a9591f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>   ffff8880a9592000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>>
