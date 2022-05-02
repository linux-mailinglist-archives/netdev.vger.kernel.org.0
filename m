Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33208516F3B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 14:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384892AbiEBMJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 08:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiEBMIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 08:08:41 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F751400E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 05:05:09 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2f7d621d1caso144714027b3.11
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 05:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=h3tCKH7ebkKPQvrWw7j6hFFjOOim/c0BmjpoSMuBdrQ=;
        b=CNJZDsF19g7FivqUW2Z1eJq8XN5EV2igI4ab6j9NUAqteLblakIst+IpEeHS/Pv+EL
         7g40JlM0BF7AEQnCwqm4RUo0/63RBy/xP2b9pKPTF3H8BNB9fJ5h4AADMMjvh0ZrTnV6
         +7vMPLJTpI6Un9uNKqGUR/G4FhisOA1vCjDw35emsEReezFS5JJAFg0bp+s+XvJaRbUs
         QHHSfjMW7xNMywwbEgMVEWk24wbe9bYNLsfWcLnDFHHuxR1M2AvZ+C2PvL+Mq5PAhKs9
         nWZyYPBBLtnJ/R0+l5PNhYKlxdlbC4UqonVhi3/jp2LFYLvbiydBN1ZkYi4KbacB4NFy
         4YLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=h3tCKH7ebkKPQvrWw7j6hFFjOOim/c0BmjpoSMuBdrQ=;
        b=PYlxLquqhnpEMPMIm5u3lkT80mXwMCYriFFMuuxBlh5Tqn6qL9/KvHGqYwqX/FdOvU
         DQOMjj4yML8nz51Ugcin9TYYMRABQjSbtktTTH8yKCheRujQtrXV9YU2l5oFnj7+9Soj
         Wuveq0N0/aOUMegOQzzlwIh1i0z2w+or1jM554XHIMcBxV772AQ2kXr83Km6mhUxLBsx
         SS3gM9/5nXbjTtH7Zp5BCjwO9RvIwXFlsySzNoAvIN+J2x/z068xZvgkML3RY7n4trC1
         ny+0JzrTTAPkNJGisgI3CHGeerdZ/YT+4ZumBsMPohXRTM9pRIN4XWxvTfAdBvYDuwtW
         4erg==
X-Gm-Message-State: AOAM532TJffzzhho5MO2SuW0ToX1v9nXyU32AOlcJ2sM8hTzZDsK4uUm
        /qWvh1vS9XytNvVEnImfvrzNaJCigcQSiYw7OQbSDQ==
X-Google-Smtp-Source: ABdhPJy+md5hEGolmEI3F2msfSAnd2QAPV6G68T06cTpxGxu+bBbbObkukwSus5TTSIkxDs9lTrJPGOrLWkRlCsL6pM=
X-Received: by 2002:a81:478b:0:b0:2ea:da8c:5c21 with SMTP id
 u133-20020a81478b000000b002eada8c5c21mr11112137ywa.189.1651493108690; Mon, 02
 May 2022 05:05:08 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 2 May 2022 17:34:56 +0530
Message-ID: <CA+G9fYs2YeyM-v-zea0D7nDk4m+=iCgYgt4pfMVUL-LmXkdHMA@mail.gmail.com>
Subject: selftests: net: pmtu.sh: BUG: unable to handle page fault for
 address: 2509c000
To:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel BUG noticed on qemu_i386 while testing
selftests: net: pmtu.sh  with kselftest merge config build image [1] & [2]
and after this BUG test hung.

metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
  git_sha: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
  git_describe: v5.18-rc5
  kernel_version: 5.18.0-rc5
  kernel-config: https://builds.tuxbuild.com/28a2wrzQ62tLypUV7bgCOXEGKig/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline/-/pipelines/528952197
  artifact-location: https://builds.tuxbuild.com/28a2wrzQ62tLypUV7bgCOXEGKig
  toolchain: gcc-11


Test log:
---------
# selftests: net: pmtu.sh
[  468.730000] ip (15022) used greatest stack depth: 4232 bytes left

<trim>

