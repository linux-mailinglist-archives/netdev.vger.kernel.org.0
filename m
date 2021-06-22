Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9B03B0350
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFVLyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:54:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54268 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230452AbhFVLyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:54:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MBlcTV020562;
        Tue, 22 Jun 2021 11:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Yr1p6Q/+eK8PSMXu3bRpZ+9sRs4I6GuoLZCsW4oDY58=;
 b=N8UnPMEU8s2a+4wJAnG+dXSdLytfP13glQGh0OjmJzjgWUaMHxme7qqDvS4EiRG4IDHw
 Di+cSnRauZwpjNOrlAhxVeo8GuPMd0cXvhXWGuSx5sUc0ZGZ9sqghNons21u0uVzzKLb
 tyaLv+tSXs+Bmdt+dKivO3EDRDKAqWs5JmVPv/hxSsjqi+PXKRrvekOfToac2OCufjyR
 9d9k7i2z0nzG4R5mA/5yjEyf4IAbplH60+RNJxlhHXaoyriHIw+Uk9NO9XpYY/inMvWs
 z0dZADnjm9G15Carm5UgMlq6vROSG099X62LdNJjTMP2bhGQleZI0U6OQFDH9ACTiL7K pQ== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39ap66k4da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:51:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15MBpuli075091;
        Tue, 22 Jun 2021 11:51:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3996md9yf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:51:56 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15MBpu74075065;
        Tue, 22 Jun 2021 11:51:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3996md9yep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:51:56 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15MBpqFV027216;
        Tue, 22 Jun 2021 11:51:53 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jun 2021 04:51:51 -0700
Date:   Tue, 22 Jun 2021 14:51:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Qing Zhang <zhangqing@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] stmmac: dwmac-loongson: fix uninitialized variable
 in loongson_dwmac_probe()
Message-ID: <YNHOz8Aqo7Y1ZwO+@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: KMVqZT6IYIXJZ4cLfD0rpbGgeJbEfcFI
X-Proofpoint-GUID: KMVqZT6IYIXJZ4cLfD0rpbGgeJbEfcFI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "mdio" variable is never set to false.  Also it should be a bool
type instead of int.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 8cd4e2e8ec40..e108b0d2bd28 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -49,7 +49,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 {
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_resources res;
-	int ret, i, mdio;
+	bool mdio = false;
+	int ret, i;
 	struct device_node *np;
 
 	np = dev_of_node(&pdev->dev);
-- 
2.30.2

