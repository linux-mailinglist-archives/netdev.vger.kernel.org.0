Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BDE50BEF2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiDVRsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiDVRrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:47:53 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2082d.outbound.protection.outlook.com [IPv6:2a01:111:f403:7011::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E6D2AD;
        Fri, 22 Apr 2022 10:44:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0iR1/aoyLcZPuFZv282SZUnGH1523Ft+3TQCN/kbPgg0VRfNSC1Gd/4nLYl+KErLzfGgFooVsewhMmSnIvCBvBlIwkKriyEn9wE2Fe9+SFEKDMcrIA8FFf3+oXR+YHnXdWatL7LlgAwGBkle17mDpET9JElh61CKzfQxpQFMMbCVe+8yYnB+fLyLBuSXC50S1f9ZNRax4djVzN6fe5WZ6pMhJ8cR+Gzx/9c233+9z/cYO81gYangHCg1GgqKsmiuxMjl6wigOpO4Vf+B+GNpxkul05EkIgHM4RInm9/7yEcH93+Q1DnX62MNMoyAYbYdzL2/IQZYX0nNPt+uU+9rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1KFyICb1KBU4A7oOn9tY7K4r2OyuSHdK/CPyRic/9Y=;
 b=lRmcjfFLBEGV13tjMvDhXUBGXLloOgWZhtRC/Ar4za7lrta8IuBJmyeyP5/oicXGarVytnzgAPN+X+xHuUwaD9fG5HqWwkxUXZUqWYVMLGcBVmNPPN6ZWWFcpy62aQRsIew3oPKJelFbry2RMdmfouGOctJdo4xCWBHMgbwmIhdDFRulr3rbj+JTzN/FJ93hL/LvWu4XVxjVE9UMkEpWENfs67t2bLJe50Pfl7VHLVhf1h9akhI2dKO9TesSuf1wOSaqmwAbkiZ5t/5O4gPR4IA1bsyKpbOlzNPT/2txzla1x1O5Mc7/9296pcHdFa5gcmw4V+MWWR3ZW7VZiT11mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1KFyICb1KBU4A7oOn9tY7K4r2OyuSHdK/CPyRic/9Y=;
 b=Ui9DLHmWjts9SEd9BFmONG+Kri45HVyGUxU735RciqGBFhRfdbPZH9ic60W7H2DmN4R58K9lh/0UpgvMV9WktHtbLJ8/+9IA4H6vf+WDiwu67zQPcW+9nsjLtZf+GKThFpeNuafVk3ois7CvIpTPkg7YcjKLj1pA59s23x+6Z3NMrRWcUXEaM8mBhKBFqB9GNTnuEWbimteWnbCLNPDirYfacexLqba/J6WmqWH6BTkUJP2olm6NkxCsQaXTXYBEOEHi7V/WXSWn5v50YSwf/eDV7mGNOTQQNc0VpRtiNcvNqirjO7LsDzM8Vcj+mAXCZnl0jGnqRUpEgZg36ZfqfA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN0PR01MB7952.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:44::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 17:39:20 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3d8a:448e:5dc6:510a]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3d8a:448e:5dc6:510a%6]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 17:39:20 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v7 RESEND] efi: Do not import certificates from UEFI Secure
 Boot for T2 Macs
