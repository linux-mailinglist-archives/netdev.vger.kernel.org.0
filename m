Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455292A9673
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 13:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgKFMuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 07:50:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727014AbgKFMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 07:50:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CWQVI168017;
        Fri, 6 Nov 2020 07:50:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=2POWXI1vf/6q5lCDJut9R4rx2D73x6omtTIZ6zT6+fQ=;
 b=esuugrn/16dn0rtVQ7Uw1QDIQRcY3tYGhkfM3ek0WweSdJJv8h9y7BeK2HS+vpmvb2Tw
 9gW6nN9PLXyvkKtdigsrbN9da6ucQJH0lFv93NsfauO6WOnrHOSeh+SNa5Vu+pSWH6VM
 N2rZqErdlmFAMIEO1YDq6uC6fgyCwgLpQkF5feIIv77GpzzPCCe0J1QlahmdghpMb3s9
 JtwNlFv4BndV3D6Qkq3aLqbS6bF0qmAYofA4ZicutOdaWiV/sKqFvzdTAHKl1XNRShfw
 786ArLohhXk4jjv1KuNG1OGf77s+T1vOXIoOB/61vziEESP+Tb6S4XhRGJ326ZWwOI8N 9g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34mhywfa6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 07:50:15 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CXCKq021954;
        Fri, 6 Nov 2020 12:50:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 34h0fcxgqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 12:50:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6CoAM358196260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 12:50:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA5CDA405C;
        Fri,  6 Nov 2020 12:50:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D973A4054;
        Fri,  6 Nov 2020 12:50:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 12:50:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/2] net/iucv: fixes 2020-11-06
Date:   Fri,  6 Nov 2020 13:50:06 +0100
Message-Id: <20201106125008.36478-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_04:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=510 suspectscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

please apply the following patch series to netdev's net tree.

One fix in the shutdown path for af_iucv sockets. This is relevant for
stable as well.
Also sending along an update for the Maintainers file.

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

