Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67F744C049
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhKJLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhKJLtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 06:49:25 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A21C061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:38 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u1so3450953wru.13
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P1MDAXqBUvRJAO6xX7CxMMNI+Qac5fxw54rz9pUhfVg=;
        b=Waqi7E8BLBXjAbSCNLrpy/QjzH1mUJi3N0z8KUKzealmkdypPGa1wtdTf8qmF0MmP7
         yOAFklIeu5pkqc9e2svZca+riQZf7/V4NcIYUag+jh7SGHxCV3iH+GlOjG1OETK/oIb+
         gaRCcmgeGBrhxUu6zQScXIy61b3bi/6g+3e2T7gEOSxgwo8oh0uO0Q+hWRgTHTSWVzUl
         X5B7k2smSMFrqIvIk7MzvP0I6NxNllmJur3Qg922yFLPpImmMsfrZWwDRnoWDXVBilgL
         IiCQyANraaB9poiQdtl0wDsrKbwhU3iGW2HSdijUer/TCNmmi3kSqNI+tPx/IZVjCgBR
         jJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P1MDAXqBUvRJAO6xX7CxMMNI+Qac5fxw54rz9pUhfVg=;
        b=JP14O3oTdQFc2bUcbbDbQbbnkV4pNYeekd+AdmTCuagMGebwjr2pP7f9b2A2qOi1b2
         nMLGVFsqFvNzgjgqbD0lklqCHOkMrx2rDLaIDpf0pg0XbisWyEyk69hGT/mT3g8C1fod
         jfLuX16q6vohPMjXJKxCGUkJVSiN0w/Y4yLIhqCDvyS24Ql0WW0DJZu3Z2S5+f9k1UO7
         tJWDz0UWUdwc6JKf95eMd6SsKnsKOUBOa9klHyX5sloI+3IMYbpQmP+HgxPZogYBsYhu
         zX+hvF55iKYd0CjLCjO61lV201TCAyG1UAAYi76Sg9elJzrdVv41JAdA4G587DUypob3
         yWyQ==
X-Gm-Message-State: AOAM533pPv5yL09TDlieaIesiOrX2oX4BO/oxUD3VK+1EVP8zNrr0dID
        foOkkLhdRjAWbnrKdriAn8G6lw==
X-Google-Smtp-Source: ABdhPJw5T27/A7hBYtGaWe4tAQY+JwONJqYBBWhWVyo7CT0DHN22IUT0sj3hZH856ktz3z+wMFpfCg==
X-Received: by 2002:adf:fc88:: with SMTP id g8mr19361660wrr.334.1636544796828;
        Wed, 10 Nov 2021 03:46:36 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.190])
        by smtp.gmail.com with ESMTPSA id i15sm6241152wmq.18.2021.11.10.03.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:46:36 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/6] bpftool: Remove inclusion of utilities.mak from Makefiles
Date:   Wed, 10 Nov 2021 11:46:28 +0000
Message-Id: <20211110114632.24537-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110114632.24537-1-quentin@isovalent.com>
References: <20211110114632.24537-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool's Makefile, and the Makefile for its documentation, both include
scripts/utilities.mak, but they use none of the items defined in this
file. Remove the includes.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/Makefile | 1 -
 tools/bpf/bpftool/Makefile               | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index c49487905ceb..f89929c7038d 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../../scripts/Makefile.include
-include ../../../scripts/utilities.mak
 
 INSTALL ?= install
 RM ?= rm -f
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c0c30e56988f..2a846cb92120 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../scripts/Makefile.include
-include ../../scripts/utilities.mak
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-- 
2.32.0

