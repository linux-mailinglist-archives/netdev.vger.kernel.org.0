Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81AC4A66A2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbiBAU5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54914 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242628AbiBAU5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 378F3B82F92;
        Tue,  1 Feb 2022 20:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC79C340F0;
        Tue,  1 Feb 2022 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643749026;
        bh=CjKRajP1hyPG6GHtEcC8S1cRRiUsFDVkufEo2oeRcYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHhT8p9EI3H/jMYWEdBQhX57o8+L+vIC3+tLN4xs6ZNWLxeJKKUB05GTm3uPyKZJP
         n+1HQRKXDjX88fiYj9VEC1k7DxhEFOBPiveXCGnh7QWajpO8gdfbTdFdZTR9DERIZ9
         pKcGOkI5jhSUqUulKJjjhkEBOxqo5TVQQx0Iz3k6KELSay+iCNX+4K7B33Tlcxjy93
         afxH0sb7C88bZioAMSRlSCT2D+TsilmQQw4MQfy8OJKw5eLQ2d1TChcRATvmZJ+3o/
         UBo29e/0n6vyImBfvW0YptV1u6izC8zLkHsj0DWCYL7JnskXjvERbE/PVIC6ufl01T
         /Q1aiZ0bGchMQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH bpf-next 4/5] lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
Date:   Tue,  1 Feb 2022 13:56:23 -0700
Message-Id: <20220201205624.652313-5-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
References: <20220201205624.652313-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that CONFIG_PAHOLE_VERSION exists, use it in the definition of
CONFIG_PAHOLE_HAS_SPLIT_BTF and CONFIG_PAHOLE_HAS_BTF_TAG to reduce the
amount of duplication across the tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/Kconfig.debug | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6159859769fa..bd487d480902 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -323,10 +323,10 @@ config DEBUG_INFO_BTF
 	  DWARF type info into equivalent deduplicated BTF type info.
 
 config PAHOLE_HAS_SPLIT_BTF
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
+	def_bool PAHOLE_VERSION >= 119
 
 config PAHOLE_HAS_BTF_TAG
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "123")
+	def_bool PAHOLE_VERSION >= 123
 	depends on CC_IS_CLANG
 	help
 	  Decide whether pahole emits btf_tag attributes (btf_type_tag and
-- 
2.35.1

