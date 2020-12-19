Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB3C2DEE62
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 12:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgLSLFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 06:05:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgLSLFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 06:05:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BJAxrZq070732;
        Sat, 19 Dec 2020 11:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=KqQd5C/oVrn9Vxupsvz0V8EFYbvRMSsdVu9QXDDGAmU=;
 b=vSTQQcG6HevAdfoUQxk/2UFagc387B4z1Hql1d6E9PV1qiJuSKAkK9ZZuIcxIfj1YfVH
 U2KOic291zED1r05bNla6ihFzrHgzpqcjzkKWLn/uyN5OtI+mdtxfk6J98+NzrqCyef6
 0tdtxTbQV8GyuPCyrefW5m5vMDN1bXUbT6TQdIHUZdgV4usaf0oy89yfllLOjmwhdDLs
 XMT/nBsaefkaYckmlCplknaiKZPCbwcWwaq0ZtThWWfgW8A9H9eP4qJdTcEGfhAQaLxb
 tWgMzrgBp1C0JQ+s64Fx0BFkdsfmUwfcXyVXBCSHMl8W2XLeKv64gPH+gVHCxG0678SA dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35h9fkrnnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 19 Dec 2020 11:03:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BJB1Nsx084404;
        Sat, 19 Dec 2020 11:01:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35h8ugsta9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Dec 2020 11:01:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BJB1qSY001476;
        Sat, 19 Dec 2020 11:01:53 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Dec 2020 03:01:52 -0800
Date:   Sat, 19 Dec 2020 14:01:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Chas Williams <3chas3@gmail.com>
Cc:     chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] atm: idt77252: call pci_disable_device() on error path
Message-ID: <X93dmC4NX0vbTpGp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012190080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012190080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This error path needs to disable the pci device before returning.

Fixes: ede58ef28e10 ("atm: remove deprecated use of pci api")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/atm/idt77252.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 65a3886f68c9..5f0472c18bcb 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3607,7 +3607,7 @@ static int idt77252_init_one(struct pci_dev *pcidev,
 
 	if ((err = dma_set_mask_and_coherent(&pcidev->dev, DMA_BIT_MASK(32)))) {
 		printk("idt77252: can't enable DMA for PCI device at %s\n", pci_name(pcidev));
-		return err;
+		goto err_out_disable_pdev;
 	}
 
 	card = kzalloc(sizeof(struct idt77252_dev), GFP_KERNEL);
-- 
2.29.2

