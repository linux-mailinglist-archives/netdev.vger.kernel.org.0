Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2B4514B5
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348856AbhKOUMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347432AbhKOTjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:39:52 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421EDC03541D
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:31:08 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id r18-20020a25ac52000000b005c9047c420bso23974124ybd.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4uSzuTcwVIaWHj9mOBdqmeLq8zoZlReWYD6+yqHjK7w=;
        b=B0ygsEcxpyi9/suFEKLR81K66yi2KGN23Crva/YVNYqEsJoA1tmUHqX7aBKJPkGd4U
         fSY+qEoMnFtGx3lA3nRfsm8SB4PtZW0ApzXc0X5dE8C3slCsuHw1TfJF5CyaXwIuSags
         lW/QqSiAJ9cd4+ws49dsTNiX1im5s2FvA/7eNhyjV1NBJ8pnsHhulKkqfISz9anHSEts
         t0Gyqw9rwlsXfOXf/MeZY2fzaHxoj2BseikTjsd75HbDcMRl4K/pZrdruPUZ2aiV+w3O
         /o9dmZcMz8HHmpcegWRku0WJIWb0uKW0PK2oes/F4Q0CMkfpljUoU19qxC2XQNmahS4W
         DDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4uSzuTcwVIaWHj9mOBdqmeLq8zoZlReWYD6+yqHjK7w=;
        b=lmqJqTKGPVb/2e0y9Q+RbjiLkHr4ieooaNoYVUHy+OmfXAORbIKcv4vJtMlR/dfBM3
         TIIr3T10xMI8WoHOkeQbnwD6yUSTpwAoCCuUZHHrPNc+qGIHq0GjlIfUvXIoEZakDnes
         1Gkx4JrpbCR7db4pe/vOmeXIe3vD1zOnEsfKn3H5dQwAEb8TUFcdHAer7zc98qVzZcti
         4xUh0SfBn6FEJsdpzXOxcLGC1KIuzaerxLZdpYFND352kJRdCmVLvaQAFOVIVKbeXxLp
         FN99+4q+54SKUZJPeJwJZ4QnZ9iauwNZNNGA2+cupK/MlyaH/fjAl4YMwnctL3Fq0BUb
         kvsw==
X-Gm-Message-State: AOAM530fXqxA2RbyNoIBu4UESGf04RYAKMwje8dX5iTODtheEBAmf1Yx
        I2/dF8g/shj5WGLcLEep6LzbdNH8KoVIcQiixYILcRSvkR/5qFB9vkpEEBSZWP2xqUobqb2AoaG
        +FckBmQdsQMPR3wti9cG8O8F0nLwLIOKRgrWKczPEx1NS6U8NK9a28Q==
X-Google-Smtp-Source: ABdhPJytAWI4KPZsWIikMibV8nJzJ28kBVZg7YdtJbWDUVMDJpTI8G3PxhgKxZG7EHtm4MR8in9j1j8=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b159:a155:9460:f1ca])
 (user=sdf job=sendgmr) by 2002:a25:5954:: with SMTP id n81mr1457941ybb.435.1637004667476;
 Mon, 15 Nov 2021 11:31:07 -0800 (PST)
Date:   Mon, 15 Nov 2021 11:31:05 -0800
Message-Id: <20211115193105.1952656-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH bpf-next v2] bpftool: add current libbpf_strict mode to
 version output
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ bpftool --legacy --version
bpftool v5.15.0
features: libbfd, skeletons
+ bpftool --version
bpftool v5.15.0
features: libbfd, libbpf_strict, skeletons

+ bpftool --legacy --help
Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
       bpftool batch file FILE
       bpftool version

       OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
       OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
                    {-V|--version} }
+ bpftool --help
Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
       bpftool batch file FILE
       bpftool version

       OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
       OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
                    {-V|--version} }

+ bpftool --legacy
Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
       bpftool batch file FILE
       bpftool version

       OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
       OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
                    {-V|--version} }
+ bpftool
Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
       bpftool batch file FILE
       bpftool version

       OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
       OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
                    {-V|--version} }

+ bpftool --legacy version
bpftool v5.15.0
features: libbfd, skeletons
+ bpftool version
bpftool v5.15.0
features: libbfd, libbpf_strict, skeletons

+ bpftool --json --legacy version
{"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":false,"skeletons":true}}
+ bpftool --json version
{"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":true,"skeletons":true}}

v2:
- fixes for -h and -V (Quentin Monnet)

Suggested-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 473791e87f7d..601d0ee5e6d3 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -93,6 +93,7 @@ static int do_version(int argc, char **argv)
 		jsonw_name(json_wtr, "features");
 		jsonw_start_object(json_wtr);	/* features */
 		jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
+		jsonw_bool_field(json_wtr, "libbpf_strict", !legacy_libbpf);
 		jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
 		jsonw_end_object(json_wtr);	/* features */
 
@@ -106,6 +107,10 @@ static int do_version(int argc, char **argv)
 			printf(" libbfd");
 			nb_features++;
 		}
+		if (!legacy_libbpf) {
+			printf("%s libbpf_strict", nb_features++ ? "," : "");
+			nb_features++;
+		}
 		if (has_skeletons)
 			printf("%s skeletons", nb_features++ ? "," : "");
 		printf("\n");
@@ -414,9 +419,11 @@ int main(int argc, char **argv)
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
-			return do_version(argc, argv);
+			last_do_help = do_version;
+			break;
 		case 'h':
-			return do_help(argc, argv);
+			last_do_help = do_help;
+			break;
 		case 'p':
 			pretty_output = true;
 			/* fall through */
@@ -476,7 +483,7 @@ int main(int argc, char **argv)
 
 	argc -= optind;
 	argv += optind;
-	if (argc < 0)
+	if (argc < 1)
 		usage();
 
 	ret = cmd_select(cmds, argc, argv, do_help);
-- 
2.34.0.rc1.387.gb447b232ab-goog

