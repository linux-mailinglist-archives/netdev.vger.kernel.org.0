Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5334E7A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfFDRLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:11:16 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:46237 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfFDRLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:11:16 -0400
Received: by mail-lj1-f169.google.com with SMTP id m15so12161296ljg.13
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=z3Rm1IpMxofWBAs0dWcXcdCgdxSDOtcPS5QrxRItya8=;
        b=Ilq8tkn7CHCeMmx2zlpnGUQ4icdjoRy50AQkTW2KEUtInTdwtO/4QTncqLJX3WGx7X
         ZR68AkKcQwMMUyc0XcoWPkASa7HiH9H7qdGIBF2STjPE4jNJtIiKInpAJx4wAvNYiqFl
         /qyW9mHs9tH8r77bqWbmxL4QTycEWUwXZsunjkokCRHw4kBHGxI4oc0lYxQILQZhKzZY
         wyBt/Vc/+Fr4hIU+ihbmZla9aMxBQjBiAF2KV+TiL4DjKIsar1FYt4p3Km8d9lHan2e2
         TpElPa0kkSw+B7msXbgvmldv+I82mjLs7x5lO4wo6TY5ON/tIWFHQN81VeV6FUaX8EdH
         QpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=z3Rm1IpMxofWBAs0dWcXcdCgdxSDOtcPS5QrxRItya8=;
        b=s8nhxMSKLR9s1MCyrkO0GUYIuz5wrCZ4fQPk0LqfXaLpIQeyeg8kZ1v4Yzl0+T+s+M
         z3Hr1ZohS8Z4qbxNm1p8GUE8S+Pk4gzlBGGnQuTanYZuE6tuuafx/bnAHSS3E4wTOhzT
         AE37Qc5xXCS/E67isXlLb5lL4VJyFhI04+GmjGlLISIcLOsXK6kWWZLa3bF2kaMEWH30
         7i1RodEMHajI1EReEWrbQmsgXTIk+u7yplaG9zaakjwpsS/lgkB3IQEAQUN+M4ZonQna
         rCWaryflcrovlLTxz95M20FMnaDqPnB2lFVpGGynJPHFNYHIPuz1zRriAuRfPIX2t5T9
         HdBw==
X-Gm-Message-State: APjAAAWvzGjeu5iip35DiVursVg3KCgwLjGWCJIANoVzmUAnTDopAzjB
        Dl3LwfKXNL1GykpJQawxPm/89BhIKh24thsZss+ZEIjUZrw=
X-Google-Smtp-Source: APXvYqz3uJSusB3UbNUsaNLHM20Sus+F+y35y3psENaO4fi/JFE9wq98I1WJfiLXNe+UU/4X0M15BMgOM/hLnGnZiGs=
X-Received: by 2002:a2e:90d1:: with SMTP id o17mr17835634ljg.187.1559668272703;
 Tue, 04 Jun 2019 10:11:12 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jun 2019 22:41:01 +0530
Message-ID: <CA+G9fYu1qT44USvLGed=K2F=x8NAh8sgosw5KrS=THhLsrcxtw@mail.gmail.com>
Subject: BUG: kernel NULL pointer dereference, address: 00000000: memcpy+0x1d/0x30
To:     Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Yonghong Song <yhs@fb.com>, alan.maguire@oracle.com,
        alexei.starovoitov@gmail.com
Cc:     lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running selftest bpf: test_maps the kernel BUG found on i386 kernel
running on x86_64 machine Linux version 5.2.0-rc3-next-20190604

Full test log can be found in the below link [1]

