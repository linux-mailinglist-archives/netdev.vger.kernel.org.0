Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EC711D863
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbfLLVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:15:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730971AbfLLVPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:15:51 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCL7Eno051267;
        Thu, 12 Dec 2019 16:15:49 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wujxrppd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 16:15:48 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBCL7YiG052047;
        Thu, 12 Dec 2019 16:15:48 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wujxrppcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 16:15:48 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBCL9xOL012765;
        Thu, 12 Dec 2019 21:15:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 2wr3q7dhy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 21:15:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCLFka655836952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 21:15:46 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48A8678060;
        Thu, 12 Dec 2019 21:15:46 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C55197805E;
        Thu, 12 Dec 2019 21:15:44 +0000 (GMT)
Received: from LeoBras.aus.stglabs.ibm.com (unknown [9.18.235.137])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 21:15:44 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Leonardo Bras <leonardo@linux.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] drivers/vhost : Removes unnecessary 'else' in vhost_copy_from_user
Date:   Thu, 12 Dec 2019 18:15:39 -0300
Message-Id: <20191212211539.34578-1-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_07:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need for this else statement, given that if block will return.
This change is not supposed to change the output binary.

It reduces identation level on most lines in this function, and also
fixes an split string on vq_err().

Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
---
 drivers/vhost/vhost.c | 50 +++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f44340b41494..b23d1b74c32f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -824,34 +824,32 @@ static int vhost_copy_from_user(struct vhost_virtqueue *vq, void *to,
 
 	if (!vq->iotlb)
 		return __copy_from_user(to, from, size);
-	else {
-		/* This function should be called after iotlb
-		 * prefetch, which means we're sure that vq
-		 * could be access through iotlb. So -EAGAIN should
-		 * not happen in this case.
-		 */
-		void __user *uaddr = vhost_vq_meta_fetch(vq,
-				     (u64)(uintptr_t)from, size,
-				     VHOST_ADDR_DESC);
-		struct iov_iter f;
 
-		if (uaddr)
-			return __copy_from_user(to, uaddr, size);
+	/* This function should be called after iotlb
+	 * prefetch, which means we're sure that vq
+	 * could be access through iotlb. So -EAGAIN should
+	 * not happen in this case.
+	 */
+	void __user *uaddr = vhost_vq_meta_fetch(vq,
+			     (u64)(uintptr_t)from, size,
+			     VHOST_ADDR_DESC);
+	struct iov_iter f;
 
-		ret = translate_desc(vq, (u64)(uintptr_t)from, size, vq->iotlb_iov,
-				     ARRAY_SIZE(vq->iotlb_iov),
-				     VHOST_ACCESS_RO);
-		if (ret < 0) {
-			vq_err(vq, "IOTLB translation failure: uaddr "
-			       "%p size 0x%llx\n", from,
-			       (unsigned long long) size);
-			goto out;
-		}
-		iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
-		ret = copy_from_iter(to, size, &f);
-		if (ret == size)
-			ret = 0;
-	}
+	if (uaddr)
+		return __copy_from_user(to, uaddr, size);
+
+	ret = translate_desc(vq, (u64)(uintptr_t)from, size, vq->iotlb_iov,
+			     ARRAY_SIZE(vq->iotlb_iov),
+			     VHOST_ACCESS_RO);
+	if (ret < 0) {
+		vq_err(vq, "IOTLB translation failure: uaddr %p size 0x%llx\n",
+		       from, (unsigned long long)size);
+		goto out;
+	}
+	iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
+	ret = copy_from_iter(to, size, &f);
+	if (ret == size)
+		ret = 0;
 
 out:
 	return ret;
-- 
2.23.0

