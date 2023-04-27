Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8966EFFEB
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242825AbjD0Dnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242790AbjD0Dni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73E33C03
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682566968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oGPEmXtiWKYZ86rFBafONQEnyUSDRcjcPzcWfmgs0hA=;
        b=JywBMnnsQT0nqe6svmuu+gAqiezfcwy3pIqeR9ZBcyYdKYkaU9fVKhSripEn+IeRjgA4K3
        Wn2kdolnzLaA0enu+8loQul1r8eW+pBiZPQdy2XduMizfzWruSi/s51Eszp9BP2YbSBEQ2
        zWCoU+91zMm39zNsmKfnLMQkTyG8AcU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-exuwYzQFNUmnfs_MuRHvLg-1; Wed, 26 Apr 2023 23:42:46 -0400
X-MC-Unique: exuwYzQFNUmnfs_MuRHvLg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94D2785A5B1;
        Thu, 27 Apr 2023 03:42:46 +0000 (UTC)
Received: from localhost.localdomain (vm-10-0-76-221.hosted.upshift.rdu2.redhat.com [10.0.76.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 881E9492B03;
        Thu, 27 Apr 2023 03:42:46 +0000 (UTC)
From:   Liang Li <liali@redhat.com>
To:     netdev@vger.kernel.org
Cc:     liali@redhat.com, j.vosburgh@gmail.com, razor@blackwall.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: bonding: delete unnecessary line.
Date:   Thu, 27 Apr 2023 03:43:43 +0000
Message-Id: <20230427034343.1401883-1-liali@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"ip link set dev "$devbond1" nomaster"
This line code in bond-eth-type-change.sh is unnecessary.
Because $devbond1 was not added to any master device.

Signed-off-by: Liang Li <liali@redhat.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/drivers/net/bonding/bond-eth-type-change.sh        | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
index 5cdd22048ba7..862e947e17c7 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
@@ -53,7 +53,6 @@ bond_test_enslave_type_change()
 	# restore ARPHRD_ETHER type by enslaving such device
 	ip link set dev "$devbond2" master "$devbond0"
 	check_err $? "could not enslave $devbond2 to $devbond0"
-	ip link set dev "$devbond1" nomaster
 
 	bond_check_flags "$devbond0"
 
-- 
2.35.1

