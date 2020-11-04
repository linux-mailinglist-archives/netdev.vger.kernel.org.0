Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D38B2A6025
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgKDJGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgKDJGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:30 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6432C061A4D
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:29 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x7so21205754wrl.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RhBSE8b4jj6nqalJuypI4+LMHNUIblPNqmwOKfwlf3A=;
        b=d8FYw5y9s0ImXUjzT+/ScM6dF5Zk+3ZdbtCBgOnGFpLmHyeB4rOmB5cMhR4MR6lAfS
         RM+6xbp7eHwL027rcdRu8CUlxsVfAzNFbpFwMv5UuLjHCGoEXq7FCjk4B20qN2zkL8Ac
         d16wgGn50FntKCv0rUD7ym1afd/Fzyraym4GeRi6ppRSlZcFevlgc4MHxv00CpCq51P/
         CbXzdktCGipU0YKM+ft/ceL/PaxcSnkZU5aT3vbMJj3EL/60TAoR77ksYx4Oai6mnGuS
         IVGMOTeC78xAicux3kxh4PZWpncnirnlIOIWM/AEg4Qs7oE6NNj6S/BHnsEvqBFxgq4h
         f4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RhBSE8b4jj6nqalJuypI4+LMHNUIblPNqmwOKfwlf3A=;
        b=tehNSXzVhRXXPBgjPbjOtt1kVbDUmXHEJ648A2O+LAPhWz/cBceHzRR+T7I7I2FeBq
         wPLu3siFeQlc2V1EGvRz/qBjlhg7tG/CWOzjQbGzudtNqfdX0+2JjsX8vc2mJKZjbvJd
         9hUhlrzOb4pszozYvlQMJt//CHeL3xXFdJQq8LH4aymliPjwV9RacjHDiWFBoaRlwqSR
         JJppB8syOrftHaA1SyyyUW10Bq5igE202MdE/n63Qg1h9AA2Jy7g0qMqdbHZNIBOeQTJ
         Ql1lpFJ9x/ECPwPCBHdER/GNrLXjpFwHigHajR0pDrTdep51mEYUcWKF8SBjGtPi9PkA
         xq/g==
X-Gm-Message-State: AOAM530YU04lGcLBojkcj71w7UheADvKMsGnRiJmxFlHevWwa9ZxPQED
        cdfRKeBCXI/NvZkb2FZdK2yTrw==
X-Google-Smtp-Source: ABdhPJyWn6Thfs9WlMimZUpG4aYPiYRWYcZaPQWulRw531rZTJAAvRRMB/8BuOwFxR5z6Yr3ILzuEw==
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr30157001wrv.49.1604480788414;
        Wed, 04 Nov 2020 01:06:28 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>, Erik Stahlman <erik@vt.edu>,
        Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH 04/12] net: ethernet: smsc: smc91x: Demote non-conformant kernel function header
Date:   Wed,  4 Nov 2020 09:06:02 +0000
Message-Id: <20201104090610.1446616-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'dev' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'desc' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'name' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'index' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'value' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'nsdelay' not described in 'try_toggle_control_gpio'

Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Erik Stahlman <erik@vt.edu>
Cc: Peter Cammaert <pc@denkart.be>
Cc: Daris A Nevil <dnevil@snmc.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index a3f37b1f86491..aeb6d3a017c9f 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2190,7 +2190,7 @@ static const struct of_device_id smc91x_match[] = {
 MODULE_DEVICE_TABLE(of, smc91x_match);
 
 #if defined(CONFIG_GPIOLIB)
-/**
+/*
  * of_try_set_control_gpio - configure a gpio if it exists
  */
 static int try_toggle_control_gpio(struct device *dev,
-- 
2.25.1

