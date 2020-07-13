Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1D21DF16
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgGMRra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgGMRrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:21 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2979CC08C5DB
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:21 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q4so19010271lji.2
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AyMfG/HsKAqlEgMq6Li9Y2u77ypCGbN506NWO50QX3Q=;
        b=UbVbBF9JMEf2IYzaTLaA8hdc6cE25wp+3t7yNtDUTZdpBK6t70DZLbPHnYLPdhPlkQ
         igvwHgibT54icmNx/nmJe5wNlTBoHUJGUUVH7qHs6NqekxongxFne1hpNHXzrtqDo3Q7
         zaCuq9LHKSfNrGn57njCAO3he3gKmRJnObgmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AyMfG/HsKAqlEgMq6Li9Y2u77ypCGbN506NWO50QX3Q=;
        b=YzJKnMsyK4gTqd5rVW5QoOXKie367XaqvsZgpWKFPHEeW/zHXa/R2nJ/BW9BChDCfo
         pKSCGjmS35c0FhslTT57oxTH73El7rx1CihR/uzOcb9sAaE02xoXsbsQNIXPpczYtDt2
         Ab8Cg4sc1m/Un4d50+NYNEm6TQ0qiy7JAWvYuhoFFx4Tikosr1DGbJQSEiu8XCjJ5gkM
         Q8cokQAs1XtWIaBn6LNAFB6/RQjZQv20ayjs3qAHuSA8shzuUFprSsm40ZkND4NFGFuP
         8175T09ye7arc0VNG/EEs1uo0XJghJI9oQcVXdzRugQfxWmokIskpygtIXvRBjIcL3H2
         c3pw==
X-Gm-Message-State: AOAM532eKFsog2mE67p+X2LOYmYkUtGiHd5aIhzAdbF0cjW6QQLZVVCg
        qG0yncdjBJqoysm/TZm7/l7d2g==
X-Google-Smtp-Source: ABdhPJwQq0qg5FqzJIChrRpnHkyul5R+1XxHa1aghGXAgvsN05JN3+Ivn0/IlZixXaesnmc/lD1fMw==
X-Received: by 2002:a2e:8855:: with SMTP id z21mr386110ljj.325.1594662439641;
        Mon, 13 Jul 2020 10:47:19 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a22sm4734030lfg.96.2020.07.13.10.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:19 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 13/16] tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type
Date:   Mon, 13 Jul 2020 19:46:51 +0200
Message-Id: <20200713174654.642628-14-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpftool show human-friendly identifiers for newly introduced program
and attach type, BPF_PROG_TYPE_SK_LOOKUP and BPF_SK_LOOKUP, respectively.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - New patch in v3.

 tools/bpf/bpftool/common.c | 1 +
 tools/bpf/bpftool/prog.c   | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 29f4e7611ae8..9b28c69dd8e4 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -64,6 +64,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_TRACE_FEXIT]		= "fexit",
 	[BPF_MODIFY_RETURN]		= "mod_ret",
 	[BPF_LSM_MAC]			= "lsm_mac",
+	[BPF_SK_LOOKUP]			= "sk_lookup",
 };
 
 void p_err(const char *fmt, ...)
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 6863c57effd0..3e6ecc6332e2 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -59,6 +59,7 @@ const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_TRACING]			= "tracing",
 	[BPF_PROG_TYPE_STRUCT_OPS]		= "struct_ops",
 	[BPF_PROG_TYPE_EXT]			= "ext",
+	[BPF_PROG_TYPE_SK_LOOKUP]		= "sk_lookup",
 };
 
 const size_t prog_type_name_size = ARRAY_SIZE(prog_type_name);
@@ -1905,7 +1906,7 @@ static int do_help(int argc, char **argv)
 		"                 cgroup/getsockname4 | cgroup/getsockname6 | cgroup/sendmsg4 |\n"
 		"                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
 		"                 cgroup/getsockopt | cgroup/setsockopt |\n"
-		"                 struct_ops | fentry | fexit | freplace }\n"
+		"                 struct_ops | fentry | fexit | freplace | sk_lookup }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
-- 
2.25.4

