Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBF53F7CAA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbhHYTYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:24:48 -0400
Received: from mail-sn1anam02on2130.outbound.protection.outlook.com ([40.107.96.130]:21768
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236654AbhHYTYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 15:24:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1Xg/xm5hyZHfy6fCJKWRA6F6wqRByiGrj3zuq6LxGbZfT7B/orIcox3wf19pcl7uLUce2i9CLjC7Zy22x6weh9Oh4i7F9VVNS60eFM/QBUtuFenVv3MuZ6WCe18VB1L89QR9RnhiaxdGqP/+K6nQqY1/371Ben9++hIyGy0V1tD6Ay4qvKVVVR2c2g4XN4zgUJTGkjr/lI/jjz8nyBmqPTtWR9IanVbfMM5sZhaEIuhmRayCFB/d3S6Ik5vrcnPeja3/hmPUvXiPl35USotHe9+raEOczBy3MhvqhMn/yo/OjUGJHOELx5PLvMRZhXE/lh4D1FeLZNiAXTdRpdrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KcABsNMaE7XG96c2boNY47x9eCsyRGHMr2/pzff5qA=;
 b=KUhbEGk69BQSWGcDiQfK0Bo1pPxdhzff3i9PqQfom2Ru+/ivded/YC2Io4n5Uja14XBnPBA5UwZgmG1yW2+XpUMF7Gwa7jd7Rcip4Ko8ypNoOUNk75ypAmvn1wGCzUKZDaOqR+VfPwiNMGt0AeBAROzdrqidwO+nZKyEQLjxTd8ncChADbTUAlsJqE0w81oXpmixhrulmgl5HysZzPZGpwwH36GCydd+vrrKGYfEB/68721pZ99ud2WG3AtkYsKy0AJXRbg/NYKRk/0csn9sC6V0hwb1GM6EBe1DctxWl17BCl7rOW/1dpCiWURBGK4fhTz88clmIwVD49ZQ3YYztA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 208.78.214.5) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=fpif-pwl1.w2k.jumptrading.com; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=jumptrading.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KcABsNMaE7XG96c2boNY47x9eCsyRGHMr2/pzff5qA=;
 b=ks+WedvSxQHZMjSNV3vtkUdQCj2YDg+i9ak6pPlGjiXFuviHLLZqdFh3uq+Nc1myRnHjz/Vfx5pSQ13K5M1XtbvrIJE8XvXTNzpH8GAapTMN6AsCgFH3Ri/cc5nFoCrZWuUPobXBJnEAb1RX7H51Ufe9x3xeieNhyq4kvaH7tac=
Received: from MW4PR03CA0019.namprd03.prod.outlook.com (2603:10b6:303:8f::24)
 by BN8PR14MB3105.namprd14.prod.outlook.com (2603:10b6:408:d0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Wed, 25 Aug
 2021 19:23:56 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::97) by MW4PR03CA0019.outlook.office365.com
 (2603:10b6:303:8f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 25 Aug 2021 19:23:56 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 208.78.214.5)
 smtp.mailfrom=fpif-pwl1.w2k.jumptrading.com; vger.kernel.org; dkim=none
 (message not signed) header.d=none;vger.kernel.org; dmarc=fail action=oreject
 header.from=jumptrading.com;
Received-SPF: None (protection.outlook.com: fpif-pwl1.w2k.jumptrading.com does
 not designate permitted sender hosts)
