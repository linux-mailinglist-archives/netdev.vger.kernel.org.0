Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2264483686
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiACSAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:00:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231395AbiACSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641232849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xd1myrkSFzvm5J2fnWxw06OIhq1aEOsMtPWufprRxcg=;
        b=H3tzfKM+Fu63CcrmU2y+w3KZWXRvwAl4aaHGzNZ3XmRHNkITudv9Y3+z0P+c4ObMiYEn+H
        TivqzIb06mS+fNkqpJax2e4Tb/xQlMcjpbNh4pqfVpB2YcdQ4wQYCpiUp7ZeLrrHp6RxGx
        6nIpY6vknhuoVNlEmJXfASe978Q18c4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-hqVnurj3OUeAmG4omj0uzw-1; Mon, 03 Jan 2022 13:00:48 -0500
X-MC-Unique: hqVnurj3OUeAmG4omj0uzw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B4D363A7;
        Mon,  3 Jan 2022 18:00:47 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.192.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71D4F85EE4;
        Mon,  3 Jan 2022 18:00:46 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] testsuite: Fix tc/vlan.t test
Date:   Mon,  3 Jan 2022 19:00:22 +0100
Message-Id: <31ec3c6473b76d320301767cc3920ce6dac33e4c.1641232756.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following commit 8323b20f1d76 ("net/sched: act_vlan: No dump for unset
priority"), the kernel no longer dump vlan priority if not explicitly
set before.

When modifying a vlan, tc/vlan.t test expects to find priority set to 0
without setting it explicitly. Thus, after 8323b20f1d76 this test fails.

Fix this simply removing the check on priority.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 testsuite/tests/tc/vlan.t | 1 -
 1 file changed, 1 deletion(-)

diff --git a/testsuite/tests/tc/vlan.t b/testsuite/tests/tc/vlan.t
index b86dc364..51529b2d 100755
--- a/testsuite/tests/tc/vlan.t
+++ b/testsuite/tests/tc/vlan.t
@@ -50,7 +50,6 @@ test_on "vlan"
 test_on "modify"
 test_on "id 5"
 test_on "protocol 802.1Q"
-test_on "priority 0"
 test_on "pipe"
 
 reset_qdisc
-- 
2.33.1

