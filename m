Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371B817E745
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCISfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:35:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60975 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:35:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D9C14220F1;
        Mon,  9 Mar 2020 14:35:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ci5PWBLCiVlsnSsz1NxtxWWVuZwaLvYOZUMtZKCZIpQ=; b=h9dHuRsJ
        bNCngamMUe5bByDuZdeYsXdw/xIivnaeoMqVsGs/TsZ/Ry941078239qzY3WYGT9
        1vnuwQ4L8CazL0TSRjkhN4AI+isiVz8nE3f7RaB9xGYn9BeArEgRb9Ix7YS4ETdv
        0PYv3rTnjjXReQ+/h23W8BQBi98Uns0VtJT1bLODP4+Lpf+K8HvVN3zNt8oVYLhL
        v8PiB4X0YK3QKAxsfCgt+9iWigAmmLhzD7zN9QUSOt9l4IyYYH/3P9kffjKo/pyh
        usDPpteqeqg7HehxOFqZPE1YcraYbJiEJFOcG0sy9U9Kim2InANGMONUIbdO6p5G
        40VD7whD8HSeoQ==
X-ME-Sender: <xms:gYxmXornkphAb9qBG0x_nWiZzfw3zBC7G3mDUsijBhcytsr1M8wnXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeejrddufeekrddvgeelrddvtdelnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:gYxmXqRXTKNom0PshMUhZuoaKg5RowodrP2YS6mZBXTRTd4pFoRKRw>
    <xmx:gYxmXvU_FsHBhc1MHIHtsU3ajurZVDu56b27zATh5pNVzyjOCZl7-Q>
    <xmx:gYxmXuSpS0_TeotHep0WTix1YOBeqr5qLCvOHSM6v21ACwSc4-if5A>
    <xmx:gYxmXqjn2wqO9ej7jvv8qVuzQ2Qiv_1xOzBF-KEoXsTQnJFh_XAjhg>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B20230618B7;
        Mon,  9 Mar 2020 14:35:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/6] selftests: qdiscs: Add TDC test for RED
Date:   Mon,  9 Mar 2020 20:34:58 +0200
Message-Id: <20200309183503.173802-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309183503.173802-1-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a handful of tests for creating RED with different flags.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../tc-testing/tc-tests/qdiscs/red.json       | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
new file mode 100644
index 000000000000..6c5a4c4e0a45
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
@@ -0,0 +1,102 @@
+[
+    {
+        "id": "8b6e",
+        "name": "RED",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "342e",
+        "name": "RED adaptive",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red adaptive limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb adaptive",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2d4b",
+        "name": "ECN",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "650f",
+        "name": "ECN adaptive",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn adaptive limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn adaptive",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5f15",
+        "name": "ECN harddrop",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.24.1

