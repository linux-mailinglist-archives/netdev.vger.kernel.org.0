Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B86834DBF0
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhC2Wdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhC2Wbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 18:31:46 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33638C0613D8
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:31:46 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id t24so13251536qkg.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q8YC7QsT68djr+5X1MBcYOtPJh4z8UQj3GHMhPlwj6U=;
        b=iah82HS24X7ki+RXgfuxNHUXLmyc+TuCsp9oZHppVxCwiTZnDhUBZvV82m5R8LDrTh
         oc9rvXzlZtdHnFStzAOssn2oB6yl2X8ZYXvJFmdYtKAR1a0e9gHoyOLT2Y+JmNhakoRE
         0K+LXFMC1GrSW3H1CqTR80vUhNA4o/qhu4gkc7QbxBhO0PvwJbwkz5YEZSUrxu7jHtVm
         tDOjMbKK4BRQGMYHwocZqL/6IKiiKo2vVDYrBR/oQUwXaLIhHLMHD4Nm0sKjtcatmZ88
         1zRMItQTI1SLDks07kEolUpPgqB9yXFhEOeHqNTQ6aBWFsrz0QBgXgaxCQ9fLC1zK7/e
         UDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Q8YC7QsT68djr+5X1MBcYOtPJh4z8UQj3GHMhPlwj6U=;
        b=XlLBkI+kTVDfM/P+AWA5BjYZZhUHsZPh9FvVF9KIHuR+CSVj2bQtutUe3Sn4A9rOv0
         EHy7dy39cFcq4XnKFG2ahi+jUSub/mFnwLN17WNKmFwP5VAUfDbxTf3mFmbWq03p0g+R
         lew7l6/1ebeArOqPAwkj9N3mXfO1gZDnnKQ1YfyItlPBjYwXW1imR26qwgL0/74CUWOB
         NQPaultjvsff+S4xorOajWRadLNQgqSI+QZkr4pXuVfRJlUahYdVTs9WnM4SZM5J5pIh
         VzVcVZ6hoP8F6cmjpbUTfQmr2caGR8a3kaXAn2WJQ5e1+xuUWSFysQ1m0x1MJSiCpJD8
         GLHQ==
X-Gm-Message-State: AOAM530DcYQzSdjL6HyrJ5FdhynnT5177PDdX2gXKNuDWwTZ6jvRVAK2
        bzuJanHbT3jtn5yq1lm4EuyvI1Z0cLufh9T2rJZ2VBNwX5Wv3rMdiy6I4K9zO/h9MBNIcbuBaS/
        zBVq3SFIqGdgkONt1j6+EJXHj43nmTmoT59b0Z36BwMMTZYn1OgTkrQ==
X-Google-Smtp-Source: ABdhPJwJYPovPdrVaVUoTstb8My5EfnOOkvSEnX/CQNx4ThkDPXrKKpBt/wwD1tyG0oYyTojvcv8v6A=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:ede7:5698:2814:57c])
 (user=sdf job=sendgmr) by 2002:ad4:528c:: with SMTP id v12mr27335404qvr.54.1617057105299;
 Mon, 29 Mar 2021 15:31:45 -0700 (PDT)
Date:   Mon, 29 Mar 2021 15:31:43 -0700
Message-Id: <20210329223143.3659983-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v3 bpf-next] tools/resolve_btfids: Fix warnings
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* make eprintf static, used only in main.c
* initialize ret in eprintf
* remove unused *tmp

v3:
* remove another err (Song Liu)

v2:
* remove unused 'int err = -1'

Cc: Song Liu <song@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/resolve_btfids/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 80d966cfcaa1..7550fd9c3188 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -115,10 +115,10 @@ struct object {
 
 static int verbose;
 
-int eprintf(int level, int var, const char *fmt, ...)
+static int eprintf(int level, int var, const char *fmt, ...)
 {
 	va_list args;
-	int ret;
+	int ret = 0;
 
 	if (var >= level) {
 		va_start(args, fmt);
@@ -385,7 +385,7 @@ static int elf_collect(struct object *obj)
 static int symbols_collect(struct object *obj)
 {
 	Elf_Scn *scn = NULL;
-	int n, i, err = 0;
+	int n, i;
 	GElf_Shdr sh;
 	char *name;
 
@@ -402,11 +402,10 @@ static int symbols_collect(struct object *obj)
 	 * Scan symbols and look for the ones starting with
 	 * __BTF_ID__* over .BTF_ids section.
 	 */
-	for (i = 0; !err && i < n; i++) {
-		char *tmp, *prefix;
+	for (i = 0; i < n; i++) {
+		char *prefix;
 		struct btf_id *id;
 		GElf_Sym sym;
-		int err = -1;
 
 		if (!gelf_getsym(obj->efile.symbols, i, &sym))
 			return -1;
-- 
2.31.0.291.g576ba9dcdaf-goog