Received: from mail.jumptrading.com (208.78.214.5) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 19:23:54 +0000
Received: from njwf-exnw1.w2k.jumptrading.com (7.9.212.134) by
 njwf-exvnw2.w2k.jumptrading.com (7.9.212.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 25 Aug 2021 15:23:53 -0400
Received: from fpif-esa1.w2k.jumptrading.com (7.145.12.210) by
 njwf-exnw1.w2k.jumptrading.com (7.9.212.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Wed, 25 Aug 2021 15:23:53 -0400
X-Internal-Message: True
Received: from fpif-pwl1.w2k.jumptrading.com ([7.145.13.98])
  by fpif-esa1.w2k.jumptrading.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2021 19:23:53 +0000
Received: by fpif-pwl1.w2k.jumptrading.com (Postfix, from userid 44223)
        id 515B080246F; Wed, 25 Aug 2021 14:23:53 -0500 (CDT)
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     PJ Waskiewicz <pjwaskiewicz@gmail.com>,
        PJ Waskiewicz <pwaskiewicz@jumptrading.com>
Subject: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Date:   Wed, 25 Aug 2021 14:23:21 -0500
Message-ID: <20210825192321.32784-1-pwaskiewicz@jumptrading.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f6965e4-300f-457f-e833-08d967fde119
X-MS-TrafficTypeDiagnostic: BN8PR14MB3105:
X-Microsoft-Antispam-PRVS: <BN8PR14MB3105E7381B2C4D580CCBDBEDE1C69@BN8PR14MB3105.namprd14.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHtsVifLoks8MJRS2Wm/qokEHSeDuh1bvYhOsu3a3/La39g+iDwsXPJgrM51QCqP3pwTmCs7b+P03te/aOlyqP2NJ/24Y2g2zZmFjt0Jhs82tW3n24twg07RSdyHFDP0nEolhkmRTA8PImwFSo0+Nie3x+cTvTgi9Hfd1lxoyGra9VXW2SiZYol6EeO8+v6HRMx6Vs6fr5whW9HOjubh0idcowTJXEyUXBZfcgC+MBA0hF3bGEbfo9zDa6XZUdZd62BbXCs2sYngd0tkLTgjRUsCOajpiYKLeeeKTDaJvYZyhCKvgwg/90WziiCeOQYYljQF3oYxyMMqdiir8oRuw4OdJNnxItzpdWziQ8kV1rkW3uLX26sbwVseMv9GlZa0A5UOmTni3d3YvB+XF6OTkLGPXqTUt6GTCl2j5Tq516DhkjXlevsMXSQHJ2Lvdqd840rNa8sKke4A0n+scpw1Evd/0qGEfisyQYfrcKUpxCjwAzzHKQnaEodsdfDdHr8d3MZmN5C62J/UR94bxNEdl1I0bsmSFFUw8N+yUeKv7ZdFJqLineOk1JxXYCahcV+197fovQvG6UxO8fI9BewKLKp4nCve4FqsYGigI8eXE+TR7O3Lae2NT6MJOs6wObX6oj7C0KrTGpfP9cSqbg5aAB+jlIUT3z3KD27ED0jSpoQ=
X-Forefront-Antispam-Report: CIP:208.78.214.5;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.jumptrading.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(5660300002)(1076003)(70206006)(316002)(82310400003)(6266002)(35950700001)(8936002)(70586007)(4326008)(42186006)(8676002)(54906003)(110136005)(81166007)(6666004)(47076005)(2906002)(82740400003)(26005)(498600001)(426003)(336012)(45080400002)(2616005)(83380400001)(356005)(36756003)(83170400001)(107886003);DIR:OUT;SFP:1102;
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 19:23:54.9074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6965e4-300f-457f-e833-08d967fde119
X-MS-Exchange-CrossTenant-Id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=11f2af73-8873-4240-85a3-063ce66fc61c;Ip=[208.78.214.5];Helo=[mail.jumptrading.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR14MB3105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes an error path condition when probe() fails due to the
default VSI not being available or online yet in the firmware. If
that happens, the previous teardown path would clear the interrupt
scheme, which also freed the IRQs with the OS. Then the error path
for the switch setup (pre-VSI) would attempt to free the OS IRQs
as well.

[   14.597121] i40e 0000:31:00.0: setup of MAIN VSI failed
[   14.712167] i40e 0000:31:00.0: setup_pf_switch failed: -11
[   14.755318] ------------[ cut here ]------------
[   14.766261] Trying to free already-free IRQ 266
[   14.777224] WARNING: CPU: 0 PID: 5 at kernel/irq/manage.c:1731 __free_ir=
q+0x9a/0x300
[   14.791341] Modules linked in: XXXXXX
[   14.825361] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted <kernel omitted>
[   14.840630] Hardware name: XXXXXX
[   14.854924] Workqueue: events work_for_cpu_fn
[   14.866482] RIP: 0010:__free_irq+0x9a/0x300
[   14.877638] Code: 08 75 0e e9 3c 02 00 00 4c 39 6b 08 74 59 48 89 da 48 =
8b 5a 18 48 85 db 75 ee 8b 74 24 04 48 c7 c7 58 a0 aa b4 e8 3f 2e f9 ff <0f=
> 0b 4c 89 f6 48 89 ef e8 f9 69 7b 00 49 8b 47 40 48 8b 80 80 00
[   14.910571] RSP: 0000:ff6a6ad7401dfb60 EFLAGS: 00010086
[   14.923265] RAX: 0000000000000000 RBX: ff3c97328eb56000 RCX: 00000000000=
00006
[   14.937853] RDX: 0000000000000007 RSI: 0000000000000092 RDI: ff3c97333ee=
16a00
[   14.952290] RBP: ff3c9731cff4caa4 R08: 00000000000006b8 R09: 0000000000a=
aaaaa
[   14.966781] R10: 0000000000000000 R11: ff6a6ad768aff020 R12: ff3c9731cff=
4cb80
[   14.981436] R13: ff3c97328eb56000 R14: 0000000000000246 R15: ff3c9731cff=
4ca00
[   14.996041] FS:  0000000000000000(0000) GS:ff3c97333ee00000(0000) knlGS:=
0000000000000000
[   15.011511] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.024493] CR2: 00007fb6ac002000 CR3: 00000004f8c0a001 CR4: 00000000007=
61ef0
[   15.039373] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   15.054426] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   15.068781] PKRU: 55555554
[   15.078902] Call Trace:
[   15.088421]  ? synchronize_irq+0x3a/0xa0
[   15.099556]  free_irq+0x2e/0x60
[   15.109863]  i40e_clear_interrupt_scheme+0x53/0x190 [i40e]
[   15.122718]  i40e_probe.part.108+0x134b/0x1a40 [i40e]
[   15.135343]  ? kmem_cache_alloc+0x158/0x1c0
[   15.146688]  ? acpi_ut_update_ref_count.part.1+0x8e/0x345
[   15.159217]  ? acpi_ut_update_object_reference+0x15e/0x1e2
[   15.171879]  ? strstr+0x21/0x70
[   15.181802]  ? irq_get_irq_data+0xa/0x20
[   15.193198]  ? mp_check_pin_attr+0x13/0xc0
[   15.203909]  ? irq_get_irq_data+0xa/0x20
[   15.214310]  ? mp_map_pin_to_irq+0xd3/0x2f0
[   15.225206]  ? acpi_register_gsi_ioapic+0x93/0x170
[   15.236351]  ? pci_conf1_read+0xa4/0x100
[   15.246586]  ? pci_bus_read_config_word+0x49/0x70
[   15.257608]  ? do_pci_enable_device+0xcc/0x100
[   15.268337]  local_pci_probe+0x41/0x90
[   15.279016]  work_for_cpu_fn+0x16/0x20
[   15.289545]  process_one_work+0x1a7/0x360
[   15.300214]  worker_thread+0x1cf/0x390
[   15.309980]  ? create_worker+0x1a0/0x1a0
[   15.319854]  kthread+0x112/0x130
[   15.328806]  ? kthread_flush_work_fn+0x10/0x10
[   15.338739]  ret_from_fork+0x1f/0x40
[   15.347622] ---[ end trace 5220551832349274 ]---

