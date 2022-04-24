Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B73B50CFC3
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 07:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiDXFN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 01:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiDXFNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 01:13:55 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5446174;
        Sat, 23 Apr 2022 22:10:51 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 5C511C021; Sun, 24 Apr 2022 07:10:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777050; bh=7qSdX1fQc8qaq/0kGWbdqAbwUgwAzFodhcpGt82loR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdWarBr5CnPsGzKSetCqZpdT5ZKydqge7UiNqi+BUKoDD2rrbENWcT4IlB2JdwlOx
         2PTD8YGbNmqriodTcDW+1JFuswkszJQAFrJLmwCI5jgO3UBGJhkF9Y6eOYfknRgQJt
         6Cp2YbKYtaoJhbzK8E8TrsH6uDnVeYHKRCJpjlTTOngbVpI7dtLZaygTwNWVGaSwGL
         zzYY0pzl3coJL/9Cu/FMmlc7wCwfgm76KE1d4gUrViS9L0pxQ0hXQYGNSX8TJzfWQR
         omrbTSS1BX00n28oLbxUqraCdDmRMfYM6b2KMYitcMp9sjiPr3jnHxYlRdap4R07kz
         ZJLCTlhnc4yBw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 3705DC01E;
        Sun, 24 Apr 2022 07:10:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777049; bh=7qSdX1fQc8qaq/0kGWbdqAbwUgwAzFodhcpGt82loR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgfIS7pUGdGHNkVlxWV4bZXPoJoi9lirfrl8o/cOJt0ezuoXj6eddMm/hxfXlXsSm
         VDxGtvGCWHBDb3tgD6BPEdCgwOziRhdl8SY2UHqXelUuYpuiFwU1FLFlcmMhcBGnwb
         9ZAPz1K3VNetc70zr4JGqpsklbHqt7+JNGd2whkAU/Oa9k+mL0Zq2EuJ+rcbwWgXrg
         3XSVlk4KT3J/+tmCE/KqwJJXgJDuxOXV2bOXeEPZ7W973D9LUWo6IK6kzIL7ySdyZl
         vFWlqaVkP1SgUakf8LdyoyrrgtGdJssLpTaDHhJpzcoP5QalcEaWQkJCfVCesrLPoz
         dS97PnXpNrejA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id e78b8354;
        Sun, 24 Apr 2022 05:10:26 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4/4] tools/bpf: replace sys/fcntl.h by fcntl.h
Date:   Sun, 24 Apr 2022 14:10:22 +0900
Message-Id: <20220424051022.2619648-5-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220424051022.2619648-1-asmadeus@codewreck.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

musl does not like including sys/fcntl.h directly:
    1 | #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h>

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 tools/bpf/bpftool/tracelog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/tracelog.c b/tools/bpf/bpftool/tracelog.c
index e80a5c79b38f..bf1f02212797 100644
--- a/tools/bpf/bpftool/tracelog.c
+++ b/tools/bpf/bpftool/tracelog.c
@@ -9,7 +9,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <linux/magic.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <sys/vfs.h>
 
 #include "main.h"
-- 
2.35.1