# helper_fill_hashmap(261)FAILfailed to create hashmap err Cannot
allocate memory, flags 0x0
to: create_hashmap #
# Fork 1024 tasks to 'test_update_delete'
1024: tasks_to #
# Fork 1024 tasks to 'test_update_delete'
1024: tasks_to #
# Fork 100 tasks to 'test_hashmap'
100: tasks_to #
# Fork 100 tasks to 'test_hashmap_percpu'
100: tasks_to #
# Fork 100 tasks to 'test_hashmap_sizes'
[   93.249753] BUG: kernel NULL pointer dereference, address: 00000000
[   93.256586] #PF: supervisor read access in kernel mode
[   93.261714] #PF: error_code(0x0000) - not-present page
[   93.266846] *pde = 00000000
[   93.269722] Oops: 0000 [#1] SMP
[   93.272859] CPU: 0 PID: 4354 Comm: test_sockmap Not tainted
5.2.0-rc3-next-20190604 #1
[   93.280763] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   93.288235] EIP: memcpy+0x1d/0x30
[   93.291547] Code: 59 58 eb 85 90 90 90 90 90 90 90 90 90 3e 8d 74
26 00 55 89 e5 57 56 89 c7 53 89 d6 89 cb c1 e9 02 f3 a5 89 d9 83 e1
03 74 02 <f3> a4 5b 5e 5f 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 3e
8d 74
[   93.310291] EAX: e2ca9000 EBX: 00000001 ECX: 00000001 EDX: 00000000
[   93.316548] ESI: 00000000 EDI: e2ca9000 EBP: e3d8799c ESP: e3d87990
[   93.322806] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[   93.329582] CR0: 80050033 CR2: 00000000 CR3: 20d21000 CR4: 003406d0
[   93.335841] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   93.342097] DR6: fffe0ff0 DR7: 00000400
[   93.345929] Call Trace:
[   93.348391]  bpf_msg_push_data+0x635/0x660
[   93.352492]  ___bpf_prog_run+0xa0d/0x15a0
[   93.356529]  ? __lock_acquire+0x1fe/0x1360
[   93.360626]  __bpf_prog_run32+0x4b/0x70
[   93.364461]  ? sk_psock_msg_verdict+0x5/0x290
[   93.368842]  sk_psock_msg_verdict+0xad/0x290
[   93.373105]  ? sk_psock_msg_verdict+0xad/0x290
[   93.377543]  ? lockdep_hardirqs_on+0xec/0x1a0
[   93.381896]  ? __local_bh_enable_ip+0x78/0xf0
[   93.386255]  tcp_bpf_send_verdict+0x29c/0x3b0
[   93.390615]  tcp_bpf_sendpage+0x233/0x3d0
[   93.394629]  ? __lock_acquire+0x1fe/0x1360
[   93.398754]  ? __lock_acquire+0x1fe/0x1360
[   93.402850]  ? lock_release+0x8b/0x280
[   93.406593]  ? find_get_entry+0x136/0x300
[   93.410599]  ? touch_atime+0x34/0xd0
[   93.414177]  ? copy_page_to_iter+0x245/0x400
[   93.418441]  ? lockdep_hardirqs_on+0xec/0x1a0
[   93.422793]  ? tcp_bpf_send_verdict+0x3b0/0x3b0
[   93.427325]  inet_sendpage+0x53/0x1f0
[   93.430981]  ? inet_recvmsg+0x1e0/0x1e0
[   93.434812]  ? kernel_sendpage+0x40/0x40
[   93.438728]  kernel_sendpage+0x1e/0x40
[   93.442474]  sock_sendpage+0x24/0x30
[   93.446054]  pipe_to_sendpage+0x59/0xa0
[   93.449894]  ? direct_splice_actor+0x40/0x40
[   93.454166]  __splice_from_pipe+0xde/0x1c0
[   93.458264]  ? direct_splice_actor+0x40/0x40
[   93.462535]  ? direct_splice_actor+0x40/0x40
[   93.466801]  splice_from_pipe+0x59/0x80
[   93.470641]  ? splice_from_pipe+0x80/0x80
[   93.474652]  ? generic_splice_sendpage+0x20/0x20
[   93.479262]  generic_splice_sendpage+0x18/0x20
[   93.483701]  ? direct_splice_actor+0x40/0x40
[   93.487971]  direct_splice_actor+0x2d/0x40
[   93.492065]  splice_direct_to_actor+0x127/0x240
[   93.496597]  ? generic_pipe_buf_nosteal+0x10/0x10
[   93.501302]  do_splice_direct+0x7e/0xc0
[   93.505134]  do_sendfile+0x20d/0x3e0
[   93.508739]  sys_sendfile+0xac/0xd0
[   93.512232]  ? lock_release+0x8b/0x280
[   93.515984]  do_fast_syscall_32+0x8e/0x320
[   93.520084]  entry_SYSENTER_32+0x70/0xc8
[   93.524009] EIP: 0xb7f9d7a1
[   93.526807] Code: 8b 98 60 cd ff ff 85 d2 89 c8 74 02 89 0a 5b 5d
c3 8b 04 24 c3 8b 14 24 c3 8b 1c 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[   93.545542] EAX: ffffffda EBX: 0000001a ECX: 0000001e EDX: 00000000
[   93.551799] ESI: 00000001 EDI: 0000001a EBP: 00000001 ESP: bfa67a64
[   93.558057] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000206
[   93.564836] Modules linked in: tun algif_hash af_alg
x86_pkg_temp_thermal fuse
[   93.572082] CR2: 0000000000000000
[   93.575411] ---[ end trace c106584042e12a8d ]---
[   93.580046] EIP: memcpy+0x1d/0x30
[   93.583355] Code: 59 58 eb 85 90 90 90 90 90 90 90 90 90 3e 8d 74
26 00 55 89 e5 57 56 89 c7 53 89 d6 89 cb c1 e9 02 f3 a5 89 d9 83 e1
03 74 02 <f3> a4 5b 5e 5f 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 3e
8d 74
[   93.602092] EAX: e2ca9000 EBX: 00000001 ECX: 00000001 EDX: 00000000
[   93.608349] ESI: 00000000 EDI: e2ca9000 EBP: e3d8799c ESP: d967e49c
[   93.614607] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[   93.621408] CR0: 80050033 CR2: 00000000 CR3: 20d21000 CR4: 003406d0
[   93.627694] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   93.633951] DR6: fffe0ff0 DR7: 00000400
[   93.637783] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:34
[   93.648035] in_atomic(): 1, irqs_disabled(): 1, pid: 4354, name: test_sockmap
[   93.655156] INFO: lockdep is turned off.
[   93.659074] irq event stamp: 1538
[   93.662408] hardirqs last  enabled at (1537): [<d902cadf>]
_raw_spin_unlock_irqrestore+0x2f/0x50
[   93.671200] hardirqs last disabled at (1538): [<d840182c>]
trace_hardirqs_off_thunk+0xc/0x10
[   93.679624] softirqs last  enabled at (1532): [<d8d1b849>]
lock_sock_nested+0x39/0x90
[   93.687465] softirqs last disabled at (1530): [<d8d1b83f>]
lock_sock_nested+0x2f/0x90
[   93.695284] CPU: 0 PID: 4354 Comm: test_sockmap Tainted: G      D
        5.2.0-rc3-next-20190604 #1
