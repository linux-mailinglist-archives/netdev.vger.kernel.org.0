Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A3428E59C
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgJNRnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:43:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47242 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbgJNRnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:43:51 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EHahtc044812;
        Wed, 14 Oct 2020 13:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Gt4NZB0uESNmt2PO2RMIw8EK6Ao8nYuE17aP1g0ygSw=;
 b=UZF/r6Jc5dpTJJgmaOf+DXBi6elWFDHzs1cHlTCBWmGMGIBa2Obv7Rz6HDo0nYhZOQoq
 KUVkCPlCxpnrxmtxgCWhOt2OPZGvGilW9XRngkZA4CUHK+mgfKhEfZAQ8MmYclHFyYxH
 zlgF+584FbR9U4Mo6O9juvqW7HsmdNEUH9FMWJJqPpxxrdAJzOxh/3JmCLwhqHaeYsuK
 ZbwnlfRbVkpBNTzBWv5DKEI6vBDiu+Ca9Z+LYwDLOrbaJhWxfXZ7XMQU4TbLqRWafAAI
 gvqXiIYQ1uG676dLai3Wbr0WAMU7PvImBl+peCcquxu5uEbIiDQeXCyn2W9DwWPrvjTk pA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3465r08gch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 13:43:48 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09EHgWlp015797;
        Wed, 14 Oct 2020 17:43:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 34347h290w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 17:43:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09EHhiXq24904150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 17:43:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3212752050;
        Wed, 14 Oct 2020 17:43:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DCD395204F;
        Wed, 14 Oct 2020 17:43:43 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 0/3] net/smc: fixes 2020-10-14
Date:   Wed, 14 Oct 2020 19:43:26 +0200
Message-Id: <20201014174329.35791-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_09:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 adultscore=0
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=885
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

The first patch fixes a possible use-after-free of delayed llc events.
Patch 2 corrects the number of DMB buffer sizes. And patch 3 ensures
a correctly formatted return code when smc_ism_register_dmb() fails to
create a new DMB.

Karsten Graul (3):
  net/smc: fix use-after-free of delayed events
  net/smc: fix valid DMBE buffer sizes
  net/smc: fix invalid return code in smcd_new_buf_create()

 net/smc/smc_core.c |  5 +++--
 net/smc/smc_llc.c  | 13 +++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.17.1

