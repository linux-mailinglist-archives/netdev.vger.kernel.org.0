Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55433394944
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhE1XzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhE1XzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069A3C061574;
        Fri, 28 May 2021 16:53:40 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z26so408654pfj.5;
        Fri, 28 May 2021 16:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Agy9x6Mg8As0SqD+0oLSEwC0oEqk9fEZ+8467L6XkQ=;
        b=HY9k/UkijCOBkH3ui67wovUSEgGGVINUOmjrom8ZbKCTMwsc6ww/XaaexcXLikqtdJ
         4AKi3RCpqpkgi8Babb/WClnTqNVZ9Sn3mdtwrsU8PhDYUHYEviwawY5nLIQKbk8bt5/f
         UemAoEDFNxai8LAJeduJRCb187SWQOTzMOy/NpIN8R9OdN2ZOVbTlhWNsFzLTLGoP1YZ
         sBfbmBa+FXXMnwqabILcDQQmY77tWh9SVlLmFCjLH9uwuhosTqnOSD2EtZ89GggRFDd+
         aCzw0WBOM1GSIVKtri+zDhjwdSnwU/Stc8H42Dt+bREMNydiHwCUTdzYGhvFs8OpsBMo
         eCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Agy9x6Mg8As0SqD+0oLSEwC0oEqk9fEZ+8467L6XkQ=;
        b=f2Xw1EIqc7IO26I26nISd/v45YAeWGhZJXnd9Wx8CLgx+dSk6V2+ooSufHZny9Ghdu
         oCW/QU61ZBulHnYYD3z0EsBaGt0NojJDaUAdMgL5LRHTo8H6qDDHMpPFnpeSfRjrjejh
         RnAiJzbJNl8avmc7iONgVdKk2iPXHU5AtUcXhSTdvFvyhZEU6zoY6SgcnL6Juevb0X8J
         n2ygLJQ6hIAOtSMLiIjr8ofDX5VXBpmg6Tiwy57RSbM18fZ8AId9+TGhscdbz/NFANfs
         GPmtK5kn76RIxyHLP7sx4R7CFfgVLkAqsTVi1OTIxUlpRrR/8vluRyNURis+mTcOtSa2
         r4Fw==
X-Gm-Message-State: AOAM533nQ4/9fXaPpMce2s6NF/xFaicmxTy2O2sfCARbWTYL/mqcgG4o
        wNKhHg46bgOR0/bO6LVkXpkYvxTQ8Yw=
X-Google-Smtp-Source: ABdhPJyjX4Hk/LGUFfPGemqT8kCp5nhpWS/6dbFDFf1MEyMalxl9iigVsR60g88pzPWWjMHl1lQAjA==
X-Received: by 2002:a62:a101:0:b029:2e8:e878:bdc0 with SMTP id b1-20020a62a1010000b02902e8e878bdc0mr6227257pff.38.1622246019349;
        Fri, 28 May 2021 16:53:39 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id o6sm5304430pfb.126.2021.05.28.16.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:39 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 01/15] samples: bpf: fix a couple of NULL dereferences
Date:   Sat, 29 May 2021 05:22:36 +0530
Message-Id: <20210528235250.2635167-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When giving it just one ifname instead of two, it accesses argv[optind + 1],
which is out of bounds (as argc < optind + 1).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_redirect_map_user.c | 4 ++--
 samples/bpf/xdp_redirect_user.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index 0e8192688dfc..ad3cdc4c07d3 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -169,8 +169,8 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	if (optind == argc) {
-		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
+	if (argc <= optind + 1) {
+		usage(basename(argv[0]));
 		return 1;
 	}
 
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 41d705c3a1f7..4e310660632b 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -130,8 +130,8 @@ int main(int argc, char **argv)
 	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
 
-	if (optind == argc) {
-		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
+	if (argc <= optind + 1) {
+		usage(basename(argv[0]));
 		return 1;
 	}
 
-- 
2.31.1

