Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4A4F722F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 04:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbiDGCn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 22:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239342AbiDGCnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 22:43:24 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A07A12F167
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 19:41:22 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id g16-20020a05660203d000b005f7b3b0642eso2802366iov.16
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 19:41:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FPnFLcQyYhCFXk0VrLepSFcekoTeVgMkT+ojeLkwXxg=;
        b=P2kdDtDPKLhzcBrvE2X+B8Hz4TzrsgkhieMzyNp0PyA9H28nJqFeGz4hGuKhRaFre3
         4PNMPdnaKRVGITdNwxN2PQqIsxKOFXJOmBrwn5V8CmqOMY0L4aRpLqpvaI6wiM7o1Ath
         CVZWT36rzuzGssDCGODbgUmj+YXmQzMIVj/Igne2fb6QpBOuMEu2sbk481Thq/iHgMVd
         Ulysr66h4smkuwH5ppUIq9TchF+8kjxsKXfOZqQgLGhedNah6hF98BGqhrRCZJbwURe2
         v//Y8DbSUhD1LOXf1KOadX6P5hxBWU9UhJFYyU3GnpDXBm+meq0+2uFgnX1LRP3azVGq
         Ejsg==
X-Gm-Message-State: AOAM533ncQ7zagYQdAR8ZzZM2OEjxirNbYz9lKE630bfhifvOlBHYvwA
        f+xDTmXONIqiBN+Bdh8fhb0eg2lhwc2U0C/X3ZQlvSLvWbzB
X-Google-Smtp-Source: ABdhPJzqtrd4sabLux6vR5+l+khyNsFOVbGzr/VFyM/MP5DGx96Qu/ip0omBcn6x9qDeFAImnQx/HZ9s8eAIVjTqfme6Ffi0RUFZ
MIME-Version: 1.0
X-Received: by 2002:a92:c691:0:b0:2be:8eab:9f7d with SMTP id
 o17-20020a92c691000000b002be8eab9f7dmr5431907ilg.26.1649299281836; Wed, 06
 Apr 2022 19:41:21 -0700 (PDT)
Date:   Wed, 06 Apr 2022 19:41:21 -0700
In-Reply-To: <000000000000d56a0305d80c2f2b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d27e6705dc07698c@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in ax88179_led_setting
From:   syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>
To:     arnd@arndb.de, dan.carpenter@oracle.com, davem@davemloft.net,
        glider@google.com, jackychou@asix.com.tw, jannh@google.com,
        jgg@ziepe.ca, k.kahurani@gmail.com, kbuild-all@lists.01.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, lkp@intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, phil@philpotter.co.uk,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    33d9269ef6e0 Revert "kernel: kmsan: don't instrument stack..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=158ddbcf700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d830111cc3be873
dashboard link: https://syzkaller.appspot.com/bug?extid=d3dbdf31fbe9d8f5f311
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146e3dc3700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com

ax88179_178a 2-1:0.252 (unnamed net_device) (uninitialized): Failed to read reg index 0x0001: -71
ax88179_178a 2-1:0.252 (unnamed net_device) (uninitialized): Failed to read reg index 0x0002: -71
=====================================================
BUG: KMSAN: uninit-value in ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1074 [inline]
BUG: KMSAN: uninit-value in ax88179_led_setting+0x884/0x30b0 drivers/net/usb/ax88179_178a.c:1168
 ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1074 [inline]
 ax88179_led_setting+0x884/0x30b0 drivers/net/usb/ax88179_178a.c:1168
 ax88179_bind+0xf00/0x1a50 drivers/net/usb/ax88179_178a.c:1412
 usbnet_probe+0x1251/0x4160 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:755
 driver_probe_device drivers/base/dd.c:785 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:902
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:973
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1020
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:755
 driver_probe_device drivers/base/dd.c:785 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:902
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:973
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1020
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_new_device+0x1b8e/0x2950 drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5358 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x58e3/0x89e0 drivers/usb/core/hub.c:5742
 process_one_work+0xdb6/0x1820 kernel/workqueue.c:2307
 worker_thread+0x10b3/0x21e0 kernel/workqueue.c:2454
 kthread+0x3c7/0x500 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

Local variable eeprom.i created at:
 ax88179_check_eeprom drivers/net/usb/ax88179_178a.c:1045 [inline]
 ax88179_led_setting+0x2e2/0x30b0 drivers/net/usb/ax88179_178a.c:1168
 ax88179_bind+0xf00/0x1a50 drivers/net/usb/ax88179_178a.c:1412

CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.17.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
=====================================================

