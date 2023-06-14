Return-Path: <netdev+bounces-10605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E674172F53B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C355281325
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C913EA31;
	Wed, 14 Jun 2023 06:56:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC89E7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:56:12 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02941713;
	Tue, 13 Jun 2023 23:56:08 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6lp57009654;
	Wed, 14 Jun 2023 06:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ylMSaPvGBcRhHzlgU8hZoT6qCRO1jiXjvCOtVCUH+Rg=;
 b=sIGMUADkHggODbdWfcmdlEUUumW1v5DOCVubiPKyLjRsheFj6EXjIa9RYYhsMgRajdvQ
 l9ExjpA3XWpZePPfzHXLGDxAB7JdnUrs8RY3TkLly/fcvNDjnF/ODtG1LAsy/7XSvyFY
 lgyxswsqR/Rl66MV0AFWkLvZr7i88g07e3sT8brDXW6V7obK1J+UGAkPlTZiDrhB7VzM
 ZuOP1o+EgxpXTIGWZoMWOjbIcTTLY7gjwDa/HLuvENAob0EQP4iej2ir3RUMrTiYXR/D
 nuCT/mQT/2/A4ftRIsqUv8W4G6f7WdhIhuQrDh2qGQbREVIrhKC6A9NXtas/EjsHkNFY 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r78kcr5j9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jun 2023 06:55:58 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35E6mGSo011106;
	Wed, 14 Jun 2023 06:55:58 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r78kcr5hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jun 2023 06:55:58 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5SoB7024515;
	Wed, 14 Jun 2023 06:55:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3r4gt4t0b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jun 2023 06:55:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35E6tqHR10486428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 06:55:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 144AC20043;
	Wed, 14 Jun 2023 06:55:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2E3D20065;
	Wed, 14 Jun 2023 06:55:49 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.93.95])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jun 2023 06:55:49 +0000 (GMT)
From: Jan Karcher <jaka@linux.ibm.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>, Jan Karcher <jaka@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH] MAINTAINERS: add reviewers for SMC Sockets
Date: Wed, 14 Jun 2023 08:54:56 +0200
Message-Id: <20230614065456.2724-1-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6XyPUNvR8f79_J7mtUT4FesRa5jH_2Uy
X-Proofpoint-ORIG-GUID: SbhgmFM0GCnOCoQH-vsISvFHaVvI06O0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_03,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 impostorscore=0
 mlxlogscore=887 bulkscore=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

adding three people from Alibaba as reviewers for SMC.
They are currently working on improving SMC on other architectures than
s390 and help with reviewing patches on top.

Thank you D. Wythe, Tony Lu and Wen Gu for your contributions and
collaboration and welcome on board as reviewers!

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f794002a192e..6992b7cc7095 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19140,6 +19140,9 @@ SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
 M:	Karsten Graul <kgraul@linux.ibm.com>
 M:	Wenjia Zhang <wenjia@linux.ibm.com>
 M:	Jan Karcher <jaka@linux.ibm.com>
+R:	D. Wythe <alibuda@linux.alibaba.com>
+R:	Tony Lu <tonylu@linux.alibaba.com>
+R:	Wen Gu <guwen@linux.alibaba.com>
 L:	linux-s390@vger.kernel.org
 S:	Supported
 F:	net/smc/
-- 
2.39.2


