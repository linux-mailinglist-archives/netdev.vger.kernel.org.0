Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A71C2762
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfI3UyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:54:19 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34264 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfI3UyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:54:19 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so42090711ion.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=WJ2NjbJMq3lOmAJqEgIyHx/7Ko24AcU+XIDukMDR+08=;
        b=YJqgNTNtyh+NH3NZkmVDD7YCDh0zpcJYNHEVPxnis4aYaC6qjmINtgxnbW1FLBLXJY
         8auv+dtt2DPomXIVGL4N2js/BQKdabuViWmi+52D23y5zv8MZEA4iMfVcPjA5oPPztgp
         CWivk7JAGX1tgTKsIdh7/MtSocnhAoLzTZHENM9k0VavDb9bSDV0FMSMNkR4nwP4t8T/
         g+mWtA56Zx+oRCJdvScJZiBecoKWXaexkq0FHTL6GGsJ721ObBqooKarahwmnFG1SqF8
         VabhQyZ/Vq8XFJDpGZrfX8q8SS3UfMr6WiMk6rbo/YCQSPkTuWICqXwrGckgklOkBE2o
         rYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WJ2NjbJMq3lOmAJqEgIyHx/7Ko24AcU+XIDukMDR+08=;
        b=slE8kaNbfzkRRj7izoG6NYLGAkZhJXxCcE42sW11YWd1PY7WXFSwrp0BteQzteVKJ9
         T03czSeMBMHEZcJ8NOrHCMG1IEnVGOyAHZdDsPuuslGHsdxi7Aif6FmDdhQUK6s9qbfG
         a49d0+Pu5Lb6BlgNDHKa6rMR+/okwVrBQJC8mljdTSyin1bHkzsLedNAmHE+OfsyDJzA
         /0DPQplGXxzZd7wHOTpU6hp3MlmiCbhUfgi2IpT+Cy9AQEsGQa2vrjUb7ZoD7pBZc+iB
         uw++F/9HcVGDFwmdC88QV6bhxBiDSKYwmJnZHuJaG6EA5TIYQqXHJjKpWYK9kXy0IzKu
         rLOg==
X-Gm-Message-State: APjAAAUwr6OBMOTxhl2yZBkBBEoSwQ+cbD81TporStvJBzFIhXvefd0m
        wV0KCGwlqsE3ytf4QbszV3wgeQmWGT5lAg==
X-Google-Smtp-Source: APXvYqwofpFGIw1BRswdhvULt5/UJw+pIM4d34iQQIZULkCNCY8/SloxczxwtYYVONqvxLScqqNFxw==
X-Received: by 2002:a63:4558:: with SMTP id u24mr26472413pgk.262.1569866535194;
        Mon, 30 Sep 2019 11:02:15 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id u1sm153873pjn.3.2019.09.30.11.02.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 11:02:14 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/5] ionic: simplify returns in devlink info
Date:   Mon, 30 Sep 2019 11:01:54 -0700
Message-Id: <20190930180158.36101-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
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

