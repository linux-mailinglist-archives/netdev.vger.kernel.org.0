Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1356026DAEE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgIQL7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 07:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgIQL7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 07:59:42 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2801C06174A;
        Thu, 17 Sep 2020 04:59:12 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id e4so995562pln.10;
        Thu, 17 Sep 2020 04:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q1DbrMjO4BZTE2w6KtdCZfCvUgYWfaaS/EcGaSNvftk=;
        b=AG3mqd+PZ3EUP9hCgxSrUGiqdasTPXZq+38FoV3DB6xUgG4DkY517BUrCIFaJ4CeIZ
         Sd9vc8Jf3YzE2ojKC2hFFHHpX462QsZZp4TcsQHVOzmk4Vdd0o4tMBEelSBC+WhamuCe
         bpg2a4/2lXxtePK52Tu2f7aDv7unHjGv7y/WrB/PeHiLEC0y0EhCIwnuJcBfPJ/Fr0RU
         fZ4ENayEZ9XR0pw6NiB1wI0wPM4Ke1A6hBw5P2Bns2LjS63sURDUaoaRfDNWXmTq96hg
         7pPy35QmhiYrHxuegU4tGnwDiyhCd2V4VGjcA1ldnS38VguNTjlbE2h1XbHZsHURqy7/
         I5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q1DbrMjO4BZTE2w6KtdCZfCvUgYWfaaS/EcGaSNvftk=;
        b=QMZlj31DtfGHH2VDSdsfXZc6Vti93x0FMJOi0iQhAk9Hc/FI6EWnGJsMd27h8dRQHe
         e34WNKV8DC6RTIlKtHLiT0uHodhQGa8DIPNLmTXaugIraeLuFbX8I9aFO9D+4TD9/8Bj
         /30gthF1c6qZOgGLp8jCGQjQz0s/EaNshKD3qxtENVxbk9riB+z0cE4LHo0JBgQkpBLX
         0VrezcqCJJiu/IZ3m7MkZ1ohHPoEEu9+BE0bd9Yvf4KMw7GbLw7HckL7qb+ObSBkp2mI
         1nCNV5+Jt6fxoKvTcHZSF2Hd9yg8RwIuL/d4LQHdIHZSnUVCcUrmGiw8HBvVeuiu+8It
         2rRQ==
X-Gm-Message-State: AOAM533vZbyaMe0BF+7Djsixz5OgHfyFMlofivCHSWz3bPv7SK7Qxybu
        r8uClowUGA1QjP7bBUk/XNc=
X-Google-Smtp-Source: ABdhPJxYoAErNWLu/+EOG22+4+znyLSZAfuYFGEVx8OEJZc2MTtiYOHWwnRhm0kjBZzrsecFnfD2/A==
X-Received: by 2002:a17:90b:4b0b:: with SMTP id lx11mr8156340pjb.104.1600343952529;
        Thu, 17 Sep 2020 04:59:12 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:6ca9:b613:f248:49fa])
        by smtp.gmail.com with ESMTPSA id w19sm21156376pfq.60.2020.09.17.04.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 04:59:12 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v1] tools/bpftool: support passing BPFTOOL_VERSION to make
Date:   Thu, 17 Sep 2020 04:58:33 -0700
Message-Id: <20200917115833.1235518-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change facilitates out-of-tree builds, packaging, and versioning for
test and debug purposes. Defining BPFTOOL_VERSION allows self-contained
builds within the tools tree, since it avoids use of the 'kernelversion'
target in the top-level makefile, which would otherwise pull in several
other includes from outside the tools tree.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 8462690a039b..4828913703b6 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -25,7 +25,7 @@ endif
 
 LIBBPF = $(LIBBPF_PATH)libbpf.a
 
-BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
+BPFTOOL_VERSION ?= $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 
 $(LIBBPF): FORCE
 	$(if $(LIBBPF_OUTPUT),@mkdir -p $(LIBBPF_OUTPUT))
-- 
2.25.1

