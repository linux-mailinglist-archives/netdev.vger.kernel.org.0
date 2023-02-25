Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFA46A2B4E
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 19:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBYS3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 13:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBYS3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 13:29:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FBDE060
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 10:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677349716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zv/xQL8kguH2DCyuojYf/vRV+UjJ6qJW7G0m4Ktfp5I=;
        b=S2Zr4YbA6RSEwvFIkSmr3uRzqDdPLuDRZc57RlHxyIzTnAuZOX3tNeJFYaiRPkPFepXWNC
        KaDHyaEiRwNSTjwydZjhsCjGa0H2U06TTndtqBeUOlAK7oRmpnjmuXd9NHKZGj9RzkdCyA
        2wLXHIXw7/0tUWSg6/pKSneenCHDbUQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-637-aOkZZgkmOAuFpZa4W03wVA-1; Sat, 25 Feb 2023 13:28:35 -0500
X-MC-Unique: aOkZZgkmOAuFpZa4W03wVA-1
Received: by mail-pj1-f71.google.com with SMTP id d3-20020a17090acd0300b00237659aae8dso2914716pju.1
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 10:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zv/xQL8kguH2DCyuojYf/vRV+UjJ6qJW7G0m4Ktfp5I=;
        b=tROm6/VQkTW+Vy0544H3Js2Qg75IY+a/UmgfOP626dk1ilIR0NqG/wuDGGJWbh6Hn0
         6iYZK4lpjHM0w6ZRRE/lAUnaOht5+mnDSZrPZR/LARb2HdA0ZUv/psOxOSpuUMF133/3
         bxkF6LGSuczKTeFCPFkfvDbQa5z4B+kujWSVvT8wSkSDH3slcI8re0MRfkbvcTNeWRMs
         fe+WGv7Nr6s3aLYPbw1ONOAqyOr/dVdnhnOjkqm+aQaOdJD4g44g/lWoXqw3zJL6f9CO
         fhV0lYVzAdlLB9g4fxmtu/Ou5x8+ulrZ7cQeLlcQtyRnCfUdy06fcH3ZrYqohZR46Kbt
         T3/A==
X-Gm-Message-State: AO0yUKXEzIswdxoWLLyaW+DZqMPoqN3aFEJXVWPXvnZTooTj+WbEN7+P
        uMk/bzyzYE0XoasElGpCQ1hZhvQo4UTfRewwavP70bAYpZl4MGhsy/BF+8QwRT3NfyuGJI+XFA8
        XncGmJqpnI5Qxlo/x
X-Received: by 2002:a17:902:f64b:b0:19a:b588:6fe2 with SMTP id m11-20020a170902f64b00b0019ab5886fe2mr3116032plg.13.1677349714051;
        Sat, 25 Feb 2023 10:28:34 -0800 (PST)
X-Google-Smtp-Source: AK7set8yuR7pxdQ8IMkY1K+3yOajNqaFNAzNJnxZdw75CwKi770/K/ZEOAKP5zhvvS2KVZohmIAXeQ==
X-Received: by 2002:a17:902:f64b:b0:19a:b588:6fe2 with SMTP id m11-20020a170902f64b00b0019ab5886fe2mr3116018plg.13.1677349713689;
        Sat, 25 Feb 2023 10:28:33 -0800 (PST)
Received: from localhost.localdomain ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ee8200b0019926c7757asm1543214pld.289.2023.02.25.10.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 10:28:33 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Subject: [PATCH net] net: caif: Fix use-after-free in cfusbl_device_notify()
Date:   Sun, 26 Feb 2023 03:28:20 +0900
Message-Id: <20230225182820.4048336-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported use-after-free in cfusbl_device_notify() [1].  This
causes a stack trace like below:

BUG: KASAN: use-after-free in cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
Read of size 8 at addr ffff88807ac4e6f0 by task kworker/u4:6/1214

CPU: 0 PID: 1214 Comm: kworker/u4:6 Not tainted 5.19.0-rc3-syzkaller-00146-g92f20ff72066 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10227 [inline]
 netdev_run_todo+0xbc0/0x10f0 net/core/dev.c:10341
 default_device_exit_batch+0x44e/0x590 net/core/dev.c:11334
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

When unregistering a net device, unregister_netdevice_many_notify()
sets the device's reg_state to NETREG_UNREGISTERING, calls notifiers
with NETDEV_UNREGISTER, and adds the device to the todo list.

Later on, devices in the todo list are processed by netdev_run_todo().
netdev_run_todo() waits devices' reference count become 1 while
rebdoadcasting NETDEV_UNREGISTER notification.

When cfusbl_device_notify() is called with NETDEV_UNREGISTER multiple
times, the parent device might be freed.  This could cause UAF.
Processing NETDEV_UNREGISTER multiple times also causes inbalance of
reference count for the module.

This patch fixes the issue by accepting only first NETDEV_UNREGISTER
notification.

Link: https://syzkaller.appspot.com/bug?id=c3bfd8e2450adab3bffe4d80821fbbced600407f [1]
Reported-by: syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/caif/caif_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index ebc202ffdd8d..bf61ea4b8132 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -134,6 +134,9 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	struct usb_device *usbdev;
 	int res;
 
+	if (what == NETDEV_UNREGISTER && dev->reg_state >= NETREG_UNREGISTERED)
+		return 0;
+
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
 	      strcmp(dev->dev.parent->driver->name, "cdc_ncm") == 0))
-- 
2.39.0

