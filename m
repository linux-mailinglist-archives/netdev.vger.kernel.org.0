Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4003B9169
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhGAMDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhGAMDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:03:06 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25520C061756;
        Thu,  1 Jul 2021 05:00:36 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o18so5219153pgu.10;
        Thu, 01 Jul 2021 05:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ccXf4NSKmr2F5OxqDILkQbJWitWryrP323WTdT3fg0=;
        b=aQdryLRllPcxLoSP4L05eHImlsMtM1VW/JctbqRPDQkezjFHjV3+pMNvrKufOKrFYf
         pzFtopDBNg1NH3yffNpxpCJo7d4dw/IPPIGkPhbXrRoE1pEE7n4U0ZN9GIAU4m9wSmZf
         JmEBDofnp7t1+imApVctqplJnFpzZrYyE6LCg0dh4azhPsZy4RLkhGkcFpPuNIY3rp8g
         ijATBBTHt9bF+zEzMdROyN8Hicm61CGl0rCaJqol1dVE9jtbTTn65SbgRUjKGi1eGWCv
         9C4J1XAyhhQ8shda1RCrGb6nEDrBvlxmZ2sAAsHh5X8kk5Z2VR3SisYnjGkiIUNG7Kd9
         gUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ccXf4NSKmr2F5OxqDILkQbJWitWryrP323WTdT3fg0=;
        b=rrVTRuqbEwOqVqQFvBjmpAHA1RK0kC+pD7duGJ2c5ArgcTm80gszFVdxc3jLJ+BEhh
         Qlgd4LT6RuipIR6ErFWuiaT6r0NjNpyTbqiCir8LedSFa18J7lJZYRzbiS/OdZHR2dQ0
         IujZ7VNBmafoi1Xw+usQav77+RHsQ0vUuEVvT20kEVx6xCogLnZXed8pkXrYFh2rgDXY
         5cu9dsn24S1EhY4Y7YTo8RhMvVLrdP4LYy67EoJbE0owbdnkamJ3GNl+k+pYyskAuISL
         olzX7G6g/SpKkUKOZ5Mb/JvsXuWLy2PvwLw7aY+o6VKd7GckvLIeKIYpsj7+tROI5gzZ
         iJfg==
X-Gm-Message-State: AOAM533U//TRcWM3L34Nnruv9MnF2eHlJOjdk/Jg/ybZPYLHxv5MPALl
        0+h0O37A/PT0FHEdEtkLOls=
X-Google-Smtp-Source: ABdhPJxS10y8pI4F0CF1sTYadittND67kThOJjvtVX+1qjjKh0iHAY/MvfSyvkZCCbkzBnIn3CpaRQ==
X-Received: by 2002:aa7:83d9:0:b029:2eb:b0ef:2a67 with SMTP id j25-20020aa783d90000b02902ebb0ef2a67mr41641267pfn.1.1625140835706;
        Thu, 01 Jul 2021 05:00:35 -0700 (PDT)
Received: from ubuntu.localdomain ([218.17.89.92])
        by smtp.gmail.com with ESMTPSA id j20sm24021860pfc.85.2021.07.01.05.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 05:00:35 -0700 (PDT)
From:   gushengxian <gushengxian507419@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] tools: bpftool: close va_list 'ap' by va_end()
Date:   Thu,  1 Jul 2021 05:00:26 -0700
Message-Id: <20210701120026.709862-1-gushengxian507419@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

va_list 'ap' was opened but not closed by va_end(). It should be
closed by va_end() before return.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 tools/bpf/bpftool/jit_disasm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index e7e7eee9f172..3c85fd1f00cb 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -45,8 +45,10 @@ static int fprintf_json(void *out, const char *fmt, ...)
 	char *s;
 
 	va_start(ap, fmt);
-	if (vasprintf(&s, fmt, ap) < 0)
+	if (vasprintf(&s, fmt, ap) < 0) {
+		va_end(ap);
 		return -1;
+	}
 	va_end(ap);
 
 	if (!oper_count) {
-- 
2.25.1

