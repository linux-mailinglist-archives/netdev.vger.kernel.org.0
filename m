Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B362878CE
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbgJHP4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731368AbgJHPzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3966C061755;
        Thu,  8 Oct 2020 08:55:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so4320568pfp.13;
        Thu, 08 Oct 2020 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h0p8Xt3XdtzkknQZhHMSvFqlGsHM+pNMkA7g9tC8aVQ=;
        b=bNwV1OIYrYq31PGTPm81oj0LtmtRT+fRvQEPkZBwF5fC08wh0rLWFISYLsTsmRMhQJ
         1U9H7g1H0cVHXDX7tB6CHD4nOMABoDQEtnSipa4rzBjikeRGqar4wUbhYSHXJj5BzRx+
         5/8h4m0J47HdAyZZiMtz5wlIh66XhfP2a6IHuz7c7Nq0dB/r/IIxnEAbnxcIOD55wtic
         P3S8ahAhqsMD/MX6QRChUZRtVq5gO6R6DLBjwlEOzcLQeILaBs+HCu8pUUzMP64aqC6A
         Ugr/CB0r0NbhTorn6FysNlEZdyAnYtML5bJlDINpUN2JKZtQvStNxOsazu94Aguic3NN
         HObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h0p8Xt3XdtzkknQZhHMSvFqlGsHM+pNMkA7g9tC8aVQ=;
        b=EImcXVmLTjCBNMTt/dBwyIxw6w4xXJhz6tpJegYzOaYPD56sK16fnPhJvzUJ5iGDyi
         MJ4GopI1mwVESxEs7g3NpBcS7Fpq9DiFtiv5SIHZUpwyBENXqAh5NaduWpSjxNwqms+y
         OHcqAVbKWxQljqOFfSeAHqk4I6KH4/22J0NTFjqzQMhD5EMkbONuH1mNIUncUJa8mJi3
         112HGEQXJN3vBHCF+SvsAuoAOm0Yep2/Pw8iQ+O2DOxpmBkC2Lvxh8HcyI2rJpexmdu2
         2WJGP55D+7JKuh428NhQIq7PwXaEmXGqijPiZpmevL5dBqU+U/JBDY8rQvcOMV7oiiWs
         ynnA==
X-Gm-Message-State: AOAM530KPQZSy/oHEh/6PI4LY0goi2KvsSHtZhkesj1Mw+Y02pRjx8aB
        P8x2WD5GqyuFJv0lRRGQ/E6VB0CK4B8=
X-Google-Smtp-Source: ABdhPJz/e4VdJLBe/mCNniWHnfrhoiYUmnurgtTy+P04ZaTMruVShtSafOA0vI5BT2LeJ/3XsdUE+g==
X-Received: by 2002:aa7:8d4a:0:b029:152:4da3:df1 with SMTP id s10-20020aa78d4a0000b02901524da30df1mr8125995pfe.78.1602172543409;
        Thu, 08 Oct 2020 08:55:43 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:42 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 065/117] ath11k: set fops_extd_rx_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:17 +0000
Message-Id: <20201008155209.18025-65-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath11k/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index 93461e840c87..8494ddbef7e7 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -775,6 +775,7 @@ static const struct file_operations fops_extd_rx_stats = {
 	.read = ath11k_read_extd_rx_stats,
 	.write = ath11k_write_extd_rx_stats,
 	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static int ath11k_fill_bp_stats(struct ath11k_base *ab,
-- 
2.17.1

