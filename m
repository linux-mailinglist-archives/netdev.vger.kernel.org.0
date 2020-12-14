Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4FD2DA0A3
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441097AbgLNTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:35:22 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:5438 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2441069AbgLNTew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:34:52 -0500
Received: from pps.filterd (m0170398.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJVNSX010332;
        Mon, 14 Dec 2020 14:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=8afjPOHWIh3Kk/CaJ6E3dMsZaOm0VHVAq7VOUtIhrYQ=;
 b=QUEFbDb4vekvJVGcKq6hzSIYIT1rQ0ReEee6L9ILFELl7kxyhGNfAwEocI8UKOMdkvyx
 qkyob22h/3Sec1WDXiXv44PoeT3Wuj0q6FXKO+F5xEQydY0gkRTCF99QKml5c+kPB4oP
 A6+wsEAM+g0KnPFunQLA/BcErKi6OOW8i9+v45S+yYd4MHgX0lA9H/VBM9+aKNQDlvMc
 GMY53Q/O1g8x1TEw4bbDp280XMu61ei7dH3ULEXgG4lpzapAXYMJG2+Rf6n39yUzqJdp
 Rgs54rGVLqmyX7F/ZH1h4oJtgVE1qMFqMkBjaI9RdPuQA9Ow8uyH5CCVPJEQScJb/y4D CQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 35csydxkw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:34:10 -0500
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJY6Q4182661;
        Mon, 14 Dec 2020 14:34:09 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 35e5emsm0j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 14:34:09 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,420,1599541200"; 
   d="scan'208";a="1020795054"
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
        Mario Limonciello <mario.limonciello@dell.com>
Subject: [PATCH v5 3/4] Revert "e1000e: disable s0ix entry and exit flows for ME systems"
Date:   Mon, 14 Dec 2020 13:29:34 -0600
Message-Id: <20201214192935.895174-4-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214192935.895174-1-mario.limonciello@dell.com>
References: <20201214192935.895174-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=750 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=924 suspectscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
disabled s0ix flows for systems that have various incarnations of the
i219-LM ethernet controller.  This changed caused power consumption regressions
on the following shipping Dell Comet Lake based laptops:
* Latitude 5310
* Latitude 5410
* Latitude 5410
* Latitude 5510
* Precision 3550
* Latitude 5411
* Latitude 5511
* Precision 3551
* Precision 7550
* Precision 7750

This commit was introduced because of some regressions on certain Thinkpad
laptops.  This comment was potentially caused by an earlier
commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case").
or it was possibly caused by a system not meeting platform architectural
requirements for low power consumption.  Other changes made in the driver
with extended timeouts are expected to make the driver more impervious to
platform firmware behavior.

Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 45 +---------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6588f5d4a2be..b9800ba2006c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -103,45 +103,6 @@ static const struct e1000_reg_info e1000_reg_info_tbl[] = {
 	{0, NULL}
 };
 
-struct e1000e_me_supported {
-	u16 device_id;		/* supported device ID */
-};
-
-static const struct e1000e_me_supported me_supported[] = {
-	{E1000_DEV_ID_PCH_LPT_I217_LM},
-	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
-	{E1000_DEV_ID_PCH_I218_LM2},
-	{E1000_DEV_ID_PCH_I218_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM},
-	{E1000_DEV_ID_PCH_SPT_I219_LM2},
-	{E1000_DEV_ID_PCH_LBG_I219_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM4},
-	{E1000_DEV_ID_PCH_SPT_I219_LM5},
-	{E1000_DEV_ID_PCH_CNP_I219_LM6},
-	{E1000_DEV_ID_PCH_CNP_I219_LM7},
-	{E1000_DEV_ID_PCH_ICP_I219_LM8},
-	{E1000_DEV_ID_PCH_ICP_I219_LM9},
-	{E1000_DEV_ID_PCH_CMP_I219_LM10},
-	{E1000_DEV_ID_PCH_CMP_I219_LM11},
-	{E1000_DEV_ID_PCH_CMP_I219_LM12},
-	{E1000_DEV_ID_PCH_TGP_I219_LM13},
-	{E1000_DEV_ID_PCH_TGP_I219_LM14},
-	{E1000_DEV_ID_PCH_TGP_I219_LM15},
-	{0}
-};
-
-static bool e1000e_check_me(u16 device_id)
-{
-	struct e1000e_me_supported *id;
-
-	for (id = (struct e1000e_me_supported *)me_supported;
-	     id->device_id; id++)
-		if (device_id == id->device_id)
-			return true;
-
-	return false;
-}
-
 /**
  * __ew32_prepare - prepare to write to MAC CSR register on certain parts
  * @hw: pointer to the HW structure
@@ -6974,8 +6935,7 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 		e1000e_pm_thaw(dev);
 	} else {
 		/* Introduce S0ix implementation */
-		if (hw->mac.type >= e1000_pch_cnp &&
-		    !e1000e_check_me(hw->adapter->pdev->device))
+		if (hw->mac.type >= e1000_pch_cnp)
 			e1000e_s0ix_entry_flow(adapter);
 	}
 
@@ -6991,8 +6951,7 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	int rc;
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
+	if (hw->mac.type >= e1000_pch_cnp)
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);
-- 
2.25.1

