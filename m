Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ECB2B7F58
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgKROZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:25:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbgKROZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:25:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605709507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XlUtYN9I1jTM0ZwVMsk+cNHUe7M2ezNY7akFMHeqpTc=;
        b=XDPBdIvfO/oLHxXPjIg1dAq479Fc5Xo3TlKSqP1qudl7D+pIuKmLwYf5vUJgQ0O9IMJAz5
        mF2X4hftEE1CDdJV/NkzgfN3cbXvQQCVHoTxwvgnIDqhdzd3Agi9h98R8slh/n3Zdm/yAI
        dmVSsdQc1k0/Mq2FPloxCGSseTogh0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-Mhtd6tqoOYiLM2WoSOC8cw-1; Wed, 18 Nov 2020 09:25:05 -0500
X-MC-Unique: Mhtd6tqoOYiLM2WoSOC8cw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A50F64082;
        Wed, 18 Nov 2020 14:25:03 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74A195D6AC;
        Wed, 18 Nov 2020 14:25:02 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ss: mptcp: fix add_addr_accepted stat print
Date:   Wed, 18 Nov 2020 15:24:18 +0100
Message-Id: <a4925e2d0fa0e07a14bbef3744594d299e619249.1605708791.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add_addr_accepted value is not printed if add_addr_signal value is 0.
Fix this properly looking for add_addr_accepted value, instead.

Fixes: 9c3be2c0eee01 ("ss: mptcp: add msk diag interface support")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 misc/ss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index 77e1847ee2473..0593627b77e31 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -3136,7 +3136,7 @@ static void mptcp_stats_print(struct mptcp_info *s)
 		out(" subflows:%d", s->mptcpi_subflows);
 	if (s->mptcpi_add_addr_signal)
 		out(" add_addr_signal:%d", s->mptcpi_add_addr_signal);
-	if (s->mptcpi_add_addr_signal)
+	if (s->mptcpi_add_addr_accepted)
 		out(" add_addr_accepted:%d", s->mptcpi_add_addr_accepted);
 	if (s->mptcpi_subflows_max)
 		out(" subflows_max:%d", s->mptcpi_subflows_max);
-- 
2.26.2

