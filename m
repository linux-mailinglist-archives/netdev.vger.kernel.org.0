Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E93074FE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhA1LmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:42:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29006 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231448AbhA1Ll5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:41:57 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SBWiOL144906;
        Thu, 28 Jan 2021 06:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=OvASVC92KWI/KacwPx150G35Tb5Oxc83yhVbDSzJWm0=;
 b=SFp2U5pIdRo2u3BLQeULsjFGOqXj2HnY5odgf4KM1GxiwCZlAK+S5aRWnRKaAr4lqXHE
 jP+ggE1BnvIBqfIdW/TX4GVD4QgwHYRI1yDX6FM7kiyt3xcOVqavlqBiwRnUcAjB24ig
 35c0BPM0INc4lxybY/36zEWZF49LB6iZ2CypSw9QG7VqhG2TEtk4U9x5WdGpyM9yxwTg
 Q8aA9ITg5tdbmZQy5jzkqsyh9tlhizLFf9q69Ens1U4NoYziB0J4rbzoZhEWxZqe4XWS
 hgbL5ljdxm0EWi5yp0l1SzcHhapUmzQ/Em0/6i4pITjEn2w5GArDWrrUaWdDtc95k+04 ew== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bvg6g5hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:41:15 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBbE2L018084;
        Thu, 28 Jan 2021 11:41:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 368b2h4s6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:41:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBfAXs37028212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:41:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A8AE4C046;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 389364C040;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/5] net/iucv: updates 2021-01-28
Date:   Thu, 28 Jan 2021 12:41:03 +0100
Message-Id: <20210128114108.39409-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=638
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for iucv to netdev's net-next tree.

This reworks & simplifies the TX notification path in af_iucv, so that we
can send out SG skbs over TRANS_HIPER sockets. Also remove a noisy
WARN_ONCE() in the RX path.

Thanks,
Julian

Alexander Egorenkov (1):
  net/af_iucv: remove WARN_ONCE on malformed RX packets

Julian Wiedmann (4):
  net/af_iucv: don't lookup the socket on TX notification
  net/af_iucv: count packets in the xmit path
  net/af_iucv: don't track individual TX skbs for TRANS_HIPER sockets
  net/af_iucv: build SG skbs for TRANS_HIPER sockets

 drivers/s390/net/qeth_core_main.c |   6 +-
 include/net/iucv/af_iucv.h        |   3 +-
 net/iucv/af_iucv.c                | 122 ++++++++++++------------------
 3 files changed, 53 insertions(+), 78 deletions(-)

-- 
2.17.1

