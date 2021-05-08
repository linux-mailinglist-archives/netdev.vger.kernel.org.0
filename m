Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D6377333
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhEHQi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 12:38:56 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:45663 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhEHQiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 12:38:51 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id CB05976F36;
        Sat,  8 May 2021 19:37:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620491853;
        bh=SSPafbxy4r2OU72JdjQWKGMN2ReGB2PQt4Gd/j7hBes=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=PezQpEBEppUum37twSP/DbfT3ifbsuvEKOyBYTW7ZLGMoP49zQtDIyoQtEId4n6hr
         A+sT15gt2yCXLdpqVDcdMhELrQzYYlZQjdcXPkLzznDO5cZ41Ysp0gb7ZlN8POCSNF
         kwgbCwquJPwefaNQP+FDP8m1cV3+r3Y+1icz9VmkMe2j4R1Q0wmlFxT++B3KV256w9
         +Pz1mFLDc9c/UG2bEEsKZ66ASpFYElQhkUsahO1HZjY1Gb4oU1GyNJSp4DPkBlGT1t
         TdYHd/kBeSZ4GsXVHuY1frjuXX7M90IgywDv+smrOpuXsSVp4BBzfdcuPqUzQ1LnLz
         bQWeV3G60cvKA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 6786F76F33;
        Sat,  8 May 2021 19:37:33 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 8 May
 2021 19:37:29 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v9 18/19] virtio/vsock: update trace event for SEQPACKET
Date:   Sat, 8 May 2021 19:37:20 +0300
Message-ID: <20210508163725.3432864-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/08/2021 16:27:11
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163552 [May 08 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/08/2021 16:29:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 08.05.2021 12:32:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/08 15:50:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/08 12:32:00 #16600610
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds SEQPACKET socket's type for trace event of virtio vsock.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
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

