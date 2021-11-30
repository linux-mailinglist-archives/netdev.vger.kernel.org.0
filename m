Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9007946376F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbhK3Oxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242761AbhK3Owj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:52:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3151DC0613F9;
        Tue, 30 Nov 2021 06:48:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E761CE1A53;
        Tue, 30 Nov 2021 14:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67231C53FC1;
        Tue, 30 Nov 2021 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283716;
        bh=88TuTQArwI04rN4GYmJhGXgsohvu3NNdljtOdwJzUpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPyGS47ctCaUjHgyAHZcSQsJiYpPhhnqeN2LwOTUIjqvKVegnM3Al3hR8yOE2gxNM
         0BZ9N0gjXvMLdlZCSGZkUNmys+t3IxJYlSkYvdAiFAGK8rq4mX7KjUaKm/wKHVCpML
         FUGL9EwcyFYjjMCMJHNWrgJNvcWJ3QBEjsrUekgc37THzWJYBPyxRZCAu+gh65CyFA
         1Ag8jYAswiR4ZJV61Zx6gcPBs1CNcjTE5AFhk+HBNn4P9m1TAvOKB8wizhy7tHlxTD
         dQ4htf2njG43LamXGr+09Uw4ZS32Sy2ncxNVwE+Yh+NlvHrmThVEKUZCptDSMkNn8h
         AMSNlTiiFwG5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhijian <zhijianx.li@intel.com>,
        kernel test robot <lkp@intel.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 30/68] selftests/tc-testing: match any qdisc type
Date:   Tue, 30 Nov 2021 09:46:26 -0500
Message-Id: <20211130144707.944580-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Zhijian <zhijianx.li@intel.com>

[ Upstream commit bdf1565fe03d29777d24e239163d0d53e4af9ce0 ]

We should not always presume all kernels use pfifo_fast as the default qdisc.

For example, a fq_codel qdisk could have below output:
qdisc fq_codel 0: parent 1:4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/tc-testing/tc-tests/qdiscs/mq.json     | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
index 88a20c781e498..c6046096d9db8 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
@@ -15,7 +15,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "0",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "4",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -37,7 +37,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "0",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-9,a-f][0-9,a-f]{0,2} bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-9,a-f][0-9,a-f]{0,2}",
 	    "matchCount": "256",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -60,7 +60,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "4",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -82,7 +82,7 @@
 	    "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "0",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -106,7 +106,7 @@
 	    "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "0",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -128,7 +128,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "0",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
-- 
2.33.0

