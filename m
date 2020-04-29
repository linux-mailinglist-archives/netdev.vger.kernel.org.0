Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2041BDD20
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgD2NFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgD2NFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:05:50 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F4AC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 06:05:49 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so1937891wma.4
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 06:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRCfBdadPVTEiQclG9/KJeo/s7dbbAmCdTeG8F+tkxA=;
        b=kkknD6znJD9eKqwpa80nS3XJjm4Vg/Ne2ZPsAgMy5k3r9Cqllji8I7sKWJhmRqGHJk
         D3pqVbezVxOdWLPlvzfQKeLS91UpCmiNzhcAQ9PdTsLdXb7M0UQr5fALfWLdEhxpf+el
         ByD4Lw+wxQUgFh/6sp+pbfb2wc+tIvqPnFm2jnPa9uIkDiCbQS62VoWXV5tfZupymSw9
         4eJDE4q+Qos3IqcoX5NW+jEN4aSj2+z605FZYvR9ESu2N/58MI7EEsqSlcuKh0FDFUD8
         FCUU/DKFcaMwbFv/VI5zB2+RNDqODVPklzyEbYyBQn+xjswZ25ZJgR5AZhXu+7Q+SLk9
         jIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRCfBdadPVTEiQclG9/KJeo/s7dbbAmCdTeG8F+tkxA=;
        b=ua7N3oxm5jg+Bc8aHAN1bcf0qLVEh4fUwIqbH8Pmy2L4VN8HncOobsNFoThHWjaWTW
         PFoM0FNP0uWgneBY5pMeQrEKbljV205FKF8QR0rNSjhiXTysTkupIcIx10p0/avLqts1
         DoSoxTNPWNLyoRd0xKZYZ+ZuX7JiQ/UhDrCNOuALh9RdGkezyPv9ZP2NqFxpGYrmfFC2
         HBcof3keHa8UuMY+cMxRa+bFLUr0QjBJSdG2l8z9aREK7n1r4MefebGvHCRJWdG6z1fc
         puUyHThEYLmk4VX/iUhfzSNEIurXpk/+bhJzkqOYR1CB/NgwaNMXVWRrepS5AE/3rlF+
         p4qA==
X-Gm-Message-State: AGi0PuacRHNBLJTkOs3tauyqc50aPBv0BLD73J0OgWHVOrSxJvlsvyEC
        dCrUtCWs3PGIVm4YxxilbSnYUHq8ZsA=
X-Google-Smtp-Source: APiQypJ0KgnHIRKLRRjiH/35QcG9BbymXObY4HmkCzP6WAaOBHXg+Ab/KdZn7oaXvRajqpvCxAtbOg==
X-Received: by 2002:a1c:e284:: with SMTP id z126mr3405702wmg.32.1588165548378;
        Wed, 29 Apr 2020 06:05:48 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.38])
        by smtp.gmail.com with ESMTPSA id 74sm31568199wrk.30.2020.04.29.06.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 06:05:47 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH bpf-next v2 1/3] tools: bpftool: for "feature probe" define "full_mode" bool as global
Date:   Wed, 29 Apr 2020 14:05:32 +0100
Message-Id: <20200429130534.11823-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429130534.11823-1-quentin@isovalent.com>
References: <20200429130534.11823-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "full_mode" variable used for switching between full or partial
feature probing (i.e. with or without probing helpers that will log
warnings in kernel logs) was piped from the main do_probe() function
down to probe_helpers_for_progtype(), where it is needed.

Define it as a global variable: the calls will be more readable, and if
other similar flags were to be used in the future, we could use global
variables as well instead of extending again the list of arguments with
new flags.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/feature.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 88718ee6a438..59e4cb44efbc 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -35,6 +35,8 @@ static const char * const helper_name[] = {
 
 #undef BPF_HELPER_MAKE_ENTRY
 
+static bool full_mode;
+
 /* Miscellaneous utility functions */
 
 static bool check_procfs(void)
@@ -540,8 +542,7 @@ probe_helper_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 
 static void
 probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
-			   const char *define_prefix, bool full_mode,
-			   __u32 ifindex)
+			   const char *define_prefix, __u32 ifindex)
 {
 	const char *ptype_name = prog_type_name[prog_type];
 	char feat_name[128];
@@ -678,8 +679,7 @@ static void section_map_types(const char *define_prefix, __u32 ifindex)
 }
 
 static void
-section_helpers(bool *supported_types, const char *define_prefix,
-		bool full_mode, __u32 ifindex)
+section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
 {
 	unsigned int i;
 
@@ -704,8 +704,8 @@ section_helpers(bool *supported_types, const char *define_prefix,
 		       define_prefix, define_prefix, define_prefix,
 		       define_prefix);
 	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
-		probe_helpers_for_progtype(i, supported_types[i],
-					   define_prefix, full_mode, ifindex);
+		probe_helpers_for_progtype(i, supported_types[i], define_prefix,
+					   ifindex);
 
 	print_end_section();
 }
@@ -725,7 +725,6 @@ static int do_probe(int argc, char **argv)
 	enum probe_component target = COMPONENT_UNSPEC;
 	const char *define_prefix = NULL;
 	bool supported_types[128] = {};
-	bool full_mode = false;
 	__u32 ifindex = 0;
 	char *ifname;
 
@@ -803,7 +802,7 @@ static int do_probe(int argc, char **argv)
 		goto exit_close_json;
 	section_program_types(supported_types, define_prefix, ifindex);
 	section_map_types(define_prefix, ifindex);
-	section_helpers(supported_types, define_prefix, full_mode, ifindex);
+	section_helpers(supported_types, define_prefix, ifindex);
 	section_misc(define_prefix, ifindex);
 
 exit_close_json:
-- 
2.20.1

