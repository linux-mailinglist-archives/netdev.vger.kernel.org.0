Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C1525E6F4
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgIEKck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 06:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIEKcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 06:32:39 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78F8C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 03:32:38 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z19so5143861lfr.4
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 03:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iKozwlzrBwDOZZQyoYHJabN4r3Vpg15uwW4kvVojjxI=;
        b=TO3rfIfiwSe8RuXHcYLMdP7GiXtvfHyOkB5OeCUqgp3hO/LBwESBmOkLQiYLAvZ5qW
         WUlnKZ+WmepflXs+HcTD1j70+/az9aU5fGp8O0XN4TOQG1phL7UkH1wlBaE+oH1HM3R8
         blxGPWj08YFqGKUSw5urpzKQIkMkBydVHukwAOCVfWGjvvRAhlrfGczbq9o8MIwrJnyR
         waBFmc56vp652rBT82J0K1i5jsopHZv7GBKBMyHkSOr8nr6Bq86nxWGnrB0Orp8GQu0o
         ZYYsxGo1KIdB/fpcXfx6E1gmv5nNqg4UzeB819AApYACNiVbM/f4WInPZJDjzUsF+Xqv
         vQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iKozwlzrBwDOZZQyoYHJabN4r3Vpg15uwW4kvVojjxI=;
        b=kBK3O1KOLLW8yejHZbZqypNvBFaIbKSXLY1DYCpAcpy7/e6kgJqCYHONd2h8MJP4N1
         X0KUkNEeXB69s1u8ziKq/S5SHXAFxj4b7+KxJDDFL5WJRHK/P+PxKMtOlmQCM+REVwUx
         l9ENRcRifw6m+YwXfYWwdpTwbfxGIh8cLaCHlRXbPoK6nF9legnJC1JAFAbW/hQvKJjh
         gzLISS5HsI0sA24QXjHVJjbtHWSmIJ7dHFCW0IVjMICUcRsg0+v1bA0/UrBGjiDlUcIm
         9PHZrrrqORF8tGDahpjVm2SLbmOigD7WNyeE2W6QTphdNdKQHOM9PiT8UhuV7fQnMEze
         8ruw==
X-Gm-Message-State: AOAM531i3vhFI6nTqL1YrCY+eHhNTvsuLlaUXnom223lp/1TyXRU2nGP
        CrRXDK3WHyQPDbMUWsfCBRxlqQ==
X-Google-Smtp-Source: ABdhPJzt/A9+9bGxnMg2R4xraEZaJ9hQd57fqTdmYYo5CDCDUHNbSXGSou9VYYDJy+8L2cJxIzTzfQ==
X-Received: by 2002:a05:6512:6cd:: with SMTP id u13mr2608373lff.17.1599301956275;
        Sat, 05 Sep 2020 03:32:36 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id 10sm1951292lfq.64.2020.09.05.03.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 03:32:35 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH] net: dsa: rtl8366: Properly clear member config
Date:   Sat,  5 Sep 2020 12:32:33 +0200
Message-Id: <20200905103233.16922-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing a port from a VLAN we are just erasing the
member config for the VLAN, which is wrong: other ports
can be using it.

Just mask off the port and only zero out the rest of the
member config once ports using of the VLAN are removed
from it.

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 2dcde7a91721..bd3c947976ce 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -471,13 +471,19 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 				return ret;
 
 			if (vid == vlanmc.vid) {
-				/* clear VLAN member configurations */
-				vlanmc.vid = 0;
-				vlanmc.priority = 0;
-				vlanmc.member = 0;
-				vlanmc.untag = 0;
-				vlanmc.fid = 0;
-
+				/* Remove this port from the VLAN */
+				vlanmc.member &= ~BIT(port);
+				vlanmc.untag &= ~BIT(port);
+				/*
+				 * If no ports are members of this VLAN
+				 * anymore then clear the whole member
+				 * config so it can be reused.
+				 */
+				if (!vlanmc.member && vlanmc.untag) {
+					vlanmc.vid = 0;
+					vlanmc.priority = 0;
+					vlanmc.fid = 0;
+				}
 				ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
 				if (ret) {
 					dev_err(smi->dev,
-- 
2.26.2

