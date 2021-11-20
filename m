Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B27458048
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 21:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhKTUSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 15:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhKTUSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 15:18:38 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFE3C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 12:15:34 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id n29so24499338wra.11
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 12:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DKCMcrulrmSmG/YLPpNGcHqPmytE36hqQowsiKmVizw=;
        b=Ei7scbN8UvkGigXQEueLY48sngv3w6ilwjKYukC4oL2GigTc866SJjryAYxIKwW4m7
         kcewumq19KhruA++DAKShYLO4vSLYwv8VmwAoUtgNTuh86irZGhR/sTzjZfY2a7dQnW1
         dHbmIDQNELS7LD5qybXbwiqPyZNCLQERiTXvuuS5/cxEISoQP/+DAsAU8RZjyJF8pa+o
         RUhvIcIekcIpN5eQ1zpoQ7u7VOGAPmAfQ3Vk92Jgu5d9fjmASUNXEwRNaId1VSUM9Ps+
         hAKCIxKjlQSq2CeQUIPTTt4VYcL9Dnw+/shwaXejV7UB31gvjnaMddpY5S6KD0rdZ8Ud
         svnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DKCMcrulrmSmG/YLPpNGcHqPmytE36hqQowsiKmVizw=;
        b=tda+NLfLSJW4MHi4KdCafEZ7OyQ8C2oe+XjNLW3cPEfcCbmeB7WI6p/4ccOcgAy4C6
         1HW5pTsMdby2HOaJyOBzLbiH/maPQP7PXzeQoK0+nAwuE4M1Xd0e7Dj2qKDW8IEl2wAJ
         SC8KiMAfwL0PLnTPAooh0FsrE5GIY/avQ65LGMV8wVwywpW5Ya7pFfbPAXjLdEBy3rdV
         U5yJr1wVrMvT7rK+vaG1yUL+Bo7qtFAMA6aD7SUnCsD0jVS/8Li1GXZDadLEWuU2rU8f
         H3UqFDNU5w4QZDd8Ry4G6dYAMcnL0a6DcuLU3UFvxJyoI92QmhGHjhEMKmFCoez+ZZyB
         jKJQ==
X-Gm-Message-State: AOAM531U8LTIbvgUgbhBMRsyAOkRVca+PzvL84hHB57QBPM6WIOVPfwf
        RSFA1WUvYpYRbIqyMi5OuWoumf46qjyDlA==
X-Google-Smtp-Source: ABdhPJx2G7JzEGw3+MRPp65+lG9geyDplKwQ6usit8n//F6VwT83pYeviuj+8Nhw71crNOHlnr5CjA==
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr22339789wrq.221.1637439333015;
        Sat, 20 Nov 2021 12:15:33 -0800 (PST)
Received: from ady1.alejandro-colomar.es ([170.253.36.171])
        by smtp.googlemail.com with ESMTPSA id t189sm3798172wma.8.2021.11.20.12.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 12:15:32 -0800 (PST)
From:   Alejandro Colomar <alx.manpages@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alejandro Colomar <alx.manpages@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH] drivers/net/ethernet/sfc/: Simplify code
Date:   Sat, 20 Nov 2021 21:14:26 +0100
Message-Id: <20211120201425.799946-1-alx.manpages@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That ternary operator has
the same exact code in both of the branches.

Unless there's some hidden magic in the condition,
there's no reason for it to be,
and it can be replaced
by the code in one of the branches.

That code has been untouched since it was added,
so there's no information in git about
why it was written that way.

Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/sfc/ethtool_common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bd552c7dffcb..1b9e8b0afb3c 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -33,10 +33,7 @@ struct efx_sw_stat_desc {
 				get_stat_function) {			\
 	.name = #stat_name,						\
 	.source = EFX_ETHTOOL_STAT_SOURCE_##source_name,		\
-	.offset = ((((field_type *) 0) ==				\
-		      &((struct efx_##source_name *)0)->field) ?	\
-		    offsetof(struct efx_##source_name, field) :		\
-		    offsetof(struct efx_##source_name, field)),		\
+	.offset = offsetof(struct efx_##source_name, field),		\
 	.get_stat = get_stat_function,					\
 }
 
-- 
2.33.1

