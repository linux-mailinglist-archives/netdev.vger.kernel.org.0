Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A0D3D8570
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhG1BeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhG1BeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:34:07 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFC4C061757;
        Tue, 27 Jul 2021 18:34:05 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w10so272822qtj.3;
        Tue, 27 Jul 2021 18:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ESeIPTS91F+xbzWWUrKYtYdUuWj/eolcxwSojut3luM=;
        b=G2TUjLjc0k83E9TVyRVmaRadsAn7Z8GEiOcjHLnLA0Frqk8DfTnwMEhc+ziwiXkj1S
         eZEZaFVelfaK0J4qjW9gAPtkRM5j1Ay6onxio9CQ80kuyfMzbwLiDHCbWxSAxgna8Z7/
         xMDP2G0GM2QH6s80y83cPiFt5ED2mm8RfYvNuL7hJImg1m0R54RIzJ1wTx5Fj4pYkBBx
         zBy2IR/lxtS9wsDX1rnHJDMvN5euXKZcWHFU9PHc/VJugX29+hTxjCXMxelWgixdq1GC
         kF7+jEXxcxpfT7Izt+RuXjxZHDO1k2PxO/S9T13wozIYVLL4HvwvPn0uCkrFmLJZb48z
         IQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESeIPTS91F+xbzWWUrKYtYdUuWj/eolcxwSojut3luM=;
        b=KHo0MtGupeu15fF3F68Mr7hUr1gedzlcXkthTPHP9X11tG5yC5Ln0hZxYBKPHYOP9T
         0kNdQrcfE++XayHOCYuSUImWMYa1J4Z62mDLG25oz1mSKLnuJ/KhZ20f8ZN23GSVY221
         Gg0xb6x0QjPqz/JC71+3WZS1mviXkOLoiM9bmnTtNsodsBeCXvpO1ukfcoh6F2SqwH2m
         N9qmprrwH5EFl7Qzs2dH29mlN562xl90MtStEadC+Iexo7dq2zK0Rgk0EZ05gN+vwbD4
         XTnYJhbFnCAP4EOtMlj0KDlOcB2b4doXbWVTkzqdJA5i4CkMunh5HtneTnXTsaOU9bIb
         zAiA==
X-Gm-Message-State: AOAM5306Uw9dI2BPTUFPPe32kzNF66Li4jZrnMbJSXOCFY8FK0z6p0J0
        c1fbKFAkJN2mlyGeP6mKJw==
X-Google-Smtp-Source: ABdhPJx0thwuLZ4+tvyoLjwt6F5ZXn3u9dYqRc8BI2cGH8+FphyWyuGgMH5h9+9N8jfd0tYxRzGXdQ==
X-Received: by 2002:ac8:110e:: with SMTP id c14mr22267122qtj.76.1627436044968;
        Tue, 27 Jul 2021 18:34:04 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id n5sm2741054qkp.116.2021.07.27.18.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 18:34:04 -0700 (PDT)
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
Subject: [PATCH RESEND net-next 2/2] tc-testing: Add control-plane selftest for skbmod SKBMOD_F_ECN option
Date:   Tue, 27 Jul 2021 18:33:40 -0700
Message-Id: <1a2701d93dece40f515a869362be63ae03abbe93.1627434177.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <f5bd3c60662ec0982cccd8951990796b87d1f985.1627434177.git.peilin.ye@bytedance.com>
References: <f5bd3c60662ec0982cccd8951990796b87d1f985.1627434177.git.peilin.ye@bytedance.com>
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

