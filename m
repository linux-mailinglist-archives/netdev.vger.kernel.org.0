Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F901D6BA7
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgEQSAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 14:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgEQSAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 14:00:40 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DE420674;
        Sun, 17 May 2020 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589738440;
        bh=ZeNSQTxwVxkV6z4JDdpAOLXsmpGfe//zhaQui1tCzK0=;
        h=From:To:Cc:Subject:Date:From;
        b=gD2IJjcmGoeN9mJn6iHyjBnSFdivJfPIqES7CloT90ompRfReQ4CgR7cS6kuJH/He
         21n97F+x4+o11wac61DJUmAZiT6OwZuSMyWzLz8LyOfkiRtUwdKN3NUNI2NKhYrQt2
         R39MKJJunYpP3XXLhIhc0UCwJ1SnSXZqVFArrZAc=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net-next] selftests: Drop 'pref medium' in route checks
Date:   Sun, 17 May 2020 12:00:33 -0600
Message-Id: <20200517180033.75775-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The 'pref medium' attribute was moved in iproute2 to be near the prefix
which is where it applies versus after the last nexthop. The nexthop
tests were updated to drop the string from route checking, but it crept
in again with the compat tests.

Fixes: 4dddb5be136a ("selftests: net: add new testcases for nexthop API compat mode sysctl")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index dd0e5fec6367..50d822face36 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -965,7 +965,7 @@ ipv6_compat_mode()
 	log_test $? 0 "IPv6 compat mode on - route add notification"
 
 	# route dump should contain expanded nexthops
-	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop via 2001:db8:91::3 dev veth1 weight 1"
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop via 2001:db8:91::3 dev veth1 weight 1"
 	log_test $? 0 "IPv6 compat mode on - route dump"
 
 	# change in nexthop group should generate route notification
@@ -992,7 +992,7 @@ ipv6_compat_mode()
 	log_test $? 0 "IPv6 compat mode off - route add notification"
 
 	# route dump should not contain expanded nexthops
-	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium"
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024"
 	log_test $? 0 "IPv6 compat mode off - route dump"
 
 	# change in nexthop group should not generate route notification
-- 
2.21.1 (Apple Git-122.3)

