Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E874AD823
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 13:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346855AbiBHMHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 07:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347519AbiBHMG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:06:57 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAAFC03FECA
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:06:56 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id k25so51182967ejp.5
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 04:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iTdMXnmtGPLZRSvlL1IcNtJZpPvHU3gWUTLzYfE+SxE=;
        b=SAYY6wGOIVD0AIl6XkKbe6OEJ1zPsZEZ4paudU5iBURPJ5YLioi9K3UQxb3qp0aSAn
         U31d/hQTPa0wjQt7YkxNG2KtRAOYzB3GFkNJYy8F5atoQ6ncMfduXadUU+N8+4LnjfPs
         tbXZrMnyohTJQmA3frAxExswKsA+5wJ90T32qFTbaWBUJHisP1Fl0gB5t7hiHyWa7KU8
         8UOvrPuc5+/qdtJOnnP+AzX2TanFV5xC8JXFg3tNG6rWkHY1Iayhjej8ZQZSsEAalgGy
         Z2x1hm62Itp65O4S0KM51QV/yDyi+w7vn0+JFnwljzgtSlQqJFDPYUKsU+TEFeXfHQZt
         kOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTdMXnmtGPLZRSvlL1IcNtJZpPvHU3gWUTLzYfE+SxE=;
        b=aGAElPhbOLvpyGySfllloF6jzYNBIMZL6TGCcfYhEWcRiD6p0ujwtvO56OwiWH+JmT
         a6I5dXAIYrTuGN6OtkFsSz9GI4DX6tHWJnrHwNu7XjlfUcqvCZ1dAcRdEiFWYlq8njFO
         O7vkVH2thkdNFaioFp/xcihrUMrPMhl58jogDd1KaiILQgHFBM29nuBEFd9LHAxpNA88
         0Ybo69QAOyrHz85sztgyfbejRSgqecW3CpgD14KChHwbUnoCKXVgPgDd6w8PbZ7kpPIe
         FGSakcFhJTW7B1sC3LyApUqgM5e/Zq2QL4AGluumBQLCQ1GHzhAd1buXws4deaPAD5nI
         TAmQ==
X-Gm-Message-State: AOAM533c16OMmdUUhL3r4PxiB1gNSCAvHMzQ3rQOPZfZqs0Nq9S6rrJW
        kXDNv3tMpLJEcpIdYYZ/e3KJ12dQQpcZkg==
X-Google-Smtp-Source: ABdhPJwMsCI2qbWp1E5WT/ejbpHBceAKMrBZ23qpp1k9dfTOiIX3ekzZv1JnbNt8pXkn5EDuyLUUBg==
X-Received: by 2002:a17:907:62a9:: with SMTP id nd41mr3471216ejc.50.1644322015107;
        Tue, 08 Feb 2022 04:06:55 -0800 (PST)
Received: from localhost.localdomain ([149.86.77.242])
        by smtp.gmail.com with ESMTPSA id m17sm5567351edr.62.2022.02.08.04.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 04:06:54 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 2/3] libbpf: Add "libbpversion" make target to print version
Date:   Tue,  8 Feb 2022 12:06:47 +0000
Message-Id: <20220208120648.49169-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220208120648.49169-1-quentin@isovalent.com>
References: <20220208120648.49169-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a target to libbpf's Makefile to print its version number, in a
similar way to what running "make kernelversion" at the root of the
repository does.

This is to avoid re-implementing the parsing of the libbpf.map file in
case some other tools want to extract the version of the libbpf sources
they are using.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index b8b37fe76006..91136623edf9 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -108,6 +108,9 @@ MAKEOVERRIDES=
 
 all:
 
+libbpfversion:
+	@echo $(LIBBPF_VERSION)
+
 export srctree OUTPUT CC LD CFLAGS V
 include $(srctree)/tools/build/Makefile.include
 
-- 
2.32.0

