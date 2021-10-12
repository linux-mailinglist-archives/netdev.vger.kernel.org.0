Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2042A1C6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhJLKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:20:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232638AbhJLKUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:20:07 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C7fcAi013150;
        Tue, 12 Oct 2021 06:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=6nHJJT4ll93/O+UlFkR1fRDh7FEtLoUB7d1lftJJ7tA=;
 b=CJTN1jtBpuEsvE8mScNwipdOT6ih1BUj/TJtGgw0wjMrvZC6+c7dwU8eHkg7uz1w9mMT
 2+ZwFH/jdwLI1jpsFwsipeJZ3PeMh2Vkywq7dujta8tODYjOmfXF8HXoVZHIdvvqUnMz
 HniamG9A8q8JxCzLAWzqp/5FVVMf8wGGDkrV8bzpkT18MiH3pl3bmmLLost8eTpDyyBS
 M+IHubMbZ7aVRK8sPnE18V4SJiSOC0l2vXF7O1FowFO+zUmAhWHgw+GZbZUueHvY/4w2
 ACSa2fr/BwMqhuEFeEh2ePt98dMWGz5QLizYVW+O69RYupKv1KExoVmKgyko1qNKxVLH Cg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qk1p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:18:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CABNvo026005;
        Tue, 12 Oct 2021 10:18:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2q9xymg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:18:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CACJWS50069890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 10:12:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B5ABAE05A;
        Tue, 12 Oct 2021 10:17:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1920EAE057;
        Tue, 12 Oct 2021 10:17:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 10:17:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net-next 00/11] net/smc: introduce SMC-Rv2 support
Date:   Tue, 12 Oct 2021 12:17:32 +0200
Message-Id: <20211012101743.2282031-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TRm8sCwlcpgXgSOpIp3yWb6riGQpb7u3
X-Proofpoint-GUID: TRm8sCwlcpgXgSOpIp3yWb6riGQpb7u3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=806 priorityscore=1501 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
provides routable RoCE support for SMC-R, eliminating the current
same-subnet restriction, by exploiting the UDP encapsulation feature
of the RoCE adapter hardware.

Patch 1 ("net/smc: improved fix wait on already cleared link") is
already applied on netdevs net tree but its changes are needed for
this series on net-next. The patch is unchanged compared to the
version on the net tree.

Karsten Graul (11):
  net/smc: improved fix wait on already cleared link
  net/smc: save stack space and allocate smc_init_info
  net/smc: prepare for SMC-Rv2 connection
  net/smc: add SMC-Rv2 connection establishment
  net/smc: add listen processing for SMC-Rv2
  net/smc: add v2 format of CLC decline message
  net/smc: retrieve v2 gid from IB device
  net/smc: add v2 support to the work request layer
  net/smc: extend LLC layer for SMC-Rv2
  net/smc: add netlink support for SMC-Rv2
  net/smc: stop links when their GID is removed

 include/uapi/linux/smc.h |  17 +-
 net/smc/af_smc.c         | 431 +++++++++++++++++-------
 net/smc/smc.h            |  20 +-
 net/smc/smc_cdc.c        |   7 +-
 net/smc/smc_clc.c        | 147 +++++++--
 net/smc/smc_clc.h        |  55 +++-
 net/smc/smc_core.c       | 193 +++++++----
 net/smc/smc_core.h       |  50 ++-
 net/smc/smc_ib.c         | 160 ++++++++-
 net/smc/smc_ib.h         |  16 +-
 net/smc/smc_llc.c        | 684 ++++++++++++++++++++++++++++++---------
 net/smc/smc_llc.h        |  12 +-
 net/smc/smc_pnet.c       |  41 ++-
 net/smc/smc_tx.c         |  22 +-
 net/smc/smc_wr.c         | 237 ++++++++++++--
 net/smc/smc_wr.h         |  22 ++
 16 files changed, 1691 insertions(+), 423 deletions(-)

-- 
2.25.1

