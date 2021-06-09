Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426333A10A1
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbhFIJzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:55:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17178 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238448AbhFIJzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:55:20 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1599pccj006669;
        Wed, 9 Jun 2021 09:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=S/qcMO7tg70TWSG285PucZXlxuXsoTBcX4MUtOs0lzQ=;
 b=eUqjwonPcrNQNVRUhhy+lflZxT8VH7KF61Yuf8Otw2A4q9iUKmEqK2BwIYZBbsDjbAYM
 OoGfTEhVT8ndrvVmGaLxvJDmNDqwwXibsJoP+C/2OdTBMNiQKfm36E92AXwgkiVqxDK/
 RR4p9kfWv/1vE7hDbucCE+Hc38mjdht21m0rHfxeWzJJQ5SkFrDnucTQmw/xuvXQbgRo
 HjbI72Pd6nA98sTQQNewFw9XNrmI81lJUv8JkUXCrLycCf0IKbzRYgIDEDi4OBBVcqpl
 jbzjUaZsFX04uz+dpvAWHA7d3eSrhecxo00ZAi0rBrthb2Ahvbl+JP5qcdp59ILYmnaU nw== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3926dh8eej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:53:16 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1599pnhp181059;
        Wed, 9 Jun 2021 09:53:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 390k1rsmv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:53:15 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599rEVA183088;
        Wed, 9 Jun 2021 09:53:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 390k1rsmuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:53:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1599rBTg010829;
        Wed, 9 Jun 2021 09:53:11 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 09:53:11 +0000
Date:   Wed, 9 Jun 2021 12:53:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net-next] net: dsa: qca8k: check the correct variable in
 qca8k_set_mac_eee()
Message-ID: <YMCPf8lVosAYayXo@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMCPTLkZumD3Vv/X@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: pRvR0IkDCi0pyCOCbQcxZO4wREhhhL0-
X-Proofpoint-GUID: pRvR0IkDCi0pyCOCbQcxZO4wREhhhL0-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code check "reg" but "ret" was intended so the error handling will
never trigger.

Fixes: 7c9896e37807 ("net: dsa: qca8k: check return value of read functions correctly")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/qca8k.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9df3514d1ff2..1f63f50f73f1 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1454,10 +1454,8 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 
 	mutex_lock(&priv->reg_mutex);
 	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
-	if (reg < 0) {
-		ret = reg;
+	if (ret < 0)
 		goto exit;
-	}
 
 	if (eee->eee_enabled)
 		reg |= lpi_en;
-- 
2.30.2

