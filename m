Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6B73D1A5F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhGUWmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhGUWmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 18:42:17 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FA9C061575;
        Wed, 21 Jul 2021 16:22:53 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id j7so3072844qtj.6;
        Wed, 21 Jul 2021 16:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pozbzGVzs8EDjWr/Isfr8VZlmmrHC7hULWqF8mz9+Xo=;
        b=azUZRQH7bhfATqyNF86v4JQHKEKaObrAlMHQ8FX5Ck2jdYXcCdz11mIJ05zSiFFoq3
         S7ZuuR5mAXoEo8j58afrfe9sge5kCcc+A5F/KRDViziVUsKPDDwt6N5MLJwhngsy2hpn
         9L4Ot5h46sqVeVPk9iclYmhev4QnIV4Lq219+uPYRhpqrG5XOFEcfYu6Ep6qynefk+L/
         1wHRhrBfELR7kd2GMGVl4Ay1P6p+SrpN5ZwtQ5INx1qCX4QDLN0ZIht1kAwbSn77AR1w
         E7jIQiSPsbgrtZj8fO5zlLfpuNFslZJNxtlEs4IVJ1jcDBmAnmBtvs7OBadcb0Nrm6fs
         mkTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pozbzGVzs8EDjWr/Isfr8VZlmmrHC7hULWqF8mz9+Xo=;
        b=mC+QFgL6xm9ZnN93VhBLT3ufQuZrYKX5AyiAV+RLW4v9GkRLys/2+bntQeIFa1K1dI
         IkiEokhLOors6aLl8yxDDS3aTuhdagFPSNERGMWEH4nYVAObf1WyCTSe73kfC7noi9On
         UnpYA0HN2VfYws65AryMtgY1RvyIYXQSldZpBtDk549OQH+k+vUYGN/aIYFa3Jn9/O1q
         mpRI4YfMpNzYBituQeyOGTLcll3oOYs8JwvINkWc9ejI/yoR3q+EhmEaTctje2BxcxBK
         q4r4OvbzgGG43FHyEFQvvYEZHRGThoVgUQStl8Na9f+INIdTMezBYYqsOtqSmv25UtwR
         TXrg==
X-Gm-Message-State: AOAM533bPZslqzqw0YN3WVjGF42I9tz8iWeaIVG8vv80+xhYwS9jiWRP
        BTLyUErqWd7nAHt8K6d/1A==
X-Google-Smtp-Source: ABdhPJzQ8SJgmO30XBcBnvfbnsCN4ckh2jCVvOvrbZ4ELmKOrnjoJ5I8BNDeE6oJE2rPVdbt5w2Ofg==
X-Received: by 2002:a05:622a:1342:: with SMTP id w2mr33443452qtk.310.1626909772739;
        Wed, 21 Jul 2021 16:22:52 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id k9sm6531563qti.88.2021.07.21.16.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 16:22:52 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Shuah Khan <shuah@kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 2/2] tc-testing: Add control-plane selftest for skbmod SKBMOD_F_ECN option
Date:   Wed, 21 Jul 2021 16:22:44 -0700
Message-Id: <21ca3638f09c55d0e1deb439f82a1124aff80144.1626899889.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <f5c5a81d6674a8f4838684ac52ed66da83f92499.1626899889.git.peilin.ye@bytedance.com>
References: <f5c5a81d6674a8f4838684ac52ed66da83f92499.1626899889.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we added a new option, SKBMOD_F_ECN, to tc-skbmod(8).  Add a
control-plane selftest for it.

Depends on kernel patch "net/sched: act_skbmod: Add SKBMOD_F_ECN option
support", as well as iproute2 patch "tc/skbmod: Introduce SKBMOD_F_ECN
option".

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

The corresponding iproute2-next patch is here:
https://lore.kernel.org/netdev/20210721232053.39077-1-yepeilin.cs@gmail.com/

Thanks,
Peilin Ye

 .../tc-testing/tc-tests/actions/skbmod.json   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/skbmod.json b/tools/testing/selftests/tc-testing/tc-tests/actions/skbmod.json
index 6eb4c4f97060..742f2290973e 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/skbmod.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/skbmod.json
@@ -417,5 +417,29 @@
         "teardown": [
             "$TC actions flush action skbmod"
         ]
+    },
+    {
+        "id": "fe09",
+        "name": "Add skbmod action to mark ECN bits",
+        "category": [
+            "actions",
+            "skbmod"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action skbmod",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action skbmod ecn",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action skbmod index 1",
+        "matchPattern": "action order [0-9]*: skbmod pipe ecn",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action skbmod"
+        ]
     }
 ]
-- 
2.20.1

