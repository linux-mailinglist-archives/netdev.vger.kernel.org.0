Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200053DA916
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhG2QaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhG2Q3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:29:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C66C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:49 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id u15-20020a05600c19cfb02902501bdb23cdso7247631wmq.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fc+7RwYnjdQczVrAOaEk6yAXkkOw0SL9ZR500UN4OHs=;
        b=cZqx4pfCSl2Qs6vBSXYE07eN7BXk6chw5uIrB8P6F9qFok+hHRcoch0p51SaVLm8lS
         6uf8KUrM48BVocBLvXzQAuIPa93keLBjcbTrlgqSRQyX7qAY57s05P1hos9N3RyweanJ
         Z3H1k+MfvwTJqysS3h1jMlo+DgTss2FqluqMVplRBv44XZEZkrLtT+ZDNjHjpVKNWHmv
         SeaE5kxukgiNkNcskdG8Z7zkABbpFoNukAm4jZruQciVDBxzEbNfn4XFGF55lvkrYNZ5
         EYe2Zb8Q8k17eMvdYkKEPheaSuJj2lf8qCJs1DPQVjfg/nvxb/FRYEoZV3nQCGUSCXtf
         GZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fc+7RwYnjdQczVrAOaEk6yAXkkOw0SL9ZR500UN4OHs=;
        b=LutzNnMEBVRXQW4N6ij6UQ8cAyRhHIJVQM9T1e8NQzRw482mCKnkc9eRJtGVRIUwxu
         dKKR/b6CG9D8WZ2dRadQ3cRCPQjM6yL126UITmJ8yxRt4dhAT13TNLt+URPSWiYOQzkY
         B2uHfUJEhnD68/49QQUrLmQx5qXK8fALy/rZeI7ARVdA/vGDWaprgAUvGm7yayjpQHUL
         TqQxGmtSqMav2muY1g2Zd0Hx4zk7VhWmGiGiuXoKZAbRw2bnBZxb2UGxmP9gFw2rqUDY
         b9eOpZvfaA5sCHa4dO8/FdBHjjIh+2jpvu1Fb53b+TpYN3Wssi506LsdZHmnFAxBlGki
         hi5A==
X-Gm-Message-State: AOAM531y9+WevAEHy0DV7qlFMbNdMojLy0Tgoca1Zlr7wa/3vRMvyVGf
        y02j39VzTLGNXwEOR7RKef1Qkw==
X-Google-Smtp-Source: ABdhPJwAs/gG6cf6c5K+lCBTXUDkoXxJXh99JfX3r0FFJo4HxQdJzDqMt1VSGXiciqEC2nFC47uAgg==
X-Received: by 2002:a7b:c84e:: with SMTP id c14mr2585105wml.94.1627576187540;
        Thu, 29 Jul 2021 09:29:47 -0700 (PDT)
Received: from localhost.localdomain ([149.86.75.13])
        by smtp.gmail.com with ESMTPSA id 140sm3859331wmb.43.2021.07.29.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:29:46 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 7/7] tools: bpftool: complete metrics list in "bpftool prog profile" doc
Date:   Thu, 29 Jul 2021 17:29:32 +0100
Message-Id: <20210729162932.30365-8-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162932.30365-1-quentin@isovalent.com>
References: <20210729162932.30365-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Profiling programs with bpftool was extended some time ago to support
two new metrics, namely itlb_misses and dtlb_misses (misses for the
instruction/data translation lookaside buffer). Update the manual page
and bash completion accordingly.

Fixes: 450d060e8f75 ("bpftool: Add {i,d}tlb_misses support for bpftool profile")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool-prog.rst | 3 ++-
 tools/bpf/bpftool/bash-completion/bpftool        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 2ea5df30ff21..91608cb7e44a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -53,7 +53,8 @@ PROG COMMANDS
 |		**msg_verdict** | **skb_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
 |	}
 |	*METRICs* := {
-|		**cycles** | **instructions** | **l1d_loads** | **llc_misses**
+|		**cycles** | **instructions** | **l1d_loads** | **llc_misses** |
+|		**itlb_misses** | **dtlb_misses**
 |	}
 
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index d33b8f308a4c..17a5032b7325 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -345,7 +345,8 @@ _bpftool()
 
             local PROG_TYPE='id pinned tag name'
             local MAP_TYPE='id pinned name'
-            local METRIC_TYPE='cycles instructions l1d_loads llc_misses'
+            local METRIC_TYPE='cycles instructions l1d_loads llc_misses \
+                itlb_misses dtlb_misses'
             case $command in
                 show|list)
                     [[ $prev != "$command" ]] && return 0
-- 
2.30.2

