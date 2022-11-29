Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F099E63B9B8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 07:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiK2GST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 01:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbiK2GSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 01:18:14 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 22:18:09 PST
Received: from esa1.hc3370-68.iphmx.com (esa1.hc3370-68.iphmx.com [216.71.145.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C342015FC8;
        Mon, 28 Nov 2022 22:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1669702689;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=bmlgSAtGbFtOdTc2GOvO2wyZBv0MSel48KWcSeby+RI=;
  b=CVPlJDsjJlMPg5rRWdVhzAcIUtSpPg1RkGA0BWB9aZWfLF/PC+UNcHfW
   S6xwVW71HvjqzbwLH6/kxF8AqSUEcgHF5od9l7gf2HsMyzrMUNWZONNU0
   ce42jfM2KeM2byQ1juvIwLTX+aQdQ2chJCa6h/RDtCJb5qLDoBT6+65WS
   Y=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
X-SBRS: None
X-MesageID: 86155238
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:/wwzm67QmHsfLrdwyeQQXAxRtJ3HchMFZxGqfqrLsTDasY5as4F+v
 mIYWW6GafyJNmXwKY10aIu+9U0G6JGHxoNgG1dkrio9Hi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraBYnoqLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9VU+4pwehBtC5gZkPKkR7QeE/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5my
 cYxczAofhW5xMXsz5SLWMR8jdwKBZy+VG8fkikIITDxCP8nRdbIQrnQ5M8e1zA17ixMNa+AP
 YxDM2MpNUmeJU0UUrsUIMtWcOOAgnj5NTlZtXqepLYt4niVxwt0uFToGIqLI4HXH54F9qqej
 m2Y7kPGWgsjDtya4CXC3X+0vf/MuQquDer+E5Xnr6U30TV/3Fc7EBQcWF26ieO0hk63R5RUL
 El80ikzp6Ea90GxSNT5GRqirxasrhMaHtZdDeA+wAWM0bbPpRaUAHAeSTxMY8Bgs9U5LRQu1
 1mUj5bqCCZpvbm9V32Q7PGXoCm0NCxTKnUNDQcCQBcJ7sfLvo4+lFTMQ8xlHarzicf6cRn9z
 y2PpTozm50ciskE06j99lfC6xquqYLOVRUd/RjMUySu6QYRTJW+e4Wi5Fzf7PBBBIWUVF+Mu
 D4Dgcf2xOwHE5yIvCCEXugIGLan+7CDPSG0qVlrEpo6/jKh4Um/bJtQ6zFzIkRuGssccDqva
 0jW0T69/7cKYiHsN/UuJdvsVYJ6lsAMCOgJSNjoVPMVYr1hcTXE23thQ36C8nDmiGEFxPRX1
 YigTe6gCnMTCKJCxTWwRvsA3bJD+h3S1V8/VrigkU35jOP2iGq9DO5cbQDQNrxRALas+l29z
 jpJCyedJ/yzusXaazKfz4McJEtiwZMTVcGv8Jw/mgJuz2Nb9IAd5x35m+tJl29Nxf49egL0E
 paVBCdlJKLX3yGvFOlzQikLhXOGdc8XQYgHFSItJ020/HMofJyi6qwSH7NuI+d2qrI7lq8kE
 KZbEyllPhioYm2XkwnxkLGn9NAyHPhVrV3m09WZjMgXIMc7Gl2hFi7MdQrz7igeZhdbRuNny
 4BNF2rzH/I+euiVJJ+OMK33kAvt5SN1dSAbdxKgH+S/sX7EqOBCQxEdRNdsSy3QAX0vHgen6
 js=
IronPort-HdrOrdr: A9a23:2Qpes6A5gwNlSHblHem455DYdb4zR+YMi2TC1yhKJiC9E/bo8/
 xG88576faZslsssRIb6LW90cu7IU80nKQdieJ6AV7LZniFhILCFu9fBOXZrwEIYxeOldJg6Q
 ==
X-IronPort-AV: E=Sophos;i="5.96,202,1665460800"; 
   d="scan'208";a="86155238"
From:   Lin Liu <lin.liu@citrix.com>
CC:     Lin Liu <lin.liu@citrix.com>, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:XEN HYPERVISOR INTERFACE" 
        <xen-devel@lists.xenproject.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/netfront: Fix NULL sring after live migration
Date:   Tue, 29 Nov 2022 06:17:02 +0000
Message-ID: <20221129061702.60629-1-lin.liu@citrix.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        TO_EQ_FM_DIRECT_MX autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A NAPI is setup for each network sring to poll data to kernel
The sring with source host is destroyed before live migration and
new sring with target host is setup after live migration.
The NAPI for the old sring is not deleted until setup new sring
with target host after migration. With busy_poll/busy_read enabled,
the NAPI can be polled before got deleted when resume VM.

[50116.602938] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[50116.603047] IP: xennet_poll+0xae/0xd20
[50116.603090] PGD 0 P4D 0
[50116.603118] Oops: 0000 [#1] SMP PTI
[50116.604624] Call Trace:
[50116.604674]  ? finish_task_switch+0x71/0x230
[50116.604745]  ? timerqueue_del+0x1d/0x40
[50116.604807]  ? hrtimer_try_to_cancel+0xb5/0x110
[50116.604882]  ? xennet_alloc_rx_buffers+0x2a0/0x2a0
[50116.604958]  napi_busy_loop+0xdb/0x270
[50116.605017]  sock_poll+0x87/0x90
[50116.605066]  do_sys_poll+0x26f/0x580
[50116.605125]  ? tracing_map_insert+0x1d4/0x2f0
[50116.605196]  ? event_hist_trigger+0x14a/0x260
...
[50116.613598]  ? finish_task_switch+0x71/0x230
[50116.614131]  ? __schedule+0x256/0x890
[50116.614640]  ? recalc_sigpending+0x1b/0x50
[50116.615144]  ? xen_sched_clock+0x15/0x20
[50116.615643]  ? __rb_reserve_next+0x12d/0x140
[50116.616138]  ? ring_buffer_lock_reserve+0x123/0x3d0
[50116.616634]  ? event_triggers_call+0x87/0xb0
[50116.617138]  ? trace_event_buffer_commit+0x1c4/0x210
[50116.617625]  ? xen_clocksource_get_cycles+0x15/0x20
[50116.618112]  ? ktime_get_ts64+0x51/0xf0
[50116.618578]  SyS_ppoll+0x160/0x1a0
[50116.619029]  ? SyS_ppoll+0x160/0x1a0
[50116.619475]  do_syscall_64+0x73/0x130
[50116.619901]  entry_SYSCALL_64_after_hwframe+0x41/0xa6
...
[50116.806230] RIP: xennet_poll+0xae/0xd20 RSP: ffffb4f041933900
[50116.806772] CR2: 0000000000000008
[50116.807337] ---[ end trace f8601785b354351c ]---

xen frontend should remove the NAPIs for the old srings before live
migration as the bond srings are destroyed

There is a tiny window between the srings are set to NULL and
the NAPIs are disabled, It is safe as the NAPI threads are still
frozen at that time

Signed-off-by: Lin Liu <lin.liu@citrix.com>
---
 drivers/net/xen-netfront.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 9af2b027c19c..dc404e05970c 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1862,6 +1862,12 @@ static int netfront_resume(struct xenbus_device *dev)
 	netif_tx_unlock_bh(info->netdev);
 
 	xennet_disconnect_backend(info);
+
+	rtnl_lock();
+	if (info->queues)
+		xennet_destroy_queues(info);
+	rtnl_unlock();
+
 	return 0;
 }
 
-- 
2.17.1

