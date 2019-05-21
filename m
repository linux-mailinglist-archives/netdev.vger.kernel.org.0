Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046152584F
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfEUTbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:31:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46086 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfEUTa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:30:59 -0400
Received: by mail-qt1-f194.google.com with SMTP id z19so21858897qtz.13
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nrPCrlxPlp1D3IAAV/afRFPak6Q7SCuk7DDSsGFSmVQ=;
        b=SAMKRCshj2QRDfJiN4GsEm4RKgLXVFIJvTn/oRIfCJ9ywC41o1UfOKVdPKXewfvANZ
         ET//FszOinvnNyXUCpNc7UrwjGBnbB7hi44coRa4kxwZfC8YX0Xi2bucRjbnmaYv2LgH
         X0DZOeufgNCkJzEi+siInW9ssT2DsMDHvxXLC5/CD9RSLUuoOhcFd0ZXj/+59QASPnAo
         /yEm4JO+sLGlw6alxpvPaVICh56x9Vzo4Mh6Ef5YRFE8e7lAeEoRYpUe5SMh4VGMPomi
         2KepFOCZHhqeFYg1ky+I3QFCqcsQia0JWMANEylb9jpLhZ/XeaQxBmFYD3KHMvoRkcOS
         jfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nrPCrlxPlp1D3IAAV/afRFPak6Q7SCuk7DDSsGFSmVQ=;
        b=C8+R3Fe9Tc0l9V97YYK03YTFtjsuo2osHgJMGw9F7iUnXOVTBae+WBZihoSBWfAk40
         TbsKKQjM2w1gopa2FuQD0MAzy3ffpTgZ1CVDw1Bo44l7u4BoOSPGeNxNUecdahJEztDA
         FhFkF4Z/+LWpyi1cnw/TaJpK/KLCp+HCcS7dCzOlBZOQg253Xsy//Ns+3k1zVm+Q9yfM
         N2TuUSq5UJSxtjjDrLc6YStkNkygvoP67V+nUnG1erV2LULph4MOiKl1A9SZQn4p0hvK
         mclg0beD7wLmbHkRegvFXxeREU7yp22biGULL8fnDuWa+LVo4/S+o7uvyq43a8YHD81l
         MvWA==
X-Gm-Message-State: APjAAAWsGDW/io56KqkanI96+z+h69X5E/uvD91OYaaDJVjXcqeyZoft
        E5qhTrSzkgBqt+lNN4UA++H60n67
X-Google-Smtp-Source: APXvYqw96uxyEKDLnX9GhklbTMUltvyOKGUS9hKXewZAp9U701UKmyYN8U449GtSv7pQ39hCa3qFNw==
X-Received: by 2002:aed:3596:: with SMTP id c22mr71103596qte.365.1558467058491;
        Tue, 21 May 2019 12:30:58 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r16sm7773203qkk.36.2019.05.21.12.30.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:57 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 5/9] net: dsa: introduce dsa_to_master
Date:   Tue, 21 May 2019 15:30:00 -0400
Message-Id: <20190521193004.10767-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a dsa_to_master helper to find the master interface dedicated
to a given switch port.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c5b45bfeea01..b0be2687bd61 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -356,6 +356,19 @@ static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
 	return dsa_upstream_port(ds, port) == port;
 }
 
+static inline struct net_device *dsa_to_master(struct dsa_switch *ds, int port)
+{
+	const struct dsa_port *dp = dsa_to_port(ds, port);
+
+	if (dp->type == DSA_PORT_TYPE_CPU)
+		return dp->master;
+
+	if (dp->cpu_dp)
+		return dp->cpu_dp->master;
+
+	return NULL;
+}
+
 static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 {
 	const struct dsa_switch *ds = dp->ds;
-- 
2.21.0

