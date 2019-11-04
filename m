Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8600EE3CC
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfKDPaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:30:10 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37414 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfKDPaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 10:30:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id v2so18100456lji.4
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 07:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=L4OTsx6tnYmHWpBfCCw4iK88aVxkKO6H7TUh4ieonNw=;
        b=rNofkVl0Lg909dYZ8wkd6rPoyp89RE8jaEDwEKNO4wqKB+3uUcsQ1GyDvwVFNPN83h
         OGjOFwQ4/1DkgkuwYJkqFzuOesPhh8RUmTXrczpcO/BxGKh1mt2pWwLUesVC5LxYRbBl
         f5b5Nd7AYq5WmDljHm1t5yA0ed2jVsO3jbGvmMaEu1Di9TDpy4eHZ95uSxKXZUv+PCNE
         SZIfxQPe6Vsstb5bu2tide9mA7QrShWsb4BUyDLnawvI67xhcnC4pykJ07NJR2/m97Qb
         T3YG5EGTRRnPME4rwWNk7hnY5ZeuY8qHbCjdzvua9EkcwdFV7YtsoUQGqQRJuhUQhOgM
         rdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=L4OTsx6tnYmHWpBfCCw4iK88aVxkKO6H7TUh4ieonNw=;
        b=eTLaB1V7NoAD3NsDMgMr2LfFJ2KrFJ942wP+3xBAvXwslFt/o1U5yT+HK1b3B6LuNr
         ujcIUAoW3dZyY1yTfRWw/m7Bt8+Ji9d0Hee7fywpB91DvGkdQsk2kjOu4tRdLZkgGKjm
         /qnEf0T7nT2wxowykc4Kzj9Er3x1PNh02fSrDl9EXY4+txrPqHKuoOLCyIKJir4gF8FZ
         iPFfJD+IFdVd+AEwr0w1A5ucvs7wk+EJxrVblQQBG6YC0ZRdSiHcSAlK0Lc5HdC5pdZv
         Ytux9CNeLOfE6Sz/2sab5qTG1zkXit8LhsgLM9jlKVzTNppbWvIrhUubQDYYj0gCfUdW
         g1gQ==
X-Gm-Message-State: APjAAAWhbbT56qfkja7C84BKS/U+4zDcfzPr6H8l3VS7cwbwg3SwaqFb
        gtSLEgCAA+XottIT7hOInMMip8gFc4u7v/P2Y6LxIw==
X-Google-Smtp-Source: APXvYqyEv8vi9hG7WzF1wHMTs8PW3UAq9vOBSFdPj3A6YWe0sq7LExCZ4L4fAzCqbZNJ8iKFjw7dMUHx7UeS0puOrS4=
X-Received: by 2002:a2e:814b:: with SMTP id t11mr19923634ljg.20.1572881408192;
 Mon, 04 Nov 2019 07:30:08 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Nov 2019 20:59:56 +0530
Message-ID: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
Subject: stable-rc-5.3.9-rc1: regressions detected - remove_proc_entry:
 removing non-empty directory 'net/dev_snmp6', leaking at least 'lo'
To:     linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Dan Rue <dan.rue@linaro.org>, LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, chrubis <chrubis@suse.cz>,
        mmarhefk@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux stable rc 5.3 branch running LTP reported following test failures.
While investigating these failures I have found this kernel warning
from boot console.
Please find detailed LTP output log in the bottom of this email.

List of regression test cases:
  ltp-containers-tests:
    * netns_breakns_ip_ipv6_ioctl
    * netns_breakns_ip_ipv6_netlink
    * netns_breakns_ns_exec_ipv6_ioctl
    * netns_breakns_ns_exec_ipv6_netlink
    * netns_comm_ip_ipv6_ioctl
    * netns_comm_ip_ipv6_netlink
    * netns_comm_ns_exec_ipv6_ioctl
    * netns_comm_ns_exec_ipv6_netlink

