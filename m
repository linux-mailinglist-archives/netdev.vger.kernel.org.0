Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0D153F85A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiFGIks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiFGIkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:40:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4F8D2477;
        Tue,  7 Jun 2022 01:40:44 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so20222110pju.1;
        Tue, 07 Jun 2022 01:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pb593Np/kp86l+3oqzrBPdLokFUVR5dWHJspHdhIfzs=;
        b=cLrN67vbRxCdpdjlvYUO6Ulby8YvLpTdjcj16eRv0n4B+JzvZGTyMxkjUgUA47jyRT
         75SCSSOqe1SS6qKy3jvpFpcIKuisFOzmlw1MlCZl9hzSvvpPLbNEB1yY9wo5in5Lkly0
         yhxWx6dY6BxumUpLhDGnSWWJEEkJCmHCn7+eTSOtxR4pDS2obooydmkkIbp74t6lSANd
         uWaXj4rbYm7G4TSFHdR5LVj4z2uZXe7U6CC95NsqI78SDLA8DAH1oRdqsGRxggYsK3FK
         f2W0LvT5KqVhkrLMYR2XSnxiz4RE1igks0OjksmwVWPHygl16+Y1a0yvgFubMvyN281s
         YsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pb593Np/kp86l+3oqzrBPdLokFUVR5dWHJspHdhIfzs=;
        b=HcTx06qC0oL90iAqtLLfLhD5qAgk77s+C3HdCB5VsCpi5XBsvLep9DUgu1fLuPFBLI
         beWjfKxnFi6NxBUyfrtPXzlSMD1ai1U03ekTQpt9wsef06ZDKn8t7khFpFO3R77sph+Z
         n7b8gP95HBgbbu+brrDeNRWBmlhpSq0zNFA6vJi5C3JyOalWPxVth4jCSEERr0PgrhnS
         +ti55RDU7QJladhAFl9QkuQPxZ8S5qpSXqWEE7O5x/SE+AVhmM5N49om58nzcdHCgGz8
         Ir4BFRYUT4glaOVLxCWFbfchDOKpFeQ88MyQm3Ybe21b9SA1WmweaPBJ8JValCcAh83i
         Sz9A==
X-Gm-Message-State: AOAM530Bi2K87rVcYyGzSEdEdeuYe2p0wN4h+AZ7UBRdbGwVjYJOlkNV
        slr+AUUi2zHcV7CJFCMsgd0qTRk6c9O0tQ==
X-Google-Smtp-Source: ABdhPJyf+h78/PFDk+dzQ3AwiE4bphgwwiFJEwrlmygYOj4BkEO0ehgcQ17xppJogGh8Do/KOyoRaA==
X-Received: by 2002:a17:90b:4b51:b0:1e8:71cb:4d18 with SMTP id mi17-20020a17090b4b5100b001e871cb4d18mr13495757pjb.108.1654591243672;
        Tue, 07 Jun 2022 01:40:43 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s18-20020aa78d52000000b0050dc76281fdsm12134047pfe.215.2022.06.07.01.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:40:43 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 2/3] samples/bpf: move AF_XDP APIs to libxdp
Date:   Tue,  7 Jun 2022 16:40:02 +0800
Message-Id: <20220607084003.898387-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607084003.898387-1-liuhangbin@gmail.com>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
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

libbpf APIs for AF_XDP are deprecated starting from v0.7.
Let's move to libxdp.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/xdpsock_ctrl_proc.c | 5 +----
 samples/bpf/xdpsock_user.c      | 5 +----
 samples/bpf/xsk_fwd.c           | 5 +----
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/xdpsock_ctrl_proc.c b/samples/bpf/xdpsock_ctrl_proc.c
index 28b5f2a9fa08..964fb3f9c12b 100644
--- a/samples/bpf/xdpsock_ctrl_proc.c
+++ b/samples/bpf/xdpsock_ctrl_proc.c
@@ -12,12 +12,9 @@
 #include <unistd.h>
 
 #include <bpf/bpf.h>
-#include <bpf/xsk.h>
+#include <xdp/xsk.h>
 #include "xdpsock.h"
 
-/* libbpf APIs for AF_XDP are deprecated starting from v0.7 */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
 static const char *opt_if = "";
 
 static struct option long_options[] = {
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 3ea46c300df2..9231bfadf419 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -33,13 +33,10 @@
 #include <sched.h>
 
 #include <bpf/libbpf.h>
-#include <bpf/xsk.h>
+#include <xdp/xsk.h>
 #include <bpf/bpf.h>
 #include "xdpsock.h"
 
-/* libbpf APIs for AF_XDP are deprecated starting from v0.7 */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
 #ifndef SOL_XDP
 #define SOL_XDP 283
 #endif
diff --git a/samples/bpf/xsk_fwd.c b/samples/bpf/xsk_fwd.c
index 2324e18ccc7e..946d29dd2a9e 100644
--- a/samples/bpf/xsk_fwd.c
+++ b/samples/bpf/xsk_fwd.c
@@ -23,12 +23,9 @@
 #include <linux/if_xdp.h>
 
 #include <bpf/libbpf.h>
-#include <bpf/xsk.h>
+#include <xdp/xsk.h>
 #include <bpf/bpf.h>
 
-/* libbpf APIs for AF_XDP are deprecated starting from v0.7 */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 typedef __u64 u64;
-- 
2.35.1

