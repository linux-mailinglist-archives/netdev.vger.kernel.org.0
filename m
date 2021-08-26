Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CAF3F909F
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbhHZWU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:20:26 -0400
Received: from mail-bn8nam11on2101.outbound.protection.outlook.com ([40.107.236.101]:29968
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243700AbhHZWUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:20:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLLEKMpxZ/qUkj/C7ArAW5mjqLZhG5YtMpB7wY1M7M7jAIB/O3SzyQAxXAQ6iYMjyYj0cv6Z6yZPl4m8BVUWJpIyECWaFUy6wZmmMHmQVqTVvRJeZyXMAE9zLBdnYeeEmqAbsmcAT/vlBsXIjBkotTp0hatTZR8847gK4FlS8/NEmuqp8NGA3XBP647rylBRGu1zTvU/4NDe3gHJk1eEVufVkUv4ozja7OCITF7hfjWBF2h8MYaiUx0GDJViOFKku+VEaxM5i214prVIJALNjWDLsAAEUHRs+FI1KHeYODLpwAjQLAWpVXmU/KMWePtsg3ATMOKNxk/2xOMgfVEnQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8pdtuMVn0RfK9YlRKctXBoavkeZeGynmgG5NR53h5Y=;
 b=OolWCgImkBaH0JyxU7Bk5B9qjLsKwtMkRhqSaUqUBYDFHEqaUFaCX96lku51Jp0Lh5jktfSuSsQzxe1m9JNiq+q5sSjgq+YMOmX48e3ulQ0ETMmopvGFW5bsVcCsbi+8YJ792ZAbex4YT9ByA+BpIXxrJjTmElU+DNv32i/gyxC/1m8HSvTMKU044Wn9Ws+9xaC1usl9D4PFPn8MfPkFDIDv9X4pl7Wn83JenayBczjmVf2lZwuJ+xeCKj3Lut6SxjlRXGgf+OlRfaBuvVrB+1DpctHx4oEeeyhefOJJiyGVesqSWVcv4Mf9R5ax5zH/zLRsaHDuMikIZv81RESOdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 208.78.214.5) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=fpif-pwl1.w2k.jumptrading.com; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=jumptrading.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8pdtuMVn0RfK9YlRKctXBoavkeZeGynmgG5NR53h5Y=;
 b=R3D9kV4Z/Lpa0WqrxLNlNtWPYdlsFSKlKV9rHFQPGLD5i3nkUtGga0OGsKhAjqtsuiGtyqHFImEjEdviCZmCVWkuCmkELWUugUptBp7FEbu/JtPvOrnr1E4ABW2YWdYDkRgboGoNxaDzjp+qEz66mwgwphQE6PDgV5adgnRELfU=
Received: from BN9P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::14)
 by CH2PR14MB3756.namprd14.prod.outlook.com (2603:10b6:610:6d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 22:19:35 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::9) by BN9P220CA0009.outlook.office365.com
 (2603:10b6:408:13e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Thu, 26 Aug 2021 22:19:35 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 208.78.214.5)
 smtp.mailfrom=fpif-pwl1.w2k.jumptrading.com; vger.kernel.org; dkim=none
 (message not signed) header.d=none;vger.kernel.org; dmarc=fail action=oreject
 header.from=jumptrading.com;
Received-SPF: None (protection.outlook.com: fpif-pwl1.w2k.jumptrading.com does
 not designate permitted sender hosts)
