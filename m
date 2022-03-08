Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013204D0ED4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 05:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiCHEqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 23:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiCHEqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 23:46:14 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6DB2F034;
        Mon,  7 Mar 2022 20:45:18 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 132so15406172pga.5;
        Mon, 07 Mar 2022 20:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yp4XOV099+8KsjwVQiajLdJYpcZJrSJVKo5Wf41XMi8=;
        b=QHI84cHVmSwSoO2tyNVe5iGb4gKbOv/ABZag9JmtRrCyTwa23g+0au1vFyxpIoBk5Q
         OetNzX8dNPvw/wse4800/DYsCnGgvhBiXEl6e/4cUhtYzNwD/vgg1wMOkhpHRPxAB4NY
         p32TR/wU+dtlg4BqxOGRXn+Nj4wLYjVJgM+g9eQuqJMJutwgvv/ZNW2RrBKDL6+kaOle
         pz2uUhhAcqVwbyZDb6q2EI6KPhEzUrjaK/5EKG7zJPY5fK8Y7cYXuGor/A4I5aqtRl4H
         unG1l6g0tH/ng1JxAMlKoKqKYaokYj3finNdBfvMmaH1QGl4y4emn/fqDWueAEy6OLEQ
         v+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yp4XOV099+8KsjwVQiajLdJYpcZJrSJVKo5Wf41XMi8=;
        b=xHaY9DqIrLnNy695Uyk9CJefE39B+iOmMLqVd4ev1JUm2IdSYamWL/O7r4l9maUQhz
         u2/OXiQjCmzvOO6sDH8cFLidQMLqUXYj5d0iL5UwshE6R395s2XEe9fNbKlKq/QY0uh7
         HKJdd+DHU0IF/kz8zr7emOaYUD9Gi248chfYdlngcj460kYFLBzGDsE3qhGThD+0oxcU
         JfaiJgSBRCJSos6Zh71T1QypLoDhC7frO//Ftm9BrHGzro0iZ/Idevzp6asLUAvMcc5j
         K8EsUvRrT4gunQnknDDAGDuQGiZUHd7GEZmPxp7jjfyAMBq8fOWe35G+OyMVWJfyEUeC
         km+Q==
X-Gm-Message-State: AOAM530FX88o9RQdXxbIUdIDeMMleLxZKZ/+cbJb0vg0stH/+hMqpu4o
        Kyu8HdYLcmXHwGwVRadKED8=
X-Google-Smtp-Source: ABdhPJw3KNVBabWHI90FOifMwoskaCmEEWI2OlnSyaCuukWxxfkGwDHTtACAaEbDyKPg3A1X6wGTVA==
X-Received: by 2002:a65:554e:0:b0:34d:f721:7fef with SMTP id t14-20020a65554e000000b0034df7217fefmr12753728pgr.476.1646714718231;
        Mon, 07 Mar 2022 20:45:18 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a0023cc00b004f707cc97f9sm5174022pfc.52.2022.03.07.20.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 20:45:17 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     quentin@isovalent.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        ytcoode@gmail.com
Subject: [PATCH bpf-next v2] bpf: Clean up Makefile of bpf preload
Date:   Tue,  8 Mar 2022 12:43:39 +0800
Message-Id: <20220308044339.458876-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <56b9dab5-6a3d-58ff-69c9-7abaabf41d05@isovalent.com>
References: <56b9dab5-6a3d-58ff-69c9-7abaabf41d05@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trailing slash in LIBBPF_SRCS is redundant, it should be removed.

But to simplify the Makefile further, we can set LIBBPF_INCLUDE to
$(srctree)/tools/lib directly, thus the LIBBPF_SRCS variable is unused
and can be removed.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1->v2: get rid of LIBBPF_SRCS

 kernel/bpf/preload/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 167534e3b0b4..7284782981bf 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
-LIBBPF_INCLUDE = $(LIBBPF_SRCS)/..
+LIBBPF_INCLUDE = $(srctree)/tools/lib
 
 obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o
 CFLAGS_bpf_preload_kern.o += -I $(LIBBPF_INCLUDE)
-- 
2.35.1

