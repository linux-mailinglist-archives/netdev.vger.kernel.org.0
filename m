Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1365E206653
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394052AbgFWVkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394046AbgFWVkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:40:16 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DC30208C9;
        Tue, 23 Jun 2020 21:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592948416;
        bh=39nK/nXqvDHuUPZgpGAmEmsgZKOsgV2ZPJy+N53fGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9uOK54o6eNKQdBI9sDBu/kOp7KkQHtp/DixHKuXyg1DWNYA1rp1Cc8MEAZ8jQMoA
         tbgrVhVZfCa1MT6KjWTp9DfnR7YpFoFn9puXm0TSju1pt5cmEJSVg4DW4pQids5Zvz
         0zd//R+UWkGOyD/qqLiRL+2jnxaz5JG83cpQJRiA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v3 bpf-next 7/9] libbpf: add SEC name for xdp programs attached to CPUMAP
Date:   Tue, 23 Jun 2020 23:39:32 +0200
Message-Id: <372755fa10bdbe9b5db4e207db6b0829e18513fe.1592947694.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As for DEVMAP, support SEC("xdp_cpumap*") as a short cut for loading
the program with type BPF_PROG_TYPE_XDP and expected attach type
BPF_XDP_CPUMAP.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 18461deb1b19..16fa3b84ac38 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6866,6 +6866,8 @@ static const struct bpf_sec_def section_defs[] = {
 		.attach_fn = attach_iter),
 	BPF_EAPROG_SEC("xdp_devmap",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
+	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_CPUMAP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
-- 
2.26.2

