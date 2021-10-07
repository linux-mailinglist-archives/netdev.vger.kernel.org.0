Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14DD425C8A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbhJGTrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241533AbhJGTqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16238C061772
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r7so22413464wrc.10
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6qPlM6MAUchBkbCWCD/H91DQxecPf+FzubhRu6ucuSs=;
        b=E7lH7ZBOhfz4M+b4Jdm/w7k5g56Nfu6tsa3xxN4kFlFhY8ChSw9TZLp7Sx0MHjDEUu
         DEVDIn+4IlSmHcoZkqC+sUCxe4VzfJshLbVNESLXKjzYtBHwgKWDBZMSoDsqiWe0jTKZ
         MxPJBlrGGg4ZtpzcCdv210fqCnltZUTuL6VTEqsegb1OI5YqN2vTDum4U+9XHbglQgwh
         vDCQy7htxXFiRMRW46x8zlEQ6XT3vg64EYmsUbKAN4ES3e2GkHMHi/PsWd+xFeJ4Zr0W
         1NripXZX41XqN7IMrNs8DSxYSk/+BWu0piY2KrtJRqOZOTnzpBxz/h4jxwoNBiduG+fh
         UjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6qPlM6MAUchBkbCWCD/H91DQxecPf+FzubhRu6ucuSs=;
        b=FJBjvYAF7dY8kEkkc30EN00/s4CBFHFtREXFgrtwRx33uWtKayFA97nm0ZNQam/98Z
         Nd5PeNzlQy0mXJMBlcHlgwFYHyUHaJnWFPbD0Q1HHF2TC2b5AOrpKzqWw/538WppcKAi
         mv94eRbflarMPeLw1ZSqHOZnF1OBHx01xDPzkq1v45xJxrUV+CwNz7xdFWiePzXBmLqg
         fBGl42ZSOmXuUYeHaBDP/73IbXD4FExKZskVV30pLdUECzYplkMvEDglLlDWuOlb4hBO
         d1pMuvt7F/Ygdj6SK6BuF2Gw/7lDwrP/JN5jGJLXhGuZnt6aXql0jKWA6LD5Nz437zg2
         Xm1A==
X-Gm-Message-State: AOAM533C1sKOUHuP2eq0rt/dzwbT+jO0V5kpfj2sRLzAPiajM8g3CByw
        dUD98IHGm1oY5fP4yFCRGw92dw==
X-Google-Smtp-Source: ABdhPJyltq6V37YskhPRfq3eTYOqRY8HHhmv8rHcb6toRrB3HT22UAeArSzXNX2+k+4KvJ3R586ZxQ==
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr7992741wrs.404.1633635895726;
        Thu, 07 Oct 2021 12:44:55 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:55 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 11/12] selftests/bpf: better clean up for runqslower in test_bpftool_build.sh
Date:   Thu,  7 Oct 2021 20:44:37 +0100
Message-Id: <20211007194438.34443-12-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
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

