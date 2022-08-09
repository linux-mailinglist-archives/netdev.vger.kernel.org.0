Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E058D294
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 06:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiHIECb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 00:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbiHIECK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 00:02:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69F019018
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 21:02:04 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dc19so20040050ejb.12
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 21:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc;
        bh=DlddBQTU8KsFHcWwxWALdsTXHIddo9CH27rxkq8nAsc=;
        b=WsQWmYRbPgDx6BgJPZnPKTa2oxAt1BEXRx7+4nsLcKiS+85QIsylYnHMtQ/0bYYdlE
         +L+87Y4cxDE9gv14OHBb5GxmANUJPRIaFd0zMdpLS98sQpFPwywv14o50FcAW027UXsV
         1tZWesQsPWnkQ2uNBCIHiW/07THbqkiWsis8WkV8DMduk+s3OlS0ywg8hdwJ1S1iT3Ob
         OtMbgzqNE0KAxlxEfC9yJ7m4rRVvldGlWOkwWOK/TdjNXNiN9OXrO6RUSMwWBOMN1aBZ
         srBgbU/jVsKsjXtfZ1C5Dp5mP7+GTUSHRR2GAbXg4ZYkhspeuAU3cw8bybIt66CoCaNL
         BxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DlddBQTU8KsFHcWwxWALdsTXHIddo9CH27rxkq8nAsc=;
        b=k/0kEo19bGOVzqM94C+ueQtBxgeMDNLtZ+A/lZwtvEoMTUYtsIZ2oDghreq38oFzxd
         bHP/t2FW03kyoCf/CT85UBAoRRgpfXOX+e/jjsKp1uRkes4+I8WdSKAZFwAvWwv/9PXS
         LoV6BQDP9y1xxVybuOD7aNcS4VuG/QJ8BweYyQ9ZjnOZ3yoKWD864dMvqwgva42Mg5Ek
         KTlDoH5ayeCipQYescnEwZpBuwmPYa50NKjJ6KnFxnVllRAxUe17THZxI0Nm7wmdoeR5
         RkEpcdquAKFvH3bOTsvSGJ1jiAYM/g5X0DGjLgjOOgfLMdmLqcd/H1dAp0DKTXfoOvqC
         OHxw==
X-Gm-Message-State: ACgBeo1xeghuH4/mEm6/Muob4F1bU6Rd4nNF1D3pNRMwxNae4Jkrlnzm
        Twl6txZ4gfvfD8IiGRtu/Sb+7lvOsmD17A==
X-Google-Smtp-Source: AA6agR4kV+r3LxHj4A5ZNZm6Ua4ptac9c80ZJTENVETxrThkBMN3QAxDbMlGBLBB/HQoSSU6fFk1Uw==
X-Received: by 2002:a17:906:8a4e:b0:730:9fcd:d988 with SMTP id gx14-20020a1709068a4e00b007309fcdd988mr15834469ejc.636.1660017722885;
        Mon, 08 Aug 2022 21:02:02 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aec80.dynamic.kabel-deutschland.de. [95.90.236.128])
        by smtp.gmail.com with ESMTPSA id c6-20020a1709060fc600b0072b592ee073sm631485ejk.147.2022.08.08.21.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 21:02:02 -0700 (PDT)
From:   Changhyeok Bae <changhyeok.bae@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, kuznet@ms2.inr.ac.ru,
        Changhyeok Bae <changhyeok.bae@gmail.com>
Subject: [PATCH iproute2] ipstats: Add param.h for musl
Date:   Tue,  9 Aug 2022 04:01:05 +0000
Message-Id: <20220809040105.8199-1-changhyeok.bae@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build error for musl
| /usr/src/debug/iproute2/5.19.0-r0/iproute2-5.19.0/ip/ipstats.c:231: undefined reference to `MIN'

Signed-off-by: Changhyeok Bae <changhyeok.bae@gmail.com>
---
 ip/ipstats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 5cdd15ae..1ac275bd 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 #include <assert.h>
 #include <errno.h>
+#include <sys/param.h>
 
 #include "list.h"
 #include "utils.h"
-- 
2.17.1

