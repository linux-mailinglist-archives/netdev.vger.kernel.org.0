Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79F630964
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 09:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfEaHfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 03:35:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35607 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfEaHfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 03:35:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so5789598wrv.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 00:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=s1a3ffK83MdLiV09gJmbZprosRcZAkmT+m5DPcFIxLc=;
        b=2AtMxCgTOMoBq7V9O7ebISL00QYFiROr5UX+WTKR05o5v0dVhtwpjUbP0ywuufRSCM
         wDJrYJeUH9R+b+Jdvioau1ENioD6Qribz6U8CFcxipGne2CTrxV7FayE/+IjMGzbs7SX
         hat2IjnZnc9/hU12Tz3ql2SJJ4CmSrTRqwc2Ywi1FDgNePgDQuCg/1TpHAB8T9FW1XkQ
         BZ74F01wprRlXAXSZRb926n11MZcEKM3+M7QFr1h61RYzqu4crdrThXgG8xILJTnynpq
         nlTSIfG/d7CdNzdl43AjcOOQJId5ugbuwo9Z/vckY4v1NUuqJxSv9gbzAaB5JEEJxXBV
         pypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s1a3ffK83MdLiV09gJmbZprosRcZAkmT+m5DPcFIxLc=;
        b=SM0BI1JjVMcwnmkrGG6ixGv2qVo9VCxUka5rZRyGLtIUnrdqP3u0DgYmh5vO7ZdqBY
         IrOpBaQ41I3sB7cIkA+ZZhmaNoibuokZzH4zr1M6RV0qolDVkleHU5oR01fbJIptqmWd
         TDKiRcFFmuapG2mt87ziJZX6n2idNlWpAQFc+xJFB4xZIJ2HOUswQLN9A6TcdCX7slEp
         cqwcNm1jmKfRwUixJuMhejK7lMx+IuCj5+nuerIpXuCW71qnlhx0dmwwFaJq+NP56DAY
         rJ9jQcXm2CMoUIWVZQRj9rNWebHiZgyTR3jG+akdvPHamBRls8ZfSCfYhqZiys1kdKfB
         RkIA==
X-Gm-Message-State: APjAAAVp9gg5u0WcMAl5Ndf14Xabn19gQraxuOiSBxyH/IQfIaNGiKSe
        Vm7+6XKsSLXt2+Cb2fAxXHeabA==
X-Google-Smtp-Source: APXvYqzW5W/cGqo1lduxfmk0mQcqRPMhScqJjyMum6NFeXqwzHHcOB9UUS6QS5cuQrryl5bXKzjy7Q==
X-Received: by 2002:adf:dc04:: with SMTP id t4mr5714889wri.126.1559288121099;
        Fri, 31 May 2019 00:35:21 -0700 (PDT)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id g5sm6021418wrp.29.2019.05.31.00.35.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 00:35:20 -0700 (PDT)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0
Date:   Fri, 31 May 2019 10:35:14 +0300
Message-Id: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
message is logged:

failed to kill vid 0081/0 for device eth_cu_1000_4

This is caused by call from __vlan_vid_del() with vin set to zero, over
call chain this results into _mv88e6xxx_port_vlan_del() called with
vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.

On symmetric path moving port up, call goes through
mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
that returns -EOPNOTSUPP for zero vid.

This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
zero vid, then this error code is explicitly cleared in
dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 28414db979b0..6b77fde5f0e4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1392,7 +1392,7 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	int err;
 
 	if (!vid)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	entry->vid = vid - 1;
 	entry->valid = false;
-- 
2.11.0

