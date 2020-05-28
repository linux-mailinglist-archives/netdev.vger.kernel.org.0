Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434461E5222
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgE1AOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgE1AO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 20:14:29 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DB22145D;
        Thu, 28 May 2020 00:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590624869;
        bh=LMvpoYSfq7Kyp231vwYOOIFRb+mj2gJwkyE9ufxfIQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSGTW14cauyuZBl/Cw5Rc48T8mv6YIWF+2dnxrUW7W0fMs7xWOYm8x7dMu8gioYOM
         SYyNtMSnwGd/8mKP7SBef2e6VA8AJCM/1o36wb+bnxUeTv9MWbCGFopb6MmyQHxLQh
         uVwu3SVPgHDep62St1GmU1TGKesTh7fyHdRxdj+o=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 bpf-next 4/5] libbpf: Add SEC name for xdp programs attached to device map
Date:   Wed, 27 May 2020 18:14:22 -0600
Message-Id: <20200528001423.58575-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200528001423.58575-1-dsahern@kernel.org>
References: <20200528001423.58575-1-dsahern@kernel.org>
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
index 5d60de6fd818..493909d5d3d3 100644
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

