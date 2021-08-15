Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20E33EC7BC
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 08:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbhHOGvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 02:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhHOGve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 02:51:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A755C061764;
        Sat, 14 Aug 2021 23:51:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso22359152pjy.5;
        Sat, 14 Aug 2021 23:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=thuEpYTiM1U8+AJeygFq4zHWuS3MrIl/T2LAUyDKeNU=;
        b=ntrECijhAqGRrpX3Fcl4l+lIJ5Ki4Fiui9VcuQzNsyVmTBN0/gjDLi+vFVi0uk0RpY
         xoHumKDDfghQc7Q44HK0rfpSEc2aWuQKHqLzglVRdRlc/xVhVIGEClCb9uAp6S6okTqZ
         zVL3cn6hQ3piPtbbgDZTUbpJH3JE8f1cKsW8KmwNQ1k3sXvjAm5CWNRzaaKAwsLRRYlS
         /onB59oNP2cTLgTe9gFkXfLnoojTgVhd5Tm48WrDsJiZaTWeU8OnDXs9gAxNAYmPEGfx
         vHnzs++W3vK+1xcRFmahyamuQG1m/yzvxOQMU5LAlGSCndQuWOONYPIeTxKjTQcoeGjV
         yj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=thuEpYTiM1U8+AJeygFq4zHWuS3MrIl/T2LAUyDKeNU=;
        b=CGmZYie97zV6PP/3Rdg3uTIqyBBBx1+JHlue1U3GItLahFXeiZS/GvOcayuCGRr5fR
         IZ4bZFjdT4jh0SYB+RZfpZ4cpSqMZNQigApKuT56wMP5OgskoAcOyW1Ghw29GRUAA+bs
         M3F4CFSgNHFUZPKLCziTOheaD7xwpOnTeMCfgv2j9SwoJIHJovMhDcUHc7hGqH2rgFhY
         Mzp4bHxX9w4bm5223q745/J+J0DewyNE+KIn/oQHKTTi/zQqZq8DAUF4yEE6n8Lm+6Je
         fYmFSj5irnuctCN3RtA2PcHUjRf4EpQqvvar2vHuRYVxOgMzLYXYjvLs7kKWvN3QUGe/
         pd3A==
X-Gm-Message-State: AOAM530UMbpqAdBwDdDCWq3J2oPYIGJqgV8CyZJcaCSW+X7qjBm/JnVS
        YsAMw4I1CSs/dtOA7cqm2Bk=
X-Google-Smtp-Source: ABdhPJywcfvIEYb4s9hDgsPcDVKaYP8GH7oz2zwz17dv0SixUG/FTzyOHxoMN8GbdjMMYlIoyb5hwA==
X-Received: by 2002:a17:90a:c085:: with SMTP id o5mr10560376pjs.113.1629010259867;
        Sat, 14 Aug 2021 23:50:59 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.196])
        by smtp.gmail.com with ESMTPSA id pj14sm5943221pjb.35.2021.08.14.23.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 23:50:59 -0700 (PDT)
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] samples: bpf: offwaketime: define MAX_ENTRIES instead of a magic number
Date:   Sun, 15 Aug 2021 12:20:13 +0530
Message-Id: <20210815065013.15411-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define MAX_ENTRIES instead of using 10000 as a magic number in various
places.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 samples/bpf/offwaketime_kern.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index 14b792915a9c..4866afd054da 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -20,6 +20,7 @@
 	})
 
 #define MINBLOCK_US	1
+#define MAX_ENTRIES	10000
 
 struct key_t {
 	char waker[TASK_COMM_LEN];
@@ -32,14 +33,14 @@ struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
 	__type(key, struct key_t);
 	__type(value, u64);
-	__uint(max_entries, 10000);
+	__uint(max_entries, MAX_ENTRIES);
 } counts SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
 	__type(key, u32);
 	__type(value, u64);
-	__uint(max_entries, 10000);
+	__uint(max_entries, MAX_ENTRIES);
 } start SEC(".maps");
 
 struct wokeby_t {
@@ -51,14 +52,14 @@ struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
 	__type(key, u32);
 	__type(value, struct wokeby_t);
-	__uint(max_entries, 10000);
+	__uint(max_entries, MAX_ENTRIES);
 } wokeby SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
 	__uint(key_size, sizeof(u32));
 	__uint(value_size, PERF_MAX_STACK_DEPTH * sizeof(u64));
-	__uint(max_entries, 10000);
+	__uint(max_entries, MAX_ENTRIES);
 } stackmap SEC(".maps");
 
 #define STACKID_FLAGS (0 | BPF_F_FAST_STACK_CMP)
-- 
2.17.1

