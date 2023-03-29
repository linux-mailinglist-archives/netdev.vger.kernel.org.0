Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590646CD715
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjC2J5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjC2J4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFD5F0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680083765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TlVoMNodglqF0e1sH32ZY7apczejQlBff+dhoMyjVHE=;
        b=eDDMkwg0vop/SA3YXLFydiC10UHLQs6Zt3RLJMz9WKBWIsIzNOPYsqvaYDJZDsjFtYacx/
        Z2RieZ//8zowvZWeG2IrBplCJ+ZrOju6FHbwSp79EDSQfCTaSUyHp0yWsyqMfi62WVxPe4
        ixOpcMrNQJTyhy6MnR6vXFExrGtj4uA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-nyC39gRpMemVrlM32b8L7g-1; Wed, 29 Mar 2023 05:56:03 -0400
X-MC-Unique: nyC39gRpMemVrlM32b8L7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A0485C06A;
        Wed, 29 Mar 2023 09:56:03 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D363518EC2;
        Wed, 29 Mar 2023 09:56:01 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 3/4] selftests: tc-testing: add tunnel_key "nofrag" test case
Date:   Wed, 29 Mar 2023 11:54:54 +0200
Message-Id: <a051e4e5c776a84e591f708ab7915143afe2b3a7.1680082990.git.dcaratti@redhat.com>
In-Reply-To: <cover.1680082990.git.dcaratti@redhat.com>
References: <cover.1680082990.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
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

