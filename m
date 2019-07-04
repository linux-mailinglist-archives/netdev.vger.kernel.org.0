Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E1F5F9E7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfGDORA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:17:00 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39962 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfGDOQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:16:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so5562740eds.7
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kBI6RI9KbkiWLwwPLHBzlg9X6VQCSKjNqAiFaiq5x5A=;
        b=mx4fWrWwih+F3AflZvDVmSJh6VAb4NuosUR8V9Nje3R7yzS7y56lSzLFds2eb2oRRZ
         61d2YA9wMtyUGy5RN/LZj9zqICd2zBkyhCX/azHIVKy8re3NX1jDa1z2+qlUHJU4AgfN
         vWtH/U9MBlLiPulqL6lolThdIcgTcy4JxP8KRNz+u4uv1mHg6EzZmBDvNZMvv7GFk1Dp
         8ipx0EGkvgyVwdlj/Oyz+lXyOwidmhKjlYEnUxKRhTHbmqwFc4EktNr4ZXMlzoLryJ+o
         JQqXtRe1R8AawtYwN95G7uBT7953Gcg0+IE//TAyr5sHGnj3brBdvma8KEl05SC0RAYr
         029w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kBI6RI9KbkiWLwwPLHBzlg9X6VQCSKjNqAiFaiq5x5A=;
        b=sAUhM+WgDsqUAOIoytNYPgW25DH0rB8NKRG6/Nw19/ZwdSaOgw11zequfZmwsyV6MH
         o5sso8DGYWgayuKsHm/dSp1KlUqzvpfNnT8HFhiugTI+InSpybURa3jAWRNTEhSPKMoD
         brjbYLq3kKrnq6MC2mOzrtHdQGnsJpEXoHL3oxfISNmkYfa0EK7mDm+xazpMnjExEihE
         JHrOyo2TvftD3vTfwMwP0r+7dklcyIEUeH43hJ95fVyrAOqw1nXAlcHjLLV7FRE4fsYv
         UuoJIB6IjgYw3rr/BRhL+2fX8HJnUlk2qKLicq3pSsy7Kx7nPtoJzyJnMqyQL3/hv2lU
         QCKw==
X-Gm-Message-State: APjAAAUHxqOpBMdPle2ctBeevhh/DlOsifMKmAFELowS9q/hSTbCZcPg
        hBOkF0nPfagppdnoCGdS3p6SyZzZM0o=
X-Google-Smtp-Source: APXvYqzPOia/Gn4yh6G88KMvJrZA3p0ch+erwhb/om7ETdPX4FmUcQr2DuQDGtLnPrlVV8a1qv2SlQ==
X-Received: by 2002:a17:906:1292:: with SMTP id k18mr40233887ejb.146.1562249815665;
        Thu, 04 Jul 2019 07:16:55 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id s27sm1702705eda.36.2019.07.04.07.16.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:16:55 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v6 5/5] selftests: tc-tests: actions: add MPLS tests
Date:   Thu,  4 Jul 2019 15:16:42 +0100
Message-Id: <1562249802-24937-6-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
References: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
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
 tools/testing/selftests/tc-testing/config          |   1 +
 .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
 2 files changed, 813 insertions(+)
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
index 0000000..d46180a
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
@@ -0,0 +1,812 @@
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

