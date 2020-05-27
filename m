Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454251E3AD9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbgE0Hoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387505AbgE0Hoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:44:34 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43035C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 00:44:34 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so26773250eje.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 00:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DfwOZgo35KGpzcj4qNlL/rLMTnakMSgVX5UxS1ERamY=;
        b=bjKgywSo+zlaLz5UIWSwAMrO1R7c85dPsA9yqrQpJT9hvAjtWNw42ABzjOfTsY1F9L
         maZBsvWJF4rfa8vGsLPjdWe26Cnhc1V85yTG3npqw1/VPrgZ2BoSqMX/hnLgeJDmiVVq
         eSMYMqX8pl8DDSEn8CTqjMiWuyueCcNnSKkw/ktddz+riXQRHOibaiRmvTMg4dFywU+O
         ocIFHFMZxjLa3YtCwhrwKu9gzJOsqIuYmG8BEH7CZhPIptk34Bwkctr9TKKLVRXpoJez
         SbvlRCNTmlBhZf1Ym9v+DLKYmrFH/olvgwAiaBgYV7zVUhZEaWrDpajXyGnJzIWKVeiW
         sGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DfwOZgo35KGpzcj4qNlL/rLMTnakMSgVX5UxS1ERamY=;
        b=M6p0CfnvE9OCHOuV1ZQ/YAGQ6uS5/Vq/FM5WPKNdAGnNk/quLugzWBGfevN1uNOI8G
         N5SWcmDLbmvXELoU0+Y1/YoliDbWLhAafh2KYr8ObibMx4fhrgV0MQ34neTWy5Z41nyM
         sQDpmRoGApLhS5ktekE02l/a2/sR+FEDEaxmAx6DI2wyJnPXiN0LMIK6KdRatQ8cfpUd
         cTx4ZZez/g1HkXdx1E3geeSs3lGTn5kRsYlO0jH3YbOUAvV2nNt1z/33zUqYGZNUGeh9
         ohmY/ZFbzxctz29JOhWBjD17jbIlELIbFW/00Ipi0dl1ryGRoob6fDPNDZk3W00Euw6o
         izfA==
X-Gm-Message-State: AOAM531JEN47T1aqUM09Pjkrts6vuRQMIt6KBMb5I3xQtpJ8mioyi/C4
        4U3A5rUEdoikp5fjDRTJfsAkew==
X-Google-Smtp-Source: ABdhPJybK5+la7pI9lx2eoF+emzRouMfxWcaeWovv4VJKWhuuztoAc1FHuhTKbSz7+3Ksvb2gUU4Kg==
X-Received: by 2002:a17:906:7e56:: with SMTP id z22mr4581253ejr.60.1590565472950;
        Wed, 27 May 2020 00:44:32 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id z7sm1640871edq.38.2020.05.27.00.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 00:44:32 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Heinrich Kuhn <heinrich.kuhn@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] nfp: flower: fix used time of merge flow statistics
Date:   Wed, 27 May 2020 09:44:20 +0200
Message-Id: <20200527074420.11232-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heinrich Kuhn <heinrich.kuhn@netronome.com>

Prior to this change the correct value for the used counter is calculated
but not stored nor, therefore, propagated to user-space. In use-cases such
as OVS use-case at least this results in active flows being removed from
the hardware datapath. Which results in both unnecessary flow tear-down
and setup, and packet processing on the host.

This patch addresses the problem by saving the calculated used value
which allows the value to propagate to user-space.

Found by inspection.

Fixes: aa6ce2ea0c93 ("nfp: flower: support stats update for merge flows")
Signed-off-by: Heinrich Kuhn <heinrich.kuhn@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index c694dbc239d0..6b60771ccb19 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1440,7 +1440,8 @@ __nfp_flower_update_merge_stats(struct nfp_app *app,
 		ctx_id = be32_to_cpu(sub_flow->meta.host_ctx_id);
 		priv->stats[ctx_id].pkts += pkts;
 		priv->stats[ctx_id].bytes += bytes;
-		max_t(u64, priv->stats[ctx_id].used, used);
+		priv->stats[ctx_id].used = max_t(u64, used,
+						 priv->stats[ctx_id].used);
 	}
 }
 
-- 
2.20.1

