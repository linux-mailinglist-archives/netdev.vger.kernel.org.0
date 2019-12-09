Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1778117172
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLIQWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:22:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41232 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLIQWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:22:20 -0500
Received: by mail-pf1-f196.google.com with SMTP id s18so7482356pfd.8;
        Mon, 09 Dec 2019 08:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1WchXByJdtEUq90E1n/vrDWDGRooLaARsJZ93BiIjh4=;
        b=MugDM+mL+KSCPyqjfhhBXj9LjxiGzJb5I2Z3C8EHAV8QVerqqSPA9KemYncix6rnsd
         OVjezkkRyH6ybNmQ8s3s4+rZT4hAU+zeGHjX809S7p0lJPY83r/W6b8U/C+OKP8nvNxC
         43/MgzRWHTGr9zroE2VHUZmRYeshEBe6Ifl3KWYZANOuRoRqPs6NgfKA+3VDxC1eiaEA
         a+QGVmPBbT/yNfzHL0RouwRtR9IpqrhA8ukMaVYzP7BidTxpY3u2dGrO0Ae2Hr5oaJC9
         n1QKEhgPFoehNUqBrqUFn4jiHkhpN7F/CeeWTy8kAD6TT5h4r0SoSogNWDn3O0W+YUQe
         FwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1WchXByJdtEUq90E1n/vrDWDGRooLaARsJZ93BiIjh4=;
        b=c0VSm2vC8jjwAb+rbwhckBVWaQWHm9yKGRGn5v9Rfu89Ph+lSHRej7nBaGbmJ4dysv
         E1ce91dYkVhcIafMRn+MvBN5xEuw0vMYpnty571Z9aXPVUvGEdfYtRgUOAN81tq6xdwd
         Bmnfbr/gUc+tN9MQVhzQqT0i4877mEcMOLVaAyYxTGKsPwXLKSjTR89X5OpNzREqdRKE
         q89rEY5Xk05Fl4YvXN0Nbz0WdX3OA1jNhHh0f9HGzzvUjeeNrDH07tcmQdS4VzC+vzOW
         Q8TGOApO95GNBfF1K3gk7Jdrol4yFob56dKCYcpDIeMM4Ua3flul4aNdTbe85HJAuk/g
         qAHw==
X-Gm-Message-State: APjAAAVBG+4YChqHzRs22Z8BUd/yLbMlFBjmIhooN0P3ykajXJXmeF80
        6MPTVLjXwOe/+ZFPK8/7WneCno5AGHU=
X-Google-Smtp-Source: APXvYqwhWzAsuYvQLN0xKCm+fPbIVs0ilIo5yZp/kpbRUMNEqJ7Z5ywErb8fmqFQ1dQu+zf4drHaAw==
X-Received: by 2002:a63:6d0e:: with SMTP id i14mr20013323pgc.12.1575908539486;
        Mon, 09 Dec 2019 08:22:19 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id u10sm46106pgg.41.2019.12.09.08.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 08:22:18 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] fjes: fix missed check in fjes_acpi_add
Date:   Tue, 10 Dec 2019 00:22:07 +0800
Message-Id: <20191209162207.14934-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fjes_acpi_add() misses a check for platform_device_register_simple().
Add a check to fix it.

Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/fjes/fjes_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index b517c1af9de0..91a1059517f5 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -166,6 +166,9 @@ static int fjes_acpi_add(struct acpi_device *device)
 	/* create platform_device */
 	plat_dev = platform_device_register_simple(DRV_NAME, 0, fjes_resource,
 						   ARRAY_SIZE(fjes_resource));
+	if (IS_ERR(plat_dev))
+		return PTR_ERR(plat_dev);
+
 	device->driver_data = plat_dev;
 
 	return 0;
-- 
2.24.0

