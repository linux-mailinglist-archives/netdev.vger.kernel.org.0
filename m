Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9323C449D4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfFMRoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:44:24 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39536 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbfFMRoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:44:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so32390211edv.6
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bw+ctLUbISziNZHFZUmDDvlVUCOXrvgv6bfM+sLLdeU=;
        b=0o8xPzyaJZ+6vb8wBr74/iifOhe7mf/YCAIODrYVtx2CopYsOYU4jgkfEyTa0L1ExD
         kORjq1GxGzmt0BjWlfQYaO5tMZDkC+swCiD4zUoD+MCF7YfQI9GAzIpCnOw6HUr8XDua
         E/emldCysj4HDbPJKKUT3w6A6p0Kylr2/rf46Fb0Gl05JiRs7Jp4Rb5z3QH2s02VVehr
         aE7g5bPF+QVimqZmrgr+lN/FoCD8P59yYIkCrSYv2J0BWzR94/vJrEXf696gDpYMcGaK
         NHuh0BFtoS/6YjlkfggRXo1HXII+Q66jMqUU+hxFq8tB/BRtIZiYfMYBD+hWcvJ2nZZg
         MUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Bw+ctLUbISziNZHFZUmDDvlVUCOXrvgv6bfM+sLLdeU=;
        b=ebF4DTihIlZwc1bGcLRs1XVoe9q0zz/VbeixF3Oigrqq83Cmp6DqmevUo8RJ91xxeU
         0iJnq3vKQ0dZKnpk0nWfDMnensRXOZAVmJrc0rJ12vzC0MIF7wxEfu6IqVQ4liniB2mI
         cWO6OzajYQAmhfrZOt3yAhyYjB34q12KHTrCt0ybI1lTOn4tVdFcqgmuMy7+gBuzwsQi
         wl9IMoiw07JbvqCo8kxyqly7YhOuhZ9otS1jDQUk+o6keew2cRKMuL0rMG4DuyorrxHU
         9EP0ZiHAffpRWG7H06zEFB7JL+1lhfDouECOsthlUGaIOv1vkSqV2nRyRBnm8QYk70dc
         S6IA==
X-Gm-Message-State: APjAAAVqRs3i+JuN3HPo1tDGoMixDz3Wn7bKGb/GkoyZZhVjKjNJ66u0
        dwDtNL726H5c8dDt/Q2dcoRkAU18+aU=
X-Google-Smtp-Source: APXvYqwe7euLp7g5i9pg/VLrb5+y4AkQKZkuDq32zyCl1zmleZ3tZ3hU01Lxx71Jj1wGLg4lSC/tig==
X-Received: by 2002:a50:ad2c:: with SMTP id y41mr73496664edc.300.1560447860736;
        Thu, 13 Jun 2019 10:44:20 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id e22sm115162edd.25.2019.06.13.10.44.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 10:44:20 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 3/3] selftests: tc-tests: actions: add MPLS tests
Date:   Thu, 13 Jun 2019 18:43:59 +0100
Message-Id: <1560447839-8337-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new series of selftests to verify the functionality of act_mpls in
TC.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../tc-testing/tc-tests/actions/mpls.json          | 744 +++++++++++++++++++++
 1 file changed, 744 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
new file mode 100644
index 0000000..e1a14f4e0
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
@@ -0,0 +1,744 @@
+[
+    {
+        "id": "a933",
+        "name": "Add MPLS dec_ttl action with pipe opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl pipe index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*pipe.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "08d1",
+        "name": "Add mpls dec_ttl action with pass opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl pass index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action mpls index 8",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*pass.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "d786",
+        "name": "Add mpls dec_ttl action with drop opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl drop index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action mpls index 8",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*drop.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "f334",
+        "name": "Add mpls dec_ttl action with reclassify opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl reclassify index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action mpls index 8",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*reclassify.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "29bd",
+        "name": "Add mpls dec_ttl action with continue opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl continue index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action mpls index 8",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*continue.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "48df",
+        "name": "Add mpls dec_ttl action with jump opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl jump 10 index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*jump 10.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "62eb",
+        "name": "Add mpls dec_ttl action with trap opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl trap index 8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl trap.*index 8 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "9118",
+        "name": "Add mpls dec_ttl action with invalid opcode",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl foo index 8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*foo.*index 8 ref",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "6ce1",
+        "name": "Add mpls dec_ttl action with label (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl label 20",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*label.*20.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "352f",
+        "name": "Add mpls dec_ttl action with tc (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl tc 3",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*tc.*3.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "fa1c",
+        "name": "Add mpls dec_ttl action with ttl (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl ttl 20",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*ttl.*20.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "d4c4",
+        "name": "Add mpls pop action with ip proto",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop protocol ipv4",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*protocol.*ip.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "92fe",
+        "name": "Add mpls pop action with mpls proto",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop protocol mpls_mc",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*protocol.*mpls_mc.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "7e23",
+        "name": "Add mpls pop action with no protocol (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "6182",
+        "name": "Add mpls pop action with label (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop protocol ipv4 label 20",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*label.*20.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "6475",
+        "name": "Add mpls pop action with tc (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop protocol ipv4 tc 3",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*tc.*3.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "067b",
+        "name": "Add mpls pop action with ttl (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop protocol ipv4 ttl 20",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*ttl.*20.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "38cc",
+        "name": "Add mpls push action with label",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push label 20",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*ttl.*[0-9]+.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "c281",
+        "name": "Add mpls push action with mpls_mc protocol",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push protocol mpls_mc label 20",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_mc.*label.*20.*ttl.*[0-9]+.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "5db4",
+        "name": "Add mpls push action with label, tc and ttl",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push label 20 tc 3 ttl 128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*tc.*3.*ttl.*128.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "d69d",
+        "name": "Add mpls push action with no label (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "e8e4",
+        "name": "Add mpls push action with ipv4 protocol (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push protocol ipv4 label 20",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*ttl.*[0-9]+.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "ecd0",
+        "name": "Add mpls push action with out of range label (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push label 1048576",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*1048576.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "d303",
+        "name": "Add mpls push action with out of range tc (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push label 20 tc 8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*tc.*8.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "fd6e",
+        "name": "Add mpls push action with ttl of 0 (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push label 20 ttl 0",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*ttl.*0.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "19e9",
+        "name": "Add mpls mod action with mpls label",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls mod label 20",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*label.*20.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "04b5",
+        "name": "Add mpls mod action with mpls tc",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls mod tc 3",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*tc.*3.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "6ed5",
+        "name": "Add mpls mod action with mpls label",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls mod ttl 128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*ttl.*128.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "db7c",
+        "name": "Add mpls mod action with protocol (invalid)",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls mod protocol ipv4",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*protocol.*ip.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "b070",
+        "name": "Replace existing mpls push action with new ID",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action mpls push label 20 pipe index 12"
+        ],
+        "cmdUnderTest": "$TC actions replace action mpls push label 30 pipe index 12",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action mpls index 12",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*30.*pipe.*index 12 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "6cce",
+        "name": "Delete mpls pop action",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action mpls pop protocol ipv4 index 44"
+        ],
+        "cmdUnderTest": "$TC actions del action mpls index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*index 44 ref",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "d138",
+        "name": "Flush mpls actions",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action mpls push label 10 index 10",
+            "$TC actions add action mpls push label 20 index 20",
+            "$TC actions add action mpls push label 30 index 30",
+            "$TC actions add action mpls push label 40 index 40"
+        ],
+        "cmdUnderTest": "$TC actions flush action mpls",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*",
+        "matchCount": "0",
+        "teardown": []
+    }
+]
-- 
2.7.4

