Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428F0218B49
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgGHPdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbgGHPdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:33:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA16C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:33:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k5so1346021pjg.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SCGp3U3xXjWjHpiJFM+xhiuHwGrJyAaBl6MNlzcTB54=;
        b=t8mvQIuuPEXTBzaVYmy4TPam9Iu48FyKCMvuky/dh6AVSrehqwh7bG5w6k2VhvgmYS
         qiBf/y5et8I59QzUMb2UpcaHmnCuTmoD2lovyWP9s8AHABAkj8hWg/gSGE50T7m96VmP
         Mgis1G8rIbZczSBfDRQDks2BZJUnNMCfnZUMiiT13Z43VqBCpuayKjFFYsztFMtCRBF6
         GRyPvljmlMFdCVGUKvEJlNkTOFOi//27CaJnSdVd4sXlD6+qRjRMgcSP2u8hbM/d6mhF
         iSLbMNrJzHVvMGDoHP2u6B+j7tcRbzpKsMTtgMGc+0qy724Won5P8Pc9+qEcKgw0OxOq
         gscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SCGp3U3xXjWjHpiJFM+xhiuHwGrJyAaBl6MNlzcTB54=;
        b=muNJ0AKfnwtPKmCxXgdVgChofWQR3Y0AJ3n2Peru8rAxVQyPsxMsWNi2IjD2GoBeLk
         ogF9XtMrkQDkVOyhhOJgBpABGDJyeE/J3HmhYA4oWZ5JyRXbOahKBknTu4px9EQKq+Gt
         /IZNHFrlVhRvHFgGFhBiK8vVCiDUKIyM7SyiiamOoFuQLdewTeeVoRYi3JXNpFGNEptP
         ii7O3DfSzZzpdEirmO1wZ1JBlUVzkhP5tdlGJrFYtcxhSumpXMhdntoJHuPnmZ9k9jSp
         h1q4hQSxRpb6Tz1bzNtOSYwr8DfaZm0pUT7o7aHKWEC2eLSjqG2O3aUOW7gt8RtHXq1y
         8ZqQ==
X-Gm-Message-State: AOAM531mx2FoftgA1d2iYvnAh2N10CI5sbWgMsqBfRkP+Hmp0KdlDZrl
        3xJ7WN+ml7TOn7IjtO1AXso=
X-Google-Smtp-Source: ABdhPJySn5c5rTuhs0MV1jg90eUjli21m9unhD9IEdtvBrcRC39D5QN97kLsjk/tUTRsn5yXSo8ZKg==
X-Received: by 2002:a17:902:be17:: with SMTP id r23mr14391852pls.284.1594222410408;
        Wed, 08 Jul 2020 08:33:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm208217pfh.160.2020.07.08.08.33.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 08:33:29 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:33:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200708153327.GA193647@roeck-us.net>
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jul 02, 2020 at 11:52:56AM -0700, Cong Wang wrote:
> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> copied, so the cgroup refcnt must be taken too. And, unlike the
> sk_alloc() path, sock_update_netprioidx() is not called here.
> Therefore, it is safe and necessary to grab the cgroup refcnt
> even when cgroup_sk_alloc is disabled.
> 
> sk_clone_lock() is in BH context anyway, the in_interrupt()
> would terminate this function if called there. And for sk_alloc()
> skcd->val is always zero. So it's safe to factor out the code
> to make it more readable.
> 
> The global variable 'cgroup_sk_alloc_disabled' is used to determine
> whether to take these reference counts. It is impossible to make
> the reference counting correct unless we save this bit of information
> in skcd->val. So, add a new bit there to record whether the socket
> has already taken the reference counts. This obviously relies on
> kmalloc() to align cgroup pointers to at least 4 bytes,
> ARCH_KMALLOC_MINALIGN is certainly larger than that.
> 
> This bug seems to be introduced since the beginning, commit
> d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> tried to fix it but not compeletely. It seems not easy to trigger until
> the recent commit 090e28b229af
> ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.
> 

This patch causes all my s390 boot tests to crash. Reverting it fixes
the problem. Please see bisect results and and crash log below.

Guenter

---
bisect results (from pending-fixes branch) in -next repository):

