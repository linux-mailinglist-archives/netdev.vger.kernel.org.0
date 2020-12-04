Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7583A2CF592
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 21:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388254AbgLDUVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 15:21:13 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:53368 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730480AbgLDUVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 15:21:12 -0500
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4KEHET027750;
        Fri, 4 Dec 2020 15:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=AHnb657ZVkd3rGKeu3xGSOupjj5816VejdnfGan8hNg=;
 b=Z8O/Px1CkKM+v1MyLm/Dn8zln6nYo5D8n+xY26BzkpDHQDcCPUtruNIzv0b4QUSz9OGK
 oshN5D/5jy34i6Nz/xBNrXfBrgUlWXfYWUm0jTVBm0wNzfXS0eZJhngYzgL1wDCruE1n
 FpJbOO0CJMCYz5UH4QI46Hsq4pM0FWApHuSJnMZBJURI2YryC2ox3bQg3SlV9ub4uvh2
 n/IqNsr0i4a1xt1Z/Oe8D99N+CycNkO5ZtL9yhSFimNpbrm/sJwzTvWN0GXbFgE8f2oU
 ZJgbzqviqQyK7/d1N1lQMWxCeiUF5FjioicY1HWOTSft2jc3cErjAyvP2EIxUS3cqiAV jA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 354fjthj5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 15:20:31 -0500
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4KJEbM143512;
        Fri, 4 Dec 2020 15:20:30 -0500
Received: from ausxipps310.us.dell.com (AUSXIPPS310.us.dell.com [143.166.148.211])
        by mx0a-00154901.pphosted.com with ESMTP id 357ua80kun-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 15:20:30 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,393,1599541200"; 
   d="scan'208";a="573039895"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com,
        Mario Limonciello <mario.limonciello@dell.com>
Subject: [PATCH v3 7/7] e1000e: Add another Dell TGL notebook system into S0ix heuristics
Date:   Fri,  4 Dec 2020 14:09:20 -0600
Message-Id: <20201204200920.133780-8-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201204200920.133780-1-mario.limonciello@dell.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_09:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012040115
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This Tiger Lake system is not yet released, but has been validated
on pre-release hardware.

This is being submitted separately from released hardware in case of
a regression between pre-release and release hardware so this commit
can be reverted alone.

Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/s0ix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000e/s0ix.c b/drivers/net/ethernet/intel/e1000e/s0ix.c
index cc04aeaa2292..3f2985fac67c 100644
--- a/drivers/net/ethernet/intel/e1000e/s0ix.c
+++ b/drivers/net/ethernet/intel/e1000e/s0ix.c
@@ -63,6 +63,7 @@ static bool e1000e_check_subsystem_allowlist(struct pci_dev *dev)
 		case 0x0a40: /* Notebook 0x0a40 */
 		case 0x0a41: /* Notebook 0x0a41 */
 		case 0x0a42: /* Notebook 0x0a42 */
+		case 0x0a22: /* Notebook 0x0a22 */
 		case 0x0a2e: /* Desktop  0x0a2e */
 		case 0x0a30: /* Desktop  0x0a30 */
 			return true;
-- 
2.25.1

