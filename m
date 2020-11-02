Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6BA2A29BC
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgKBLqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbgKBLpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:36 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01038C061A4A
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:36 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 205so1440572wma.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+JGIBxh2OHPmWqNoTk3kNcBe2Yw+4aH4Fb8WFyGD6FA=;
        b=OCtG+NyPy6NjpA+yP+kc9t/GBUTE59Cg+6TxVnmIATtEFXWWp2Nc/mXIpaPUs518bE
         LzRXpR2IQ3vTBC3S+GvvjpGDLYuOiB84WQAs9VDT8cM3yeRazr8y85b3mOO6Qt44nu9T
         /6sG6GsQX67gl8/yjcxM9s4jGOULebIapztfjkVLkXsNT5bBqvwk9bsSZtyQchi+roAT
         BAS4R+zGWInHafeNmA5aDZVehQcG6QCrYpM2nM+wknh6RocDgrmk6jQdOi1MnXgUsDJq
         CeQRwGzOM4bYkXo6C+xYGj4M5PJ4ei9bphFA8fN6BcI2XEMcS2bBdlFXRBVqllLodbq8
         J/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+JGIBxh2OHPmWqNoTk3kNcBe2Yw+4aH4Fb8WFyGD6FA=;
        b=sLa4P1+qn1cfIntTFP5satLr1vpbL/vqbqyR/XlkJg1MnIE56JqkSTw6cwZFwijINI
         2VH9F/6/89gqUo0xlkIzJ24h/Sl7k63wxiU6JI6TEKbL8sJxh0wO+Er2VbD77AW63+PY
         UPK/Ab0njiSczgfUiYkbaMk1txzc8k+4gpWC41D1PJCTEIEF2lxgK/ab+BYZtw42Z0XI
         32zBSpcjIzcX6fa8gX4lvJRIMkzDJ+4QMt7uYwnynKMBhw1x5w0RFVF9jITni618dnJ9
         4UlIEkP7CHqFGMQqQu/oEIHQkQQdgNbCS/Xia5I13TA1sr4Pqi/zMGrMurKCvWHviin9
         xiyw==
X-Gm-Message-State: AOAM533eYmXvntygZZ6spwfBvpBTsekR9QzMeAKWVJlAGiKKZyWGPRGK
        jdUV6Dt911BOReX1TaX7d1TZpnj6eCoIqw==
X-Google-Smtp-Source: ABdhPJyidhSU9lS2I1HP9YG0E5I3cIiLsvT8CzglNpdpSJYt4uYgKZj2+aP38vkCL1094Axals7m2w==
X-Received: by 2002:a7b:c00a:: with SMTP id c10mr17198561wmb.119.1604317534760;
        Mon, 02 Nov 2020 03:45:34 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:34 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 12/30] net: wimax: i2400m: netdev: Demote non-conformant function header
Date:   Mon,  2 Nov 2020 11:44:54 +0000
Message-Id: <20201102114512.1062724-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/netdev.c:583: warning: Function parameter or member 'net_dev' not described in 'i2400m_netdev_setup'

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wimax/i2400m/netdev.c b/drivers/staging/wimax/i2400m/netdev.c
index a7fcbceb6e6be..8339d600e77b5 100644
--- a/drivers/staging/wimax/i2400m/netdev.c
+++ b/drivers/staging/wimax/i2400m/netdev.c
@@ -574,7 +574,7 @@ static const struct ethtool_ops i2400m_ethtool_ops = {
 	.get_link = ethtool_op_get_link,
 };
 
-/**
+/*
  * i2400m_netdev_setup - Setup setup @net_dev's i2400m private data
  *
  * Called by alloc_netdev()
-- 
2.25.1