# TEST: ipv6: cleanup of cached exceptions                            [ OK ]
[  587.633640] IPv6: ADDRCONF(NETDEV_CHANGE): veth_A-R1: link becomes ready
[  587.695867] IPv6: ADDRCONF(NETDEV_CHANGE): veth_A-R2: link becomes ready
[  587.758384] IPv6: ADDRCONF(NETDEV_CHANGE): veth_B-R1: link becomes ready
[  587.821528] IPv6: ADDRCONF(NETDEV_CHANGE): veth_B-R2: link becomes ready
# TEST: ipv6: cleanup of cached exceptions - nexthop objects          [ OK ]
[  591.442819] BUG: unable to handle page fault for address: 2509c000
[  591.444468] #PF: supervisor read access in kernel mode
[  591.445810] #PF: error_code(0x0000) - not-present page
[  591.447175] *pde = 00000000
[  591.448121] Oops: 0000 [#1] PREEMPT SMP
[  591.449350] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.18.0-rc5 #1
[  591.451373] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  591.453404] EIP: percpu_counter_add_batch+0x2e/0xe0
[  591.454134] Code: ec 20 89 5d f4 89 c3 b8 01 00 00 00 89 75 f8 89
7d fc 89 55 ec 89 4d f0 e8 3f f0 a3 ff b8 5f c4 c7 cf e8 e5 43 bd 00
8b 4b 34 <64> 8b 39 89 7d e0 89 fe 8b 45 08 c1 ff 1f 03 75 ec 13 7d f0
89 45
[  591.456840] EAX: 00000003 EBX: c60fd540 ECX: 00000000 EDX: cfc7c45f
[  591.457755] ESI: 00000000 EDI: c11a92c0 EBP: c1251f40 ESP: c1251f20
[  591.458686] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210202
[  591.459688] CR0: 80050033 CR2: 2509c000 CR3: 05401000 CR4: 003506d0
[  591.460628] Call Trace:
[  591.461009]  <SOFTIRQ>
[  591.461366]  dst_destroy+0xac/0xe0
[  591.461879]  dst_destroy_rcu+0x10/0x20
[  591.462438]  rcu_core+0x354/0xa50
[  591.462942]  ? rcu_core+0x2fd/0xa50
[  591.463462]  rcu_core_si+0xd/0x10
[  591.463962]  __do_softirq+0x14f/0x4ae
[  591.464509]  ? __entry_text_end+0x8/0x8
[  591.465108]  call_on_stack+0x4c/0x60
[  591.465637]  </SOFTIRQ>
[  591.466010]  ? __irq_exit_rcu+0xca/0x130
[  591.466588]  ? irq_exit_rcu+0xd/0x20
[  591.467132]  ? sysvec_apic_timer_interrupt+0x36/0x50
[  591.467868]  ? handle_exception+0x133/0x133
[  591.468481]  ? __sched_text_end+0x2/0x2
[  591.469079]  ? sysvec_call_function_single+0x50/0x50
[  591.469804]  ? default_idle+0x13/0x20
[  591.470346]  ? sysvec_call_function_single+0x50/0x50
[  591.471068]  ? default_idle+0x13/0x20
[  591.471605]  ? arch_cpu_idle+0x12/0x20
[  591.472164]  ? default_idle_call+0x52/0xa0
[  591.472788]  ? do_idle+0x20a/0x270
[  591.473289]  ? cpu_startup_entry+0x20/0x30
[  591.473890]  ? cpu_startup_entry+0x25/0x30
[  591.474489]  ? start_secondary+0x10f/0x140
[  591.475098]  ? startup_32_smp+0x161/0x164
[  591.475687] Modules linked in: sit xt_policy iptable_filter
ip_tables x_tables veth fuse [last unloaded: test_blackhole_dev]
[  591.477321] CR2: 000000002509c000
[  591.477818] ---[ end trace 0000000000000000 ]---
[  591.478500] EIP: percpu_counter_add_batch+0x2e/0xe0
[  591.479218] Code: ec 20 89 5d f4 89 c3 b8 01 00 00 00 89 75 f8 89
7d fc 89 55 ec 89 4d f0 e8 3f f0 a3 ff b8 5f c4 c7 cf e8 e5 43 bd 00
8b 4b 34 <64> 8b 39 89 7d e0 89 fe 8b 45 08 c1 ff 1f 03 75 ec 13 7d f0
89 45
[  591.481915] EAX: 00000003 EBX: c60fd540 ECX: 00000000 EDX: cfc7c45f
[  591.482829] ESI: 00000000 EDI: c11a92c0 EBP: c1251f40 ESP: c1251f20
[  591.483739] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210202
[  591.484744] CR0: 80050033 CR2: 2509c000 CR3: 05401000 CR4: 003506d0
[  591.485656] Kernel panic - not syncing: Fatal exception in interrupt
[  591.486680] Kernel Offset: disabled
[  591.487215] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org

[1] https://lkft.validation.linaro.org/scheduler/job/4976107#L4726
[2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.18-rc5/testrun/9320607/suite/linux-log-parser/test/check-kernel-bug-4976107/log
