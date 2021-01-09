Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923182F02F2
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAISz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbhAISzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 13:55:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44E05239EB;
        Sat,  9 Jan 2021 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218452;
        bh=+w6BT02pj2FkKynyrgV5mmoQCBwxx0cX64Ygv1uHuXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3aF/uwVGfNsS67r5q2tfIcq4YFYlL2/SJ+1iOvM0oY11ivT/+uR7e2B86s84liTy
         MxjTm64pNeE3REl0EixcAqzFoesQAZ6cCepiVq6D5ACjrWJ7Y43XtyKS3mbYCbVzeT
         z2+6mNII6Uis9Yf8xbPFuY86ixlsP54V+dyzgImGxVXNCFFFJ2B0+O0EaGKMwyQKZu
         7uK7DyD0PF9p8xu8WRNN9FKYBjnnQEricds1U4Z81PMajcM2xkemULJvjR7QCaOXC+
         XMgWKUl4jGliWBr0XGknAUpP1KeuLSqJz2f15vfTD8yYG+aadUC6CSPwLZNH0HF0TF
         e3jLM5n9cuK6w==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/11] selftests: Add missing newline in nettest error messages
Date:   Sat,  9 Jan 2021 11:53:54 -0700
Message-Id: <20210109185358.34616-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210109185358.34616-1-dsahern@kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
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
index ab3e268c12a9..b1d6874d69ee 100644
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

