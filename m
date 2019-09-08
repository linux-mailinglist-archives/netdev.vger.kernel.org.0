Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1BACA4A
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 03:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391382AbfIHB7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 21:59:09 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:41194 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388555AbfIHB7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 21:59:08 -0400
Received: by mail-io1-f70.google.com with SMTP id t8so13063852iom.8
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 18:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rXKs9yhAL+cLtDNzcYNrqbpngd8N+DJ3APnXTX48uH8=;
        b=mOX2vFelTbntot9CxF+/mX6iYrYJeuMdAKGt6Uecwb6bnu+C+yv6FwSI9qoiTPSxlU
         /R3JLPQ/3Ay1Q5IjrspIETRdaDfZUHvXc1/Ax1JY8fJdYTrhvNx2mUINgKwL0vFgijz6
         tIqBfme/ppCsIr7JVIunPhOAiYw+ZKLIDv+xZMeJoSGjx8yaSVx+7JFXw1aaKxjH7Y6a
         fXypCbZ2axaliz8xaEyakOiJzNMNDfDWXWYgifZ3A2t0EJVjWokLQmAkBJ3Znszwxno5
         Chhjg6fbQtF+hjwXczJloKWr08lW24+FiNFUlkoOzJGSs1TsESdxIRUkihGQkeFuJuXK
         Zodg==
X-Gm-Message-State: APjAAAUTBQ9yRObboncy4bMLvT7xQQ5ojZorQkU1o1y4kGDHzsFM+ZS4
        bS4uU8ZnQDqkHnacDI5M6CI4qXBszXaZYn5LGPDVzbu2bn7J
X-Google-Smtp-Source: APXvYqyN1zQ0hsIlmiKdinW/dtYs2rMpdVgFIoL09fkmJzKYJYJ3ntfObYT0u6rGFcEetLfFE/OpRJffdTMV+hFjyrkt9UuxQu0C
MIME-Version: 1.0
X-Received: by 2002:a05:6638:6b2:: with SMTP id d18mr18383931jad.61.1567907946584;
 Sat, 07 Sep 2019 18:59:06 -0700 (PDT)
Date:   Sat, 07 Sep 2019 18:59:06 -0700
In-Reply-To: <0000000000005091a70591d3e1d9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032650c0592010449@google.com>
Subject: Re: general protection fault in dev_map_hash_update_elem
From:   syzbot <syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com>
To:     alexei.starovoitov@gmail.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, jbrouer@redhat.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        toke@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    a2c11b03 kcm: use BPF_PROG_RUN
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d46ec1600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf0c85d15c20ade3
dashboard link: https://syzkaller.appspot.com/bug?extid=4e7a85b1432052e8d6f8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1220b2d1600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1360b26e600000

Bisection is inconclusive: the first bad commit could be any of:

