Return-Path: <netdev+bounces-12143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 239B573667B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55E571C20B84
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A6AC126;
	Tue, 20 Jun 2023 08:39:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38639BE62
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:39:40 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC4BA2;
	Tue, 20 Jun 2023 01:39:39 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35K8MOnD012640;
	Tue, 20 Jun 2023 08:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4mH7jrvxyEUwm/LQv1jYIsgHBUPPOH87RzgFOklkSmA=;
 b=gIHg8Z50tNecEujI2NAgw4U/FNeNA4ePsnSij2LG5FcmEXBPbu3LPpUPWxtX/g/O+2tu
 aJG/prBwtz9l6IY0PLelWlsaPNXpdwlT5gcp++dNMc+3MYV3qt9SterAdIGfxIAZvdjh
 peB8nLbBiag58b711vrcjSV5EqCb5JpT1o+S0zfoEpG3Yl74FsJRevTOYJMEbr4cv1oj
 /ljRRv1ICv2iSKlqyruT5hNXSFkqgEmVbMF1/wbJwRclkbF7bi1Sh02x/tc8OIzk/2tu
 JumtbFyreeUuKUJ5QD6b8JcRdf6QM9QX8+B4K6vSjoFjjspRfebj6Ir6cPv2YgfNO9MK KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8hq0af3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:39:36 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35K8ZFjb014904;
	Tue, 20 Jun 2023 08:39:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8hq0ae1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:39:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35K77sIJ000954;
	Tue, 20 Jun 2023 08:34:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3r94f59fdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35K8YUYk393868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jun 2023 08:34:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 297AF20043;
	Tue, 20 Jun 2023 08:34:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14DE520040;
	Tue, 20 Jun 2023 08:34:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Jun 2023 08:34:30 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
	id 962C4E0652; Tue, 20 Jun 2023 10:34:29 +0200 (CEST)
From: Alexandra Winter <wintera@linux.ibm.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 0/4] s390/net: updates 2023-06-10
Date: Tue, 20 Jun 2023 10:34:07 +0200
Message-Id: <20230620083411.508797-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QAFYVYqDoGPgYYkxFowqHQaX08vYe1CC
X-Proofpoint-GUID: H59BMjpWLlttp47EwkN9MbN-g2W3sB62
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=786 lowpriorityscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306200076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Please apply the following patch series for s390's ctcm and lcs drivers
to netdev's net-next tree.

Just maintenance patches, no functional changes.

Thanks,
Alexandra

Thorsten Winkler (4):
  s390/lcs: Convert sysfs sprintf to sysfs_emit
  s390/lcs: Convert sprintf to scnprintf
  s390/ctcm: Convert sysfs sprintf to sysfs_emit
  s390/ctcm: Convert sprintf/snprintf to scnprintf

 drivers/s390/net/ctcm_dbug.c  |  2 +-
 drivers/s390/net/ctcm_main.c  |  6 ++---
 drivers/s390/net/ctcm_main.h  |  1 +
 drivers/s390/net/ctcm_mpc.c   | 18 ++++++++------
 drivers/s390/net/ctcm_sysfs.c | 46 +++++++++++++++++------------------
 drivers/s390/net/lcs.c        | 13 +++++-----
 drivers/s390/net/lcs.h        |  2 +-
 7 files changed, 46 insertions(+), 42 deletions(-)

-- 
2.39.2


