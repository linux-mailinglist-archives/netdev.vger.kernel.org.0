Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5D56CC85A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjC1QqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjC1QqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:46:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBF71729
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680021925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2cwFaiGEcaKbetx5eOECVzhQrtIqPQ2dWgamjvGOv18=;
        b=BAhxgdhlak7revjCQoGTvxGCuPr72y+VHhdyYrbkUmOq3PjNmuSsoCcFi6n4s23xEffXNZ
        JH3oOSXdrMmTdpGbAAl8pcRh+CUjLYmOL+j2YfG7bFJ99Y+Va5WrHKEf3haLMOgr2dAYwm
        HUIPtdW7YrqtAznBqRLCwsMSDPvmDv4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-jfkahAOcMN6wb6bOpPNn_w-1; Tue, 28 Mar 2023 12:45:21 -0400
X-MC-Unique: jfkahAOcMN6wb6bOpPNn_w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD8D31C07547;
        Tue, 28 Mar 2023 16:45:20 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.32.181.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A53AB492C13;
        Tue, 28 Mar 2023 16:45:19 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 3/4] selftests: tc-testing: add tunnel_key "nofrag" test case
Date:   Tue, 28 Mar 2023 18:45:04 +0200
Message-Id: <72335bd036509a533d1cf00554b77b674fad846f.1680021219.git.dcaratti@redhat.com>
In-Reply-To: <cover.1680021219.git.dcaratti@redhat.com>
References: <cover.1680021219.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 # ./tdc.py -e 6bda -l
 6bda: (actions, tunnel_key) Add tunnel_key action with nofrag option

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../tc-tests/actions/tunnel_key.json          | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index b40ee602918a..b5b47fbf6c00 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -983,5 +983,30 @@
         "teardown": [
             "$TC actions flush action tunnel_key"
         ]
+    },
+    {
+        "id": "6bda",
+        "name": "Add tunnel_key action with nofrag option",
+        "category": [
+            "actions",
+            "tunnel_key"
+        ],
+        "dependsOn": "$TC actions add action tunnel_key help 2>&1 | grep -q nofrag",
+        "setup": [
+            [
+                "$TC action flush action tunnel_key",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 10.10.10.2 id 1111 nofrag index 222",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action tunnel_key index 222",
+        "matchPattern": "action order [0-9]+: tunnel_key.*src_ip 10.10.10.1.*dst_ip 10.10.10.2.*key_id 1111.*csum.*nofrag pipe.*index 222",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action tunnel_key"
+        ]
     }
 ]
-- 
2.39.2

