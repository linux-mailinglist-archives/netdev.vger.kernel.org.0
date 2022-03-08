Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700764D0EDE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 05:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbiCHEyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 23:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiCHEyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 23:54:43 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277A13BA54
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 20:53:48 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so1315069pjb.3
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 20:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Em5g/ScTbvCdYtDWGH433lroKkQwOYk33njMRC+cjoA=;
        b=MAQBE50dVS/rAyZf/+fGPvdOHgLwPI8UhMgIHGY4HwZnI1wwnYuHUKuFmx4Grbp4vT
         jO4nfD1gUB9ypC7OSO7eMGDZ65VP90IISMJotT4OnvXV7/wKbj/U9qijzliPCP9HHjZg
         Wp3yuozxNh8QXQea1I/4IbV465trVGC1Eeu9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Em5g/ScTbvCdYtDWGH433lroKkQwOYk33njMRC+cjoA=;
        b=icEjSpt7+fbRquDSyIaif2FRk5DKgnH0HAxeq8tXNt+2Y624eWldAdLqGtt8k7Ecbs
         g5b/wZ7+2wS0wd3/sBrqIYrIFWLlejbQ5xiQDM1pwQ1SI7g3OfMGOqbPx8aVfW33W7io
         ZfQX0YVeKf8miABtyHmEm7Lord1Bs/X2T5qO9S2LPQT+qXtxQJqILSZaaGRCPO7c/Fqw
         XX+lJJiNbEsg5sO8OqYMp/MuUzY+L8PL9lVa0/kqAbr+zVxuMaDXTg+vKuFBqiNh9gR1
         Szm20/tSeLEVqC1P+ZCYbadL5ybs3lH5wB5HPWQmeNPzfj0W4qBJnaFi5vYpNP/uCh/U
         TqWA==
X-Gm-Message-State: AOAM531Be2TmsRYHNNp4eYxcU3c5UARXciTj+P7zs/bKEqbznqY5Ba+k
        6GEqImR2L1JXpzu4562WtNIBCg==
X-Google-Smtp-Source: ABdhPJyyBI7RLQGOqJuupQer3+spkJyHeEkcSyFtMgGfrMhShBI41VBZelwmlOCAXJrn0cftD+kIZQ==
X-Received: by 2002:a17:90b:4f92:b0:1bf:25e2:f6af with SMTP id qe18-20020a17090b4f9200b001bf25e2f6afmr2738197pjb.98.1646715227711;
        Mon, 07 Mar 2022 20:53:47 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a0b9700b001b8f602eaeasm991459pjr.53.2022.03.07.20.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 20:53:47 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Cc:     Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next] net/fungible: CONFIG_FUN_CORE needs SBITMAP
Date:   Mon,  7 Mar 2022 20:53:45 -0800
Message-Id: <20220308045345.2899-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fun_core.ko uses sbitmaps and needs to select SBITMAP.
Fixes below errors:

ERROR: modpost: "__sbitmap_queue_get"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_finish_wait"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_clear"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_prepare_to_wait"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_init_node"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_wake_all"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!

Fixes: 83622ae3989b ("net/fungible: Kconfig, Makefiles, and MAINTAINERS")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 drivers/net/ethernet/fungible/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/fungible/Kconfig b/drivers/net/ethernet/fungible/Kconfig
index 2ff5138d0448..1ecedecc0f6c 100644
--- a/drivers/net/ethernet/fungible/Kconfig
+++ b/drivers/net/ethernet/fungible/Kconfig
@@ -18,6 +18,7 @@ if NET_VENDOR_FUNGIBLE
 
 config FUN_CORE
 	tristate
+	select SBITMAP
 	help
 	  A service module offering basic common services to Fungible
 	  device drivers.
-- 
2.25.1

