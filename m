Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A585194359
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgCZPiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:38:46 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:39183 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgCZPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:38:45 -0400
Received: by mail-vs1-f67.google.com with SMTP id j128so4115779vsd.6;
        Thu, 26 Mar 2020 08:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HvMnncn1TWI1BUA76/imMhrXXc8pw/VrjlqspT0N78w=;
        b=D+6LFS+Zf421ZeDTXPAV8XjVrApEykCv115uEY7z4mgvXJZkSfeb/tRNFie/Yo2zYy
         O+gqEE1+JiB7/8NTnLZ1KdTUdGWdCQz49gmszFXMAlx+rKi5NKZaFOkJHT+W3mOgxPvG
         RZsrz1lYDHeEuGkaaT5XiXzLDQUpiYyhYf8PvFDD1R7TlSBKytrIh8EjAen8j94k97Ll
         JZkXWAc4wqx0RzomgiFTnkk1LSB4dhWrNGao2Sk4Rvmr2U0PF0edCI3jA8UBQhGgKGKo
         zzsWN9umz5+Ew7y5JjjUoqUjwqI2Y+8BznpIQUWq99veNWqwAN14AfYrD2NxOMUWn9Dl
         u8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HvMnncn1TWI1BUA76/imMhrXXc8pw/VrjlqspT0N78w=;
        b=tCQ/4dPzXvhNN7OP0n/LDVa34Q/t6KaK7LqE39xeHP6dT8CAILracWPl7R8D1ttwZ0
         +VlK+vuTxF3kOL8PdTtfRYeUaU6nUg6rbqau0lDf7zDff+LA9+ya9h1nKDrsryQFv33T
         gEJeBxC/8RqfZvGprAAj7URCQEJM0Tz6UDF8V+MbRdNYrszUTSapeQNB/wZvP9o0/LtD
         HZV18l/+UKkxMgqmo8L0yujq1CKoaX5MilZKQeoAx4iTes1SA44MVwPJlARB3JWLVwZN
         vvD1WRnKcgryATdKJinYliSoa+pRno1YMw7EeFx4KzBZthN3EIK7rpHnM0j4U0RLvZS2
         0iSw==
X-Gm-Message-State: ANhLgQ0HAQTWSQbfC2sZZ2K9qfTTHOXZYDeIu5WDvukg+6nthUt4xIVR
        C6F3pgEo/XoCb8Dq8fmKvbrZBXQkQl5GwW0swFs=
X-Google-Smtp-Source: ADFU+vsfXmR2Mp3IYPyqU7Uqk4xBGVGG7+PwXLTwdGsctT/9BmD13neKqizcXgT5s4AxpZKa8tum8JMuoMMXbKH0Zp4=
X-Received: by 2002:a05:6102:a01:: with SMTP id t1mr7272108vsa.108.1585237123616;
 Thu, 26 Mar 2020 08:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Thu, 26 Mar 2020 23:38:32 +0800
Message-ID: <CADG63jDCTdgSxDRsN_9e3fKCAv5VduS5NNKWmqjByZ=4sT+HLQ@mail.gmail.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
To:     syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        vyasevich@gmail.com
Content-Type: multipart/mixed; boundary="000000000000a383e705a1c3c7b6"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a383e705a1c3c7b6
Content-Type: text/plain; charset="UTF-8"

#syz test: upstream

