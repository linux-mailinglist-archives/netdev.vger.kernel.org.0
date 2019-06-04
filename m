Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DFF33D62
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFDDFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:05:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40446 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfFDDFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 23:05:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so12066156qtn.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 20:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T8fvVbHUlEwdcjnUoUL6Z3/uFUCtkzzPW+EIvSN2hWA=;
        b=Qr6iQ3sukoz12+t7eHDGn5IN/wQIyO7/CFuRQb4qXE2yWtG8rLQxqFpw2mwSOaQCsC
         M+2FrFkcKKzSND6mhp/VYLsxmb/t9puNU8kfy99g/vO8EdsOT9TnC4qsoEKMQB42yQHI
         Es6vY3tVeItVfKZEoY+unVjIbnITPs02nQmhYnCiwDgiuvaPm/lrGmTiTNk6xdiiXkFQ
         rcCV1pP2DJPdamRqJGX77jY/erDRH6GbCcK3nNtPllA3fQLaaPL2E760yUtFq1pWjHEI
         BsfPR62yo0DjkByXaWNE8yGPiD7UBb3+i5TlFl1uRZDzM4nrXM/hpZqs4yOWrsuTicjs
         h4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T8fvVbHUlEwdcjnUoUL6Z3/uFUCtkzzPW+EIvSN2hWA=;
        b=TehByNMxz+A6uZpUzgXyc7p7zxeNNWS2l7s8Zfs1qg6jAOtTmskYovAEpMmwVyGUO6
         8u+fMztsARoEG1m5npNzXezmdTkuz6u35d0kkqlBCvJsrzgb2bUezgLHaC+UmNj14TDx
         R9Q5cxFIoo61PHUQWTClfhUxoBrbT1fn5+LZSHk6o20MB2XU15qX0pfI3UdwNSf3AYSE
         iH7MJ6cC1dSUVCpuzu7Wp9ggCfFFYX05k9nNtnDM+yGGBKbvHLP35S88GWOy+X0rhALG
         FH8Qedw8Q8VXG31oBpt+BpxsUph0JWm0Q9TqcnN3lDyhyGlrNZRZSxr7JEjI7kF0cZGt
         uwvw==
X-Gm-Message-State: APjAAAXcHc25EpJ+VRECzPkfuTqoG5+Xx5V8BCYzA1jsSKUdn+oMG5/E
        CCSUqgIyXngv4MfHMk+UL/o=
X-Google-Smtp-Source: APXvYqxAaqZpynpXEG844QOJrbPLNQItmGsonzTuRoiSSDWDGx1l0CgMnKReQSBsD4IcETIcLZDasg==
X-Received: by 2002:aed:3c2e:: with SMTP id t43mr26820667qte.39.1559617502707;
        Mon, 03 Jun 2019 20:05:02 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:3c8:56cb:1049:60d2:137b])
        by smtp.gmail.com with ESMTPSA id z12sm1135915qkf.20.2019.06.03.20.05.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 20:05:02 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next v2 2/2] net: fec_ptp: Use dev_err() instead of pr_err()
Date:   Tue,  4 Jun 2019 00:04:45 -0300
Message-Id: <20190604030445.21994-2-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604030445.21994-1-festevam@gmail.com>
References: <20190604030445.21994-1-festevam@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_err() is more appropriate for printing error messages inside
drivers, so switch to dev_err().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Use dev_err() instead of netdev_err() - Andy

 drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 7e892b1cbd3d..19e2365be7d8 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -617,7 +617,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_clock = ptp_clock_register(&fep->ptp_caps, &pdev->dev);
 	if (IS_ERR(fep->ptp_clock)) {
 		fep->ptp_clock = NULL;
-		pr_err("ptp_clock_register failed\n");
+		dev_err(&pdev->dev, "ptp_clock_register failed\n");
 	}
 
 	schedule_delayed_work(&fep->time_keep, HZ);
-- 
2.17.1

