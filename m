Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C372032208C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhBVUAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhBVT77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:59:59 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3DFC061786;
        Mon, 22 Feb 2021 11:59:18 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id d20so15239008oiw.10;
        Mon, 22 Feb 2021 11:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SXqUvT54kKjdOxFJnOi4gZFO6SdTpDHa17+Fn5lo0U=;
        b=LZPoH317/hr87yT8xRI+td91z9dl9JTs/1QMi7nZK6YcYMGcVeOmBdYG32a23jsovz
         FPXFlJCFQtFOV0hGqUGgnjWWJT2OoMtRFaKwjx6SZk9UPs9KTjHM8ixmwOzBqZcD2W7+
         LEXsl30CKw3/H3SpiEtdnmquQ/RRKbZcP/gdE7uWS0epTOdQ7JELV9xSUYN6T1Pbyxy0
         QDKewP2g/POsT4mkbCQY/WbiS1EMHmcqlfA/vHd5Lsqog9TPe02y+v8G5sQGCCLO3MT8
         It7L6QeKmawk2dA1XmRiyH6UmRFaBrVY4RxAU1wvlTB+MTLGbWnfzbk3Bu9NOKX0GaV/
         QdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SXqUvT54kKjdOxFJnOi4gZFO6SdTpDHa17+Fn5lo0U=;
        b=UAwz2NZjDCAVqbjXRFmz0JlOcjwR+yn4FnejHxmHEq6Dd7GPpbsuW3CHqUO76EMRrm
         9aD0EaoiyN0s1xKOQkpCH45N8j3Pb4gZI8wExEf16PiBUfcPFr4ccyVzG4rgHF3/6/b5
         dWzJ15CGgyAO6euB+jmHDAMfd5JJjOEAXAnSeOcebvRs9yjCOz9VJOo4/Gv5953TG5C1
         0qDSAFXwbF/9Kl7Nu13qwLg59lfDr/xkTPVQPSiHQIKbiEXlpnXtt8FaeGEHtVEyYp95
         ovO10t3tkMSMabonqAmzg9qKLRNvrrpnS3h+mWJG/Ff7lDcgNC8BOuICbMHgLZEq3Y3K
         zRUw==
X-Gm-Message-State: AOAM530oYPAqTDsjUGS8+Hh5De+BjUROucZ+fepSBzPeUrDewVRHnsE1
        mnHJlAmXYY4dOIw/rlVADiA=
X-Google-Smtp-Source: ABdhPJxgJAuYqifanP+GwLE3YkSVhdbLIBybVwR2qHPxCThBCmFod8a/r/bdYvtI9ykk3yiCCEqfiQ==
X-Received: by 2002:a05:6808:f0c:: with SMTP id m12mr10695128oiw.95.1614023958187;
        Mon, 22 Feb 2021 11:59:18 -0800 (PST)
Received: from localhost.localdomain (162-198-41-83.lightspeed.wepbfl.sbcglobal.net. [162.198.41.83])
        by smtp.gmail.com with ESMTPSA id b7sm1011190oiy.29.2021.02.22.11.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 11:59:17 -0800 (PST)
From:   grantseltzer <grantseltzer@gmail.com>
To:     andrii@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     irogers@google.com, yhs@fb.com, tklauser@distanz.ch,
        netdev@vger.kernel.org, mrostecki@opensuse.org, ast@kernel.org,
        quentin@isovalent.com, bpf@vger.kernel.org,
        grantseltzer <grantseltzer@gmail.com>
Subject: [PATCH v4 bpf-next] Add CONFIG_DEBUG_INFO_BTF and CONFIG_DEBUG_INFO_BTF_MODULES check to bpftool feature command
Date:   Mon, 22 Feb 2021 19:58:46 +0000
Message-Id: <20210222195846.155483-1-grantseltzer@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds both the CONFIG_DEBUG_INFO_BTF and CONFIG_DEBUG_INFO_BTF_MODULES
kernel compile option to output of the bpftool feature command.
This is relevant for developers that want to account for data structure
definition differences between kernels.

Signed-off-by: Grant Seltzer <grantseltzer@gmail.com>
---
 tools/bpf/bpftool/feature.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 359960a8f..40a88df27 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -336,6 +336,10 @@ static void probe_kernel_image_config(const char *define_prefix)
 		{ "CONFIG_BPF_JIT", },
 		/* Avoid compiling eBPF interpreter (use JIT only) */
 		{ "CONFIG_BPF_JIT_ALWAYS_ON", },
+		/* Kernel BTF debug information available */
+		{ "CONFIG_DEBUG_INFO_BTF", },
+		/* Kernel module BTF debug information available */
+		{ "CONFIG_DEBUG_INFO_BTF_MODULES", },
 
 		/* cgroups */
 		{ "CONFIG_CGROUPS", },
-- 
2.29.2

