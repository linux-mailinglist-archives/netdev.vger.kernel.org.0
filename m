Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B73426B3
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439313AbfFLMwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:52:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43158 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437322AbfFLMwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:52:19 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so25557221edb.10
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bw+ctLUbISziNZHFZUmDDvlVUCOXrvgv6bfM+sLLdeU=;
        b=BPFsMxi7UOh0TXmmVZ3E73gq31k8EphLSzojU4NkrkXiOeE8ebiP7sRwwv1L1KcFPz
         50Cubp6kzlae30XL5b5l2OUpcOqG8EiZ/GARX5Ln5pAtLOA/iJzD5noAQq2oabzG/JPR
         UCyz4FXlRx8pMBROL68sz3u54qNmABpoGF2JbEl60RJ+hkiOuX2N2DsMBz/IbIVsUeql
         yweLM/F/VdVvymtGnvCqyBSB/7EqagkEfgXRKS+EV+z4iN2EuVf/XsaOKm5sLo7tSiNW
         m1de83uh9ooJ7F5k25cnvsEJxj8PoG4qlgM6WHLqONClY/7Sfu7ni0MiQ5GxzZZoelov
         mHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Bw+ctLUbISziNZHFZUmDDvlVUCOXrvgv6bfM+sLLdeU=;
        b=JbOJzp4Wpz7axIX61ur6Gfjsg1lNSEe2m10rFMW6KEtG941rl3r5RseotsGxRNBRjG
         hsKuoHO2v0JTBKkkf5REKmiqwxqb8FjYEV4y7WseHtu0N3DXN28kfUSYkcPdOmgfWX3V
         O5mIn0n2uXy7owN0j0VGy9hsol+sdVOfG78zsNkhfTJ+v9hoVr72F0mI3pVZh7EsEZAG
         +xKgZWWZ4DsjPC6K4iovjHqJasYLrW+9TiPEBug0Xx+GcHQswlxOm4zWSyQuUdRGImsE
         Fk3I4Uk3J6+6v4mr3Q2jJkFX8+B5G0AGhbt5DmUsjsUP8D1ajwS4XVZ50ZmgjlUNNGe+
         9FRA==
X-Gm-Message-State: APjAAAWqIdw/h7fKhXb9B2s09lKL0BL8aeY146d4BO9ER9tDLNKBSzPH
        2ryeCqnHYSdgT3TAllVy5StaFyYobVs=
X-Google-Smtp-Source: APXvYqwbq/ibXTn0kytmg2G9N3dV8Yy8SaQp2xv+uUMc8RRHJm1Ri6zxes31S6cL6Rtl/2SIOk60jg==
X-Received: by 2002:a17:906:c315:: with SMTP id s21mr51820195ejz.238.1560343936422;
        Wed, 12 Jun 2019 05:52:16 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u15sm17043eja.32.2019.06.12.05.52.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 05:52:15 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 3/3] selftests: tc-tests: actions: add MPLS tests
Date:   Wed, 12 Jun 2019 13:51:46 +0100
Message-Id: <1560343906-19426-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
References: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
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

