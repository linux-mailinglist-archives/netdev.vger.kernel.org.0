Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B4C6C69A2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 14:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCWNgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 09:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjCWNg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:36:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9F623305
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679578543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L12WjHFFaTMD9P3TMuQKJ7hgZ5gWG2Nw2m6rT4BFV+o=;
        b=WFzGXXsataDnobKRZOUeJufWNCF+GO1ubKrGiUVrmFJitoKlKqCOAYqWyZ5GFwHnraXXfC
        9g2e8N0EpVeNjUm2XiEbxx/lF/V7rahbWZwBIyWCgIlEHZ7PUxAhy0wKBoeqcQN734P8pH
        PTsqovxs5iUABrDDv4SfYFpC3fCwjrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-9C7nQUruNk29EVLHPnOkWg-1; Thu, 23 Mar 2023 09:35:26 -0400
X-MC-Unique: 9C7nQUruNk29EVLHPnOkWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A192855312;
        Thu, 23 Mar 2023 13:35:26 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.225.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9E0C1410DD7;
        Thu, 23 Mar 2023 13:35:24 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 3/4] selftests: tc-testing: add tunnel_key "nofrag" test case
Date:   Thu, 23 Mar 2023 14:34:42 +0100
Message-Id: <f6a741188228d80fcb3928a514837a5b54269242.1679569719.git.dcaratti@redhat.com>
In-Reply-To: <cover.1679569719.git.dcaratti@redhat.com>
References: <cover.1679569719.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
index b40ee602918a..1ae51eadc477 100644
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
+        "skip": "$TC actions add action tunnel_key help 2>&1 | grep -q nofrag",
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

