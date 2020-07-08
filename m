Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F85218EE9
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgGHRsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:48:13 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:18136 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgGHRsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:48:05 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 13:48:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594230480;
        s=strato-dkim-0002; d=jm0.eu;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=EZeg6fI6ttKUi7UP14G00kZ70cwnxfgmSdSYiNxnja4=;
        b=PkZPrTIc3fhirFL/TM4M9QJ83uc62xOXnf9kVYnqdYPGHW6KTYm4nEIonWL8vF1ppU
        I+EtqGxb1smxUMzfF/YOyNYKgDc6iz6xvy8oR3+7RNFxX8QKli+hr+n4aXhhtXr5xm2/
        2bXtrr8GY0NIxiP39B8CZO25T4hkfSIV5pjzCOmLUp4jCtTLfBNH8q2Pbnij0ryjM2Ww
        xKCpN4epZwAABdKb5dFALRUPQ9XEkMkNEHshgybFVSgaYmszJMUgrQgF1N9KQk/9aRSJ
        7vKZ48k2jmB7eoPx+c9ZozcogZZWGN5Q1e9CeZSneIqxlCIQQj2LRsBYyXmTt7rPMuKe
        PwTA==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPXvQCbXgI7t69COvnl6LERsNcX+38fzXJ1XO/JvLGWj59ag=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2003:c6:1f3d:7510::f30]
        by smtp.strato.de (RZmta 46.10.5 AUTH)
        with ESMTPSA id c08c89w68Ha0tHd
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 8 Jul 2020 19:36:00 +0200 (CEST)
Subject: Re: use-after-free in Bluetooth: 6lowpan (was Re: KASAN:
 use-after-free Write in refcount_warn_saturate)
To:     Kees Cook <keescook@chromium.org>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Johan Hedberg <johan.hedberg@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+7dd7f2f77a7a01d1dc14@syzkaller.appspotmail.com>,
        Michael Scott <mike@foundries.io>,
        Josua Mayer <josua.mayer@jm0.eu>
References: <00000000000055e1a9059f9e169f@google.com>
 <202007052022.984BAD97@keescook>
From:   "Ing. Josua Mayer" <josua.mayer@jm0.eu>
Autocrypt: addr=josua.mayer@jm0.eu; prefer-encrypt=mutual; keydata=
 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
 Si21CLNeIbliI0CNR5kPUY1ntw1JCOmOjKZm
Message-ID: <2f14ae85-6ec7-2a37-a54c-ab9a68bbc40a@jm0.eu>
Date:   Wed, 8 Jul 2020 19:36:00 +0200
MIME-Version: 1.0
In-Reply-To: <202007052022.984BAD97@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings everybody,
Am 06.07.20 um 05:32 schrieb Kees Cook:
> On Thu, Feb 27, 2020 at 11:50:11PM -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    f8788d86 Linux 5.6-rc3
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13005fd9e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
>> dashboard link: https://syzkaller.appspot.com/bug?extid=7dd7f2f77a7a01d1dc14
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> userspace arch: i386
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e3ebede00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a9f8f9e00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+7dd7f2f77a7a01d1dc14@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in atomic_set include/asm-generic/atomic-instrumented.h:44 [inline]
>> BUG: KASAN: use-after-free in refcount_set include/linux/refcount.h:123 [inline]
>> BUG: KASAN: use-after-free in refcount_warn_saturate+0x1f/0x1f0 lib/refcount.c:15
>> Write of size 4 at addr ffff888090eb4018 by task kworker/1:24/2888
>>
>> CPU: 1 PID: 2888 Comm: kworker/1:24 Not tainted 5.6.0-rc3-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: events do_enable_set
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>>  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>>  __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
>>  kasan_report+0x12/0x20 mm/kasan/common.c:641
>>  check_memory_region_inline mm/kasan/generic.c:185 [inline]
>>  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
>>  __kasan_check_write+0x14/0x20 mm/kasan/common.c:101
>>  atomic_set include/asm-generic/atomic-instrumented.h:44 [inline]
>>  refcount_set include/linux/refcount.h:123 [inline]
>>  refcount_warn_saturate+0x1f/0x1f0 lib/refcount.c:15
>>  refcount_sub_and_test include/linux/refcount.h:261 [inline]
>>  refcount_dec_and_test include/linux/refcount.h:281 [inline]
>>  kref_put include/linux/kref.h:64 [inline]
>>  l2cap_chan_put+0x1d9/0x240 net/bluetooth/l2cap_core.c:498
>>  do_enable_set+0x54b/0x960 net/bluetooth/6lowpan.c:1075
>>  process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
>>  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>>  kthread+0x361/0x430 kernel/kthread.c:255
>>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>>
>> Allocated by task 2888:
>>  save_stack+0x23/0x90 mm/kasan/common.c:72
>>  set_track mm/kasan/common.c:80 [inline]
>>  __kasan_kmalloc mm/kasan/common.c:515 [inline]
>>  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
>>  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
>>  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
>>  kmalloc include/linux/slab.h:555 [inline]
>>  kzalloc include/linux/slab.h:669 [inline]
>>  l2cap_chan_create+0x45/0x3a0 net/bluetooth/l2cap_core.c:446
>>  chan_create+0x10/0xe0 net/bluetooth/6lowpan.c:640
>>  bt_6lowpan_listen net/bluetooth/6lowpan.c:959 [inline]
>>  do_enable_set+0x583/0x960 net/bluetooth/6lowpan.c:1078
>>  process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
>>  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>>  kthread+0x361/0x430 kernel/kthread.c:255
>>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>>
>> Freed by task 2975:
>>  save_stack+0x23/0x90 mm/kasan/common.c:72
>>  set_track mm/kasan/common.c:80 [inline]
>>  kasan_set_free_info mm/kasan/common.c:337 [inline]
>>  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
>>  kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
>>  __cache_free mm/slab.c:3426 [inline]
>>  kfree+0x10a/0x2c0 mm/slab.c:3757
>>  l2cap_chan_destroy net/bluetooth/l2cap_core.c:484 [inline]
>>  kref_put include/linux/kref.h:65 [inline]
>>  l2cap_chan_put+0x1b7/0x240 net/bluetooth/l2cap_core.c:498
>>  do_enable_set+0x54b/0x960 net/bluetooth/6lowpan.c:1075
>>  process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
>>  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>>  kthread+0x361/0x430 kernel/kthread.c:255
>>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> 
> The free and use-after-free are both via the same do_enable_set() path
> which implies there are racing writes to the debugfs write handler. It
> seems locking is missing for both listen_chan and enable_6lowpan. The
> latter seems misused in is_bt_6lowpan(), which should likely just be
> checking for chan->ops == &bt_6lowpan_chan_ops, I think?
> 
> I have no way to actually test changes to this code...
> 

I do have limited hardware for testing bluetooth 6lowpan connections,
but am a little busy these weeks. So some time by the end of this month
I should be able to at least verify if my use-case would be broken by a
change, if somebody were to propose one ;)

br
Josua Mayer
