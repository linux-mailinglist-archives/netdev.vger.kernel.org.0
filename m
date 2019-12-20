Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F419E128206
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfLTSP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:28 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45948 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfLTSP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:27 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so4420279pls.12;
        Fri, 20 Dec 2019 10:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZYaULAOf/ipunpDAVFMxi/EQXHSk5RtELu2hRAqrmfo=;
        b=soKJ/5TQY63UbRSr/zPOYFJ//r47GQwE1DlWZTnD/JRFIV8IQl4fP78yE6RtyVDOTM
         Xqs+kbKYthY9UWqBajEEgYYWTCR0RS2la8elKIZi5NY0R06W8EoVf3mKr8raOBD8G9cz
         Ym+nO58OKnQuLNjrLn+eVzpu4lPQoAtZpg3I8Ri5JjhLCaEju+x4IyG21EfTmCSB/k0x
         4sObaHtpzlWF5wgIwAtPsT+aS37pKAW3MQ/wOIzrGzXhVhHxAUpNAjwhlrl0iBK6PFLf
         TH9ypavrq9CRYk506KGbtKOsQCB8wouPiNT0yhlbDOAVxCRTCj0tcXlnHi+j3tGaBH06
         MzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZYaULAOf/ipunpDAVFMxi/EQXHSk5RtELu2hRAqrmfo=;
        b=W8H4nB8APF3rfYHiNSYYqgayw6GIQ03DiLcCd2PlRwkjcAlgMnx9+8qUyN8G23zj/2
         3fM6mpWfmsG7qumCVak0ukfC3c7NlDD9Xyy3xTOf1fu+GH2t39az5FmqVSJFOXkr5055
         sdtlVXNSDnHPdCco//Ji2/ljtZQSA8MiAkeXqCz96UhC88+BNMAPAvO9uRfnUrgvNCDc
         R8WYvnFNGQ9jHsqKCreqgtRu2FNz/zgukXNu9iKE/hCnEt9BkwDXjyqBqpj2CR9xorIC
         bd5/rJBcdgH13jacY37m3P83CIWlxExk56l+pNo8Qv18JUMh2wbHdUv2iMjhGK1pBqRi
         RBvQ==
X-Gm-Message-State: APjAAAVej7Ct1PwwLXxd60gPwAE1j2l8GD+MzOWTYRLo+snDnQ1ViTQ1
        e/zsFx/JKDrbo52S7g4p/nSoTWD6
X-Google-Smtp-Source: APXvYqzPCFhIou48B2xrgnV5RxShqn7fWYHRBbPW40IcR6fiy1vjmYBl8m8ZtgOHHXG27L5Dse17tw==
X-Received: by 2002:a17:90a:868b:: with SMTP id p11mr17638902pjn.60.1576865725709;
        Fri, 20 Dec 2019 10:15:25 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:24 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V7 net-next 01/11] net: phy: Introduce helper functions for time stamping support.
Date:   Fri, 20 Dec 2019 10:15:10 -0800
Message-Id: <bb9bfc2826fa92bedde11664b0c0e0b9d028a689.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some parts of the networking stack and at least one driver test fields
within the 'struct phy_device' in order to query time stamping
capabilities and to invoke time stamping methods.  This patch adds a
functional interface around the time stamping fields.  This will allow
insulating the callers from future changes to the details of the time
stamping implemenation.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/phy.h | 60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5032d453ac66..fc51aacb03a7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -936,6 +936,66 @@ static inline bool phy_polling_mode(struct phy_device *phydev)
 	return phydev->irq == PHY_POLL;
 }
 
+/**
+ * phy_has_hwtstamp - Tests whether a PHY time stamp configuration.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_hwtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->hwtstamp;
+}
+
+/**
+ * phy_has_rxtstamp - Tests whether a PHY supports receive time stamping.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_rxtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->rxtstamp;
+}
+
+/**
+ * phy_has_tsinfo - Tests whether a PHY reports time stamping and/or
+ * PTP hardware clock capabilities.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_tsinfo(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->ts_info;
+}
+
+/**
+ * phy_has_txtstamp - Tests whether a PHY supports transmit time stamping.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_txtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->txtstamp;
+}
+
+static inline int phy_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
+{
+	return phydev->drv->hwtstamp(phydev, ifr);
+}
+
+static inline bool phy_rxtstamp(struct phy_device *phydev, struct sk_buff *skb,
+				int type)
+{
+	return phydev->drv->rxtstamp(phydev, skb, type);
+}
+
+static inline int phy_ts_info(struct phy_device *phydev,
+			      struct ethtool_ts_info *tsinfo)
+{
+	return phydev->drv->ts_info(phydev, tsinfo);
+}
+
+static inline void phy_txtstamp(struct phy_device *phydev, struct sk_buff *skb,
+				int type)
+{
+	phydev->drv->txtstamp(phydev, skb, type);
+}
+
 /**
  * phy_is_internal - Convenience function for testing if a PHY is internal
  * @phydev: the phy_device struct
-- 
2.20.1

