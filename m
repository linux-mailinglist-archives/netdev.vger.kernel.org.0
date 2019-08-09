Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9A88634
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfHIWrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:47:09 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37832 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfHIWrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:47:08 -0400
Received: by mail-ot1-f65.google.com with SMTP id f17so3274375otq.4
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=FfqeoglKJI5wxr9DhrtTTsYEfi55AC9LzbDVcIyMk+o=;
        b=mz8jMRV+juEHzYGcrqrc9zY0KVZnsoCf7su0uUBqaPNzcB+s7/GB65WWaoqIO/2ZRB
         /T0Wx+0eNt6nCxpuKkVPJCfJxXCESWGVP3OVFjmAoJnUQe9apKnn6Orad7IjuLY7ng5p
         QKrx5YRA8fhnVSpacDVm5jY4e4UvDzbG90xAZiw9PyxekFkIoFBl3e81RlUiNTJ54sVp
         e6spQvppDGQ2F15AHCRcoCBGOlUyP2B4R76lneqZsHeaIpwcFjxm+hLlNVK99hw+kV8k
         aFxDIHSuWA581na5BlwE1M45BXvUIy6wXkM5LvIUbWMJKhPcx0VxS+Oc/Edn8f9vHIv2
         osMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FfqeoglKJI5wxr9DhrtTTsYEfi55AC9LzbDVcIyMk+o=;
        b=c4LDtiMa6pH1sR033z6n4KCzR1uWkDNwAbFfWV0PMb5BeqxOjk52wtbDu1FKAATXVH
         p084mpN59zSUozltwsdY1WVqQu2Zy0UGiiT4xrPlOpviHG5w5bsm3N+x43AAxqYucKQk
         nrBy3mm2Z+aJdP58A9wyymycczF1MEYtHIfu3jxm95+tCaywjHoH4YFZhkIcZWod0958
         h1wQi9AMba6j5MV8aJb1ITzBCa1Q6CNhLluD3DBYi3qzvjtirgZzMRRaSqXHt4l0FDGB
         bCJKoYk6a56xxXGcc1Zg2cYXZTZF39fcHHBgjh8veigUIGu5+jOHkOAJjx7IxW0sqrTl
         y3pg==
X-Gm-Message-State: APjAAAXH1WnR7xSgiJ7E20ImrBis96get7HZtiQ19fwJ31e4u7ZlnzAb
        Te/gRgdMsnAHBITEdB6NShT7Z3I9d+I=
X-Google-Smtp-Source: APXvYqx4k8qgvrt7o+Cy22oPA4LbjG0WyaZT8OS4T+6bfMIljBZcyd12dFwhOTLr2+6Gj8rDVbmysA==
X-Received: by 2002:a6b:b804:: with SMTP id i4mr22060082iof.119.1565390826683;
        Fri, 09 Aug 2019 15:47:06 -0700 (PDT)
Received: from mojatatu.com ([74.127.212.48])
        by smtp.gmail.com with ESMTPSA id n7sm73154468ioo.79.2019.08.09.15.46.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 09 Aug 2019 15:47:06 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: added tdc tests for matchall filter
Date:   Fri,  9 Aug 2019 18:46:40 -0400
Message-Id: <1565390800-26061-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/matchall.json      | 391 +++++++++++++++++++++
 1 file changed, 391 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
