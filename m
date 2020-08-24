Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9C2505AC
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHXRUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728341AbgHXQgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:36:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C40A22CB3;
        Mon, 24 Aug 2020 16:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286987;
        bh=1r9Nwm+fHZWNLsNiNhca3Aszj5TIiU+51K/LKn1Uz5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saloeLGZdC+qCI/wJkniCVsPfP46DPTAyRY2h+vzr7Beujnnxqbz34DWPjp6VqJ7l
         kp2oGhup3TkPIOlKbtoiR2t8UCLlQdg8cWhLB4QfZ7QYeU+ZPZ0GfBNjeiFdnbHjwk
         GhgclZomOnQhzhC0B/phDQGlXcIx+FMBVOJBVxko=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 60/63] libbpf: Fix map index used in error message
Date:   Mon, 24 Aug 2020 12:35:00 -0400
Message-Id: <20200824163504.605538-60-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 1e891e513e16c145cc9b45b1fdb8bf4a4f2f9557 ]

The error message emitted by bpf_object__init_user_btf_maps() was using the
wrong section ID.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200819110534.9058-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e8e88c1ab69de..dd89cbc1acd7b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2237,7 +2237,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 		data = elf_getdata(scn, NULL);
 	if (!scn || !data) {
 		pr_warn("failed to get Elf_Data from map section %d (%s)\n",
-			obj->efile.maps_shndx, MAPS_ELF_SEC);
+			obj->efile.btf_maps_shndx, MAPS_ELF_SEC);
 		return -EINVAL;
 	}
 
-- 
2.25.1

