Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E931EC94D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgFCGNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgFCGNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:13:20 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6183C05BD43;
        Tue,  2 Jun 2020 23:13:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o6so1062196pgh.2;
        Tue, 02 Jun 2020 23:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nOXFzX456k8ToSmWlXrVvQOpedDy83brpUrAH8sEVJ0=;
        b=jtNCMEpo9NnsrjyLGnOiUsW3VlIIYeQw34/0ZCDVA4Zjrt/+9i+O1B29l8pAYPSD/m
         ET4oqSngZpkeeWaT8NGrCOawKnNhWBKx8MftrtLImwyaKmsjl/EqZBSxrxK/0l807eoG
         3sppOdEpVbbmsMlqiAs1JqK+2kOPWDR8h/utozQLbFFsqyzZOYJxZHLAhCjiv3/PO1GR
         ARf50CmsAh88zjpDpGkfpNPQWD+3mGNDpkyG6zOhYAb4FZH/zFdsewk5gr34hUrrRm5u
         jyh68fvVJI1d0RhsYCaKnKBDQs4rSUDyq1L/AimwKroDMv6Lgqg4rCyXAf8Uvcq853Ic
         Jf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nOXFzX456k8ToSmWlXrVvQOpedDy83brpUrAH8sEVJ0=;
        b=Ntf9D7NmPLFgHSgxIkKQha/j6O6vR41JsS/SOCENfIQUrayyQ96FgRgrhaVss0NtXN
         KRaFe54nyJVpWFvesSwaAEt0bXIjGnSP7EKrJFR8OkQFSs30HscPUqkV+DDKLiI2mTBN
         Sn63/bKuDuXs52xbZP6KWFRVJRRv4hkoX5kaIcoUhsqmbpN13WeedRQ/blyT4WxcHZGR
         A9tV4kJOOrtoczOVr41jH8ensbviTJ1LtXO0C+9Q0zPlwVA9G0ymh6CYWlI1WwYmqfYD
         j0LbqA5O3N+pCHp8q4fmQE+50pHF4+U3Xh+onYHvsdmkzoGRh8yPZonsE3DxxQ5yiS/C
         9mNg==
X-Gm-Message-State: AOAM531bwPE5Y4QwZwl273HLthFMVrnT5L8Pkyfqkl7P+9ugAzJ7y8du
        +MaRR4XqSLDtIWCblXWsRenTl9dN
X-Google-Smtp-Source: ABdhPJwp9U4l18oSw7Ng1/0ps1SmqynLvc4lx9fMuBl19nsAQ/prcCZPws5UHC21udoxrS6jGiiWXg==
X-Received: by 2002:aa7:91ca:: with SMTP id z10mr3004826pfa.282.1591164798859;
        Tue, 02 Jun 2020 23:13:18 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id ft10sm1017271pjb.40.2020.06.02.23.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 23:13:18 -0700 (PDT)
