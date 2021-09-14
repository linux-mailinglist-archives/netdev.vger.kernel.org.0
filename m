Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C8A40A725
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 09:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbhINHN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 03:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240599AbhINHN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 03:13:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDCC061762;
        Tue, 14 Sep 2021 00:12:09 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id o20so16004578ejd.7;
        Tue, 14 Sep 2021 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ib2Cla9NE9BCcyIj9QHsclYFQpDljJidgC34V3t8so=;
        b=Kox0pd77V5Fior9IvRAfA+R18h2wFSqR3w0DOclaqmhPTcWSz8zCUrSnRTE+tsHJfT
         H4eH4vII9n0+dLIbuGohuulLGe6R3J2/18u3T9HMQYQ/UrbK4tBXjdIlYX4UsaJHNeIC
         8l2GspmaSA1iXOpHRWtLATgFBY21vfhnQmDf9bHOFOSJ6Md2pijXmllP+JSFwd0ljL0z
         CAY87ZqkweOFPwD1fZb0VgC10jDwehKQWLwunN84PpmO2mz1TMMaWJWhqnU/OUSFmCfH
         T/qffdHPLZTUz6k7CVjkC+X/4DGCo2oFL0H+e2t88JhOEMsgh26wlav/PHpI/wuN3yC4
         Yh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ib2Cla9NE9BCcyIj9QHsclYFQpDljJidgC34V3t8so=;
        b=ldhfqEfCkMrvjCDOeZdh2mq4sNqepIu/P5x3eBSDdz0MOzZQLj5tQ40uOFQjAvm3+/
         owJNMCYfKJjq1Z24fiLGEInleEz+X70o2ojjNmwPCp7qfjMXuyPnAFbwP6SElEkPcvhf
         90ILqT9H1tLmB72skiPJGFoquWuurIB3U8WZl6rlsoEbQ72eTZhsO9hMXngKjLd1tFym
         27YPI8n7hO6HVG/qZMMUEBOUfTsIf19f4sqo1Y9bU+i8BNbWbFWgznO4uXpetbPRjlur
         ec9qc0WuyanvGbTQtQPplOwTXkH7RWG7HfmwCtGzV5bEoa1y0GyrxSQo7Ayb5cLLK1Y1
         cMeg==
X-Gm-Message-State: AOAM53164XKgYacX2puLz7jWAFddhgJLsSCUDHpJC//4VCBsyAPCExyV
        MQrU8n43m8TjM6Ctd+galoxw06IHQ0g=
X-Google-Smtp-Source: ABdhPJyNL356wHsefJWV212NycXXo6I3rwdwcajnGU37zWKQr+IfDxsSCrtmLouc3ZJY7RKHeVF+4Q==
X-Received: by 2002:a17:906:6b96:: with SMTP id l22mr17430468ejr.430.1631603528237;
        Tue, 14 Sep 2021 00:12:08 -0700 (PDT)
Received: from Ansuel-xps.localdomain ([5.170.141.93])
        by smtp.googlemail.com with ESMTPSA id s26sm4988549edt.41.2021.09.14.00.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 00:12:07 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rosen Penev <rosenp@gmail.com>
Subject: [PATCH net-next] net: phy: at803x: add support for qca 8327 internal phy
Date:   Tue, 14 Sep 2021 09:11:41 +0200
Message-Id: <20210914071141.2616-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 internal phy needed for correct init of the
switch port. It does use the same qca8337 function and reg just with a
different id.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Tested-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/phy/at803x.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index bdac087058b2..19a426aa4ede 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1420,6 +1420,19 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+}, {
+	/* QCA8327 */
+	.phy_id = QCA8327_PHY_ID,
+	.phy_id_mask = QCA8K_PHY_ID_MASK,
+	.name = "QCA PHY 8327",
+	/* PHY_GBIT_FEATURES */
+	.probe = at803x_probe,
+	.flags = PHY_IS_INTERNAL,
+	.config_init = qca83xx_config_init,
+	.soft_reset = genphy_soft_reset,
+	.get_sset_count = at803x_get_sset_count,
+	.get_strings = at803x_get_strings,
+	.get_stats = at803x_get_stats,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
2.32.0

