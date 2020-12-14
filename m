Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5F92D9B33
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438730AbgLNPfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:35:51 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:20746 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408218AbgLNPfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:35:39 -0500
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEFR4oR022012;
        Mon, 14 Dec 2020 10:34:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=02Jqo6Lln8up7BIA0wiOO6ZU/Rp+U8Jd3QdTEpjBscQ=;
 b=OAqe6bOaQUwH+MUHVs6BznGSXZ0uLC87e6LgQGGwW4x8xPAgmBpZWkaAfX4mgFEgrcUa
 htC5kppvTxNxbMNweH/PszfddWo9boM4CjkvV7v4Z3EakTgSBHYHWNYtfgZLvwYEYsbg
 zcBHHRkLNq3agytuhVwi1sFXByqx3BiqQxehE53k87WP51pCrhJpCmVFNEsHPXmkb4fn
 jQTfP2dL8TDoAdnNgfhHY7jxKtg1N1MkDZgluzTDa12s6ofPtRo8Yjq0mh9LqvoOu8eC
 V7d9zMW4y5aBrpaUXipcV4lr2wLtyyrjmtMV39cPsBpQZWVlH3Yr3y980V4PZynQlUjt OA== 
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0b-00154904.pphosted.com with ESMTP id 35csaanny0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 10:34:56 -0500
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEFXLYP003223;
        Mon, 14 Dec 2020 10:34:55 -0500
Received: from ausc60pc101.us.dell.com (ausc60pc101.us.dell.com [143.166.85.206])
        by mx0b-00154901.pphosted.com with ESMTP id 35e7q23aw7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 10:34:55 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,420,1599541200"; 
   d="scan'208";a="1641438810"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com, Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Aaron Ma <aaron.ma@canonical.com>
Subject: [PATCH 2/4] e1000e: bump up timeout to wait when ME un-configure ULP mode
Date:   Mon, 14 Dec 2020 09:34:48 -0600
Message-Id: <20201214153450.874339-3-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214153450.874339-1-mario.limonciello@dell.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_06:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140108
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per guidance from Intel ethernet architecture team, it may take
up to 1 second for unconfiguring ULP mode.

Suggested-by: Aaron Ma <aaron.ma@canonical.com>
Suggested-by: Sasha Netfin <sasha.neftin@intel.com>
Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
BugLink: https://bugs.launchpad.net/bugs/1865570
Link: https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
Link: https://lkml.org/lkml/2020/12/13/15
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 9aa6fad8ed47..4621d01e8a24 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1248,9 +1248,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 			ew32(H2ME, mac_reg);
 		}
 
-		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
+		/* Poll up to 1 second for ME to clear ULP_CFG_DONE. */
 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
-			if (i++ == 30) {
+			if (i++ == 100) {
 				ret_val = -E1000_ERR_PHY;
 				goto out;
 			}
-- 
2.25.1

