Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB9D6B2C6C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCIR43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCIR42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:56:28 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00991149B3
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 09:56:24 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1767a208b30so3157863fac.2
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 09:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678384584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N6qgeaDKMuofLnHYNA7x2T6oneaSI+qlR8o6wtcZtJw=;
        b=cVNuD/ZgzJHWlbdW2UE8v2Q8+5zeqJBeP9g3IsyrGReKUZ18S9nuiREEhdtuglikrv
         c1a9OXmhz+ikxt61Rjemb1UVcmurTVrIrjAH3G3+kx6PIoA2bhjQ+sTSIUTuTwUcnI8D
         PfVovU9Jy0SjoFPPn7ul1fqiJpvjmUDlbl5Jl73IiTvKNANc9vk6qTQgjQx5KbgLw20I
         IcI7e7Y5n/YX+PpW6sSP0NbOf3vrhKsnLbAwjGfWIRuqrYogNOMM7esZCrEVzBMDTXte
         2LrfyPcBZaKqdE0LNEwnjTedpbyEd1ByRyO2sPb8ZCXxGEBw82LfK2z82Eef7dFwnxVA
         Rzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678384584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6qgeaDKMuofLnHYNA7x2T6oneaSI+qlR8o6wtcZtJw=;
        b=6/bHQKUmqFubzwir9n/8oJqHMwMC5WBslIfw6SyBfllZbWvXPhR+Q/zmS2VU4XHqEs
         KX+2Y0d91NFWCLktRGD+dQNq1uFkveaX6fD8WFDlKgSiMQK8IvC/4N4lb24xa3sFNXte
         /VaeV0gNgYse1xdg1j5YURjR3OY+4IZlR8akADgSdWLV8DGK6W1eh3AVP9F/Q2EF4sok
         Ml/0XfjG059oF/1gotgkOHs1Ix8Vgqo35SFroVa0wRC1gHxlKAENyT6otcC1n5AJ/WOQ
         +o644xW4NEls4ujrDSXr1bsQ0qMJEFUjzSe7Yloz4Xfo8KuYPZ3oQO1kjFT7zL6SEfU6
         pqkQ==
X-Gm-Message-State: AO0yUKU/82nVT8fOSVMRZoYWDsZudgqvEoWwJbxlok8u713B/xIbQqNL
        HjAl8Zli9+rbI/S/qZrPFK8sKr/ZZt7M3Mwn/Z4=
X-Google-Smtp-Source: AK7set9ffEWxe3KYTfdRxtAjaukjzfn+0gG+dVVbZxUmsWX1YjZsvx23KC5dUZtqgn+dpI27WpAjgA==
X-Received: by 2002:a05:6870:9728:b0:163:4a41:ea94 with SMTP id n40-20020a056870972800b001634a41ea94mr3635799oaq.49.1678384584085;
        Thu, 09 Mar 2023 09:56:24 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:d22f:e7ce:9ab3:d054])
        by smtp.gmail.com with ESMTPSA id g2-20020a056870c38200b0017703b8a5f8sm2876617oao.49.2023.03.09.09.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 09:56:23 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        shuah@kernel.org, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next] selftests: tc-testing: add tests for action binding
Date:   Thu,  9 Mar 2023 14:55:54 -0300
Message-Id: <20230309175554.304824-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests that check if filters can bind actions, that is create an
action independently and then bind to a filter.

tdc-tests under category 'infra':
1..18
ok 1 abdc - Reference pedit action object in filter
ok 2 7a70 - Reference mpls action object in filter
ok 3 d241 - Reference bpf action object in filter
ok 4 383a - Reference connmark action object in filter
ok 5 c619 - Reference csum action object in filter
ok 6 a93d - Reference ct action object in filter
ok 7 8bb5 - Reference ctinfo action object in filter
ok 8 2241 - Reference gact action object in filter
ok 9 35e9 - Reference gate action object in filter
ok 10 b22e - Reference ife action object in filter
ok 11 ef74 - Reference mirred action object in filter
ok 12 2c81 - Reference nat action object in filter
ok 13 ac9d - Reference police action object in filter
ok 14 68be - Reference sample action object in filter
ok 15 cf01 - Reference skbedit action object in filter
ok 16 c109 - Reference skbmod action object in filter
ok 17 4abc - Reference tunnel_key action object in filter
ok 18 dadd - Reference vlan action object in filter

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../tc-testing/tc-tests/infra/actions.json    | 416 ++++++++++++++++++
 1 file changed, 416 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/actions.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/actions.json b/tools/testing/selftests/tc-testing/tc-tests/infra/actions.json
