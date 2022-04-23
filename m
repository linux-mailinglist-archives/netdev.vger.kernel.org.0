Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC6250CAEF
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiDWOFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiDWOEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:04:54 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A998D5131F;
        Sat, 23 Apr 2022 07:01:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r83so9638639pgr.2;
        Sat, 23 Apr 2022 07:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=22WibGqwBYzM5TID1KxUHLJP4UWNrynkocfb34+94xc=;
        b=BDcQ/kTKJH85Fw7B7YF9tbQ9lYjXX3vbbV+aIA/legJ/EXkFmdJW6fQur+wuIaNTFi
         nQs/GbkC1VlK8jkPLSrFYQJWi8ij3vauhqEzWOTfGNH2YmGowdfKPUcluvnuSMIE6/N3
         BTfY9mF2qVwj36D4M7hL/CZMzgWETRbdVB0sp0vM1sJnWzJuMMerEuzlPHg1egeRyhKA
         OSvZLCM3VodxuKxhEW4o6B2Py/qfha7C1fLsTkXXlPE8ogJPWl9+tmr6/LubzPgBr8YX
         vp8q4xJ1IlWcpyS8905c0bqR+2viDOIF8UQWx4etuNV554rruRbi6QR0qgSDwHM342Hm
         H6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=22WibGqwBYzM5TID1KxUHLJP4UWNrynkocfb34+94xc=;
        b=nmNJUA/o88ByPrpI9cwgOaktt44+5rKmxio8aTFoCjrbfFQX/S4vEgIYlaYwHkSD7L
         PjvEUsBhO5gDzuIbuUhAC8ORDiw96hUa77G2cvzzPVxqioNSmQXWDiWt3RlautQst1lU
         MBE3Z4e/SR4KtwFXXy1pF1hGrRufefhBJFWwOgncYCa7njAelrUZs+OmaSkonlXaUZoq
         skREln0gxIR7DSmt78BN+wLTT2gKUMm+2nPvSU/0viSw5zUy4ozkqnNUBcPR6DHETPgw
         bq1k/5Hvki+MgbD9eAUc6F6wE77Wg3drEbk8h0eHAltavLaaDFOuIHUnoRi2WjHbhQhR
         w3Ew==
X-Gm-Message-State: AOAM531bFlKGbAZ2vHQCV2dsC2huwBQCoylpDKV8IXvjtbmnuoHnb3+v
        Rmq480FX8n9CADezldh5TlQ=
X-Google-Smtp-Source: ABdhPJyvt2LojsIjnekUFNYn3uJlU35LnqXY/3/0KggO509FvfvWuklCoFFaug9G6XrExsfl/JHbDg==
X-Received: by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP id h16-20020a056a00231000b004fa7eb1e855mr10356884pfh.14.1650722514879;
        Sat, 23 Apr 2022 07:01:54 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:1e2f:5400:3ff:fef5:fd57])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a77c600b001cd4989fedcsm9282071pjs.40.2022.04.23.07.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:01:54 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 1/4] libbpf: Define DEFAULT_BPFFS
Date:   Sat, 23 Apr 2022 14:00:55 +0000
Message-Id: <20220423140058.54414-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220423140058.54414-1-laoar.shao@gmail.com>
References: <20220423140058.54414-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's use a macro DEFAULT_BPFFS instead of the hard-coded "/sys/fs/bpf".

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 2 +-
 tools/lib/bpf/libbpf.c      | 2 +-
 tools/lib/bpf/libbpf.h      | 6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 44df982d2a5c..9161ebcd3466 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -137,7 +137,7 @@ struct bpf_map_def {
 
 enum libbpf_pin_type {
 	LIBBPF_PIN_NONE,
-	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
+	/* PIN_BY_NAME: pin maps by name (in DEFAULT_BPFFS by default) */
 	LIBBPF_PIN_BY_NAME,
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9a213aaaac8a..13fcf91e9e0e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2180,7 +2180,7 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
 	int len;
 
 	if (!path)
-		path = "/sys/fs/bpf";
+		path = DEFAULT_BPFFS;
 
 	len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
 	if (len < 0)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index cdbfee60ea3e..3784867811a4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -28,6 +28,8 @@ LIBBPF_API __u32 libbpf_major_version(void);
 LIBBPF_API __u32 libbpf_minor_version(void);
 LIBBPF_API const char *libbpf_version_string(void);
 
+#define DEFAULT_BPFFS "/sys/fs/bpf"
+
 enum libbpf_errno {
 	__LIBBPF_ERRNO__START = 4000,
 
@@ -91,7 +93,7 @@ struct bpf_object_open_opts {
 	bool relaxed_core_relocs;
 	/* maps that set the 'pinning' attribute in their definition will have
 	 * their pin_path attribute set to a file in this directory, and be
-	 * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
+	 * auto-pinned to that path on load; defaults to DEFAULT_BPFFS.
 	 */
 	const char *pin_root_path;
 
@@ -190,7 +192,7 @@ bpf_object__open_xattr(struct bpf_object_open_attr *attr);
 
 enum libbpf_pin_type {
 	LIBBPF_PIN_NONE,
-	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
+	/* PIN_BY_NAME: pin maps by name (in DEFAULT_BPFFS by default) */
 	LIBBPF_PIN_BY_NAME,
 };
 
-- 
2.17.1

