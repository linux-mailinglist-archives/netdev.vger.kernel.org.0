Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB50B4974D0
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiAWSuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiAWStj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:49:39 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1996C06173B;
        Sun, 23 Jan 2022 10:49:38 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id az27-20020a05600c601b00b0034d2956eb04so26141474wmb.5;
        Sun, 23 Jan 2022 10:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QNqDn3I3LJLzoyMZXKpcI7Z5iL1QVKhcITQ7cdN2Eik=;
        b=XTSyLsYruDxgGhVGg7tqEoHCKh7PCit7Tcwzd1PZxnc17OG1M5yfx2Hp2jHGXq1Ngn
         QfALqEFpgro6Kw6mOECJe8weHFLrdej+K8689SgNWME0OcvKkd7VDMmed3kAZITt+sBP
         H1ZFDWfExHmnjcOav2iVhMLQpaL0as+k1rXmznmBa85KOYEB+bZXmJi+6HbYozWpYYLq
         FqTh0rEkmeB6jaVBtzNxBd8M7klwlWBXE2HTAvLdZZDLimiyivwQ04pReCFgHhNRGZHM
         Upsx5za6EYRupJhomYcuMbY22jWa+PwfiwjuV/jXOgpqybUOcuab+H4ESIH1hwY4zy0N
         78eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QNqDn3I3LJLzoyMZXKpcI7Z5iL1QVKhcITQ7cdN2Eik=;
        b=lSOr8WDWZj65++MpTTm/wcbrwVQ19TQ5VBHTk+XrG+4mHxpiCJPHZjRptIfoQFIvb+
         bELwkPOLxJbymts3srfu3czAvR25Vq/EqQtRkfvBAWQVbrfP5KnHJgD/V3OMLhCc66KC
         sPxfZZc20h6xP+zdR83WHz8aTbXET7Fj2hueCjtqPdjNyMncnBsLc5nnJIJ/pYWv8QGD
         BRoza+fq07/8di3ucfpfdObYxOEBRHNzlv5LmcA9DGUbVYVMnwEd7j0/9BQwwWajpPPu
         1YoPxjvkykj5ZpR2EoJHY0r54kwRRCs9c+QcviCeEdObSzx9Y3o6eUayOa/q52dvGtoh
         CF1Q==
X-Gm-Message-State: AOAM532ziBgSnYgDK526rD07b2wWqk94t0/ow1CjgaWuEANcQpExFRPG
        /NsG7VKkEdV7MQ5/b18Zrlg5R4KcWQTbDQ==
X-Google-Smtp-Source: ABdhPJxNP8e3b/i3J1jIoUGak690AInHAgR5PpNWEkZNKxwUIDbwFrxt8DkRrzbZZjp4yuM3YhBOHA==
X-Received: by 2002:a1c:4d1a:: with SMTP id o26mr6375332wmh.147.1642963777165;
        Sun, 23 Jan 2022 10:49:37 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id m5sm11013691wms.4.2022.01.23.10.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:49:36 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: fec_ptp: remove redundant initialization of variable val
Date:   Sun, 23 Jan 2022 18:49:36 +0000
Message-Id: <20220123184936.113486-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable val is being initialized with a value that is never read,
it is being re-assigned later. The assignment is redundant and
can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index af99017a5453..7d49c28215f3 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -101,7 +101,6 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	u32 val, tempval;
 	struct timespec64 ts;
 	u64 ns;
-	val = 0;
 
 	if (fep->pps_enable == enable)
 		return 0;
-- 
2.33.1

