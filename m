Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72902A4CC5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgKCRYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbgKCRYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:36 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A02CC0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:35 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 205so85705wma.4
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJvu8f2jgbnJqs1NY6YsP4oxwkKYOvAd3eazDvKS0GI=;
        b=g+69WtLfjhgsl+7v0a3curceaiZQaK+hNEG0UuCK88gnmq2yKLMI9heFnt7ZKzGER2
         Krxonchdb+j3nEXNS0BRqY2EaTllTf7rOwW+4up+hQ8B+OGtVmmoRnvw7HVjgY2Nkjgv
         magldk+KL2ncKXmYUK7YkFEYKcdfWrYzRjvAtYiqoDSjgKO/I3fMhfWecpefFk9yt6IL
         ixzvd6YWlVHWH4oEVmQ0iWY6oxqc3i45CSp72DJ/Q+gUmAl6VCJECo6z1WdpOMWtMzTF
         lPIazRPIzkQtePTpdEnEE9kdGG7axZtUHDsCaShXU9Q+5EWXLwsKnf3jEeXc2uRxwj+X
         xDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJvu8f2jgbnJqs1NY6YsP4oxwkKYOvAd3eazDvKS0GI=;
        b=gJ7DXEzXDQ9Njt8hmJa4R3wmkJArq+TBbJcNFGNn50jiboHJ9UHE4axsVRP9zmu8LW
         vEoJm1EZNB8bQ1rfZiSWQmGLm4lhdWhqofuzx/hzskGQ+Bqjr/7VBR8UVbtxzWUOpER8
         HCV2Yc81Fu05I/V2jRw1hf4k9hE/1Olw+MpSJLZACQpoiUma2rWtGVfjybonYWco9T+l
         Lcm8VqqpStR0R1nHA98KJrqnmEZyjwYBUWQppYya30P/kKDaOT6A75rx6vM/oJ+smGaj
         ZK0Pph8R/GUZkDxwREbiV9pk0lFsRC30Krh+1X+9/synPe0FqaoAv11b0s6HbIId1fI6
         8smQ==
X-Gm-Message-State: AOAM530NjJ213hZ1JEZ0Za3Dq710Ml53nrQTZAWbnZC0cgm+xhluAAHF
        f2+FirO3sq59srvPy+MaLazrHFzkA4aHokgE
X-Google-Smtp-Source: ABdhPJwZAIOV+nauKiS1IVebL2y9F3nncAa9ZEJ3reSeuzMIOvHbbW1qxa46xQmzLf+ycR3MG7CueQ==
X-Received: by 2002:a1c:8194:: with SMTP id c142mr218010wmd.94.1604424273589;
        Tue, 03 Nov 2020 09:24:33 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:33 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 16/16] selftests: net: bridge: add test for mldv2 *,g auto-add
Date:   Tue,  3 Nov 2020 19:24:12 +0200
Message-Id: <20201103172412.1044840-17-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When we have *,G ports in exclude mode and a new S,G,port is added
the kernel has to automatically create an S,G entry for each exclude
port to get proper forwarding.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index b34cf4c6ceba..ffdcfa87ca2b 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -4,7 +4,7 @@
 ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test \
 	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test \
 	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test mldv2inc_block_test \
-	   mldv2exc_block_test mldv2exc_timeout_test"
+	   mldv2exc_block_test mldv2exc_timeout_test mldv2star_ex_auto_add_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -519,6 +519,35 @@ mldv2exc_timeout_test()
 	mldv2cleanup $swp1
 }
 
+mldv2star_ex_auto_add_test()
+{
+	RET=0
+
+	mldv2exclude_prepare $h1
+
+	$MZ $h2 -c 1 $MZPKT_IS_INC -q
+	sleep 1
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .src == \"2001:db8:1::3\" and \
+				.port == \"$swp1\")" &>/dev/null
+	check_err $? "S,G entry for *,G port doesn't exist"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .src == \"2001:db8:1::3\" and \
+				.port == \"$swp1\" and \
+				.flags[] == \"added_by_star_ex\")" &>/dev/null
+	check_err $? "Auto-added S,G entry doesn't have added_by_star_ex flag"
+
+	brmcast_check_sg_fwding 1 2001:db8:1::3
+
+	log_test "MLDv2 S,G port entry automatic add to a *,G port"
+
+	mldv2cleanup $swp1
+	mldv2cleanup $swp2
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

