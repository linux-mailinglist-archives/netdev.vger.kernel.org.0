Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF402B82B2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgKRRIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:08:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727955AbgKRRIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:08:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gjbadWafB5PZQdFuOO+0yOJJiXeAj0y04FweE/Zx/1U=;
        b=CJ08ll/of3XOOTa2BuMpIjXmUF2UkrI4Qzz6jJ4athW50NdY+x+Mge+ZuvqVIySorEUT1w
        HgUaeeg3la36TGLRB+w20GtimQSb7zh65bF4vJBvyxCq3fYycofFyaxmnkd73aoeoZcyoq
        NiR4vD7x1Ls5ABLHgRFgEgaHCCzEZkU=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-bG-M0o3kMk-_49WeCf8ymA-1; Wed, 18 Nov 2020 12:08:36 -0500
X-MC-Unique: bG-M0o3kMk-_49WeCf8ymA-1
Received: by mail-oo1-f70.google.com with SMTP id o7so1054429oom.13
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 09:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gjbadWafB5PZQdFuOO+0yOJJiXeAj0y04FweE/Zx/1U=;
        b=uFsMAOqw882bORn0ddjy5A5myaSn4JXiZVgu+LJzhBmIqfSnQ3AqouZHkcfq5AkRxt
         ZPnRVVp0cIbNEksDfhyOTpT+Fl6r4Eaqq+4bUOu0UXGO2nxZI5RehOA32es4iOOeL6Vx
         AIBlQU32ru/hivnZfkiJ0BPl/Z9TS3fOfUSVnnzkF7erSIlQlSg/FkqChdXMpYgwZ282
         uXWMOtfwmdzb6d7YMDfn8HjlWuEtqfPm9EDxkILHj77KF8Z4GrEULAECgh73drSoq598
         CnngM4qnbyFfw/83mRWD+IkzuqbpsmEQQSa7ofJzS+FMygkhybDO/mvB4uMPPduy1mNF
         z5zA==
X-Gm-Message-State: AOAM5308cvpY4Oc6BfPlBxFsJNVvR2qzysq3s8Cy4fuLb656j+MM7AFH
        mm1fqswe06zbX0KQDQadhxQ3y0pjwJMHoCqU7FJa4PILBAkmsUyf2Pc0/G4WNLyb3xQ4lWynBVM
        E6jXVW8P/LjcsAMxg
X-Received: by 2002:a05:6830:1e6f:: with SMTP id m15mr7041129otr.253.1605719315696;
        Wed, 18 Nov 2020 09:08:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTNImudshm4tcifGUoGWaxSb3c/nS2C4avfNqpMXAgIx4m3U4qu/tQSyD025QgxR0n79WQ3Q==
X-Received: by 2002:a05:6830:1e6f:: with SMTP id m15mr7041096otr.253.1605719315388;
        Wed, 18 Nov 2020 09:08:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m65sm7624239otm.40.2020.11.18.09.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 09:08:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 34FF71833E0; Wed, 18 Nov 2020 18:08:32 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com, andrii@kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        haliu@redhat.com, dsahern@gmail.com, jbenc@redhat.com
Subject: [PATCH bpf-next] libbpf: Add libbpf_version() function to get library version at runtime
Date:   Wed, 18 Nov 2020 18:07:38 +0100
Message-Id: <20201118170738.324226-1-toke@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a response to patches adding libbpf support to iproute2, an extensive
discussion ensued about libbpf version visibility and enforcement in tools
using the library[0]. In particular, two problems came to light:

1. If a tool is statically linked against libbpf, there is no way for a user
   to discover which version of libbpf the tool is using, unless the tool
   takes particular care to embed the library version at build time and print
   it.

2. If a tool is dynamically linked against libbpf, but doesn't use any
   symbols from the latest library version, the library version used at
   runtime can be older than the one used at compile time, and the
   application has no way to verify the version at runtime.

To make progress on resolving this, let's add a libbpf_version() function that
will simply return a version string which is embedded into the library at
compile time. This makes it possible for applications to unambiguously get the
library version at runtime, resolving (2.) above, and as an added bonus makes it
easy for applications to print the library version, which should help with (1.).

[0] https://lore.kernel.org/bpf/20201109070802.3638167-1-haliu@redhat.com/T/#t

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/Makefile   |  1 +
 tools/lib/bpf/libbpf.c   | 12 ++++++++++++
 tools/lib/bpf/libbpf.h   |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 15 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 5f9abed3e226..c9999e09a0c8 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -107,6 +107,7 @@ override CFLAGS += -Werror -Wall
 override CFLAGS += $(INCLUDES)
 override CFLAGS += -fvisibility=hidden
 override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+override CFLAGS += -DLIBBPF_VERSION="$(LIBBPF_VERSION)"
 
 # flags specific for shared library
 SHLIB_FLAGS := -DSHARED -fPIC
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 313034117070..dc7bb3001fa6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -136,6 +136,18 @@ static void pr_perm_msg(int err)
 
 #define STRERR_BUFSIZE  128
 
+#ifndef LIBBPF_VERSION
+#define LIBBPF_VERSION unset
+#endif
+#define __str(s) #s
+#define _str(s) __str(s)
+static const char *_libbpf_version = _str(LIBBPF_VERSION);
+
+const char *libbpf_version(void)
+{
+	return _libbpf_version;
+}
+
 /* Copied from tools/perf/util/util.h */
 #ifndef zfree
 # define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6909ee81113a..d8256bc1e02e 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -45,6 +45,7 @@ enum libbpf_errno {
 };
 
 LIBBPF_API int libbpf_strerror(int err, char *buf, size_t size);
+LIBBPF_API const char *libbpf_version(void);
 
 enum libbpf_print_level {
         LIBBPF_WARN,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 29ff4807b909..5f931bf1b5b0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -345,4 +345,5 @@ LIBBPF_0.3.0 {
 		btf__parse_split;
 		btf__new_empty_split;
 		btf__new_split;
+                libbpf_version;
 } LIBBPF_0.2.0;
-- 
2.29.2

