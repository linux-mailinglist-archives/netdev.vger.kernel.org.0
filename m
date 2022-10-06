Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DE25F6E23
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiJFTVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiJFTU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:20:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD038E99D
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:20:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 67so2911398pfz.12
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 12:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=o0sz4YV8I6xJq994JzYjrxpMVxoZUTAxkS32TV/i12o=;
        b=SKbqVfRbeTgnf4D8/CD3LpgaxYpAoCVyTbm553MqSfFjg9QF3hxIv4dllqrBOMe7ZG
         YhwvBzv7VMOZLJVi5Zbdtg3d25wSP6KiALB5yCMxWIi69eoq5l3ck76SFkO0zPOHX5C+
         eXCss/eLi18BvattmCV4jvG18Kn3chFDmlvqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=o0sz4YV8I6xJq994JzYjrxpMVxoZUTAxkS32TV/i12o=;
        b=zBgP2AJVhzFjjtq83KeHmJIbc21TSY5daTZW8c3S0s18xdiGatl04xEJsoDmhBGLOU
         2SSlQxpxuRvcqdQaoat2pq4XGE+Tm8QzhutvokpZ2UfP7gLXlfnQzayV5ERofDWFfkX0
         e7+vvEjIXBf6yoxVB1/cu8gB13YOL9Oaabk/UrMVFcCk3BdusHGGOBxjwQh6VqXSQhH9
         dpxkD/RXXSohqdxbNnxtUUuvxZ5XMXFZsgADhD78dHH9rg1D1FCtZVUhp26g64zPIxoe
         szrSEa0onNg9YfelmpzZYafPOzL0Rq3fRFuAQnfZ/JBqO6/QrYqTdUTHB01HBEuc9hYe
         htTQ==
X-Gm-Message-State: ACrzQf2Y2MA7Xz477mHdc3ajL8F5Ks7ugQaSsK2s+yIJVf0B66/msva1
        jm2dfzPQyiDVWWe+QBLtK07mRA==
X-Google-Smtp-Source: AMsMyM7DHGS2j6S6qg8i6qoZJaoYNXEAww2nyZu7uKQ8jkBFYsFCiEBxERMt+2VXZSXy6rsRp1fOMQ==
X-Received: by 2002:a63:fe13:0:b0:452:2b86:50fb with SMTP id p19-20020a63fe13000000b004522b8650fbmr1148757pgh.167.1665084056135;
        Thu, 06 Oct 2022 12:20:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id gn21-20020a17090ac79500b002086ac07041sm67230pjb.44.2022.10.06.12.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:20:55 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: bgmac: Remove -Warray-bounds exception
Date:   Thu,  6 Oct 2022 12:20:53 -0700
Message-Id: <20221006192053.1742965-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC-12 emits false positive -Warray-bounds warnings with
CONFIG_UBSAN_SHIFT (-fsanitize=shift). This is fixed in GCC 13[1],
and there is top-level Makefile logic to remove -Warray-bounds for
known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
'-Warray-bounds' universally for now").

Remove the local work-around.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/broadcom/Makefile |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 2e6c5f258a1f..0ddfb5b5d53c 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -17,8 +17,3 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
-
-# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
-ifndef KBUILD_EXTRA_WARN
-CFLAGS_tg3.o += -Wno-array-bounds
-endif

