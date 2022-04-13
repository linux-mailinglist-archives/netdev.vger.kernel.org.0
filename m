Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27284FF87D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbiDMOGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbiDMOGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:06:47 -0400
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0165.outbound.protection.outlook.com [104.47.100.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289976252;
        Wed, 13 Apr 2022 07:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIvilzrEY241uDTNww0fc9FFvbFhM7mvD5zqb7LSXcppwHIhRr9cj485KeA4r9VRYzt4n2WEfVGehs8ExnZHfFNThpGmQeP781r3kFB+8TFo/VgWK+R5anboy5YYEArbWsdJ8jBYBvA1189cThK0TTiwju70wXiNLNaTDGOHG0ozDS7Hu2U37dr840HMlT00zo1MlUUjnVy18ZeLHPPrf5/T9039XeJaczfbLpE5sAgFzvMs2pc6lqP0+i7TepO47Lc08cTS54+qqTjO4UfnKBWwHiyBhYEc2ElwTrKZFJd3Uz8WnqMJGi4njKf+caCc4tq/EMRe9heeezfdw1EoJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApuCERXhLlrcIvk22sjEpQJAbjQii2yMS3hHqTWR9+Y=;
 b=bnp5dxIrtEc1DLnfFLJLJ29UWoTbJuxlM7TGe1dwYIV65Q2mm02Doe3t8afvwk9LpmvjGG6puSBFoW7uWZzgFqKMPlAUtckYYGBCbxcfVRTjNBOv4ywAP+LwfMCeU3y4tjxDM4yNUtu1HWiQMR9rNZIs2CK45MbkOCiAE6t2pCacqB0vT1U2jWEt37TtW0y9drHikYwLSJZuGUGIsUTh8u99ZDa4n6DRWwoQ9IdHqGADm5/zDMt/LIcOg7Pqf3ogRfWm4USJFGAW3YKQJQAPsOF/dZaY8yIQC5ro6CPIlc0W6kJTqGnnOQX72C4bymXRgrao3n604oBmp/ArPcv8IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApuCERXhLlrcIvk22sjEpQJAbjQii2yMS3hHqTWR9+Y=;
 b=oX4Cck2CTKt4dM6q67soLMJDIWInx15F3+tnz1IGFe+a0Hcw+MeO/33e+SXbxH3u3fSLp/MEIrgogTMKNYCpAjYgOHMBhdZHwJB88768HCFBTQAH3oB6yThchKaKi/0xr4OqtgL2uU2O4INe30n8czB+yr6gBFAZdLbZMuJNcJd7Qx4QgaXwA0E/B44o1TvwX7PmYizW6+xFdX4L41sijSCcUypCW8L/zIRNEIE4Ez5ROc+bguFH2QpQzRDVvgOLn17ih86SUNcP8BmJRJwXqfGL8/U6sNtIMtu6DCrh2ukam2not2eH8jrPS++O9uO2/Abxl3LsHptLjEzsmU6ltg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB2045.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 14:04:18 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 14:04:18 +0000
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
Subject: [PATCH v5] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH v5] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYTz9dLlSTMdRHnkmSfUQV8JWzhA==
Date:   Wed, 13 Apr 2022 14:04:18 +0000
Message-ID: <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
In-Reply-To: <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [ySZnu0NEl5DFr7K8br+1m4eD1pKN9JE3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ab0b5f7-e5a8-48b3-3495-08da1d568054
x-ms-traffictypediagnostic: PN1PR0101MB2045:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P6cpX/uQrPD+SM9yMe6z4XVHNxSOlfC0vMPcwcOc9ZG616cUy+tZS1dDHfXYiUisIbx1jjdADznU5580HLQ3MgbSkwr1EDKv4VOC1dGeFg6fgZgQ/tmJSQWWaFZTSY65dCHqCPVgCMxHABUQHf2nEP0kEPlHiitovz7qgrZ5VBqKX8dnz0UdORupFPd8/piplZkG0hUR34sybUqU/J6hRGBm1Ivcgu9RiwfBGqNqzVqRJ6VmFJUxH04eObhn0yKJi453C91GJlR7MVXunyxkSpSGRJrwnw7eh0goSlb+m8oiDX6anAMMaX9tEOczJuUruMnorlyJGGxrchfNfzpDbuDwykjZQqEhs3nQXZzuZYKo15dP8FwK1ZdfLLTuaxKxSj2K/YTPyhcw6VqQm/6NI74vOYCDBEOb+qMmLRLsAOv803dxpyWhbR/3qtx/siKfK84uHT14vfivpYsBfxnImq7t5k1K8JpkNIEnKsM3surP+4PIZTfwz88JigvlHmCz6tej3ovQGXf5O98mZeUVoDzze6k4/wnnCeKxAOqzy/CSidfOsL1NQnKc9LSBxtXvD2zbzm4DKi/cput6SU0QGg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9HzOYunob4of6GwZGxECn6PCccgAflYLk2RdmSVmY/q+Bmu8ZcndOq/IRYAI?=
 =?us-ascii?Q?X2WQoM0JOixN7DZdCcpbLYq0aVRdOFp28+A/MdjVH2bqeQ0O5gzruCYx4hpC?=
 =?us-ascii?Q?Jbv58joYgiAtpsUOAJXqrGDsKz42vpm+twr/pINx/OYp2CPTReqRk1jr8+5j?=
 =?us-ascii?Q?r83irDaJcSsQ+LbuVa5RXfpbdUnHcTOVWemBcc8hWhjxVHsu2peg04pbDMpi?=
 =?us-ascii?Q?B3fLn7mNDVg11c7e5b6Eh/BVAeZ/tg/46jATTsOdd8iNdDqasVYg//mECEim?=
 =?us-ascii?Q?n4LHpalQdptqPjzmAkX2BoxcyqSO49AQH8nKYkiPSPXJjx+uLVFX2mGIt+rg?=
 =?us-ascii?Q?QZcpwwLlTScSCw8EuBeArHcCzenstIf9o5JfFKfaLBw1gKhakdjHM4CJMGMo?=
 =?us-ascii?Q?JbkGjiHgx0v5c/APnmIDKo+opawRC2DGu0CtYhVCdqjO4A/H6hzVETVF8azv?=
 =?us-ascii?Q?JVYIqGYx1r9mYFFH+oCOFb3IQp4+STpsbiWatWlIWopmpfzYBsRhIrtYx2Tb?=
 =?us-ascii?Q?hCen5sAytKHeDy59vbkPhB9CODQ9wnRt8+XhET7UCtlydtIRsZVlohkKZ0ja?=
 =?us-ascii?Q?swxr++M6hN8yEbiDIwWR8GwAWmk/l7Jf9PiPhI0OE+iDGIZSjhfp2AwTiwET?=
 =?us-ascii?Q?KOaMyDs6FzLME5KWEhywnMCGRHCn+DHnnWhWvVu7V36hf1ovEaGs7VYRHkVc?=
 =?us-ascii?Q?ZChOJ2rK6dZikWl3kprL8N/hY2EhKSyuvHlYejGDl19l+6VBCYOk6VckE9jr?=
 =?us-ascii?Q?GSLPqNuXNaGREg1R4yyvAGD8KNGc/N1f7W3YSD1ReOB+MT0VOQE+9E0vi+hU?=
 =?us-ascii?Q?fsPYnIKbI2NLsBm/iUyuAq963jmSbomDKw/q6jpup6suzpuESfaOwpwvWGJI?=
 =?us-ascii?Q?KtbMHn8i7TET9ujroi5FDGXczCEZVTDUi9qRGpLBQvbVWElj7q3d6ad55+1p?=
 =?us-ascii?Q?HFF2XhTNj6Vc0xZ2R/0QHBfbhp/jbyVHTPbjzXTJAAkDJp7Q7tuqI5VY7Bzw?=
 =?us-ascii?Q?6/lI7pP/Fk1VTHqAyffa9d2sseKF628wPDnHSTUQWol9qqEgCN4ggRu7nDYV?=
 =?us-ascii?Q?rl2cvyjvrnydD97RxB+LkA109HNOjQVC/M6+K2DNfN4MOI0342xPDMrrgvxC?=
 =?us-ascii?Q?nolpxdHAymOnq4i0od3ND0sTTzprGEVTNLy7RTBWG1vd89OE3bRb1ENPCqj1?=
 =?us-ascii?Q?hMuIP+WLJiNf7O4yYEVGuO5BGTIVnRJOfHw1nYklX1aUtWPZFlM/1+pExd8H?=
 =?us-ascii?Q?IK+3h2frRK8Ra6Ued5Juyd3xByD8fz4XsIa2cWJBRxcUJVlZkpGyhX5kL6sO?=
 =?us-ascii?Q?ydDEPHeoGjUSNsdicgE7pH9F87sJsfE2QA5fLsJxrd5u7Wor2HxcPS5v46S8?=
 =?us-ascii?Q?gyVwajoJf9w8geN+rShGiKPk4GLb7CR9Z0QWk4NRwnAz80bVWyMdlQygj8Iu?=
 =?us-ascii?Q?GeOULuXrOm0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCD9548BD9399942898A4B5F46481393@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab0b5f7-e5a8-48b3-3495-08da1d568054
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 14:04:18.0461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB2045
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

On Apple T2 Macs, when Linux reads the db and dbx efi variables to load
UEFI Secure Boot certificates, a page fault occurs in Apple firmware
code and EFI services are disabled with the following logs:

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

This also occurs when some other variables are read (see examples below,
there are many more), but only when these variables are read at an early
stage like db and dbx are to load UEFI certs.

BridgeOSBootSessionUUID-4d1ede05-38c7-4a6a-9cc6-4bcca8b38c14
KEK-8be4df61-93ca-11d2-aa0d-00e098032b8c

On these Macs, we skip reading the EFI variables for the UEFI certificates.
As a result without certificates, secure boot signature verification fails.
As these Macs have a non-standard implementation of secure boot that only
uses Apple's and Microsoft's keys (users can't add their own), securely
booting Linux was never supported on this hardware, so skipping it
shouldn't cause a regression.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
v2 :- Reduce code size of the table.
v3 :- Close the brackets which were left open by mistake.
v4 :- Fix comment style issues, remove blank spaces and limit use of dmi_fi=
rst_match()
v4 RESEND :- Add stable to cc
v5 :- Rewrite the description
 .../platform_certs/keyring_handler.h          |  8 ++++
 security/integrity/platform_certs/load_uefi.c | 37 +++++++++++++++++++
 2 files changed, 45 insertions(+)

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
index 5f45c3c07..bbddc7c7c 100644
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
@@ -12,6 +13,35 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
=20
+/*
+ * On T2 Macs reading the reading the db and dbx efi variables to load UEF=
I
+ * Secure Boot certificates causes occurrence of a page fault in Apple's
+ * firmware and a crash disabling EFI runtime services. The following quir=
k
+ * skips loading of these certificates.
+ *
+ * As these Macs have a non-standard implementation of secure boot that on=
ly uses
+ * Apple's and Microsoft's keys, booting Linux securely was never supporte=
d on
+ * this hardware, so these quirks shouldn't cause a regression.
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
@@ -138,6 +168,13 @@ static int __init load_uefi_certs(void)
 	unsigned long dbsize =3D 0, dbxsize =3D 0, mokxsize =3D 0;
 	efi_status_t status;
 	int rc =3D 0;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id) {
+		pr_err("Getting UEFI Secure Boot Certs is not supported on T2 Macs.\n");
+		return false;
+	}
=20
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;
--=20
2.25.1


