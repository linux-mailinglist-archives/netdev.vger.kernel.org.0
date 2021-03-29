Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB334D55D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhC2Qpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhC2Qpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:45:44 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C54AC061756
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:45:44 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m5so10652662pgp.13
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oAB+Nl4FFFMz/nqI5DhEiAQ9QgS+G5IVSXiy+W8aIAs=;
        b=Ub4qL+G0TFMmpt8I9Y0leGAVswWqNSISZsn/M04pjYwpXOHGwaro/4CnljdEszm6zT
         h5Co5ifTcvMp0xu29wzemGPLvWLXRbi1jBrf98sregWcgPruScjtiV18ZDWrO3QtAon5
         ULqMbWZ36LIsJSVp1WVt7fVhLKQgwRSXpTpeJJYGCBdoCeTn9A319VAuKqvD1vpKVCBM
         9DhcF+F6B58+9qreGjrRuOhel8H4/zIV1aOetH/r+gLEIYXJdxYa8lKPk7EMHywWNdEL
         LWCQwxzJW4bK/eb9LbhnN2oXDeX2Cf9T/mjIHfp8tCc9FN05k9Q/3Mfj3R+FXX38YQ0G
         hs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oAB+Nl4FFFMz/nqI5DhEiAQ9QgS+G5IVSXiy+W8aIAs=;
        b=SxIVfw2BpksdVRQ2WOVaU2sXschDxo8RZlCtKb4lAA/ahIFW/P36Bx/lDAClOcF4gU
         gxjFVq4kxfI6GzlbJ8uW08cAfyH4MukB1syMoxCEIJSBW4i25nGhzXj2vy1YFCJVzHgZ
         +FRG0PDlPVR8ZEuf1octAahb6QoqvJJtfpANiSNiB/eBzOfL0BR4he7qI/xTq24g5Xqj
         3nCEojDPniVEejapnm8M73owFVs1pRbgyOmtUe/E82+sYiV3uv2JHsUjDyeJoxVv03q9
         lvKv6Y2Z0v6Tdoibh3fjeQ01IpsSQWoJHi0cnPi9Z3dA9snBVDXKSEeZg1xL5HHY0X+M
         vw+g==
X-Gm-Message-State: AOAM533VAf3c4PhzTdTbqkUbx193kHCmjKY//5Q5QYuzHIOdgSzWdhHY
        e9gBTXS8g+WhUCSZbN4St0vTTZeWLxXr7/Sxpo8BwhYHGMZGLtdhnlBBuqyc9uK0MqfunlzQwjw
        wBBTgWYtRx90NKpaBgAXYaJMXMAurQxTYuuQPeVYCmHtUIw+3gvXl/g==
X-Google-Smtp-Source: ABdhPJyZWEOxE+3z9VOFN/LKiQwo35hSdBfgqnhe/G3qVNN7DD7U4N4W6xk1VmjB5uDp2Dh3yWoHlVA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:ede7:5698:2814:57c])
 (user=sdf job=sendgmr) by 2002:aa7:8e8f:0:b029:1f1:5a1a:7f82 with SMTP id
 a15-20020aa78e8f0000b02901f15a1a7f82mr26356990pfr.52.1617036343555; Mon, 29
 Mar 2021 09:45:43 -0700 (PDT)
Date:   Mon, 29 Mar 2021 09:45:41 -0700
Message-Id: <20210329164541.3240579-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2 bpf-next] tools/resolve_btfids: Fix warnings
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* make eprintf static, used only in main.c
* initialize ret in eprintf
* remove unused *tmp
* remove unused 'int err = -1'

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/resolve_btfids/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 80d966cfcaa1..be74406626b7 100644
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
@@ -403,10 +403,9 @@ static int symbols_collect(struct object *obj)
 	 * __BTF_ID__* over .BTF_ids section.
 	 */
 	for (i = 0; !err && i < n; i++) {
-		char *tmp, *prefix;
+		char *prefix;
 		struct btf_id *id;
 		GElf_Sym sym;
-		int err = -1;
 
 		if (!gelf_getsym(obj->efile.symbols, i, &sym))
 			return -1;
-- 
2.31.0.291.g576ba9dcdaf-goog

