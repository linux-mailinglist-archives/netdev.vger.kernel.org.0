Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8483E35605A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbhDGAcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbhDGAct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 20:32:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C6C06174A;
        Tue,  6 Apr 2021 17:32:40 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n2so18499005ejy.7;
        Tue, 06 Apr 2021 17:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sV9cwVjyvXxbW0ehUMCGQIeQ9SC41q6QfFAJr+V6US8=;
        b=PjqPEKC7jL/xniF2pAXcOM2VFrAq0Ytpx1oKo36koUtZwU9dUMEhfneWLSuqHyLJ0m
         wMNsnJrhhJX8amsCDjA8WuNdIo1zfnqWInqjzmcNUbR/0S6xE33g+1cx//dVBJXWK7rA
         HRPfaRbqyu9d0I+t7/pTOpfgN8z61VXbYQxnmSc+YGUnQTTaTcs0k0HFn1XOF9SNqlrY
         I6wQcJMHVkJYDApbjxhqBVhYDlAI/4mfaYZkOUD8V3cddzsplmVXWvEKtMayF8o1cq4H
         a28h1LqzZ7Df4AnJ3Or+fdGsR1w3LTyeS8limCUn3eD2w1XUKIg1iEhIiIb5OlLIKa34
         6+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sV9cwVjyvXxbW0ehUMCGQIeQ9SC41q6QfFAJr+V6US8=;
        b=VWq9yOdPiNzS0mq4TQPcJCwGReDrosKMi+YHwbO2a4czbzHMja/yTuwa+ICJ7UkW/+
         inK7+a/sUCDPniQXwb3k6abeJ4XUmkGEPOjO1HpviyBC8jJQmQGIdc0EosKlcUvpmPH+
         w9+pzpU4zNZyezy27WIiOzRf2QuofZAZvf+mB3Joa+xGe0yqV1wfYlb6vHwwN3ZqElWm
         OS1nRDI7xWwJcPGHNLL7xJmYpNaRVHbKHInygT+/Cl05vTtVv65jEOZQRKSMkq0dxUpw
         faJEvDTG949cw+cMHuuuhyom2Ae0LHqymAXsfygcRj940Nb7KOPHOLiiR/MPy36TyLt5
         za9A==
X-Gm-Message-State: AOAM531FJJI1lGOSdy3Lm+BQbX9oXMm+mhafUlhGRHxBHWaHV5c/aHZt
        Lgfqmg8UWVTQo01UHMrfSRw=
X-Google-Smtp-Source: ABdhPJwcmc9Q2MgE2ZQKYJ4L0bTTcx0DN7tCES0fryFDT4sZcvrDDjZg3ytj/g+yd4n4FKf5Cr6YmA==
X-Received: by 2002:a17:906:4e8a:: with SMTP id v10mr762837eju.6.1617755559394;
        Tue, 06 Apr 2021 17:32:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-23-201-105.retail.telecomitalia.it. [79.23.201.105])
        by smtp.googlemail.com with ESMTPSA id j7sm7829644ejf.74.2021.04.06.17.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:32:39 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] include: net: add dsa_cpu_ports function
Date:   Tue,  6 Apr 2021 06:50:39 +0200
Message-Id: <20210406045041.16283-1-ansuelsmth@gmail.com>
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
index d71b1acd9c3e..6d70a722d63f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -458,6 +458,18 @@ static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
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

