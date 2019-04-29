Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE8E907
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfD2R3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbfD2R3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 13:29:08 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38602075E;
        Mon, 29 Apr 2019 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556558947;
        bh=15tEcoLaTtLGIbDl7Cs3q1VFsi31mp8hV3LirZFn2H4=;
        h=From:To:Cc:Subject:Date:From;
        b=zpyS1U+uThYuIboqSsZCYIW1l7oTi/GXBrO0pgbmW/2SxWqqsjPZ0ABDidpKwx3hO
         BLK3x0EYqY/RNc5HLzrvxLL0rCm+oIvP4nO9iNZ6Vxp2deG+Y0Pin18DAwWJVkKyfZ
         5IhKtyy08Q7TK7wbjhTCemFSonTAb35wRXw/y1sQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, liuhangbin@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] selftests: fib_rule_tests: Fix icmp proto with ipv6
Date:   Mon, 29 Apr 2019 10:30:09 -0700
Message-Id: <20190429173009.8396-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A recent commit returns an error if icmp is used as the ip-proto for
IPv6 fib rules. Update fib_rule_tests to send ipv6-icmp instead of icmp.

Fixes: 5e1a99eae8499 ("ipv4: Add ICMPv6 support when parse route ipproto")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index d4cfb6a7a086..5b92c1f4dc04 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -147,8 +147,8 @@ fib_rule6_test()
 
 	fib_check_iproute_support "ipproto" "ipproto"
 	if [ $? -eq 0 ]; then
-		match="ipproto icmp"
-		fib_rule6_test_match_n_redirect "$match" "$match" "ipproto icmp match"
+		match="ipproto ipv6-icmp"
+		fib_rule6_test_match_n_redirect "$match" "$match" "ipproto ipv6-icmp match"
 	fi
 }
 
-- 
2.11.0

