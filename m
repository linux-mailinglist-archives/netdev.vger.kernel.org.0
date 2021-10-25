Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096DA43932B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhJYKAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:00:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232728AbhJYJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9PxEb020793;
        Mon, 25 Oct 2021 09:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tEKvGqZLwkw0FDv++ZuR7idxRlDFssckUPzAifObMdg=;
 b=HHsT/rGtHObkN6zLKHQkjRf84gBJegArz2+5XxkkdmWhz38yoxmiqaxrf070bsCqP9qB
 wLM6+OTMwwQShofC98O8G+kMZoUiJy/4HZkTwt3CoduESm5g/xGBUs14ysOgiKO1ZnvX
 xIlkcLTgS7fsK4LoF59wzPuNJVES4+0znRb8qbxaFmfl3XwaDwoeJxjHIfcoNn8Sw63x
 sWiGFzAE8eFzk93TFZEXM+0EXIOfpqYmIGLPS1BucNy+bXOMYNwbjDXDE7sLpP6rsFeq
 qGsMWzbamcRAj7hPa7kuQxanCJFFxBf1o2T1kDN9TB1DxGmR2+sOG5jp/6Qv2av1Uq2s 3w== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bwsxs0m3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9hbFh014559;
        Mon, 25 Oct 2021 09:57:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3bv9njjvq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v69H5571226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8944911C04A;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46A6011C069;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:06 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/9] s390/qeth: add __printf format attribute to qeth_dbf_longtext
Date:   Mon, 25 Oct 2021 11:56:56 +0200
Message-Id: <20211025095658.3527635-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: puk8EA0tZJjBr83CMyT8uc-EfutB0ZDW
X-Proofpoint-GUID: puk8EA0tZJjBr83CMyT8uc-EfutB0ZDW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Allow the compiler to recognize and check format strings and parameters.

As reported with allmodconfig and W=1:

drivers/s390/net/qeth_core_main.c: In function ‘qeth_dbf_longtext’:
drivers/s390/net/qeth_core_main.c:6190:9: error: function ‘qeth_dbf_longtext’ might be a candidate for ‘gnu_printf’ format attribute [-Werror=suggest-attribute=format]
 6190 |         vsnprintf(dbf_txt_buf, sizeof(dbf_txt_buf), fmt, args);
      |         ^~~~~~~~~

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 09e1d2da3e48..20dca4c0384a 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1084,6 +1084,7 @@ int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq,
 			void __user *data, int cmd);
+__printf(3, 4)
 void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
-- 
2.25.1

