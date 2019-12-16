Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341141209AB
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 16:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbfLPP1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 10:27:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728392AbfLPP1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 10:27:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576510069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=p19K4nNZBjlA/2QraodRTLoohxP7l5DJnVKPrMnOfvs=;
        b=GTWHr/mvq9pR1cCVSMEqUuUa5XGFc8wyPSXQSaH5aHjWmvO2qnLo9CuFjf2SPo1iEVulMM
        HqPuTO0gkF7hqM8fEtVSxxSqOYzxyWt/qJCH3vzasYjfrMPue7Fl4nk/XJc+9YJICLYA6J
        32D1dWB1J4mSBcCXXbiTZhq4dVGQP1Q=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-cqn18qJKPTmgaDZ103hUlg-1; Mon, 16 Dec 2019 10:27:47 -0500
X-MC-Unique: cqn18qJKPTmgaDZ103hUlg-1
Received: by mail-lj1-f200.google.com with SMTP id b12so2254836ljo.11
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 07:27:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p19K4nNZBjlA/2QraodRTLoohxP7l5DJnVKPrMnOfvs=;
        b=ZfIiq3vzzzku4yfrXQUzEppcaHDkZhCYM8HaEOAhs8YgDTBha1zvU6lTX0ippWUjZD
         w6hYo3Or0MOELDGpYyWdr+0hwfGrm9naSTtWeq3HXiK78bVVEkrlr0/tg5lh7W+BxkM4
         9SpQjIr6WKTlYaHaiCCfpIY+HFIjlky5fpe3skroycV8q8Pm1b0SpcH5kc5B0OCcrk5m
         m++3VEYGaZHWGRrKgauhrc+YcTn580diBd7XhB7VXXK40vgQWayrPAJEVw2ZYF6GxWHW
         I5ZU8WpO9Zh8eKz2tRVWGUJ78EbdpVIDvRX04hnLt/iV6QBLyKe5z3e32qJPdq6xImDT
         8phg==
X-Gm-Message-State: APjAAAXEZAyHpIslZoKz5DdKqB4YrGd+yQPh5aMha4ZMfxlvXoUfjO4m
        UWeNFOVTaIa8GMgOxDE6hLOHb5pU48G+AbO1zO0IVlPUx/CxXL4+eQCMaq4AQLa9oV5ojof5k8F
        xUvjQQ7VkpUy4Dt98
X-Received: by 2002:a19:c205:: with SMTP id l5mr16808665lfc.159.1576510066037;
        Mon, 16 Dec 2019 07:27:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzm8TtaRzB4+6ef+vGk4EE5SHs2+z3xeqcnqxvHEW9SpJ2hw3TvrTJVZVPO1YB3qQuitDtLTA==
X-Received: by 2002:a19:c205:: with SMTP id l5mr16808621lfc.159.1576510065288;
        Mon, 16 Dec 2019 07:27:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o20sm11033568ljc.35.2019.12.16.07.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 07:27:44 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9685D180960; Mon, 16 Dec 2019 16:27:43 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [RFC PATCH bpf-next] xdp: Add tracepoint on XDP program return
Date:   Mon, 16 Dec 2019 16:27:15 +0100
Message-Id: <20191216152715.711308-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new tracepoint, xdp_prog_return, which is triggered at every
XDP program return. This was first discussed back in August[0] as a way to
hook XDP into the kernel drop_monitor framework, to have a one-stop place
to find all packet drops in the system.

Because trace/events/xdp.h includes filter.h, some ifdef guarding is needed
to be able to use the tracepoint from bpf_prog_run_xdp(). If anyone has any
ideas for how to improve on this, please to speak up. Sending this RFC
because of this issue, and to get some feedback from Ido on whether this
tracepoint has enough data for drop_monitor usage.

[0] https://lore.kernel.org/netdev/20190809125418.GB2931@splinter/

Cc: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h     | 22 +++++++++++++++++--
 include/trace/events/xdp.h | 45 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/core.c          |  2 ++
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 37ac7025031d..f5e79171902f 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -704,19 +704,37 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 
 DECLARE_BPF_DISPATCHER(bpf_dispatcher_xdp)
 
+#if defined(_XDP_TRACE_DEF) || defined(_TRACE_XDP_H)
+static void call_trace_xdp_prog_return(const struct xdp_buff *xdp,
+				       const struct bpf_prog *prog,
+				       u32 act);
+#else
+#ifndef _CALL_TRACE_XDP
+#define _CALL_TRACE_XDP
+static inline void call_trace_xdp_prog_return(const struct xdp_buff *xdp,
+					      const struct bpf_prog *prog,
+					      u32 act) {}
+#endif
+#endif
+
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
+	u32 ret;
+
 	/* Caller needs to hold rcu_read_lock() (!), otherwise program
 	 * can be released while still running, or map elements could be
 	 * freed early while still having concurrent users. XDP fastpath
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return __BPF_PROG_RUN(prog, xdp,
-			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
+	ret = __BPF_PROG_RUN(prog, xdp,
+			     BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
+	call_trace_xdp_prog_return(xdp, prog, ret);
+	return ret;
 }
 
+
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
 
 static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index a7378bcd9928..e64f4221bd2e 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -50,6 +50,51 @@ TRACE_EVENT(xdp_exception,
 		  __entry->ifindex)
 );
 
+TRACE_EVENT(xdp_prog_return,
+
+	TP_PROTO(const struct xdp_buff *xdp,
+		 const struct bpf_prog *pr, u32 act),
+
+	TP_ARGS(xdp, pr, act),
+
+	TP_STRUCT__entry(
+		__field(int, prog_id)
+		__field(u32, act)
+		__field(int, ifindex)
+		__field(int, queue_index)
+		__field(const void *, data_addr)
+		__field(unsigned int, data_len)
+	),
+
+	TP_fast_assign(
+		__entry->prog_id	= pr->aux->id;
+		__entry->act		= act;
+		__entry->ifindex	= xdp->rxq->dev->ifindex;
+		__entry->queue_index	= xdp->rxq->queue_index;
+		__entry->data_addr	= xdp->data;
+		__entry->data_len	= (unsigned int)(xdp->data_end - xdp->data);
+	),
+
+	TP_printk("prog_id=%d action=%s ifindex=%d queue_index=%d data_addr=%p data_len=%u",
+		  __entry->prog_id,
+		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
+		  __entry->ifindex,
+		  __entry->queue_index,
+		  __entry->data_addr,
+		  __entry->data_len)
+);
+
+#ifndef _CALL_TRACE_XDP
+#define _CALL_TRACE_XDP
+static inline void call_trace_xdp_prog_return(const struct xdp_buff *xdp,
+					      const struct bpf_prog *prog,
+					      u32 act)
+{
+	trace_xdp_prog_return(xdp, prog, act);
+}
+#endif
+
+
 TRACE_EVENT(xdp_bulk_tx,
 
 	TP_PROTO(const struct net_device *dev,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2ff01a716128..a81d3b8d8e5c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -17,6 +17,8 @@
  * Kris Katterjohn - Added many additional checks in bpf_check_classic()
  */
 
+#define _XDP_TRACE_DEF
+
 #include <uapi/linux/btf.h>
 #include <linux/filter.h>
 #include <linux/skbuff.h>
-- 
2.24.1

