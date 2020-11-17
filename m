Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F02B6815
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgKQO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQO6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:58:04 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E459C0613CF;
        Tue, 17 Nov 2020 06:58:04 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 81so7833785pgf.0;
        Tue, 17 Nov 2020 06:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QTNAsmJWywQK31rnCwGj30fhbZ0MO6d7w/L2x6KNmXA=;
        b=kNugxmFUmbxznmO9LQVmqriBwneAu7PyIb+jw2PZdGNcAIPy8y/H1TIETfTEOVECTd
         zV+8jgsHrbQpBv+8DwOWnixMtgN/C0tzOdREC8s3siep5gUJWJ4AktgbQwD+UpfOQPH1
         SCKQ6iVaK9/Hhd63lf2gF7Id/huuNJLhd4el9Hyw3DzWFxHD83pKzMwgfR0Gy49J0ACu
         IxTNZZ1OikclS6VVIwxH8s5O6uGhUuB4szmEEHDyXPOmMCnMjG+O2KwEW19JcwBkItsJ
         LZOMiUc0qVNDT/6BhR7sL+XffOoiA6ZA/tyhaCWkE1wsWIeto+KDREIuOh+jOh+bAc7G
         k8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QTNAsmJWywQK31rnCwGj30fhbZ0MO6d7w/L2x6KNmXA=;
        b=jmFbZ6VktWIBK2KIHtw6IgQ31RqUYB0xPayTULzvUSCjLs1s0XoXzwIwu6CnUvEbA+
         YjQtJ3MhY6WkCEvA5iqOfll0Zo82QIsDMIQuPgk0rb8iJwdeU6ijC/Cg9MK7tLByOzNW
         kFLzGI78GGSpk8PI4u8ibqiG5q8qLCtdlA/ZfJOJdGGI68fyx/K7A/LelqZtMzIpAXaM
         OT+ImLE4SL5AGs/Dl3SSlbSpFnQiZarolSf3T8ycmYtfiQg599+4JpRQxaTMoPXpHG6u
         k1Mezh1zNd2IbYgGumCLcwV0zsxqfUyOThCDndlFh8eaUzmTa7n766BcPqi7yzvrNM/1
         jPaQ==
X-Gm-Message-State: AOAM530nIJk/b+/13b3Ef+EBYFmOe6pxXlD8nf6mKmToimyix91JEhwf
        ak7FJ5UbsJb6Df2KrBQ/cTrx57FwIKrF
X-Google-Smtp-Source: ABdhPJwZAcSd+9vVJOM0fXGU6ZpMgZUVMaLeICXEH3v3nom3FzBEMYHXJI0m88ZO3F5NV4gJQM3KpA==
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr3863372pgu.21.1605625083732;
        Tue, 17 Nov 2020 06:58:03 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:58:03 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 8/9] samples: bpf: remove unused trace_helper and bpf_load from Makefile
Date:   Tue, 17 Nov 2020 14:56:43 +0000
Message-Id: <20201117145644.1166255-9-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit removes the unused trace_helper and bpf_load from
samples/bpf target objects from Makefile.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 16d9d68e1e01..a8b6fd943461 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -73,7 +73,7 @@ tracex5-objs := tracex5_user.o $(TRACE_HELPERS)
 tracex6-objs := tracex6_user.o
 tracex7-objs := tracex7_user.o
 test_probe_write_user-objs := test_probe_write_user_user.o
-trace_output-objs := trace_output_user.o $(TRACE_HELPERS)
+trace_output-objs := trace_output_user.o
 lathist-objs := lathist_user.o
 offwaketime-objs := offwaketime_user.o $(TRACE_HELPERS)
 spintest-objs := spintest_user.o $(TRACE_HELPERS)
@@ -91,8 +91,8 @@ test_current_task_under_cgroup-objs := $(CGROUP_HELPERS) \
 				       test_current_task_under_cgroup_user.o
 trace_event-objs := trace_event_user.o $(TRACE_HELPERS)
 sampleip-objs := sampleip_user.o $(TRACE_HELPERS)
-tc_l2_redirect-objs := bpf_load.o tc_l2_redirect_user.o
-lwt_len_hist-objs := bpf_load.o lwt_len_hist_user.o
+tc_l2_redirect-objs := tc_l2_redirect_user.o
+lwt_len_hist-objs := lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
@@ -108,7 +108,7 @@ xdpsock-objs := xdpsock_user.o
 xsk_fwd-objs := xsk_fwd.o
 xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
-xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
+xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
 
@@ -197,8 +197,6 @@ TPROGS_CFLAGS += --sysroot=$(SYSROOT)
 TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
 endif
 
-TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
-
 TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
 TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
-- 
2.25.1

