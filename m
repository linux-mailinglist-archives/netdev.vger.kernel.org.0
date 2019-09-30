Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481B0C2920
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbfI3Vtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:49:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41875 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfI3Vtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:49:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so8097013pgv.8
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h24U/pDFeFhysb6jTBGKDxtavedojYgfnOxmpjoiZjM=;
        b=L+qEzGWZcF5Wtx6qdkgva89wxhHm1laN2/sdIDFEGV5cEuLcWcexj0z7S7fpK4UX81
         oVPp6W5OIZiH2z5lI6aV1onAQX55hvjd4Cdutedv062qIG9LUoPKOBDN1lxSvjFDa5hx
         HGZ6uRvwaONPxjp6gPJ2rIErn4HH59oGK9KIfKd9IL4v8s0z4HcNbNL5GnMwDO1o5qfm
         B1RFYiBt8hheiW7slYzRqA+sXcozjagf1+gKpyYKd1dbQX+2fGfTqPMAPYpR30dAEZBU
         KJgM2KMVeGJVhtXdZsEFVDtb/oiozFI90Q6dALXtXPzjvbqL8koNgZh4TWVq9qmyFZFs
         K/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h24U/pDFeFhysb6jTBGKDxtavedojYgfnOxmpjoiZjM=;
        b=lfB32XHIWBpleK1IWLaKpWThqknqLvo0LIV7WOROYJQ76BeYZVHkPx4yT0Jw4Ie4K1
         0zDz9yikvQyumdeTSVlAqwfGdbA0H4EiBI+grbFkX7oUW+bD2t3LMV0gvfdVS8zyGZXT
         SIdlOk/nVqAEDYKh4Ph2SoEbMfFJnWQHxqmtQ/eY3A2vV6GehhwFd97g9WivQN8WcahR
         GWOdbZR/NV9DwM4CbLQkmBZjODrx5TjO9K8vVK77QeKRlT6MQtbqW8euUXlG47+mBXg5
         A5eMbZzILUHW821ATC5bqN0gUk5o2mCob/vg1xE3FoBy0hJWFVx5Nuc8sjYO99xRt3rO
         sjbw==
X-Gm-Message-State: APjAAAWA0gzjjoPjJCjdrgQLQZ6XGBK7QKxdePmM44WaGBJJmW+rD1sS
        p4KfOEAjCQS95nWbR/Dlr45GJEf4cgyVlg==
X-Google-Smtp-Source: APXvYqwU/UPCY2CfWYDG2Po00TUDvs7CkqRAwCiU0n6J9O5vBqjEizl0nhaCKK8Nw0t9TVeRp4wNeA==
X-Received: by 2002:a17:90a:380a:: with SMTP id w10mr1587657pjb.104.1569880169911;
        Mon, 30 Sep 2019 14:49:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm505746pjk.25.2019.09.30.14.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:49:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/5] ionic: simplify returns in devlink info
Date:   Mon, 30 Sep 2019 14:49:16 -0700
Message-Id: <20190930214920.18764-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930214920.18764-1-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need for a goto in this bit of code.

Fixes: fbfb8031533c9 ("ionic: Add hardware init and device commands")
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

