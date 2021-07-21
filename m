Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF13D0E70
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhGULWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:22:34 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:47984
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239029AbhGULQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 07:16:00 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 5AB3F3F233;
        Wed, 21 Jul 2021 11:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626868593;
        bh=z2ufXsLf37VqDlE9l6EtFspiE90ljAjzw62R09jzo/Y=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=TZwEf7IEZjs0CeGI6pWIb2jqxZIObRdqFz29DsylAxAiC1XQLbRi+34P+YmLuifpo
         k6ElrOQryQaYAsIjScswMlyVbec66N8hvjEBd2TCKQhc0QKgIhzwejTzqNQY8X/RfM
         EnzgKn0+9EJ9+uCG0uOX2n1DszQqMo/0Gq9mD7QHRjHBp3hPujVdmAj2k39FrdR37A
         X9VmR73zFrWxqfl1QDtOur09FdazHsYWO8r+z/l3IcJpj4CIsuJlZ+chOF/5xZLjix
         QmswdhJDUuW8Hr1I8drlAugo8QZyVMNve8nWE1akbi1A4z+bKXRTDoSZ7PrL1VFrI6
         Q+L2ilizuJB5A==
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: remove redundant intiialization of variable stype
Date:   Wed, 21 Jul 2021 12:56:30 +0100
Message-Id: <20210721115630.109279-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable stype is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 kernel/bpf/local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 362e81481594..7ed2a14dc0de 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -406,7 +406,7 @@ static int cgroup_storage_check_btf(const struct bpf_map *map,
 static void cgroup_storage_seq_show_elem(struct bpf_map *map, void *key,
 					 struct seq_file *m)
 {
-	enum bpf_cgroup_storage_type stype = cgroup_storage_type(map);
+	enum bpf_cgroup_storage_type stype;
 	struct bpf_cgroup_storage *storage;
 	int cpu;
 
-- 
2.31.1

