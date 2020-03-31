Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF5B199BC1
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgCaQhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:37:16 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40963 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaQhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:37:16 -0400
Received: by mail-vs1-f67.google.com with SMTP id a63so13873330vsa.8;
        Tue, 31 Mar 2020 09:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxMrX2fU50llL8Gol6ypab4+Z8339iXLa0polzphaRs=;
        b=sZcVztJ/GKyFtVF2948VMs91x0fR2v92fnfKmNFBokxemDULgmASyXcTrMQVJjdPl+
         T7xYj5jLwnYc++3236U8opdm4ZV9oHGvpm/tfDrslcX/5sohQpjwv2XB6o81aJx+ffBN
         vCNzCcIxUHVUKcSv4d4N6sSW/QwS0bZq+YwgvRsyPsaBnnXvk7k+yD31GvwN3+94Cx8M
         54blJvMeCK9Y2dY0I39AEqAFUopZfIXZjKYeoH8Ay05Bm9ug7NArHyoCfuDUt5+KhBj2
         jjqMWGIJ5zS28YHTl298HmNbN/J73xtVn9jbpwe07+08rnhGyqrFtWj9GjLm0pqh7ljp
         rIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxMrX2fU50llL8Gol6ypab4+Z8339iXLa0polzphaRs=;
        b=OOzM3VzSRUrgkNsWyosHU8UGBVlezIJxsIVeiuofdNqCOMPZRP3GvPod+tfTam3mBp
         gITJaHXPaoyeyZfJkhjOi9Cgi/huBzMJclDUN8euxct4R6NU2YxloJjhiZ9lQkv7fAlJ
         8zWC5lpWY1EF4otW1R8Z14V1TFonS80ctRZ4ppri/w5V9fh3saeZg3Efoo45M+vOVMS1
         90VgnPda+rzdUo/SpJg4x4sQZLRuQOlj6WfBYsnSa0wdKxK8FX3bowZq2S6gXLNUK7XG
         JU/+ja8+C+r4PDu1BGjCXx8tRpNcgb/DoDH2CEFmTgCXJ+qq6q43GwyXwMGv04jbEBeq
         aJ2g==
X-Gm-Message-State: AGi0PubQ9Gr3JcA++9qNsACLoDksgSJ8SWizF841jg6h91p76Wysz6VV
        RwijfuHYfNnCumJLURoB076YLi+WVZg+6LY1rfY=
X-Google-Smtp-Source: APiQypKHv+9X2OTsYBe3eLy+ziR1sPmaNg19WSifhwYMJsAPr5Rv1sclFjIv79Y5n6QwzQesW8yPNSb/zQbBnhiF0+g=
X-Received: by 2002:a67:3201:: with SMTP id y1mr14067732vsy.54.1585672632268;
 Tue, 31 Mar 2020 09:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006ac55b05a1c05d72@google.com>
In-Reply-To: <0000000000006ac55b05a1c05d72@google.com>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Wed, 1 Apr 2020 00:36:54 +0800
Message-ID: <CADG63jCwP1D3dBRFTB6FXePD6ys5n1j+1=JrkJjZXC80eKLehQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in ath9k_htc_rx_msg
To:     syzbot <syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: multipart/mixed; boundary="000000000000fa224d05a2292d01"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000fa224d05a2292d01
Content-Type: text/plain; charset="UTF-8"

#syz test: https://github.com/google/kasan.git usb-fuzzer

