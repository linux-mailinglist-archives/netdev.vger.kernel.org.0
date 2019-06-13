Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F9A4450E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392744AbfFMQlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:41:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730541AbfFMGvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 02:51:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5D6i23D012518;
        Thu, 13 Jun 2019 06:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=Cklcp4WiaQzxRVfrjQ6N2LqnHn1Jb+/D/zOE2f9gAPE=;
 b=x8G48O4QztLA+T6Q8ej8FS57MNGdfgZ0fSefogeULMSOwZdLRbX0arq8C2FTb1joqfkx
 cyyN8KybBwKW94TZ2q6z0hL9/y8cSp+n1Jz7JCaoSEoQkcl+Lah8c4vSqkL/9bSegq/I
 f32t147/KrG1RxvTUhPuOdA3vXHWEpZZI8cmrKI1/riWDWS+zGuTxzxGqcLThzQpMv3/
 DQMrwbn/kBalmR7Pc7A3QWnludbmdR0zYS8vqBdVwTjIIkf5SAnqmpUFqVOYSJUNNTXv
 zg6H95flWu3UkxODyOIoix57ytYHUrFzgEddVLb0CyS9RNcfCMit2CAJh5eAtFwQ9076 kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t05nqygwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 06:51:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5D6p6lf142351;
        Thu, 13 Jun 2019 06:51:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t04j0a0qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 06:51:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5D6pBw9002024;
        Thu, 13 Jun 2019 06:51:11 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Jun 2019 23:51:10 -0700
Date:   Thu, 13 Jun 2019 09:51:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Russell King <linux@armlinux.org.uk>,
        Ruslan Babayev <ruslan@babayev.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: phy: sfp: clean up a condition
Message-ID: <20190613065102.GA16334@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906130054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906130054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The acpi_node_get_property_reference() doesn't return ACPI error codes,
it just returns regular negative kernel error codes.  This patch doesn't
affect run time, it's just a clean up.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a991c80e6567..8a99307c1c39 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1848,7 +1848,7 @@ static int sfp_probe(struct platform_device *pdev)
 		int ret;
 
 		ret = acpi_node_get_property_reference(fw, "i2c-bus", 0, &args);
-		if (ACPI_FAILURE(ret) || !is_acpi_device_node(args.fwnode)) {
+		if (ret || !is_acpi_device_node(args.fwnode)) {
 			dev_err(&pdev->dev, "missing 'i2c-bus' property\n");
 			return -ENODEV;
 		}
-- 
2.20.1

