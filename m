Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6569F2B063C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgKLNUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgKLNUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:20:11 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B2FC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:09 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id b6so5979908wrt.4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LII9MNgt9pv1krh9xVWqsqClr9UQVbocm2wzkwzWn8k=;
        b=y26/CrKRMckJBmsrPXZ57maQyGpG/r7AzJk8ZEg9fz7LcpbCmzBKSDcHI2Sg66PzQj
         uRmSVTWXX4lTIbA07TkRB/9QxaFl1Cv0MypR3nOXQTFCuEI6CDa+3LuyomDu8RNTfVkC
         kIRmmqwZBoADKBXDiBJdComCFtEW01ZVKh/A6bjcUc6kV3Y9Y+UzmQWvR5I7kEcI7O+f
         FOKD5uia49j3F+Oqj7O8g2vSW3pw3D1otIrV6NzSbNLJqbGX1EOaD6SUlMufZSq4DDar
         LyoPTe0usXqm50eHkHNF6+IYv8XSBemL8m1xZKwJRO8oi6joWMZEV/ss4ArBdENaXN/1
         GWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LII9MNgt9pv1krh9xVWqsqClr9UQVbocm2wzkwzWn8k=;
        b=fB7xp7Vvz2cWEW9wX8Ombpq4aDd5wieXi0qSbQv6+Jqv4fiGHsYvJ6GXjh2stPClKB
         gNhUfazCUbZsJZb+8cD8eM1pVL9hENj+pj4h/tgyrkzmWGbikVxNxrcxtOZWI8CPQnEx
         yGAC8vWrrMvjxgxjgKbvWOg1nwKlZRwy686bdztuyGdivBnOH4/43uWGp/iqfoy2gCfX
         ADKkCEXb7Au+FAt/LV5hTK8wlDkDOGScFEz3bKshOWE+Bpl6EJtoTCASa9T6OkOl9Ut9
         TaQFUDJrY4QV3bfp0LWkey+kCk5/mxplUc7KgKVfqfGjrZv1+cf6L8n/tRBoBlw1B+vB
         5/ww==
X-Gm-Message-State: AOAM530APzm/R2Hg5emmQN5JKrl9tc+/gTFYi9uPqNTj/Yr7zwFsTvM4
        Mv7wTkK6Wdvy9cOHKoMuZNgb1Q==
X-Google-Smtp-Source: ABdhPJzHfYnKQzvyLB/MD8YUCmrJjSC0CX5kUEpgJNSnqQu6q+cJK6cgvJfEWBAO7tRBswcwJfhpdA==
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr8729158wri.29.1605187208708;
        Thu, 12 Nov 2020 05:20:08 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id t136sm2806326wmt.18.2020.11.12.05.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:20:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 4/6] staging: net: wimax: i2400m: netdev: Demote non-conformant function header
Date:   Thu, 12 Nov 2020 13:19:57 +0000
Message-Id: <20201112131959.2213841-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112131959.2213841-1-lee.jones@linaro.org>
References: <20201112131959.2213841-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/netdev.c:583: warning: Function parameter or member 'net_dev' not described in 'i2400m_netdev_setup'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
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

