Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37892A4CAE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgKCRY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbgKCRYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:23 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D3C0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:22 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id y12so19362357wrp.6
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dNyIExP8c9yMd7IzGVWPAaLZGLs2zadG76onwKL9QZM=;
        b=TljOs6rbX9O++Nptjxew0JrB01mnJ8mehSMrWfPFF2baZNj6e5EAoxlu0LWJsTy3ao
         5F4T0rqsZYeUrcZT3hPGJrRMD3f8EqbpRSJgqQWx+7cWtPQWl7YKHJdX5WUYqiPCg/MM
         V2Y8W2x+nUb9rKhW/ghg0qCFxiV641INL6Mk0pwlagMUZjezYlPgb3LhMzlb/N43RA3t
         J5J9HKTwsyjiMvEugiOKd/pu2JFrhRvMcJKtV+2Ohx79eadzpbwstZ8Cs3lJ9EixG9p7
         7rIyBXIRGoKppp9a3R6vXzl6PtFSEytxeAw0T2iB5pOLIhylaZ+YcK7EWteoDikRLg0V
         YPOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNyIExP8c9yMd7IzGVWPAaLZGLs2zadG76onwKL9QZM=;
        b=ZAWalpq6Yw5SNw69x99RpRuaz3n7YWvfhLFwlWkTHOnECJTg/qiHjErLfSB7Zt+enq
         QapIkdNpGi/v9tQdH/sckXqIUxaNNMuTIIN/ZLCZlhWrctFUtAhmGaJWuFCNcbt8GfzJ
         m26mobyOCME08nDKyLAPf6U6H53gQFUOTGtA69qzt30gZG2+zW5H/GSINfZhWrMjA8xc
         G6WeqX6IFg9bhUBgo28josg6I6VSuXfDn5mJAmu0YTK05qic1w6xwwjCQR/M/hPwNnmT
         TVN/ESdbpKinNjbhnF68b0GuKAG6AODmUbosl4jBb5hDjTx7ImUtu5ow+JSEjLYc+jNM
         odsw==
X-Gm-Message-State: AOAM533yZK+bUtKeZKIxU3NB5jGI4VvBqtG0oFTUTa8zMlm5sLLbgt3m
        kDLEZfKEd2iZ+M/WrzsRP+ByFppDlxsFzXU4
X-Google-Smtp-Source: ABdhPJyZj1xy6tlFq+PgIg0mS77/IRivdvtLVeNUXS/8ttcygJ803RBdfgPWwd9YwP0JYdiE1zFzCQ==
X-Received: by 2002:a5d:694b:: with SMTP id r11mr27952409wrw.104.1604424259355;
        Tue, 03 Nov 2020 09:24:19 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:18 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 02/16] selftests: net: lib: add support for IPv6 mcast packet test
Date:   Tue,  3 Nov 2020 19:23:58 +0200
Message-Id: <20201103172412.1044840-3-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In order to test an IPv6 multicast packet we need to pass different tc
and mausezahn protocols only, so add a simple check for the destination
address which decides if we should generate an IPv4 or IPv6 mcast
packet.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index bb3ccc6d2165..0a427b8a039d 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1280,14 +1280,22 @@ mcast_packet_test()
 	local host1_if=$4
 	local host2_if=$5
 	local seen=0
+	local tc_proto="ip"
+	local mz_v6arg=""
+
+	# basic check to see if we were passed an IPv4 address, if not assume IPv6
+	if [[ ! $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
+		tc_proto="ipv6"
+		mz_v6arg="-6"
+	fi
 
 	# Add an ACL on `host2_if` which will tell us whether the packet
 	# was received by it or not.
 	tc qdisc add dev $host2_if ingress
-	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
+	tc filter add dev $host2_if ingress protocol $tc_proto pref 1 handle 101 \
 		flower ip_proto udp dst_mac $mac action drop
 
-	$MZ $host1_if -c 1 -p 64 -b $mac -A $src_ip -B $ip -t udp "dp=4096,sp=2048" -q
+	$MZ $host1_if $mz_v6arg -c 1 -p 64 -b $mac -A $src_ip -B $ip -t udp "dp=4096,sp=2048" -q
 	sleep 1
 
 	tc -j -s filter show dev $host2_if ingress \
@@ -1297,7 +1305,7 @@ mcast_packet_test()
 		seen=1
 	fi
 
-	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $host2_if ingress protocol $tc_proto pref 1 handle 101 flower
 	tc qdisc del dev $host2_if ingress
 
 	return $seen
-- 
2.25.4

