Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3BC2C32
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 05:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbfJADDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 23:03:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44504 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfJADDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 23:03:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id i14so8575093pgt.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 20:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WJ2NjbJMq3lOmAJqEgIyHx/7Ko24AcU+XIDukMDR+08=;
        b=tgyuZFwdDAWND5GF/2YpybYsUqiP2l31u/CzQ7akxCgMuVG+QuamreJaq6cleJORtc
         CRm4pWB5ZRbYmUMIMSgzb4K9BHrBo5g4eTGvnsx6UV8FPXsICZPDCSuGY0qlcsi64Bg4
         1XIoHVv7PHnfpC8fIH4Obi4xQqxmadvXGvRCLdQeRBiVDzNGECFOl//psiNKv5FD0npt
         B0Vb5Yl9w77HLZp62sU+EU5QHk9UNbpN4HIZhXiJT8sbTb4v7BlbOux3XFQH2zEht+Dc
         3aufJPGSzG6m3AMLf7wFMOKGeLFMhaBPXY05iW0vbk6ET6u+H2YN/fmOUYvhQuuWVhtc
         3mIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WJ2NjbJMq3lOmAJqEgIyHx/7Ko24AcU+XIDukMDR+08=;
        b=D3QfjZgXuCoi1VwaF7DkHSQxWE/AfHQP8yyv/+PJ4CKFyt4AJ3bIvpQJPMa3f9rZGo
         gmQGzqzdcfOQ7vugTKsZZzok1h2PTsjb5RCcDZNPg3ALFF7+uhfwcY8QSC/KYnQxLUTp
         vn48iTNA1qKXoRvBGdlTB5SwrVVHoWkURmZ/tpQxRh60g9Ub9JQUNAomqlYgrl6r05zR
         a2XUCEUb6PFPbHnlmJ0pW3KfRMl0PoVK0omAakNc7GS+EmUN+Eqwqd8buqx14StCYLEP
         MCoQMGKgNt7tseqii7C5lePL2KK+I2QDKlWYVli45Ic8RVWtnct0n5BCS79kjuGidWBN
         aomQ==
X-Gm-Message-State: APjAAAXTqcMZfp0HQT5jk0/APLKaQ6bAW9A77jYSajjlk/TnAnMFm4tO
        SmkNKIyIuTCEMFZxGKEuYtJ3FUK7Zrtpaw==
X-Google-Smtp-Source: APXvYqwGX5ywsjc/fElpcJBugkxkkymbJcExVP6LsND3OsHnu3XOhwzyGdQHxm+So3oOrEMW/1mc/g==
X-Received: by 2002:a63:720f:: with SMTP id n15mr26587485pgc.198.1569899016272;
        Mon, 30 Sep 2019 20:03:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id y17sm14831062pfo.171.2019.09.30.20.03.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 20:03:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/5] ionic: simplify returns in devlink info
Date:   Mon, 30 Sep 2019 20:03:22 -0700
Message-Id: <20191001030326.29623-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001030326.29623-1-snelson@pensando.io>
References: <20191001030326.29623-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need for a goto in this bit of code.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index af1647afa4e8..6fb27dcc5787 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -19,31 +19,30 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 	err = devlink_info_driver_name_put(req, IONIC_DRV_NAME);
 	if (err)
-		goto info_out;
+		return err;
 
 	err = devlink_info_version_running_put(req,
 					       DEVLINK_INFO_VERSION_GENERIC_FW,
 					       idev->dev_info.fw_version);
 	if (err)
-		goto info_out;
+		return err;
 
 	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
 	err = devlink_info_version_fixed_put(req,
 					     DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
 					     buf);
 	if (err)
-		goto info_out;
+		return err;
 
 	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
 	err = devlink_info_version_fixed_put(req,
 					     DEVLINK_INFO_VERSION_GENERIC_ASIC_REV,
 					     buf);
 	if (err)
-		goto info_out;
+		return err;
 
 	err = devlink_info_serial_number_put(req, idev->dev_info.serial_num);
 
-info_out:
 	return err;
 }
 
-- 
2.17.1

