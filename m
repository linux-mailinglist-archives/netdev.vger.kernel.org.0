Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECC26152A
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfGGOC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 10:02:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34453 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfGGOCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 10:02:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so12204074edb.1
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 07:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NRvUPniIpp+jRJf+EaiA0wvGosoh6WBj9IGi2JCUvdY=;
        b=1CHL9I7AzxYoQ2ETTRQUh5RLHNnA4m2R32WENLexx9JqXx5zHSzCoegwK+aWtDjtHi
         5fyqd12mCkEaFiI0AUBGcckKXclne34WgEWEqgBFz473CLQr09jN2BToS9PAK8j4OTNj
         yE0oy4YrRfWyHA1m5DKNRFjQy66SL/vOIBuwGZu6V2YBZ2Y/kxm8cBCDBU+bt+uMjYbQ
         d9dpIOo3DZ0lI6BBD0YhgtXi6HYftKSf8tlq2BS5+2ZdkZodKHlMBdUyMoJbZNcL5iDo
         fh/9vf3wYJkBEfoO2O42oCSNzlyELwBHQ3p1eLYy6wfucktDSiuGJk8yvs8ViUhigsDv
         5GFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NRvUPniIpp+jRJf+EaiA0wvGosoh6WBj9IGi2JCUvdY=;
        b=Ux5OqOrnUJ9Gxb3n1P/BdAxJgMtS4JuEBgHrobDMb3twNtakl7m0cLsRYxVTXMvCah
         qgWcOv2ghcO4UVPCKnPelxOeHp7/rfQoBD21iTN0bX0AjfGTozC4P9YlptGVkApEWZ1w
         QxlwLIZhJ3H/Gjh68far/lB83sWPi3AHbyGG1mZPiRBm8bpiQSsczMbRFn6GhHf7KDQj
         rUuO2TPSJ5ZUltcfJxakHZ0BEnCqgooJEB4NhVtSsQx8BW1JZgvYMR1J2IW9Ff0ObA1f
         stOFflgflecZi+kdcEqXyEqK6R0DjsHjLrw+wXd0CH319xaltGmLjpeh6LfPav8wGQc+
         tt2g==
X-Gm-Message-State: APjAAAUceXGjtzxHMQqAzjlMOp2Bl13UUlvL+MOiMA30kMsHnjzv4VXj
        S86kitgXxAaR95DbFfpPD5uSveBwezU=
X-Google-Smtp-Source: APXvYqz6O80wS1EIvD9Hpg90aJ4x8Hbj+nW2Ze5256MXsqxH0hHF7YZHw3JKobtXxyADttpGdXdpPw==
X-Received: by 2002:a17:906:610:: with SMTP id s16mr12385328ejb.122.1562508140171;
        Sun, 07 Jul 2019 07:02:20 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t2sm4673327eda.95.2019.07.07.07.02.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 07 Jul 2019 07:02:19 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, mrv@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v7 5/5] tc-tests: actions: add MPLS tests
Date:   Sun,  7 Jul 2019 15:01:58 +0100
Message-Id: <1562508118-28841-6-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
References: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new series of selftests to verify the functionality of act_mpls in
TC.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/tc-testing/config          |    1 +
 .../tc-testing/tc-tests/actions/mpls.json          | 1088 ++++++++++++++++++++
 2 files changed, 1089 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 1adc4f9..7c55196 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -42,6 +42,7 @@ CONFIG_NET_ACT_CTINFO=m
 CONFIG_NET_ACT_SKBMOD=m
 CONFIG_NET_ACT_IFE=m
 CONFIG_NET_ACT_TUNNEL_KEY=m
+CONFIG_NET_ACT_MPLS=m
 CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
new file mode 100644
index 0000000..04f2a94
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
@@ -0,0 +1,1088 @@
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
+        "id": "6b79",
+        "name": "Add mpls dec_ttl action with bos (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl bos 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl.*bos.*1.*pipe",
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
+        "id": "7316",
+        "name": "Add mpls pop action with bos (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls pop protocol ipv4 bos 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*bos.*1.*pipe",
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
+        "id": "16eb",
+        "name": "Add mpls push action with label and bos",
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
+        "cmdUnderTest": "$TC actions add action mpls push label 20 bos 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*bos.*1.*pipe",
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
+        "id": "1fde",
+        "name": "Add mpls mod action with max mpls label",
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
+        "cmdUnderTest": "$TC actions add action mpls mod label 0xfffff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*label.*1048575.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "0c50",
+        "name": "Add mpls mod action with mpls label exceeding max (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls mod label 0x100000",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*label.*1048576.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "10b6",
+        "name": "Add mpls mod action with mpls label of MPLS_LABEL_IMPLNULL (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls mod label 3",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*label.*3.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "57c9",
+        "name": "Add mpls mod action with mpls min tc",
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
+        "cmdUnderTest": "$TC actions add action mpls mod tc 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*tc.*0.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "6872",
+        "name": "Add mpls mod action with mpls max tc",
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
+        "cmdUnderTest": "$TC actions add action mpls mod tc 7",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*tc.*7.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "a70a",
+        "name": "Add mpls mod action with mpls tc exceeding max (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls mod tc 8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*tc.*4.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "6ed5",
+        "name": "Add mpls mod action with mpls ttl",
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
+        "id": "b80f",
+        "name": "Add mpls mod action with mpls max ttl",
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
+        "cmdUnderTest": "$TC actions add action mpls mod ttl 255",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*ttl.*255.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "8864",
+        "name": "Add mpls mod action with mpls min ttl",
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
+        "cmdUnderTest": "$TC actions add action mpls mod ttl 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*ttl.*1.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "6c06",
+        "name": "Add mpls mod action with mpls ttl of 0 (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls mod ttl 0",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*ttl.*0.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "b5d8",
+        "name": "Add mpls mod action with mpls ttl exceeding max (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls mod ttl 256",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*ttl.*256.*pipe",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "451f",
+        "name": "Add mpls mod action with mpls max bos",
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
+        "cmdUnderTest": "$TC actions add action mpls mod bos 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*bos.*1.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "a1ed",
+        "name": "Add mpls mod action with mpls min bos",
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
+        "cmdUnderTest": "$TC actions add action mpls mod bos 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*bos.*0.*pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "3dcf",
+        "name": "Add mpls mod action with mpls bos exceeding max (invalid)",
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
+        "cmdUnderTest": "$TC actions add action mpls mod bos 2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*bos.*2.*pipe",
+        "matchCount": "0",
+        "teardown": []
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

