Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B201AE4C9
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgDQSdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726054AbgDQSdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 14:33:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF90C061A0C;
        Fri, 17 Apr 2020 11:33:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r4so1512451pgg.4;
        Fri, 17 Apr 2020 11:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDZqRs08yW8rmkLGicGD1U3ejEUDLw8Yn7W5t1UZPFo=;
        b=Adm0UqbK4EhGULyk4ehca7RcMRTuQeudlh3i29+AzJINbhEdhrZxcJ8lq9vWB7EkkG
         Dd/wx9AbcU1RTgKyNuRQmaqhuHjceXd7HFY7ASfaU6CK3oqpcRGl1/VwmFIRi9QdrTRJ
         4SLt4EhBgjehg5E6m2ztMzD0pa+G0H0VQJJEcJn0QxhBUu72wn72D8rDd8D80X8URUZK
         R+LowDO1EA+W33znbD7mYDIchCJ9GMkzHUwGjojYApaSQLBvHaye0qAk9fXwNtuwf0mV
         yUTBuSzWQZ0psotjyeHwvm71k6fhmz9AzaKdSoUBQnY4rObH1Nuui6h1aZFYgrMyOiQw
         VEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDZqRs08yW8rmkLGicGD1U3ejEUDLw8Yn7W5t1UZPFo=;
        b=H9pWAv9b6x+N6gebAwKg9iyvXvAWayIpWOJv9Rlf9GunOra1B4nCRyJkFRRftMjbdX
         U5tdH0L6AIf0aY3R4m/GQdaGPibAG+iWXUbaxsNhpFO5BcAy8/CdQXM6D6RbDKFp7Z6e
         x9so391fFUI74zMJj68py7dhibOSp9lQ8k4+Ymz3HPEeQFFUBzb/gUb3DVdGcHQtS+vD
         n6bmx7/JjHATFiuxaeIcx+VIO8rG7J7SM26IqIDx3hGtbE/PTkPZBIs2TDC4nRwE22Cs
         sKX2ViQfzsJMqoHqJIdd+KzZzZDS8VG9cxourJOVL6l8kw+zjyU58ShG6Q7/118r9WSJ
         t+SA==
X-Gm-Message-State: AGi0PuZATz4eRuDx/hJeuvuT8LEW4jbLDuOkb637Ch0k2BnaquP6J3Pa
        fCcKhKIeBntSCDgqHYQ2WrA1vFi8
X-Google-Smtp-Source: APiQypJ7yu6e20Z9lERl9UPYAY4MjeVTTtJ925wGDt8BkyIlq5x1y+RrHbGafCp27Q0ZK8pKHd/Nhw==
X-Received: by 2002:a63:1415:: with SMTP id u21mr4175888pgl.452.1587148426177;
        Fri, 17 Apr 2020 11:33:46 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u7sm18368297pfu.90.2020.04.17.11.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 11:33:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: b53: per-port interrupts are optional
Date:   Fri, 17 Apr 2020 11:33:41 -0700
Message-Id: <20200417183341.8375-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of platform_get_irq_byname_optional() to avoid printing
messages on the kernel console that interrupts cannot be found.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_srab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 0a1be5259be0..1207c3095027 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -524,7 +524,7 @@ static void b53_srab_prepare_irq(struct platform_device *pdev)
 
 		port->num = i;
 		port->dev = dev;
-		port->irq = platform_get_irq_byname(pdev, name);
+		port->irq = platform_get_irq_byname_optional(pdev, name);
 		kfree(name);
 	}
 
-- 
2.19.1

