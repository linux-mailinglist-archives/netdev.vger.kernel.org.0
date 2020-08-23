Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A1C24EFE4
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 23:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHWVfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgHWVfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 17:35:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A417C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:35:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id oz20so4450169ejb.5
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlftxuZyp+0yIx85djMGeU1j8E2b2MQlZnYcmAr/cok=;
        b=Nhsf9LXXyvERNXfIlV1Z5Ok/HNdzAgusj19nwlZWBNCI0ywxU5OV7ENHKa32sbtjiF
         mOamHe2oKA8icQ2AtvR4CmP7OFKzko0G3tP7kaoLORqTh/Bdo7PZBJQQRzjk2HQqrX6W
         kNBqmHdXS+QYKgoXGR5JcvluL1Om5YU41F3m38AuE7R8vvKoRtXB6D5am5Y12UpOaTLL
         4FbdnYHX82aaD/6iWVR0I/Jlyf1VuhuBnVE6MfB+Ga2lak1wqa+HxAjVNKL9yDCwOeXc
         02wElVLUZzk2ds31TRZ8ysWkIPAsiEw3UrMcBrS8+6Al35iBIGCzDYNkbrREquVeUzsn
         PQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlftxuZyp+0yIx85djMGeU1j8E2b2MQlZnYcmAr/cok=;
        b=drEl6xUwdsqwLpMBUTHvs6rQw2jDg9sIhBzXrxp9rOq0gw/iZhzVBzf9DhwnASj4iL
         WkC1QpiGk4EzIlTt9ckwXx48a8Fy+2QFLBfNxCzKwrUU/isQBUVXPAH5rtWRik2C8vx7
         yG702xd8czb8SlgjZgjX4QvFDYjyRxb3wK9pPd4dQmNU1GMHuV8IrA1FAVp5rKgIJPPE
         G9fCqm3+8Oq/30u8I1ORQv1ImcUatag9CRYqkGgxddkxgW2mqYwNftMpYiO1Xab+bOfC
         gtmucn8Ht/qtN/wCP9lMJBDix8VYQDSft5Y5tuqOBwazbV8Q9x3rr1XWXLsLafYYB+Z/
         DIBw==
X-Gm-Message-State: AOAM531vmvd62lMwgQaY4lnEhJN2e61b52Wbf+AgbmMcxNfV3MuM3xB9
        3QcKR6yphJ2ynAcJNHGKsxXHu1XQX6A=
X-Google-Smtp-Source: ABdhPJyPKpSrnmfSIiFtNS1XvYCMpxaOBd5GGKGNDPCsUcVgU0D1kQLP2Ouxer8XlubcWdr1BKwc5A==
X-Received: by 2002:a17:906:9145:: with SMTP id y5mr2807242ejw.76.1598218536654;
        Sun, 23 Aug 2020 14:35:36 -0700 (PDT)
Received: from localhost.localdomain ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id n24sm6978441edq.63.2020.08.23.14.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 14:35:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net] net: dsa: change PHY error message again
Date:   Mon, 24 Aug 2020 00:35:20 +0300
Message-Id: <20200823213520.2445615-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

slave_dev->name is only populated at this stage if it was specified
through a label in the device tree. However that is not mandatory.
When it isn't, the error message looks like this:

[    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
[    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
[    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
[    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d

which is especially confusing since the error gets printed on behalf of
the DSA master (fsl_enetc in this case).

Printing an error message that contains a valid reference to the DSA
port's name is difficult at this point in the initialization stage, so
at least we should print some info that is more reliable, even if less
user-friendly. That may be the driver name and the hardware port index.

After this change, the error is printed as:

[    4.957403] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 0
[    4.964231] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 1
[    4.971055] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 2
[    4.977871] mscc_felix 0000:00:00.5: error -19 setting up PHY for port 3

Fixes: 65951a9eb65e ("net: dsa: Improve subordinate PHY error message")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 53310bbdeb0d..59e2d3c1a717 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1832,8 +1832,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	ret = dsa_slave_phy_setup(slave_dev);
 	if (ret) {
-		netdev_err(master, "error %d setting up slave PHY for %s\n",
-			   ret, slave_dev->name);
+		dev_err(ds->dev, "error %d setting up PHY for port %d\n",
+			ret, port->index);
 		goto out_gcells;
 	}
 
-- 
2.25.1

