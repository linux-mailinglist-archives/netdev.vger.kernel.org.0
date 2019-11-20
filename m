Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE4E10408C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbfKTQR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:17:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34306 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729397AbfKTQR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 11:17:28 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKGDA14099436;
        Wed, 20 Nov 2019 11:17:24 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wact8g9r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 11:17:21 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAKGGDKu003108;
        Wed, 20 Nov 2019 16:17:10 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2wa8r6p7yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 16:17:10 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAKGHAtD55509442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:17:10 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E76AF11206B;
        Wed, 20 Nov 2019 16:17:09 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B699112063;
        Wed, 20 Nov 2019 16:17:09 +0000 (GMT)
Received: from ltcalpine2-lp21.aus.stglabs.ibm.com (unknown [9.40.195.230])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Nov 2019 16:17:09 +0000 (GMT)
From:   Juliet Kim <julietk@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, julietk@linux.vnet.ibm.com,
        tlfalcon@linux.vnet.ibm.com
Subject: [PATCH 1/2] net/ibmvnic: Revert "net/ibmvnic: Fix EOI when running in XIVE mode"
Date:   Wed, 20 Nov 2019 11:16:54 -0500
Message-Id: <1574266615-9991-2-git-send-email-julietk@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574266615-9991-1-git-send-email-julietk@linux.vnet.ibm.com>
References: <1574266615-9991-1-git-send-email-julietk@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_04:2019-11-20,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=921 suspectscore=1
 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911200142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 11d49ce9f7946dfed4dcf5dbde865c78058b50ab
(“net/ibmvnic: Fix EOI when running in XIVE mode.”) since that
has the unintended effect of changing the interrupt priority
and emits warning when running in legacy XICS mode.

Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f59d9a8..2b073a3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2878,10 +2878,12 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
 
 	if (test_bit(0, &adapter->resetting) &&
 	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
-		struct irq_desc *desc = irq_to_desc(scrq->irq);
-		struct irq_chip *chip = irq_desc_get_chip(desc);
+		u64 val = (0xff000000) | scrq->hw_irq;
 
-		chip->irq_eoi(&desc->irq_data);
+		rc = plpar_hcall_norets(H_EOI, val);
+		if (rc)
+			dev_err(dev, "H_EOI FAILED irq 0x%llx. rc=%ld\n",
+				val, rc);
 	}
 
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
-- 
1.8.3.1

