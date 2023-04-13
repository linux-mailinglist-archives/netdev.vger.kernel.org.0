Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3956E12B0
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjDMQrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDMQrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:47:43 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA59019;
        Thu, 13 Apr 2023 09:47:33 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id jg21so38662620ejc.2;
        Thu, 13 Apr 2023 09:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681404451; x=1683996451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=76ETY+isIx7iYwEUo1JeENf2CaVjYZp8DI5NXMOw9dU=;
        b=VAIcFvvB5t3517nDf/y3JgH3G4uDmP+oWS2Sf2BguvxrgLsglHqpkpzrzuSIbV9aZ9
         MgWWpZqAd3FceBNaQLpqKbd3PYUcctI5+fnSuBCtiS7K5K4TAdyRxJL73qIumwp0fdpq
         1PAfm2fNnYUV+rpnyeFXVEHnCxFRuVFJlJGyPh8FiRLrUWMK9wr98R35eaDgTYhaVEAp
         v3nbqmdzzzlnBztD6uxC1wuiwOZ3gr6Lhkdwil5YeZSWTdo2QKgwBkHfFnliyKqmKVJO
         T0mrVst4lCqaii/J8gjXN9rn6jSEf5hw2tqJSBq+/7BjEfXK8gtugdEGAsPSN1hPsVTi
         qRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681404451; x=1683996451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76ETY+isIx7iYwEUo1JeENf2CaVjYZp8DI5NXMOw9dU=;
        b=TUVwr4hgf66GKH1Wz3mi9QKDvbg0E+f4fAZ8eYOjb/NQYTBqP71OO8y/TW3CFy5Ib2
         5bZoFR/sRwlsM1BcFNxjA9BlnOkJwZmBT2r59RLnDNzMeGZqslV8F9mwPRdnodct2G+S
         QW7IuCiGuPS+k/9a6IyWm5PZsRWR/DURz5KwFPYbNzgkkVvgxCWm2NhmJ77aKazJDSzq
         kDDw+Bz1IIBe+E8JM1Tkm9og0RYvHf03iv2FrVbrQc4UkMOUmks43t+C3D+kFfIYJOJd
         CvQ4qZqMRP3F2eUvsQyvfWytQYVySgUnfkcY9HwVX5yIqj0OWluKsJGra1mqSONdITuv
         J0zQ==
X-Gm-Message-State: AAQBX9c5L9C+5skKtPOIiwkDVnUjy+vPugFnB57hF35+ZlG2LqIQLxfK
        gqlGmj6xgRAC4CViLtllPu30Fx/QWYxFCCiI
X-Google-Smtp-Source: AKy350ZLk2fm2QSC7ajwa9op45CcCMbRw55CnTViYrBzQ81vBh1WX4In1LxxrQGfaTBE+Z59AJe24g==
X-Received: by 2002:a17:906:5849:b0:94e:4c8f:759 with SMTP id h9-20020a170906584900b0094e4c8f0759mr3267506ejs.38.1681404451118;
        Thu, 13 Apr 2023 09:47:31 -0700 (PDT)
Received: from localhost.localdomain ([45.35.56.2])
        by smtp.gmail.com with ESMTPSA id a10-20020a1709064a4a00b0094a4e970508sm1218744ejv.57.2023.04.13.09.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 09:47:30 -0700 (PDT)
From:   Yixin Shen <bobankhshen@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        ncardwell@google.com, Yixin Shen <bobankhshen@gmail.com>
Subject: [PATCH net-next] lib/win_minmax: export symbol of minmax_running_min
Date:   Thu, 13 Apr 2023 16:47:26 +0000
Message-Id: <20230413164726.59019-1-bobankhshen@gmail.com>
X-Mailer: git-send-email 2.25.1
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

This commit export the symbol of the function minmax_running_min
to make it accessible to dynamically loaded modules. It can make
this library more general, especially for those congestion
control algorithm modules who wants to implement a windowed min
filter.

Signed-off-by: Yixin Shen <bobankhshen@gmail.com>
---
 lib/win_minmax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/win_minmax.c b/lib/win_minmax.c
index ec10506834b6..1682e614309c 100644
--- a/lib/win_minmax.c
+++ b/lib/win_minmax.c
@@ -97,3 +97,4 @@ u32 minmax_running_min(struct minmax *m, u32 win, u32 t, u32 meas)
 
 	return minmax_subwin_update(m, win, &val);
 }
+EXPORT_SYMBOL(minmax_running_min);
-- 
2.25.1

