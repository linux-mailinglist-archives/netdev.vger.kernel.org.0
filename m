Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BCF1F0B3A
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 15:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgFGNDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 09:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgFGNDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 09:03:08 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03E4C08C5C2;
        Sun,  7 Jun 2020 06:03:07 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n21so780895ejg.3;
        Sun, 07 Jun 2020 06:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sz9gBVVeMmCOLNwfNEr8y0q2MmnBrNbnLVxb2Hv4PU0=;
        b=ARi2s5xQ5Lsat1eRCYPXeFBJ06VCGZ6cXtLmcoYjte5ZtXv0dj3FczN5JWPBzVZt+p
         sGAK5EbjlR8dodw9v0TMJi/JUvpCP8kgnbat4Maeu2QcTFZTv5NEox6crNHPQLgojHia
         488Wz13L3SLutQ8wH9XUOFxaJ83r3KOBnTELPrEJPjLx/WCxT1TwWQ0q2lxGheQATHjM
         oxncJ9/xtXHiNsbC8LpbeJ69NyCwzReao2RAYxzdvcJOZz7RwDyo+6UU7+KVrIR01CZH
         9e1o+EIpiSlkR8/4K0meYbL1EDgebzIifl5KZtNqCWrbFqJkUWtuE/TfqSYRmaZWl9Ns
         nSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sz9gBVVeMmCOLNwfNEr8y0q2MmnBrNbnLVxb2Hv4PU0=;
        b=uTFnOeapvmaiBkriHxSHTgOLkY60I/wSds6MRVKV9v3oCmwgtcawk4/6dq0GDof8fp
         +g7toG/vVBStWLhlkuCEuzDP0BB/DF01qujNP1QfvGx8HUtqvbRcv1t1Fd1y9bWbJha9
         rBDmp7T3L3rogwZfJBSPbG6jDhGEwVJTCTWfipzHCt2/bxOWue4vMI98b09wa26gAgCc
         jrsNNaVhtLOKR53+7jqvrgm8cDzWCqvq2PZ7Z9pY7xLNFCjeANpMTtIjRzSOieywLpxQ
         l67RcDcdJecbEg/+o38Dv9NtvlNaoYl3S/ggKUzuO7LeoC+DGW2ZqMYkFCi+xrQ2YjZQ
         FCNA==
X-Gm-Message-State: AOAM533Yf1lasHdPt3cxCxDHCw1Vb4uE5dTnxzo9vwo06Inh+bAofRBw
        7KA5fcinJcMtOEu17ahgue4=
X-Google-Smtp-Source: ABdhPJwdy0HIwwfTUs9lnh2a8Ajb3MOjrSbkREmlPVg91dTI+wf9sPUDsdMtsr6lXoxqJmB7ppnVYA==
X-Received: by 2002:a17:906:b55:: with SMTP id v21mr15930486ejg.298.1591534984853;
        Sun, 07 Jun 2020 06:03:04 -0700 (PDT)
Received: from localhost.localdomain (p200300f137189200428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3718:9200:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id ew9sm8588784ejb.121.2020.06.07.06.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 06:03:04 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net v1] net: dsa: lantiq_gswip: fix and improve the unsupported interface error
Date:   Sun,  7 Jun 2020 15:02:58 +0200
Message-Id: <20200607130258.3020392-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While trying to use the lantiq_gswip driver on one of my boards I made
a mistake when specifying the phy-mode (because the out-of-tree driver
wants phy-mode "gmii" or "mii" for the internal PHYs). In this case the
following error is printed multiple times:
  Unsupported interface: 3

While it gives at least a hint at what may be wrong it is not very user
friendly. Print the human readable phy-mode and also which port is
configured incorrectly (this hardware supports ports 0..6) to improve
the cases where someone made a mistake.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index cf6fa8fede33..521ebc072903 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1452,7 +1452,8 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 
 unsupported:
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	dev_err(ds->dev, "Unsupported interface: %d\n", state->interface);
+	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+		phy_modes(state->interface), port);
 	return;
 }
 
-- 
2.27.0

