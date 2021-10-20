Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96760435622
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhJTWwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTWw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:52:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C8C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b126-20020a251b84000000b005bd8aca71a2so32871718ybb.4
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rBNogD71QwX1yFi87rfGNRLIga0/VwtxkfUp9rDUZvc=;
        b=C6xt0MvA6xauf5TQ9xfR57d1BTQRzEBmFwnNCfsTj3aXWXKnIUgsp5CyDELUF6Icfb
         iFtjLEm+fct/ShCneeMKfW4dUN7/dXPIh8V22CqvyZdUeUmi9UJoMmtfVEFTlJ10fV9P
         YFSInC7Kya0Ob8uXfFRAb47LJXmVZ0Dk+5AojFbPZBHyMvzjRTaYBaB+3ILCnHq/0AfQ
         ZZzMOfXDiewTIJ5XCrKLM64Q7bHaeS/Z9/gq5LS1ZuCBO+f9T5NkrITnfYVNjCERrq4j
         fHBgSScQBDO3g3BQmnb8d2u+xBYHWYEi02otwuqapDONTnX7s93JjtDWlQoXSjUyX4vA
         wdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rBNogD71QwX1yFi87rfGNRLIga0/VwtxkfUp9rDUZvc=;
        b=7OPHtpA75t0mfsC7MH2dftWbqgvvnW+s/MmUtQ1juzEQvZyhHGPwrkn0uvIkGSKtr+
         4j5RLFLU/mrmbyC9VEdmGrf5WTGuhcQlCqZ3veBIMcEJjPKb5zxf+QfrNUwuMP0u5wgV
         1cwWfyDIbMxMlGeQSDDF5R8hcl/NYIxuATfwj452VTAQGMlza+RRgXQcAbJPry/juG1x
         4f7YsbEKWzkCpSe+tFrebbNF6ynJbqvY22dBzEsHC9jDSLm6jYGvJjuMGlGEBrx0t5mV
         rPvzZEZi5YWoknDa+fW9sg0emCrhZKviw0P1Bj9pAR6atnY+l4yXtdkzFFGaK8T9eLtV
         5C2Q==
X-Gm-Message-State: AOAM533aSywDOEK4flATIkr/UcJo0o9J4Fo5W6s3SA8I53PvpUbgIJ97
        NA1jbphIly1J1zIQXMXVnW9VkMFllHDLsCvH4lG2RRCMMzBhEI6To+lsicCZysizEXMXXyljltR
        Rx3A9ipRkhmcZkP+8kCRomuIARJ0CcdQESHIMYvVBN2FpVde7GzP3EA==
X-Google-Smtp-Source: ABdhPJxARQOrMmkzQMj8NYyUfG6aqUlUOHEqNT0BPimeGmaRxa7RJvpqzNed/ocTcAdE+uX+xLxmFK0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:dcf9:6f58:d879:8452])
 (user=sdf job=sendgmr) by 2002:a25:37d1:: with SMTP id e200mr2077940yba.34.1634770211380;
 Wed, 20 Oct 2021 15:50:11 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:50:04 -0700
In-Reply-To: <20211020225005.2986729-1-sdf@google.com>
Message-Id: <20211020225005.2986729-3-sdf@google.com>
Mime-Version: 1.0
References: <20211020225005.2986729-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v3 2/3] bpftool: don't append / to the progtype
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, attaching with bpftool doesn't work with strict section names.

Also, switch to libbpf strict mode to use the latest conventions
(note, I don't think we have any cli api guarantees?).

Cc: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/main.c |  4 ++++
 tools/bpf/bpftool/prog.c | 15 +--------------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 02eaaf065f65..8223bac1e401 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -409,6 +409,10 @@ int main(int argc, char **argv)
 	block_mount = false;
 	bin_name = argv[0];
 
+	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+	if (ret)
+		p_err("failed to enable libbpf strict mode: %d", ret);
+
 	hash_init(prog_table.table);
 	hash_init(map_table.table);
 	hash_init(link_table.table);
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 277d51c4c5d9..17505dc1243e 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	while (argc) {
 		if (is_prefix(*argv, "type")) {
-			char *type;
-
 			NEXT_ARG();
 
 			if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
@@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			if (!REQ_ARGS(1))
 				goto err_free_reuse_maps;
 
-			/* Put a '/' at the end of type to appease libbpf */
-			type = malloc(strlen(*argv) + 2);
-			if (!type) {
-				p_err("mem alloc failed");
-				goto err_free_reuse_maps;
-			}
-			*type = 0;
-			strcat(type, *argv);
-			strcat(type, "/");
-
-			err = get_prog_type_by_name(type, &common_prog_type,
+			err = get_prog_type_by_name(*argv, &common_prog_type,
 						    &expected_attach_type);
-			free(type);
 			if (err < 0)
 				goto err_free_reuse_maps;
 
-- 
2.33.0.1079.g6e70778dc9-goog

