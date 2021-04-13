Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE735DF61
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhDMMvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:51:02 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:58885 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345963AbhDMMsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:48:08 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id BA08375FD5;
        Tue, 13 Apr 2021 15:47:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618318048;
        bh=A27l1J9Yc+j5o2Q+8SNfGKD4Q0rwBxmD9oawj1dkX5Y=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=psqMNkFBqqDiQY075dz7ogkwEsVFACNZfHXd4Ndh0J2I6/rIp+ZwCzJotp2cNEmfI
         MwD4QHCYB3urjJOqtu55HCF+f2xk4QNhxNl4ot2yfAyIIYhnrau8zJiejK/SgSvdWV
         ccpp3zdJwh9U2ghaGwZJdcRqqniw0Gx3A8zdC8E882bB9PyAOkULBAOSRmiFzx1y+s
         RgPQQoAyWj8/7ZzOyyFpr/GcJjFKB1TYkwT7gLo2MUQe89OPql+pm+D6006Wg8ZykX
         1BZ2AcCk7Z3lFtpbXAUBxtqE+maiFlOuV792TJt3P3If1TRe6gkajRcboEr2P4fYrn
         5RR+hiiJrWXYQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 197BE75F59;
        Tue, 13 Apr 2021 15:47:28 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:47:27 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v8 18/19] virtio/vsock: update trace event for SEQPACKET
Date:   Tue, 13 Apr 2021 15:47:16 +0300
Message-ID: <20210413124720.3407726-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/13/2021 12:36:22
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163057 [Apr 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/13/2021 12:38:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.04.2021 10:53:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/13 07:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/13 03:14:00 #16587160
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds SEQPACKET socket's type for trace event of virtio vsock.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
v7 -> v8:
 - Code used for SEQ_BEGIN and SEQ_END removed.

 include/trace/events/vsock_virtio_transport_common.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/vsock_virtio_transport_common.h b/include/trace/events/vsock_virtio_transport_common.h
index 6782213778be..b30c0e319b0e 100644
--- a/include/trace/events/vsock_virtio_transport_common.h
+++ b/include/trace/events/vsock_virtio_transport_common.h
@@ -9,9 +9,12 @@
 #include <linux/tracepoint.h>
 
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_STREAM);
+TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_SEQPACKET);
 
 #define show_type(val) \
-	__print_symbolic(val, { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" })
+	__print_symbolic(val, \
+				{ VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
+				{ VIRTIO_VSOCK_TYPE_SEQPACKET, "SEQPACKET" })
 
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_INVALID);
 TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_REQUEST);
-- 
2.25.1