On Thu, Mar 26, 2020 at 7:35 PM syzbot
<syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    e17994d1 usb: core: kcov: collect coverage from usb comple..
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=13a40c13e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
> dashboard link: https://syzkaller.appspot.com/bug?extid=b1c61e5f11be5782f192
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13790f73e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ebae75e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
> BUG: KASAN: use-after-free in ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
> Write of size 2 at addr ffff8881cea291f0 by task swapper/1/0
>
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
>  __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:641
>  htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
>  ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
>  ath9k_hif_usb_reg_in_cb+0x1ba/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:718
>  __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>  usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>  dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>  call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>  expire_timers kernel/time/timer.c:1449 [inline]
>  __run_timers kernel/time/timer.c:1773 [inline]
>  __run_timers kernel/time/timer.c:1740 [inline]
>  run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>  __do_softirq+0x21e/0x950 kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x178/0x1a0 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>  smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:default_idle+0x28/0x300 arch/x86/kernel/process.c:696
> Code: cc cc 41 56 41 55 65 44 8b 2d 44 77 72 7a 41 54 55 53 0f 1f 44 00 00 e8 b6 62 b5 fb e9 07 00 00 00 0f 00 2d ea 0c 53 00 fb f4 <65> 44 8b 2d 20 77 72 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
> RSP: 0018:ffff8881da22fda8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000007 RBX: ffff8881da213100 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da21394c
> RBP: ffffed103b442620 R08: ffff8881da213100 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000001 R14: ffffffff87e607c0 R15: 0000000000000000
>  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
>  do_idle+0x3e0/0x500 kernel/sched/idle.c:269
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
>  start_secondary+0x2a4/0x390 arch/x86/kernel/smpboot.c:264
>  secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242
>
> Allocated by task 371:
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  __kasan_kmalloc mm/kasan/common.c:515 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
>  kmalloc include/linux/slab.h:560 [inline]
>  raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:556 [inline]
>  raw_alloc_io_data+0x150/0x1c0 drivers/usb/gadget/legacy/raw_gadget.c:538
>  raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:657 [inline]
>  raw_ioctl+0x686/0x1a70 drivers/usb/gadget/legacy/raw_gadget.c:1035
>  vfs_ioctl fs/ioctl.c:47 [inline]
>  ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
>  __do_sys_ioctl fs/ioctl.c:772 [inline]
>  __se_sys_ioctl fs/ioctl.c:770 [inline]
>  __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
>  do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 371:
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  kasan_set_free_info mm/kasan/common.c:337 [inline]
>  __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
>  slab_free_hook mm/slub.c:1444 [inline]
>  slab_free_freelist_hook mm/slub.c:1477 [inline]
>  slab_free mm/slub.c:3024 [inline]
>  kfree+0xd5/0x300 mm/slub.c:3976
>  raw_ioctl_ep_read drivers/usb/gadget/legacy/raw_gadget.c:961 [inline]
>  raw_ioctl+0x189/0x1a70 drivers/usb/gadget/legacy/raw_gadget.c:1047
>  vfs_ioctl fs/ioctl.c:47 [inline]
>  ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
>  __do_sys_ioctl fs/ioctl.c:772 [inline]
>  __se_sys_ioctl fs/ioctl.c:770 [inline]
>  __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
>  do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8881cea29000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 496 bytes inside of
>  2048-byte region [ffff8881cea29000, ffff8881cea29800)
> The buggy address belongs to the page:
> page:ffffea00073a8a00 refcount:1 mapcount:0 mapping:ffff8881da00c000 index:0x0 compound_mapcount: 0
> flags: 0x200000000010200(slab|head)
> raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da00c000
> raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8881cea29080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881cea29100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8881cea29180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                              ^
>  ffff8881cea29200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881cea29280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

--000000000000fa224d05a2292d01
Content-Type: application/octet-stream; 
	name="0001-ath9k-fix-use-after-free-read-in-htc_connect_service.patch"
Content-Disposition: attachment; 
	filename="0001-ath9k-fix-use-after-free-read-in-htc_connect_service.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8g4j23m0>
X-Attachment-Id: f_k8g4j23m0

