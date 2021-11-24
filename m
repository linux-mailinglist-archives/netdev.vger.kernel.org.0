Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C877D45BDAB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243511AbhKXMj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:39:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344150AbhKXMg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 07:36:28 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOBeZHe026797;
        Wed, 24 Nov 2021 12:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=b7ko0yJdBI/F7xcJBCQ5FRhZjKIiCTaZ8AJ1sNLRJ4A=;
 b=KuJXaJ6Um79bWYh59rfBaTEzfoomqlnrxGUrzEfMC3VXHJu/FTNSh7QyNA63fzTC7zQ5
 p9A6FqEiR0TbEF7jV3IesRXCDSLodcLyd+bVoTzDwjU/sZSUzgGQdgq/SJ2jD9NWJNUu
 KecS5IHSjK9J/H3EzBTXqApPsyS55CCaoH2LyZytjKEXVlOFyRx+1R3bk17vrVQ0ofqA
 UYhWxG4GsIDw2sky1Ojm4dY7eKcZv/4QeHZuxbHIFNbjcorEL3h5iPQVcOIRjZV8DrWj
 0VQPyLyFm/Jh1I9G4T2twSD5V9t2onGngzkxZdMfFwcjCyK9CmwvpuezagddxUVbU/Qv og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3chgvfxh6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 12:33:12 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AOBp17k007746;
        Wed, 24 Nov 2021 12:33:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3chgvfxh5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 12:33:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AOCWdEf024989;
        Wed, 24 Nov 2021 12:33:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3cern9r238-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 12:33:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AOCX6OP20250926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 12:33:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AD5311C064;
        Wed, 24 Nov 2021 12:33:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0056F11C058;
        Wed, 24 Nov 2021 12:33:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Nov 2021 12:33:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Guo DaXing <guodaxing@huawei.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net 0/2] net/smc: fixes 2021-11-24
Date:   Wed, 24 Nov 2021 13:32:36 +0100
Message-Id: <20211124123238.471429-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ctwsrnTbdQS1-ydz51Uc4c-uPlTdQ_0U
X-Proofpoint-ORIG-GUID: rVjc1qtbcYWtUOAfI4LI0qaxQKoXuKT1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_04,2021-11-24_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=667 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 from DaXing fixes a possible loop in smc_listen().
Patch 2 prevents a NULL pointer dereferencing while iterating
over the lower network devices.

Guo DaXing (1):
  net/smc: Fix loop in smc_listen

Karsten Graul (1):
  net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()

 net/smc/af_smc.c   |  4 +++-
 net/smc/smc_core.c | 35 ++++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 18 deletions(-)

-- 
2.32.0

