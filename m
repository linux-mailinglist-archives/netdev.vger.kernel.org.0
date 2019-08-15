Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075278F520
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfHOTt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:49:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43415 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730491AbfHOTt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:49:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id k3so1734125pgb.10
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 12:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i8QNU1xl04T+eOac39szO+SgsFkNj86PfWbsgoUUQqw=;
        b=e9M2SaNIXYR6XcfY3RLTqG0HHbVEGkpyzc5nTnS0eKWOnOjkpK4GtjZlC7gRWczlp2
         +oPjZGhoRIaqaQ+FYUh8MUebmdf+tuMiWppaRvwvKDsJlKxZfwyvv7osADxxtshYKC+Z
         LxFY3qQY919qYB0X4KMP9d2wQxo1QuiXxhMhkusj0xUqQLxBcrLU3WmD83UgLS1RMRHt
         zudxe3siKyWZPwcJ1j8IMzMPdCvnBZ6ViUoj4+5HHkFLJFwLlQbBeslIjled5cge5Im9
         xEjfAW8psFL4PAdkEO88OcjBngI5YXNeaDpALmCTGNGgwHJTcSKAPWoEqrH/E9hqaWot
         NPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i8QNU1xl04T+eOac39szO+SgsFkNj86PfWbsgoUUQqw=;
        b=jOZmFreDx/zMjPS4BqTvUXz9COFOJ7XyLo65qimioUO0UxADmx5WXzJQyD3NZRVuff
         ms20AnR0l2EE6jVlusqkyE8E6y2ZG+gL40YNsst/04dmLAL8Nn1s1O+8iRlDpmcKZV1e
         ihvGPdbJ1yVIKTx2GjqtYkZdtnKSH7jfmm+3hJ0pJrgxSjEFyTGyKr1W9fnjBvTgRyxJ
         AtWQn/qG4kgFnuiuFf6TE4xCIiAmYBz6OMFTS/hMrDhcCxPsvp0f7gsfDAWGiUcLJTgW
         iD+Upcoy1/7s3/nP67h8qb5Bxe+Fy/urExlVWhHv/tC2+uBmthRye4tbT7xLQOVuW0PN
         QYjw==
X-Gm-Message-State: APjAAAUo5qcNdnCPDWkkAx6OCH/M99PIpFuIU1wstKC3o5eH8PQYH3jI
        aJfo59tu6dvl9NtNFjD/eVS/T7iVX6I=
X-Google-Smtp-Source: APXvYqwKyteM4FepQ56JgJZuAv4ZeIHQ2/r90hW/5R6+Q82ON62UQXjFhc5HMZWy5/qDOrgnJj1HcQ==
X-Received: by 2002:aa7:8edd:: with SMTP id b29mr7256801pfr.173.1565898598669;
        Thu, 15 Aug 2019 12:49:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s20sm3438600pfe.169.2019.08.15.12.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 12:49:57 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     yuehaibing@huawei.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] net: cavium: fix driver name
Date:   Thu, 15 Aug 2019 12:49:49 -0700
Message-Id: <20190815194949.10630-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver name gets exposed in sysfs under /sys/bus/pci/drivers
so it should look like other devices. Change it to be common
format (instead of "Cavium PTP").

This is a trivial fix that was observed by accident because
Debian kernels were building this driver into kernel (bug).

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 drivers/net/ethernet/cavium/common/cavium_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/common/cavium_ptp.c b/drivers/net/ethernet/cavium/common/cavium_ptp.c
index 73632b843749..b821c9e1604c 100644
--- a/drivers/net/ethernet/cavium/common/cavium_ptp.c
+++ b/drivers/net/ethernet/cavium/common/cavium_ptp.c
@@ -10,7 +10,7 @@
 
 #include "cavium_ptp.h"
 
-#define DRV_NAME	"Cavium PTP Driver"
+#define DRV_NAME "cavium_ptp"
 
 #define PCI_DEVICE_ID_CAVIUM_PTP	0xA00C
 #define PCI_DEVICE_ID_CAVIUM_RST	0xA00E
-- 
2.20.1

