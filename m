Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A797440A95A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhINIge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:36:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14902 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230093AbhINIgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:36:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E8QdZl031399;
        Tue, 14 Sep 2021 04:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LzHExfBqLUQA7MfiuMVN/6nNsxSfjFfCy3n4/Fzv7Io=;
 b=B0MdQjXJmuc6cDIG3iM/XJo7T588g7K0qZijsEYHimMvE8M7HISt14BOCJhZVLoncond
 BvSJLypUWFI9Suo2VYrY+11RfrV15mLwVnEu4ed60WdybPhObkHurJ53oL10/C9UflFj
 RG0hheqfROaI2qdoYxG7Uf+O1K7hYHidgl0nm2KIxtMhhZgsZuewRunHs3XTzSP25+Xz
 iP+nnlDDG/umY0+ImTfzQ8ibLILQdPZ6To8oF8bvPbQjD4NkDg4QkZyeIsUyDXS1RwXx
 7dGLxqjmApoFL8/m31v49/xLIC4JFVnQAR4QsWwfXfm/qZIUYaB7MEgwauzt+leyWgxL gg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2nmkuwbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:35:13 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8WBXX023627;
        Tue, 14 Sep 2021 08:35:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3b0m39802t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:35:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8UbAD51184070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:30:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FCC5A406F;
        Tue, 14 Sep 2021 08:35:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA1B6A4040;
        Tue, 14 Sep 2021 08:35:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:35:07 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net-next 0/3] net/smc: add EID support
Date:   Tue, 14 Sep 2021 10:35:04 +0200
Message-Id: <20210914083507.511369-1-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DVieTovBX7G6kfB8cil4kQf23TyxFHQG
X-Proofpoint-ORIG-GUID: DVieTovBX7G6kfB8cil4kQf23TyxFHQG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=822 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for smc to netdev's net-next 
tree. The series introduce the so called Enterprise ID support for smc
protocol. Including the generic netlink based interface.

Thanks,

Guvenc Gulce

Karsten Graul (3):
  net/smc: add support for user defined EIDs
  net/smc: keep static copy of system EID
  net/smc: add generic netlink support for system EID

 include/uapi/linux/smc.h |  27 ++++
 net/smc/af_smc.c         |  34 ++--
 net/smc/smc.h            |   3 -
 net/smc/smc_clc.c        | 330 +++++++++++++++++++++++++++++++++++++--
 net/smc/smc_clc.h        |  19 ++-
 net/smc/smc_core.c       |  10 +-
 net/smc/smc_core.h       |   1 +
 net/smc/smc_ism.c        |  16 +-
 net/smc/smc_ism.h        |   2 +-
 net/smc/smc_netlink.c    |  47 +++++-
 net/smc/smc_netlink.h    |   2 +
 11 files changed, 443 insertions(+), 48 deletions(-)

-- 
2.25.1

