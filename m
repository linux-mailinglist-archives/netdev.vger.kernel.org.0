Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD33203C0
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 06:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBTFNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 00:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhBTFNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 00:13:30 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDA8C061574;
        Fri, 19 Feb 2021 21:12:50 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id b21so6669119pgk.7;
        Fri, 19 Feb 2021 21:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nv3w/V9N3MulHuSxHo6DjXcO1wCmRGf5Is/WYRe4EtY=;
        b=VLkYFzKjVbPyAy08y2u0Qg6uiXNIc5ATOyvhN0PqpP66IwNhhlSqZMq7809CVDp6dG
         RgjbFV8vssQ7QYiC5gXbLpnmGHfj3gQp6UC2OXgq9Wld53HPY34woFMFoQwGT+OrZhLc
         NNpQB8HHJY4pHcf/uSCysTbO495VKOf2ZJIWAnixWoQqpDKCxFW8kZk2MGmdyYWFxQ6h
         ZeYmSoD4q5I7KE6g3FC6qQ/41ectTPOoQm230gq3PF/tttsTpaWWKv4FR2+reVP2Mofd
         G+s5vLaI4csyAS1vP2UfbDk16fDX8HJj34bXuiQagqlYfrecdk6cqlqEz99usbinSajH
         Zx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nv3w/V9N3MulHuSxHo6DjXcO1wCmRGf5Is/WYRe4EtY=;
        b=GMpAJOh2E4ayXcv3XqJdXP6O0Q9BKg9zj/uvJkj80jzW9E2ZXm/3//eQ2D47h/A31N
         oSHG8JJZftQ1/ZaXusPG/brpetmVmxgsUnyM8ieyiXxLrz7NwsIY3RN3PhrKeRLkgQXY
         EPqzWyHQInPI6udicxVnodrCAapcBfJdP0X6IYVwY9H6+iCQieJ4GJx3REdjGPN3T1DY
         6ZVg8LtaZQZY3GXSex2LIva6WWyIu9QJS6umOo8e20faRvGiN/LNLhhBzIxnbVtwI2ar
         Xw7/a1f7hadFiuqjahrm64EhMEe/25YF+vC3YjPnVZXds9LcrPPCXqSFRyRMUmqI1DME
         o3UQ==
X-Gm-Message-State: AOAM532xuBsk8q3BUMnaIYNGTPTSZIpOi/7YKVnlNKMlzdSzEC4zh0Pi
        FSOjNvVftuzV5P0npcds+Vz5YVHZe9I=
X-Google-Smtp-Source: ABdhPJxYhieCLSDr+rMaLfGXbIIBGtEs8bK+BzrL3sOeNHo/BQrQ7ZIavp9NJbdB/P/LhzpmBR3fkg==
X-Received: by 2002:a63:5952:: with SMTP id j18mr11437777pgm.29.1613797969852;
        Fri, 19 Feb 2021 21:12:49 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g19sm10180679pjv.43.2021.02.19.21.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 21:12:49 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Fix dependencies with HSR
Date:   Fri, 19 Feb 2021 21:12:21 -0800
Message-Id: <20210220051222.15672-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The core DSA framework uses hsr_is_master() which would not resolve to a
valid symbol if HSR is built-into the kernel and DSA is a module.

Fixes: 18596f504a3e ("net: dsa: add support for offloading HSR")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
David, Jakub,

This showed up in linux-next which means it will show up in Linus' tree
soon as well when your pull request gets sent out.

 net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index a45572cfb71a..3589224c8da9 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -9,6 +9,7 @@ menuconfig NET_DSA
 	tristate "Distributed Switch Architecture"
 	depends on HAVE_NET_DSA
 	depends on BRIDGE || BRIDGE=n
+	depends on HSR || HSR=n
 	select GRO_CELLS
 	select NET_SWITCHDEV
 	select PHYLINK
-- 
2.25.1

