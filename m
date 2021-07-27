Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06F73D7C75
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhG0RoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhG0Rny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB02C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ca5so321096pjb.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Le5TK/qKnBJqL51abKei4XYG6hFpBdjJJBFRxGy2g5o=;
        b=428YxjwYdS2OA9BT6a+cJWezzFJNOc2z7n9CD0RzTYEEVX4O5aU/wwChxRmVzYs7EZ
         Cgc8QIIwRdTKl0JG6v+i8w5tbz0LrDqs8eDqduW1skgSYjnfYmITc7Wt/hf0XMRWp122
         EsS3rDWX6m7zbSIy6zhuJ/cAyVy3IWk10kFbk7BRiMtYAuPTyiIpnrL+olht9xzm3lHY
         s/KwgOuv9uMirhYC2q8wICD2na80wSnN2r96Dpldmqb/PalfeFdkt32kDIT8bn/l3plJ
         EcKUh6hPzingZirmLOoCeOLXCmDrhNG+nnLu0c5oZCTGk7Ls2MYRPyquwrOVkvHgupBx
         eIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Le5TK/qKnBJqL51abKei4XYG6hFpBdjJJBFRxGy2g5o=;
        b=ZBqaC6OSnwbeAZN4rOLeN0hszx26TBpl1va+bJWSlM4q+5kGp0/FlhDqqfEKNTpICP
         lj2rN4DqL2iJLA8IBOA5mA2bQNW6BXypLAk7vfopLF661HC6K6B8l0qyjtquBMkkakSj
         yZYC1eVXIN/NH0hAwQ6X4nd3wtUGMmdjrl+NJLfKxEDLAWcOY4Wu804YUDRxQh9rvEEg
         cLiVFZ8X0lksoyysYn91MljShR2rCDvMEw/hhlmQ761WoMGcORyvqjagtqKMi+VSk0sh
         QU2gUdBuaELbipLmvAu5MBZ8ole03jDr0wmUnPFrsZPtDt5fpxl5PebQ7zBsafYlqoPi
         v3ug==
X-Gm-Message-State: AOAM532u9++YtXpMRgVrrDxbCZ3IyLBC4VCPcGwKqNckFvWZHxjoW2mb
        JolLQs7N5JoYi3a5vi+OhXfghw==
X-Google-Smtp-Source: ABdhPJyq13tsqH/Zzz1RbaUmzfKQHCOKOp8mo/ri8/fIVTsxJYi3RFtDzXfLEx23j0T6tW0UOOHxzg==
X-Received: by 2002:a17:90a:bd98:: with SMTP id z24mr5268666pjr.99.1627407834128;
        Tue, 27 Jul 2021 10:43:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 10/10] ionic: add function tag to debug string
Date:   Tue, 27 Jul 2021 10:43:34 -0700
Message-Id: <20210727174334.67931-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prefix the log output with the function string as in other
debug messages.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index a87c87e86aef..736ebc5da0f7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -119,8 +119,8 @@ static int ionic_lif_hwstamp_set_ts_config(struct ionic_lif *lif,
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
-	dev_dbg(ionic->dev, "config_rx_filter %d rx_filt %#llx rx_all %d\n",
-		config->rx_filter, rx_filt, rx_all);
+	dev_dbg(ionic->dev, "%s: config_rx_filter %d rx_filt %#llx rx_all %d\n",
+		__func__, config->rx_filter, rx_filt, rx_all);
 
 	if (tx_mode) {
 		err = ionic_lif_create_hwstamp_txq(lif);
-- 
2.17.1

