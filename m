Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294C53E5948
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbhHJLlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:41:50 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:12586 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbhHJLlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:41:49 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id C55D1520D32;
        Tue, 10 Aug 2021 14:41:25 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628595685;
        bh=eUL8Cw/3k5FqvIluVwVrx3fPpQfCpj6l3rLBCKcnnN0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=mFV6pKe4SLvIinyhV7MubM+cfcD6r1atmdi3BFkCZJP+MjUJZaCv2x4vDk4pOG1Ob
         1qLanFrTJHEoKm/R7adAQlZGiX6J8JkL6XfwTJCExrs/R6NnRM/J9k07tdNxIzRmyr
         XP+gCOgcaQw8ypRdSZ3N5SD2zEG3AKlK0rW3/cAvr1B33ZWmjN1V9s+ljoDx/1RZ0z
         aYXE2N9baOV0Ooy8xWUH1sVrvWoFxO3lvipw2snJCAXktwJ/S+E28ARUj/S668Lmlj
         iLSp2RKacCCV8WESlHKFPbgeQoZC3nMrRZEybuhKdKnVgj/0IpNuFFFCZYd1zfrXsJ
         644xTHnfJ1+PA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 76CDD520CB7;
        Tue, 10 Aug 2021 14:41:25 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 10
 Aug 2021 14:41:24 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 5/5] vsock_test: update message bounds test for MSG_EOR
Date:   Tue, 10 Aug 2021 14:41:16 +0300
Message-ID: <20210810114119.1215014-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/10/2021 11:26:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165493 [Aug 10 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/10/2021 11:29:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10.08.2021 6:55:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/10 08:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/10 05:40:00 #17007547
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set 'MSG_EOR' in one of message sent, check that 'MSG_EOR'
is visible in corresponding message at receiver.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 tools/testing/vsock/vsock_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 67766bfe176f..2a3638c0a008 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -282,6 +282,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 }
 
 #define MESSAGES_CNT 7
+#define MSG_EOR_IDX (MESSAGES_CNT / 2)
 static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 {
 	int fd;
@@ -294,7 +295,7 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 
 	/* Send several messages, one with MSG_EOR flag */
 	for (int i = 0; i < MESSAGES_CNT; i++)
-		send_byte(fd, 1, 0);
+		send_byte(fd, 1, (i == MSG_EOR_IDX) ? MSG_EOR : 0);
 
 	control_writeln("SENDDONE");
 	close(fd);
@@ -324,6 +325,11 @@ static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
 			perror("message bound violated");
 			exit(EXIT_FAILURE);
 		}
+
+		if ((i == MSG_EOR_IDX) ^ !!(msg.msg_flags & MSG_EOR)) {
+			perror("MSG_EOR");
+			exit(EXIT_FAILURE);
+		}
 	}
 
 	close(fd);
-- 
2.25.1