Thread-Topic: [PATCH v7 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Index: AQHYVm/lf8oZJ0+bFUqnMcRigUBj+g==
Date:   Fri, 22 Apr 2022 17:39:19 +0000
Message-ID: <C704A64D-171F-4253-B2E3-42C3AFAF08A7@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
 <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
 <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
In-Reply-To: <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [j+6HjTJ2dHgpkG9sPJ7uzxmi9j7JMZcJ]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d81c4a98-0b5b-48a4-265e-08da2487080f
x-ms-traffictypediagnostic: PN0PR01MB7952:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSUbC4y/lKf+DBxcb2foKf7X13cvtM2yitj9KfFLvYZm9dcD4Vkc3DUS2doMiMDHmQYgJ+QfJEIx+lmB6tBdpjNidkTJ43xz/VDuvVT4HXamK2b94wSSzDtnwQeaIkeWLwcMuT+PIrj/40PJpkEKPobOg6AkuY7I0IfpN70v4MvGnCBbw9nbAIMaKHZAY3dAq6eKMA6qgR4qvBVq5UfgU6hwTXEtY5Qa78Enbz5i7mHPBNY1+B9WlAVgZkVTwQtXsjymlwA3CtzWtQrYHzdL4z0KlvP71Vbqiub4YC78AS5q7OeqA58FYGTT05lxZzG9tziVVcBZCE7gaWxsZtpAXysz6uHz76EtesWEBC6NtXVb6pCKQSxhfMg6qQzgSUQ62VquFbePW02lQxhDdq8czeFX2Zcaha2IQ+Vnx5SoeN5jqpqR0ArVxv2RHyFLgEM/Re/j018l6wkoGv/vcm4oikHItNRdHL+5hlXNV/AVf/MNhXB6j8FB83hgOL++PdgFWtCUJrFO0GOm4NAwuNotDLhiUpyWLqR/lq+BqqiJnn8A+TBBUbPVeHXwfE4LrfKnDok2B6b3lZsHpZuJC85FDw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ctHfdRcak71ZoYK5TnYtbzZjoz/eKCe5HDiYv0YWh92D8bu9REOljkNMJQsh?=
 =?us-ascii?Q?zF/OmZ8UQdx0rqmLppDgxkUPZ9TnIdu1nQuYwP36JNw9WOrmB0r2u60+yuoK?=
 =?us-ascii?Q?NGAx5p3zdrno6vx/+Q7jdZqmtQuIjZm4Ues3HFRYneYjR7MfIhs9pROqzYJi?=
 =?us-ascii?Q?nGURxrHX8PpjBlTlM/Ux1lRe1CgrR4qEzPMd64w20NkeOz5MxMTrB6ycw1Dx?=
 =?us-ascii?Q?i5gxZ/MuCm8PJGxw3Z1sWfUXXO3HzyfVMPrYCbF6J4dP5uSnX/OPQWezS01O?=
 =?us-ascii?Q?j+XrNeCMklA2/3UiQ3iATN0s4tMbf3hPADb3mm4nPuRHeytGh6GGsUG7UELB?=
 =?us-ascii?Q?lJDfhorDBg+ZRg4ZHrXhktaYLxDNngXuBMXxkeuSw2Vpz/n59KNibXuehklb?=
 =?us-ascii?Q?tF6ChBm3COqvNeb2tA53Qga8zte7GChXVu6tzSX9RpPJP+FRaRplb6T3R4dM?=
 =?us-ascii?Q?PnouABbQ+E1Tnj+6uKuWCLCOTeEIiejOQLKJXf5eao2a5/AkrGTRms514ZBJ?=
 =?us-ascii?Q?yljvSAOhBr5FkSUJw3cvfOqLaRu4568XsRRqEIGlj++gAIulajd3ZmbAbz05?=
 =?us-ascii?Q?WV0+Wdg9Iksrq7QbeuLsFJMOt9qoaD34lvIHLzFNKSEzu+5Y+H7MLOgjXgTO?=
 =?us-ascii?Q?WEXYkLmDWQxowJYqAmtI7YnCoQDKXGLJmNluJCC/Sc8MUvz4maWfnqYzotCp?=
 =?us-ascii?Q?BCNSnOkJzXtn8cUJxRIP/zHydn0TrorsohDVd4xqAbcFzc8op9Z0+QKO3k96?=
 =?us-ascii?Q?hGDK8yWRSbxmp4Y+Pz/yrO4x1+6YTECnLWW/IScL13G4qbZV8dRhtd6+3nmI?=
 =?us-ascii?Q?uuy7BygQuxTRPSYC4Qvt43gcN2C+T/uQ7zGQ1FgVE5KItUTpyyTe46xJaiPj?=
 =?us-ascii?Q?QQFZAHEG7HQluFP4oFFR9K0MXeXmPEjtk1mvzKMEsoCbMO9e0xb2X9JK1ob5?=
 =?us-ascii?Q?OBKmT9utxP59ZUTgNgc7U5Pe4FjQDybjhegqLDP9ozy3TQuJtoflFAfirzxs?=
 =?us-ascii?Q?WvMtrg3grg4lhwcBB7wHOL5Xt8hKhpcDLKnnW14DxUEEKQQjAMClB6Es0nkY?=
 =?us-ascii?Q?QBP/r9uRaHN8LzqOnBVk4sB2UHXhwdEF/g+dOVE9Ds/SZ+uSi9ALU9jDAQrr?=
 =?us-ascii?Q?SdDSjEaZFBNkq97l9DG2QaoWS9DDXL/WMlUBSPkwuhc/RPsYGO1k8F7BgH+3?=
 =?us-ascii?Q?FEFjmkmrWUJJNkDFsZ5j0khGU3Vidq4qoNCuTwQ6UVtbV4X+1vu8ZBs8WNJY?=
 =?us-ascii?Q?pe3yCxIrgp8t6qzf2kwfyLxL5l7QuwkSxvnuhpimy8w1olrmaVUk7TcEJDVK?=
 =?us-ascii?Q?B6jSGu/ZzDYlXWKJnd4lbJMzRiXJiteT2nID1XN2drBSOAqZxfj2y7lq3PKY?=
 =?us-ascii?Q?VQlQ8XfhYO/myMdsW0BAnhQ9KXwxPzfCuSL6XSZAS8LqtWMgMqKO7HLOa6LN?=
 =?us-ascii?Q?fZ9fQONYzJE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FEBAE4A5EAE3BA4F9CB2F31FE1B78CC2@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d81c4a98-0b5b-48a4-265e-08da2487080f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 17:39:20.0586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0PR01MB7952
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

On Apple T2 Macs, when Linux attempts to read the db and dbx efi variables
at early boot to load UEFI Secure Boot certificates, a page fault occurs
in Apple firmware code and EFI runtime services are disabled with the
following logs:

[Firmware Bug]: Page fault caused by firmware at PA: 0xffffb1edc0068000
WARNING: CPU: 3 PID: 104 at arch/x86/platform/efi/quirks.c:735 efi_crash_gr=
acefully_on_page_fault+0x50/0xf0
(Removed some logs from here)
Call Trace:
 <TASK>
 page_fault_oops+0x4f/0x2c0
 ? search_bpf_extables+0x6b/0x80
 ? search_module_extables+0x50/0x80
 ? search_exception_tables+0x5b/0x60
 kernelmode_fixup_or_oops+0x9e/0x110
 __bad_area_nosemaphore+0x155/0x190
 bad_area_nosemaphore+0x16/0x20
 do_kern_addr_fault+0x8c/0xa0
 exc_page_fault+0xd8/0x180
 asm_exc_page_fault+0x1e/0x30
(Removed some logs from here)
 ? __efi_call+0x28/0x30
 ? switch_mm+0x20/0x30
 ? efi_call_rts+0x19a/0x8e0
 ? process_one_work+0x222/0x3f0
 ? worker_thread+0x4a/0x3d0
 ? kthread+0x17a/0x1a0
 ? process_one_work+0x3f0/0x3f0
 ? set_kthread_struct+0x40/0x40
 ? ret_from_fork+0x22/0x30
 </TASK>
---[ end trace 1f82023595a5927f ]---
efi: Froze efi_rts_wq and disabled EFI Runtime Services
integrity: Couldn't get size: 0x8000000000000015
integrity: MODSIGN: Couldn't get UEFI db list
efi: EFI Runtime Services are disabled!
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get UEFI dbx list
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get mokx list
integrity: Couldn't get size: 0x80000000

So we avoid reading these UEFI variables and thus prevent the crash.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
v2 :- Reduce code size of the table.
v3 :- Close the brackets which were left open by mistake.
v4 :- Fix comment style issues, remove blank spaces and limit use of dmi_fi=
rst_match()
v4 RESEND :- Add stable to cc
v5 :- Rewrite the description
v6 :- Make description more clear
v7 :- Minor changes and add reviewed by
 .../platform_certs/keyring_handler.h          |  8 +++++
 security/integrity/platform_certs/load_uefi.c | 33 +++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/security/integrity/platform_certs/keyring_handler.h b/security=
/integrity/platform_certs/keyring_handler.h
index 284558f30..212d894a8 100644
--- a/security/integrity/platform_certs/keyring_handler.h
+++ b/security/integrity/platform_certs/keyring_handler.h
@@ -35,3 +35,11 @@ efi_element_handler_t get_handler_for_mok(const efi_guid=
_t *sig_type);
 efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_type);
