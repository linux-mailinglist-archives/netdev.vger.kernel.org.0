Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858AB1E3478
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgE0BJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgE0BJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:09:12 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D80E20E65;
        Wed, 27 May 2020 01:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590541751;
        bh=T0IVk+W0jmSuwjR9xT3b3xG1pvcq2QYiZ1jAJhmAfAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9+QjSTTg7ci7H0px9taJANQHJzMqQ5IONS7sbXcqryqcS6lq2nk+44v0qGCx/gJ2
         bouG3IVKvfNxC5AuFzZWW7U4PtyCRHHuxcA3jGtIdrEH80mtFaqbHkPYdRqMK209E7
         9tWcJ1m7EAws9Sy0xSZdaG1/1XMwhypeV+7NlrvE=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf-next 4/5] bpftool: Add SEC name for xdp programs attached to device map
Date:   Tue, 26 May 2020 19:09:04 -0600
Message-Id: <20200527010905.48135-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200527010905.48135-1-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support SEC("xdp_dm*") as a short cut for loading the program with
type BPF_PROG_TYPE_XDP and expected attach type BPF_XDP_DEVMAP.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fa04cbe547ed..563827b260e8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6657,6 +6657,8 @@ static const struct bpf_sec_def section_defs[] = {
 		.expected_attach_type = BPF_TRACE_ITER,
 		.is_attach_btf = true,
 		.attach_fn = attach_iter),
+	BPF_EAPROG_SEC("xdp_dm",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_DEVMAP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
-- 
2.21.1 (Apple Git-122.3)

