Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC9A393746
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhE0UrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbhE0UrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:16 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1606FC061760
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:42 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e24so2274995eds.11
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nkiW4cgqcNA2wnsGokaWDqLEeknOpooJwCUovxh3/t0=;
        b=Z4oTJB5Y74wha5BkSsO7Ho0Udg0OuV7TlLRz/9wZZ1TLuBpkCD3K7yFSKzB4NNmBI8
         Gu3LzaUkgsjBf001vHgVrrddG6liaV/R9IepZFN/5j4ICE8LuVAhIwK2rQW0SqaMmp3t
         gPsynwyX2DaqlqJ2D20/DkF96P6HT9i0JS8IaMil86Is8v0Dww4Q1s11naTj+/kQ2SEn
         T3CCO9c+JjDNkZ1LfUE89bUenZv4XKoB89xBFwDPsdqHkqxgazi35qiv0SU7+rViw9e2
         rsD/I+xB52ODKE7BGkAPfTNR+UbRoKcHy8K2GEnVJGs6knvhOUCRn1jGq0p89z3jk4uJ
         cpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nkiW4cgqcNA2wnsGokaWDqLEeknOpooJwCUovxh3/t0=;
        b=UhlfOK2YkVRllEQD45IpR7/ZaYHi5C9EA5uJsYkWyRaBGDZhVbvNCyjvZHdD9cMvIi
         xvgPOr9w71rHWANmlTOy01NlXs+6ayKK9zrECKb/W81nyCfUavWXMWV3J5XaFk9TCjyG
         dU1g+BvTtxaLXbZt5ITqBdobqB0YCQeIZG39QxfnUWOZYoNs6DfzH3dZ8AjjQPn6pPhi
         OUGJ/yUPUggPWfNfOhVJ0TCwQMoYafOVSMfV6FsNdXNMAllCQUrE3PIPlzQ1q3eb6/iQ
         VgRbVOqRJHT3bW3rhxksmokBU5RnYfoHMOkr3T57Z4AhJ94oFtHsdwrl4UAR1kPFtg1s
         Ag7g==
X-Gm-Message-State: AOAM531ynFOFVvhVL6nuULyMTXOhl7nhj/YulnguyNcNBx4wLNPJUA0K
        18UIR2CJnZPmuSFW+7hxPRc=
X-Google-Smtp-Source: ABdhPJyYByVl7G+keupLijkhy1dJY61aYv505FjG03VqtvoMIxDHTl0kXTm+v+je5fEhmwUVW5zeNg==
X-Received: by 2002:a05:6402:14d2:: with SMTP id f18mr6478692edx.259.1622148339318;
        Thu, 27 May 2021 13:45:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 1/8] net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
Date:   Thu, 27 May 2021 23:45:21 +0300
Message-Id: <20210527204528.3490126-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

CONFIG_STMMAC_ETH selects CONFIG_PCS_XPCS, so there should be no
situation where the shim should be needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/pcs/pcs-xpcs.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 5938ced805f4..c4d0a2c469c7 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -36,13 +36,6 @@ struct mdio_xpcs_ops {
 			  int enable);
 };
 
-#if IS_ENABLED(CONFIG_PCS_XPCS)
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
-#else
-static inline struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
-{
-	return NULL;
-}
-#endif
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