dmesg log:
[    0.000000] Linux version 5.3.9-rc1 (oe-user@oe-host) (gcc version
7.3.0 (GCC)) #1 SMP PREEMPT Mon Nov 4 12:14:24 UTC 2019
[    0.000000] Machine model: ARM Juno development board (r2)
...
[    3.670227] ------------[ cut here ]------------
[    3.674887] remove_proc_entry: removing non-empty directory
'net/dev_snmp6', leaking at least 'lo'
[    3.684183] WARNING: CPU: 1 PID: 1 at
/usr/src/kernel/fs/proc/generic.c:684 remove_proc_entry+0x194/0x1a8
[    3.693658] Modules linked in:
[    3.696687] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.3.9-rc1 #1
[    3.702806] Hardware name: ARM Juno development board (r2) (DT)
[    3.708669] pstate: 40000005 (nZcv daif -PAN -UAO)
[    3.713414] pc : remove_proc_entry+0x194/0x1a8
[    3.717814] lr : remove_proc_entry+0x194/0x1a8
[    3.722213] sp : ffff00001003bbe0
[    3.725494] x29: ffff00001003bbe0 x28: ffff0000119cddc0
[    3.730757] x27: ffff000012256000 x26: ffff00001220b000
[    3.736019] x25: ffff00001220a000 x24: ffff000012209000
[    3.741280] x23: ffff8009754a6b00 x22: ffff800973a536db
[    3.746541] x21: ffff800973a53600 x20: ffff000011f8f000
[    3.751803] x19: ffff8009754a6bdb x18: ffffffffffffffff
[    3.757065] x17: 0000000000000007 x16: 0000000000000000
[    3.762326] x15: ffff000011f8f848 x14: ffff80097396f108
[    3.767588] x13: ffff80097396f107 x12: ffff000012268b70
[    3.772849] x11: ffff000012268000 x10: 0000000000000028
[    3.778111] x9 : 0000000000000000 x8 : ffff000011f8f848
[    3.783372] x7 : 00000000b2722639 x6 : ffff000011f93000
[    3.788634] x5 : 0000000000000000 x4 : ffff800975dd8000
[    3.793895] x3 : ffff000011f90000 x2 : 0000000000000000
[    3.799157] x1 : 43129acc141cb700 x0 : 0000000000000000
[    3.804419] Call trace:
[    3.806841]  remove_proc_entry+0x194/0x1a8
[    3.810900]  ipv6_proc_exit_net+0x38/0x58
[    3.814872]  ops_exit_list.isra.1+0x54/0x88
[    3.819013]  unregister_pernet_operations+0xec/0x150
[    3.823929]  unregister_pernet_subsys+0x34/0x48
[    3.828416]  ipv6_misc_proc_exit+0x1c/0x28
[    3.832473]  inet6_init+0x2a4/0x33c
[    3.835929]  do_one_initcall+0x94/0x458
[    3.839727]  kernel_init_freeable+0x484/0x52c
[    3.844043]  kernel_init+0x18/0x110
[    3.847498]  ret_from_fork+0x10/0x1c
[    3.851037] irq event stamp: 255276
[    3.854492] hardirqs last  enabled at (255275):
[<ffff00001104f828>] _raw_spin_unlock_irq+0x38/0x78
[    3.863453] hardirqs last disabled at (255276):
[<ffff0000100a5a14>] debug_exception_enter+0xac/0xe8
[    3.872498] softirqs last  enabled at (255270):
[<ffff00001008210c>] __do_softirq+0x474/0x580
[    3.880943] softirqs last disabled at (255259):
[<ffff0000101018e4>] irq_exit+0x144/0x150
[    3.889044] ---[ end trace 6cbc85548f1f4bc5 ]---

...
LTP test trimmed output,

RTNETLINK answers: Operation not supported
netns_breakns_ns_exec_ipv6_netlink 1 TBROK: adding address to veth0 failed
tee: /proc/sys/net/ipv6/conf/veth0/accept_dad: No such file or directory
tee: /proc/sys/net/ipv6/conf/veth0/accept_ra: No such file or directory
tee: /proc/sys/net/ipv6/conf/veth1/accept_dad: No such file or directory
tee: /proc/sys/net/ipv6/conf/veth1/accept_ra: No such file or directory
No support for INET6 on this system.
netns_breakns_ns_exec_ipv6_ioctl 1 TBROK: adding address to veth0 failed
netns_breakns_ip_ipv6_netlink 1 TBROK: adding address to veth0 failed
netns_breakns_ip_ipv6_ioctl 1 TBROK: adding address to veth0 failed
netns_comm_ns_exec_ipv6_netlink 1 TBROK: adding address to veth0 failed
netns_comm_ns_exec_ipv6_ioctl 1 TBROK: adding address to veth0 failed
netns_comm_ip_ipv6_netlink 1 TBROK: adding address to veth0 failed
netns_comm_ip_ipv6_ioctl 1 TBROK: adding address to veth0 failed

metadata:
  git branch: linux-5.3.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: ff21af282725ae2ebc3ac4298513816f760c929e
  git describe: v5.3.8-160-gff21af282725
  make_kernelversion: 5.3.9-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.3/35/config
  kernel-defconfig:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.3/35/defconfig
  build-url: https://ci.linaro.org/job/openembedded-lkft-linux-stable-rc-5.3/DISTRO=lkft,MACHINE=juno,label=docker-lkft/35/
  build-location:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.3/35

We are investigating this problem.

Full test logs,
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.8-160-gff21af282725/testrun/991864/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.8-160-gff21af282725/testrun/991901/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.8-160-gff21af282725/testrun/991922/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.8-160-gff21af282725/testrun/991884/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.8-160-gff21af282725/testrun/991846/log

--
Linaro LKFT
https://lkft.linaro.org/
