Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CC1120EF4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLPQNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:35 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34198 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfLPQNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:33 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so3189826pjs.1;
        Mon, 16 Dec 2019 08:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/MRhQUjLSreGloL+KPRjpYwH368HHxH0UzHRNSILX4=;
        b=MlNAA8WzMIod9j9yDRzmYH8pWcH/rmyFRlpADrooW0ahbejzSEmL4ecPVM7QyQel9v
         KCipQWg+Bp2N5WMhpjWfnJ2BAHMaoCpSJMTOF87sHQTvgsmb6IsF9GmK51zSperehQsM
         dFX1BPrW+8V4+EMy7bZQJ8QKnnrZ8qH2k3ZD6mzRa+Yd/YBAl8P9fnVbVgkF8IdxVmYu
         7oBHWnTfEuTx/1YVorSM7woOIKqPzy00gQ9oQBJicT1b1yxv1WKHnLlxRZSxPUiEOJ5L
         3R8fw80oPH1Qvq2idi0zqAJY1MKSDz/xNzJ6ZzmvVCImP0qMsu/aPESsIhfnfXHk+X5M
         PTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/MRhQUjLSreGloL+KPRjpYwH368HHxH0UzHRNSILX4=;
        b=ipH/BBxX2TaQhmK+JsGAr/g23PQHlp35euHoN1ObKpho+ywBGMi52y+GZpP7UVkDmE
         5qpex0HHjuwyIknIMryaqb61Fs0j90H1vA79MZrBbHmL6YGiLKiNwSdO51lsAX7WO/9m
         BoxjSO5TtHJvFtKD/ejxLwPO82JCFe4u1duetNb3fJAsPdnNq8h5mVBzJT2be1qEDHun
         a6vhZS+i6srf5bkllnS0MZxRD8vSg/reuYUd7P78k9xOWbxyWTsZpFAp+W2vBain9D6q
         a+zeO0TVWv3fCr4VdILqXvog6EoqrHv0PAnY1dFTpnc+FuyMGwZu2IJFmno4eAOyp7IH
         qt6g==
X-Gm-Message-State: APjAAAVAeN+B5N7Y+1jrEsH4wpIAOThtL90DNg1pmHqMp35+7hXki+o7
        w1ylW88CjEOrUevpv+iw5xkYStuV
X-Google-Smtp-Source: APXvYqzd1RZBPDZjBqbD48zfb3DB+UWKmVDrCKLnnfxPKNwCnZFjIM+VWQj4/M2BCXMWhfg6ikGaEA==
X-Received: by 2002:a17:90a:c706:: with SMTP id o6mr17832333pjt.82.1576512812931;
        Mon, 16 Dec 2019 08:13:32 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:32 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 03/11] net: vlan: Use the PHY time stamping interface.
Date:   Mon, 16 Dec 2019 08:13:18 -0800
Message-Id: <de2f4c6f93857bc932c71574abcdc48eee706b99.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vlan layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 net/8021q/vlan_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5bff5cc6f97..5ff8059837b4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -646,8 +646,8 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
 	struct phy_device *phydev = vlan->real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phy_has_tsinfo(phydev)) {
+		return phy_ts_info(phydev, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(vlan->real_dev, info);
 	} else {
-- 
2.20.1

