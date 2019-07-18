Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86286CFEE
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfGROed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:34:33 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37576 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGROed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:34:33 -0400
Received: by mail-io1-f67.google.com with SMTP id q22so51773376iog.4;
        Thu, 18 Jul 2019 07:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oDl7E8YKcAEhCCAp8p0njilUrHjKHf6sfibp/FHWZTo=;
        b=u6F+WnLGI2ptAR4uryiw92FIXjSyTxJroviYtGMBHF1degDfacRhXmmY7s41c2f/kB
         /R1DuuvYeiI5maIhSSYwosX0qRoZghfT49S29+Wm6vOyMNFp0J9GZtIPAPtQtm4YylID
         xwrkjNb9k8TclP+0zVToQAvVF/4CH//fITQdiAtUU5ByuKONgkYm+kC9RKrudkGSzhxR
         jUFWuULz1d0LILvm+m1dOAOdmM/3F/IhCCjO2vmwDIGGFo79UW56ywXAQuKceGq1g/l1
         dKbInlHFhNgnQCsV3qCwHvJLmPjZtNfm2ws80mU74Y4RZxYE7hId0xU+VSw3/c4qAxcV
         fvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oDl7E8YKcAEhCCAp8p0njilUrHjKHf6sfibp/FHWZTo=;
        b=ifkvwy3YkniX0fX7a2jixMA9hxsdei8GDdbr6Wrq31lOh3MY0FED8/RD+Tc/sz3RDa
         Or9p+4zTR9OUaSnALAwUq2eta9KWcnKAFn79Glnvuk710arRoNUuRRWrasw51CVrrZok
         IGU/Y9mozhv3HZvfSdLaKS6UF/1gqgVzGd6iMIfCbcFZPHOo6axd+AixhjBi+6wSYvKp
         /7QKUJ4JYueteFqZQSK8hootpQNQZlEblcuCoxdAuqPDJKJ1HpnYqydH3WCTBJL4YHMz
         LucqXtnjgiBCDmVklxCCaPQ0lequ8zUcVs9ouHP12LMbhrcIPVNA1XKb18dQpynwUjnq
         Kb6g==
X-Gm-Message-State: APjAAAXlBP2ZNPMRuujciV4u7lE+d8uJoCLl9CP4XC+rJsdVtX3kmYL8
        bXiZ5ygxrgg0KtmfmYbZkc2Fde8d
X-Google-Smtp-Source: APXvYqwbrz77pJJV1QMk+m26XOfbGgZ4WjOwTiuDXjo1erC4rtTCZ5iiYUeN8N3ZmggpXfDYhuVH9w==
X-Received: by 2002:a6b:ee15:: with SMTP id i21mr11002926ioh.281.1563460471939;
        Thu, 18 Jul 2019 07:34:31 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id x13sm21001895ioj.18.2019.07.18.07.34.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 07:34:31 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Fugang Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fec: generate warning when using deprecated phy reset
Date:   Thu, 18 Jul 2019 10:34:28 -0400
Message-Id: <20190718143428.2392-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allowing the fec to reset its PHY via the phy-reset-gpios
devicetree property is deprecated. To improve developer
awareness, generate a warning whenever the deprecated
property is used.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 38f10f7dcbc3..00e1b5e4ef71 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3244,6 +3244,12 @@ static int fec_reset_phy(struct platform_device *pdev)
 	else if (!gpio_is_valid(phy_reset))
 		return 0;
 
+	/* Recommended way to provide a PHY reset:
+	 * - create a phy devicetree node, and link it to its fec (phy-handle)
+	 * - add your reset gpio to the phy devicetree node
+	 */
+	dev_warn(&pdev->dev, "devicetree: phy-reset-gpios is deprecated\n");
+
 	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
 	/* valid reset duration should be less than 1s */
 	if (!err && phy_post_delay > 1000)
-- 
2.17.1