# bad: [1432f824c2db44ef35b26caa9f81dd05211a75fc] Merge remote-tracking branch 'drm-misc-fixes/for-linux-next-fixes'
# good: [dcb7fd82c75ee2d6e6f9d8cc71c52519ed52e258] Linux 5.8-rc4
git bisect start 'HEAD' 'v5.8-rc4'
# bad: [fe12f8184e7265e2d24e5ed5b255275dfe4c1c04] Merge remote-tracking branch 'net/master'
git bisect bad fe12f8184e7265e2d24e5ed5b255275dfe4c1c04
# good: [474112d57c70520ebd81a5ca578fee1d93fafd07] Documentation: networking: ipvs-sysctl: drop doubled word
git bisect good 474112d57c70520ebd81a5ca578fee1d93fafd07
# good: [6d12075ddeedc38d25c5b74e929e686158da728c] Merge tag 'mtd/fixes-for-5.8-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux
git bisect good 6d12075ddeedc38d25c5b74e929e686158da728c
# good: [74478ea4ded519db35cb1f059948b1e713bb4abf] net: ipa: fix QMI structure definition bugs
git bisect good 74478ea4ded519db35cb1f059948b1e713bb4abf
# bad: [9c29e36152748fd623fcff6cc8f538550f9eeafc] mptcp: fix DSS map generation on fin retransmission
git bisect bad 9c29e36152748fd623fcff6cc8f538550f9eeafc
# good: [aea23c323d89836bcdcee67e49def997ffca043b] ipv6: Fix use of anycast address with loopback
git bisect good aea23c323d89836bcdcee67e49def997ffca043b
# bad: [28b18e4eb515af7c6661c3995c6e3c34412c2874] net: sky2: initialize return of gm_phy_read
git bisect bad 28b18e4eb515af7c6661c3995c6e3c34412c2874
# bad: [ad0f75e5f57ccbceec13274e1e242f2b5a6397ed] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
git bisect bad ad0f75e5f57ccbceec13274e1e242f2b5a6397ed
# first bad commit: [ad0f75e5f57ccbceec13274e1e242f2b5a6397ed] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()

---
Crash log:

[   22.390674] Run /sbin/init as init process
[   22.497551] Unable to handle kernel pointer dereference in virtual kernel address space
[   22.497738] Failing address: 5010f0b45fa93000 TEID: 5010f0b45fa93803
[   22.497813] Fault in home space mode while using kernel ASCE.
[   22.497958] AS:0000000001774007 R3:0000000000000024
[   22.498300] Oops: 0038 ilc:3 [#1] SMP
[   22.498405] Modules linked in:
[   22.499027] CPU: 0 PID: 153 Comm: init Not tainted 5.8.0-rc4-00328-g1432f824c2db4 #1
[   22.499112] Hardware name: QEMU 2964 QEMU (KVM/Linux)
[   22.499261] Krnl PSW : 0704e00180000000 0000000000259be0 (cgroup_sk_free+0xa8/0x1e8)
[   22.499405]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
[   22.499506] Krnl GPRS: 0000000048a38585 5010f0b45fa93094 0000000000000002 000000001c228bd8
[   22.499585]            000000001c228bb0 0000000000000000 0000000000000000 00000000011c2eda
[   22.499665]            fffffffffffff000 00000000011c1f72 00000000011deef0 0000000000014040
[   22.499744]            000000001c228100 0000000000e76bf0 0000000000259c82 000003e0002c3c00
[   22.500270] Krnl Code: 0000000000259bd2: a72a0001		ahi	%r2,1
[   22.500270]            0000000000259bd6: 502003a8		st	%r2,936
[   22.500270]           #0000000000259bda: e31003b80008	ag	%r1,952
[   22.500270]           >0000000000259be0: e32010000004	lg	%r2,0(%r1)
[   22.500270]            0000000000259be6: a7f40004		brc	15,0000000000259bee
[   22.500270]            0000000000259bea: b9040023		lgr	%r2,%r3
[   22.500270]            0000000000259bee: b9040032		lgr	%r3,%r2
[   22.500270]            0000000000259bf2: b9040042		lgr	%r4,%r2
[   22.500635] Call Trace:
[   22.500748]  [<0000000000259be0>] cgroup_sk_free+0xa8/0x1e8
[   22.500835] ([<0000000000259bb4>] cgroup_sk_free+0x7c/0x1e8)
[   22.500914]  [<0000000000b24e16>] __sk_destruct+0x196/0x260
[   22.500999]  [<0000000000cadc18>] unix_release_sock+0x358/0x460
[   22.501073]  [<0000000000cadd5a>] unix_release+0x3a/0x60
[   22.501149]  [<0000000000b1a63a>] __sock_release+0x62/0xf8
[   22.501223]  [<0000000000b1a6f8>] sock_close+0x28/0x38
[   22.501299]  [<000000000045101e>] __fput+0x126/0x2a8
[   22.501374]  [<000000000017e088>] task_work_run+0x78/0xc8
[   22.501449]  [<000000000010a596>] do_notify_resume+0x9e/0xa8
[   22.501526]  [<0000000000de555a>] system_call+0xe6/0x2d4
[   22.501657] INFO: lockdep is turned off.
[   22.501736] Last Breaking-Event-Address:
[   22.501814]  [<0000000000259c86>] cgroup_sk_free+0x14e/0x1e8
[   22.502169] Kernel panic - not syncing: Fatal exception: panic_on_oops
