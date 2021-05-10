Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DA437949F
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhEJQyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:54:46 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:42780 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhEJQyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 12:54:41 -0400
Received: by mail-ed1-f52.google.com with SMTP id j26so15849861edf.9;
        Mon, 10 May 2021 09:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bXLkpVtMXslYGX6op0binKvERZGlOYLeffR5i5Xpes=;
        b=ZdaRHOrJFGUSTeNBKjpmCmpyVKiO/EZsv1TM7WabPkGhOIMbkMiE2X3xPuDODn32S7
         5Vm2CyOxaV6gY59OtAqtRfSbFEqnW6OvPSfrSUZ0xKyZTVMmxNYwFk2HotbsOmWv/s3w
         WWy8KysqMdL2bgUDfqqINzqOASBeXs9jS39upm93cuSLX56xuxw1tpI6D+KmQEJBL1BJ
         z9fNEbQh9VXXVKGDNk+aw+MUc995994tdTUfZSvSeh1ZRQvJkU6gddM3OEZ/r/riDaRH
         GGvYp9Sdfk+0lEwg81LrYGeVkp1kQj1We6FsV9ackvIBc3odDe4Ga074RbnHHFHr/ye/
         MhZA==
X-Gm-Message-State: AOAM530Q1ttA9WhVZzujVXVA5S6mtdxwSNRTyh14n5PDMEN6cNZBG3yB
        viXLBVnQKOQORF1wpmLmf7U=
X-Google-Smtp-Source: ABdhPJyoCeWu3cKJZP4w9f4u4GDXo7AIUbWfJ+14Y7oBTmEO0V0G8zmQGxjiqFhFjrtHOOl3YlDz5w==
X-Received: by 2002:a05:6402:416:: with SMTP id q22mr30713096edv.204.1620665613644;
        Mon, 10 May 2021 09:53:33 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id t7sm11930469eds.26.2021.05.10.09.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:53:33 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] mvpp2: suppress warning
Date:   Mon, 10 May 2021 18:52:32 +0200
Message-Id: <20210510165232.16609-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510165232.16609-1-mcroce@linux.microsoft.com>
References: <20210510165232.16609-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Remove some unreachable code, so to suppress this warning:

drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c: In function ‘mvpp2_prs_tcam_first_free’:
drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c:397:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
  397 |  if (end >= MVPP2_PRS_TCAM_SRAM_SIZE)
      |          ^~

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 7cc7d72d761e..93575800ca92 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -394,9 +394,6 @@ static int mvpp2_prs_tcam_first_free(struct mvpp2 *priv, unsigned char start,
 	if (start > end)
 		swap(start, end);
 
-	if (end >= MVPP2_PRS_TCAM_SRAM_SIZE)
-		end = MVPP2_PRS_TCAM_SRAM_SIZE - 1;
-
 	for (tid = start; tid <= end; tid++) {
 		if (!priv->prs_shadow[tid].valid)
 			return tid;
-- 
2.31.1

