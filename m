Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E732878FB
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbgJHP5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgJHP5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:04 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315B1C0613D4;
        Thu,  8 Oct 2020 08:57:04 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u24so4683252pgi.1;
        Thu, 08 Oct 2020 08:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BZWfgYnCGeFpIPa21k7qNqO1BMWShyJcjVnWw4J6NkQ=;
        b=ejFzCotf/jsXbPXwii4iyLGaLyU0/dCxn/IezSLKc3jAD19AhjoKIkHOHex1TNmP4Z
         MEXZxfl4qSoRCVh1JcVPvuHvlamHwVU8MIiw7eLIZLtrOAL1EVcwJ4oV/PRSvoWtJGH4
         ZJtnNWEsHMjXEkMu0eYeOmKKY7TjdHeGVXHOVyuqfy46WiGJ2nLxWot2VNpyEIrJ2KSa
         TZWQujGBVc3OWSXXA3fqr+J8gdbFYJO/ANWPj49rw1JlxEfEkfDTqr7UjnIDGYeT6omn
         ZlYVfVwCJjePjRU7E/7ad5DHpTDxUxfZP1eazO7cOTzA1O5CT1PJt1qaXllMNdooQEMI
         +Adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BZWfgYnCGeFpIPa21k7qNqO1BMWShyJcjVnWw4J6NkQ=;
        b=aAADu5T42pXnfLaPbvDPA7WKblFWt1joIwwzIjZPUkSsiD9hq9gtbUvjm9UdP1l8H2
         +gTWHfmd+G7XE3qTCTdICjdleqQwr7avk88T4EmnNExxA+UWXEz+BjRVaNlfYUas1+St
         QRjXssClfuX0wE4k/hpn80JnXX6gX/arCD6OrR0MDZRIknu6Fi5U5OmniSrOPR5kkrej
         SwNHK+W3cHmzTaoqD+riD1R1ZY2ob9XA1ZdbRF95AT0BKazDUd+A6rQ0C+3rffDqs9i6
         Gh/sCcKP6demTYDpUDEx/JO/Vf7aHeoG9C+/JryBVqG1P1v2Kw/Wg0L88DSH/TbPH0TB
         hhsQ==
X-Gm-Message-State: AOAM532NWMDiYrgr5LWnrVpuwdh+aMZ4u++iWKfGMNFAwG3u1IS7CnrX
        HV3ffMrDBYYNWn5KfHB1nEE=
X-Google-Smtp-Source: ABdhPJzHoIUiSChwgu0dItYQdGH3lbKUfe2sL+AKBVptXR8rzKKFE6XIYWrAAokExax9FFKOy8dSzg==
X-Received: by 2002:a63:524a:: with SMTP id s10mr8190997pgl.40.1602172623729;
        Thu, 08 Oct 2020 08:57:03 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:02 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 091/117] wil6210: set fops_fw_version.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:43 +0000
Message-Id: <20201008155209.18025-91-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 13cd9f758a55 ("wil6210: extract firmware version from file header")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index b147b97c0d5e..c1a43de9a630 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2231,6 +2231,7 @@ static const struct file_operations fops_fw_version = {
 	.release	= single_release,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 /*---------suspend_stats---------*/
-- 
2.17.1

