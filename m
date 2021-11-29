Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8332461190
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344379AbhK2KEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:04:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345014AbhK2KCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:02:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638179937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DuHgrG37at6Yd+kpyqL+6ZWTxH/BYHA0MHxcriPZi+U=;
        b=U2TeEvIF+Y09voVUOJh33M2sbL9RF4rrIU3EduE6+WsABZw+w0xkGjJ6krHY4N0ZkM+d96
        B1P2pLAeD9dmmPNt8StzS2jwRa4xcwJjqru/uG71OKSVfWBNdZEj3S65jx3Sx6jUsdE8+B
        J45lHk1ScpBiliZlMmqHqad4sNymFQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-UPKWDGbVN-G44svR7ogyYQ-1; Mon, 29 Nov 2021 04:58:53 -0500
X-MC-Unique: UPKWDGbVN-G44svR7ogyYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B63CF190D340;
        Mon, 29 Nov 2021 09:58:52 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.39.195.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF21260C0F;
        Mon, 29 Nov 2021 09:58:51 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] selftests: net: bridge: fix typo in vlan_filtering dependency test
Date:   Mon, 29 Nov 2021 10:58:50 +0100
Message-Id: <20211129095850.2018071-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior patch:
]# TESTS=vlmc_filtering_test ./bridge_vlan_mcast.sh
TEST: Vlan multicast snooping enable                                [ OK ]
Device "bridge" does not exist.
TEST: Disable multicast vlan snooping when vlan filtering is disabled   [FAIL]
        Vlan filtering is disabled but multicast vlan snooping is still enabled

After patch:
# TESTS=vlmc_filtering_test ./bridge_vlan_mcast.sh
TEST: Vlan multicast snooping enable                                [ OK ]
TEST: Disable multicast vlan snooping when vlan filtering is disabled   [ OK ]

Fixes: f5a9dd58f48b7c ("selftests: net: bridge: add test for vlan_filtering dependency")
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 5224a5a8595b32..8748d1b1d95b71 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -527,7 +527,7 @@ vlmc_filtering_test()
 {
 	RET=0
 	ip link set dev br0 type bridge vlan_filtering 0
-	ip -j -d link show dev bridge | \
+	ip -j -d link show dev br0 | \
 	jq -e "select(.[0].linkinfo.info_data.mcast_vlan_snooping == 1)" &>/dev/null
 	check_fail $? "Vlan filtering is disabled but multicast vlan snooping is still enabled"
 	log_test "Disable multicast vlan snooping when vlan filtering is disabled"
-- 
2.32.0

