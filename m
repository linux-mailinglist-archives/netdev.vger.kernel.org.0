Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCC63BF86D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 12:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhGHKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 06:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhGHKcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 06:32:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A73C061574;
        Thu,  8 Jul 2021 03:29:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso5592384pjc.0;
        Thu, 08 Jul 2021 03:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fri6CTG62n5mPzd6PDTzvkLlOYKTfbKQfa4LIN83KEs=;
        b=sC/wcjvCNNbvzyeW/dDFpG4jErg7MUKsQcImGtM4JUboho9hCyMfQOqHPwYU/jX2BT
         QNcvhQICzt4sNICQUFE4eSaAsD950iXm4Oaqu48FkkxiVWYz6Uh1b6YwOxEEnchNECVX
         ZbMk76bWToktjdJFleTluver1aZr1HenbxrkqRilqb12knp0qW4HTjp4yccjJsL1h//m
         NvQUoP0dOS/9EDe+UyMx6mosELcyLELjsPRO5ltdxaC71eh1SY25T2HPe9i7oLMUISkq
         bPxnYjU9GRd8NceXRPjBupSA5BBLPJR1hphovvjTTzCQ0VunS7ivHR2i6nBoW2OTyDip
         YypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fri6CTG62n5mPzd6PDTzvkLlOYKTfbKQfa4LIN83KEs=;
        b=X/qU+RryL23TjJBG8rPmDYv54Osm6PhYhhaCT1cMPTFu/grd13K8og/2DJo1Xe1kDY
         A3uz9FUYB+2PG1znnJVUMqrC53VBhzq8KjX0hFmI1+TyiR7d7fDjpmxj8E9JLjxpIpE6
         xsPNVeq+C8sOMD8GEH0mvek+jKjMS7Xv8YT7Co3zvkKrvxuMUM6pJH6RiqZq7yE3O01L
         rDtWukm8e5YO/GNtIy1xA7fEm9ExpemRJm7iIT1TK+DbLPffBxxgom+U35xjzlLebZCM
         KR28lKZaYg07BxU6RV/DIkgAC1nXsqIDlx7ByN6Ao2qdSRDhvdDucp7GCrjmgzSbP1p+
         rN5Q==
X-Gm-Message-State: AOAM530hr0yn+6CMdzN0XejcOEl/AjT3CE+tBNznv4qtBfA/mJnzyjJL
        TtXLDgIg7U7A6puu3o963EU=
X-Google-Smtp-Source: ABdhPJy+0h04fLeo2fdk7Exx7BEbuiM0av0r4rhbBoYgiAUd+ovrDBb3sKzzSeSrJHtffi/BI3Sk9A==
X-Received: by 2002:a17:90b:1294:: with SMTP id fw20mr4246917pjb.100.1625740164709;
        Thu, 08 Jul 2021 03:29:24 -0700 (PDT)
Received: from localhost.lan (p1284205-ipngn14601marunouchi.tokyo.ocn.ne.jp. [153.205.193.205])
        by smtp.gmail.com with ESMTPSA id z3sm2555650pgl.77.2021.07.08.03.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 03:29:24 -0700 (PDT)
Received: from x2.lan (localhost [127.0.0.1])
        by localhost.lan (Postfix) with ESMTPSA id 912F59011C2;
        Thu,  8 Jul 2021 10:29:21 +0000 (GMT)
From:   Vincent Pelletier <plr.vincent@gmail.com>
To:     Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] checkpatch: Follow scripts/spdxcheck.py's switch to python3
Date:   Thu,  8 Jul 2021 10:29:18 +0000
Message-Id: <73dca402670be1e7a8adf139621dafd0dfa03191.1625740121.git.plr.vincent@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit d0259c42abff ("spdxcheck.py: Use Python 3") spdxcheck.py
expects to be run using python3. "python" may still be a python2 alias.
Instead, obey scripts/spdxcheck.py's shebang by executing it without
pre-selecting an interpreter.
Also, test python3 presence in path.

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 23697a6b1eaa..a1cbd5fd0856 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1084,10 +1084,10 @@ sub is_maintained_obsolete {
 sub is_SPDX_License_valid {
 	my ($license) = @_;
 
-	return 1 if (!$tree || which("python") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$gitroot"));
+	return 1 if (!$tree || which("python3") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$gitroot"));
 
 	my $root_path = abs_path($root);
-	my $status = `cd "$root_path"; echo "$license" | python scripts/spdxcheck.py -`;
+	my $status = `cd "$root_path"; echo "$license" | scripts/spdxcheck.py -`;
 	return 0 if ($status ne "");
 	return 1;
 }
-- 
2.32.0

