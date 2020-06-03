Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40361ED556
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgFCRu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 13:50:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56496 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgFCRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 13:50:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053HocSC185664;
        Wed, 3 Jun 2020 17:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=FdPqnGZzA4ybqn6KRHxNKak/dhZw4OpBPol0DpgMROw=;
 b=y6RgarbwLpheAfa5IVchrkpOGCplrrtADhi1BBshSfihgLfN1N4GzyRkGJOHqem7olZc
 JR2Qgd4Kowy3bCm9oiaN4Er+5XRJqorIUdF/F/haEY4fTuFRWCuNBBPoq/fFGjz11iEU
 x+V+Yb39gkurJXg+jCWU+8Ka06fCeQdEoH8//Y704yweDF+uTixF1kZv8cP2btdUwOpO
 gBL4sK60qGs7RGPYvr0fcNoVmDUGldQ1av6PfoxaVDI9tR2Of3jfe381Lr5bDzt7SMsw
 vbaWrzEjNp2duTK19eSbrZEahJzWI7pRZbKVZdkD4AmiTJBOycjbbdb/Ogpib/VDw5+i dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfemakhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 17:50:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053Hm68p050798;
        Wed, 3 Jun 2020 17:50:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31dju3m5ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 17:50:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 053HoZiX014126;
        Wed, 3 Jun 2020 17:50:36 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 10:50:35 -0700
Date:   Wed, 3 Jun 2020 20:50:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: dwmac: Fix an error code in
 imx_dwmac_probe()
Message-ID: <20200603175025.GA19353@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code is return PTR_ERR(NULL) which is zero or success.  We should
return -ENOMEM instead.

Fixes: 94abdad6974a5 ("net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 5010af7dab4af..3c5df5eeed6c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -225,7 +225,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 
 	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
 	if (!dwmac)
-		return PTR_ERR(dwmac);
+		return -ENOMEM;
 
 	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
 	if (IS_ERR(plat_dat))
-- 
2.26.2

