Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB02CFD68
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgLEScf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbgLES2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 13:28:53 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4158C02B8F2;
        Sat,  5 Dec 2020 07:28:20 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id 19so867944qkm.8;
        Sat, 05 Dec 2020 07:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iFNYyDl4TzsszoMYxpRS/KovZey20VoWKlMzk2erbcM=;
        b=YsGh/kmM7LdA9HrH3dSSIed39/M5ywSZYIP1RQ/cdSj1Qy0/IB3WuwiId2UTclUCab
         LND+JdKO66XFi7dSZFi4kwWPg5Q02VW7p/NPTjq6bNWp3Q+eWVSE65fQ4NV7HtHps7il
         iVcCe+Rhq6/lLdSRCz/+hf3APq8EUHCdfWXsjkavYQeZkjcCLiK10fv1ZsdgxNYWI+6P
         gb545KQA1urYD9FcvA7JdefgWnGPR62k994Q6JQ8yJisimlExiM1VG+wf69OJ2Duha30
         DqfElhL54mcrXrg/KW2l632U9eG9u9oLc9bdzfdpbdWgMqliHCyIdIPt43aZb4bEGQCS
         dCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iFNYyDl4TzsszoMYxpRS/KovZey20VoWKlMzk2erbcM=;
        b=FXnAysbHwy4zYzkqKNG4tGRctulJKOfiv3lDPZ5dukfw8OmNn97Zw/XzLcO2m69/vc
         7CnlJSnNFpU71URMxJAp80s6SWBr1Fz3Cb78XvT/YVpp5NZKSjGPQ/8htFXsc5CgiabD
         b0JYt9fMSSA3h7al037v7NAxQ8sW22LFbGxp97KxrYX2yDxKhPi3MytDYjhL6neWynyW
         F5nHO8I8tHfcyrBz22/YvH/eNwfDo+mLAAR1fYaB1z3Nq0Kd74LhLozQG6tsen2LdXpw
         B2B5yNiBB5RR92SoHmnGd42UF7Q8BB1zJvB47WhZ8Re8qp/kjx7ktfI02iwM5oksSdw9
         HHaA==
X-Gm-Message-State: AOAM533rqVFd3jkCX9EJ7FOyX0CprTrOWSrkhvPZ6t5UOEaFOHPIGRgP
        MLGyvqO9c3VhYanc0z64eV8=
X-Google-Smtp-Source: ABdhPJzfAXYnOGRnHpEA1wSP5JhgNduzs+F25shU9hLOFXSyVVEHzOZk+mtQN5f7EfvK+SwxAQR+AA==
X-Received: by 2002:a37:6697:: with SMTP id a145mr15028425qkc.296.1607182098832;
        Sat, 05 Dec 2020 07:28:18 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id o16sm9008554qkg.27.2020.12.05.07.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 07:28:18 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v1 1/2] net: dsa: microchip: fix devicetree parsing of cpu node
Date:   Sat,  5 Dec 2020 10:28:13 -0500
Message-Id: <20201205152814.7867-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

On the ksz8795, if the devicetree contains a cpu node,
devicetree parsing fails and the whole driver errors out.

Fix the devicetree parsing code by making it use the
correct number of ports.

Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 905b2032fa42

To: Woojung Huh <woojung.huh@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: Andrew Lunn <andrew@lunn.ch>
To: Vivien Didelot <vivien.didelot@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
To: Vladimir Oltean <olteanv@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Helmut Grohne <helmut.grohne@intenta.de>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index e5f047129b15..17b804c44c53 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -431,7 +431,7 @@ int ksz_switch_register(struct ksz_device *dev,
 				if (of_property_read_u32(port, "reg",
 							 &port_num))
 					continue;
-				if (port_num >= dev->port_cnt)
+				if (port_num >= dev->ds->num_ports)
 					return -EINVAL;
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
-- 
2.17.1

