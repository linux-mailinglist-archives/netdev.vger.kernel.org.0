Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D699796CEF
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfHTXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:09:09 -0400
Received: from lekensteyn.nl ([178.21.112.251]:43647 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfHTXJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 19:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=aTs/19MyORw3OpmJFYMSjvA9Q0yVU+se+6r/BJ0qdiU=;
        b=BSaZJSOI0BcGsmGwvW5jiiW/W0Ln5eJWYXS6BlI2IQLa8JVpexEwrGnu5q8jxhozsIAssg6GzZ4LSnzUJJvLgVP56qJY/cIgCiSLkM059gvXCb8YA59q9QTZwwJcUB6qP89BcQfSjkjFeFDKUeGtboTiAPQMoAxv+4p5SZMoB4b80NKUQwdl2o7CayGL9+pVsW87nB1DD+1fj7evgdFdX6AOWtzazCJ+zv/MkPKJ2+99Y2xnAjaoOKIv9pQCX0LN+6sPcryNCOEW+pvH1Xw8UqbxLHC58e5pL3WMl7nHqLV1MOlAGF6oMXpyHALW1A66TAKcfDwmH72NTiuMf7669w==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1i0DFR-00055S-Np; Wed, 21 Aug 2019 01:09:05 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 4/4] bpf: sync bpf.h to tools/
Date:   Wed, 21 Aug 2019 00:09:00 +0100
Message-Id: <20190820230900.23445-5-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190820230900.23445-1-peter@lekensteyn.nl>
References: <20190820230900.23445-1-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a 'struct pt_reg' typo and clarify when bpf_trace_printk discards
lines. Affects documentation only.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 tools/include/uapi/linux/bpf.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65..58bdb89599c9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -575,6 +575,8 @@ union bpf_attr {
  * 		limited to five).
  *
  * 		Each time the helper is called, it appends a line to the trace.
+ * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
+ * 		open, use *\/sys/kernel/debug/tracing/trace_pipe* to avoid this.
  * 		The format of the trace is customizable, and the exact output
  * 		one will get depends on the options set in
  * 		*\/sys/kernel/debug/tracing/trace_options* (see also the
@@ -1013,7 +1015,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(struct pt_reg *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1075,7 +1077,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(struct pt_reg *ctx, struct bpf_map *map, u64 flags)
+ * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1721,7 +1723,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_override_return(struct pt_reg *regs, u64 rc)
+ * int bpf_override_return(struct pt_regs *regs, u64 rc)
  * 	Description
  * 		Used for error injection, this helper uses kprobes to override
  * 		the return value of the probed function, and to set it to *rc*.
-- 
2.22.0

