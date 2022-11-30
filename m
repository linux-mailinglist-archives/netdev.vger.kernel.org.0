Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5595C63D5FC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiK3Mur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiK3Mup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:50:45 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8314F3054A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:50:43 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3704852322fso169806237b3.8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=61fKaN1RgZu/xXzq2GQeDUU3FSJDk3tRJK16ifRK9+c=;
        b=sC6+H6syPiy08gXleFu7AaQzqdXgjkpEl1OPmBsnvM+t7RGMRy9+FaEdQ4nl1YStLW
         2u8SidSHPvli1ImY5lOZRCij1SMgFAFxCJaK0cHQ8P+9F9sYKtxdXt6EnKSt3OQE8ZiM
         bzg1KBZ/+LZ7aPTVt7tDAYajV7oBDXpv8lN7F3aCTuz4zi6PS93iA7xUV27prXFFrEOk
         qK2VpQG5MyDUkyOQnhuxszStLh4mFrUy71RDtcCkXXgudfQX8k3ae83WbQ2wROGIwR/E
         LHFluOgjjAyhWQJlSyQrmyPrsJGX6ftwSoEtP2rYtinsvVx/F/hClY8e0KAZngAxZ7vi
         0ngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=61fKaN1RgZu/xXzq2GQeDUU3FSJDk3tRJK16ifRK9+c=;
        b=LVnp6N1c+fama3WPe/JB50hsmVuR2X874ZAJL2rq2d1JplwWUQUauhsMHXiElTOMhD
         H99y29cSGfivhMZxboZ8HTQ09XD0s2yVDn+L5q0MJEcCzff2GwAhkXhphbBnD5TewL/6
         Kxgpsr3NtHoAIjkXBgEvfMBL7TnUT+iqRrU8e4/mh5Zyk5lTpNsvhSqA5x8M59Wqxo5S
         /QtPhFN9A3YQixgn9pXxjM+JE3oL4HPFQ4Jw46p5hy9tKSLP2xSzxw0e7Mn2Qcl1Cjxb
         7wYRZ8NgU+iZwG4hvljxwAdPqg+zd4Y/6mHohg3s+Hc/jzr5tFiUCkUCRXH6ucpoT8MZ
         cSRA==
X-Gm-Message-State: ANoB5pn98/8psGSxZP8FM61/hn7pUC4bahjNvccBo1uQMz11lfM+qmX+
        u7vD+kDrSfejaIRs6n5ewhSFo+LzGcTbjnjtMIoznw==
X-Google-Smtp-Source: AA0mqf5Mtc3g4IaeS/udDSdjIshl/Nt0dbGI6vRRCHK1JhZEiQRL5APp70Km0i9UU42guuqivy83OMD+yaVOzJ6IY7g=
X-Received: by 2002:a81:dd8:0:b0:3b8:97ce:990a with SMTP id
 207-20020a810dd8000000b003b897ce990amr26466371ywn.448.1669812642465; Wed, 30
 Nov 2022 04:50:42 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 30 Nov 2022 18:20:30 +0530
Message-ID: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
Subject: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb / p9_client_rpc
To:     rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Netdev <netdev@vger.kernel.org>, Marco Elver <elver@google.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Please ignore if it is already reported, and not an expert of KCSAN]

