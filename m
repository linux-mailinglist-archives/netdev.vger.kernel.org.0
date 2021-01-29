Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8389D308600
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhA2GrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbhA2GrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:47:02 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AEDC061573;
        Thu, 28 Jan 2021 22:46:21 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b8so4703911plh.12;
        Thu, 28 Jan 2021 22:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j2nNsb+PpPp3IoJggkXhbnPAMjLO/Rz5D5nMjxNgA/4=;
        b=qxYacbX1M27vFIXSoWpMQjS+qOQm9ggyg0HAjoaz+oMYbCLS6crhJPL1Cs3wvW8Gl/
         wU+zwTjF9DVAj5m7nlj3TFtj8bqFZZz9jAtBlnUCUeKTehbNcuWNc269ykphmuco2z/H
         HSkbbwtkSd11rtL33Y7tuxxHzB9+Qfrs3jbf2di/RCbKMrrkTAE8uBcsvJxiTvyAGcjy
         Dkho3B+TkdV2ehDv8trR3fO+XXLCQbhl9h10LRNmkuY8NRdowqD+6uKDQy+BUFILlH7P
         DQw+MbwF9T2Sw+mKu3fw1NQA1CdV2HgeQrvM9URqh/Brzy5Ozxuu7Y23vfDSoGesJ3JZ
         d+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j2nNsb+PpPp3IoJggkXhbnPAMjLO/Rz5D5nMjxNgA/4=;
        b=QNBVrCiFSFOneSjumAmFvAcdKSCUHLNUwwo93VYaAaeVQ4Y6hjyTeesXEuq4x0AXy2
         8ch+7kaJy5BuKcVrtDnNbUldbqf9d2WEz3mtW3PMFF2kBhWg4teW5JzMS0ytJp8NasDQ
         sdGN258G3gRfau7EyPGfeab/R4lwZX7HEsl/QJQwf/Ur9lCnIiutms2btfdO1625RCB1
         V1bx56zYh+LrZqDIv1I006Ptg9uNbfdzQbsIOB+PjxEMHIaf+3q3y9bS3uWURtZO8KbE
         Qp8B8JWHvIEipSRJiJPxiOzrN73s252mxGL0PvJxzVZvL4x0/PLqpYHDEn5TNe5MAeei
         dGcg==
X-Gm-Message-State: AOAM5332ICsV/nKrW+E11AmrOZHJjAuJxpVVqm8Zw8fOSibJQYrCHF2W
        oldVOOGrb+z4gPVCJtiNVKOU6khvP2dB2Q==
X-Google-Smtp-Source: ABdhPJxIZIiaTCvt7GbLlBexTSqnh+YWJoI1mr6tPMpc0UXtcJ9Rb8Lzy3tF6/RObPe+QanwFW/9bw==
X-Received: by 2002:a17:902:a383:b029:e0:10e6:6ed7 with SMTP id x3-20020a170902a383b02900e010e66ed7mr2871426pla.5.1611902780644;
        Thu, 28 Jan 2021 22:46:20 -0800 (PST)
Received: from localhost ([2402:3a80:11ea:bf74:a2a4:c5ff:fe20:7222])
        by smtp.gmail.com with ESMTPSA id z22sm7146921pfg.116.2021.01.28.22.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 22:46:20 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     memxor@gmail.com, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge/qlge_ethtool.c: strlcpy -> strscpy
Date:   Fri, 29 Jan 2021 12:15:23 +0530
Message-Id: <20210129064522.97548-1-memxor@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes checkpatch warnings for usage of strlcpy.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index a28f0254c..635d3338f 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -417,15 +417,15 @@ static void ql_get_drvinfo(struct net_device *ndev,
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
-	strlcpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, qlge_driver_version,
+	strscpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
+	strscpy(drvinfo->version, qlge_driver_version,
 		sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "v%d.%d.%d",
 		 (qdev->fw_rev_id & 0x00ff0000) >> 16,
 		 (qdev->fw_rev_id & 0x0000ff00) >> 8,
 		 (qdev->fw_rev_id & 0x000000ff));
-	strlcpy(drvinfo->bus_info, pci_name(qdev->pdev),
+	strscpy(drvinfo->bus_info, pci_name(qdev->pdev),
 		sizeof(drvinfo->bus_info));
 }
 
-- 
2.29.2

