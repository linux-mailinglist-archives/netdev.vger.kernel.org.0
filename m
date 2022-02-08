Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0D4AD827
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 13:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348221AbiBHMHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 07:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347695AbiBHMG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:06:59 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A036C03FECF
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:06:58 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id o12so51579575eju.13
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 04:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bysXayoj/ZOqXC0/8UAT3GEQ7MEmhAEIOcxkwiZ3yAY=;
        b=VQMyTU4CXnn06uzQHW3sjNfiXj1subUzOFgdW3kbOYxPbFUPR9AUYedox4V4h5j/jS
         3FmyJ+OOEaQ5VY3JlpYojxUBYuAJ14tPfw/k9FTfIPkwPhUudUdsZqs8U8cRuvw12K3/
         p9Kv/eL1NLkgHE7x5h5nPetQuIU2o4hHyBFd7mNBIvaeLGz5RUE4k4myHh8eAf+j89OA
         E1B6ukeH3zf8ugb6fv9xUTxGKzP/+2YQKqGPqzdGGPng+njUKQPwKWaNE1Pj5UezghLs
         jF0BHvJF02bn00KPZMEKQqAe8TvEhIr3jnH8DEUkNL7Hn/bmE2oaFrER5wOCNP7bTA+C
         Av7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bysXayoj/ZOqXC0/8UAT3GEQ7MEmhAEIOcxkwiZ3yAY=;
        b=0ZqTYRZ7XZhyCiX71l+kwKkbkBgFZ37oI6xOKyIrtvrB10A2wFqfjAwNiMozvpfxk0
         1ngH2jfoI6iGDzz1lHCpJ1saSvN+5+3TElzK0/I/QpD5ntaEkHEGkAL0oY7bPfN6bq02
         fq63LycI4ahx/1VIsGDZUxM1tH9VLiFg8HzAS2NACypKyWwPXTv5dad5MmU7Mgeqk4xz
         Vi1Wb9EV1ErEtPz8qWQWktScANZf86Q+3k1/vSj+ZDlfRpNR7rhaGW8RUm5kCSmBHdeM
         vg4WlhVPJexCNSmsRaByPh4E1f6XfczLwPLBHN8vxQr2o6BFy98//4xqOkIxBRbXAeep
         bCeg==
X-Gm-Message-State: AOAM531H5iwZzO/uL8ZDNtaae0qJgTOn+es7uK6SacELQ8jRv1wfbLGq
        rHNoHAqnX4kow5JfJkIN0Bowpw==
X-Google-Smtp-Source: ABdhPJy1VMXQiImoWz6SJVctnTicPlW8qYp1+ulx7E1TdRYZI0rTwKDFz0yENg3CU95v+/g4MAvdRQ==
X-Received: by 2002:a17:907:7f0e:: with SMTP id qf14mr3479255ejc.152.1644322016601;
        Tue, 08 Feb 2022 04:06:56 -0800 (PST)
Received: from localhost.localdomain ([149.86.77.242])
        by smtp.gmail.com with ESMTPSA id m17sm5567351edr.62.2022.02.08.04.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 04:06:56 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 3/3] bpftool: Update versioning scheme, align on libbpf's version number
Date:   Tue,  8 Feb 2022 12:06:48 +0000
Message-Id: <20220208120648.49169-4-quentin@isovalent.com>
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

Since the notion of versions was introduced for bpftool, it has been
following the version number of the kernel (using the version number
corresponding to the tree in which bpftool's sources are located). The
rationale was that bpftool's features are loosely tied to BPF features
in the kernel, and that we could defer versioning to the kernel
repository itself.

But this versioning scheme is confusing today, because a bpftool binary
should be able to work with both older and newer kernels, even if some
of its recent features won't be available on older systems. Furthermore,
if bpftool is ported to other systems in the future, keeping a
Linux-based version number is not a good option.

Looking at other options, we could either have a totally independent
scheme for bpftool, or we could align it on libbpf's version number
(with an offset on the major version number, to avoid going backwards).
The latter comes with a few drawbacks:

- We may want bpftool releases in-between two libbpf versions. We can
  always append pre-release numbers to distinguish versions, although
  those won't look as "official" as something with a proper release
  number. But at the same time, having bpftool with version numbers that
  look "official" hasn't really been an issue so far.

- If no new feature lands in bpftool for some time, we may move from
  e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
  versions which are in fact the same.

- Following libbpf's versioning scheme sounds better than kernel's, but
  ultimately it doesn't make too much sense either, because even though
  bpftool uses the lib a lot, its behaviour is not that much conditioned
  by the internal evolution of the library (or by new APIs that it may
  not use).

Having an independent versioning scheme solves the above, but at the
cost of heavier maintenance. Developers will likely forget to increase
the numbers when adding features or bug fixes, and we would take the
risk of having to send occasional "catch-up" patches just to update the
version number.

Based on these considerations, this patch aligns bpftool's version
number on libbpf's. This is not a perfect solution, but 1) it's
certainly an improvement over the current scheme, 2) the issues raised
above are all minor at the moment, and 3) we can still move to an
independent scheme in the future if we realise we need it.

Given that libbpf is currently at version 0.7.0, and bpftool, before
this patch, was at 5.16, we use an offset of 6 for the major version,
bumping bpftool to 6.7.0.

It remains possible to manually override the version number by setting
BPFTOOL_VERSION when calling make.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
Contrarily to the previous discussion and to what the first patch of the
set does, I chose not to use the libbpf_version_string() API from libbpf
to compute the version for bpftool. There were three reasons for that:

- I don't feel comfortable having bpftool's version number computed at
  runtime. Somehow it really feels like we should now it when we compile
  it. We link statically against libbpf today, but if we were to support
  dynamic linking in the future we may forget to update and would have
  bpftool's version changing based on the libbpf version installed
  beside it, which does not make sense.

- We cannot get the patch version for libbpf, the current API only
  returns the major and minor version numbers (we could fix it, although
  I'm not sure if desirable to expose the patch number).

- I found it less elegant to compute the version strings in the code,
  which meant malloc() and error handling just for printing a version
  number, and having a separate case for when $(BPFTOOL_VERSION) is
  defined, whereas passing a macro from the Makefile makes things
  straightforwards.
---
 tools/bpf/bpftool/Makefile | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 83369f55df61..8dd30abff3d9 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -7,14 +7,21 @@ srctree := $(patsubst %/,%,$(dir $(srctree)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
 
+BPF_DIR = $(srctree)/tools/lib/bpf
+
+# bpftool's version is libbpf's with a fixed offset for the major version.
+# This is because bpftool's version was higher than libbpf's when we adopted
+# this scheme.
+BPFTOOL_MAJOR_OFFSET := 6
+LIBBPF_VERSION := $(shell make -r --no-print-directory -sC $(BPF_DIR) libbpfversion)
+BPFTOOL_VERSION ?= $(shell lv="$(LIBBPF_VERSION)"; echo "$$((${lv%%.*} + $(BPFTOOL_MAJOR_OFFSET))).$${lv#*.}")
+
 ifeq ($(V),1)
   Q =
 else
   Q = @
 endif
 
-BPF_DIR = $(srctree)/tools/lib/bpf
-
 ifneq ($(OUTPUT),)
   _OUTPUT := $(OUTPUT)
 else
@@ -39,10 +46,6 @@ LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
 LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
 
-ifeq ($(BPFTOOL_VERSION),)
-BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
-endif
-
 $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
 	$(QUIET_MKDIR)mkdir -p $@
 
-- 
2.32.0

