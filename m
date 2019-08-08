Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C627485EFD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389814AbfHHJuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:50:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:34848 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbfHHJuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 05:50:04 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hvf3X-0006I4-JT; Thu, 08 Aug 2019 11:49:59 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, m@lambda.lt,
        edumazet@google.com, ast@kernel.org, willemb@google.com,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net 2/2] bpf: sync bpf.h to tools infrastructure
Date:   Thu,  8 Aug 2019 11:49:37 +0200
Message-Id: <20190808094937.26918-3-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808094937.26918-1-daniel@iogearbox.net>
References: <20190808094937.26918-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25535/Thu Aug  8 10:18:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull in updates in BPF helper function description.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/include/uapi/linux/bpf.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65..a5aa7d3ac6a1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1466,8 +1466,8 @@ union bpf_attr {
  * 		If no cookie has been set yet, generate a new cookie. Once
  * 		generated, the socket cookie remains stable for the life of the
  * 		socket. This helper can be useful for monitoring per socket
- * 		networking traffic statistics as it provides a unique socket
- * 		identifier per namespace.
+ * 		networking traffic statistics as it provides a global socket
+ * 		identifier that can be assumed unique.
  * 	Return
  * 		A 8-byte long non-decreasing number on success, or 0 if the
  * 		socket field is missing inside *skb*.
@@ -1571,8 +1571,11 @@ union bpf_attr {
  * 		but this is only implemented for native XDP (with driver
  * 		support) as of this writing).
  *
- * 		All values for *flags* are reserved for future usage, and must
- * 		be left at zero.
+ * 		The lower two bits of *flags* are used as the return code if
+ * 		the map lookup fails. This is so that the return value can be
+ * 		one of the XDP program return codes up to XDP_TX, as chosen by
+ * 		the caller. Any higher bits in the *flags* argument must be
+ * 		unset.
  *
  * 		When used to redirect packets to net devices, this helper
  * 		provides a high performance increase over **bpf_redirect**\ ().
-- 
2.17.1

