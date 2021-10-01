Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC541EB8C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353794AbhJALP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353779AbhJALLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:18 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A42FC0613E5
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:31 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j27so6965304wms.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6qPlM6MAUchBkbCWCD/H91DQxecPf+FzubhRu6ucuSs=;
        b=rLhqDBYADo0gATH024esrjLIO6v4kz2Njm1FM5OFb6ic311kGVTISD76FxNOfhlH5U
         4N0Dh9lBc3wbNCSCi01Gf39Y6j+xsAEqya/Uiz+fWCN+p9p41YVKOZk2mu0y9Q8UIQGj
         7ku2+EDb0RZhnYZtSg6ep9SNLpFRTYfcBjrWCM6DzqL2jNIyfEAws9KRh7ADVevEC7wA
         Zf3CDBlSVAX8S60Lbute8Q5LMYoS05ieZMPE8uNNHmbp7GXR+oDwD0l/s3AB+iZqlBPY
         LbzXOu6rG4Ze67aH/dr0duSumV34/5gJO3GbOeP8OgJ6coJfkzgNrlZIDaPW557X5xG0
         Pqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6qPlM6MAUchBkbCWCD/H91DQxecPf+FzubhRu6ucuSs=;
        b=SficAok0hW42YMokbGzPsnz70iGHUWAPfbOTVE8DzIlvbm0iT0gf0qcCAMjuLutjp4
         2aFHLbYcPDRwW6U67qizIl76OibWJvhqrKgbXIBYQYpc+gK1Pb5nM+dgmC6V7WIikHYO
         uLo/2os6FPVUa9o0bKKvLQfRvtlMp822T7zZNM54T4bR1HwUmE87d0OCSLpuYhZn/Ojk
         YIGSDAKAIYeBVf1WwacKDRU7auVJQgey+kYOFHFkj6iS151DcOrSwVYQPUl0MoZjojDO
         fJX5ggy7Kr4spdu/wS9N3kR9UBR2REfn/0/JM9jMmedsttFPoZ5ONNGL9eV7HcTMRSCY
         P3eA==
X-Gm-Message-State: AOAM532LwFsTfI6cn1o9/RgUR6ft/MkENDOOCrtgQ8UNT40dDH6qiiut
        cxQgiv/l+1bm9BfpqZugLu50CYytpwdaKzqY
X-Google-Smtp-Source: ABdhPJwy+/LZz9UiprvlfvSX72rL4WmZrFEfo85Hi/fvLGC14Sb7muPYWu7R2pd34j/dCs6+v4rB2w==
X-Received: by 2002:a05:600c:510a:: with SMTP id o10mr3737710wms.81.1633086569927;
        Fri, 01 Oct 2021 04:09:29 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:29 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 9/9] selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
Date:   Fri,  1 Oct 2021 12:08:56 +0100
Message-Id: <20211001110856.14730-10-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The script test_bpftool_build.sh attempts to build bpftool in the
various supported ways, to make sure nothing breaks.

One of those ways is to run "make tools/bpf" from the root of the kernel
repository. This command builds bpftool, along with the other tools
under tools/bpf, and runqslower in particular. After running the
command and upon a successful bpftool build, the script attempts to
cleanup the generated objects. However, after building with this target
and in the case of runqslower, the files are not cleaned up as expected.

This is because the "tools/bpf" target sets $(OUTPUT) to
.../tools/bpf/runqslower/ when building the tool, causing the object
files to be placed directly under the runqslower directory. But when
running "cd tools/bpf; make clean", the value for $(OUTPUT) is set to
".output" (relative to the runqslower directory) by runqslower's
Makefile, and this is where the Makefile looks for files to clean up.

We cannot easily fix in the root Makefile (where "tools/bpf" is defined)
or in tools/scripts/Makefile.include (setting $(OUTPUT)), where changing
the way the output variables are passed would likely have consequences
elsewhere. We could change runqslower's Makefile to build in the
repository instead of in a dedicated ".output/", but doing so just to
accommodate a test script doesn't sound great. Instead, let's just make
sure that we clean up runqslower properly by adding the correct command
to the script.

This will attempt to clean runqslower twice: the first try with command
"cd tools/bpf; make clean" will search for tools/bpf/runqslower/.output
and fail to clean it (but will still clean the other tools, in
particular bpftool), the second one (added in this commit) sets the
$(OUTPUT) variable like for building with the "tool/bpf" target and
should succeed.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/testing/selftests/bpf/test_bpftool_build.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index b03a87571592..1453a53ed547 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -90,6 +90,10 @@ echo -e "... through kbuild\n"
 
 if [ -f ".config" ] ; then
 	make_and_clean tools/bpf
+	## "make tools/bpf" sets $(OUTPUT) to ...tools/bpf/runqslower for
+	## runqslower, but the default (used for the "clean" target) is .output.
+	## Let's make sure we clean runqslower's directory properly.
+	make -C tools/bpf/runqslower OUTPUT=${KDIR_ROOT_DIR}/tools/bpf/runqslower/ clean
 
 	## $OUTPUT is overwritten in kbuild Makefile, and thus cannot be passed
 	## down from toplevel Makefile to bpftool's Makefile.
-- 
2.30.2

