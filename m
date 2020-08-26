Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D1D253A71
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHZW45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgHZW4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:47 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230A6C061757;
        Wed, 26 Aug 2020 15:56:47 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m22so4252059ljj.5;
        Wed, 26 Aug 2020 15:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afC6eoAZztl3Q8Idac3immDWpySqEFxQWwnaYLkH85k=;
        b=EnWlVTpWzPBTdMBz89ngZhwDupx5yWCX2+sryIokHLdjAqsApZAhF6ehBHAuNMxZS/
         ci/TQqwSBszsV73XX7GAVNkJX6V+VLtV/xbBzPv3a7gMXIZp/C1CMCIP5XP8D/OHJ09w
         Ai3l9jzOHlBBQcnJmAbu6tqSBoVwHZlPSMqxPfmkjYkFF4ZYTxxcNfx7maGtP00HfTL1
         KDIEVpU/SDNLpbDHUAD/wxA9FLRK9ccEx7wR2UxCG4QSG4T/tcWXFML8VPPIAZOg9Mbi
         Iu8vMrDwSFQH6cb6Ks+0UPnFBGy4YUzPss1hbpRBYuYihrBZJXFYOp5AbvnYe1U1rLGk
         8Apw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afC6eoAZztl3Q8Idac3immDWpySqEFxQWwnaYLkH85k=;
        b=EqOa+SybYbWxWSl4pYYPgIEVR4XXD4DKoi27yhrUOuChFgyRgZM9+kaIgOh/jSkjBK
         hbQHvYSe8UF+EWvdevjTEw2MUchTjhSzmeQ8aS3CQl2tBu9Z7og1D46l4t/VQ3S11cvn
         SBXEsrIftFCNo7D4v9Crx/qhp5fXdW56w3hGcsjGhAcT0dLaSAWGODtX4ApnpG5Q7cev
         PLUEetiewkbL4fbdoHlF4jI79cUijFnI6hZDN3AD70mMQt0o6cburrkxUzDIgmdrA7GD
         L4ayHTnKhijDMb7befCBAWlltV+VjbD01QR8ahw9AHAHCdJ7EiixE4t3SQo7Em0GvT6B
         12iA==
X-Gm-Message-State: AOAM531RXBk7MySKuxoS9CZNLwFl/iuTkMGBB4CgD9hrOPV2NOqclEB2
        yr1Ui313572NugyygPjm+ew=
X-Google-Smtp-Source: ABdhPJwyQjh8FYd5hcYFWrzSRrsgrgmpsXsNdXoLfkbX3mN44hHwU9EOjmMsVfR9kqYxQ5+Ilhq2/g==
X-Received: by 2002:a2e:b0c9:: with SMTP id g9mr7947765ljl.65.1598482605563;
        Wed, 26 Aug 2020 15:56:45 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id u28sm49075ljd.39.2020.08.26.15.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:56:44 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ath11k: constify ath11k_thermal_ops
Date:   Thu, 27 Aug 2020 00:56:08 +0200
Message-Id: <20200826225608.90299-7-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
References: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of ath11k_thermal_ops is to pass its address to
thermal_cooling_device_register() which takes a const pointer. Make it
const to allow the compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/wireless/ath/ath11k/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/thermal.c b/drivers/net/wireless/ath/ath11k/thermal.c
index 5a7e150c621b..c96b26f39a25 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.c
+++ b/drivers/net/wireless/ath/ath11k/thermal.c
@@ -53,7 +53,7 @@ ath11k_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 	return ret;
 }
 
-static struct thermal_cooling_device_ops ath11k_thermal_ops = {
+static const struct thermal_cooling_device_ops ath11k_thermal_ops = {
 	.get_max_state = ath11k_thermal_get_max_throttle_state,
 	.get_cur_state = ath11k_thermal_get_cur_throttle_state,
 	.set_cur_state = ath11k_thermal_set_cur_throttle_state,
-- 
2.28.0

