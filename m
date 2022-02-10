Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1F4B0B26
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiBJKmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:42:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbiBJKmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:42:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0A1FD5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:42:47 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p24so14255376ejo.1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8MCTtOQQV5S6DRMIgEdzgH7o7Z0XnR5RLccuHTb4Jd8=;
        b=gWyubEMGWUUvIAC7z68ajkZ6Xihr4AsIHu6xju9v4oYuVJCsJKCXyekm8KsXH3fvNq
         UFymnJUcPSWtm1JiIRi1zAMKehNt34R40m9zWyx3KdLe6E7bIIEjOTAG3OxMwTKTS/rn
         zdHiUXyEDvysswJIC932CQFn7HGx9rRJj/DuzYY1ElPGv4ZS+8hpKBnpMIUxsL+goFcU
         ryWkYPbN8PahHCrgb6RLL3cHsvIf+0Q8Q0jX1mSsiXHWKwG1/Nb0nToSiuCMBla/dxgL
         O1bJd+no8NIObLgL8OYJhtJFSbBTz9EMa3FBUfhlpOLWgOJhNIFZsAqZ8/BRSEPSWlrV
         jFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8MCTtOQQV5S6DRMIgEdzgH7o7Z0XnR5RLccuHTb4Jd8=;
        b=xHRgJVnU+hVEnZBk8IWnE95ZXCk1YQY1Rhmiv+CfeCcEducVWAPs5FOUe/J9HeFPqd
         81bpDczyDGdHDQnORX7De91T834WiR/ITmhwYaatjr7Qh+AtM4YMF7kJhTNvSaOWhzcT
         CraA4Y5C8cERC6NapPMk74RXEozNF1QgAQTccBGqSCK27+v9LZa16g7N/8drU8Bz4iKW
         tsRgPdgVADEXJtq7f5q2jvhcxVIBUbEh87Kc7vALggHgbuMZVPzof/0V5YipGbSYpjbz
         zP6LZd6e7UT/tJieOiiMOqNRXg24T9jatVPZ/zhLC1zjdkw//TtFrVp2HN0j9H/kMAPo
         Ddug==
X-Gm-Message-State: AOAM531wgZvYCDHyWGPn8L4w3PfjV8UQUnWXi0TEPPrIkddCAQmFVgL/
        l1/H1vLpB+XCbODXrgltHF/43dSnAP5R4A==
X-Google-Smtp-Source: ABdhPJxPkrM+QC2tTR24vJqSQD+T2vvto+GAgPJ+sx8ODa60OYdYBNOTX2GrDV9HxKgdP49YLrI6QQ==
X-Received: by 2002:a17:906:149a:: with SMTP id x26mr5723043ejc.103.1644489766140;
        Thu, 10 Feb 2022 02:42:46 -0800 (PST)
Received: from localhost.localdomain ([149.86.70.238])
        by smtp.gmail.com with ESMTPSA id w8sm6111839ejo.18.2022.02.10.02.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 02:42:45 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 1/2] bpftool: Add libbpf's version number to "bpftool version" output
Date:   Thu, 10 Feb 2022 10:42:36 +0000
Message-Id: <20220210104237.11649-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210104237.11649-1-quentin@isovalent.com>
References: <20220210104237.11649-1-quentin@isovalent.com>
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

To help users check what version of libbpf is being used with bpftool,
print the number along with bpftool's own version number.

Output:

    $ ./bpftool version
    ./bpftool v5.16.0
    using libbpf v0.7
    features: libbfd, libbpf_strict, skeletons

    $ ./bpftool version --json --pretty
    {
        "version": "5.16.0",
        "libbpf_version": "0.7",
        "features": {
            "libbfd": true,
            "libbpf_strict": true,
            "skeletons": true
        }
    }

Note that libbpf does not expose its patch number.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/common_options.rst | 13 +++++++------
 tools/bpf/bpftool/main.c                           |  4 ++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
index 908487b9c2ad..4107a586b68b 100644
--- a/tools/bpf/bpftool/Documentation/common_options.rst
+++ b/tools/bpf/bpftool/Documentation/common_options.rst
@@ -4,12 +4,13 @@
 	  Print short help message (similar to **bpftool help**).
 
 -V, --version
-	  Print version number (similar to **bpftool version**), and optional
-	  features that were included when bpftool was compiled. Optional
-	  features include linking against libbfd to provide the disassembler
-	  for JIT-ted programs (**bpftool prog dump jited**) and usage of BPF
-	  skeletons (some features like **bpftool prog profile** or showing
-	  pids associated to BPF objects may rely on it).
+	  Print bpftool's version number (similar to **bpftool version**), the
+	  number of the libbpf version in use, and optional features that were
+	  included when bpftool was compiled. Optional features include linking
+	  against libbfd to provide the disassembler for JIT-ted programs
+	  (**bpftool prog dump jited**) and usage of BPF skeletons (some
+	  features like **bpftool prog profile** or showing pids associated to
+	  BPF objects may rely on it).
 
 -j, --json
 	  Generate JSON output. For commands that cannot produce JSON, this
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 490f7bd54e4c..0f2f8de514a4 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -89,6 +89,9 @@ static int do_version(int argc, char **argv)
 
 		jsonw_name(json_wtr, "version");
 		jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
+		jsonw_name(json_wtr, "libbpf_version");
+		jsonw_printf(json_wtr, "\"%d.%d\"",
+			     libbpf_major_version(), libbpf_minor_version());
 
 		jsonw_name(json_wtr, "features");
 		jsonw_start_object(json_wtr);	/* features */
@@ -102,6 +105,7 @@ static int do_version(int argc, char **argv)
 		unsigned int nb_features = 0;
 
 		printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
+		printf("using libbpf %s\n", libbpf_version_string());
 		printf("features:");
 		if (has_libbfd) {
 			printf(" libbfd");
-- 
2.32.0

