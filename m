Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D84F0A43
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359064AbiDCOpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349257AbiDCOpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:07 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FC4396B2;
        Sun,  3 Apr 2022 07:43:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q19so6287247pgm.6;
        Sun, 03 Apr 2022 07:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sR1PYjJd65B0ytgSsHdKVZKV5nNYshMABOqYKn9lox8=;
        b=LZi8IzMnimNyLNBd6suPuAINdu/e7qwXK8VryE4oBrkMpsDkKcZSboMZ2I6yMzNf21
         /YMJNbVSVk5onxm9BfDazLxkmVRIW+TvCc1HMf2LKCexSgMFsquV2xIWxDYxd40S5mwU
         L1RxhSG6NOPHZnerj2YSoM7t2s+NKLHISfUjD6wknBa/7vvcIvs42mb0k6U//mcMcW7I
         LA6DrRiO2IHbOaudYKijfwcg5PvW0eHbFDcQ9FmuYqHkoeGfyqctKHFi0j5QOzlO2FZ4
         Vb8tiMTm1scJE8mlKoPy/zV7ekXKeXpm7SVWZS8QCqjemp7PTXmxj5MDSq4mXECBMg9w
         UwsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sR1PYjJd65B0ytgSsHdKVZKV5nNYshMABOqYKn9lox8=;
        b=Ed7eXffwxEiDg5rXZ5IUFAihdYRl9J9oxPPAsz4F6BKzEydvAyshg+LZtKlyvpZfK0
         8hq/qYNuB+Rd6a2x7SEp36GoLiiSM5EvFMie8hQF1VFR+DKI4VPIC+ihiYxKKmw7QLqE
         +/2RxSWPFGRl5K6uEJ0xqqIUGKXf7m/yh0lpfkDEcytLpc6KjC7yyAl1Z7/Z46bMJImx
         dKjHy/3KUIJfUxQDNzf55lNtKc+CUiPaP6KSifeQ3bUirFGTdimDHLEence047qSuepl
         hRXF8uR1yrswXP84Rp6Sdwd6xkGYbVqWl2FRLT14eCY/rFXNFzM6E7bXgU4Vs1W5WauE
         m2EQ==
X-Gm-Message-State: AOAM530Qm7T4vQfPSLJ1dgzQOy3btPPEwQ8k7pbVKz2T2hvS15Kli+VL
        8CAWXA/oVQ4666m+gbLhTX4=
X-Google-Smtp-Source: ABdhPJwkGCeaXYeYfgt/uFJDdPmmT52oIMZVi/me70gQQfAfgDjXbRmQE6+a6KdTnjLBDuHA+Qlr1w==
X-Received: by 2002:a62:1ad3:0:b0:4fa:686f:9938 with SMTP id a202-20020a621ad3000000b004fa686f9938mr19906721pfa.6.1648996993265;
        Sun, 03 Apr 2022 07:43:13 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:12 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 3/9] bpf: selftests: Use bpf strict all ctor in xdpxceiver
Date:   Sun,  3 Apr 2022 14:42:54 +0000
Message-Id: <20220403144300.6707-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
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

Avoid using the deprecated RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 5f8296d29e77..1be14e0c236e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -90,13 +90,14 @@
 #include <string.h>
 #include <stddef.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/queue.h>
 #include <time.h>
 #include <unistd.h>
 #include <stdatomic.h>
 #include <bpf/xsk.h>
+
+#include "bpf_rlimit.h"
 #include "xdpxceiver.h"
 #include "../kselftest.h"
 
@@ -1448,15 +1449,11 @@ static void ifobject_delete(struct ifobject *ifobj)
 
 int main(int argc, char **argv)
 {
-	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	struct pkt_stream *pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
 	struct test_spec test;
 	u32 i, j;
 
-	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
-		exit_with_error(errno);
-
 	ifobj_tx = ifobject_create();
 	if (!ifobj_tx)
 		exit_with_error(ENOMEM);
-- 
2.17.1

