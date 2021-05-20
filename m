Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61CB38B755
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbhETTVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:21:42 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:30322 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbhETTVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:21:41 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id EBE545212D6;
        Thu, 20 May 2021 22:20:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538415;
        bh=2fgv6quaAojndVwSYVCltsVkau3dKg8d9BBkNJEHikk=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=wCEvA7Xrl4WuzPaLA4/Oav9hrK1TfXfcFF28lYzjGvsiFltUVK6wcfh5Xa/dhkBIk
         3hLl5GoAiDPIbeQQaR9/47q0+NkS07WKMkF5LBoTwLkFMVLxxsnpVIF2V5kBvfLIUU
         f71JkVomRQD+wJktliXMCk47jR1oUZ+CUf4mQncVP4fYILJINEgYlozlKUVpwQYbXx
         7U3oVV5QXBBVUh565k9SlNDVjR58l/3IAiXkt4LDsE0Prlo2jFkH+g8We9dL4/PHeQ
         9mbJBKFFk1yDnS3FSI+biLCWORQhRvGJSIHsJzLV1r2w/I1DgfOPCQQ8/QSk2AZ31y
         Y71MshpRaJ04A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id EBABF52129F;
        Thu, 20 May 2021 22:20:13 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:20:13 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 18/18] virtio/vsock: update trace event for SEQPACKET
Date:   Thu, 20 May 2021 22:20:04 +0300
Message-ID: <20210520192008.1272910-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/20/2021 18:58:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163818 [May 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/20/2021 19:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 20.05.2021 14:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/20 17:27:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/20 14:47:00 #16622423
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SEQPACKET socket type to vsock trace event.

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

