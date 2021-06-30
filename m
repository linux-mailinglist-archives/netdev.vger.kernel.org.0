Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B913B7C16
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 05:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhF3Dgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 23:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhF3Dgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 23:36:39 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3924C061760;
        Tue, 29 Jun 2021 20:34:10 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 19so1046652qky.13;
        Tue, 29 Jun 2021 20:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JlKNMEqpq8mloT6aSYxFBY1VdN5zVl85hWhebvszHaU=;
        b=vJk157RmJeVBD7xbdY4Pb9VOz3BWUknZLUqSsiUZS1HLHjw2AROju/z3l3+K84Gp4m
         j7qt09N9EogGly83B+ALpqS3Oa991G0WyNtaVDkag+dGBKHp0ew1f/nnWhb5fwYclHUn
         NlL08IgMtrzlPNwly9md6ZkIoCjrUrWV053RxXl3jIp9E09cFdzexJDUMDwUXgTyDTN5
         vjTVj0k3TOOv5mXzqK9GX9/IWXK/KnObCKzfZPLXxq/5/SMfxK6SzjiPoS78dMs1qQbv
         OEopQMnHyks4kzK90BfZxuMoCiwOSG2+uvVSfIcEqheK6iQ+tCwvXNuTkjNr/W5haltr
         9w3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JlKNMEqpq8mloT6aSYxFBY1VdN5zVl85hWhebvszHaU=;
        b=tD7evqxg6VguvzM7uJyLrAm2BMK+4msqdUqOgHpUFe6P81wHRCErZ+HXiZYGd5KVsz
         cSf7h7DW5FGF+SMPQuw4e8orzWrjRx1inq1iasD4J019Cq1wznqMlioJLWH4/k95Rcs9
         2IVv1D5HZjoZ8kPU0fh3fkDBNnGHgvPoin6rV1dpTxjshQs80AloCyEtTr2AFJa0nxam
         4hYlQHPBa8xkyWdvardGp166EUD+Wa1dsWVSNh+hswRk0yn66IW60R6p9yZlMKUuaBQM
         0/PZwBmJwaFMXi/KJ1QMz9e5dCJeXcx8XRfHUyzwm1GRC3jqwC4kPhlLJyCiNWTn1q57
         pzrw==
X-Gm-Message-State: AOAM531QuC2au5aRnozNX/bLSml03mF4dgCRP8tGX5LRYObpFqIMahWn
        5vCNcPimBLvwoALn3E6kc+tWTP1VJ2YUdg==
X-Google-Smtp-Source: ABdhPJzd2SKi6gmNdt+6MKwLUea7VaYKK/J/U2Skq+ABMJRig0E1g7MQaNbxSV+6Wa0UUPItAiprfg==
X-Received: by 2002:a05:620a:20d1:: with SMTP id f17mr13381110qka.185.1625024049600;
        Tue, 29 Jun 2021 20:34:09 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 128sm4811975qkf.102.2021.06.29.20.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 20:34:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next] sctp: move 198 addresses from unusable to private scope
Date:   Tue, 29 Jun 2021 23:34:08 -0400
Message-Id: <c3f8dfcf952ebfd1ebe0108fc13aacedbad38e99.1625024048.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The doc draft-stewart-tsvwg-sctp-ipv4-00 that restricts 198 addresses
was never published. These addresses as private addresses should be
allowed to use in SCTP.

As Michael Tuexen suggested, this patch is to move 198 addresses from
unusable to private scope.

Reported-by: Sérgio <surkamp@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/constants.h | 4 +---
 net/sctp/protocol.c          | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 265fffa33dad..5859e0a16a58 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -360,8 +360,7 @@ enum {
 #define SCTP_SCOPE_POLICY_MAX	SCTP_SCOPE_POLICY_LINK
 
 /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
- * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
- * 192.88.99.0/24.
+ * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 192.88.99.0/24.
  * Also, RFC 8.4, non-unicast addresses are not considered valid SCTP
  * addresses.
  */
@@ -369,7 +368,6 @@ enum {
 	((htonl(INADDR_BROADCAST) == a) ||  \
 	 ipv4_is_multicast(a) ||	    \
 	 ipv4_is_zeronet(a) ||		    \
-	 ipv4_is_test_198(a) ||		    \
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index bc5db0b404ce..3ab1a2db1ff2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -393,7 +393,8 @@ static enum sctp_scope sctp_v4_scope(union sctp_addr *addr)
 		retval = SCTP_SCOPE_LINK;
 	} else if (ipv4_is_private_10(addr->v4.sin_addr.s_addr) ||
 		   ipv4_is_private_172(addr->v4.sin_addr.s_addr) ||
-		   ipv4_is_private_192(addr->v4.sin_addr.s_addr)) {
+		   ipv4_is_private_192(addr->v4.sin_addr.s_addr) ||
+		   ipv4_is_test_198(addr->v4.sin_addr.s_addr)) {
 		retval = SCTP_SCOPE_PRIVATE;
 	} else {
 		retval = SCTP_SCOPE_GLOBAL;
-- 
2.27.0

