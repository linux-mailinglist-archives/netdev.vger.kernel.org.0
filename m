Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2DE11A585
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfLKIBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:01:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51015 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfLKIBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:01:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so173984wmb.0;
        Wed, 11 Dec 2019 00:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iNafb8iy7Y+FGGrqVQWeJF9BXCyC71QaJHmHluKRT0o=;
        b=baaWlDZCjyJzC2yTy9CXfarqpwTt1iLf+khLAWw+yk7gPLxRc9PrKn1Z89jdL9UTTE
         +mrqhCMHzzwKRJeZuZrPTeI9sZcTJn55fbzEoy1QiB+uEC4h23S1aQkqsOlQQs8K3vlg
         /e+z+LO9kIpIzviLVTCtUZMxF2SLJOdHtsxhi6DnTFzorCTMhOAMVQn3JdCaIZTSAFcr
         h5o/2zOwCzs+6905Nw1dsIKLSZRhW7ikvXe+VqwJubNFww+nwo89MnuygOYjYKp34pjf
         xTujZQKqRRvIaRBRSJtCMzxEFxKbW72QYbgx2SJuFwYjt8gaOznUEZqVS8pKLa60Yqhj
         zxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iNafb8iy7Y+FGGrqVQWeJF9BXCyC71QaJHmHluKRT0o=;
        b=gKYkjaMMC2yDXWfsWOu8o0/TkNetCq51SVcsTP5EyUoPetcMWfviUs58vdFaznNL6X
         Wp8+MUyXK000A16JiowXa5slUYXy3PuK3RMPpCABpVK0+s+ZdvzYz6yD/aDCJuQzLK85
         DbRWoz3XdtxXMpTZQstbbmVGZNFl/GkAcxTyB7hHQoiOri8cWMx4HxOeLpZj73osPC/0
         jDkUBztOs1g0Lr79WLP3CIwDt5dcsTs5BmAAwQGl16B6wRJ5UqZKdDyF7uBlmP8e2G9I
         ZoJmXYHMF05ixwyIoNAMLhUeqm6W00V/2QJCXWoJmepTlVFDatebpPbQ7WC/VkzGpJMn
         U/qQ==
X-Gm-Message-State: APjAAAXo+qCT1SF0SAr6XOsNsG8sMwKP660AfaI02I8Q9cwSUF5ky8hj
        dtkkH6v+SGgKnjxv7lAT0Pw=
X-Google-Smtp-Source: APXvYqzTJllTzFGqeiMqEBx0JuKyRO5tZacl4sepHfUt5XF/++K3JLMTcU2Py3wrRaNsGkcVKOsjJQ==
X-Received: by 2002:a1c:dc82:: with SMTP id t124mr2068687wmg.122.1576051289961;
        Wed, 11 Dec 2019 00:01:29 -0800 (PST)
Received: from aherlnxbspsrv01.lgs-net.com ([193.8.40.126])
        by smtp.gmail.com with ESMTPSA id s25sm1313160wmh.4.2019.12.11.00.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:01:29 -0800 (PST)
From:   Andrey Zhizhikin <andrey.z@gmail.com>
X-Google-Original-From: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sergey.senozhatsky@gmail.com, pmladek@suse.com,
        wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH] tools lib api fs: fix gcc9 compilation error
Date:   Wed, 11 Dec 2019 08:01:09 +0000
Message-Id: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC9 introduced string hardening mechanisms, which exhibits the error
during fs api compilation:

error: '__builtin_strncpy' specified bound 4096 equals destination size
[-Werror=stringop-truncation]

This comes when the length of copy passed to strncpy is is equal to
destination size, which could potentially lead to buffer overflow.

There is a need to mitigate this potential issue by limiting the size of
destination by 1 and explicitly terminate the destination with NULL.

Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/api/fs/fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 11b3885e833e..027b18f7ed8c 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -210,6 +210,7 @@ static bool fs__env_override(struct fs *fs)
 	size_t name_len = strlen(fs->name);
 	/* name + "_PATH" + '\0' */
 	char upper_name[name_len + 5 + 1];
+
 	memcpy(upper_name, fs->name, name_len);
 	mem_toupper(upper_name, name_len);
 	strcpy(&upper_name[name_len], "_PATH");
@@ -219,7 +220,8 @@ static bool fs__env_override(struct fs *fs)
 		return false;
 
 	fs->found = true;
-	strncpy(fs->path, override_path, sizeof(fs->path));
+	strncpy(fs->path, override_path, sizeof(fs->path) - 1);
+	fs->path[sizeof(fs->path) - 1] = '\0';
 	return true;
 }
 
-- 
2.17.1

