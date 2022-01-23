Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3072497455
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239540AbiAWSeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbiAWSen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:34:43 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A940C06173B;
        Sun, 23 Jan 2022 10:34:43 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l25so9619392wrb.13;
        Sun, 23 Jan 2022 10:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QiOgKgP5kmmtK6S2g8otnbNPdYlZLH4U555IDjUUehY=;
        b=nDJa+pX98uzuM/z6giz9sAVqUM+UxvHpSI+ak+tFIV+VsQhibkftoxoVqZcyas5rdI
         W72ERGnTedeamZkE3O9wBpaNLMOWFXWQPFnZt1M+4Fkk7qaYpk+9GNMGgvNmxDxD4gZV
         IjE6pvb7n/rVg3jPIhgH0u4peW1YMLkULdf69L27p/5lm2Mhx0yBXWVusZdfAl28+ZSk
         6517Up2hcUM7WVHe0Oi6ImLBAmhMr1b+ep9j3JAf1Zx+dXR8Q8J2ZMi8Rc06FBv4cskK
         Wlcw5NX5D3Rniwj+0NaRn3CWKri8mxiKKAvofEHvTqWCAuZqeLYeA8rE4ObY7iYcvRfk
         JqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QiOgKgP5kmmtK6S2g8otnbNPdYlZLH4U555IDjUUehY=;
        b=njr+jfj2GpoEQ4Ybe4t4QP3AR7IEuT2Z33TZficL1CGBq//unz7Vf6UzCZ0Fq4jfEE
         MH6/xKElj7TvC0qXr6/cYcvS9e0iTC95/AaSnDVNiyr3yYzuiWPVSQSzK8zEi1keoSRZ
         8pyfs70077v0lf8Y59lfqYB7F3k6tKmDjzwIBVrQiw2xHt0+fkeobPXMX9kXv9FYENWk
         H35VuC+vryRQaysdie1yHWHk63xCo8/6Lt6JdLkKXETdwLsX25DE3OjyZ1zyylA0TmdD
         wh/ruZDs9n3ThdUik5W43cPQfbw2QnY5LckNOlyKSqV455SLpvil25UW/lA/HuyvHqvk
         UQ4w==
X-Gm-Message-State: AOAM533y3/j89Rv7APJwcW29IVqAMdt15FEfAJZMOgnDKvJnIag14mfn
        v7i5kPRKVUK1Lk9my4g6EK8=
X-Google-Smtp-Source: ABdhPJwU1FAvTXxySatmqT04kn0Ftxclc8hnPgTQTB4cHvIVPkkWlHZ3Mm8VSqVCriYkzORvj/sbIQ==
X-Received: by 2002:adf:ea0a:: with SMTP id q10mr11817653wrm.670.1642962881663;
        Sun, 23 Jan 2022 10:34:41 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id m5sm10988955wms.4.2022.01.23.10.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:34:41 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: tulip: remove redundant assignment to variable new_csr6
Date:   Sun, 23 Jan 2022 18:34:40 +0000
Message-Id: <20220123183440.112495-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable new_csr6 is being initialized with a value that is never
read, it is being re-assigned later on. The assignment is redundant
and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/dec/tulip/pnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/pnic.c b/drivers/net/ethernet/dec/tulip/pnic.c
index 3fb39e32e1b4..653bde48ef44 100644
--- a/drivers/net/ethernet/dec/tulip/pnic.c
+++ b/drivers/net/ethernet/dec/tulip/pnic.c
@@ -21,7 +21,7 @@ void pnic_do_nway(struct net_device *dev)
 	struct tulip_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->base_addr;
 	u32 phy_reg = ioread32(ioaddr + 0xB8);
-	u32 new_csr6 = tp->csr6 & ~0x40C40200;
+	u32 new_csr6;
 
 	if (phy_reg & 0x78000000) { /* Ignore baseT4 */
 		if (phy_reg & 0x20000000)		dev->if_port = 5;
-- 
2.33.1

