Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9454541722
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436613AbfFKVsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:48:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45493 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407713AbfFKVsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:48:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so8674877qkj.12;
        Tue, 11 Jun 2019 14:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OTZFFyvvpmxV8PmygcaYSy6kccJmec1j9T2lwtj/7pY=;
        b=uWM3SKC6M1rSXXop8Yctu0QEY49jHuIAk6Zg3mE+S9hPM8/SEOJNG8dLdBbZSGY9a2
         zeOkZp0djLYW5YSAhxan31i/me05YoL6HSWv63oTkwJcvbHPoWBo+bgSLYGs2lWOEU4q
         JnKmNQKvobQGOL9u7ifWPotrkyKi26XbvoiSYaymZtoJu4fcvj04AcPiKSSd15K8Bk2l
         tB3K8ubmZkb1ywtJqrZ8brPB2WaHNmxxLj4nWh80Gc9eySeE4W+losqO3X+TPpjH0eYi
         JY2OxR9npa/WXV3i78XPimGtdGxW4eZPK/VRsWrOs8pgcIc6Vn77m8zf/NQHCvtu1UAp
         sTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OTZFFyvvpmxV8PmygcaYSy6kccJmec1j9T2lwtj/7pY=;
        b=OJJpLSzTYbCgL2ExYV0OTmBSM7XPi2YsjUgIEn8wJQC+RSryIfjL0Z04Pw1ZxiLilP
         EkpNqipKJMgMLUUzlGQIqGo7Y/Poi9W+HbyyP6mkBPHZ8eHBN02uJ9H3+DIfIbZ1XHQc
         f8lRFzDzpx2BZG7YvTyhUc7bDFYTIElQa2TuLO+WhFnwrPyld+3ccCreLlGd94kLRffI
         RCNlXM3OwMN0McOzb2jQgrC8OXPdVbg27rXmysCNLXq3ON1ugOuSm1WElVL6ljJg5w/a
         /1QQZANcNBubkfA8r3OxUTNQYEUJEQKcBbL04g6XzHVL65tm7WasdbexFMVFKP/kXgzn
         X6pw==
X-Gm-Message-State: APjAAAUCP1ui8ch9jPY71rGH5CxoEYHrb4wsyXIr7yC5MfQD/aci3o1g
        or9wFEgh4YrMDKpVB/oN+WRsKp4Rkgs=
X-Google-Smtp-Source: APXvYqwhksrSoGrXI/LonZ+Kvb44E4Wd5miAEtSg9mDKVzVrGrYZgzGXuK10RbSaLA3j9pkBv0HWag==
X-Received: by 2002:a05:620a:4dc:: with SMTP id 28mr42256901qks.354.1560289696312;
        Tue, 11 Jun 2019 14:48:16 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k5sm7072823qkc.75.2019.06.11.14.48.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:48:15 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next 3/4] net: dsa: make dsa_slave_dev_check use const
Date:   Tue, 11 Jun 2019 17:47:46 -0400
Message-Id: <20190611214747.22285-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611214747.22285-1-vivien.didelot@gmail.com>
References: <20190611214747.22285-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switchdev handle helpers make use of a device checking helper
requiring a const net_device. Make dsa_slave_dev_check compliant
to this.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 289a6aa4b51c..cb436a05c9a8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -22,7 +22,7 @@
 
 #include "dsa_priv.h"
 
-static bool dsa_slave_dev_check(struct net_device *dev);
+static bool dsa_slave_dev_check(const struct net_device *dev);
 
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
@@ -1408,7 +1408,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	free_netdev(slave_dev);
 }
 
-static bool dsa_slave_dev_check(struct net_device *dev)
+static bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
 }
-- 
2.21.0

