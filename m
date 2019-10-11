Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24EFDD3608
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfJKA3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:29:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46733 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbfJKA22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id t8so5684983lfc.13
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X+OYdLBkIYv08X2eKXt3TCPXQ11so0VYCO7f1mswfR4=;
        b=YKc0wBOK5kw1DdbXCuiOee6bbytIkRtP7xcVtvuTLj4UdL6r5TUv6DcZgG/ZDsLP69
         ulWquw4+7tsUAsKSiFy2Cfty4cW+bXLlKps9odJRuCeWnw/lGdGvLR5rkISefH9Phe91
         /CAtfzmy5wtryrSDvREOHdPKvSRLjAPu5s7+k7zxv+jQtm2PN0fja1E8kM5N4INyKxLu
         /Vf7ncX5Q0YaTUYo17CjLST2nR75D+SCZ8tWLmJkPS9ENAAQArYJ0M+MYo6mSMcqEXu7
         Tnhwc+jAV+FrQNEWwOXtNudFWCGl6uLf0ZpPNG8Nqh7N9/l5U6zwHP+DruNqbB9COdF4
         akmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X+OYdLBkIYv08X2eKXt3TCPXQ11so0VYCO7f1mswfR4=;
        b=kQuPbeQg7JWvHkaViv1YheMH+D8yrvA1Cj22DvQOqNjiGfWBiqTiqnRxlk1LdGobqi
         E7JYPkmyHqpnvE6Nl/Owo2EITZkpIlj0EsxCOt5hAFCCbapR8YaGCAeIB0Lx85Xla7Q9
         zUQDDHN5fYyPBq3ZuI8ONuzeey/qfJwNAKzu9FJo00C5z4RcfkWkvhf/G/3ByrAbOokC
         bMvYn6hoonnq2xvGywlXdOn+y0jrtqipBNTpRWtDaYOKA10YOujDe/qPWHqYF2OtA5nc
         zL0EUKahlWc9XZRrakWplMoTvkVvD7ncdR4PvHdIElpOT8EnD6cbow/hjjJSDevhoE83
         xD1A==
X-Gm-Message-State: APjAAAVFNkY/sCuDPXtAE7galSPZo2EEa4niD1i9p72uNUd2FyDC82wR
        yFUF43Jle+QxrZCVdgnEYhtaAA==
X-Google-Smtp-Source: APXvYqzxfrVPEHNBW9hrD6Av/hCkqGzGXRR9boh0fDIihTSKCgluCdKMc7ty+RTqXr4lDuRPE/0FPQ==
X-Received: by 2002:ac2:41d4:: with SMTP id d20mr7390173lfi.24.1570753705056;
        Thu, 10 Oct 2019 17:28:25 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:24 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 03/15] samples/bpf: use --target from cross-compile
Date:   Fri, 11 Oct 2019 03:27:56 +0300
Message-Id: <20191011002808.28206-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For cross compiling the target triple can be inherited from
cross-compile prefix as it's done in CLANG_FLAGS from kernel makefile.
So copy-paste this decision from kernel Makefile.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 045fa43842e6..9c8c9872004d 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -195,7 +195,7 @@ BTF_PAHOLE ?= pahole
 # Detect that we're cross compiling and use the cross compiler
 ifdef CROSS_COMPILE
 HOSTCC = $(CROSS_COMPILE)gcc
-CLANG_ARCH_ARGS = -target $(ARCH)
+CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
 endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
-- 
2.17.1