On Tue, Mar 10, 2020 at 9:36 AM syzbot
<syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    2c523b34 Linux 5.6-rc5
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=155a5f29e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
> dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164b5181e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166dd70de00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 1 PID: 8668 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 8668 Comm: syz-executor779 Not tainted 5.6.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1e9/0x30e lib/dump_stack.c:118
>  panic+0x264/0x7a0 kernel/panic.c:221
>  __warn+0x209/0x210 kernel/panic.c:582
>  report_bug+0x1ac/0x2d0 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> Code: c7 e4 ff d0 88 31 c0 e8 23 20 b3 fd 0f 0b eb 85 e8 8a 4a e0 fd c6 05 ff 70 b1 05 01 48 c7 c7 10 00 d1 88 31 c0 e8 05 20 b3 fd <0f> 0b e9 64 ff ff ff e8 69 4a e0 fd c6 05 df 70 b1 05 01 48 c7 c7
> RSP: 0018:ffffc90001f577d0 EFLAGS: 00010246
> RAX: 8c9c9070bbb4e500 RBX: 0000000000000003 RCX: ffff8880938a63c0
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: ffffffff815e16e6 R09: fffffbfff15db92a
> R10: fffffbfff15db92a R11: 0000000000000000 R12: dffffc0000000000
> R13: ffff88809de82000 R14: ffff8880a89237c0 R15: 1ffff11013be52b0
>  sctp_wfree+0x3b1/0x710 net/sctp/socket.c:9111
>  skb_release_head_state+0xfb/0x210 net/core/skbuff.c:651
>  skb_release_all net/core/skbuff.c:662 [inline]
>  __kfree_skb+0x22/0x1c0 net/core/skbuff.c:678
>  sctp_chunk_destroy net/sctp/sm_make_chunk.c:1454 [inline]
>  sctp_chunk_put+0x17b/0x200 net/sctp/sm_make_chunk.c:1481
>  __sctp_outq_teardown+0x80a/0x9d0 net/sctp/outqueue.c:257
>  sctp_association_free+0x21e/0x7c0 net/sctp/associola.c:339
>  sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:930 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1318 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
>  sctp_do_sm+0x3c01/0x5560 net/sctp/sm_sideeffect.c:1156
>  sctp_primitive_ABORT+0x93/0xc0 net/sctp/primitive.c:104
>  sctp_close+0x231/0x770 net/sctp/socket.c:1512
>  inet_release+0x135/0x180 net/ipv4/af_inet.c:427
>  __sock_release net/socket.c:605 [inline]
>  sock_close+0xd8/0x260 net/socket.c:1283
>  __fput+0x2d8/0x730 fs/file_table.c:280
>  task_work_run+0x176/0x1b0 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0x5ef/0x1f80 kernel/exit.c:801
>  do_group_exit+0x15e/0x2c0 kernel/exit.c:899
>  __do_sys_exit_group+0x13/0x20 kernel/exit.c:910
>  __se_sys_exit_group+0x10/0x10 kernel/exit.c:908
>  __x64_sys_exit_group+0x37/0x40 kernel/exit.c:908
>  do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x43ef98
> Code: Bad RIP value.
> RSP: 002b:00007ffcc7e7c398 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ef98
> RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> RBP: 00000000004be7a8 R08: 00000000000000e7 R09: ffffffffffffffd0
> R10: 000000002059aff8 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000006d01a0 R14: 0000000000000000 R15: 0000000000000000
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
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

--000000000000a383e705a1c3c7b6
Content-Type: application/octet-stream; 
	name="0001-sctp-fix-refcount-bug-in-sctp_wfree.patch"
Content-Disposition: attachment; 
	filename="0001-sctp-fix-refcount-bug-in-sctp_wfree.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k88x8d1v0>
X-Attachment-Id: f_k88x8d1v0

