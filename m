Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC294078B1
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbhIKOPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 10:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235331AbhIKOPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 10:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631369672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sjvQLMLGpfcPqffTJqY5VxV8wNhk8j5mqr+mlB+SjSc=;
        b=LhtlvZVoaWg4eyWPb/FB1j39h4wLqcLGCbDd9ME88+A0IFC20TepsI7BVLecavLvHxuHR0
        Tf0jmKmEVkHx51FWVQlmdioHRHvuRvo2ABW5XQ7jkHYsOENy8+GSicm/WIlW3G1+NOFIrt
        wtY2w8XawozM/eyk0WveLMYhdDFH79I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-lpblkUhbMNaj5_69RxZ9Fg-1; Sat, 11 Sep 2021 10:14:31 -0400
X-MC-Unique: lpblkUhbMNaj5_69RxZ9Fg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F0D3FAB;
        Sat, 11 Sep 2021 14:14:30 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6A9D10013C1;
        Sat, 11 Sep 2021 14:14:29 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com
Subject: [PATCH net] selftest: net: fix typo in altname test
Date:   Sat, 11 Sep 2021 16:14:18 +0200
Message-Id: <4e795ea14ace83249e256dc3845d3cd68ba3eefe.1631369140.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If altname deletion of the short alternative name fails, the error
message printed is: "Failed to add short alternative name".
This is obviously a typo, as we are testing altname deletion.

Fix this using a proper error message.

Fixes: f95e6c9c4617 ("selftest: net: add alternative names test")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tools/testing/selftests/net/altnames.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/altnames.sh b/tools/testing/selftests/net/altnames.sh
index 4254ddc3f70b..1ef9e4159bba 100755
--- a/tools/testing/selftests/net/altnames.sh
+++ b/tools/testing/selftests/net/altnames.sh
@@ -45,7 +45,7 @@ altnames_test()
 	check_err $? "Got unexpected long alternative name from link show JSON"
 
 	ip link property del $DUMMY_DEV altname $SHORT_NAME
-	check_err $? "Failed to add short alternative name"
+	check_err $? "Failed to delete short alternative name"
 
 	ip -j -p link show $SHORT_NAME &>/dev/null
 	check_fail $? "Unexpected success while trying to do link show with deleted short alternative name"
-- 
2.31.1

