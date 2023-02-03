Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E80E688BA9
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjBCATz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBCATy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:19:54 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68635F751
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:19:53 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id cr11so2452414pfb.1
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 16:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=04VyYCnOs89oG5kkCQ7dJq3gfMZU6XP6VWIVpoaiOu0=;
        b=UTdkVTcAar2UhMIBv7/BPhA4z94GhlBP70BFz8cnmksU7Lvx6jKQk4huY+LFBELhll
         uVrSxgjMLC34FU2x/tdBCRtMxPC7RErijzYuQ4tjuUYWMfljvgClgZOepsn1vhUDMPwm
         YOYYvRZeRL8POjqGmvFK4bKp6Dw94dr1tjQdyks4rFY8jY7EkzYLUEcp4x/OUQI4FAL4
         sxJl9b4tHdX8voZN4lBcvq78zRUgibR/oe+9mrnYrWM6NgnwEvKKf2Fy3DDowF9l6a+c
         XdYrVIwAK7uI2j5dJfp576BzYe7QAx4NFhMa/LKex9DtNAoQUcEwnCinvozr0oGf0WnE
         W7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04VyYCnOs89oG5kkCQ7dJq3gfMZU6XP6VWIVpoaiOu0=;
        b=H1idi73eQfik2b+wN0NEYHkpwltjt4CHMvcZFQBzj0TYMoAUNSfwRskENsMHgQGu4O
         V3e2vzJP5tLf2chPgxljAGGfYWLORyUDDtag/sBf7TJSatRFuH/EpjD9JVuUGsv7us3h
         X7305ZuIWlN+jqQts/3UBdDsAEZQXDNvdRMUIaYH4IWjIbi0uzybfcdDm4k7Df0XR0FB
         dzW6VZL+5/FSqjo5uSfgWPMEGxhNGbS3s+CbAkyM6G+MeaG/hheN6xTofkYMemXadot6
         tfClUuJvTFJfw1mYlxVdFPdQpLFN5/71QHj4jwoPlT1Dog2FdNpVFsfrAtxN+Ccx3BuZ
         OG1Q==
X-Gm-Message-State: AO0yUKW4elN7/nGQhRXmfnCq6DOewj5TsA85OOZWY1Jtjci5ImDKRL3b
        6BeZ+TGD4DaFAXHjw7j5xgJIyINvcsOtV7yjKjo=
X-Google-Smtp-Source: AK7set8tFtSFTqY+tmituXQe8aPu6GpPPVlUMTsc4BukeNEP9SzxqhFm2nGXFUsi3sPJoh/yiqwx+A==
X-Received: by 2002:a05:6a00:3005:b0:592:48ba:9f59 with SMTP id ay5-20020a056a00300500b0059248ba9f59mr6969033pfb.22.1675383592562;
        Thu, 02 Feb 2023 16:19:52 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d8-20020aa78148000000b00593906a8843sm272429pfn.176.2023.02.02.16.19.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 16:19:52 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:19:49 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216992] New: sl0: transmit timeout
Message-ID: <20230202161949.3d42d655@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 02 Feb 2023 21:28:56 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216992] New: sl0: transmit timeout


https://bugzilla.kernel.org/show_bug.cgi?id=216992

            Bug ID: 216992
           Summary: sl0: transmit timeout
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.54-0-virt
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

