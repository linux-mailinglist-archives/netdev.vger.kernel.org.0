Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483142AB1F6
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgKIH5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:57:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40858 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729562AbgKIH5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:57:21 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A97VhMH003841;
        Mon, 9 Nov 2020 02:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=1nzQsTosUYW0LSCaBAo4dhg+xFbfE92im80S8cPXiq4=;
 b=Cyv/Vwpmtr63DgpdbulWYlSSta3uP0OLv4dcEAJZnFxhso3XcME+LSex7YZFx9OC9lBm
 ioVNYY5MJl9qNSq3CuwKjSNLhdls73fLTrj6pAcogQFG98VJjQvo4Bot6fxoNq87TgKs
 dY5/QkAjZOidA+P/6gyldKbJpXp/wVuyjxpquNCMEeVcDN64w4j9hcMp70/4lzhk0Uth
 VItmc2C0PWq9JACTJsqsSahZA/AykGt0C3AIx5qZDQkT4zZxn2m6jbbaC0rR9tzYIFuv
 GsLhd808G+LiCtegr0KrlU4Mh605xMeQzGTcKsU8VxXYOXxOMUb4dwEowKH8FO4t48Ft AQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nrevwc0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 02:57:18 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A97raVf019392;
        Mon, 9 Nov 2020 07:57:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34njuh1sm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 07:57:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A97vDnI2228986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 07:57:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C4C6A4053;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57AAAA4051;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 07:57:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net v2 0/2] net/iucv: fixes 2020-11-09
Date:   Mon,  9 Nov 2020 08:57:04 +0100
Message-Id: <20201109075706.56573-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=513 phishscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

please apply the following patch series to netdev's net tree.

One fix in the shutdown path for af_iucv sockets. This is relevant for
stable as well.
Also sending along an update for the Maintainers file.

v1 -> v2: use the correct Fixes tag in patch 1 (Jakub)

Thanks,
Julian

Ursula Braun (2):
  net/af_iucv: fix null pointer dereference on shutdown
  MAINTAINERS: remove Ursula Braun as s390 network maintainer

 MAINTAINERS        | 3 ---
 net/iucv/af_iucv.c | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.17.1

