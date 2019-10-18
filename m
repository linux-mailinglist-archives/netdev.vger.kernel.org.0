Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0177BDC445
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 14:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404861AbfJRMA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 08:00:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392487AbfJRMA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 08:00:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CE89C08E2B0;
        Fri, 18 Oct 2019 12:00:56 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.205.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17CFC5D9CA;
        Fri, 18 Oct 2019 12:00:54 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Peter Oskolkov <posk@google.com>
Subject: [PATCH bpf] selftests/bpf: More compatible nc options in test_tc_edt
Date:   Fri, 18 Oct 2019 14:00:42 +0200
Message-Id: <f5bf07dccd8b552a76c84d49e80b86c5aa071122.1571400024.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 18 Oct 2019 12:00:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of the three nc implementations widely in use, at least two (BSD netcat
and nmap-ncat) do not support -l combined with -s. Modify the nc invocation
to be accepted by all of them.

Fixes: 7df5e3db8f63 ("selftests: bpf: tc-bpf flow shaping with EDT")
Cc: Peter Oskolkov <posk@google.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/test_tc_edt.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tc_edt.sh b/tools/testing/selftests/bpf/test_tc_edt.sh
index f38567ef694b..daa7d1b8d309 100755
--- a/tools/testing/selftests/bpf/test_tc_edt.sh
+++ b/tools/testing/selftests/bpf/test_tc_edt.sh
@@ -59,7 +59,7 @@ ip netns exec ${NS_SRC} tc filter add dev veth_src egress \
 
 # start the listener
 ip netns exec ${NS_DST} bash -c \
-	"nc -4 -l -s ${IP_DST} -p 9000 >/dev/null &"
+	"nc -4 -l -p 9000 >/dev/null &"
 declare -i NC_PID=$!
 sleep 1
 
-- 
2.18.1

