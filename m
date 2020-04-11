Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972EF1A5B30
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgDKXEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgDKXEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E5A7215A4;
        Sat, 11 Apr 2020 23:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646279;
        bh=trlwDwThN8VpndS+Dosau8+WGoHbHcbywweE9WxjASU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WATsBN2IA4yLD5aPmOkGZ0YlZgyoEivtEjnSTloxHGpSqzBQSgeJOiLIN11pr/e4V
         6qnxhLlK9Aa1TDzUKYLOQ+9Wxq6i5hS/Q6f/DsvJJo//TjVeFTFRGY+jcRgdbSI1ZQ
         4sMQFAcZEI17+9r4fDYjo9spzuLq8IVfHQC86QW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 042/149] libbpf: Fix handling of optional field_name in btf_dump__emit_type_decl
Date:   Sat, 11 Apr 2020 19:01:59 -0400
Message-Id: <20200411230347.22371-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 320a36063e1441210106aa33997ad3770d4c86b4 ]

Internal functions, used by btf_dump__emit_type_decl(), assume field_name is
never going to be NULL. Ensure it's always the case.

Fixes: 9f81654eebe8 ("libbpf: Expose BTF-to-C type declaration emitting API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200303180800.3303471-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index bd09ed1710f12..dc451e4de5ad4 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1030,7 +1030,7 @@ int btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 	if (!OPTS_VALID(opts, btf_dump_emit_type_decl_opts))
 		return -EINVAL;
 
-	fname = OPTS_GET(opts, field_name, NULL);
+	fname = OPTS_GET(opts, field_name, "");
 	lvl = OPTS_GET(opts, indent_level, 0);
 	btf_dump_emit_type_decl(d, id, fname, lvl);
 	return 0;
-- 
2.20.1

