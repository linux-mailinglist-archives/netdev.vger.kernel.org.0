Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DF413A80
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 16:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfEDN75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:59:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51640 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfEDN7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:59:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id t76so10384909wmt.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n86PQ7i51t6Ws6rTZUhS9zC+UeigcpROi1AyLP/YXmw=;
        b=DJubk3EwBE8OKBnsUx2DB2jGKvqddXjRD+MjY6JEEDhBU0kfsTlOK222j5gdvy1602
         pHkUN+/SS6ccW4r4jdAx5s50zRkdfex88JXByucXZflPi7EPDdiZg1mr9CAp8IfG/zio
         aRPpY7gAIS7vwWtECSeO7CGcnpGXvk1brZiw7iS7SmoStRr6GxZoefd1TwfeftmwmE2a
         3IzlPa3wMcyIVxlm96B0NVsuZLYzdqDit4RcztgybrIduOt8gmFUOXnOpKeNeaxyfJSY
         jATbRqjynrnrYn40ZrMmSiaPno4J/2K9d+jO9XC8AHWy3zmrNswYJl8I9IN/4zCouG7F
         RrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n86PQ7i51t6Ws6rTZUhS9zC+UeigcpROi1AyLP/YXmw=;
        b=KyXzN9M73y0QXrlFlw2+Ss8HZpDIKc46VTimscLQ4nTVRSEtIBNONrlXnNiZLEwDl1
         0QM/CeZ2vT0gLh2kLAqrlhE8dTwHbwt5Wt6zFXb+jbkKNCFqQwWrvqyOpqJ5HNzffSNx
         62g7+lkCkIJIpuGwiRccZpHCsSEedxx7NnZf4ME+t/uOL53xewk1cRNjHZdUnRsgw7+R
         no5Y5F5SrWmCuhgQDe6hWzUSCkVXTTfnKjnipJ0nPC+Ma2li7ChMg2IZEUYBAymsdt+s
         b9X7xcyCsyDnCNP+WEq2RjcIe+B7tS/g6hvsXARUZSi2b8uXY46CqNZOcHBsUiJ9avAZ
         PapA==
X-Gm-Message-State: APjAAAUnB4eow9tHz1Cl4xWnFSDb/SpYmwmQoddP9ZjfS4Fj85UF3Rc+
        Oif7tz9OAD0d8yBqPD1+Jpc=
X-Google-Smtp-Source: APXvYqydrjEvKRYk2q/WC86NMpm3acifDCcvTAakrfLyZNIXqgeU7gfkubCSkKwg5M0yQHmMN31Tzw==
X-Received: by 2002:a05:600c:2206:: with SMTP id z6mr10709538wml.80.1556978390869;
        Sat, 04 May 2019 06:59:50 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s16sm5085940wrg.71.2019.05.04.06.59.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:59:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 6/9] net: dsa: Add a private structure pointer to dsa_port
Date:   Sat,  4 May 2019 16:59:16 +0300
Message-Id: <20190504135919.23185-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504135919.23185-1-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is supposed to share information between the driver and the tagger,
or used by the tagger to keep some state. Its use is optional.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
  - None.

 include/net/dsa.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 936d53139865..b9e0ef6c5750 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -207,6 +207,12 @@ struct dsa_port {
 	struct work_struct	xmit_work;
 	struct sk_buff_head	xmit_queue;
 
+	/*
+	 * Give the switch driver somewhere to hang its per-port private data
+	 * structures (accessible from the tagger).
+	 */
+	void *priv;
+
 	/*
 	 * Original copy of the master netdev ethtool_ops
 	 */
-- 
2.17.1

