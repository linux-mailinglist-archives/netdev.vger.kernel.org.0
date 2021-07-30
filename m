Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7534D3DC08B
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhG3V4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbhG3VzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:55:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A63C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:55:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m12so8231447wru.12
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dDDdCBezO0q2xn1HrTWdc82ZrINOyLuTt9BwXTZEhF8=;
        b=G2DzobJSvCw3qqqzH9OqjS0dIjT5X/cnrYNLGB9hnoEevR048BZUjdhz/Otb+x6l5N
         2nVZ4CNVh0qnNtjK2DQvi1/4ebJP6pw4UD6jSasYV8QzL/OL6Zk61zfc4jkbFnc8t9tB
         pIJTJGg5iZcPYmbka1/bpR718p8fSbZMfadwkp7nGtMDxOW/y1MduA/p+pste+Vjx9aR
         pjWe+zaP7r2AeAJX6667fIgdbZF6ZJIr84SE9Lr9GcHALwQXFrTW9znGfo+9W4AhTwNt
         BH7xD4+o0nFfuxmAn9YLM9rhDnaWh/XcVg6pPD7O4aYgZncfv/vujzxBA0/+Pm5jddUk
         ECHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dDDdCBezO0q2xn1HrTWdc82ZrINOyLuTt9BwXTZEhF8=;
        b=tCQhqnpnsCDimebUSuy1GplZ8Slvr33LosQikUTxHzxuneziqmSMXqbj3Ay6ZUEV0H
         oRk+4WSJNuxlzV1QLLcqbo5NjHFdlLuJXi8MJ/L4zRR5suU9Is4CHws8EnTfdhwDAqI0
         uu3RCEThge5WIVteOUuwnAb9mSBzNq/HtMQTGGwlKV+D7NSl8m/9TjXhkaySYHdbBMmO
         hE1oba9rBLHfZhfq9pjbqlYjfUC0UGyNPxqFS+pHmtv48fc0SAXaUo/YJnuFtvAcRgGB
         GgZ0QhE7qP1phwe6seBfYGeQ5o9OdJ2F4fShOHmaFNbmTvwdD/RbDFTFvyRPnILsZJz9
         Z1/Q==
X-Gm-Message-State: AOAM532sLxz+UwPdnR7ACS0tuR1DS/cTLg2UgXdFBDIbS5VtVARBl8dE
        jcgiOHAQSN+zDpiY3P9jI9Y7aQ==
X-Google-Smtp-Source: ABdhPJyMaZADHSkB2SRMrAKV4ybbQTJjpoepbt4GCUENVaYGrfRPnW1130OXjldpwmoVaQIk0ag6TA==
X-Received: by 2002:a05:6000:18c2:: with SMTP id w2mr5297081wrq.282.1627682100501;
        Fri, 30 Jul 2021 14:55:00 -0700 (PDT)
Received: from localhost.localdomain ([149.86.78.245])
        by smtp.gmail.com with ESMTPSA id v15sm3210871wmj.39.2021.07.30.14.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 14:55:00 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 7/7] tools: bpftool: complete metrics list in "bpftool prog profile" doc
Date:   Fri, 30 Jul 2021 22:54:35 +0100
Message-Id: <20210730215435.7095-8-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730215435.7095-1-quentin@isovalent.com>
References: <20210730215435.7095-1-quentin@isovalent.com>
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
index 134135424e7f..88e2bcf16cca 100644
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

