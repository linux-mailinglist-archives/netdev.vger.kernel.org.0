Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E24BC0F4
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 21:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbiBRUFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 15:05:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiBRUFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 15:05:23 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2046.outbound.protection.outlook.com [40.107.101.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FC62402D7
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:05:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaXelGzkPo1VdON3Oj6a62EqcjDf3n2LqZTZJ7+2M8CXt9fP0fHABnNjvlt3omNP09AEk1aPR5Nu87y/KT615B9b95hqSmw45iDJCbi/Y3TguV1GorXUwKQAQC13gtzLIr0UXd/W0XtwvIyKba6FYgIzTtnKzQ+HSMMQKwjue9EJmR2sUxL9SMrbsu3e9KpYZU4pUfE6T7ZtwEthAVtq9rXKnOnq4/oPqE865JG8SLa0bcE16S8Rpqc6/iCWqV/9URW0n60ymSQ7/oCc44r0hs3VaSYX2EpPemog739sz+Pl9LvoPbEo+UWRk/lamZXXXuKl0YfSI30dR48+mGgFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrjaxW3zF4ThODs76QeauTDxm/NLkoto1zfRIEmjDTM=;
 b=DUQ8g6Q2/l2atjjjM8u8SkybSbZt30tgP4rZekb/LkTF210UoopPRAh7jilrVx4cNycmL0kniBu86ZTnV9F/GB82I6vhAMSKxBhwz9rVsF4G9bAhwCG5qGymiFu1CZxKIE5dhCnGeX+wOmkc71mbWwJdekBQBKzSp6l863H/kIbU4iK5IHKUVIKvsTPqNnoLgSXtMpjhaJCEF86VOjO/4rxzSYFpME1ZSb3vXUEAxwhFFx76VdIsbvLzMzRkoEFqDK2SFo8iycemUw+E+0jr9OQhrD4tKGzdS0G4CItyyCxYb1hwArQIQXnb1kQ5AsHOIiIIyNcVkkzmDcLIaL76Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrjaxW3zF4ThODs76QeauTDxm/NLkoto1zfRIEmjDTM=;
 b=4JGmtogvczTvlQLXGj0lFDyzBE4EfmymHwXFznjyDIJDDpg6ucAUFN/R8bpyZm8aSaOad45AnpYhlKoI7YbJFI6wmf5sYPqY7nGaKO8Db2v/rZX+yBvS3jfRDDjqjoWvDqBPPsV1q9AWereH2d5LcsHygeU40Yr/M2JWFsr2rcM=
Received: from BN0PR04CA0046.namprd04.prod.outlook.com (2603:10b6:408:e8::21)
 by BYAPR12MB2789.namprd12.prod.outlook.com (2603:10b6:a03:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Fri, 18 Feb
 2022 20:05:01 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::c1) by BN0PR04CA0046.outlook.office365.com
 (2603:10b6:408:e8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Fri, 18 Feb 2022 20:05:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Fri, 18 Feb 2022 20:05:01 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 18 Feb
 2022 14:04:59 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Shyam-sundar S-k <Shyam-sundar.S-k@amd.com>,
        Anthony Pighin <anthony.pighin@nokia.com>,
        "Rasmus Villemoes" <linux@rasmusvillemoes.dk>
Subject: [PATCH net] net: amd-xgbe: Replace kasprintf() with snprintf() for debugfs name
Date:   Fri, 18 Feb 2022 14:04:46 -0600
Message-ID: <b21d35da33357b20ece39c7892f57084b94c017a.1645214686.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be2cef23-283b-4473-a9e1-08d9f319f221
X-MS-TrafficTypeDiagnostic: BYAPR12MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2789057E18BB878316DBB493EC379@BYAPR12MB2789.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFvqTkgmJohzZ0YILcOqecFB5beubltX0Rs9xTPhUIBiyE8Kg++cqxYIZioq0N3/uEQk5yM9NyykkXZ82RjlO0Cwzozm/IC5UffApOAB8P0z8mJBP+8acEHnf3rTdPQe1YRGcd1Ss4Ug1HE+XfuSbG6D2WEuWuJWl9IQvUj2yRKUy1pHvTnR2ZLMRLXR9nDlz+YHqgKjVlzkQTKVmBp9iCm6JLgYUF4JcyxCo+/rD/UYg5Q78U7phCA4YFBhkjWvBdQklmNmYldsyi43Ae7zhi5FjmzjpENWgWbS5opbJkj/Wzc6HGjC0c7thy15BWOQuSsoou5CpD+BUFTk7uB9OHFfMtzYxVlw7tPhXqHlXC2LmrAyrer5gBl9TdMcCB0Ll3AM3jzSd4UaTU3zEKZYFbXRQHmUtyg7u3PGuav/2H3ViinY/Kczh9Zn5WbvAguvMiQm4V3dIgHDWMUgAHb2HMgvbvrR07dtjpJkc/1kmOTBxLy/t3fy/u2GpvOoaECugvZIMUfeWr2VbjVGPSy11xqeVSbOGHUAxtkmwqJ2EMNxj8J4PHaJJnPjTRvd2FoKsXrycMg5C+Bji3q59zNwj9CZAjdU1AsEK94dd6bl0JIGI4FdQBtuKPGo44E9j0lAol1xr8EuFuArsHmIgumq7iK3QIPzeeYlCC2Spxu3/aan7e61tr1KJqfi4bvFLglLYVMM43OCrJBnQ86vfkT7Ww==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(5660300002)(508600001)(54906003)(8936002)(70586007)(82310400004)(356005)(70206006)(81166007)(4326008)(8676002)(316002)(6916009)(47076005)(26005)(336012)(186003)(40460700003)(16526019)(83380400001)(426003)(2616005)(7696005)(6666004)(36756003)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:05:01.1035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be2cef23-283b-4473-a9e1-08d9f319f221
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported that using kasprintf() produced a kernel warning as the
network interface name was being changed by udev rules at the same time
that the debugfs entry for the device was being created.

Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 2219 Comm: qemu-event Tainted: G           O      5.4.134 #1
Hardware name: <redacted>
Call Trace:
  dump_stack+0x50/0x63
  panic+0x102/0x2d2
  ? kvasprintf+0xb5/0xc0
  __warn.cold+0x20/0x20
  ? kvasprintf+0xb5/0xc0
  report_bug+0xcc/0x100
  do_error_trap+0xa3/0xc0
  ? kvasprintf+0xb5/0xc0
  do_invalid_op+0x37/0x40
  ? kvasprintf+0xb5/0xc0
  invalid_op+0x28/0x30
RIP: 0010:kvasprintf+0xb5/0xc0
Code: 28 00 00 00 75 28 48 83 c4 20 4c 89 e8 5d 41 5c 41 5d 41 5e 41 5f c3 4c 89 f1 89 c2 89 ee 48 c7 c7 d8 1e 0c a8 e8 b0 a5 3a 00 <0f> 0b eb c8 e8 92 cc cd ff 66 90 41 55 41 89 fd 41 54 49 89 d4 55
RSP: 0018:ffffa79f80e37c40 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff9b71b633c7c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffffa8986566 RDI: 00000000ffffffff
RBP: 000000000000000d R08: 0000004aafbb5f98 R09: 0000000000000046
R10: ffffffffa8986900 R11: 00000000a8986553 R12: ffffa79f80e37c90
R13: ffff9b71f0dcdba0 R14: ffffffffc03c0e1a R15: 000000000000000e
  kasprintf+0x4e/0x70
  ? timecounter_init+0x20/0x50
  xgbe_debugfs_init+0x39/0x200 [amd_xgbe]
  xgbe_config_netdev+0x390/0x450 [amd_xgbe]
  xgbe_pci_probe+0x374/0x620 [amd_xgbe]
  local_pci_probe+0x26/0x50
  pci_device_probe+0x107/0x1a0
  really_probe+0x147/0x3b0
  ? driver_allows_async_probing+0x50/0x50
  bus_for_each_drv+0x7e/0xc0
  __device_attach+0xd6/0x130
  bus_rescan_devices_helper+0x35/0x80
  drivers_probe_store+0x31/0x60
  kernfs_fop_write+0xce/0x1b0
  vfs_write+0xb6/0x1a0
  ksys_write+0x5f/0xe0
  do_syscall_64+0x55/0x1c0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fa72e73bd7f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 b9 7b f9 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2d 44 89 c7 48 89 44 24 08 e8 ec 7b f9 ff 48
RSP: 002b:00007fa6de7fba10 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007fa72e73bd7f
RDX: 000000000000000c RSI: 00007fa72803cf60 RDI: 000000000000001c
RBP: 00007fa72803cf60 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000001c
R13: 000000000000001c R14: 0000000000000000 R15: 00007fa72ef0a9e8
Kernel Offset: 0x26200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Replace the use of kasprintf() with snprintf() using a local buffer to
prevent this situation. It is still possible for the device name to be
changed while the debugfs entry is being created, but that will be
handled by xgbe_debugfs_rename() function.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Reported-by: Anthony Pighin <anthony.pighin@nokia.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---

Please queue to stable:
- As the warning is only produced at v4.5 and above, no need to go back
  further than that.
- This patch will generate conflicts prior to the v5.4 stable tree that
  should be easy to resolve. But, if not, I'll take care of it when I
  see the emails.
---
 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c | 25 ++++++++++----------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c b/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
index b0a6c96b6ef4..a6537f24dd79 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
@@ -121,6 +121,8 @@
 #include "xgbe.h"
 #include "xgbe-common.h"
 
+#define XGBE_DIR_PREFIX	"amd-xgbe-"
+
 static ssize_t xgbe_common_read(char __user *buffer, size_t count,
 				loff_t *ppos, unsigned int value)
 {
@@ -438,15 +440,17 @@ static const struct file_operations xi2c_reg_value_fops = {
 
 void xgbe_debugfs_init(struct xgbe_prv_data *pdata)
 {
-	char *buf;
+	char buf[sizeof(XGBE_DIR_PREFIX) + sizeof(pdata->netdev->name)];
+	int ret;
 
 	/* Set defaults */
 	pdata->debugfs_xgmac_reg = 0;
 	pdata->debugfs_xpcs_mmd = 1;
 	pdata->debugfs_xpcs_reg = 0;
 
-	buf = kasprintf(GFP_KERNEL, "amd-xgbe-%s", pdata->netdev->name);
-	if (!buf)
+	ret = snprintf(buf, sizeof(buf), "%s%s", XGBE_DIR_PREFIX,
+		       pdata->netdev->name);
+	if (ret >= sizeof(buf))
 		return;
 
 	pdata->xgbe_debugfs = debugfs_create_dir(buf, NULL);
@@ -493,8 +497,6 @@ void xgbe_debugfs_init(struct xgbe_prv_data *pdata)
 				    pdata->xgbe_debugfs,
 				    &pdata->debugfs_an_cdr_track_early);
 	}
-
-	kfree(buf);
 }
 
 void xgbe_debugfs_exit(struct xgbe_prv_data *pdata)
@@ -505,21 +507,20 @@ void xgbe_debugfs_exit(struct xgbe_prv_data *pdata)
 
 void xgbe_debugfs_rename(struct xgbe_prv_data *pdata)
 {
-	char *buf;
+	char buf[sizeof(XGBE_DIR_PREFIX) + sizeof(pdata->netdev->name)];
+	int ret;
 
 	if (!pdata->xgbe_debugfs)
 		return;
 
-	buf = kasprintf(GFP_KERNEL, "amd-xgbe-%s", pdata->netdev->name);
-	if (!buf)
+	ret = snprintf(buf, sizeof(buf), "%s%s", XGBE_DIR_PREFIX,
+		       pdata->netdev->name);
+	if (ret >= sizeof(buf))
 		return;
 
 	if (!strcmp(pdata->xgbe_debugfs->d_name.name, buf))
-		goto out;
+		return;
 
 	debugfs_rename(pdata->xgbe_debugfs->d_parent, pdata->xgbe_debugfs,
 		       pdata->xgbe_debugfs->d_parent, buf);
-
-out:
-	kfree(buf);
 }
-- 
2.34.1

