Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1625786DA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiGRP6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiGRP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:58:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AC02A428
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:58:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q5so9409699plr.11
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uq02hIVc8/rGiSNqu1tghSh9WWBfR9s/mhkvm8YLLq0=;
        b=WLmMPBavgUVYXxU+Tu2QkBfRw0RMb+zzHv1hTi3GZFhEVvrpFhNk3VTeJUSAIebxp9
         u6Hix+F6b55qv66FxdVtIZniNG5l2EN4gYMHvBQvCSJIWQtgJPJ2vAhNMPepKC6kA/VT
         krIQ7u2VZfPHPjbb+qoO22By/KKfk44I6ZZ1Or5Q0FJIMVibK4rmdT4SPfZAcyT1Z5vH
         VhJSGQo4SRhqGOedf1gGRfzNvrd52HC9nv6wXzuUz7wvJambTuFhgOvgRHh5Nf7JnRYI
         tl2imXvcSqUt9KhnlVXGpkQJySO2xztI90sx/jU1J/8HYWornVGkrLx1cUKKq1HnKMUG
         kDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uq02hIVc8/rGiSNqu1tghSh9WWBfR9s/mhkvm8YLLq0=;
        b=dD3g/aNQDK1pNoNJ0q3cGseKqrTQtqhHYX/xo7H5C2bOiKAsWuRey1OM0/l2KlDwbE
         HvhZsiTkfxm+uVjRnELZ350KveVQmHuQ7RewSMGHQnWDy0YP2J24W1bh0cm71Q5sjt/7
         i6VucZPNRhWbslz8haFLwBWz+FU7vgm34uA6dQhJFE81Ogjs/gMDyDBgHyOh7tp9t7fk
         Ssf99Mg7F0h2v/+Y7f74yWa41drwJoCq8e9k/LlEbXRd2+ZiT/CSTxQ7g1ApEYdomZtS
         KsNhyjMXsc+a/lKYG5oI2+CFBRkqIpNsblwktwfzvKDeFou62sudVr0eiHB6bgRFPDXs
         KxEA==
X-Gm-Message-State: AJIora9P9kmMO0iZaiPBkSpt6KDX77/O97Mu5O/4zMmx9M/6c8a7xMU+
        4LvIkRbvNHlZhYdgMsVcwexEd6fTYHNGcSpK
X-Google-Smtp-Source: AGRyM1uoqQhz8nDO0bKuaiVADXSGaIv2Ilc4+aeVdGlGZz8aG8MnFaV+PtOXCaxbsqFdIxM3MYSc5w==
X-Received: by 2002:a17:90a:fa05:b0:1ef:89d1:1255 with SMTP id cm5-20020a17090afa0500b001ef89d11255mr32931901pjb.73.1658159914104;
        Mon, 18 Jul 2022 08:58:34 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.googlemail.com with ESMTPSA id y1-20020aa79421000000b0052b84ca900csm440601pfo.62.2022.07.18.08.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 08:58:33 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org
Cc:     Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH iproute2-next] bpf_glue: include errno.h
Date:   Tue, 19 Jul 2022 00:58:27 +0900
Message-Id: <20220718155827.2028-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If __NR_bpf is not enabled, bpf() function set errno and return -1. Thus, 
this patch includes the header.

Fixes: ac4e0913beb1 ("bpf: Export bpf syscall wrapper")
Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 lib/bpf_glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index c1cf351b..88a24751 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -7,6 +7,7 @@
 #include <sys/syscall.h>
 #include <limits.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "bpf_util.h"
 #ifdef HAVE_LIBBPF
-- 
2.34.1

