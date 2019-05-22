Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7F27061
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfEVUDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbfEVTVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:21:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DEB42173C;
        Wed, 22 May 2019 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552897;
        bh=SXkz2rRTYygGWZhwmXK4TDRIYfU0p6emAJwWwaDRWIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSKnRIGg2xZUeyqQHYO4+BinpkXqaIT7pODp+9N5rcx1ZFV7sQYaeCkdlS1sW0RdA
         PKguBXdJAib/XFKYxerJz5Ybvvtju7wuqLwRmo8XEoA1Heuj6dNmVvCFFE5/ESVQBP
         rLVX+VAMce1mFy4z/2fnMch5x0rkdw2Uqvl7IaoQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 016/375] bpftool: exclude bash-completion/bpftool from .gitignore pattern
Date:   Wed, 22 May 2019 15:15:16 -0400
Message-Id: <20190522192115.22666-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit a7d006714724de4334c5e3548701b33f7b12ca96 ]

tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
intended to ignore the following build artifact:

  tools/bpf/bpftool/bpftool

However, the .gitignore entry is effective not only for the current
directory, but also for any sub-directories.

So, from the point of .gitignore grammar, the following check-in file
is also considered to be ignored:

  tools/bpf/bpftool/bash-completion/bpftool

As the manual gitignore(5) says "Files already tracked by Git are not
affected", this is not a problem as far as Git is concerned.

However, Git is not the only program that parses .gitignore because
.gitignore is useful to distinguish build artifacts from source files.

For example, tar(1) supports the --exclude-vcs-ignore option. As of
writing, this option does not work perfectly, but it intends to create
a tarball excluding files specified by .gitignore.

So, I believe it is better to fix this issue.

You can fix it by prefixing the pattern with a slash; the leading slash
means the specified pattern is relative to the current directory.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
index 67167e44b7266..8248b8dd89d4b 100644
--- a/tools/bpf/bpftool/.gitignore
+++ b/tools/bpf/bpftool/.gitignore
@@ -1,5 +1,5 @@
 *.d
-bpftool
+/bpftool
 bpftool*.8
 bpf-helpers.*
 FEATURE-DUMP.bpftool
-- 
2.20.1

