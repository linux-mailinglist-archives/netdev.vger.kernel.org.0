Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CC3398FD4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhFBQXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:23:18 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:46898 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhFBQXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:23:17 -0400
Received: by mail-ed1-f49.google.com with SMTP id r11so3589367edt.13
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=je7P0/kj9dkI/ARzdpLfXpbx3wW6XGZB976ubUlH0yw=;
        b=uYtgtHqKmYC3Md3nzN9DdbIQy+TVjJt2HANSXW+FAXy+bUGbUOIj08qmZDQRJ6ioxB
         +e+FOHuZJhwNry2KZgAYBcc5J0YWCrUp341yJVSTnEvxa+qclyhPXk3C9Jk1TgfRb3wC
         wrs/8gumjcYzTmQp9h5z9fLVj4eb/mOoomQIdlLRfN9TQzGUxkkFsUdkJmMaBA8dkD9J
         xfEgaJ+El3+VjcfaDGO20mPwOCPMC3jq4/f+NtRUZqVBRrMK2xKyiRZJEff7PVgyCE/u
         YT2zeVUTUyNcbLb3IInVr/MG58sluDvT6ev9g+BRDQKe3TU83oxNbciZhHtbEuObf7nm
         a8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=je7P0/kj9dkI/ARzdpLfXpbx3wW6XGZB976ubUlH0yw=;
        b=uRDzvi59NM26/0EbjSEqfB3291B50RwVKx+CDa6GII5o1d3EhnEY0bekaxRmBPNfkj
         DFu9DiZawgYjK0d+PTDU1Xgm90C8hEXD1VilsrVeBFjIBHL/huf2tJerP6XDQp0ENvQF
         gCQcAaZ4yvu1e7AHeQDJwrhV5Vt7XLtMVrC9twg4QuhrhhS3ip9mZl2tcv5Gygd2b4MT
         Zq25a1H9ehPZ2UiYC3TuSW+8WIfDqpfP9I1AijiGW80BLo88jKFb/O3KuzmdNowKt9vh
         jLDhEu5srYr6aBYkJlyrHW5ZoAiE41ChAiNUVOY9NXeCWJVzQpK05Sdwb+mX5I6rVtA1
         6h5g==
X-Gm-Message-State: AOAM532qI1zvmmFxc0oIks1zDzeN1wkvXe2+0bCOjlAEhgjPCgKrtbR3
        5zbbzdIztUc8HhgtyPLXyQIAr3uphoM=
X-Google-Smtp-Source: ABdhPJx97gGZMN/nDz742EkP/FnQIPewnJyHPlLjia2AhXU2maHzDZhY5bJ1NOJtDTBXcvtLDsM46w==
X-Received: by 2002:a05:6402:2049:: with SMTP id bc9mr19684863edb.298.1622650833111;
        Wed, 02 Jun 2021 09:20:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 1/9] net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
Date:   Wed,  2 Jun 2021 19:20:11 +0300
Message-Id: <20210602162019.2201925-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602162019.2201925-1-olteanv@gmail.com>
References: <20210602162019.2201925-1-olteanv@gmail.com>
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
v1->v2: none
v2->v3: none

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

