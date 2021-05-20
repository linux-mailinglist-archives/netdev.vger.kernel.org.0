Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477FC38B72F
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhETTTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:19:20 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:29314 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbhETTTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:19:10 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 5202B521411;
        Thu, 20 May 2021 22:17:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538266;
        bh=8oNeV4LEYCCpV1spWguJcgspnidGzg4R+7hRzi0VJSs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=4Gw4sI2/qSO9G7rfCXs7uE7GL1WUQJwU3ZDsHriRRlN1f9EmclBJDQGcjq+xn23tV
         GJZWSu7iAwWi5VDsOF82Mx/OwOa6CUolR87f+LsRREH3zfWg23wV1mbyM1Nm6uKRj9
         MR0zwlwz92jxD+3VrKAO/w5R8YG2NE/Z/fnBFKIq65F+w0IxaHVlBETIgVij3DDFR5
         tpFMvdbojk0w/kvh2Um3hY2f2pESXF68W/5IQsadSP+l6IW663kMs6Dv72XhJsWWq5
         LOrGbrxNfaeNRUYR8DRgTz5HfqlZb3mR3d6QpzTdz52NOYjTPg6ZrOW5zs6rELlllm
         OIopnOkJlYqnQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 0DE1052142D;
        Thu, 20 May 2021 22:17:46 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:17:45 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 10/18] virtio/vsock: defines and constants for SEQPACKET
Date:   Thu, 20 May 2021 22:17:36 +0300
Message-ID: <20210520191739.1271886-1-arseny.krasnov@kaspersky.com>
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

Add set of defines and constants for SOCK_SEQPACKET support
in vsock.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/virtio_vsock.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 1d57ed3d84d2..3dd3555b2740 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -38,6 +38,9 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
+/* The feature bitmap for virtio vsock */
+#define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+
 struct virtio_vsock_config {
 	__le64 guest_cid;
 } __attribute__((packed));
@@ -65,6 +68,7 @@ struct virtio_vsock_hdr {
 
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
 };
 
 enum virtio_vsock_op {
@@ -91,4 +95,9 @@ enum virtio_vsock_shutdown {
 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
 };
 
+/* VIRTIO_VSOCK_OP_RW flags values */
+enum virtio_vsock_rw {
+	VIRTIO_VSOCK_SEQ_EOR = 1,
+};
+
 #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
-- 
2.25.1

