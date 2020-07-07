Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3815217847
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgGGTuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGTuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:50:22 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF4C061755;
        Tue,  7 Jul 2020 12:50:21 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 52F51BC0C1;
        Tue,  7 Jul 2020 19:50:18 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        kuba@kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Replace HTTP links with HTTPS ones: NFS, SUNRPC, and LOCKD clients
Date:   Tue,  7 Jul 2020 21:50:12 +0200
Message-Id: <20200707195012.52559-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
          If both the HTTP and HTTPS versions
          return 200 OK and serve the same content:
            Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See https://lkml.org/lkml/2020/6/26/837

 fs/lockd/mon.c                  | 2 +-
 include/linux/sunrpc/bc_xprt.h  | 2 +-
 include/linux/sunrpc/msg_prot.h | 2 +-
 net/sunrpc/backchannel_rqst.c   | 2 +-
 net/sunrpc/sunrpc.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 1eabd91870e6..1d9488cf0534 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -417,7 +417,7 @@ void nsm_release(struct nsm_handle *nsm)
 /*
  * XDR functions for NSM.
  *
- * See http://www.opengroup.org/ for details on the Network
+ * See https://www.opengroup.org/ for details on the Network
  * Status Monitor wire protocol.
  */
 
diff --git a/include/linux/sunrpc/bc_xprt.h b/include/linux/sunrpc/bc_xprt.h
index d796058cdff2..f07c334c599f 100644
--- a/include/linux/sunrpc/bc_xprt.h
+++ b/include/linux/sunrpc/bc_xprt.h
@@ -4,7 +4,7 @@
 
 NetApp provides this source code under the GPL v2 License.
 The GPL v2 license is available at
-http://opensource.org/licenses/gpl-license.php.
+https://opensource.org/licenses/gpl-license.php.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
diff --git a/include/linux/sunrpc/msg_prot.h b/include/linux/sunrpc/msg_prot.h
index bea40d9f03a1..43f854487539 100644
--- a/include/linux/sunrpc/msg_prot.h
+++ b/include/linux/sunrpc/msg_prot.h
@@ -143,7 +143,7 @@ typedef __be32	rpc_fraghdr;
 /*
  * Well-known netids. See:
  *
- *   http://www.iana.org/assignments/rpc-netids/rpc-netids.xhtml
+ *   https://www.iana.org/assignments/rpc-netids/rpc-netids.xhtml
  */
 #define RPCBIND_NETID_UDP	"udp"
 #define RPCBIND_NETID_TCP	"tcp"
diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 195b40c5dae4..3fecad369592 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -5,7 +5,7 @@
 
 NetApp provides this source code under the GPL v2 License.
 The GPL v2 license is available at
-http://opensource.org/licenses/gpl-license.php.
+https://opensource.org/licenses/gpl-license.php.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
diff --git a/net/sunrpc/sunrpc.h b/net/sunrpc/sunrpc.h
index f6fe2e6cd65a..2f59464e6524 100644
--- a/net/sunrpc/sunrpc.h
+++ b/net/sunrpc/sunrpc.h
@@ -4,7 +4,7 @@
 
 NetApp provides this source code under the GPL v2 License.
 The GPL v2 license is available at
-http://opensource.org/licenses/gpl-license.php.
+https://opensource.org/licenses/gpl-license.php.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- 
2.27.0

