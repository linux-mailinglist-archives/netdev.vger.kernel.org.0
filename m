Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8394E3F7FCE
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhHZBZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHZBZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:25:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C31C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j2so739123pll.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CpuYUNzq0+b2afk/nH++4cenXL/BZGm0BDWXGx8VYSU=;
        b=MMLhhyi7/jlHl9gVbwma4skv2knuEtZrCJIpCCsAbMb8xxXqoC1zyCPBbvgIeEX/lG
         OB/h/OjvYgbpJ+uIMcYnHFaBx8chvnFJqraQQO959IzLe39pHFk1m1KhoYtbdYL3/N12
         aaXOkSZwdpzpgSAdX3b6cVcjeHb+v1tiO0icW8fU6v7tRUnKtxKBftGIUPx3tD/aHfBL
         xiluPd+w6jcuftLTtp7gQ8GuOrYKKYuQM+dgFK8MrS3p5qSjczlvhhtbPwGmk8isQmcL
         5f+SgLyqG4LtMGA5/XlRKb+Ulm4DmlXtUSsgJVIAEtyETrbId3DL2pQavdyTxiQtrnNR
         611w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CpuYUNzq0+b2afk/nH++4cenXL/BZGm0BDWXGx8VYSU=;
        b=nnotju2w20riPVudZLwANsT/seLG+XDHZZEB4yxupA93cjewBCKAg8BqYOYINEaLQ2
         kjhjhea61L0r6Ssuj5l0gK8VN2h3UXLRB3EkBJtunPuUu+kaW8TAFyPrAGxDt7HFxnXo
         vy1hOVHsa60EL3+BzoLv2nwRxw0BssWZ0gsDL+GqQE+cSaifEd/L/eED4LuHnzo1pl8P
         E3XQkXA4f98VtjZ3CQOOTta/MiWVM8Lx6JE6T4UILzBdh2HeQmrB0WOE0SiQwAuMisD4
         q9xg6j2rA4Kk2yG7gQ2eBCfdNtj1WeYyBTPB0fKOoXX4tuq1O7oMN1wHeLdFjTmcVneU
         Upbw==
X-Gm-Message-State: AOAM530gLuLRMkpNiDnJOfqU6qmtll/86k5QLsEpfG3g/incTv8m/gpQ
        Cx4Y1Jn4792QIQlT0ABEl2gImQ==
X-Google-Smtp-Source: ABdhPJyIhplsmmPtpw6babDi1ELCTXojtLp69KQkmKhkDIqcIMNwcCSrtCeiYhGUI0G9R2+AL4xTLQ==
X-Received: by 2002:a17:902:8694:b0:12d:c7de:591a with SMTP id g20-20020a170902869400b0012dc7de591amr1342889plo.20.1629941107099;
        Wed, 25 Aug 2021 18:25:07 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h13sm1113458pgh.93.2021.08.25.18.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 18:25:06 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/5] ionic: remove old work task types
Date:   Wed, 25 Aug 2021 18:24:46 -0700
Message-Id: <20210826012451.54456-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210826012451.54456-1-snelson@pensando.io>
References: <20210826012451.54456-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the move of mac filter handling to outside of the
ndo_rx_mode context using the IONIC_DW_TYPE_RX_MODE,
we no longer are using IONIC_DW_TYPE_RX_ADDR_ADD and
IONIC_DW_TYPE_RX_ADDR_DEL and they can be removed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 6 ------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f52c47a71f4b..1940052acc77 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -92,12 +92,6 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 		case IONIC_DW_TYPE_RX_MODE:
 			ionic_lif_rx_mode(lif);
 			break;
-		case IONIC_DW_TYPE_RX_ADDR_ADD:
-			ionic_lif_addr_add(lif, w->addr);
-			break;
-		case IONIC_DW_TYPE_RX_ADDR_DEL:
-			ionic_lif_addr_del(lif, w->addr);
-			break;
 		case IONIC_DW_TYPE_LINK_STATUS:
 			ionic_link_status_check(lif);
 			break;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 69ab59fedb6c..31ee1a025fd8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -98,8 +98,6 @@ struct ionic_qcq {
 
 enum ionic_deferred_work_type {
 	IONIC_DW_TYPE_RX_MODE,
-	IONIC_DW_TYPE_RX_ADDR_ADD,
-	IONIC_DW_TYPE_RX_ADDR_DEL,
 	IONIC_DW_TYPE_LINK_STATUS,
 	IONIC_DW_TYPE_LIF_RESET,
 };
-- 
2.17.1

