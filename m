Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC493119A2E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfLJVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfLJVIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 272E520652;
        Tue, 10 Dec 2019 21:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012105;
        bh=ts474jo8X09F8Xjx0LlPALO9jEwtcGrtKgKurM6fb6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbiWEAFRjgihSzeonE53jPIa9oBruVtH9hAYd5Sk60ARdvivePTO5hHIQgXPNDRJd
         KytqpGC/K8wMMVpKg22kkHRphpIfM5VFArpOxI6f0Ro5+svJEcDYZxr/p2WrYV6hMT
         spaxhvLxpQ8EtCJeBp59/BaENiXqW7qKm62zvKRw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 079/350] selftests/bpf: Fix btf_dump padding test case
Date:   Tue, 10 Dec 2019 16:03:04 -0500
Message-Id: <20191210210735.9077-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 76790c7c66ccc8695afc75e73f54c0ca86267ed2 ]

Existing padding test case for btf_dump has a good test that was
supposed to test padding generation at the end of a struct, but its
expected output was specified incorrectly. Fix this.

Fixes: 2d2a3ad872f8 ("selftests/bpf: add btf_dump BTF-to-C conversion tests")
Reported-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191008231009.2991130-4-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/btf_dump_test_case_padding.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 3a62119c74986..35c512818a56b 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -62,6 +62,10 @@ struct padded_a_lot {
  *	long: 64;
  *	long: 64;
  *	int b;
+ *	long: 32;
+ *	long: 64;
+ *	long: 64;
+ *	long: 64;
  *};
  *
  */
@@ -95,7 +99,6 @@ struct zone_padding {
 struct zone {
 	int a;
 	short b;
-	short: 16;
 	struct zone_padding __pad__;
 };
 
-- 
2.20.1

