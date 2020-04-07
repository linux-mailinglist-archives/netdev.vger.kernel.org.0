Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F811A0A92
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgDGJ5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:57:34 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41408 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgDGJ5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:57:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id n17so2981767lji.8
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=o0AbrCCCBwxaSdnD4la6hfcUUO98eOc7DVUFlKwnSec=;
        b=wlvKn7ogimiW92F2bTYCAJAnBcPlF3nr0tCvSadIKAcYpsKaBMsgJ67PGBobFeaBC9
         g3Wr+9nOTYmuxW1QPAJ713MJ+t55vauFGT1E6a5uyKRE6SE9qf8kVR5M/+089xyb/ufq
         xVVVx4rBo/FayWFA7dcbdGV/E/e4IthKSi8bpFai2Se6dZe52Qe95acGpfhGYrkJ8fML
         cHwcVRc82yFEDI0m6WqQNOSgT+mGBjjqeqXCk+uq2o9vs5S1nsP59BEcKh89rtbwTUVK
         oy4dF/hlnnPEyA01K1pAjgzhse6cr3pzDTRasKCyYtaeVHVC7KHKIirauQJilnCwJPVY
         oMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=o0AbrCCCBwxaSdnD4la6hfcUUO98eOc7DVUFlKwnSec=;
        b=V82LzfrafZSAioMxsFXykTkWvoW91nKw/ngoyppjUoZ6uZ1OWIufO5HBBLlGOpldlo
         uhU59B+HY+c80lMfrHO+rT7PpE3Y9WNaDC42S0c+6rTyWTeS8ZrrS2b/mr47gwFArLyx
         N2a39hgKd9zo7k7zFaYlF1ANSgok8nsh1yYS3TBOwajjjZ69Mm9sKOTrtmWR9IXqwcnT
         q/djI0Kr7D3ktS4ETIN8F22E6MZ6lKIlENF4Fg8jH9wSGyteS5vb9z3ZjrUpUtWMD/6I
         JODrdShUwvwwlzt1mzxPqH3a/DvoIyENYYRVW1sj0b0dvZSZLfofpDo0klrsNvs3kVrX
         5Spg==
X-Gm-Message-State: AGi0Pua1PLG6aUo883cOtag1E6u4DulQwQdFW9ybYa8t2I549GoNX83O
        GpWI6x3UD5p3iNygZi/3TFGBtRwegD6IpZHnyPt3OQ==
X-Google-Smtp-Source: APiQypI3UliK96j1aiMoPqX1C3haYHk8SpHUqDJG/eJp3IDuAoIXEm4d0iyqyd+x9iH343jZHjF6MLowl1BQI4wvIxU=
X-Received: by 2002:a2e:88cb:: with SMTP id a11mr1241092ljk.245.1586253452932;
 Tue, 07 Apr 2020 02:57:32 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Apr 2020 15:27:20 +0530
Message-ID: <CA+G9fYt7-R-_fVDeiwj=sVvBQ-456Pm1oFFtM5Hm_94nN-tA+w@mail.gmail.com>
Subject: x86_64: 5.6.0: locking/lockdep.c:1155 lockdep_register_key
To:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Borislav Petkov <bp@suse.de>, Netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Brian Gerst <brgerst@gmail.com>, lkft-triage@lists.linaro.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Linux mainline kernel 5.6.0 running kselftest on i386 kernel running on
x86_64 devices we have noticed this kernel warning.

[ 0.000000] Linux version 5.6.0 (oe-user@oe-host) (gcc version 7.3.0
(GCC)) #1 SMP Mon Apr 6 17:31:22 UTC 2020
<>
[  143.321511] ------------[ cut here ]------------
[  143.326180] WARNING: CPU: 1 PID: 1515 at
/usr/src/kernel/kernel/locking/lockdep.c:1155
lockdep_register_key+0x150/0x180
[  143.336958] Modules linked in: sch_ingress veth algif_hash
x86_pkg_temp_thermal fuse
[  143.344698] CPU: 1 PID: 1515 Comm: ip Tainted: G        W         5.6.0 #1
[  143.351562] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  143.359034] EIP: lockdep_register_key+0x150/0x180
[  143.363739] Code: ff ff a1 88 4c 2a dc 85 c0 0f 85 ef fe ff ff 68
27 02 f9 db 68 a5 7a f7 db e8 0c 5b fa ff 0f 0b 59 58 e9 d7 fe ff ff
8d 76 00 <0f> 0b 8d 65 f8 5b 5e 5d c3 8d b4 26 00 00 00 00 89 c2 b8 68
68 99
[  143.382485] EAX: 00000001 EBX: dc329ea8 ECX: 00000001 EDX: dc3299a8
[  143.388751] ESI: 00000001 EDI: c7316000 EBP: c610fe10 ESP: c610fe08
[  143.395014] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  143.401792] CR0: 80050033 CR2: b7dd70c0 CR3: 20672000 CR4: 003406d0
[  143.408051] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  143.414315] DR6: fffe0ff0 DR7: 00000400
[  143.418144] Call Trace:
[  143.420592]  alloc_netdev_mqs+0xc6/0x3c0
[  143.424520]  __ip_tunnel_create+0xa1/0x1d0
[  143.428614]  ? ipgre_tap_setup+0x50/0x50
[  143.432535]  ? mutex_lock_nested+0x19/0x20
[  143.436634]  ip_tunnel_init_net+0x125/0x340
[  143.440823]  erspan_init_net+0x1d/0x20
[  143.444580]  ops_init+0x34/0x180
[  143.447815]  setup_net+0xe7/0x230
[  143.451134]  copy_net_ns+0xe0/0x210
[  143.454625]  create_new_namespaces+0xf5/0x290
[  143.458984]  unshare_nsproxy_namespaces+0x47/0xa0
[  143.463691]  ksys_unshare+0x19e/0x330
[  143.467354]  ? __might_fault+0x41/0x80
[  143.471102]  __ia32_sys_unshare+0xf/0x20
[  143.475026]  do_fast_syscall_32+0x7f/0x330
[  143.479126]  entry_SYSENTER_32+0xaa/0x102
[  143.483135] EIP: 0xb7f77ce1
[  143.485926] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb c1
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  143.504662] EAX: ffffffda EBX: 40000000 ECX: 080a8b31 EDX: 00000000
[  143.510920] ESI: 00000001 EDI: bf833230 EBP: bf830fc0 ESP: bf830f7c
[  143.517177] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  143.523959] irq event stamp: 5894
[  143.527275] hardirqs last  enabled at (5893): [<dbc0225a>]
_raw_spin_unlock_irqrestore+0x2a/0x50
[  143.536054] hardirqs last disabled at (5894): [<dae019dc>]
trace_hardirqs_off_thunk+0xc/0x10
[  143.544487] softirqs last  enabled at (5882): [<dba45069>]
inet6_fill_ifla6_attrs+0x3b9/0x400
[  143.553004] softirqs last disabled at (5880): [<dba4504b>]
inet6_fill_ifla6_attrs+0x39b/0x400
[  143.561514] ---[ end trace dbec531a9fb3b99c ]---

Full test log,
https://lkft.validation.linaro.org/scheduler/job/1341969#L5766

-- 
Linaro LKFT
https://lkft.linaro.org
