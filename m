Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3013725AA77
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIBLoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:44:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726567AbgIBLof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599047071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P1x4dyGb8dmVuQOt1tXN0RRHxenX9CUUMzSh82Yltm0=;
        b=V/EonPx5yE0X3w6i2UONkBbZPgh7H0AdO5nq1nubepvMWbxnGe9cNPdqOQoKdrpSfciq1M
        tj0qj6cHU9aRJ8882FOhJh9VptFrWdcjW9Ck7VphidSowNcblMPz2XDYvbOPK2tBrrx3VD
        N7KR0tFr9NjkVgo/kFrip77DYqLGg5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-HHorWH6ZNEOSS2cT3rKyOA-1; Wed, 02 Sep 2020 07:44:29 -0400
X-MC-Unique: HHorWH6ZNEOSS2cT3rKyOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D834910ABDB8;
        Wed,  2 Sep 2020 11:44:28 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.195.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7EC15D9CC;
        Wed,  2 Sep 2020 11:44:27 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     mptcp@lists.01.org, netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next] selftests: mptcp: fix typo in mptcp_connect usage
Date:   Wed,  2 Sep 2020 13:44:24 +0200
Message-Id: <6c43e5404c41f91ed9324e20c35a4e4fdb0ed1de.1599046871.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in mptcp_connect, 's' selects IPPROTO_MPTCP / IPPROTO_TCP as the value of
'protocol' in socket(), and 'm' switches between different send / receive
modes. Fix die_usage(): swap 'm' and 's' and add missing 'sendfile' mode.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 090620c3e10c..a54966531a64 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -65,8 +65,8 @@ static void die_usage(void)
 	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
 	fprintf(stderr, "\t-R num -- set SO_RCVBUF to num\n");
 	fprintf(stderr, "\t-p num -- use port num\n");
-	fprintf(stderr, "\t-m [MPTCP|TCP] -- use tcp or mptcp sockets\n");
-	fprintf(stderr, "\t-s [mmap|poll] -- use poll (default) or mmap\n");
+	fprintf(stderr, "\t-s [MPTCP|TCP] -- use mptcp(default) or tcp sockets\n");
+	fprintf(stderr, "\t-m [poll|mmap|sendfile] -- use poll(default)/mmap+write/sendfile\n");
 	fprintf(stderr, "\t-u -- check mptcp ulp\n");
 	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
 	exit(1);
-- 
2.26.2

