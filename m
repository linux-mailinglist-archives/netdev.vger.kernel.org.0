Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B36D2DBCCA
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgLPIjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:39:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgLPIjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:39:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BG8Xs8d049930;
        Wed, 16 Dec 2020 08:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=9EzIrzu8yR2bEg9Yuuyun20shVVA58aiXhqv0Ix0rwQ=;
 b=vBIu8Lr3lYEY0A+mmLenwj7QJvc2oPyu/ObmzIRh/EKVRzCjCfoPxfuWHCW3baX+Jmh1
 jJRZk0LdrdCSK4daYT5VZOOY/qsIuM8xtqtxWM5EHtI//TnZn+dJPSQCtCHAB8HSH2J5
 yKmJFPc/2pXPsAeKnYMCxKCjIeyVxixRYd2BvZ5vp0sRR4pGNrihdeTWm/ZXGCep3mS7
 4Y5kHbhSLwJWjfeL+za0k0BJLDclV/gsIf/TzwLt2BPMCKEaLKUkWODRm3LoA2b6EuBB
 sJ6lnXfnYFjiRwWpOBsm3O3+w+/PviTOjOcnO7AxOjFUwsjr09mOYl60ENhWeU/mHE+C +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntm6tvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Dec 2020 08:38:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BG8ZBEj114133;
        Wed, 16 Dec 2020 08:38:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35e6jse0yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 08:38:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BG8cDdW016655;
        Wed, 16 Dec 2020 08:38:13 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 00:38:12 -0800
Date:   Wed, 16 Dec 2020 11:38:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Sony Chacko <sony.chacko@qlogic.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Sritej Velaga <sritej.velaga@qlogic.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] qlcnic: Fix error code in probe
Message-ID: <X9nHbMqEyI/xPfGd@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160055
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return -EINVAL if we can't find the correct device.  Currently it
returns success.

Fixes: 13159183ec7a ("qlcnic: 83xx base driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 5a7e240fd469..c2faf96fcade 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2492,6 +2492,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		qlcnic_sriov_vf_register_map(ahw);
 		break;
 	default:
+		err = -EINVAL;
 		goto err_out_free_hw_res;
 	}
 
-- 
2.29.2

