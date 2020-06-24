Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA57A207787
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404581AbgFXPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404107AbgFXPe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 11:34:56 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6BD2077D;
        Wed, 24 Jun 2020 15:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593012895;
        bh=opS5eRfWkZxbEhJg9X6T95jpkuS1Z4Ygb8njO6/vd6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY43QSWjPjgeZinl3XIdzuaK7fu4/gFXrvOK5l0uQ7AWZeQzBrG98fFLZ0FM2hgzF
         3iPmZpaGMlCnM0+mMYDN7IT31eEm22AZbsYw/U1FQGrSfwNQyKS6sVZ1u10LdHJK2J
         oYPMykDwLa+Ui5V565ClRa6gLPJuHWMnXY5HVBGY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v4 bpf-next 7/9] libbpf: add SEC name for xdp programs attached to CPUMAP
Date:   Wed, 24 Jun 2020 17:33:56 +0200
Message-Id: <5a1ce6302ffcd54b87213e840e3e8d5b92285171.1593012598.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593012598.git.lorenzo@kernel.org>
References: <cover.1593012598.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As for DEVMAP, support SEC("xdp_cpumap/") as a short cut for loading
the program with type BPF_PROG_TYPE_XDP and expected attach type
BPF_XDP_CPUMAP.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
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

