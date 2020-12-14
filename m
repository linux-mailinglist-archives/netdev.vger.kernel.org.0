Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3C12DA0A8
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502187AbgLNTgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:36:39 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:10460 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2441071AbgLNTex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:34:53 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJWFf8026029;
        Mon, 14 Dec 2020 14:34:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=NR4be8499nTiqofcJ/u7O//eKb7BcXFXWk/GLtS08VM=;
 b=ptDAtV2JL7w8/tILNAvsL1cTN43N8JHaNE1+G6oI3Wzc8ot4+N/QalinGsYf7WzGlRcR
 jGizKKZ7m+lkd9gwV2yucRGk637D+zlC9ArJfc4Awbszr0ADxfHun1wULU1UsNj7eChc
 KupobuCC4ki4oEGeRF168mhto3UY5cLQ3XTtDOFn1OvAoqivDt7RZWIfoCySJD2s109N
 /UvwF8RKfrgri8ti6n4sC1rJMGyQTQArnEgDdo/lT+g0fvCn+5ofblCMEgKVHUhFQp5w
 rYwhlCOS69iFDxKYR6tlrePedJ2TkCOH6vHOIXyv+x6f+4ouLrq+SmY2reb3QZjYEuBr Yw== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 35ct2ppk0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:34:12 -0500
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJU0AX003633;
        Mon, 14 Dec 2020 14:34:12 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 35e6kd8p9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 14:34:11 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,420,1599541200"; 
   d="scan'208";a="1020795053"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com, Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Aaron Ma <aaron.ma@canonical.com>,
        Mark Pearson <markpearson@lenovo.com>
Subject: [PATCH v5 2/4] e1000e: bump up timeout to wait when ME un-configures ULP mode
Date:   Mon, 14 Dec 2020 13:29:33 -0600
Message-Id: <20201214192935.895174-3-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214192935.895174-1-mario.limonciello@dell.com>
References: <20201214192935.895174-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140129
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per guidance from Intel ethernet architecture team, it may take
up to 1 second for unconfiguring ULP mode.

However in practice this seems to be taking up to 2 seconds on
some Lenovo machines.  Detect scenarios that take more than 1 second
but less than 2.5 seconds and emit a warning on resume for those
scenarios.

Suggested-by: Aaron Ma <aaron.ma@canonical.com>
Suggested-by: Sasha Netfin <sasha.neftin@intel.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
CC: Mark Pearson <markpearson@lenovo.com>
Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
BugLink: https://bugs.launchpad.net/bugs/1865570
Link: https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
Link: https://lkml.org/lkml/2020/12/13/15
Link: https://lkml.org/lkml/2020/12/14/708
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 9aa6fad8ed47..fdf23d20c954 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1240,6 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 		return 0;
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+		struct e1000_adapter *adapter = hw->adapter;
+		bool firmware_bug = false;
+
 		if (force) {
 			/* Request ME un-configure ULP mode in the PHY */
 			mac_reg = er32(H2ME);
@@ -1248,16 +1251,23 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 			ew32(H2ME, mac_reg);
 		}
 
-		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
+		/* Poll up to 2.5 seconds for ME to clear ULP_CFG_DONE.
+		 * If this takes more than 1 second, show a warning indicating a firmware
+		 * bug */
 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
-			if (i++ == 30) {
+			if (i++ == 250) {
 				ret_val = -E1000_ERR_PHY;
 				goto out;
 			}
+			if (i > 100 && !firmware_bug)
+				firmware_bug = true;
 
 			usleep_range(10000, 11000);
 		}
-		e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
+		if (firmware_bug)
+			e_warn("ULP_CONFIG_DONE took %dmsec.  This is a firmware bug\n", i * 10);
+		else
+			e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
 
 		if (force) {
 			mac_reg = er32(H2ME);
-- 
2.25.1

