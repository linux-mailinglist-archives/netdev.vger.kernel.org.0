Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A683456026
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhKRQJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:09:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232515AbhKRQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:09:33 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFIR2C007591;
        Thu, 18 Nov 2021 16:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4WTjq4MPRvogL0CE5HJ6/qzHywJkz23RxMILh9VBb18=;
 b=daIMB+3Of6A6lvWYT5GVOkPH++3t9sDeEO68sTeKfQWo3+Z2EdzUOmi8Fq+0ESSsOZqR
 qvF/Y4fps34/u+Hrp96qOQv0PBxIdveKGl0/1rmwbCFWbx6mSEid7fo8yE11bP3pEDq7
 RaNOKYd2u77licWSMfon0/mDG5JWZtkDJwM1PNSmlF64lG2aX3jgemmwxMD/O8SET82b
 KybHCHd/1lwS2sugh9mX9LYIc2XQCbsqHpA/2ODOJb9XOXlEBO5rWzqcpK5BKdEfd5sK
 XuOk2qi/b18Q0WLPyZ2HuacZnO5Pv1htRXPFfGvgx5z4DLz+hufm84Kx2yHY8JGkoNWp CQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdq2and29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIG3VYm023625;
        Thu, 18 Nov 2021 16:06:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50aqtks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIFxPAX26870160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:59:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EA2BAE064;
        Thu, 18 Nov 2021 16:06:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C4B8AE068;
        Thu, 18 Nov 2021 16:06:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 16:06:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/6] s390/ctcm: add __printf format attribute to ctcm_dbf_longtext
Date:   Thu, 18 Nov 2021 17:06:06 +0100
Message-Id: <20211118160607.2245947-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118160607.2245947-1-kgraul@linux.ibm.com>
References: <20211118160607.2245947-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ffECdtnR9s836trMIcmCadRFC3kp647x
X-Proofpoint-ORIG-GUID: ffECdtnR9s836trMIcmCadRFC3kp647x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Allow the compiler to recognize and check format strings and parameters.

As reported with allmodconfig and W=1:

drivers/s390/net/ctcm_dbug.c: In function ‘ctcm_dbf_longtext’:
drivers/s390/net/ctcm_dbug.c:73:9: error: function ‘ctcm_dbf_longtext’ might be a candidate for ‘gnu_printf’ format attribute [-Werror=suggest-attribute=format]
   73 |         vsnprintf(dbf_txt_buf, sizeof(dbf_txt_buf), fmt, args);
      |         ^~~~~~~~~

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ctcm_dbug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/net/ctcm_dbug.h b/drivers/s390/net/ctcm_dbug.h
index 675575ef162e..cce11daf3245 100644
--- a/drivers/s390/net/ctcm_dbug.h
+++ b/drivers/s390/net/ctcm_dbug.h
@@ -65,6 +65,7 @@ extern struct ctcm_dbf_info ctcm_dbf[CTCM_DBF_INFOS];
 
 int ctcm_register_dbf_views(void);
 void ctcm_unregister_dbf_views(void);
+__printf(3, 4)
 void ctcm_dbf_longtext(enum ctcm_dbf_names dbf_nix, int level, char *text, ...);
 
 static inline const char *strtail(const char *s, int n)
-- 
2.25.1

