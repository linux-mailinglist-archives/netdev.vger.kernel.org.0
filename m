Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EBD3FDEC0
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343750AbhIAPgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbhIAPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:35:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FCEC061760;
        Wed,  1 Sep 2021 08:35:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c6so2155278pjv.1;
        Wed, 01 Sep 2021 08:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvCpZTAygKwbhMNtaHrStRromIJWQVL8XPEWvMCummI=;
        b=Mv/UAatQ80eXiPU6Awpr2EUrDsQDr68BfzI/sUBQMHfHeySiay4USN7guY3Hjo4eKl
         MpIPFfg7CqP7j+SZVEiSslbXoPxnYly4ZLUgDfHbhZ2yEYiHhwjJRVK1U+k94lj19XET
         Aempl5Nwl9PGodjtW1i8GkGjjDmjVvPr1hmHIfTypqqYXLG9/29quKLdpxmcFfG9kUUz
         1SWE4xbAJON0pKwBFNmnGxBLVOc7deihTi90gbMzvaHTLWVWipthE2Eagr2sOOThggBO
         96Yyx2Jfkx/aL+C/a+w2XsfTEuDA0dL4UHdJVmARsXFpM+ebtYDoyT3cOTyi2VkMYa5N
         yOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvCpZTAygKwbhMNtaHrStRromIJWQVL8XPEWvMCummI=;
        b=kxrCyXXndf8MqjxmsSobfOmRPjE9KkzMcI0jRX97SOhR+Idp+6FFY59/GvBhaq2NhP
         i7o7nHTTIu7RkhMvq2vowiL7W3vKHG0RyT5nH2VBzEO6m5flsNkdtkjQVNG9jp4HkPrS
         igvxiwAUNiKXjfzoOXO81BBdjRpNj3FP3AY37LtXXoaiHgV34i8lTbP1WjICYHthyz8z
         38N7CyAMl3/unnJ5ZgY4V7vCz8KjXM3HprBlY8pV+o36VVnz9uTPCQhXLzYWh+YY80SH
         UL/qL5CTMGa+nwN75zPqlyFdoQq8Rmp7mcrOBh7fI7VAAzw4zPxDXv+fFGlLVBWoNxNg
         wwcQ==
X-Gm-Message-State: AOAM533t7sLSz2MhZiRfM5d2xIy7YQUMsuolwWswbFUMnNXtqsmNdNbo
        NZAb/09JbOid3YtSawGfLGY=
X-Google-Smtp-Source: ABdhPJxRATpCmliOkp20ZZdvq4n6gdmDSkssTiQ0n+9K2jjmxAhKTq8dbkJZzNAOuGdrbP9c5/QXIQ==
X-Received: by 2002:a17:90a:1982:: with SMTP id 2mr12118734pji.112.1630510500954;
        Wed, 01 Sep 2021 08:35:00 -0700 (PDT)
Received: from localhost.localdomain ([222.238.85.219])
        by smtp.gmail.com with ESMTPSA id x15sm336650pfq.31.2021.09.01.08.34.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 08:35:00 -0700 (PDT)
From:   Jiwon Kim <jiwonaid0@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiwon Kim <jiwonaid0@gmail.com>
Subject: [PATCH net-next] ipv6: change return type from int to void for mld_process_v2
Date:   Thu,  2 Sep 2021 00:34:49 +0900
Message-Id: <20210901153449.26067-1-jiwonaid0@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mld_process_v2 only returned 0.

So, the return type is changed to void.

Signed-off-by: Jiwon Kim <jiwonaid0@gmail.com>
---
 net/ipv6/mcast.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index cd951faa2fac..bed8155508c8 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1356,8 +1356,8 @@ static int mld_process_v1(struct inet6_dev *idev, struct mld_msg *mld,
 	return 0;
 }
 
-static int mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
-			  unsigned long *max_delay)
+static void mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
+			   unsigned long *max_delay)
 {
 	*max_delay = max(msecs_to_jiffies(mldv2_mrc(mld)), 1UL);
 
@@ -1367,7 +1367,7 @@ static int mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 
 	idev->mc_maxdelay = *max_delay;
 
-	return 0;
+	return;
 }
 
 /* called with rcu_read_lock() */
@@ -1454,9 +1454,7 @@ static void __mld_query_work(struct sk_buff *skb)
 
 		mlh2 = (struct mld2_query *)skb_transport_header(skb);
 
-		err = mld_process_v2(idev, mlh2, &max_delay);
-		if (err < 0)
-			goto out;
+		mld_process_v2(idev, mlh2, &max_delay);
 
 		if (group_type == IPV6_ADDR_ANY) { /* general query */
 			if (mlh2->mld2q_nsrcs)
-- 
2.25.1