[43514.079668] ------------[ cut here ]------------
[43514.079684] NETDEV WATCHDOG: sl0 (): transmit queue 0 timed out
[43514.079724] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:477
dev_watchdog+0x264/0x270
[43514.079732] Modules linked in: slip ppp_deflate bsd_comp ppp_async crc_ccitt
ppp_generic slhc xt_MASQUERADE iptable_nat xt_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c xt_tcpudp ip_tables x_tables veth
virtio_gpu virtio_dma_buf evdev psmouse virtio_rng rng_core mousedev i2c_piix4
floppy ipv6 qemu_fw_cfg button af_packet virtio_input virtio_blk virtio_net
net_failover failover sr_mod cdrom ata_generic simpledrm drm_kms_helper
cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea
drm fb fbdev i2c_core drm_panel_orientation_quirks firmware_class loop ext4
crc32c_generic crc16 mbcache jbd2 usb_storage usbcore usb_common sd_mod t10_pi
[43514.079791] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.15.54-0-virt
#1-Alpine
[43514.079795] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.10.2-1 04/01/2014
[43514.079797] RIP: 0010:dev_watchdog+0x264/0x270
[43514.079801] Code: eb a6 48 8b 1c 24 c6 05 1b 20 a7 00 01 48 89 df e8 51 47
fb ff 44 89 e9 48 89 de 48 c7 c7 58 13 e8 b3 48 89 c2 e8 de 3e 0e 00 <0f> 0b eb
83 0f 1f 84 00 00 00 00 00 41 57 41 56 49 89 d6 41 55 4d
[43514.079803] RSP: 0018:ffffbbe0c00c8ea0 EFLAGS: 00010246
[43514.079806] RAX: 0000000000000000 RBX: ffff94afc1803000 RCX:
0000000000000000
[43514.079808] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[43514.079809] RBP: ffff94afc18033dc R08: 0000000000000000 R09:
0000000000000000
[43514.079811] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff94afc13fc080
[43514.079813] R13: 0000000000000000 R14: ffff94afc1803480 R15:
0000000000000001
[43514.079817] FS:  0000000000000000(0000) GS:ffff94afcf300000(0000)
knlGS:0000000000000000
[43514.079819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[43514.079821] CR2: 00007ffc3525e000 CR3: 0000000003fa6000 CR4:
00000000000006a0
[43514.079825] Call Trace:
[43514.079827]  <IRQ>
[43514.079829]  ? pfifo_fast_enqueue+0x160/0x160
[43514.079833]  call_timer_fn+0x21/0x100
[43514.079838]  __run_timers.part.0+0x1e4/0x260
[43514.079841]  ? tick_nohz_handler+0xb0/0xb0
[43514.079845]  ? __hrtimer_run_queues+0x138/0x280
[43514.079848]  ? kvm_clock_get_cycles+0xd/0x10
[43514.079852]  run_timer_softirq+0x44/0xe0
[43514.079855]  __do_softirq+0xcb/0x293
[43514.079859]  irq_exit_rcu+0x96/0xc0
[43514.079863]  sysvec_apic_timer_interrupt+0x72/0x90
[43514.079868]  </IRQ>
[43514.079869]  <TASK>
[43514.079870]  asm_sysvec_apic_timer_interrupt+0xf/0x20
[43514.079873] RIP: 0010:native_safe_halt+0xb/0x10
[43514.079876] Code: 65 48 8b 14 25 c0 bb 01 00 f0 80 4a 02 20 48 8b 12 83 e2
08 75 b9 e9 73 ff ff ff cc cc cc cc eb 07 0f 00 2d d9 dd 44 00 fb f4 <c3> 0f 1f
40 00 eb 07 0f 00 2d c9 dd 44 00 f4 c3 cc cc cc cc cc 53
[43514.079878] RSP: 0018:ffffbbe0c0093ef0 EFLAGS: 00000246
[43514.079881] RAX: ffffffffb37bd050 RBX: 0000000000000001 RCX:
0000000000000000
[43514.079882] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[43514.079884] RBP: ffff94afc11c3a80 R08: 0000000000000000 R09:
0000000000000000
[43514.079885] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[43514.079887] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[43514.079888]  ? __cpuidle_text_start+0x8/0x8
[43514.079892]  default_idle+0x5/0x20
[43514.079894]  default_idle_call+0x38/0xd0
[43514.079896]  do_idle+0x1f8/0x270
[43514.079899]  cpu_startup_entry+0x14/0x20
[43514.079902]  secondary_startup_64_no_verify+0xb0/0xbb
[43514.079906]  </TASK>
[43514.079907] ---[ end trace bb78bf750d0f8ee3 ]---
[43514.079909] sl0: transmit timed out, driver error?
[43534.559659] sl0: transmit timed out, driver error?
[43555.039673] sl0: transmit timed out, driver error?
[43573.234648] device sl0 entered promiscuous mode
[43575.519894] sl0: transmit timed out, driver error?
[43596.639662] sl0: transmit timed out, driver error?
[43612.740927] device sl0 left promiscuous mode
[43617.119680] sl0: transmit timed out, driver error?
[43763.679660] sl0: transmit timed out, driver error?
[43784.159658] sl0: transmit timed out, driver error?
[43804.639704] sl0: transmit timed out, driver error?
[43825.119682] sl0: transmit timed out, driver error?
[44033.163830] device sl0 entered promiscuous mode

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
