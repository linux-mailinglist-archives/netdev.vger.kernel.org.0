Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E934F412E
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387191AbiDEOaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbiDEOWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:22:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0986A433;
        Tue,  5 Apr 2022 06:09:46 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id bo5so12048814pfb.4;
        Tue, 05 Apr 2022 06:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6m7ShcbASdrto/3TsaoHbBXRCyYeXuWGLlXaER69zS8=;
        b=OSQiFVkSzzdo38CkZyMYBw1cWEhozWr71fgIEwkmRokuJmsa6OfIdmGOHPyKVK8vOC
         z8VvyKZZWxj012CK6f5dln/zgBaYFiUp2cY4uS93vOTwCsx4xrOHY9Zb72xnHhms2Lh8
         YNVsWSLFmQvKIvNVbFjj5RU9S8W5eYaJbyplCDAwtLy96FrrVLb676yZGyR1cgJcpPDs
         Z3QJcrXNqFkdN5RxX1BATSptpGSSyEZSrPhAb76i6LcegqpL7iEoB1VkJjFFT4AbwBT8
         cieKdNo9+bqmPy4GqMdq2CH3l+01Zfp/2juhp6F9834jEnNylc/POBHb/ZyYQ9cUYrPm
         vBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6m7ShcbASdrto/3TsaoHbBXRCyYeXuWGLlXaER69zS8=;
        b=49NcARhslURQaEPXuEpQPwUIOZosS5BD+mvVFu2JdzVniA5Q/PSz+GvsAe1MIokFvJ
         EZip2a4g5FFnUh1hj6C4HvjFKzK6Q28Kaw9XnxC4tYm+JHh/gFy7i2Ow+F7bmuac78hF
         0bxKZw3Pd7tfdhge0+xE4tErjYjwTUoEcHU7KrP/g8PaZnCmRGF9cVgzrr+JTu1VfxWk
         xCuTYEyFa/27kdsOQeLdmP7mEqy2DBVDnsEbQDbUG6CkFxYwxzXe4zQWyjNFegXj+H6T
         JVZzmK7DToaJ7OKS/wEVJ/FLitpyQwkOIOOZwFNoTlceDC1CStbrA0MWvtdeVsccyUqG
         XPYA==
X-Gm-Message-State: AOAM532n5O0XuUz+aJDJLPnu+KLF3vK8IAafI7pAap8OxZIU0AgLQqdc
        uqKI9nm01Boh0MEq53XLLg8=
X-Google-Smtp-Source: ABdhPJxQqYtQUBceYfwYXVOgG/KTSA2UXDDpRCn8C+rr/K3M+nQqpLD5s8QxDg+zQmz5kDfQqJt5JQ==
X-Received: by 2002:a05:6a00:1d85:b0:4fa:9dba:f1f2 with SMTP id z5-20020a056a001d8500b004fa9dbaf1f2mr3592645pfw.31.1649164181867;
        Tue, 05 Apr 2022 06:09:41 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:40 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 20/27] bpf: selftests: No need to include sys/resource.h in some files
Date:   Tue,  5 Apr 2022 13:08:51 +0000
Message-Id: <20220405130858.12165-21-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

sys/resource.h is useless in these files.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/bench.c              | 1 -
 tools/testing/selftests/bpf/prog_tests/btf.c     | 1 -
 tools/testing/selftests/bpf/xdp_redirect_multi.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f973320e6dbf..f061cc20e776 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -8,7 +8,6 @@
 #include <fcntl.h>
 #include <pthread.h>
 #include <sys/sysinfo.h>
-#include <sys/resource.h>
 #include <signal.h>
 #include "bench.h"
 #include "testing_helpers.h"
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index ec823561b912..84aae639ddb5 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -8,7 +8,6 @@
 #include <linux/filter.h>
 #include <linux/unistd.h>
 #include <bpf/bpf.h>
-#include <sys/resource.h>
 #include <libelf.h>
 #include <gelf.h>
 #include <string.h>
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
index aaedbf4955c3..c03b3a75991f 100644
--- a/tools/testing/selftests/bpf/xdp_redirect_multi.c
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -10,7 +10,6 @@
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
-- 
2.17.1

