Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2202504D6
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgHXRIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbgHXQiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E2312310F;
        Mon, 24 Aug 2020 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287065;
        bh=IRYV+X6VW9rjKkby9X778CS1Hr+wn3yRd29eHWImALU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFkbONU9yOBiP9wAvadbYIcLhi48S9wEjx8Cx9dGKLrVPDNa5HYEeJvqt/MgubmcH
         ssUnbbNAMhcX3Tfv+5kttplzJo5pY/ZqgDyhsYU1j49ByOHSVirnBvli+cvBjTJOB5
         L6ZtkT9IoqTHVZMpRj8bM92fvVyOpiJsPDBQFJ4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 51/54] libbpf: Fix map index used in error message
Date:   Mon, 24 Aug 2020 12:36:30 -0400
Message-Id: <20200824163634.606093-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
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
index 3e53bfcba2b1a..ae19778220574 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2151,7 +2151,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 		data = elf_getdata(scn, NULL);
 	if (!scn || !data) {
 		pr_warn("failed to get Elf_Data from map section %d (%s)\n",
-			obj->efile.maps_shndx, MAPS_ELF_SEC);
+			obj->efile.btf_maps_shndx, MAPS_ELF_SEC);
 		return -EINVAL;
 	}
 
-- 
2.25.1

