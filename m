Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D47E31283F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBGXYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBGXXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:23:49 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F26CC06178A;
        Sun,  7 Feb 2021 15:23:08 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id l25so4535966eja.9;
        Sun, 07 Feb 2021 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e9XiWgYMfVUBSKTt2/GH7FXs22RSflWWzqO+GytFND8=;
        b=hrNsNNr92ti6PuUoJlwmbCFI/0za7J7d0/Mr1fl7pIVF/V67yqcNAU7YeBI1zSE4BR
         vSgZbG8ewwmWuad2Q2X9OSAP4c84PibFdy8bnfSPBkaQ9FmMBRHaN3w/O9cdp6mm9EV8
         peKBNbGwlC6Vf40m7+O7ezFrNYLrfBDQGu+ob/LKU8JvBMEyGf3HXYSNIAPqbIBS7vif
         3Eri2/HMq/LZ13WJHBIo1J5K9kcfOKCIJav6wJ+e3tptTsOgagQ5kZPg9d+zYB7WFel+
         pb0WnbEwHIyu8EbFSKaQgXu1bBNnxT99UcGWQbSWSZ1xu9g3g6ZWAW8/5kh+P6vKWZ9M
         uU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e9XiWgYMfVUBSKTt2/GH7FXs22RSflWWzqO+GytFND8=;
        b=iKXJ2ODQAbBoRNzAkAs/QuHRs+6VA4fqHfaTcC/b+9EXZDq0IscHbQc0k/ZvsN/3zK
         ahzgV9P9JBDRMq2B2gEZ9v7LuS3BeU2nigI1gCNT2ik0qx6FvmM2I5YJMPWDvBjIy3pk
         AWGj7hPDZTUlaqdwQQX+qAgUU70WCTRZ89fY3lrU5EzT+nDKSZiAsC+wLBJqhajS30SZ
         6p2ocRy/cwkMlWOsx4VzwJhO05D/Vvhruz305i61F8MZHE0Q5t+sIJxEd9Y3a0gtbp+X
         kzAsoHrtJlhYC4MwnUuTJCB5bYS7zUpPLCnSFvRFmxcZg2w9tRnGAHm30kkBqW1tcbxl
         3MIA==
X-Gm-Message-State: AOAM533rRMtmZPosopqVpmgrb1cxlPQ1P1+jkVw9e0m31MTozQND9+fC
        78wZ271/qha9SP7VvkR+M30=
X-Google-Smtp-Source: ABdhPJzZ9hMYurUekGo++xUICdbenx+WJqC9rfS+Fr5RgTrA/SSw5oKu9PUajnSEZ4VhPv4nmDn8BQ==
X-Received: by 2002:a17:906:f4f:: with SMTP id h15mr14443806ejj.498.1612740187258;
        Sun, 07 Feb 2021 15:23:07 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u21sm7540016ejj.120.2021.02.07.15.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:23:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH net-next 3/9] net: dsa: stop setting initial and final brport flags
Date:   Mon,  8 Feb 2021 01:21:35 +0200
Message-Id: <20210207232141.2142678-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207232141.2142678-1-olteanv@gmail.com>
References: <20210207232141.2142678-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

With the bridge driver doing that for us now, we can simplify our
mid-layer logic a little bit, which would have otherwise needed some
tuning for the disabling of address learning that is necessary in
standalone mode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 5e079a61528e..aa1cbba7f89f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -132,11 +132,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
-	/* Set the flooding mode before joining the port in the switch */
-	err = dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD);
-	if (err)
-		return err;
-
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
@@ -145,10 +140,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
 
 	/* The bridging is rolled back on error */
-	if (err) {
-		dsa_port_bridge_flags(dp, 0);
+	if (err)
 		dp->bridge_dev = NULL;
-	}
 
 	return err;
 }
@@ -172,9 +165,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
-	/* Port is leaving the bridge, disable flooding */
-	dsa_port_bridge_flags(dp, 0);
-
 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
 	 */
-- 
2.25.1