[   93.704573] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   93.712043] Call Trace:
[   93.714490]  dump_stack+0x66/0x96
[   93.717800]  ___might_sleep+0x13e/0x230
[   93.721629]  __might_sleep+0x33/0x80
[   93.725200]  exit_signals+0x2a/0x200
[   93.728771]  do_exit+0x8e/0xbb0
[   93.731910]  ? do_fast_syscall_32+0x8e/0x320
[   93.736182]  rewind_stack_do_exit+0x11/0x13
[   93.740356] EIP: 0xb7f9d7a1
[   93.743150] Code: 8b 98 60 cd ff ff 85 d2 89 c8 74 02 89 0a 5b 5d
c3 8b 04 24 c3 8b 14 24 c3 8b 1c 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[   93.761887] EAX: ffffffda EBX: 0000001a ECX: 0000001e EDX: 00000000
[   93.768142] ESI: 00000001 EDI: 0000001a EBP: 00000001 ESP: bfa67a64
[   93.774406] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000206

100: tasks_to [   93.781266] note: test_sockmap[4354] exited with
preempt_count 2
#
# Fork 100 tasks to 'test_hashmap_walk'
100: tasks_to #
# helper_fill_hashmap(261)FAILfailed to create hashmap err Cannot
allocate memory, flags 0x0


[1] https://lkft.validation.linaro.org/scheduler/job/760391#L13640

Best regards
Naresh Kamboju
