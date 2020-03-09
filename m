Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6954217E749
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgCISf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:35:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51563 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:35:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 255A2220FF;
        Mon,  9 Mar 2020 14:35:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SC5vuFUElFRTYfjuF5bDzXEmFsIfi8nR+TeOBil1Ijo=; b=FCsjTbic
        g+JNn8zdxzxxpzrynvcvPHryJ8/qTRBupnBrHNjGAzZa+dsYi90V311j0+OevyKO
        BTcEvfDALbXUuld/upG0KISNRuIlgAebA1Y8HTk1d3UspkCkwBIdZUWvdefzvBo3
        +emxU9B+eF41Zm+WtvQGIktIObpyOZ4thJ0OOug8bjLBREPGUbf62sogMisl1iB7
        6m4SxYOgdIki+hTLeYJyeFC2FxrCg9pbTr95FQeGUgyAhCfVjO72maJ8sSAYgC85
        wUyFmTOfgl6wbCrxvtphzbMNhrDxQ9uhEZPRra7nW0rvohFbxkUkw9zlc/ONxDaA
        4RxJQEaCE6J+TQ==
X-ME-Sender: <xms:jIxmXvlFPVZz7ya7t-H11-DDSvRLI8nlEA1XNOyCYDrDbcoBepb7cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeejrddufeekrddvgeelrddvtdelnecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:jIxmXh-RibdmtYldN9FH78_4HQYXadu2Opd9mdr8Twmsco_OXvQPRA>
    <xmx:jIxmXqkQxDZ-2qnzYAJsKW64278cPKEQyti70M90q1QjuBvJZ2wZQg>
    <xmx:jIxmXmS5JNjkMPZzSe05MF0n1PkZmXE78LQXeSce3heHBZ26vILXTg>
    <xmx:jIxmXigXDYny2IH-ZvnTKcXDVTvaFfo9qtwu1DyH7mjPhSnoDpAoRQ>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFFFC3060F09;
        Mon,  9 Mar 2020 14:35:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/6] selftests: qdiscs: RED: Add taildrop tests
Date:   Mon,  9 Mar 2020 20:35:02 +0200
Message-Id: <20200309183503.173802-6-idosch@idosch.org>
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

Add tests for the new "taildrop" flag.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../tc-testing/tc-tests/qdiscs/red.json       | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
index 6c5a4c4e0a45..00d25db7e5f7 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
@@ -98,5 +98,45 @@
             "$TC qdisc del dev $DUMMY handle 1: root",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "53e8",
+        "name": "ECN taildrop",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn taildrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn taildrop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "af8e",
+        "name": "ECN harddrop taildrop",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop taildrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop taildrop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
     }
 ]
-- 
2.24.1

