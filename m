Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33532899E4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390771AbgJIUmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:42:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:39466 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388460AbgJIUmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:42:51 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzE1-00084k-1g; Fri, 09 Oct 2020 22:42:49 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf-next v3 1/6] bpf: improve bpf_redirect_neigh helper description
Date:   Fri,  9 Oct 2020 22:42:40 +0200
Message-Id: <20201009204245.27905-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201009204245.27905-1-daniel@iogearbox.net>
References: <20201009204245.27905-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow-up to address David's feedback that we should better describe internals
of the bpf_redirect_neigh() helper.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/uapi/linux/bpf.h       | 10 +++++++---
 tools/include/uapi/linux/bpf.h | 10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 42d2df799397..4272cc53d478 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3679,10 +3679,14 @@ union bpf_attr {
  * 		Redirect the packet to another net device of index *ifindex*
  * 		and fill in L2 addresses from neighboring subsystem. This helper
  * 		is somewhat similar to **bpf_redirect**\ (), except that it
- * 		fills in e.g. MAC addresses based on the L3 information from
- * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
+ * 		populates L2 addresses as well, meaning, internally, the helper
+ * 		performs a FIB lookup based on the skb's networking header to
+ * 		get the address of the next hop and then relies on the neighbor
+ * 		lookup for the L2 address of the nexthop.
+ *
  * 		The *flags* argument is reserved and must be 0. The helper is
- * 		currently only supported for tc BPF program types.
+ * 		currently only supported for tc BPF program types, and enabled
+ * 		for IPv4 and IPv6 protocols.
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 42d2df799397..4272cc53d478 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3679,10 +3679,14 @@ union bpf_attr {
  * 		Redirect the packet to another net device of index *ifindex*
  * 		and fill in L2 addresses from neighboring subsystem. This helper
  * 		is somewhat similar to **bpf_redirect**\ (), except that it
- * 		fills in e.g. MAC addresses based on the L3 information from
- * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
+ * 		populates L2 addresses as well, meaning, internally, the helper
+ * 		performs a FIB lookup based on the skb's networking header to
+ * 		get the address of the next hop and then relies on the neighbor
+ * 		lookup for the L2 address of the nexthop.
+ *
  * 		The *flags* argument is reserved and must be 0. The helper is
- * 		currently only supported for tc BPF program types.
+ * 		currently only supported for tc BPF program types, and enabled
+ * 		for IPv4 and IPv6 protocols.
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
-- 
2.17.1

