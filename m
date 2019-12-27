Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B115912B83C
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfL0Ryb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfL0Rme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED5F822525;
        Fri, 27 Dec 2019 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468553;
        bh=/tw67VQLb0mitfMvrosR62AiKJIK6xrq9uKx8NzGIJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEdpzT0cNb/VQRXToLXVkXVs15Vp/19X/7W048v75c9/ID9viUQlHBFITVQBwaoqD
         8bXqi35DCNNchhyePdL5EV7yVYuRtOUqogGI4jYwQj170P2GLf7IKIeZum12ETDWED
         vDqp6fPE+OzWnB/89To9Nj2xBrZO3kZaruJSEljk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 080/187] samples: bpf: Replace symbol compare of trace_event
Date:   Fri, 27 Dec 2019 12:39:08 -0500
Message-Id: <20191227174055.4923-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>

[ Upstream commit bba1b2a890253528c45aa66cf856f289a215bfbc ]

Previously, when this sample is added, commit 1c47910ef8013
("samples/bpf: add perf_event+bpf example"), a symbol 'sys_read' and
'sys_write' has been used without no prefixes. But currently there are
no exact symbols with these under kallsyms and this leads to failure.

This commit changes exact compare to substring compare to keep compatible
with exact symbol or prefixed symbol.

Fixes: 1c47910ef8013 ("samples/bpf: add perf_event+bpf example")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191205080114.19766-2-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/trace_event_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index 16a16eadd509..749a50f2f9f3 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -37,9 +37,9 @@ static void print_ksym(__u64 addr)
 	}
 
 	printf("%s;", sym->name);
-	if (!strcmp(sym->name, "sys_read"))
+	if (!strstr(sym->name, "sys_read"))
 		sys_read_seen = true;
-	else if (!strcmp(sym->name, "sys_write"))
+	else if (!strstr(sym->name, "sys_write"))
 		sys_write_seen = true;
 }
 
-- 
2.20.1

