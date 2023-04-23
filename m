Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB7C6EC1F9
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjDWTcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjDWTbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:44 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD971706;
        Sun, 23 Apr 2023 12:31:34 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 3DE5F5FD1A;
        Sun, 23 Apr 2023 22:31:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278292;
        bh=tL2E1Y90S5bBkA16ZM0oXYsz18KCFk1Zn9JPdTBbPT8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=UWKVnL/mqB/IkLUAiJ6REH5PGQEFI8HKRqL0NYUgyNx0c+yMVMH2IUuxcTv/FQ5hr
         vLUYKUFdeoblK9qlxbSYEPdTMd4Y9oSE/Wq/tHUKjzGWI00ZdgCtgVqFK7NkK5SSFz
         M59/IMy6h283dZJIHH0qts1gV49pnoGSHwksrm2m65iXyrNIc+/NRR1oK0jtUjNI5/
         K7+R/VEfDnaQhFdd//q4KXivkqljSkLzSlb6V9Ad+OEliSeA4CB79XruzGPxuWMNBN
         d925s3hTWXgCEiimcxPrfmMT7CFszN6duip0h8OnQlLYWGpVdZoNvn5sYa5vrLXIz4
         FJaRfdRleALXQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:32 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 15/15] docs: net: description of MSG_ZEROCOPY for AF_VSOCK
Date:   Sun, 23 Apr 2023 22:26:43 +0300
Message-ID: <20230423192643.1537470-16-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds description of MSG_ZEROCOPY flag support for AF_VSOCK type of
socket.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Documentation/networking/msg_zerocopy.rst | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
index b3ea96af9b49..34bc7ff411ce 100644
--- a/Documentation/networking/msg_zerocopy.rst
+++ b/Documentation/networking/msg_zerocopy.rst
@@ -7,7 +7,8 @@ Intro
 =====
 
 The MSG_ZEROCOPY flag enables copy avoidance for socket send calls.
-The feature is currently implemented for TCP and UDP sockets.
+The feature is currently implemented for TCP, UDP and VSOCK (with
+virtio transport) sockets.
 
 
 Opportunity and Caveats
@@ -174,7 +175,7 @@ read_notification() call in the previous snippet. A notification
 is encoded in the standard error format, sock_extended_err.
 
 The level and type fields in the control data are protocol family
-specific, IP_RECVERR or IPV6_RECVERR.
+specific, IP_RECVERR or IPV6_RECVERR (for TCP or UDP socket).
 
 Error origin is the new type SO_EE_ORIGIN_ZEROCOPY. ee_errno is zero,
 as explained before, to avoid blocking read and write system calls on
@@ -201,6 +202,7 @@ undefined, bar for ee_code, as discussed below.
 
 	printf("completed: %u..%u\n", serr->ee_info, serr->ee_data);
 
+For VSOCK socket, cmsg_level will be SOL_VSOCK and cmsg_type will be 0.
 
 Deferred copies
 ~~~~~~~~~~~~~~~
@@ -235,12 +237,15 @@ Implementation
 Loopback
 --------
 
+For TCP and UDP:
 Data sent to local sockets can be queued indefinitely if the receive
 process does not read its socket. Unbound notification latency is not
 acceptable. For this reason all packets generated with MSG_ZEROCOPY
 that are looped to a local socket will incur a deferred copy. This
 includes looping onto packet sockets (e.g., tcpdump) and tun devices.
 
+For VSOCK:
+Data path sent to local sockets is the same as for non-local sockets.
 
 Testing
 =======
@@ -254,3 +259,6 @@ instance when run with msg_zerocopy.sh between a veth pair across
 namespaces, the test will not show any improvement. For testing, the
 loopback restriction can be temporarily relaxed by making
 skb_orphan_frags_rx identical to skb_orphan_frags.
+
+For VSOCK type of socket example can be found in  tools/testing/vsock/
+vsock_test_zerocopy.c.
-- 
2.25.1

