Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B3A121FAB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfLQAZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:25:14 -0500
Received: from mga07.intel.com ([134.134.136.100]:21147 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbfLQAY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 19:24:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 16:24:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217599729"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2019 16:24:58 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 03/11] tcp: Define IPPROTO_MPTCP
Date:   Mon, 16 Dec 2019 16:24:47 -0800
Message-Id: <20191217002455.24849-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
References: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To open a MPTCP socket with socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP),
IPPROTO_MPTCP needs a value that differs from IPPROTO_TCP. The existing
IPPROTO numbers mostly map directly to IANA-specified protocol numbers.
MPTCP does not have a protocol number allocated because MPTCP packets
use the TCP protocol number. Use private number not used OTA.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/trace/events/sock.h   | 3 ++-
 include/uapi/linux/in.h       | 2 ++
 tools/include/uapi/linux/in.h | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 3ff12b90048d..a966d4b5ab37 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -19,7 +19,8 @@
 #define inet_protocol_names		\
 		EM(IPPROTO_TCP)			\
 		EM(IPPROTO_DCCP)		\
-		EMe(IPPROTO_SCTP)
+		EM(IPPROTO_SCTP)		\
+		EMe(IPPROTO_MPTCP)
 
 #define tcp_state_names			\
 		EM(TCP_ESTABLISHED)		\
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index e7ad9d350a28..1521073b6348 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -76,6 +76,8 @@ enum {
 #define IPPROTO_MPLS		IPPROTO_MPLS
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
+  IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
+#define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
 };
 #endif
diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index e7ad9d350a28..1521073b6348 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -76,6 +76,8 @@ enum {
 #define IPPROTO_MPLS		IPPROTO_MPLS
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
+  IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
+#define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
 };
 #endif
-- 
2.24.1

