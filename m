Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AA72C4BCF
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgKZAJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:09:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57782 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgKZAJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:09:17 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ02o3D127438;
        Wed, 25 Nov 2020 19:09:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Qf3gLvQ/R57sxawcKZK++b9HkZEdRMhhDbo9dSMTBqc=;
 b=SCRhkuwNwmP+ASUC3+56VGsRcaVl6DX2E9u1oPM3eVrDZZmFa8fj8/KI58KHMjdoPZNS
 1vQvReiMOdem0qt6RDNrLEgaYhYI4CJ2ZIygdfEB5RuEiBwH2fCbXwony17CPm6ApAFW
 TAGDiNUF9CdHbMI+iKEgqVuASC3C8pTEd6PkEBpz06vKFSCO6pEtwEVj91EU90TEBieY
 MDMjzY2DYNR4Hu1BJCnIQPQaNsqQjDW1QucnmaNFBxSnJtmvv2bKScyqv1wuNnW/Vx9X
 UlJyp5wrcOCiMA2waqerj85jbE4b9Vg2ZqE9bFi+34haKtdJXuWOgsb2VfpDvPon6iPb bw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351yjcjkpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 19:09:08 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ07XlJ001035;
        Thu, 26 Nov 2020 00:09:07 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 34xth9b559-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 00:09:07 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ097ai11141884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 00:09:07 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E0F5AC064;
        Thu, 26 Nov 2020 00:09:07 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA084AC05E;
        Thu, 26 Nov 2020 00:09:06 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 00:09:06 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net v3 0/9] ibmvnic: assorted bug fixes
Date:   Wed, 25 Nov 2020 18:04:23 -0600
Message-Id: <20201126000432.29897-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=3 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 mlxlogscore=714 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assorted fixes for ibmvnic originated from "[PATCH net 00/15] ibmvnic:
assorted bug fixes" sent by Lijun Pan.

v3 Changes as suggested by Jakub Kicinski:
- Add a space between variable declaration and code in patch 3/9. Checkpatch
  does not catch this.
- Unwrapped FIXES lines in patch 9/9.
- Removed all extra line between Fixes and Signed-off-by lines in all patches.

V2 Changes as suggested by Jakub Kicinski:
- Added "Fixes" to each patch.
- Remove "ibmvnic: process HMC disable command" from the series. Submitting it
  separately to net-next.
- Squash V1 "ibmvnic: remove free_all_rwi function" into
  ibmvnic: stop free_all_rwi on failed reset.


Dany Madden (7):
  ibmvnic: handle inconsistent login with reset
  ibmvnic: stop free_all_rwi on failed reset
  ibmvnic: avoid memset null scrq msgs
  ibmvnic: restore adapter state on failed reset
  ibmvnic: send_login should check for crq errors
  ibmvnic: no reset timeout for 5 seconds after reset
  ibmvnic: reduce wait for completion time

Sukadev Bhattiprolu (2):
  ibmvnic: delay next reset if hard reset fails
  ibmvnic: track pending login

 drivers/net/ethernet/ibm/ibmvnic.c | 168 ++++++++++++++++++-----------
 drivers/net/ethernet/ibm/ibmvnic.h |   3 +
 2 files changed, 106 insertions(+), 65 deletions(-)

-- 
2.26.2