RnJvbSBmODQ2MWViZWVlZTEwYjc3ZTA0ZGFhYWNhYWJlZThlMWM3MDk5MzVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBRaXVqdW4gSHVhbmcgPGhxamFnYWluQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAzMSBNYXIgMjAyMCAyMDoxODo1NiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGF0aDlr
OiBmaXggdXNlLWFmdGVyLWZyZWUgcmVhZCBpbiBodGNfY29ubmVjdF9zZXJ2aWNlCgooMSlUaGUg
c2tiIGlzIGNvbnN1bWVkIGJ5IGF0aDlrX2h0Y190eGNvbXBsZXRpb25fY2IuCigyKWZyZWUgd21p
IGxhdGVyIGFmdGVyIHVyYiBoYXMgYmVlbiBraWxsZWQuCgpTaWduZWQtb2ZmLWJ5OiBRaXVqdW4g
SHVhbmcgPGhxamFnYWluQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoOWsvaGlmX3VzYi5jICAgICAgfCAgMyArKy0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGg5ay9odGNfZHJ2X2luaXQuYyB8ICAyICstCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
OWsvaHRjX2hzdC5jICAgICAgfCAgMSAtCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
d21pLmMgICAgICAgICAgfCAxNCArKysrKysrKysrKysrKwogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDlrL3dtaS5oICAgICAgICAgIHwgIDIgKysKIDUgZmlsZXMgY2hhbmdlZCwgMTkgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKIG1vZGUgY2hhbmdlIDEwMDY0NCA9PiAxMDA3NTUg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3dtaS5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2hpZl91c2IuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9oaWZfdXNiLmMKaW5kZXggZGQwYzMyMzc5Mzc1Li45ZmMyN2MxM2Q3YjUgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9oaWZfdXNiLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2hpZl91c2IuYwpAQCAtMTM0MSw4ICsxMzQx
LDkgQEAgc3RhdGljIHZvaWQgYXRoOWtfaGlmX3VzYl9kaXNjb25uZWN0KHN0cnVjdCB1c2JfaW50
ZXJmYWNlICppbnRlcmZhY2UpCiAKIAlpZiAoaGlmX2Rldi0+ZmxhZ3MgJiBISUZfVVNCX1JFQURZ
KSB7CiAJCWF0aDlrX2h0Y19od19kZWluaXQoaGlmX2Rldi0+aHRjX2hhbmRsZSwgdW5wbHVnZ2Vk
KTsKLQkJYXRoOWtfaHRjX2h3X2ZyZWUoaGlmX2Rldi0+aHRjX2hhbmRsZSk7CiAJCWF0aDlrX2hp
Zl91c2JfZGV2X2RlaW5pdChoaWZfZGV2KTsKKwkJYXRoOWtfZGVzdG95X3dtaShoaWZfZGV2LT5o
dGNfaGFuZGxlLT5kcnZfcHJpdik7CisJCWF0aDlrX2h0Y19od19mcmVlKGhpZl9kZXYtPmh0Y19o
YW5kbGUpOwogCX0KIAogCXVzYl9zZXRfaW50ZmRhdGEoaW50ZXJmYWNlLCBOVUxMKTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9odGNfZHJ2X2luaXQuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9odGNfZHJ2X2luaXQuYwppbmRleCBkOTYxMDk1
YWIwMWYuLmQxZDBlZDZlNjUzYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL2h0Y19kcnZfaW5pdC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5
ay9odGNfZHJ2X2luaXQuYwpAQCAtOTgyLDcgKzk4Miw3IEBAIHZvaWQgYXRoOWtfaHRjX2Rpc2Nv
bm5lY3RfZGV2aWNlKHN0cnVjdCBodGNfdGFyZ2V0ICpodGNfaGFuZGxlLCBib29sIGhvdHVucGx1
ZykKIAkJCWh0Y19oYW5kbGUtPmRydl9wcml2LT5haC0+YWhfZmxhZ3MgfD0gQUhfVU5QTFVHR0VE
OwogCiAJCWF0aDlrX2RlaW5pdF9kZXZpY2UoaHRjX2hhbmRsZS0+ZHJ2X3ByaXYpOwotCQlhdGg5
a19kZWluaXRfd21pKGh0Y19oYW5kbGUtPmRydl9wcml2KTsKKwkJYXRoOWtfc3RvcF93bWkoaHRj
X2hhbmRsZS0+ZHJ2X3ByaXYpOwogCQlpZWVlODAyMTFfZnJlZV9odyhodGNfaGFuZGxlLT5kcnZf
cHJpdi0+aHcpOwogCX0KIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGg5ay9odGNfaHN0LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2hzdC5j
CmluZGV4IGQwOTFjOGViZGNmMC4uMDE4ODk4MDcwNjY5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2hzdC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9odGNfaHN0LmMKQEAgLTI3OSw3ICsyNzksNiBAQCBpbnQgaHRjX2Nvbm5lY3Rf
c2VydmljZShzdHJ1Y3QgaHRjX3RhcmdldCAqdGFyZ2V0LAogCWlmICghdGltZV9sZWZ0KSB7CiAJ
CWRldl9lcnIodGFyZ2V0LT5kZXYsICJTZXJ2aWNlIGNvbm5lY3Rpb24gdGltZW91dCBmb3I6ICVk
XG4iLAogCQkJc2VydmljZV9jb25ucmVxLT5zZXJ2aWNlX2lkKTsKLQkJa2ZyZWVfc2tiKHNrYik7
CiAJCXJldHVybiAtRVRJTUVET1VUOwogCX0KIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDlrL3dtaS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3dt
aS5jCmluZGV4IGNkYzE0NjA5MTE5NC4uOTRmOTU2NzZlMDJjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoOWsvd21pLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDlrL3dtaS5jCkBAIC0xMjMsNiArMTIzLDIwIEBAIHZvaWQgYXRoOWtfZGVpbml0X3dt
aShzdHJ1Y3QgYXRoOWtfaHRjX3ByaXYgKnByaXYpCiAJa2ZyZWUocHJpdi0+d21pKTsKIH0KIAor
dm9pZCBhdGg5a19zdG9wX3dtaShzdHJ1Y3QgYXRoOWtfaHRjX3ByaXYgKnByaXYpCit7CisJc3Ry
dWN0IHdtaSAqd21pID0gcHJpdi0+d21pOworCQorCW11dGV4X2xvY2soJndtaS0+b3BfbXV0ZXgp
OworCXdtaS0+c3RvcHBlZCA9IHRydWU7CisJbXV0ZXhfdW5sb2NrKCZ3bWktPm9wX211dGV4KTsK
K30KKwordm9pZCBhdGg5a19kZXN0b3lfd21pKHN0cnVjdCBhdGg5a19odGNfcHJpdiAqcHJpdikK
K3sKKwlrZnJlZShwcml2LT53bWkpOworfQorCiB2b2lkIGF0aDlrX3dtaV9ldmVudF9kcmFpbihz
dHJ1Y3QgYXRoOWtfaHRjX3ByaXYgKnByaXYpCiB7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay93bWkuaCBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay93bWkuaApvbGQgbW9kZSAxMDA2NDQKbmV3IG1vZGUgMTAw
NzU1CmluZGV4IDM4MDE3NWQ1ZWNkNy4uYzNlMjc4Mzc3MzY1Ci0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGg5ay93bWkuaAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
OWsvd21pLmgKQEAgLTE4OSw2ICsxODksOCBAQCBpbnQgYXRoOWtfd21pX2NtZChzdHJ1Y3Qgd21p
ICp3bWksIGVudW0gd21pX2NtZF9pZCBjbWRfaWQsCiB2b2lkIGF0aDlrX3dtaV9ldmVudF90YXNr
bGV0KHVuc2lnbmVkIGxvbmcgZGF0YSk7CiB2b2lkIGF0aDlrX2ZhdGFsX3dvcmsoc3RydWN0IHdv
cmtfc3RydWN0ICp3b3JrKTsKIHZvaWQgYXRoOWtfd21pX2V2ZW50X2RyYWluKHN0cnVjdCBhdGg5
a19odGNfcHJpdiAqcHJpdik7Cit2b2lkIGF0aDlrX3N0b3Bfd21pKHN0cnVjdCBhdGg5a19odGNf
cHJpdiAqcHJpdik7Cit2b2lkIGF0aDlrX2Rlc3RveV93bWkoc3RydWN0IGF0aDlrX2h0Y19wcml2
ICpwcml2KTsKIAogI2RlZmluZSBXTUlfQ01EKF93bWlfY21kKQkJCQkJCVwKIAlkbyB7CQkJCQkJ
CQlcCi0tIAoyLjE3LjEKCg==
--000000000000fa224d05a2292d01--
