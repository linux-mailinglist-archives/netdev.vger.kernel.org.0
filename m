Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14632CC1FD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgLBQSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:18:49 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:55810 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730661AbgLBQSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:18:48 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2G2j6F020053;
        Wed, 2 Dec 2020 11:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=IyMWWnKQSyY4DTy0ZiGDx8F1IPhaoeAaUvuyrjPQq7I=;
 b=u7z7F0+G47B1rsYCXglam3xoeW7Xr2OpWnDAZInv1YxHgJK3s7csF+diO63impHQ3j+Q
 ed5KTiqH4zm/bLKpWt4Sr+kV9tBPugirByGRqsMkO/LxvTmWid8jXXz8BEaKNAlMru0o
 LhzOkN5T7LcKyuKGIQql0SrH1wNaGkzA0wNMyREE3EoAoFH7Rjv32Kz35AiyCu61Uj8w
 krH0cai/kWUCu6VgyHwV3UxNbvlqLX/TR3CuM7mnTqVdzYjpDw/EzLZvOr/lAfaiDq2N
 g0Bjp9h8/FJkCjTfJhkXkx/ZEPevPnqeMDNA9MKib4Sz9G0CJ5hTwhzs123fgg890M09 rg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 353jrq0n59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:18:07 -0500
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GDDaV114781;
        Wed, 2 Dec 2020 11:18:07 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 3565vm86w5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 11:18:07 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,387,1599541200"; 
   d="scan'208";a="1013735380"
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
        Mario Limonciello <mario.limonciello@dell.com>,
        Yijun Shen <yijun.shen@dell.com>
Subject: [PATCH v2 4/5] e1000e: Add more Dell CML systems into s0ix heuristics
Date:   Wed,  2 Dec 2020 10:17:47 -0600
Message-Id: <20201202161748.128938-5-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201202161748.128938-1-mario.limonciello@dell.com>
References: <20201202161748.128938-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These comet lake systems are not yet released, but have been validated
on pre-release hardware.

This is being submitted separately from released hardware in case of
a regression between pre-release and release hardware so this commit
can be reverted alone.

Tested-by: Yijun Shen <yijun.shen@dell.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/s0ix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/s0ix.c b/drivers/net/ethernet/intel/e1000e/s0ix.c
index 74043e80c32f..0dd2e2702ebb 100644
--- a/drivers/net/ethernet/intel/e1000e/s0ix.c
+++ b/drivers/net/ethernet/intel/e1000e/s0ix.c
@@ -60,6 +60,9 @@ static bool e1000e_check_subsystem_allowlist(struct pci_dev *dev)
 		case 0x09c2: /* Precision 3551 */
 		case 0x09c3: /* Precision 7550 */
 		case 0x09c4: /* Precision 7750 */
+		case 0x0a40: /* Notebook 0x0a40 */
+		case 0x0a41: /* Notebook 0x0a41 */
+		case 0x0a42: /* Notebook 0x0a42 */
 			return true;
 		}
 	}
-- 
2.25.1

