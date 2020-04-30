Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1E1C0520
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgD3StZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgD3StW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:49:22 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB8DC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:22 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n24so2589076plp.13
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zz+52fK48fs47NoVBKl83H6Ax83n/9bb5BiULrlEUIA=;
        b=TSKiSSQKh8Guw/G5Ob6mYSJOFKz8sfU2bVx/dPOwJ1Bdzrgk8Cu6ZeGylaX+Ur+ERF
         DdwLGUnZLcMb1kHhCVppsTcgfpxiA0TkcMSQRd7TRp8L7xCbOrOzXVNC+G6jbCHr0skm
         dCrXPbkdWzzLgriFGutY6O+Rf4vEgzZHnqSMW/njdqjwD1lIGqo6wkpGtZbEsktfftHy
         1GUYU5Ua/wk0y8AJdpnLx3ExgGFGUe78LsS07q0Ra5IqZLDvtYMmXezGALaCxbThfuay
         eBlRsbZXJt513qVuf07YJF7y7wvR1+9oGsa1w6QCZaaN7IwDhkyH+igry+w+sT3YYcX5
         /bCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zz+52fK48fs47NoVBKl83H6Ax83n/9bb5BiULrlEUIA=;
        b=UQoI75ktoNsuPmuF8CTqllh2qqW7oM9dLFscFAwx2s0JHtw1kRw+MfRw2m8uEswemu
         BLVclfYpSg9fOJSkp80Gm9bCWMk0VsA7yoc9NVo2hebrg9CSQLtE/JFQ9W3RMEUNEtEz
         w10I/HFYXzXs+qHO+ZaTBnenVWqtn0zj0lc44gVVILGk7sGJT4eB9hafVvHAYrTsE7UC
         iIJKrQjT57Eu9cpd1svGxBpQOKwTDszNtgSW0YbBObp6OqTm/tP+vkUXa/c75k3gUG3U
         2wfzIvdJsmPkERxbdJb/7lmgx6jhvwthOOVhl63WmLMcNacUGtJ20mgTkIgqQa0A3ZfQ
         vfww==
X-Gm-Message-State: AGi0Pua5p2dZuTpHQvYktE1ezrWalYvX+4p543RQuQUxhR+h/2uyV5cx
        LkwTgItDvcshAIqmt6Yv5l6tSnIH
X-Google-Smtp-Source: APiQypJvsjaui0LsXHFMNpoS2oC1sdAmCtSsPZ+ev7GUf/If+xT7b6e7nG8keEpmBHpZEg2MOCt2Bg==
X-Received: by 2002:a17:90a:208f:: with SMTP id f15mr222203pjg.60.1588272561707;
        Thu, 30 Apr 2020 11:49:21 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm426886pfo.145.2020.04.30.11.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 11:49:20 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next 4/4] net: dsa: b53: Remove is_static argument to b53_read_op()
Date:   Thu, 30 Apr 2020 11:49:11 -0700
Message-Id: <20200430184911.29660-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430184911.29660-1-f.fainelli@gmail.com>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This argument is not used.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 9550d972f8c5..ceb8be653182 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1484,8 +1484,7 @@ static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
 }
 
 static int b53_arl_read(struct b53_device *dev, u64 mac,
-			u16 vid, struct b53_arl_entry *ent, u8 *idx,
-			bool is_valid)
+			u16 vid, struct b53_arl_entry *ent, u8 *idx)
 {
 	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
 	unsigned int i;
@@ -1550,7 +1549,8 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 	if (ret)
 		return ret;
 
-	ret = b53_arl_read(dev, mac, vid, &ent, &idx, is_valid);
+	ret = b53_arl_read(dev, mac, vid, &ent, &idx);
+
 	/* If this is a read, just finish now */
 	if (op)
 		return ret;
-- 
2.17.1