While booting arm64 with allmodconfig following kernel BUG found,
this build is enabled with CONFIG_INIT_STACK_NONE=y

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 6.1.0-rc7-next-20221130 (tuxmake@tuxmake)
(aarch64-linux-gnu-gcc (Debian 11.3.0-6) 11.3.0, GNU ld (GNU Binutils
for Debian) 2.39) #2 SMP PREEMPT_DYNAMIC @1669786411
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt
...
[  424.408466] ==================================================================
[  424.412792] BUG: KCSAN: data-race in p9_client_cb / p9_client_rpc
[  424.416806]
[  424.418214] write to 0xffff00000a753000 of 4 bytes by interrupt on cpu 0:
[  424.422437]  p9_client_cb+0x84/0x100
[  424.425048]  req_done+0xfc/0x1c0
[  424.427443]  vring_interrupt+0x174/0x1c0
[  424.430204]  __handle_irq_event_percpu+0x2c8/0x680
[  424.433455]  handle_irq_event+0x9c/0x180
[  424.436187]  handle_fasteoi_irq+0x2b0/0x340
[  424.439139]  generic_handle_domain_irq+0x78/0xc0
[  424.442323]  __gic_handle_irq_from_irqson.isra.0+0x3d8/0x480
[  424.446054]  gic_handle_irq+0xb4/0x100
[  424.448663]  call_on_irq_stack+0x2c/0x38
[  424.451443]  do_interrupt_handler+0xd0/0x140
[  424.454452]  el1_interrupt+0x88/0xc0
[  424.457001]  el1h_64_irq_handler+0x18/0x40
[  424.459856]  el1h_64_irq+0x78/0x7c
[  424.462331]  arch_local_irq_enable+0x50/0x80
[  424.465273]  arm64_preempt_schedule_irq+0x80/0xc0
[  424.468497]  el1_interrupt+0x90/0xc0
[  424.471096]  el1h_64_irq_handler+0x18/0x40
[  424.474009]  el1h_64_irq+0x78/0x7c
[  424.476464]  __tsan_read8+0x118/0x280
[  424.479086]  __delay+0x104/0x140
[  424.481521]  __udelay+0x5c/0xc0
[  424.483905]  kcsan_setup_watchpoint+0x6cc/0x7c0
[  424.487081]  __tsan_read4+0x168/0x280
[  424.489729]  p9_client_rpc+0x1d0/0x580
[  424.492429]  p9_client_getattr_dotl+0xd0/0x3c0
[  424.495457]  v9fs_inode_from_fid_dotl+0x48/0x1c0
[  424.498602]  v9fs_vfs_lookup+0x23c/0x3c0
[  424.501386]  __lookup_slow+0x1b0/0x240
[  424.504056]  walk_component+0x168/0x280
[  424.506807]  path_lookupat+0x154/0x2c0
[  424.509489]  filename_lookup+0x160/0x2c0
[  424.512261]  vfs_statx+0xc0/0x280
[  424.514710]  vfs_fstatat+0x84/0x100
[  424.517308]  __do_sys_newfstatat+0x64/0x100
[  424.520189]  __arm64_sys_newfstatat+0x74/0xc0
[  424.523262]  invoke_syscall+0xb0/0x1c0
[  424.525939]  el0_svc_common.constprop.0+0x10c/0x180
[  424.529219]  do_el0_svc+0x54/0x80
[  424.531662]  el0_svc+0x4c/0xc0
[  424.533944]  el0t_64_sync_handler+0xc8/0x180
[  424.536837]  el0t_64_sync+0x1a4/0x1a8
[  424.539436]
[  424.540810] read to 0xffff00000a753000 of 4 bytes by task 74 on cpu 0:
[  424.544927]  p9_client_rpc+0x1d0/0x580
[  424.547692]  p9_client_getattr_dotl+0xd0/0x3c0
[  424.550564]  v9fs_inode_from_fid_dotl+0x48/0x1c0
[  424.553550]  v9fs_vfs_lookup+0x23c/0x3c0
[  424.556144]  __lookup_slow+0x1b0/0x240
[  424.558655]  walk_component+0x168/0x280
[  424.561192]  path_lookupat+0x154/0x2c0
[  424.563721]  filename_lookup+0x160/0x2c0
[  424.566337]  vfs_statx+0xc0/0x280
[  424.568638]  vfs_fstatat+0x84/0x100
[  424.571051]  __do_sys_newfstatat+0x64/0x100
[  424.573821]  __arm64_sys_newfstatat+0x74/0xc0
[  424.576650]  invoke_syscall+0xb0/0x1c0
[  424.579144]  el0_svc_common.constprop.0+0x10c/0x180
[  424.582212]  do_el0_svc+0x54/0x80
[  424.584475]  el0_svc+0x4c/0xc0
[  424.586611]  el0t_64_sync_handler+0xc8/0x180
[  424.589347]  el0t_64_sync+0x1a4/0x1a8
[  424.591758]
[  424.593045] 1 lock held by systemd-journal/74:
[  424.595821]  #0: ffff00000a0ead88
(&type->i_mutex_dir_key#3){++++}-{3:3}, at: walk_component+0x158/0x280
[  424.601588] irq event stamp: 416642
[  424.603875] hardirqs last  enabled at (416641):
[<ffff80000a552040>] preempt_schedule_irq+0x40/0x100
[  424.609078] hardirqs last disabled at (416642):
[<ffff80000a5422b8>] el1_interrupt+0x78/0xc0
[  424.613887] softirqs last  enabled at (416464):
[<ffff800008011130>] __do_softirq+0x5b0/0x694
[  424.618699] softirqs last disabled at (416453):
[<ffff80000801a9b0>] ____do_softirq+0x30/0x80
[  424.623562]
[  424.624841] value changed: 0x00000002 -> 0x00000003
[  424.627838]
[  424.629117] Reported by Kernel Concurrency Sanitizer on:
[  424.632298] CPU: 0 PID: 74 Comm: systemd-journal Tainted: G
       T  6.1.0-rc7-next-20221130 #2
26b4d3787db66414ab23fce17d22967bb2169e1f
[  424.639393] Hardware name: linux,dummy-virt (DT)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
