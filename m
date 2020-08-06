Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777F523E122
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgHFSlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:41:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28724 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730057AbgHFSkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596739255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=/VHZefJEyFsI3PH6lymhdIaEYCu1BSLgdAY4PvnxLgw=;
        b=Ar0XQE+Qw3aG/3O7TtuMLlFNJm3sjnk5uY2Dw71cUW+Wn9eV8m55KpnfrVUOeSjbJYJ1ul
        rHwy7nJ+qmg2YseSH29ajGqH8ILLnJDluZlCxwzDWUTfEi+AXXGyTccIhYbh5Yg+4OfaiB
        aMxGUUuZzemPBfuctFdDOXumnjtBAm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-4aU_zOQRM5CCXDpdaEh2Sg-1; Thu, 06 Aug 2020 14:40:50 -0400
X-MC-Unique: 4aU_zOQRM5CCXDpdaEh2Sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E6BC1800D42;
        Thu,  6 Aug 2020 18:40:50 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 576345D9DC;
        Thu,  6 Aug 2020 18:40:49 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf] selftests: bpf: switch off timeout
Date:   Thu,  6 Aug 2020 20:39:59 +0200
Message-Id: <7a9198ed10917f4ecab4a3dd74bcda1200791efd.1596739059.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several bpf tests are interrupted by the default timeout of 45 seconds added
by commit 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second
timeout per test"). In my case it was test_progs, test_tunnel.sh,
test_lwt_ip_encap.sh and test_xdping.sh.

There's not much value in having a timeout for bpf tests, switch it off.

Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/bpf/settings

diff --git a/tools/testing/selftests/bpf/settings b/tools/testing/selftests/bpf/settings
new file mode 100644
index 000000000000..e7b9417537fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/settings
@@ -0,0 +1 @@
+timeout=0
-- 
2.18.1

