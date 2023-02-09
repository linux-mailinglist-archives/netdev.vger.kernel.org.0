Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CDD6902A8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBII6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBII6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:58:01 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A6510268
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:57:59 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id d66so1377021vsd.9
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 00:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gHb70pOwPqvR9y42fHlIc3igeOSfVis7KR0mG9YzdIo=;
        b=QtfzD/yhLf7lanhxU8TX2UmmA6Vw58vAASYkpIIyFaO57WyFOKuUkzJFI+KmZ7zP+L
         r1iQeJrGZ+3KtS8bEF1DZTzKfmRhTbVpwF0LIdpPhymi0zh9wDj5Ug8vEKSVUWyAqzxH
         DNjaNr1XxDc3VWkd0Ii/C3vE2wR70NhpXlSKb732HNjEzEyhdn1jGYhzTrR3y49GuG8/
         JDeXZOH16gni0uE97b1zjoo+Vjw8PdqOd8sFQJiTKoXlIl8rbuvzWd3QNGg/iPDGzK/U
         EpiYAid/edOzP8TTSX9CWPnG7BPQK9ZWrbeYm41ecUGY4muoz6skwCJgd4eO6POH0KzX
         LaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gHb70pOwPqvR9y42fHlIc3igeOSfVis7KR0mG9YzdIo=;
        b=ulSjlvYu6fZi/wSXAa3vsimhFqmtld61yx1gsqcsj9w2rxb+s1BM8nOb+A6ef9Bf9d
         bzg+wdSXfDfiNWmrVRn/NhqncJBerqeS54wvGOF2pYGhpyoeyqWJrQrlS/edXsmnJBbF
         DnXO/AIAN+9MdiE39Y0arvHtmQU0Cs96BB0x1L3wikM9DAcztDryILr/tnFZ4+Ydnn7L
         17Tojx5/YeA89Y2M7RN5I8ODJApEDfNLO9oI/BSH9BkpnSkWFTF/dyyRAf9HoojSSLv7
         cWaJopKmcYj2q4k8VDvfovXZX/vTVe5eLzESG4ykWaQBYRC5dbp1VMQLnj1EFWlFJcG5
         64xQ==
X-Gm-Message-State: AO0yUKXj/ozsYBCPWxFqr+ig4VHfvZBJyk0t7GSKDYh7IOx6T8JJoEEl
        2fVbg5UiJmbldHM5kgDjaR9DunQqU9b8bR+/3Vrdog==
X-Google-Smtp-Source: AK7set+SWviAPqcm+lXpFK7IG6GNon/te538RQpkkScB9UL7Dz92lij+QxWdSPocjXZnBoSHeDbTvUYclsRz++TKaO4=
X-Received: by 2002:a05:6102:3652:b0:3f7:4e35:cdfa with SMTP id
 s18-20020a056102365200b003f74e35cdfamr2068567vsu.83.1675933078490; Thu, 09
 Feb 2023 00:57:58 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 9 Feb 2023 14:27:47 +0530
Message-ID: <CA+G9fYs-i-c2KTSA7Ai4ES_ZESY1ZnM=Zuo8P1jN00oed6KHMA@mail.gmail.com>
Subject: next: arm64: boot: kernel BUG at mm/usercopy.c:102 - pc : usercopy_abort
To:     open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel crash noticed while booting arm64 devices and qemu-arm64 with
kselftest merge configs enabled.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

