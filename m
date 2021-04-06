Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59608355F7C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344418AbhDFXam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344357AbhDFXai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:30:38 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2CC06175F;
        Tue,  6 Apr 2021 16:30:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ba6so11025031edb.1;
        Tue, 06 Apr 2021 16:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rt9sGyF0lhNzq6Psh64J+PKxJQXSMpHP8e1ozc3EaAI=;
        b=T8q3Iiu47BY3UBSFT71QLWq+s217oLE/aaTCjUjmsxMhhBRWZdiFBo31sz4XEYjf/E
         sOrXEfHWkv9gShs3y3w1xGheIi2g0mK1XguOqwiVe3gf/uF2ufvS/4SVHNzRjDsqCEEB
         dm5LZfbG3naZPzBh45lhPbULBp6cArXiaqAmnyoyqMiFv8fU/dEFScjswXNhZon9yp2g
         3mR7dUfLu/5pHsgw66+vc52FjjmSSHoDoj9CSmYzzMgwCsanMY+AkBPcL19isvEufXqa
         p+5vY/fcbs5eFfkGzuxtuZWlWd5w7IVoFMAMFXr3A+bd6xMPxh5L2+ML29R1KbEfneHf
         V4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rt9sGyF0lhNzq6Psh64J+PKxJQXSMpHP8e1ozc3EaAI=;
        b=nlivXQiEyfUEjN2X2ExfGXOSP4m5DNc2aZOLaXBJK//krEWwMyPM16yESi+37bV8xe
         iNaV5MbD2YdAY6JT2OF4hTyNZpcAINlBytwdSevYT6rvhspc5PLo+y3MtPSI4RJqB/fL
         4yZhhFVtHRdV2BYRCR3wklk2K4Qz5Xmz7CZJl6XF5w4wPM9FP46H0gmAriUCaJFbHsQw
         nbEx8fVxYGqliAmhzIBr6X8SzXBsvdbZPDo/9y02xFl+V2mY7y0GxmujwMZ6Q6uYeESQ
         EYIrPJpcaAoV4GTnqJQk2YQOvcCWvyActJE189jBZBqjfSTJk1Q5RVaiE/X4sExVok5w
         kjlQ==
X-Gm-Message-State: AOAM531hT0nYJDcr2OE4YwCdxQACJSylkKAQ0Thk3iRtpZC8h4eadLeC
        TTO5AFN+S1sQEWYuVfQZLaI=
X-Google-Smtp-Source: ABdhPJx/hYIqxfyGrGlZu+yXO2nfs1i2PeC1GS2cMG/C6HDOXfKWdV52W2rDrvo6fp7Cy9OHKj/8aA==
X-Received: by 2002:aa7:cf02:: with SMTP id a2mr932598edy.59.1617751828178;
        Tue, 06 Apr 2021 16:30:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-80-116-210-41.retail.telecomitalia.it. [80.116.210.41])
        by smtp.googlemail.com with ESMTPSA id i2sm14910278edy.72.2021.04.06.16.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 16:30:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] include: net: add dsa_cpu_ports function
Date:   Tue,  6 Apr 2021 05:49:03 +0200
Message-Id: <20210406034903.14329-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the future when dsa will support multi cpu port,
dsa_cpu_ports can be useful for switch that has multiple cpu port to
retrieve the cpu mask for ACL and bridge table.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/net/dsa.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..d71b1acd9c3e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -446,6 +446,18 @@ static inline u32 dsa_user_ports(struct dsa_switch *ds)
 	return mask;
 }
 
+static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
+{
+	u32 mask = 0;
+	int p;
+
+	for (p = 0; p < ds->num_ports; p++)
+		if (dsa_is_cpu_port(ds, p))
+			mask |= BIT(p);
+
+	return mask;
+}
+
 /* Return the local port used to reach an arbitrary switch device */
 static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
 {
-- 
2.30.2

