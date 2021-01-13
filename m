Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525D82F42C5
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbhAMEC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbhAMECS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:02:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 633A82313C;
        Wed, 13 Jan 2021 04:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510460;
        bh=VtTAAwoboFoJjnhHiRxUit3l9jLhoh3r8kOPDy+6R3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbSJKikC7UkcDJFKbxocIlJb2tDfMWKFsE/NPxAIZRRe3SJ/H/wS6p3pEV5mXs7Od
         fGrBvTMp2eEc1SRjyJxhLPwcmXOMkylDrCqyWFn564YK4FSY/ZzV1xvO2p3I4wc/IW
         jn2vquBqBqAAW4WtXbmIALV3xwJkUdHqJWqn0ZVCt5RO79YY8x1BZDkYn12qB97TM5
         HLvWLM5SGVJsHaK7HOiXdrGFbZwsw5xg8LtSjWTBYExWTUPdbH2L1ESPMSVMd3jP37
         c+1fPeE9u3/U/EtQc3FNDUNabj6RcY5Cd35U2NfAIlAMSMztltcAGdmsl4ld6aYOIe
         9mJm4D6hJARFQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 07/13] selftests: Add missing newline in nettest error messages
Date:   Tue, 12 Jan 2021 21:00:34 -0700
Message-Id: <20210113040040.50813-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A few logging lines are missing the newline, or need it moved up for
cleaner logging.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 9114bc823092..dded36a7db41 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -199,7 +199,7 @@ static void log_address(const char *desc, struct sockaddr *sa)
 	if (sa->sa_family == AF_INET) {
 		struct sockaddr_in *s = (struct sockaddr_in *) sa;
 
-		log_msg("%s %s:%d",
+		log_msg("%s %s:%d\n",
 			desc,
 			inet_ntop(AF_INET, &s->sin_addr, addrstr,
 				  sizeof(addrstr)),
@@ -208,15 +208,13 @@ static void log_address(const char *desc, struct sockaddr *sa)
 	} else if (sa->sa_family == AF_INET6) {
 		struct sockaddr_in6 *s6 = (struct sockaddr_in6 *) sa;
 
-		log_msg("%s [%s]:%d",
+		log_msg("%s [%s]:%d\n",
 			desc,
 			inet_ntop(AF_INET6, &s6->sin6_addr, addrstr,
 				  sizeof(addrstr)),
 			ntohs(s6->sin6_port));
 	}
 
-	printf("\n");
-
 	fflush(stdout);
 }
 
@@ -594,7 +592,7 @@ static int expected_addr_match(struct sockaddr *sa, void *expected,
 		struct in_addr *exp_in = (struct in_addr *) expected;
 
 		if (s->sin_addr.s_addr != exp_in->s_addr) {
-			log_error("%s address does not match expected %s",
+			log_error("%s address does not match expected %s\n",
 				  desc,
 				  inet_ntop(AF_INET, exp_in,
 					    addrstr, sizeof(addrstr)));
@@ -605,14 +603,14 @@ static int expected_addr_match(struct sockaddr *sa, void *expected,
 		struct in6_addr *exp_in = (struct in6_addr *) expected;
 
 		if (memcmp(&s6->sin6_addr, exp_in, sizeof(*exp_in))) {
-			log_error("%s address does not match expected %s",
+			log_error("%s address does not match expected %s\n",
 				  desc,
 				  inet_ntop(AF_INET6, exp_in,
 					    addrstr, sizeof(addrstr)));
 			rc = 1;
 		}
 	} else {
-		log_error("%s address does not match expected - unknown family",
+		log_error("%s address does not match expected - unknown family\n",
 			  desc);
 		rc = 1;
 	}
@@ -731,7 +729,7 @@ static int convert_addr(struct sock_args *args, const char *_str,
 		}
 		break;
 	default:
-		log_error("unknown address type");
+		log_error("unknown address type\n");
 		exit(1);
 	}
 
-- 
2.24.3 (Apple Git-128)

