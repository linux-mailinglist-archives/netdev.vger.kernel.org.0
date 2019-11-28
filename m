Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AB810CAB2
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 15:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfK1Oxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 09:53:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60389 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726446AbfK1Oxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 09:53:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574952810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSRdu36kdw7cp4aj5uiQyY93zJOiHwsJ9kURwhoRP88=;
        b=OqrDtNi/w4ql95WxW9pAzMfWN2FB4wzJHck8v9lqrjTxFwwDM+RFJfKYdri4YkS5F2PBd2
        +MfdGd3i9yBmjEr88uTAFyH9sieB6Mx9to2GEtrbf77Qu0/GV9qrx4+xWCm1cF014QgeNt
        4FenBwfDlO+oSSvne8SeqPHpUC55ZsY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-BlRz4W30NQG6s5bf8Lw09Q-1; Thu, 28 Nov 2019 09:53:29 -0500
Received: by mail-lj1-f197.google.com with SMTP id v26so1052493ljg.22
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 06:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DFfjqzHfd87DTRbEbayt6s48Ee8N6vIkSod5kqZnQ5Y=;
        b=Ltw6welEA7MWOgiBKUBj+VSo7AOFmF10uUyd+VDrDbyDPSJuJj+R2QpGaxc+Rif8Rh
         cf8Xc+NJPVg71QPJvEAgDR1H0nGErwbJV1/cWbr5hde9/ekgAwHlK/8RhW0ETFYoBkFv
         rnOQ43lig0IXJck789W7rqTJPO4eUBPKn5lbPuUeE34LnhEvvFmNyI1Gal9ierSzRU7k
         KLHAsaoLdGmgRxHrsOw8eYAm92PvV+OJJ5wax0LjKF+m1s3xlfN+np2I5CW/Mrhq2J5B
         jnL6y8MBVyDWhCD9yREOe3pz/C8R6BEn6fo0ky3My3CL0W0d0xPO4CQ2WHArSWfZ9hu3
         1bYQ==
X-Gm-Message-State: APjAAAUNf88NnZIqVtDdnRcvnEtE5DgvTonbUNFmeLMXXgk+h5klrSxD
        gKUoVHatprUolPU+JCN35lR71AENAWr9Z71f2l2u7m62f0sJXWrH88fCTu+CwKwNu+AAdwRCNiW
        JMtmKPuSp6R2wfvjn
X-Received: by 2002:a2e:b007:: with SMTP id y7mr34551269ljk.69.1574952807592;
        Thu, 28 Nov 2019 06:53:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyX6WbETt4gMUWpV0wZ/2Py0Q2dWzIgwkCGxTImfwQqW1dKylmOb5oxrAJ6cM1GAIE8WjpyYQ==
X-Received: by 2002:a2e:b007:: with SMTP id y7mr34551238ljk.69.1574952807282;
        Thu, 28 Nov 2019 06:53:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k10sm8611145lfo.76.2019.11.28.06.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 06:53:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 62FC9180339; Thu, 28 Nov 2019 15:53:24 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH bpf v2] bpftool: Allow to link libbpf dynamically
Date:   Thu, 28 Nov 2019 15:53:16 +0100
Message-Id: <20191128145316.1044912-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127094837.4045-1-jolsa@kernel.org>
References: 
MIME-Version: 1.0
X-MC-Unique: BlRz4W30NQG6s5bf8Lw09Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Currently we support only static linking with kernel's libbpf
(tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
that triggers libbpf detection and bpf dynamic linking:

  $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=3D1

If libbpf is not installed, build (with LIBBPF_DYNAMIC=3D1) stops with:

  $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=3D1
    Auto-detecting system features:
    ...                        libbfd: [ on  ]
    ...        disassembler-four-args: [ on  ]
    ...                          zlib: [ on  ]
    ...                        libbpf: [ OFF ]

  Makefile:102: *** Error: No libbpf devel library found, please install-de=
vel or libbpf-dev.

Adding LIBBPF_DIR compile variable to allow linking with
libbpf installed into specific directory:

  $ make -C tools/lib/bpf/ prefix=3D/tmp/libbpf/ install_lib install_header=
s
  $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tmp/libbpf/

It might be needed to clean build tree first because features
framework does not detect the change properly:

  $ make -C tools/build/feature clean
  $ make -C tools/bpf/bpftool/ clean

Since bpftool uses bits of libbpf that are not exported as public API in
the .so version, we also pass in libbpf.a to the linker, which allows it to
pick up the private functions from the static library without having to
expose them as ABI.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
v2:
  - Pass .a file to linker when dynamically linking, so bpftool can use
    private functions from libbpf without exposing them as API.
   =20
 tools/bpf/bpftool/Makefile | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 39bc6f0f4f0b..397051ed9e41 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -1,6 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
+# LIBBPF_DYNAMIC to enable libbpf dynamic linking.
+
 include ../../scripts/Makefile.include
 include ../../scripts/utilities.mak
+include ../../scripts/Makefile.arch
+
+ifeq ($(LP64), 1)
+  libdir_relative =3D lib64
+else
+  libdir_relative =3D lib
+endif
=20
 ifeq ($(srctree),)
 srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
@@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
 LDFLAGS +=3D $(EXTRA_LDFLAGS)
 endif
=20
-LIBS =3D $(LIBBPF) -lelf -lz
+LIBS =3D -lelf -lz
=20
 INSTALL ?=3D install
 RM ?=3D rm -f
@@ -63,6 +72,19 @@ RM ?=3D rm -f
 FEATURE_USER =3D .bpftool
 FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zlib
 FEATURE_DISPLAY =3D libbfd disassembler-four-args zlib
+ifdef LIBBPF_DYNAMIC
+  FEATURE_TESTS   +=3D libbpf
+  FEATURE_DISPLAY +=3D libbpf
+
+  # for linking with debug library run:
+  # make LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/opt/libbpf
+  ifdef LIBBPF_DIR
+    LIBBPF_CFLAGS  :=3D -I$(LIBBPF_DIR)/include
+    LIBBPF_LDFLAGS :=3D -L$(LIBBPF_DIR)/$(libdir_relative)
+    FEATURE_CHECK_CFLAGS-libbpf  :=3D $(LIBBPF_CFLAGS)
+    FEATURE_CHECK_LDFLAGS-libbpf :=3D $(LIBBPF_LDFLAGS)
+  endif
+endif
=20
 check_feat :=3D 1
 NON_CHECK_FEAT_TARGETS :=3D clean uninstall doc doc-clean doc-install doc-=
uninstall
@@ -88,6 +110,20 @@ ifeq ($(feature-reallocarray), 0)
 CFLAGS +=3D -DCOMPAT_NEED_REALLOCARRAY
 endif
=20
+ifdef LIBBPF_DYNAMIC
+  ifeq ($(feature-libbpf), 1)
+    # bpftool uses non-exported functions from libbpf, so pass both dynami=
c and
+    # static versions and let the linker figure it out
+    LIBS    :=3D -lbpf $(LIBBPF) $(LIBS)
+    CFLAGS  +=3D $(LIBBPF_CFLAGS)
+    LDFLAGS +=3D $(LIBBPF_LDFLAGS)
+  else
+    dummy :=3D $(error Error: No libbpf devel library found, please instal=
l-devel or libbpf-dev.)
+  endif
+else
+  LIBS :=3D $(LIBBPF) $(LIBS)
+endif
+
 include $(wildcard $(OUTPUT)*.d)
=20
 all: $(OUTPUT)bpftool
--=20
2.24.0

