Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC652FECA9
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 15:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfKPOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 09:23:24 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38400 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbfKPOXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 09:23:24 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so8062829pfp.5;
        Sat, 16 Nov 2019 06:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVDv/5DN1klovyqx6S50PzD+TGU+3UYBGPqk460As+k=;
        b=tjq8TIQvs0HedOdt08m2MgrCDE0kLDWx9aYuvVlHKWht5gipmGTdSrU3CshxBVAMSH
         eS4wFt6IG5+RgZvqvIJCiZmkLV5bojaJiSBQZhp3/8iLV538LpQUB4wODaBPsQx1JCyC
         YHo1l5lgiOU9kDCQkXrFrkjpuAMSv9QGig7NdNln2fni7UiopdTY/9fpQDlekWV9TDWo
         a7abtuJexA1OaSYejnPBkGTqTDo9H+nXW/1RCfz6XNOTqM7I2iB5BOLt8feIm4Q4EQ0d
         x3MSEZXM1faAM9AOWJdzafRl2BS7Xu9tFjxl/Ts84e2PjlsiaCqRZLd/tTARDqxfpALa
         UbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVDv/5DN1klovyqx6S50PzD+TGU+3UYBGPqk460As+k=;
        b=eqBWavxPjvPxc1CdbdJXge4iKK7mVjCZMjSZvmpBNs1f9yJzcKOaBiwT8cXiVAJw9x
         UkjNB/fpctxFQz4UXIe5MwFDeY1E1afNpgTIcMK9mDzAMQL8VEsEJm9JmG1V1oXxk3pV
         OTzv1jNC8Zz+9uhPngmNl8INrBnNwxCQ2mB2AVfwxlaZdT0mKS8h4/OwL5Quoy+T6cbn
         FYY1DCFY3/O8g4VGBLOdymeIpoB5tQghyNBfHqdZKdemA+yC3gLq8gf9MAPd6dLXgYIL
         GrXcPe7uiAqTqD+sRY4w8ImEmgk1zWJqiO2QkqzQABL8XOSJZjfMLIagRTSRaqB5UAs0
         uSbg==
X-Gm-Message-State: APjAAAV7EYZuSzMSk9LewZgVY6Ra146LZnmbSpSS4cIgQhmhOJEsUUnj
        2ejJoaNirhVbnOIwMXrd94g=
X-Google-Smtp-Source: APXvYqzgJHXk8opO3uQzaOlcz9dxdwBsCgPliRhtburTOfHBkRKmih2AJ4ayuul5+9eiAQLkvhLAPQ==
X-Received: by 2002:a65:558a:: with SMTP id j10mr22504706pgs.269.1573914203334;
        Sat, 16 Nov 2019 06:23:23 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id w2sm15678178pfj.22.2019.11.16.06.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2019 06:23:22 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2] net: macb: add missed tasklet_kill
Date:   Sat, 16 Nov 2019 22:23:10 +0800
Message-Id: <20191116142310.13770-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver forgets to kill tasklet in remove.
Add the call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Rebase on net-next.

 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 8fc2e21f0bb1..7bf86b84b143 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4418,6 +4418,7 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		tasklet_kill(&bp->hresp_err_tasklet);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
-- 
2.24.0