new file mode 100644
index 000000000000..16f3a83605e4
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/actions.json
@@ -0,0 +1,416 @@
+[
+    {
+        "id": "abdc",
+        "name": "Reference pedit action object in filter",
+        "category": [
+            "infra",
+            "pedit"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC action add action pedit munge offset 0 u8 clear index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action pedit index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "7a70",
+        "name": "Reference mpls action object in filter",
+        "category": [
+            "infra",
+            "mpls"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC action add action mpls pop protocol ipv4 index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action mpls index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "d241",
+        "name": "Reference bpf action object in filter",
+        "category": [
+            "infra",
+            "bpf"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC action add action bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0' index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action bpf index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action bpf"
+        ]
+    },
+    {
+        "id": "383a",
+        "name": "Reference connmark action object in filter",
+        "category": [
+            "infra",
+            "connmark"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action connmark"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action connmark index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action connmark"
+        ]
+    },
+    {
+        "id": "c619",
+        "name": "Reference csum action object in filter",
+        "category": [
+            "infra",
+            "csum"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action csum ip4h index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action csum index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action csum"
+        ]
+    },
+    {
+        "id": "a93d",
+        "name": "Reference ct action object in filter",
+        "category": [
+            "infra",
+            "ct"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action ct index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action ct index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "8bb5",
+        "name": "Reference ctinfo action object in filter",
+        "category": [
+            "infra",
+            "ctinfo"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC action add action ctinfo index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action ctinfo index 10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action ctinfo"
+        ]
+    },
+    {
+        "id": "2241",
+        "name": "Reference gact action object in filter",
+        "category": [
+            "infra",
+            "gact"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action pass index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action gact"
+        ]
+    },
+    {
+        "id": "35e9",
+        "name": "Reference gate action object in filter",
+        "category": [
+            "infra",
+            "gate"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC action add action gate priority 1 sched-entry close 100000000ns index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action gate index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action gate"
+        ]
+    },
+    {
+        "id": "b22e",
+        "name": "Reference ife action object in filter",
+        "category": [
+            "infra",
+            "ife"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action ife encode allow mark pass index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action ife index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action ife"
+        ]
+    },
+    {
+        "id": "ef74",
+        "name": "Reference mirred action object in filter",
+        "category": [
+            "infra",
+            "mirred"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action mirred egress mirror index 1 dev lo"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action mirred index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action mirred"
+        ]
+    },
+    {
+        "id": "2c81",
+        "name": "Reference nat action object in filter",
+        "category": [
+            "infra",
+            "nat"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action nat ingress 192.168.1.1 200.200.200.1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action nat index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action nat"
+        ]
+    },
+    {
+        "id": "ac9d",
+        "name": "Reference police action object in filter",
+        "category": [
+            "infra",
+            "police"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action police rate 1kbit burst 10k index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action police index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action police"
+        ]
+    },
+    {
+        "id": "68be",
+        "name": "Reference sample action object in filter",
+        "category": [
+            "infra",
+            "sample"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action sample rate 10 group 1 index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action sample index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action sample"
+        ]
+    },
+    {
+        "id": "cf01",
+        "name": "Reference skbedit action object in filter",
+        "category": [
+            "infra",
+            "skbedit"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action skbedit mark 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action skbedit index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
+        "id": "c109",
+        "name": "Reference skbmod action object in filter",
+        "category": [
+            "infra",
+            "skbmod"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action skbmod set dmac 11:22:33:44:55:66 index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action skbmod index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action skbmod"
+        ]
+    },
+    {
+        "id": "4abc",
+        "name": "Reference tunnel_key action object in filter",
+        "category": [
+            "infra",
+            "tunnel_key"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 20.20.20.2 id 1 index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action tunnel_key index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action tunnel_key"
+        ]
+    },
+    {
+        "id": "dadd",
+        "name": "Reference vlan action object in filter",
+        "category": [
+            "infra",
+            "tunnel_key"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions add action vlan pop pipe index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action vlan index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions flush action vlan"
+        ]
+    }
+]
-- 
2.34.1