Subject: Re: [bpf PATCH] bpf: sockmap, remove bucket->lock from
 sock_{hash|map}_free
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6f8bb6d8-bb70-4533-f15b-310db595d334@gmail.com>
Date:   Tue, 2 Jun 2020 23:13:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 9:41 AM, John Fastabend wrote:
> The bucket->lock is not needed in the sock_hash_free and sock_map_free
> calls, in fact it is causing a splat due to being inside rcu block.
> 
> 
> | BUG: sleeping function called from invalid context at net/core/sock.c:2935
> | in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
> | 3 locks held by kworker/0:1/62:
> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
> | CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x71/0xa0
> |  ___might_sleep.cold+0xa6/0xb6
> |  lock_sock_nested+0x28/0x90
> |  sock_map_free+0x5f/0x180
> |  bpf_map_free_deferred+0x58/0x80
> |  process_one_work+0x260/0x5e0
> |  worker_thread+0x4d/0x3e0
> |  kthread+0x108/0x140
> |  ? process_one_work+0x5e0/0x5e0
> |  ? kthread_park+0x90/0x90
> |  ret_from_fork+0x3a/0x50
> 
> The reason we have stab->lock and bucket->locks in sockmap code is to
> handle checking EEXIST in update/delete cases. We need to be careful during
> an update operation that we check for EEXIST and we need to ensure that the
> psock object is not in some partial state of removal/insertion while we do
> this. So both map_update_common and sock_map_delete need to guard from being
> run together potentially deleting an entry we are checking, etc. But by the
> time we get to the tear-down code in sock_{ma[|hash}_free we have already
> disconnected the map and we just did synchronize_rcu() in the line above so
> no updates/deletes should be in flight. Because of this we can drop the
> bucket locks from the map free'ing code, noting no update/deletes can be
> in-flight.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/sock_map.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 085cef5..b70c844 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -233,8 +233,11 @@ static void sock_map_free(struct bpf_map *map)
>  	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
>  	int i;
>  
> +	/* After the sync no updates or deletes will be in-flight so it
> +	 * is safe to walk map and remove entries without risking a race
> +	 * in EEXIST update case.


What prevents other cpus from deleting stuff in sock_hash_delete_elem() ?

What state has been changed before the synchronize_rcu() call here,
that other cpus check before attempting a delete ?

Typically, synchronize_rcu() only makes sense if readers can not start a new cycle.

A possible fix would be to check in sock_hash_delete_elem() (and possibly others methods)
if map->refcnt is not zero.

syzbot found : (no repro yet)

general protection fault, probably for non-canonical address 0xfbd59c0000000024: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead000000000127]
CPU: 2 PID: 14305 Comm: kworker/2:3 Not tainted 5.7.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: events bpf_map_free_deferred
RIP: 0010:__write_once_size include/linux/compiler.h:279 [inline]
RIP: 0010:__hlist_del include/linux/list.h:811 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:485 [inline]
RIP: 0010:sock_hash_free+0x202/0x4a0 net/core/sock_map.c:1021
Code: 0f 85 15 02 00 00 4c 8d 7b 28 4c 8b 63 20 4c 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 47 02 00 00 4c 8b 6b 28 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 25 02 00 00 4d 85 e4 4d 89 65 00 74 20 e8 f6 82
RSP: 0018:ffffc90000ba7c38 EFLAGS: 00010a06
RAX: 1bd5a00000000024 RBX: ffff88801d866700 RCX: ffffffff8636ae84
RDX: 0000000000000000 RSI: ffffffff8636afe9 RDI: ffff88801d866720
RBP: dffffc0000000000 R08: ffff888022765080 R09: fffffbfff185f952
R10: ffffffff8c2fca8f R11: fffffbfff185f951 R12: 0000000000000000
R13: dead000000000122 R14: dead000000000122 R15: ffff88801d866728
FS:  0000000000000000(0000) GS:ffff88802d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f27551a9db8 CR3: 0000000056530000 CR4: 0000000000340ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bpf_map_free_deferred+0xb2/0x100 kernel/bpf/syscall.c:471
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Modules linked in:
---[ end trace da3ce2417ae8d343 ]---
RIP: 0010:__write_once_size include/linux/compiler.h:279 [inline]
RIP: 0010:__hlist_del include/linux/list.h:811 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:485 [inline]
RIP: 0010:sock_hash_free+0x202/0x4a0 net/core/sock_map.c:1021
Code: 0f 85 15 02 00 00 4c 8d 7b 28 4c 8b 63 20 4c 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 47 02 00 00 4c 8b 6b 28 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 25 02 00 00 4d 85 e4 4d 89 65 00 74 20 e8 f6 82
RSP: 0018:ffffc90000ba7c38 EFLAGS: 00010a06
RAX: 1bd5a00000000024 RBX: ffff88801d866700 RCX: ffffffff8636ae84
RDX: 0000000000000000 RSI: ffffffff8636afe9 RDI: ffff88801d866720
RBP: dffffc0000000000 R08: ffff888022765080 R09: fffffbfff185f952
R10: ffffffff8c2fca8f R11: fffffbfff185f951 R12: 0000000000000000
R13: dead000000000122 R14: dead000000000122 R15: ffff88801d866728
FS:  0000000000000000(0000) GS:ffff88802d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1e5e3c6290 CR3: 000000001347f000 CR4: 0000000000340ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

> +	 */
>  	synchronize_rcu();
> -	raw_spin_lock_bh(&stab->lock);
>  	for (i = 0; i < stab->map.max_entries; i++) {
>  		struct sock **psk = &stab->sks[i];
>  		struct sock *sk;
> @@ -248,7 +251,6 @@ static void sock_map_free(struct bpf_map *map)
>  			release_sock(sk);
>  		}
>  	}
> -	raw_spin_unlock_bh(&stab->lock);
>  
>  	/* wait for psock readers accessing its map link */
>  	synchronize_rcu();
> @@ -863,10 +865,13 @@ static void sock_hash_free(struct bpf_map *map)
>  	struct hlist_node *node;
>  	int i;
>  
> +	/* After the sync no updates or deletes will be in-flight so it
> +	 * is safe to walk map and remove entries without risking a race
> +	 * in EEXIST update case.
> +	 */
>  	synchronize_rcu();
>  	for (i = 0; i < htab->buckets_num; i++) {
>  		bucket = sock_hash_select_bucket(htab, i);
> -		raw_spin_lock_bh(&bucket->lock);
>  		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
>  			hlist_del_rcu(&elem->node);
>  			lock_sock(elem->sk);
> @@ -875,7 +880,6 @@ static void sock_hash_free(struct bpf_map *map)
>  			rcu_read_unlock();
>  			release_sock(elem->sk);
>  		}
> -		raw_spin_unlock_bh(&bucket->lock);
>  	}
>  
>  	/* wait for psock readers accessing its map link */
> 
