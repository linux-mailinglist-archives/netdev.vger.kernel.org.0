Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DFE560740
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiF2RTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiF2RTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:19:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B4E1CFFD;
        Wed, 29 Jun 2022 10:19:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o19-20020a05600c4fd300b003a0489f414cso38963wmq.4;
        Wed, 29 Jun 2022 10:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4nADTKeLD2xTEnrpqrxwkxFoYTSDirzPyX0vZg0rTsM=;
        b=N1AyvilMJRoh5IetQt38Sjs59abbCcMZBDXO3lHpiwBivsIbw8Smy7eeK0+yz5zDGX
         ZkYNvRUQkdf/tiMgO4tFDWnw3kVN4MQfUQym08ZXwX/LSbNnAe9LH2vJVUKLZAj2JKKc
         dhrsKDrfgv5HosHCZmIhe+Q/vc0MXUgi+03EGmIdeqhBvIpvCbkpHZlRljqNeD1EbR4/
         KUBIsrMwYSpNQnSN4uSt05W9QDWNNMGjNrZn/mE+hlzzZVrzN+FtjfWVcO7X3lYCPTek
         6wFasx7AjYU0TYG3dG9MgXYvfsT2nHzmb/2mQms/tAB5rC+pftvCsh8GbPqkZUAl4yhR
         EmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4nADTKeLD2xTEnrpqrxwkxFoYTSDirzPyX0vZg0rTsM=;
        b=0gP/Qb2mBnE952iDjcVppBb7NzFq/rpF9M7/7TFaB93IqoMG03wwQ3xCxR5mk5kWvv
         ty/VdevmwzQnh667OpOMhjtAEAFtWY/JSeQCcS2SHp42IWE33EjhN7YsE6vW4wcVqAaA
         buE+1tElDQzc0RikGg2F6sFW9Ab25At4re0+Yl9t0JGUmXadUBZ+HJJP6qwwydceExr+
         sqDW1yPbe+KXSAm9kkQ8N+iWEQJikQgLvz8iEL1Y4C37i2mFrdL9dc7QpWJ0dALFSupS
         8jgiO2iP/o0zsdjcMOcr2OvCpmUuCJ2tlywyGr8FKCs+Mz578whz2YpTFyTrIci3ybz/
         mhdA==
X-Gm-Message-State: AJIora96BDtIgUz+OWap+SB/kLDhI/9dkNdefzWmDF0UsH/VNcm9A9bw
        C9tnULz5sr+rAIJiJDdYgg==
X-Google-Smtp-Source: AGRyM1uowr7j1Na59IcvC1skgsVTVpFFaFz5VJbJRxTrsPqGs559NdTRDzYM8mvP9v8Je4w3Z+7sRg==
X-Received: by 2002:a05:600c:198e:b0:3a1:6db7:fdd0 with SMTP id t14-20020a05600c198e00b003a16db7fdd0mr3593678wmq.14.1656523174670;
        Wed, 29 Jun 2022 10:19:34 -0700 (PDT)
Received: from playground (host-78-146-72-11.as13285.net. [78.146.72.11])
        by smtp.gmail.com with ESMTPSA id 23-20020a05600c22d700b003a018e43df2sm3729572wmg.34.2022.06.29.10.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:19:34 -0700 (PDT)
Date:   Wed, 29 Jun 2022 18:19:30 +0100
From:   Jules Irenge <jbi.octave@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Elana.Copperman@mobileye.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] btf: Fix error of Macros with multiple statements
Message-ID: <YryJosfh8z2DhKC0@playground>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes an error reported by checkpatch.pl

ERROR: Macros with multiple statements should be
enclosed in a do while loop

To fix this a do while(0) loop is used
to encloses the multiple statements.

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 kernel/bpf/btf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1bc496162572..95c1ee525e28 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5057,8 +5057,10 @@ extern struct btf *btf_vmlinux;
 static union {
 	struct bpf_ctx_convert {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
-	prog_ctx_type _id##_prog; \
-	kern_ctx_type _id##_kern;
+		do { \
+			prog_ctx_type _id##_prog; \
+			kern_ctx_type _id##_kern; \
+		} while (0)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
 	} *__t;
-- 
2.36.1