116e7dbe Merge branch 'gen-syn-cookie'
91bc3578 selftests/bpf: add test for bpf_tcp_gen_syncookie
637f71c0 selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
bf8ff0f8 selftests/bpf: fix clearing buffered output between tests/subtests
3745ee18 bpf: sync bpf.h to tools/
a98bf573 tools: bpftool: add support for reporting the effective cgroup  
progs
70d66244 bpf: add bpf_tcp_gen_syncookie helper
9babe825 bpf: always allocate at least 16 bytes for setsockopt hook
9349d600 tcp: add skb-less helpers to retrieve SYN cookie
fd5ef31f selftests/bpf: extend sockopt_sk selftest with TCP_CONGESTION use  
case
02bc2b64 Merge branch 'setsockopt-extra-mem'
96511278 tcp: tcp_syn_flood_action read port from socket
a78d0dbe selftests/bpf: add loop test 4
d3406913 Merge branch 'devmap_hash'
1375dc4a tools: Add definitions for devmap_hash map type
8c303960 selftests/bpf: add loop test 5
946152b3 selftests/bpf: test_progs: switch to open_memstream
e4234619 tools/libbpf_probes: Add new devmap_hash type
10fbe211 tools/include/uapi: Add devmap_hash BPF map type
66bd2ec1 selftests/bpf: test_progs: test__printf -> printf
16e910d4 selftests/bpf: test_progs: drop extra trailing tab
6f9d451a xdp: Add devmap_hash map type for looking up devices by hashed  
index
682cdbdc Merge branch 'test_progs-stdio'
fca16e51 xdp: Refactor devmap allocation code for reuse
6dbff13c include/bpf.h: Remove map_insert_ctx() stubs
ef20a9b2 libbpf: add helpers for working with BTF types
475e31f8 Merge branch 'revamp-test_progs'
b03bc685 libbpf: convert libbpf code to use new btf helpers
4cedc0da libbpf: add .BTF.ext offset relocation section loading
b207edfe selftests/bpf: convert send_signal.c to use subtests
51436ed7 selftests/bpf: convert bpf_verif_scale.c to sub-tests API
ddc7c304 libbpf: implement BPF CO-RE offset relocation algorithm
2dc26d5a selftests/bpf: add BPF_CORE_READ relocatable read macro
3a516a0a selftests/bpf: add sub-tests support for test_progs
0ff97e56 selftests/bpf: abstract away test log output
df36e621 selftests/bpf: add CO-RE relocs testing setup
002d3afc selftests/bpf: add CO-RE relocs struct flavors tests
329e38f7 selftest/bpf: centralize libbpf logging management for test_progs
e87fd8ba libbpf: return previous print callback from libbpf_set_print
ec6438a9 selftests/bpf: add CO-RE relocs nesting tests
20a9ad2e selftests/bpf: add CO-RE relocs array tests
8160bae2 selftests/bpf: add test selectors by number and name to test_progs
766f2a59 selftests/bpf: revamp test_progs to allow more control
d9db3550 selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
61098e89 selftests/bpf: prevent headers to be compiled as C code
9654e2ae selftests/bpf: add CO-RE relocs modifiers/typedef tests
943e398d Merge branch 'flow_dissector-input-flags'
d698f9db selftests/bpf: add CO-RE relocs ptr-as-array tests
c1f5e7dd selftests/bpf: add CO-RE relocs ints tests
e853ae77 selftests/bpf: support BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP
29e1c668 selftests/bpf: add CO-RE relocs misc tests
71c99e32 bpf/flow_dissector: support ipv6 flow_label and  
BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
726e333f Merge branch 'compile-once-run-everywhere'
ae173a91 selftests/bpf: support BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG
57debff2 tools/bpf: sync bpf_flow_keys flags
b7076592 tools/bpf: fix core_reloc.c compilation error
b2ca4e1c bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
d9973cec xdp: xdp_umem: fix umem pages mapping for 32bits systems
1ac6b126 bpf/flow_dissector: document flags
3783d437 samples/bpf: xdp_fwd rename devmap name to be xdp_tx_ports
086f9568 bpf/flow_dissector: pass input flags to BPF flow dissector program
a32a32cb samples/bpf: make xdp_fwd more practically usable via devmap lookup
03cd1d1a selftests/bpf: Add selftests for bpf_perf_event_output
abcce733 samples/bpf: xdp_fwd explain bpf_fib_lookup return codes
7c4b90d7 bpf: Allow bpf_skb_event_output for a few prog types
9f30cd56 Merge branch 'bpf-xdp-fwd-sample-improvements'
5e31d507 Merge branch 'convert-tests-to-libbpf'
a664a834 tools: bpftool: fix reading from /proc/config.gz
341dfcf8 btf: expose BTF info through sysfs
47da6e4d selftests/bpf: remove perf buffer helpers
c17bec54 samples/bpf: switch trace_output sample to perf_buffer API
d66fa3c7 tools: bpftool: add feature check for zlib
9840a4ff selftests/bpf: fix race in flow dissector tests
f58a4d51 samples/bpf: convert xdp_sample_pkts_user to perf_buffer API
7fd78568 btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux
898ca681 selftests/bpf: switch test_tcpnotify to perf_buffer API
58b80815 selftests/bpf: convert test_get_stack_raw_tp to perf_buffer API
a1916a15 libbpf: attempt to load kernel BTF from sysfs first
72ef80b5 Merge branch 'bpf-libbpf-read-sysfs-btf'
f2a3e4e9 libbpf: provide more helpful message on uninitialized global var
708852dc Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1130846e600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 10210 Comm: syz-executor910 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__write_once_size include/linux/compiler.h:226 [inline]
RIP: 0010:__hlist_del include/linux/list.h:762 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:455 [inline]
RIP: 0010:__dev_map_hash_update_elem kernel/bpf/devmap.c:668 [inline]
RIP: 0010:dev_map_hash_update_elem+0x3c8/0x6e0 kernel/bpf/devmap.c:691
Code: 48 89 f1 48 89 75 c8 48 c1 e9 03 80 3c 11 00 0f 85 d3 02 00 00 48 b9  
00 00 00 00 00 fc ff df 48 8b 53 10 48 89 d6 48 c1 ee 03 <80> 3c 0e 00 0f  
85 97 02 00 00 48 85 c0 48 89 02 74 38 48 89 55 b8
RSP: 0018:ffff88808c757c30 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8880a216a980 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a216a988
RBP: ffff88808c757c78 R08: 0000000000000004 R09: ffffed10118eaf73
R10: ffffed10118eaf72 R11: 0000000000000003 R12: ffff88808c7fb2c0
R13: ffff88808aa98800 R14: 0000000000000000 R15: ffff88808c7fb3e8
FS:  00007fd4c5528700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff47596210 CR3: 000000008b442000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  map_update_elem+0xc82/0x10b0 kernel/bpf/syscall.c:966
  __do_sys_bpf+0x8b5/0x3350 kernel/bpf/syscall.c:2854
  __se_sys_bpf kernel/bpf/syscall.c:2825 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2825
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446a29
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd4c5527db8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446a29
RDX: 0000000000000020 RSI: 0000000020000180 RDI: 0000000000000002
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 00007fff4759618f R14: 00007fd4c55289c0 R15: 0000000000000000
Modules linked in:
---[ end trace 9a6d00abce3fe1c8 ]---
RIP: 0010:__write_once_size include/linux/compiler.h:226 [inline]
RIP: 0010:__hlist_del include/linux/list.h:762 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:455 [inline]
RIP: 0010:__dev_map_hash_update_elem kernel/bpf/devmap.c:668 [inline]
RIP: 0010:dev_map_hash_update_elem+0x3c8/0x6e0 kernel/bpf/devmap.c:691
Code: 48 89 f1 48 89 75 c8 48 c1 e9 03 80 3c 11 00 0f 85 d3 02 00 00 48 b9  
00 00 00 00 00 fc ff df 48 8b 53 10 48 89 d6 48 c1 ee 03 <80> 3c 0e 00 0f  
85 97 02 00 00 48 85 c0 48 89 02 74 38 48 89 55 b8
RSP: 0018:ffff88808c757c30 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8880a216a980 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a216a988
RBP: ffff88808c757c78 R08: 0000000000000004 R09: ffffed10118eaf73
R10: ffffed10118eaf72 R11: 0000000000000003 R12: ffff88808c7fb2c0
R13: ffff88808aa98800 R14: 0000000000000000 R15: ffff88808c7fb3e8
FS:  00007fd4c5528700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff47596210 CR3: 000000008b442000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

