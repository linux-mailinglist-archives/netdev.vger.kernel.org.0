Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A51C94F4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfJBXhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfJBXhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862582"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 04/45] tcp: Define IPPROTO_MPTCP
Date:   Wed,  2 Oct 2019 16:36:14 -0700
Message-Id: <20191002233655.24323-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
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
index dc749c651318..bfbcba315a12 100644
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
index e7ad9d350a28..44df6dc1ff1d 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -76,6 +76,8 @@ enum {
 #define IPPROTO_MPLS		IPPROTO_MPLS
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
+  IPPROTO_MPTCP = 262,		/* Multipath TCP connection 		*/
+#define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
 };
 #endif
diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index e7ad9d350a28..44df6dc1ff1d 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -76,6 +76,8 @@ enum {
 #define IPPROTO_MPLS		IPPROTO_MPLS
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
+  IPPROTO_MPTCP = 262,		/* Multipath TCP connection 		*/
+#define IPPROTO_MPTCP		IPPROTO_MPTCP
   IPPROTO_MAX
 };
 #endif
-- 
2.23.0

