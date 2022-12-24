Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDB6558DC
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiLXHQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiLXHQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:16:01 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6CF10B79;
        Fri, 23 Dec 2022 23:15:54 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jn22so6702105plb.13;
        Fri, 23 Dec 2022 23:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6zLmWbFfcHm01hPAqRxC8QUpd9w9h8sf5XqbJ9uy68=;
        b=cVHpdTWAZNWgkc+4HJiZYB3du+jVU4uQf9PuYC5huIzuuvFKcIjvPhi8pOv6M6Y+QT
         +PzibG7KCj9xwaS6kIsqizNWUSAvX2wfv0xogQ5OigNAuklydZFwtOgiw+IUzQwVFd6Q
         RlJrfkiSOnxKkup+FE3BeTdIShXxy9nQTl1dOMmeeW3vayzaRvvIPxuhWOwll3WbQ22/
         dP4rW07Cs8yT5Z4NZiu8qNWbu36kohey4qcDejWzYKmwhKfnRGW6YjKakzHOsdOSk40B
         FE/X5Ah8UajP0Sj66lyFR6Ov5sLnt1lh4SyyjYdX6QlGp0sa+KBu3lwW6uh2s/JuTK3e
         N2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6zLmWbFfcHm01hPAqRxC8QUpd9w9h8sf5XqbJ9uy68=;
        b=n/AXhNndUwj9170RsR5pfqfgtT1XfaqCC/bzBMhLhx3h6vY5yjZzx4pyaQbXLTuMjm
         O3P23TnzgvYYAF1TaK2pKppfYMnsa+o12MjXudA+KhyxmY1V7mtuE4UQ0chmIthRvr1n
         RD5ldfxmrG9XlJCqGWWyWgrkQAy/nEhgMSwvPXJ4G+Ydhzcvxn4c8sRWeHS14TwXWp73
         4tzFg2dNaJejGcBZofqQNcg2+OptkCT9xJbYeArp5yFIl2A/oGDImqVLM50lIkctuzIX
         fzShUls8lKpKRZlOWFAZmiqbxxuK8ypZVyvj/Hl8+hAv2RSp0Qzcaq0Asp2IphU6JqtR
         l97w==
X-Gm-Message-State: AFqh2kohpHWFy0GLx7Jmh4dxkHmntU35y4pdopxKP7GT2RmUudZ14rJo
        NCMYE2+Gxjd0QXIrjtqD8g==
X-Google-Smtp-Source: AMrXdXvYJf+z/GCGsV83lx/DXHjvlzPzNIkqiGIuUFvGxOWsVkR8TZE/uSew4HVg6edu2fGLetoXfg==
X-Received: by 2002:a17:902:930b:b0:185:441e:2240 with SMTP id bc11-20020a170902930b00b00185441e2240mr12320112plb.59.1671866154104;
        Fri, 23 Dec 2022 23:15:54 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:53 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 6/6] libbpf: fix invalid return address register in s390
Date:   Sat, 24 Dec 2022 16:15:27 +0900
Message-Id: <20221224071527.2292-7-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221224071527.2292-1-danieltimlee@gmail.com>
References: <20221224071527.2292-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently an invalid register mapping in the s390 return
address register. As the manual[1] states, the return address can be
found at r14. In bpf_tracing.h, the s390 registers were named
gprs(general purpose registers). This commit fixes the problem by
correcting the mistyped mapping.

[1]: https://uclibc.org/docs/psABI-s390x.pdf#page=14

Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 2972dc25ff72..9c1b1689068d 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -137,7 +137,7 @@ struct pt_regs___s390 {
 #define __PT_PARM3_REG gprs[4]
 #define __PT_PARM4_REG gprs[5]
 #define __PT_PARM5_REG gprs[6]
-#define __PT_RET_REG grps[14]
+#define __PT_RET_REG gprs[14]
 #define __PT_FP_REG gprs[11]	/* Works only with CONFIG_FRAME_POINTER */
 #define __PT_RC_REG gprs[2]
 #define __PT_SP_REG gprs[15]
-- 
2.34.1

