Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913996DF4A1
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjDLMD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjDLMD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:03:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110DA769A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681300921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dBWdj2PwQ2DBH7Z+MGI/PEbS98hQgvIhWHC9udsLwgM=;
        b=X0bmCFUdyuL1lsVTNIeXXkpBhZ25Y4OeU/QIh0rj/h1BlKKk30nKcW8MlENCaIa/6hL0Xu
        aSTW61K7AZUCG0j+xq7Ons073D2UixJJBaZSmBLRnIyc3QYZnRyAL9v/qHIOJugT7WzYye
        JTp3JJYy6PHK7VeqF7oNPRVMm8tecug=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-Q0iIWwesNmi3nEhZtKb0pg-1; Wed, 12 Apr 2023 07:58:34 -0400
X-MC-Unique: Q0iIWwesNmi3nEhZtKb0pg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3420185A791;
        Wed, 12 Apr 2023 11:58:33 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EC4340C6E70;
        Wed, 12 Apr 2023 11:58:33 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net] selftests: openvswitch: adjust datapath NL message declaration
Date:   Wed, 12 Apr 2023 07:58:28 -0400
Message-Id: <20230412115828.3991806-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netlink message for creating a new datapath takes an array
of ports for the PID creation.  This shouldn't cause much issue
but correct it for future cases where we need to do decode of
datapath information that could include the per-cpu PID map.

Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 096f07fb177d..21b1b8deda7d 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -938,7 +938,7 @@ class OvsDatapath(GenericNetlinkSocket):
         nla_map = (
             ("OVS_DP_ATTR_UNSPEC", "none"),
             ("OVS_DP_ATTR_NAME", "asciiz"),
-            ("OVS_DP_ATTR_UPCALL_PID", "uint32"),
+            ("OVS_DP_ATTR_UPCALL_PID", "array(uint32)"),
             ("OVS_DP_ATTR_STATS", "dpstats"),
             ("OVS_DP_ATTR_MEGAFLOW_STATS", "megaflowstats"),
             ("OVS_DP_ATTR_USER_FEATURES", "uint32"),
-- 
2.39.2