Break apart the clear and reset schemes so that clear no longer
calls i40_reset_interrupt_capability(), allowing that to be called
across error paths in probe().

Signed-off-by: PJ Waskiewicz <pwaskiewicz@jumptrading.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_main.c
index 2f20980dd9a5..4d60da44f832 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4865,7 +4865,8 @@ static void i40e_reset_interrupt_capability(struct i4=
0e_pf *pf)
  * @pf: board private structure
  *
  * We go through and clear interrupt specific resources and reset the stru=
cture
- * to pre-load conditions
+ * to pre-load conditions.  OS interrupt teardown must be done separately =
due
+ * to VSI vs. PF instantiation, and different teardown path requirements.
  **/
 static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
 {
@@ -4880,7 +4881,6 @@ static void i40e_clear_interrupt_scheme(struct i40e_p=
f *pf)
        for (i =3D 0; i < pf->num_alloc_vsi; i++)
                if (pf->vsi[i])
                        i40e_vsi_free_q_vectors(pf->vsi[i]);
-       i40e_reset_interrupt_capability(pf);
 }

 /**
@@ -10526,6 +10526,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool r=
einit, bool lock_acquired)
                         */
                        free_irq(pf->pdev->irq, pf);
                        i40e_clear_interrupt_scheme(pf);
+                       i40e_reset_interrupt_capability(pf);
                        if (i40e_restore_interrupt_scheme(pf))
                                goto end_unlock;
                }
@@ -15928,6 +15929,7 @@ static void i40e_remove(struct pci_dev *pdev)
        /* Clear all dynamic memory lists of rings, q_vectors, and VSIs */
        rtnl_lock();
        i40e_clear_interrupt_scheme(pf);
+       i40e_reset_interrupt_capability(pf);
        for (i =3D 0; i < pf->num_alloc_vsi; i++) {
                if (pf->vsi[i]) {
                        if (!test_bit(__I40E_RECOVERY_MODE, pf->state))
@@ -16150,6 +16152,7 @@ static void i40e_shutdown(struct pci_dev *pdev)
         */
        rtnl_lock();
        i40e_clear_interrupt_scheme(pf);
+       i40e_reset_interrupt_capability(pf);
        rtnl_unlock();

        if (system_state =3D=3D SYSTEM_POWER_OFF) {
@@ -16202,6 +16205,7 @@ static int __maybe_unused i40e_suspend(struct devic=
e *dev)
         * to CPU0.
         */
        i40e_clear_interrupt_scheme(pf);
+       i40e_reset_interrupt_capability(pf);

        rtnl_unlock();

--
2.27.0


________________________________

Note: This email is for the confidential use of the named addressee(s) only=
 and may contain proprietary, confidential, or privileged information and/o=
r personal data. If you are not the intended recipient, you are hereby noti=
fied that any review, dissemination, or copying of this email is strictly p=
rohibited, and requested to notify the sender immediately and destroy this =
email and any attachments. Email transmission cannot be guaranteed to be se=
cure or error-free. The Company, therefore, does not make any guarantees as=
 to the completeness or accuracy of this email or any attachments. This ema=
il is for informational purposes only and does not constitute a recommendat=
ion, offer, request, or solicitation of any kind to buy, sell, subscribe, r=
edeem, or perform any type of transaction of a financial product. Personal =
data, as defined by applicable data protection and privacy laws, contained =
in this email may be processed by the Company, and any of its affiliated or=
 related companies, for legal, compliance, and/or business-related purposes=
. You may have rights regarding your personal data; for information on exer=
cising these rights or the Company=E2=80=99s treatment of personal data, pl=
ease email datarequests@jumptrading.com.
