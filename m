Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31EC436878
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhJUQ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbhJUQ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:58:41 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E1CC0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:56:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d187-20020a6236c4000000b0044cf291bfebso733686pfa.10
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eNXnzm7PRFEjVZ7icwk7/f1lp3WIrfCuZ/3V2R8lQGc=;
        b=H1dM0GkW1dHSojJ5KLnwJhbrIytnfvWOgrP6koJZnmGR/c/1jPWviCFr56DyGp3IXp
         ZdHCX9nDLhGsz4J2Y+/CFLOaBcbE1VLikcmzkyi72nczEhafwySR0IwDJEVFFtbotpbE
         4Gk7Jzp8z9sZWMmvyABHl1gHBF3aspZJ2M9oH04hM1YO+4VDuQq8QeYwCFtFD1gumZhy
         78tNxlxjoAzDM/hoczOvnHZBRFHygJ4oDx4Ki09YFx//Kkbd0PKsqhVED9KvtJe6QtDt
         gLQySo1UNRGf714bsq+jRXWQhMyUbv5CSn48qwTMD+wORZ399wudvbmITYlYHCWA6sU8
         NkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eNXnzm7PRFEjVZ7icwk7/f1lp3WIrfCuZ/3V2R8lQGc=;
        b=iyZX/yUz+QXgm4irNlsEoui2m/epelSPA/WhU39llaoIZIcUMZargDv7Ifs2Gys/vf
         pQ02RWOEycrq4AdvQuQPvTGwGJejxwnJz27jdNFwboeiox1BUfiqm+abWDWNmDQyKZ1k
         hlySPXFu2bNuONr7Be6TfMxpAlDqcx3bnN3VqdxpnLwwEPIIcPrwdUKfGS/sROEFrcaM
         jdJdBRzK8DQKO93owYe/7rKuBShTAjFeoeS+TvGvLyRUqwMcsny61i3N8MVSYL0jA855
         Dp2iey0rFpFTk0CZjwxBwH8NvS2RFLXbeSe7vG9tjS1eGZ+nKTpmh8PnRQGRzyXad7nz
         hLbg==
X-Gm-Message-State: AOAM530exQo+sid6/oDjfj3gbRml/wMCXtRphrV+NurzhJ6lHRR4Iab/
        Shq98PEElESgTKr5Bkm6tdBrjeX6fCVMmM23Q/ru2yPihSPw4zl3QVqrOQ19dQpdj1b2gOZtk/v
        Z4BbUXjs43+eFYbgKfAEoQMbLzpKHtJNmiw0NvTYZ9b2vcqQJb3rnig==
X-Google-Smtp-Source: ABdhPJwnOa0AOC4P8HbPG7ejSdrTjwyowr0cGqlwsDRYQltpg7tlJHSK6x7GJho7W7D4XjgdZ1HVNUc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:5d22:afc4:e329:550e])
 (user=sdf job=sendgmr) by 2002:a17:90a:5285:: with SMTP id
 w5mr32859pjh.1.1634835384711; Thu, 21 Oct 2021 09:56:24 -0700 (PDT)
Date:   Thu, 21 Oct 2021 09:56:17 -0700
In-Reply-To: <20211021165618.178352-1-sdf@google.com>
Message-Id: <20211021165618.178352-3-sdf@google.com>
Mime-Version: 1.0
References: <20211021165618.178352-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v4 2/3] bpftool: conditionally append / to the progtype
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
 tools/bpf/bpftool/main.c | 4 ++++
 tools/bpf/bpftool/prog.c | 9 +++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

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
index 277d51c4c5d9..b04990588ccf 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1420,8 +1420,13 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			err = get_prog_type_by_name(type, &common_prog_type,
 						    &expected_attach_type);
 			free(type);
-			if (err < 0)
-				goto err_free_reuse_maps;
+			if (err < 0) {
+				err = get_prog_type_by_name(*argv, &common_prog_type,
+							    &expected_attach_type);
+				if (err < 0)
+
+					goto err_free_reuse_maps;
+			}
 
 			NEXT_ARG();
 		} else if (is_prefix(*argv, "map")) {
-- 
2.33.0.1079.g6e70778dc9-goog