crash log:
----------
usercopy: Kernel memory exposure attempt detected from SLUB object
'skbuff_small_head' (offset 130, size 12)!
..
[   24.673364] ------------[ cut here ]------------
[   24.673812] kernel BUG at mm/usercopy.c:102!
[   24.674631] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[   24.675389] Modules linked in:
[   24.676231] CPU: 3 PID: 1 Comm: systemd Not tainted
6.2.0-rc7-next-20230209 #1
[   24.676779] Hardware name: linux,dummy-virt (DT)
[   24.677256] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   24.677695] pc : usercopy_abort (mm/usercopy.c:102 (discriminator 24))
[   24.678470] lr : usercopy_abort (mm/usercopy.c:102 (discriminator 24))
[   24.678717] sp : ffff80000803bab0
[   24.678949] x29: ffff80000803bac0 x28: ffff0000c0838040 x27: ffff80000803bc70
[   24.679618] x26: 0000000000000000 x25: ffff0000c0fe4040 x24: ffff0000c4752000
[   24.680050] x23: 0000000000000000 x22: 0000000000000020 x21: 0000000000000000
[   24.680484] x20: ffffc94cf339ac70 x19: ffffc94cf31861b8 x18: 0000000000000000
[   24.680929] x17: 63656a626f204255 x16: 4c53206f74206465 x15: 7463657465642074
[   24.681372] x14: 706d657474612065 x13: 2129323320657a69 x12: 0000000000000001
[   24.681810] x11: ffffc94cf372ba24 x10: 65685f6c6c616d73 x9 : ffffc94cf1184028
[   24.682299] x8 : ffff80000803b7b8 x7 : ffffc94cf4207170 x6 : 0000000000000001
[   24.682742] x5 : 0000000000000001 x4 : ffffc94cf4165000 x3 : 0000000000000000
[   24.683216] x2 : 0000000000000000 x1 : ffff0000c0838040 x0 : 000000000000006a
[   24.683788] Call trace:
[   24.684019] usercopy_abort (mm/usercopy.c:102 (discriminator 24))
[   24.684346] __check_heap_object (mm/slub.c:4739)
[   24.684621] __check_object_size (mm/usercopy.c:196
mm/usercopy.c:251 mm/usercopy.c:213)
[   24.684883] netlink_sendmsg (include/linux/uio.h:177
include/linux/uio.h:184 include/linux/skbuff.h:3977
net/netlink/af_netlink.c:1927)
[   24.685161] __sys_sendto (net/socket.c:722 net/socket.c:745
net/socket.c:2142)
[   24.685397] __arm64_sys_sendto (net/socket.c:2150)
[   24.685644] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:57)
[   24.685891] el0_svc_common.constprop.0
(arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/syscall.c:150)
[   24.686164] do_el0_svc (arch/arm64/kernel/syscall.c:194)
[   24.686401] el0_svc (arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/entry-common.c:133
arch/arm64/kernel/entry-common.c:142
arch/arm64/kernel/entry-common.c:638)
[   24.686602] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:656)
[   24.686862] el0t_64_sync (arch/arm64/kernel/entry.S:591)
[ 24.687307] Code: aa1303e3 9000ea60 91300000 97f49682 (d4210000)
All code
========
   0:* e3 03                jrcxz  0x5 <-- trapping instruction
   2: 13 aa 60 ea 00 90    adc    -0x6fff15a0(%rdx),%ebp
   8: 00 00                add    %al,(%rax)
   a: 30 91 82 96 f4 97    xor    %dl,-0x680b697e(%rcx)
  10: 00 00                add    %al,(%rax)
  12: 21 d4                and    %edx,%esp

Code starting with the faulting instruction
===========================================
   0: 00 00                add    %al,(%rax)
   2: 21 d4                and    %edx,%esp
[   24.688236] ---[ end trace 0000000000000000 ]---
[   24.688722] note: systemd[1] exited with irqs disabled
[   24.689588] note: systemd[1] exited with preempt_count 1
[   24.690331] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[   24.690875] SMP: stopping secondary CPUs
[   24.691749] Kernel Offset: 0x494ce9000000 from 0xffff800008000000
[   24.692103] PHYS_OFFSET: 0x40000000
[   24.692349] CPU features: 0x000000,0068c25f,3326773f
[   24.692924] Memory Limit: none
[   24.693422] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---


detailed boot logs:
https://lkft.validation.linaro.org/scheduler/job/6145112#L778
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230209/testrun/14667540/suite/log-parser-test/tests/
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230209/testrun/14667540/suite/log-parser-test/test/check-kernel-bug/log


metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git_sha: 20f513df926fac0594a3b65f79d856bd64251861
  git_describe: next-20230209
  kernel_version: 6.2.0-rc7
  kernel-config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2LUB6A6xC34mySgwQ3vPa6kHKJS/config
  artifact-location:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2LUB6A6xC34mySgwQ3vPa6kHKJS/
  toolchain: gcc-11
  build_name: gcc-11-lkftconfig-kselftest


--
Linaro LKFT
https://lkft.linaro.org
