Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B10C3DF7B0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 00:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhHCWRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 18:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHCWRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 18:17:23 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595EC061757;
        Tue,  3 Aug 2021 15:17:10 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 184so968479qkh.1;
        Tue, 03 Aug 2021 15:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qnVRKi3HtFJMrrAfoTHSGeqHbRWAKv0dYYUUOqnFejE=;
        b=r2xKT1UpP9TvcE+AII2AMV3y5m4saqt3/f8LL6w6X5UQyBNG404ma9aj3qpvziKPoL
         Rf2UaTdDfXevM9ZRux5pypAa/RbdogxOhYLM9fflySOsHJC35OEp18aAHXhDmxUUla3D
         dticrGoa+bZ2Eg5nY/KY55Wr0mnlNiy9/LqnvUQLz99Lk1/wdZ3vrItf48lXprZZGihL
         dA3pJfR+KqPN6Xef1OCiyaXpoaZDQi/qjrsRaKgBtC+MGw3HP0DogIX2QvveCqgXM1le
         Z4xSh34FpZhPkj1rC4H8VmtdChSn7IEA4fcAYv+wVm9ScNc889dSbyQIo9MiQ+hkrliC
         ujew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qnVRKi3HtFJMrrAfoTHSGeqHbRWAKv0dYYUUOqnFejE=;
        b=tQZ0CMMq75KafuDRnkYQRys5xItLR9rCs4kcVLN0gdUZKP2CZfdSRdTDNmj2nfjEa9
         0jMh5k8/HyVwHfw2KTrt0rNku2IeDmqmH3apPb5PAHYvCp5tNGm2ihEoeGzhH4uLyCjo
         fZHLIco5gjeKIIwPzIbtFAACMNB8pFItO3TAKCNom7xGU9aPmobsps+G0hRCFBMUAttF
         1mxTjksXYyb2JqDKjqBKupPkw2SjIEMvUQQid7iRPl8quQJDy0Jz1evq2R6jvpjpyTwM
         0ywbrxqXQ/7PZP8qJoP7nWLy8Cd0Yr3PKTDNqIbOKm6BOxyN5VA/Am74HhZyHk3gRia+
         BXCQ==
X-Gm-Message-State: AOAM533OGR8BxesL4ZwmOFW+R3yw4sZWhPX+QavBdDCZoj6jrJ6DlEJv
        YT9wUn4t13riUxXA5FOuJA==
X-Google-Smtp-Source: ABdhPJwtG78PD6kRl4XlNH5SJDcyTQjsRLUCtxaAGDwminupW1fxCFNtfgl6zQ6ZSXXnHqgMrP7B7Q==
X-Received: by 2002:a05:620a:20d7:: with SMTP id f23mr22822343qka.221.1628029029385;
        Tue, 03 Aug 2021 15:17:09 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id n124sm181924qkf.119.2021.08.03.15.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 15:17:09 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas Bates <lucasb@mojatatu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next] tc-testing: Add control-plane selftests for sch_mq
Date:   Tue,  3 Aug 2021 15:16:59 -0700
Message-Id: <20210803221659.9847-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803123921.2374485-1-kuba@kernel.org>
References: <20210803123921.2374485-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we added multi-queue support to netdevsim in commit d4861fc6be58
("netdevsim: Add multi-queue support"); add a few control-plane selftests
for sch_mq using this new feature.

Use nsPlugin.py to avoid network interface name collisions.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

Here are some control-plane selftests for the mq Qdisc using netdevsim's
new multi-queue feature.  We are planning to add more data-plane selftests
in the future.

Thank you,
Peilin Ye

 .../tc-testing/tc-tests/qdiscs/mq.json        | 137 ++++++++++++++++++
 .../selftests/tc-testing/tdc_config.py        |   1 +
 2 files changed, 138 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
new file mode 100644
index 000000000000..88a20c781e49
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
@@ -0,0 +1,137 @@
+[
+	{
+	    "id": "ce7d",
+	    "name": "Add mq Qdisc to multi-queue device (4 queues)",
+	    "category": [
+            "qdisc",
+            "mq"
+	    ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+	    "setup": [
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
+	    ],
+	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
+	    "expExitCode": "0",
+	    "verifyCmd": "$TC qdisc show dev $ETH",
+	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchCount": "4",
+	    "teardown": [
+		    "echo \"1\" > /sys/bus/netdevsim/del_device"
+	    ]
+	},
+	{
+	    "id": "2f82",
+	    "name": "Add mq Qdisc to multi-queue device (256 queues)",
+	    "category": [
+            "qdisc",
+            "mq"
+	    ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+	    "setup": [
+            "echo \"1 1 256\" > /sys/bus/netdevsim/new_device"
+	    ],
+	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
+	    "expExitCode": "0",
+	    "verifyCmd": "$TC qdisc show dev $ETH",
+	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-9,a-f][0-9,a-f]{0,2} bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchCount": "256",
+	    "teardown": [
+		    "echo \"1\" > /sys/bus/netdevsim/del_device"
+	    ]
+	},
+	{
+	    "id": "c525",
+	    "name": "Add duplicate mq Qdisc",
+	    "category": [
+            "qdisc",
+            "mq"
+	    ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+	    "setup": [
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc add dev $ETH root handle 1: mq"
+	    ],
+	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
+	    "expExitCode": "2",
+	    "verifyCmd": "$TC qdisc show dev $ETH",
+	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchCount": "4",
+	    "teardown": [
+		    "echo \"1\" > /sys/bus/netdevsim/del_device"
+	    ]
+	},
+	{
+	    "id": "128a",
+	    "name": "Delete nonexistent mq Qdisc",
+	    "category": [
+            "qdisc",
+            "mq"
+	    ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+	    "setup": [
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
+	    ],
+	    "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mq",
+	    "expExitCode": "2",
+	    "verifyCmd": "$TC qdisc show dev $ETH",
+	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchCount": "0",
+	    "teardown": [
+		    "echo \"1\" > /sys/bus/netdevsim/del_device"
+	    ]
+	},
+	{
+	    "id": "03a9",
+	    "name": "Delete mq Qdisc twice",
+	    "category": [
+            "qdisc",
+            "mq"
+	    ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+	    "setup": [
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc add dev $ETH root handle 1: mq",
+            "$TC qdisc del dev $ETH root handle 1: mq"
+	    ],
+	    "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mq",
+	    "expExitCode": "2",
+	    "verifyCmd": "$TC qdisc show dev $ETH",
+	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchCount": "0",
+	    "teardown": [
+		    "echo \"1\" > /sys/bus/netdevsim/del_device"
+	    ]
+	},
+    {
+	    "id": "be0f",
+	    "name": "Add mq Qdisc to single-queue device",
+	    "category": [
+            "qdisc",
+            "mq"
+	    ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+	    "setup": [
+            "echo \"1 1\" > /sys/bus/netdevsim/new_device"
+	    ],
+	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
+	    "expExitCode": "2",
+	    "verifyCmd": "$TC qdisc show dev $ETH",
+	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchCount": "0",
+	    "teardown": [
+		    "echo \"1\" > /sys/bus/netdevsim/del_device"
+	    ]
+	}
+]
diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index cd4a27ee1466..ea04f04c173e 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -17,6 +17,7 @@ NAMES = {
           'DEV1': 'v0p1',
           'DEV2': '',
           'DUMMY': 'dummy1',
+	  'ETH': 'eth0',
           'BATCH_FILE': './batch.txt',
           'BATCH_DIR': 'tmp',
           # Length of time in seconds to wait before terminating a command
-- 
2.20.1