new file mode 100644
index 000000000000..5f24c0598624
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
@@ -0,0 +1,391 @@
+[
+    {
+        "id": "f62b",
+        "name": "Add ingress matchall filter for protocol ipv4 and action PASS",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ip matchall action ok",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "7f09",
+        "name": "Add egress matchall filter for protocol ipv4 and action PASS",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 1 protocol ip matchall action ok",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent 1: protocol ip pref 1 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 root handle 1: prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "0596",
+        "name": "Add ingress matchall filter for protocol ipv6 and action DROP",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ipv6 matchall",
+        "matchPattern": "^filter parent ffff: protocol ipv6 pref 1 matchall.*handle 0x1.*gact action drop.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "41df",
+        "name": "Add egress matchall filter for protocol ipv6 and action DROP",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 1 protocol ipv6 matchall action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 1 protocol ipv6 matchall",
+        "matchPattern": "^filter parent 1: protocol ipv6 pref 1 matchall.*handle 0x1.*gact action drop.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 root handle 1: prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "e1da",
+        "name": "Add ingress matchall filter for protocol ipv4 and action PASS with priority at 16-bit maximum",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 65535 protocol ipv4 matchall action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 65535 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 65535 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "3de5",
+        "name": "Add egress matchall filter for protocol ipv4 and action PASS with priority at 16-bit maximum",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 65535 protocol ipv4 matchall action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 65535 protocol ipv4 matchall",
+        "matchPattern": "^filter parent 1: protocol ip pref 65535 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 root handle 1: prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "72d7",
+        "name": "Add ingress matchall filter for protocol ipv4 and action PASS with priority exceeding 16-bit maximum",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 655355 protocol ipv4 matchall action pass",
+        "expExitCode": "255",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 655355 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 655355 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "41d3",
+        "name": "Add egress matchall filter for protocol ipv4 and action PASS with priority exceeding 16-bit maximum",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 655355 protocol ipv4 matchall action pass",
+        "expExitCode": "255",
+        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 655355 protocol ipv4 matchall",
+        "matchPattern": "^filter parent 1: protocol ip pref 655355 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 root handle 1: prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "f755",
+        "name": "Add ingress matchall filter for all protocols and action CONTINUE with handle at 32-bit maximum",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0xffffffff prio 1 protocol all matchall action continue",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0xffffffff prio 1 protocol all matchall",
+        "matchPattern": "^filter parent ffff: protocol all pref 1 matchall.*handle 0xffffffff.*gact action continue.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "2c33",
+        "name": "Add egress matchall filter for all protocols and action CONTINUE with handle at 32-bit maximum",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0xffffffff prio 1 protocol all matchall action continue",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 0xffffffff prio 1 protocol all matchall",
+        "matchPattern": "^filter parent 1: protocol all pref 1 matchall.*handle 0xffffffff.*gact action continue.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 root handle 1: prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "0e4a",
+        "name": "Add ingress matchall filter for all protocols and action RECLASSIFY with skip_hw flag",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall skip_hw action reclassify",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall",
+        "matchPattern": "^filter parent ffff: protocol all pref 1 matchall.*handle 0x1.*skip_hw.*not_in_hw.*gact action reclassify.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "7f60",
+        "name": "Add egress matchall filter for all protocols and action RECLASSIFY with skip_hw flag",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 1 protocol all matchall skip_hw action reclassify",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 0x1 prio 1 protocol all matchall",
+        "matchPattern": "^filter parent 1: protocol all pref 1 matchall.*handle 0x1.*skip_hw.*not_in_hw.*gact action reclassify.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 root handle 1: prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "8bd2",
+        "name": "Add ingress matchall filter for protocol ipv6 and action PASS with classid",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 1:1 action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "matchPattern": "^filter parent ffff: protocol ipv6 pref 1 matchall.*handle 0x1.*flowid 1:1.*gact action pass.*ref 1 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "2a4a",
+        "name": "Add ingress matchall filter for protocol ipv6 and action PASS with invalid classid",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 6789defg action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "matchPattern": "^filter protocol ipv6 pref 1 matchall.*handle 0x1.*flowid 6789defg.*gact action pass.*ref 1 bind 1",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "eaf8",
+        "name": "Delete single ingress matchall filter",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 1:2 action pass"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "matchPattern": "^filter protocol ipv6 pref 1 matchall.*handle 0x1.*flowid 1:2.*gact action pass.*ref 1 bind 1",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "76ad",
+        "name": "Delete all ingress matchall filters",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall classid 1:2 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x2 prio 2 protocol all matchall classid 1:3 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x3 prio 3 protocol all matchall classid 1:4 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x4 prio 4 protocol all matchall classid 1:5 action pass"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff:",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol all pref.*matchall.*handle.*flowid.*gact action pass",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "1eb9",
+        "name": "Delete single ingress matchall filter out of multiple",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall classid 1:2 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x2 prio 2 protocol all matchall classid 1:3 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x3 prio 3 protocol all matchall classid 1:4 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x4 prio 4 protocol all matchall classid 1:5 action pass"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: protocol all handle 0x2 prio 2 matchall",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol all pref 2 matchall.*handle 0x2 flowid 1:2.*gact action pass",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "6d63",
+        "name": "Delete ingress matchall filter by chain ID",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all chain 1 matchall classid 1:1 action pass",
+            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv4 chain 2 matchall classid 1:3 action continue"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: chain 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol all pref 1 matchall chain 1 handle 0x1 flowid 1:1.*gact action pass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    }
+]
-- 
2.7.4