RnJvbSA2NWY2MDBlODVhOGRjNmU2YmNiYWI2OWU0MTExZTgzMDQxZjIyYzMyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBRaXVqdW4gSHVhbmcgPGhxamFnYWluQGdtYWlsLmNvbT4KRGF0
ZTogVGh1LCAyNiBNYXIgMjAyMCAyMzoyMjozOCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHNjdHA6
IGZpeCByZWZjb3VudCBidWcgaW4gc2N0cF93ZnJlZQoKV2Ugc2hvdWxkIGl0ZXJhdGUgb3ZlciB0
aGUgZGF0YW1zZ3MgdG8gbW9kaWZ5CmFsbCBjaHVua3Moc2ticykgdG8gbmV3c2suCgpUaGUgZm9s
bG93aW5nIGNhc2UgY2F1c2UgdGhlIGJ1ZzoKZm9yIHRoZSB0cm91YmxlIFNLQiwgaXQgd2FzIGlu
IG91dHEtPnRyYW5zbWl0dGVkIGxpc3QKCnNjdHBfb3V0cV9zYWNrCiAgICAgICAgc2N0cF9jaGVj
a190cmFuc21pdHRlZAogICAgICAgICAgICAgICAgU0tCIHdhcyBtb3ZlZCB0byBvdXRxLT5zYWNr
ZWQgbGlzdAogICAgICAgIHRoZW4gdGhyb3cgYXdheSB0aGUgc2FjayBxdWV1ZQogICAgICAgICAg
ICAgICAgU0tCIHdhcyBkZWxldGVkIGZyb20gb3V0cS0+c2Fja2VkCihidXQgaXQgd2FzIGhlbGQg
YnkgZGF0YW1zZyBhdCBzY3RwX2RhdGFtc2dfdG9fYXNvYwpTbywgc2N0cF93ZnJlZSB3YXMgbm90
IGNhbGxlZCBoZXJlKQoKdGhlbiBtaWdyYXRlIGhhcHBlbmVkCgogICAgICAgIHNjdHBfZm9yX2Vh
Y2hfdHhfZGF0YWNodW5rKAogICAgICAgIHNjdHBfY2xlYXJfb3duZXJfdyk7CiAgICAgICAgc2N0
cF9hc3NvY19taWdyYXRlKCk7CiAgICAgICAgc2N0cF9mb3JfZWFjaF90eF9kYXRhY2h1bmsoCiAg
ICAgICAgc2N0cF9zZXRfb3duZXJfdyk7ClNLQiB3YXMgbm90IGluIHRoZSBvdXRxLCBhbmQgd2Fz
IG5vdCBjaGFuZ2VkIHRvIG5ld3NrCgpmaW5hbGx5CgpfX3NjdHBfb3V0cV90ZWFyZG93bgogICAg
ICAgIHNjdHBfY2h1bmtfcHV0IChmb3IgYW5vdGhlciBza2IpCiAgICAgICAgICAgICAgICBzY3Rw
X2RhdGFtc2dfcHV0CiAgICAgICAgICAgICAgICAgICAgICAgIF9fa2ZyZWVfc2tiKG1zZy0+ZnJh
Z19saXN0KQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNjdHBfd2ZyZWUgKGZvciBT
S0IpCglTS0ItPnNrIHdhcyBzdGlsbCBvbGRzayAoc2tiLT5zayAhPSBhc29jLT5iYXNlLnNrKS4K
ClJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6c3l6Ym90K2NlYTcxZWVjNWQ2ZGUyNTZkNTRkQHN5emth
bGxlci5hcHBzcG90bWFpbC5jb20KU2lnbmVkLW9mZi1ieTogUWl1anVuIEh1YW5nIDxocWphZ2Fp
bkBnbWFpbC5jb20+Ci0tLQogbmV0L3NjdHAvc29ja2V0LmMgfCAzMCArKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL25ldC9zY3RwL3NvY2tldC5jIGIvbmV0L3NjdHAvc29ja2V0
LmMKaW5kZXggMWI1NmZjNDQwNjA2Li43NWFjYmQ1ZDQ1OTcgMTAwNjQ0Ci0tLSBhL25ldC9zY3Rw
L3NvY2tldC5jCisrKyBiL25ldC9zY3RwL3NvY2tldC5jCkBAIC0xNDcsMjkgKzE0Nyw0MyBAQCBz
dGF0aWMgdm9pZCBzY3RwX2NsZWFyX293bmVyX3coc3RydWN0IHNjdHBfY2h1bmsgKmNodW5rKQog
CXNrYl9vcnBoYW4oY2h1bmstPnNrYik7CiB9CiAKKyNkZWZpbmUgdHJhdmVyc2VfYW5kX3Byb2Nl
c3MoKQlcCitkbyB7CQkJCVwKKwltc2cgPSBjaHVuay0+bXNnOwlcCisJaWYgKG1zZyA9PSBwcmV2
X21zZykJXAorCQljb250aW51ZTsJXAorCWxpc3RfZm9yX2VhY2hfZW50cnkoYywgJm1zZy0+Y2h1
bmtzLCBmcmFnX2xpc3QpIHsJXAorCQlpZiAoKGNsZWFyICYmIGFzb2MtPmJhc2Uuc2sgPT0gYy0+
c2tiLT5zaykgfHwJXAorCQkgICAgKCFjbGVhciAmJiBhc29jLT5iYXNlLnNrICE9IGMtPnNrYi0+
c2spKQlcCisJCSAgICBjYihjKTsJXAorCX0JCQlcCit9IHdoaWxlICgwKQorCiBzdGF0aWMgdm9p
ZCBzY3RwX2Zvcl9lYWNoX3R4X2RhdGFjaHVuayhzdHJ1Y3Qgc2N0cF9hc3NvY2lhdGlvbiAqYXNv
YywKKwkJCQkgICAgICAgYm9vbCBjbGVhciwKIAkJCQkgICAgICAgdm9pZCAoKmNiKShzdHJ1Y3Qg
c2N0cF9jaHVuayAqKSkKIAogeworCXN0cnVjdCBzY3RwX2RhdGFtc2cgKm1zZywgKnByZXZfbXNn
ID0gTlVMTDsKIAlzdHJ1Y3Qgc2N0cF9vdXRxICpxID0gJmFzb2MtPm91dHF1ZXVlOworCXN0cnVj
dCBzY3RwX2NodW5rICpjaHVuaywgKmM7CiAJc3RydWN0IHNjdHBfdHJhbnNwb3J0ICp0OwotCXN0
cnVjdCBzY3RwX2NodW5rICpjaHVuazsKIAogCWxpc3RfZm9yX2VhY2hfZW50cnkodCwgJmFzb2Mt
PnBlZXIudHJhbnNwb3J0X2FkZHJfbGlzdCwgdHJhbnNwb3J0cykKIAkJbGlzdF9mb3JfZWFjaF9l
bnRyeShjaHVuaywgJnQtPnRyYW5zbWl0dGVkLCB0cmFuc21pdHRlZF9saXN0KQotCQkJY2IoY2h1
bmspOworCQkJdHJhdmVyc2VfYW5kX3Byb2Nlc3MoKTsKIAogCWxpc3RfZm9yX2VhY2hfZW50cnko
Y2h1bmssICZxLT5yZXRyYW5zbWl0LCB0cmFuc21pdHRlZF9saXN0KQotCQljYihjaHVuayk7CisJ
CXRyYXZlcnNlX2FuZF9wcm9jZXNzKCk7CiAKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNodW5rLCAm
cS0+c2Fja2VkLCB0cmFuc21pdHRlZF9saXN0KQotCQljYihjaHVuayk7CisJCXRyYXZlcnNlX2Fu
ZF9wcm9jZXNzKCk7CiAKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNodW5rLCAmcS0+YWJhbmRvbmVk
LCB0cmFuc21pdHRlZF9saXN0KQotCQljYihjaHVuayk7CisJCXRyYXZlcnNlX2FuZF9wcm9jZXNz
KCk7CiAKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNodW5rLCAmcS0+b3V0X2NodW5rX2xpc3QsIGxp
c3QpCi0JCWNiKGNodW5rKTsKKwkJdHJhdmVyc2VfYW5kX3Byb2Nlc3MoKTsKIH0KIAogc3RhdGlj
IHZvaWQgc2N0cF9mb3JfZWFjaF9yeF9za2Ioc3RydWN0IHNjdHBfYXNzb2NpYXRpb24gKmFzb2Ms
IHN0cnVjdCBzb2NrICpzaywKQEAgLTk1NzQsOSArOTU4OCw5IEBAIHN0YXRpYyBpbnQgc2N0cF9z
b2NrX21pZ3JhdGUoc3RydWN0IHNvY2sgKm9sZHNrLCBzdHJ1Y3Qgc29jayAqbmV3c2ssCiAJICog
cGF0aHMgd29uJ3QgdHJ5IHRvIGxvY2sgaXQgYW5kIHRoZW4gb2xkc2suCiAJICovCiAJbG9ja19z
b2NrX25lc3RlZChuZXdzaywgU0lOR0xFX0RFUFRIX05FU1RJTkcpOwotCXNjdHBfZm9yX2VhY2hf
dHhfZGF0YWNodW5rKGFzc29jLCBzY3RwX2NsZWFyX293bmVyX3cpOworCXNjdHBfZm9yX2VhY2hf
dHhfZGF0YWNodW5rKGFzc29jLCB0cnVlLCBzY3RwX2NsZWFyX293bmVyX3cpOwogCXNjdHBfYXNz
b2NfbWlncmF0ZShhc3NvYywgbmV3c2spOwotCXNjdHBfZm9yX2VhY2hfdHhfZGF0YWNodW5rKGFz
c29jLCBzY3RwX3NldF9vd25lcl93KTsKKwlzY3RwX2Zvcl9lYWNoX3R4X2RhdGFjaHVuayhhc3Nv
YywgZmFsc2UsIHNjdHBfc2V0X293bmVyX3cpOwogCiAJLyogSWYgdGhlIGFzc29jaWF0aW9uIG9u
IHRoZSBuZXdzayBpcyBhbHJlYWR5IGNsb3NlZCBiZWZvcmUgYWNjZXB0KCkKIAkgKiBpcyBjYWxs
ZWQsIHNldCBSQ1ZfU0hVVERPV04gZmxhZy4KLS0gCjIuMTcuMQoK
--000000000000a383e705a1c3c7b6--