Received: from mail.jumptrading.com (208.78.214.5) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 22:19:34 +0000
Received: from njwf-exnw1.w2k.jumptrading.com (7.9.212.134) by
 njwf-exvnw1.w2k.jumptrading.com (7.9.212.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 26 Aug 2021 18:19:33 -0400
Received: from njwf-esa1.w2k.jumptrading.com (7.9.212.139) by
 njwf-exnw1.w2k.jumptrading.com (7.9.212.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Thu, 26 Aug 2021 18:19:33 -0400
X-Internal-Message: True
Received: from fpif-pwl1.w2k.jumptrading.com ([7.145.13.98])
  by njwf-esa1.w2k.jumptrading.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2021 22:19:33 +0000
Received: by fpif-pwl1.w2k.jumptrading.com (Postfix, from userid 44223)
        id 98124802478; Thu, 26 Aug 2021 17:19:32 -0500 (CDT)
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     <intel-wired-lan@lists.osuosl.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>, PJ Waskiewicz <pjwaskiewicz@gmail.com>,
        PJ Waskiewicz <pwaskiewicz@jumptrading.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Date:   Thu, 26 Aug 2021 17:19:16 -0500
Message-ID: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04a5775a-e7fb-417b-c550-08d968df953c
X-MS-TrafficTypeDiagnostic: CH2PR14MB3756:
X-Microsoft-Antispam-PRVS: <CH2PR14MB375689463C2744D8518A32F2E1C79@CH2PR14MB3756.namprd14.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XwDJvimqtqsGyxKX7b85iTiGOz4C8npyQNSV1TD8ls32UkCl0wAqhbeYLOPz1BLSKIMNlMiXTGUBx6yhz/lLkxX6nzn3LQ7POKKZCArkfPOWx6sJL2vNxzA/PpQXE6s0s+LDnd18xcYlrACcejqa8vCrZKKI95hyD137sLb+6+3m0yUybqiV4ovCVzFWmjaEeqtjAAEL4GcZzJPiUjM6wtHr4PrCUkjOedXp7OCsscc4AkjaMIzZG5z64d4jjt8QQhPEF6Cp/B5KypTF0zeNlIdCdK6vd5ngTMCnj5CDimY/htBP6xKCwTs6lmDrQd1Gr2SSYirLLkt0XItiGs4AbDsAfryTNwxapkMGLdEejzXyvpQA/wg11dqLZ4rL5JLbDysYgEES9uj2JO9fhWXcZ04SR7wrPG34RV2wCyq+sNsuof3GxVxUGkj/NXO+71u58rRxFiYPMYgPHTreDZhFLjBBiVICuFVVCrfJnKueqc2cu8wHHRTbFSKGS0TXYyUeJd+ZfWSaPgwZpXanmVLwzDu2SHiunVsa+wF1tRRfCmtxozsitlBKKdKDJpAFULLXxub4vy6AcfeEOzUasTMwieS9sWOMjd+AL372slpoOMtDe0ypejigF7jCei+7sq+rnK4AZw5/P8UEHDLCAJJSUeCkm2UE+IipwH6D/fTrrw=
X-Forefront-Antispam-Report: CIP:208.78.214.5;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.jumptrading.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(498600001)(83380400001)(6266002)(356005)(45080400002)(2616005)(83170400001)(336012)(5660300002)(2906002)(81166007)(8676002)(35950700001)(8936002)(316002)(6666004)(110136005)(82740400003)(54906003)(4326008)(70586007)(26005)(1076003)(70206006)(82310400003)(107886003)(36756003)(426003)(47076005)(42186006);DIR:OUT;SFP:1102;
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:19:34.0079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a5775a-e7fb-417b-c550-08d968df953c
X-MS-Exchange-CrossTenant-Id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=11f2af73-8873-4240-85a3-063ce66fc61c;Ip=[208.78.214.5];Helo=[mail.jumptrading.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR14MB3756
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

Fixes: 41c445ff0f482 ("i40e: main driver core")
Signed-off-by: PJ Waskiewicz <pwaskiewicz@jumptrading.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_main.c
index 1d1f52756a93..b1cbd0eae83c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4862,7 +4862,8 @@ static void i40e_reset_interrupt_capability(struct i4=
0e_pf *pf)
  * @pf: board private structure
  *
  * We go through and clear interrupt specific resources and reset the stru=
cture
- * to pre-load conditions
+ * to pre-load conditions.  OS interrupt teardown must be done separately =
due
+ * to VSI vs PF instantiation, and different teardown path requirements.
  **/
 static void i40e_clear_interrupt_scheme(struct i40e_pf *pf)
 {
@@ -4877,7 +4878,6 @@ static void i40e_clear_interrupt_scheme(struct i40e_p=
f *pf)
        for (i =3D 0; i < pf->num_alloc_vsi; i++)
                if (pf->vsi[i])
                        i40e_vsi_free_q_vectors(pf->vsi[i]);
-       i40e_reset_interrupt_capability(pf);
 }

 /**
@@ -10523,6 +10523,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool r=
einit, bool lock_acquired)
                         */
                        free_irq(pf->pdev->irq, pf);
                        i40e_clear_interrupt_scheme(pf);
+                       i40e_reset_interrupt_capability(pf);
                        if (i40e_restore_interrupt_scheme(pf))
                                goto end_unlock;
                }
@@ -15908,6 +15909,7 @@ static void i40e_remove(struct pci_dev *pdev)
        /* Clear all dynamic memory lists of rings, q_vectors, and VSIs */
        rtnl_lock();
        i40e_clear_interrupt_scheme(pf);
+       i40e_reset_interrupt_capability(pf);
        for (i =3D 0; i < pf->num_alloc_vsi; i++) {
                if (pf->vsi[i]) {
                        if (!test_bit(__I40E_RECOVERY_MODE, pf->state))
@@ -16130,6 +16132,7 @@ static void i40e_shutdown(struct pci_dev *pdev)
         */
        rtnl_lock();
        i40e_clear_interrupt_scheme(pf);
+       i40e_reset_interrupt_capability(pf);
        rtnl_unlock();

        if (system_state =3D=3D SYSTEM_POWER_OFF) {
@@ -16182,6 +16185,7 @@ static int __maybe_unused i40e_suspend(struct devic=
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
