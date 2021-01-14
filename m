Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553282F58FD
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbhANDLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbhANDLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:11:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B995C23788;
        Thu, 14 Jan 2021 03:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593801;
        bh=f7FOP//LHy6zKZUypHUQpW83f6stVlIO3fD2YOfoTgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sj0KAEWc9S5stU11oYhm9v8L4X7xtorMEosr1cZAReSPryMvl9SgXik/ntyOI/1ow
         6A+ebGGYHrSPBddSGc81Z/MtXthh3Dd2wkydry0xVu2lAZxme3f9QJwa43ZgOYz4lQ
         Z6SqPGs+kefHxYM+tvrGOZT9sqNDos0RNMDAVMcREGTAyF3/KB1tLcvsvzwRZxJEeJ
         uQXSpN8ZkZ09CevEhy48YzrJOfE5pn6t3EFmdtr5eqGPCu+l5AOlJNg0w5PJYC8+Hr
         JRCucc82mr9SMDGaJWmHVSGDECZHnmrwH3Uz90ndcvE8OGCMTo7cVOFTgI/Mn9R9x4
         au5yi44GRxl5g==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v4 07/13] selftests: Add missing newline in nettest error messages
Date:   Wed, 13 Jan 2021 20:09:43 -0700
Message-Id: <20210114030949.54425-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210114030949.54425-1-dsahern@kernel.org>
References: <20210114030949.54425-1-dsahern@kernel.org>
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
index aba3615ce977..186262a702bf 100644
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

