Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB6297563
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 10:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfHUIwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 04:52:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54693 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHUIwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 04:52:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so1249338wme.4
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 01:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r4bUeephZBN2sAbFUS+smte4iFd/homrxE93aQENC8Q=;
        b=J6vM5rlnR5SWmEYHt1GsK+IYqHY5SLwtDI4y7CHEDAcohXU5se/ULO9SO23cgjHDRA
         wZO+anZL0upC+0ymoI/MHOnSsOSeN5PIVd8Jj8hzLicJGltomxYkkjn79Rnttd3YW74Z
         sYpUduLuegLkMkxomAJE/7ElhpvaNLwifbuMIR6oT/ddnK0nfjZ5AH5yCY1H2mk4oKPS
         6czySKRNf86iwXnFwqYDVn1T+msRrX9UT5VCKWn7fgj54SuNli56krHYHjE6ZzhwHxrd
         MTkCVC9DD5C6xNSqaxcIZh6LP1PTvBhtEst+EL+ZZd6fOa7+McN4N9M8BYHilFGIbweA
         uT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r4bUeephZBN2sAbFUS+smte4iFd/homrxE93aQENC8Q=;
        b=FcdlAJycUcfC0jC/JWVHeM0nNhwzgDP5/GbuYQB7yXN8uoXlDIpj6xjfIDnGVB2p/O
         bdMf3/RawpbfYAcwUPOWeJFwExndZpFjWlkiuG4rQVlbGDBa6FOoBnbONDo5SD9npeLE
         xnDqSwHcrEnixvKotRglDrf+NljAEfs9T6b+6YfsHuKAAQ7+KabLVEiviD+A/ddI14EU
         g0TcePUiNTbTDqCqwa7hwWtAO4vaUQ0MhyLKsJ4xCi94nxEQrBeMgJ0gxVNU1rtphqIN
         K9JuHqyd3ysZHtDWIF4BxeRWma3bMgE4Eh9pOdY0GNnGvs/xAA9gz8xDiZsUCOPTtsKd
         fl9w==
X-Gm-Message-State: APjAAAVKEM19jcR7eal5lLGefckLTx3aHcElnAPwhCTiYCtLeh1F0we2
        +VpNqmG218EKlyPBrMYaXaebUw==
X-Google-Smtp-Source: APXvYqxGS2hNJpfLX5MhgvPLSj1wCl7pcjMh9xsnXs9vnRE9ibeXUfBLtSVh9/0JLxu6sJMUW0oq/A==
X-Received: by 2002:a1c:a957:: with SMTP id s84mr4754734wme.65.1566377548301;
        Wed, 21 Aug 2019 01:52:28 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p7sm2040165wmh.38.2019.08.21.01.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 01:52:27 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 2/2] tools: bpftool: add "bpftool map freeze" subcommand
Date:   Wed, 21 Aug 2019 09:52:19 +0100
Message-Id: <20190821085219.30387-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821085219.30387-1-quentin.monnet@netronome.com>
References: <20190821085219.30387-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new subcommand to freeze maps from user space.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../bpf/bpftool/Documentation/bpftool-map.rst |  9 +++++
 tools/bpf/bpftool/bash-completion/bpftool     |  4 +--
 tools/bpf/bpftool/map.c                       | 34 ++++++++++++++++++-
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 61d1d270eb5e..1c0f7146aab0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -36,6 +36,7 @@ MAP COMMANDS
 |	**bpftool** **map pop**        *MAP*
 |	**bpftool** **map enqueue**    *MAP* **value** *VALUE*
 |	**bpftool** **map dequeue**    *MAP*
+|	**bpftool** **map freeze**     *MAP*
 |	**bpftool** **map help**
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
@@ -127,6 +128,14 @@ DESCRIPTION
 	**bpftool map dequeue**  *MAP*
 		  Dequeue and print **value** from the queue.
 
+	**bpftool map freeze**  *MAP*
+		  Freeze the map as read-only from user space. Entries from a
+		  frozen map can not longer be updated or deleted with the
+		  **bpf\ ()** system call. This operation is not reversible,
+		  and the map remains immutable from user space until its
+		  destruction. However, read and write permissions for BPF
+		  programs to the map remain unchanged.
+
 	**bpftool map help**
 		  Print short help message.
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 2ffd351f9dbf..70493a6da206 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -449,7 +449,7 @@ _bpftool()
         map)
             local MAP_TYPE='id pinned'
             case $command in
-                show|list|dump|peek|pop|dequeue)
+                show|list|dump|peek|pop|dequeue|freeze)
                     case $prev in
                         $command)
                             COMPREPLY=( $( compgen -W "$MAP_TYPE" -- "$cur" ) )
@@ -638,7 +638,7 @@ _bpftool()
                     [[ $prev == $object ]] && \
                         COMPREPLY=( $( compgen -W 'delete dump getnext help \
                             lookup pin event_pipe show list update create \
-                            peek push enqueue pop dequeue' -- \
+                            peek push enqueue pop dequeue freeze' -- \
                             "$cur" ) )
                     ;;
             esac
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index af2e9eb9747b..de61d73b9030 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1262,6 +1262,35 @@ static int do_pop_dequeue(int argc, char **argv)
 	return err;
 }
 
+static int do_freeze(int argc, char **argv)
+{
+	int err, fd;
+
+	if (!REQ_ARGS(2))
+		return -1;
+
+	fd = map_parse_fd(&argc, &argv);
+	if (fd < 0)
+		return -1;
+
+	if (argc) {
+		close(fd);
+		return BAD_ARG();
+	}
+
+	err = bpf_map_freeze(fd);
+	close(fd);
+	if (err) {
+		p_err("failed to freeze map: %s", strerror(errno));
+		return err;
+	}
+
+	if (json_output)
+		jsonw_null(json_wtr);
+
+	return 0;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -1286,6 +1315,7 @@ static int do_help(int argc, char **argv)
 		"       %s %s pop        MAP\n"
 		"       %s %s enqueue    MAP value VALUE\n"
 		"       %s %s dequeue    MAP\n"
+		"       %s %s freeze     MAP\n"
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_MAP "\n"
@@ -1304,7 +1334,8 @@ static int do_help(int argc, char **argv)
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -1326,6 +1357,7 @@ static const struct cmd cmds[] = {
 	{ "enqueue",	do_update },
 	{ "pop",	do_pop_dequeue },
 	{ "dequeue",	do_pop_dequeue },
+	{ "freeze",	do_freeze },
 	{ 0 }
 };
 
-- 
2.17.1

