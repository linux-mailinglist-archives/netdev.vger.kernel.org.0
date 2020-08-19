Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EF024974C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgHSH2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbgHSHZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DC4C06134C
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:33 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t14so1120575wmi.3
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vEOfu47Y3L4UQX7xJ0CwMKmanBZGRJoANMK0AYiLhYY=;
        b=ONBkDFy4nvOfZy7Fb/jtxaeN/rlfFcWeeYSqwmA3J7/SlqyYyn5CfcuUN7cnycjoDR
         PdmVfEVuU/bda2pEVSTzq0R5q/7ChExwe96pxuWSx16se15S26yIBmGkQXP1ftDrZaAY
         jGn5RssGJLWMtx4n5Uw4ABkmS1HjH2QHzIreSWS55X18chzexHqZ5RdzvGU5oawhtF6E
         PeXlp947xRBTfUVg2CemnE1u3zudg3JtoKkTNjUXq2imQbPnJ0tfC9aOoEoD8g2cu+MM
         sOg01ZxL6X2GItpuOflCXO7I1eDtJiEYkqtedNLVTiSjQf6lFKcY/1gQ4v7lkBd0OeBS
         Iekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vEOfu47Y3L4UQX7xJ0CwMKmanBZGRJoANMK0AYiLhYY=;
        b=MCji11450TWKElD2qnHenST8Inr5tdynlgKCjOUSCDSOfOYnc+a/8xu3x+nXGRiEWL
         U7YTR1g4FvF4Lh5qw+5QPEOAt6iZ504zOQde00puJHY58pl5HtatTtpGkhGeD5amyoST
         ZoLcYH81C3a8x4lyXyGtgeKZQRnX30WAzGi0R9E6wUgE28FwZN3acEqCTeF6vJf3A5nP
         ZbxUcEuqx1uD/isJzohr3VazmsJZTfYB9fOqUB52nEQ9qviXpnwaAgBaUF1QWMNR70w6
         ktRrVy0Ekobanhjrl3NnptvHLnUAqOvJTCxV3ph879m9BjR5Z19grVJvkqO4B6Aygk1x
         mk5A==
X-Gm-Message-State: AOAM532/q33CQgWDIaMkNg+uQNnKVKaGSBeoC40BMTTKH+GEX2D4yWMT
        kucA+Ni8aVUuI1T1EI/T0vX29Q==
X-Google-Smtp-Source: ABdhPJzrIC/A+inhohXhaCC31ocYq2x37yCHpex5pSLhP3NPf3zLly2VascvS2mzvSfx7ZZTMNX2Fw==
X-Received: by 2002:a1c:9e11:: with SMTP id h17mr3528644wme.106.1597821871698;
        Wed, 19 Aug 2020 00:24:31 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 21/28] wireless: ath: wil6210: debugfs: Fix a couple of formatting issues in 'wil6210_debugfs_init'
Date:   Wed, 19 Aug 2020 08:23:55 +0100
Message-Id: <20200819072402.3085022-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format and
gets confused if the variable does not follow the type/attribute
definitions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'wil' not described in 'wil6210_debugfs_init_offset'
 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'dbg' not described in 'wil6210_debugfs_init_offset'
 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'base' not described in 'wil6210_debugfs_init_offset'
 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'tbl' not described in 'wil6210_debugfs_init_offset'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 11d0c79e90562..2d618f90afa7b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -443,10 +443,10 @@ DEFINE_DEBUGFS_ATTRIBUTE(wil_fops_ulong, wil_debugfs_ulong_get,
 
 /**
  * wil6210_debugfs_init_offset - create set of debugfs files
- * @wil - driver's context, used for printing
- * @dbg - directory on the debugfs, where files will be created
- * @base - base address used in address calculation
- * @tbl - table with file descriptions. Should be terminated with empty element.
+ * @wil: driver's context, used for printing
+ * @dbg: directory on the debugfs, where files will be created
+ * @base: base address used in address calculation
+ * @tbl: table with file descriptions. Should be terminated with empty element.
  *
  * Creates files accordingly to the @tbl.
  */
-- 
2.25.1

