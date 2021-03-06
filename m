Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3A32F744
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhCFA1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCFA0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:26:52 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18B5C061760
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 16:26:51 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 2so5286338ljr.5
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 16:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=dmHRm/whosWCJYEELWBVZq2d/imABHUEc3ev6dE2DgU=;
        b=F9suN9VHL3OAp/rkWWAY5Vcey2Sb8j72zocD/G83gum3023mL4boUm29mQFj7DCism
         Cu26o4c7zxLR3g6qXdd99uTDHUT3f02qAPPogt+0WCh+136YdDPaw8bgS3DxuMixoeYO
         jyfU84xPpnD6LMGOOroi6QJswnOK/AHuVw58H47y8gepBwcJCy1dhE5fVnz9DduNPpmR
         XeS9odNWSarBZqj2R1wgarsCKHyPDzQNWtseocYl63PNz9X0Kkg8oju6IDLLrIH26SVC
         12B57EUwQwbDa+KyzPY86UXTfLZEEkTTYzclZlUeGJ5IMcutinBWawkJFYP8+T7BjgkU
         RQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=dmHRm/whosWCJYEELWBVZq2d/imABHUEc3ev6dE2DgU=;
        b=B/fBRDgIPcMD70IW2/u1WX71mulhmB5If3C802Nm8c94YQZRJwuJDn7cNZvPDOq8a8
         CWiDZannkKsRnWOvTkGdD8CGQS5R7OF40Nzpp75MDBkmY5jY5Ik5HaAhnJlRulogczrp
         sTDsK/aOrxJ9rxYNvhELELIvR3QyCMPAeE6ytfNVbHQCO7Rl7i0Ah001t8bNz4RxWBvb
         wK8u2EJQ3fpiFrqMPiKgljBxioL6cq5Bhtc4izsEnEqJ6HtapRB5en2BbmcLxPnmf/rh
         YtM6BBv/0ejMcre0WqihYecNDAQXSEfd9FWzkEsHBlXXtVJk4buIMxb2MOBjyUcjj7Xx
         VKQQ==
X-Gm-Message-State: AOAM5322pUNMqrHY1S4e8DetIgavznEwvbYjFmqlBPYDvB+/rgmMdgHh
        a+a7AFahqgVfwfjmA8gvmaVTww==
X-Google-Smtp-Source: ABdhPJx/kgrH132E41iDPbVSFK0cZ/VRa0Lex3BcmeU3dLszvfQ748eVdMZh+s4v53vdDOIrOtXTww==
X-Received: by 2002:a2e:b55a:: with SMTP id a26mr4810780ljn.297.1614990410535;
        Fri, 05 Mar 2021 16:26:50 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r5sm488678lfc.235.2021.03.05.16.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 16:26:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net 1/2] Revert "net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored"
Date:   Sat,  6 Mar 2021 01:24:54 +0100
Message-Id: <20210306002455.1582593-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210306002455.1582593-1-tobias@waldekranz.com>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 99b8202b179fc3dbbca69e8af6da660224c9d676.

DSA should indeed react to certain switchdev attributes where orig_dev
is the bridge master. But the fix was too broad, causing the driver to
misinterpret VLAN objects added to the bridge master as objects added
to the ports.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/dsa_priv.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2eeaa42f2e08..d40dfede494c 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -236,15 +236,7 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 	/* Switchdev offloading can be configured on: */
 
 	if (dev == dp->slave)
-		/* DSA ports directly connected to a bridge, and event
-		 * was emitted for the ports themselves.
-		 */
-		return true;
-
-	if (dp->bridge_dev == dev)
-		/* DSA ports connected to a bridge, and event was emitted
-		 * for the bridge.
-		 */
+		/* DSA ports directly connected to a bridge. */
 		return true;
 
 	if (dp->lag_dev == dev)
-- 
2.25.1

