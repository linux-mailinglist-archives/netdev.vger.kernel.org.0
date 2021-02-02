Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE50630B77F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 06:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhBBF4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 00:56:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42722 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhBBF4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 00:56:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1125oM7s103164;
        Tue, 2 Feb 2021 05:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=2HotEF9KBpERyxgvGJrKJdjPjfRvptLxpAAXNGUkRB4=;
 b=cIaMSqCZx/CetN4MhnU7Vt9satoDay7TQqIwD0LRxN8cnwmmG1q4UdPU2cTo5l6JFKQZ
 vy9euDmG+A8FZ2m6lrXi56cCbB28bwSxbRp+NebRdcIGakA3Y+QGdDpzkAuaPu1t7knx
 bichIGRf+oPylyJbGn0kMP4q9rM3Ykf21YZjMtaftMATEE73iLT0/WiGzkkFZcWEPpRG
 gZN7zYkba1Suvk0qS/ZfYJ1bGmR6D5M+O7KJdJ856b3NwNvXSgCxJgLjKAPxnPN5ucJh
 8MWp20qrtt4DN33oplM7Zl1Tom5Hfk0OTrCD6rJlzptVZDaw8/xzMplRZfRDZcHF26q1 qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvr0xuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 05:55:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1125sVvA188081;
        Tue, 2 Feb 2021 05:55:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 36dhcw410x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 05:55:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1125tXBe028894;
        Tue, 2 Feb 2021 05:55:33 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Feb 2021 21:55:32 -0800
Date:   Tue, 2 Feb 2021 08:55:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alex Elder <elder@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: ipa: pass correct dma_handle to  dma_free_coherent()
Message-ID: <YBjpTU2oejkNIULT@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020041
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ring->addr = addr;" assignment is done a few lines later so we
can't use "ring->addr" yet.  The correct dma_handle is "addr".

Fixes: 650d1603825d ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Smatch also complians about:

    drivers/net/ipa/gsi.c:1739 gsi_channel_setup()
    warn: missing error code 'ret'

It probably should return -EINVAL, but I'm not positive.

 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f79cf3c327c1..b559d14271e2 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1373,7 +1373,7 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 	/* Hardware requires a 2^n ring size, with alignment equal to size */
 	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (ring->virt && addr % size) {
-		dma_free_coherent(dev, size, ring->virt, ring->addr);
+		dma_free_coherent(dev, size, ring->virt, addr);
 		dev_err(dev, "unable to alloc 0x%zx-aligned ring buffer\n",
 			size);
 		return -EINVAL;	/* Not a good error value, but distinct */
-- 
2.29.2

