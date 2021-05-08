Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE3376DD5
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhEHAcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhEHAbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:31:04 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846DBC061350;
        Fri,  7 May 2021 17:29:44 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o127so6101977wmo.4;
        Fri, 07 May 2021 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eEGM53YIGmYlpHBRnf6Ug1VRbnl//rrgzPHo8YXGMUc=;
        b=hK8NZIQgUk1gvvitXr0FjLQXG0FG4vNzGFSCcpzPB/5gEmkvzj2tO79UpF7SrMgTbK
         QuFjt19IbEUbDl8ocHi8fcbz4TT6WjI0seebQS5dv0Ye+hdNj9bLX1trmNnT7sX/XX2p
         7BBHs/AsdDHXJCt2oWDHKr5WT7xmmjV0dAMO39Px5RE9SD6GD5cxorpBwCTIEmVUs4qS
         kcQ11eFSpR4rcHoDMX/DTqlJTxVXPUs/iIooXUlA3p1slLShrN1UVaw6UvpJaGKIBvvW
         mLUoXtEuSbX7AkooySkAYuJ8SHwcOAtdKm+V+2/j3OnDdbA6Jahi+djovvhc7YoU1dkc
         uqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eEGM53YIGmYlpHBRnf6Ug1VRbnl//rrgzPHo8YXGMUc=;
        b=l469G2UdQ1NUmW4OLiKB30c99UhtQaoO0Dmd2kACT2dsXwqPNAlGNdX0ik61ZDC9cm
         B/YrJd6FFjF+EnOMfIqyjw6T+XdZCIbrDM8c8C3v2pwH15dcjN34IlJ7EE7j1YtFU0na
         iyMWkOoJzy3eVD97WF8FX36o/JKZ2u8EyuU4edEjoK4TrewbCutwHncEH237InVDhhkP
         4RfEvCoeTAy3DF6aXiJrrL7mMTOMvf975vStpv3ZFi7o4bsC15I/4L4bK4/R4M6yZ5JV
         30dwssmdBOzaV7HKO7MAAZGlq08xOcpYxUp4oBGm3ByLUftlmqaT+8BgAj6pe0b8q6lI
         +bBw==
X-Gm-Message-State: AOAM532RYuFcfwzITS8w+fAHpRMRbcWbFe/Qd9eL9DW+dKguWwyzEeUQ
        f7kJQs1t7faUmQhdJxU6/68=
X-Google-Smtp-Source: ABdhPJw7AtPGTdQJauew1+h1iSolj/BiUS1OPVrNW0uJpAnf3pQciPUPWRcZDlYwN9s9Y91GmPX2ag==
X-Received: by 2002:a05:600c:c7:: with SMTP id u7mr12616353wmm.156.1620433783149;
        Fri, 07 May 2021 17:29:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:42 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 22/28] net: dsa: qca8k: enlarge mdio delay and timeout
Date:   Sat,  8 May 2021 02:29:12 +0200
Message-Id: <20210508002920.19945-22-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The witch require some extra delay after setting page or the next
read/write can use still use the old page. Add a delay after the
set_page function to address this as it's done in QSDK legacy driver.
Some timeouts were notice with VLAN and phy function, enlarge the
mdio busy wait timeout to fix these problems.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 1 +
 drivers/net/dsa/qca8k.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index e272ccaaa7f6..f96579c0bd46 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -143,6 +143,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	}
 
 	qca8k_current_page = page;
+	usleep_range(1000, 2000);
 	return 0;
 }
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index a878486d9bcd..d365f85ab34f 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -20,7 +20,7 @@
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
-#define QCA8K_BUSY_WAIT_TIMEOUT				20
+#define QCA8K_BUSY_WAIT_TIMEOUT				2000
 
 #define QCA8K_NUM_FDB_RECORDS				2048
 
-- 
2.30.2

