Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE20741D04D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347813AbhI3AB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347771AbhI3ABS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:18 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C43C061769;
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k26so3358914pfi.5;
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=anUq0BRPmpOyj2S2DlCkp3QunGCpzoqv5MrMJAiNyOE=;
        b=D2BiOSU+wFIghw9j/LSZ9a6Vl4ZGbh5G0LABXB+Ue94v/A71f50alRV9F3ljqIFmq5
         T7iRBEh3dL2rPuNlGbmEHU/eEh3ELuc4H2e832yB3OGwYPEfRSu/DGcPnVC89xYaVdg8
         yFVTc2DZcQV/pK4s5OQzud8yHoNeOT+ZWzwRT9OQWpV6p7qxR8BUrNpT5ZV2IbX09Uc6
         RfNAaIwklTrSjhniRdZgaD7jtLJLL7EtCzo79Nc6bBlL0Eo6Vf3qPZOsveq+i5HQ66ep
         97OdYGjM/brn4N3IaA+ZLF0U33MQO+cvmmCWW9o5idCuU2g7kKv62Q/om/551OE38zeK
         3iwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=anUq0BRPmpOyj2S2DlCkp3QunGCpzoqv5MrMJAiNyOE=;
        b=PYlDzGHKtsyedSBQmxT9vjeDP7sZrOFviIafnloq5x+JKOaOt6uB1IwyJSwfvNSuse
         sorL2YNhd73c0vVqVuvED0jQoH5hRaWJ0ZtitapA50EitMBh0AoojF3+bIpVyIO3/65A
         oRoAmPf9GeZyAQ4bnz8sZ1yqu6hkfv+e7GZtb6uDh6wnLrR2oPljN4Ip1+P6WTpbSQPt
         IJTBhLLQAFuwfxqxG1YZ2nnSBDcjZaKtz3GCxINc2OvoYRxzhx8vgjx6V2uo8n16gT/f
         6e93vZG+VRx+aCdTZOWdGK3gedw+/sHH69VOoqzHA9w1GNUWHuBS6nLiLY+fMlU+WQVG
         2sNA==
X-Gm-Message-State: AOAM5327b8Y5CY67LpwwZFxDFXA/koqAQKIMG/hZxGoXYXBqIREQLrTA
        Bd8aAFdXWxHd+Gtzl2QTlA==
X-Google-Smtp-Source: ABdhPJzOnUPVONC8c7/o4gCFDzx/tyd7K5ases9cqhro7hUL9E9tvXDAzZAw8e/cfOLFKyBWVsi5Kg==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr2291741pgh.7.1632959976392;
        Wed, 29 Sep 2021 16:59:36 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 07/13] bpf: Register BPF_MAP_TRACE_{UPDATE,DELETE}_ELEM hooks
Date:   Wed, 29 Sep 2021 23:59:04 +0000
Message-Id: <20210929235910.1765396-8-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Tracing programs may now load with this hook. There is not yet a way to
invoke those programs.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 kernel/bpf/map_trace.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index 77a55f8cd119..d7c52e197482 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -335,3 +335,26 @@ void bpf_trace_map_delete_elem(struct bpf_map *map,
 	bpf_map_trace_run_progs(map, BPF_MAP_TRACE_DELETE_ELEM, &ctx);
 }
 
+DEFINE_BPF_MAP_TRACE_FUNC(BPF_MAP_TRACE_UPDATE_ELEM, void *key, void *value, u64 flags);
+DEFINE_BPF_MAP_TRACE_FUNC(BPF_MAP_TRACE_DELETE_ELEM, void *key);
+
+static struct bpf_map_trace_reg map_trace_update_elem_reg_info = {
+	.target = BPF_MAP_TRACE_FUNC(BPF_MAP_TRACE_UPDATE_ELEM),
+	.trace_type = BPF_MAP_TRACE_UPDATE_ELEM,
+};
+static struct bpf_map_trace_reg map_trace_delete_elem_reg_info = {
+	.target = BPF_MAP_TRACE_FUNC(BPF_MAP_TRACE_DELETE_ELEM),
+	.trace_type = BPF_MAP_TRACE_DELETE_ELEM,
+};
+
+static int __init bpf_map_trace_init(void)
+{
+	int err = bpf_map_trace_reg_target(&map_trace_update_elem_reg_info);
+
+	err = (err ? err :
+	       bpf_map_trace_reg_target(&map_trace_delete_elem_reg_info));
+	return err;
+}
+
+late_initcall(bpf_map_trace_init);
+
-- 
2.33.0.685.g46640cef36-goog

