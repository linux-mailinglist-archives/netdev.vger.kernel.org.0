Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF43A25FFE8
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgIGQlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731015AbgIGQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:40:25 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF6CC061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:40:23 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id a65so14886922wme.5
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8wCFuJU0Og2ORXiyJtRFP7tNYq0Nqq6buOkhSo/qnU=;
        b=tFC8ebq1Igo6X1/lUQDrP/oRFNwnslRG5ImFqF9wTFCMMSUKhmtiykxfLpNKZdNs7G
         C10Tm0UO94ZolKIs07XKREWA+lyv6lQkKA28E3HOYEfkATEoTyRN87M1r8nWqu9MZUaX
         ym8IfpMsIIBs8+iDbZ/WN3UfoQ1wpCw6Akfbub/H4XEfFWjnH463ZSJT7UcZj+Nu7uIq
         OB4PkxkbQuVjLzyiATlmepfdL1x4MabwcQwKlxlIv5Bi7Nva4pIyoEzNkE6TPnu41Wih
         gPQCy7KTd7RCt380YeV5ks7c8J22P85L4rV6QUJg6A4yF1qhHsWL0lechaocV79HqxMu
         dq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8wCFuJU0Og2ORXiyJtRFP7tNYq0Nqq6buOkhSo/qnU=;
        b=cdZ/x1BOhzDZ1YY9xHO2PmXdaEMlneeAQhHYoOIDc7S0DNzFLLIVHZaW/QSrOnWGGJ
         mwGn2mvHp+zBI+fk2ZR+l4XgA1/w9LzyPeHfJUk1f7t6FkH0wA/ABPTZTXUrdDc1BALD
         nw0ZGISVD6SnNivSkAlP0TCK2oYrk2RunU6h7tXd8ijPchzCMG0EvwcvVU4giEi+jqnr
         iA3O6niGS8xP3kx3dY+12PFgaD1vgYoAJ93465aD0KjNDG+YF+sCi8ndA9IFtOoLSK6w
         oQRIDfKIqw71EvIzTN/lfneQ6JJAeLw1p1gOyM1tAEae2n9XbPpfGhFVwaF7Xd7aSsMZ
         nTwg==
X-Gm-Message-State: AOAM531Utn76EuuHrvF1hgfNHsy+iKkV8mIcR4v0sAvFPxloIvHNC7LU
        7eqlZ9hf4JbzS8Mdnd9D8du5AyhHBgGOlH0i
X-Google-Smtp-Source: ABdhPJwErNckX12lW8vfabhGZNcDE0Ix0dGRrtXPvdbluPRU4j4HJ5FQIMqfX9rwlE4TaMhnfuP/4Q==
X-Received: by 2002:a1c:2903:: with SMTP id p3mr183752wmp.170.1599496821731;
        Mon, 07 Sep 2020 09:40:21 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.187])
        by smtp.gmail.com with ESMTPSA id d2sm9934895wro.34.2020.09.07.09.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:40:21 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] tools: bpftool: log info-level messages when building bpftool man pages
Date:   Mon,  7 Sep 2020 17:40:16 +0100
Message-Id: <20200907164017.30644-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907164017.30644-1-quentin@isovalent.com>
References: <20200907164017.30644-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To build man pages for bpftool (and for eBPF helper functions), rst2man
can log different levels of information. Let's make it log all levels
to keep the RST files clean.

Doing so, rst2man complains about double colons, used for literal
blocks, that look like underlines for section titles. Let's add the
necessary blank lines.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/Makefile        | 2 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst | 3 +++
 tools/bpf/bpftool/Documentation/bpftool-gen.rst | 4 ++++
 tools/bpf/bpftool/Documentation/bpftool-map.rst | 3 +++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index 815ac9804aee..e871f28a5312 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -33,7 +33,7 @@ $(OUTPUT)%.8: %.rst
 ifndef RST2MAN_DEP
 	$(error "rst2man not found, but required to generate man pages")
 endif
-	$(QUIET_GEN)rst2man $< > $@
+	$(QUIET_GEN)rst2man -r 1 $< > $@
 
 clean: helpers-clean
 	$(call QUIET_CLEAN, Documentation)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 896f4c6c2870..864553e62af4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -91,6 +91,7 @@ OPTIONS
 EXAMPLES
 ========
 **# bpftool btf dump id 1226**
+
 ::
 
   [1] PTR '(anon)' type_id=2
@@ -104,6 +105,7 @@ EXAMPLES
 This gives an example of default output for all supported BTF kinds.
 
 **$ cat prog.c**
+
 ::
 
   struct fwd_struct;
@@ -144,6 +146,7 @@ This gives an example of default output for all supported BTF kinds.
   }
 
 **$ bpftool btf dump file prog.o**
+
 ::
 
   [1] PTR '(anon)' type_id=2
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index df85dbd962c0..d52b03a352d7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -146,6 +146,7 @@ OPTIONS
 EXAMPLES
 ========
 **$ cat example.c**
+
 ::
 
   #include <stdbool.h>
@@ -187,6 +188,7 @@ This is example BPF application with two BPF programs and a mix of BPF maps
 and global variables.
 
 **$ bpftool gen skeleton example.o**
+
 ::
 
   /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
@@ -241,6 +243,7 @@ and global variables.
   #endif /* __EXAMPLE_SKEL_H__ */
 
 **$ cat example_user.c**
+
 ::
 
   #include "example.skel.h"
@@ -283,6 +286,7 @@ and global variables.
   }
 
 **# ./example_user**
+
 ::
 
   my_map name: my_map
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 083db6c2fc67..8f187c6416cd 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -182,6 +182,7 @@ OPTIONS
 EXAMPLES
 ========
 **# bpftool map show**
+
 ::
 
   10: hash  name some_map  flags 0x0
@@ -203,6 +204,7 @@ The following three commands are equivalent:
 
 
 **# bpftool map dump id 10**
+
 ::
 
   key: 00 01 02 03  value: 00 01 02 03 04 05 06 07
@@ -210,6 +212,7 @@ The following three commands are equivalent:
   Found 2 elements
 
 **# bpftool map getnext id 10 key 0 1 2 3**
+
 ::
 
   key:
-- 
2.25.1

