Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96883BC49E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 03:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhGFBi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 21:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhGFBi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 21:38:27 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F290C06175F;
        Mon,  5 Jul 2021 18:35:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oj10-20020a17090b4d8ab0290172f77377ebso82425pjb.0;
        Mon, 05 Jul 2021 18:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EkHzJYg4aiSZ7PwP7OO3CqIBv9kFMsbKjd1eVH502Gs=;
        b=vVdSAmUekAinM1YQD5T7wFBbxnofU8FXTV+HrfNtNGMId9GFhugC0Tz8wIBkgdiOzW
         Z3BYwsEOXlanohwfRvRnTH05OQVR9mig1ibnCmDs9pg4z+lm73wBkgNzY8Rw2ACtB3Yu
         0uzjkvUggu4JGqEY+monPF0JQ0DPCTNwy5mQVwOXhtRlWsdfECgLB1DbWJa4bKjU5g3g
         ISNh/Fp7FhAbMEjhPrGV5Es59FW6JI0XQLK6jTuoVHxTB1dHhLO6Rpv0zVAJJVwbwlaJ
         Gq+I1SEyO4X9a+q6z0nZIrSsrtAI6SwgIsrNz+KxT6tIhyz7CSDdk211/wbkPTGMJ+dA
         +ETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EkHzJYg4aiSZ7PwP7OO3CqIBv9kFMsbKjd1eVH502Gs=;
        b=KF7aKt60JzFAy4OmKdsB5hbC8uqoS7Q4eHBxBzGAPcG7RIeHoNNieCetlbvHcVCG7s
         Y6RlsXKhOtcNOQfvNHVd4y7YNlKrZhUb5zfpH80E/C7oZI5TU7hMSDgV/ijJtTTWjjOn
         ta/y1HD+x7d4o9sVSvi6LSURBaQqnWOr2Fvwx5lwcoYIwkB2095b6cswgtohwSec+qDO
         nHC5JK8zEPyHhvAI0QIEWVVEpW1oy2z48A591gTEh+WEfTn36ce82a+BU+TyS2a2uHep
         mEwrHZp+0vxtfkKMVPK8TIk3B2JBWuUDQGtte5yPQDR4Egs4F4GEUwg6TZXCnOO/a/5q
         u7Lw==
X-Gm-Message-State: AOAM533kttF2DwekLKHc3kQ64/mcMCF8sl/WR3QxQdfSjmTWK3twT2bV
        saqGSNGCH7WZjnjjMzcmsio=
X-Google-Smtp-Source: ABdhPJzf/UYDNE+1Nlc+E73Zjk8TgdJfa/T0m1Zycipk7qYx+02TFSQSFf8HrRBRXkwIu+lqBH9n8w==
X-Received: by 2002:a17:90b:14a:: with SMTP id em10mr18247534pjb.154.1625535348907;
        Mon, 05 Jul 2021 18:35:48 -0700 (PDT)
Received: from ubuntu.localdomain ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id m24sm9338851pgd.60.2021.07.05.18.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 18:35:48 -0700 (PDT)
From:   Gu Shengxian <gushengxian507419@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gu Shengxian <gushengxian@yulong.com>
Subject: [PATCH v3] tools: bpftool: close va_list 'ap' by va_end()
Date:   Mon,  5 Jul 2021 18:35:43 -0700
Message-Id: <20210706013543.671114-1-gushengxian507419@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gu Shengxian <gushengxian@yulong.com>

va_list 'ap' was opened but not closed by va_end(). It should be
closed by va_end() before return.

According to suggestion of Daniel Borkmann <daniel@iogearbox.net>.
Signed-off-by: Gu Shengxian <gushengxian@yulong.com>
---
 tools/bpf/bpftool/jit_disasm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index e7e7eee9f172..24734f2249d6 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -43,11 +43,13 @@ static int fprintf_json(void *out, const char *fmt, ...)
 {
 	va_list ap;
 	char *s;
+	int err;
 
 	va_start(ap, fmt);
-	if (vasprintf(&s, fmt, ap) < 0)
-		return -1;
+	err = vasprintf(&s, fmt, ap);
 	va_end(ap);
+	if (err < 0)
+		return -1;
 
 	if (!oper_count) {
 		int i;
-- 
2.25.1