=20
 #endif
+
+#ifndef UEFI_QUIRK_SKIP_CERT
+#define UEFI_QUIRK_SKIP_CERT(vendor, product) \
+		 .matches =3D { \
+			DMI_MATCH(DMI_BOARD_VENDOR, vendor), \
+			DMI_MATCH(DMI_PRODUCT_NAME, product), \
+		},
+#endif
diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integ=
rity/platform_certs/load_uefi.c
index 5f45c3c07..1a7e7d597 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/cred.h>
+#include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/efi.h>
 #include <linux/slab.h>
@@ -12,6 +13,31 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
=20
+/*
+ * On T2 Macs reading the db and dbx efi variables to load UEFI Secure Boo=
t
+ * certificates causes occurrence of a page fault in Apple's firmware and
+ * a crash disabling EFI runtime services. The following quirk skips readi=
ng
+ * these variables.
+ */
+static const struct dmi_system_id uefi_skip_cert[] =3D {
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ }
+};
+
 /*
  * Look to see if a UEFI variable called MokIgnoreDB exists and return tru=
e if
  * it does.
@@ -138,6 +164,13 @@ static int __init load_uefi_certs(void)
 	unsigned long dbsize =3D 0, dbxsize =3D 0, mokxsize =3D 0;
 	efi_status_t status;
 	int rc =3D 0;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id) {
+		pr_err("Reading UEFI Secure Boot Certs is not supported on T2 Macs.\n");
+		return false;
+	}
=20
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;
--=20
2.25.1


