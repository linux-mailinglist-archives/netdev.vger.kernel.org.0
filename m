Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE5130E0C
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgAFHgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:36:32 -0500
Received: from conuserg-08.nifty.com ([210.131.2.75]:47941 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAFHgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:36:32 -0500
X-Greylist: delayed 9305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2020 02:36:31 EST
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 0067Zx8c016413;
        Mon, 6 Jan 2020 16:35:59 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 0067Zx8c016413
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1578296160;
        bh=ZVoO8YLsTvNlYUAa93bzA04FOXwCJJRNR2tidbcPgLQ=;
        h=From:To:Cc:Subject:Date:From;
        b=QIevkAWy+8aOHk7THP4EbH7P/Exfbv1NOySKZbR4/XKS2zq7c8aMV1uUJAo2yUuf5
         oHtZll7lM7LQO2ZFjG4PZzVbNNx0R0ueaXUR6K/OOPDsvBk2GP+LzKkf60EaxIN7OZ
         /BtwerKd8ck6Nn+FNVkphuxO90WGzustB3DVuA/+14iAJZJ3mpLfC/YGvEG1yrMLa1
         uXhIGGhamHYzWowclgPTRYvjrQslXgDE/2Os3HhX5ABStreowOtaL4VazLdE2ip/gm
         lfx6PL3V7CD8dqxRUrRqKO02Xqxt0/+9lK+irQMw4RFeaSWcCLJXdeHI3gjAr0+Yj9
         j6ErkpEoq4WEA==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S . Miller" <davem@davemloft.net>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tipc: do not add socket.o to tipc-y twice
Date:   Mon,  6 Jan 2020 16:35:26 +0900
Message-Id: <20200106073527.18697-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/tipc/Makefile adds socket.o twice.

tipc-y	+= addr.o bcast.o bearer.o \
           core.o link.o discover.o msg.o  \
           name_distr.o  subscr.o monitor.o name_table.o net.o  \
           netlink.o netlink_compat.o node.o socket.o eth_media.o \
                                             ^^^^^^^^
           topsrv.o socket.o group.o trace.o
                    ^^^^^^^^

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/tipc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/Makefile b/net/tipc/Makefile
index 11255e970dd4..1603f5b49e73 100644
--- a/net/tipc/Makefile
+++ b/net/tipc/Makefile
@@ -9,7 +9,7 @@ tipc-y	+= addr.o bcast.o bearer.o \
 	   core.o link.o discover.o msg.o  \
 	   name_distr.o  subscr.o monitor.o name_table.o net.o  \
 	   netlink.o netlink_compat.o node.o socket.o eth_media.o \
-	   topsrv.o socket.o group.o trace.o
+	   topsrv.o group.o trace.o
 
 CFLAGS_trace.o += -I$(src)
 
-- 
2.17.1

