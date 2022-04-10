Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA324FAD77
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 12:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiDJKwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 06:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiDJKwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 06:52:00 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2109.outbound.protection.outlook.com [40.92.103.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1476652E4D;
        Sun, 10 Apr 2022 03:49:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL/jjQKXWGEg9WCgWwDwTqCOIOrKCHVFCkWjrupUhdKR3nZqYqqJUeL8MTh0/9DL8hkxCor+KDGNBIp9GCzYt599fhr87SRjgRiqumjkVFwppDWKQJZrAZkvJw66nF8chp4LZEKD9odY0Jx3QH/k4xojJBssvYy9+MDEcGghPXib+7DIsR94dcjj/Y24P0KEpqyI+dHJipqAtVeAPyTTT9mb6NmiUBR70mUvZw9fW/Z/cQtMsWiGLLD5ZJ9wR7TDZSEpGRWdZdHzfjFtmTaOETqjraBs3AFrEQtB6lYScaAcUG5zNHYAk8fExT0Ikgcpz7YMbdBkRXJZEBKy841OvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRYT9HIVLI3JsGOF2U/SbYZObbuVI/T8O37W1Car8WE=;
 b=fOBK8mGfaAVd2CmxnaAFAYY/YSbmGW6nuE+Ll49qWAIHRnHjxZc8NTUP7j+Wkx6eGXBOHtPYQtYoRMvjE/MRhVgsBpxbvUgvVilkNDKBoYDfGmFmR/FoLSgLJCdSGxnjXVBnOy9CTu6L5nEG3JUUtRj4kttph3yfsJS6237rJjAPRm7x4FssEqSmtnT46fwrPUZGRI+u0wXtHjvw65t8wcFxCCmmZNVnpuY0ZEiPeqNwvAzaPsNX/YbnfMYifcvLVwIjLkQx3ulSfABYCYjshsWluFSR69UGBVjJvPkM7sxwf1f8qalr3xFsnxxtMGOL0ucbYrhTRpZ2AqKYIb0xIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRYT9HIVLI3JsGOF2U/SbYZObbuVI/T8O37W1Car8WE=;
 b=Nq9co3KHin5PJ0GpCVJVUIcrfD559PS+EzHaIrp5d9DQtDAVj7clUDeFmZ5V9m1Y7075uXzb48c4fbBjnMqs26Q4NsW8w99a+c1a9q+HpDnaPKfsNNrzXZkgktbVv4YVG9pUmKa4FiIHbVQpQaOLgXhGAhTNUrtEqRSXVpFuKooZmrKQclY/90UuV023HyjdB5Cb3+NYDQ9fxEBeffikonEjNT1D0TF95K60puro2mhCicLP/0+1HEoTEDPuIdYS9dtPJzTTSHq9sFN3x+DhPGUAfTmYqqRoBHY8ez7Zb0wJ89rVypwa1CL8rX9R4ruAardWEP5rGCXDsRcGpWsG4A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNXPR01MB6803.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:a4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Sun, 10 Apr
 2022 10:49:40 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.029; Sun, 10 Apr 2022
 10:49:40 +0000
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
        "admin@kodeit.net" <admin@kodeit.net>
Subject: [PATCH v3 RESEND] efi: Do not import certificates from UEFI Secure
 Boot for T2 Macs
Thread-Topic: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Index: AQHYTMiu7fv9f4beLU+/MNIc0GPCKQ==
Date:   Sun, 10 Apr 2022 10:49:40 +0000
Message-ID: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Dk+Bk30Vq8pr0Mf13vFncptVWdm2hXtW]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a20533a-22d9-416d-ec26-08da1adfd0aa
x-ms-traffictypediagnostic: PNXPR01MB6803:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mYd/zd2ozv+maSKzZYzunUD8kQHUF4ywu1rIOz7DuAMdtV8JGR2YiCfInTtNbH0m1ZESCJmL0n1FBNHR9jloe8KVZUiIgJIWjyWXBnFeRhxxftgFqUIVNQJO/pqt8U6jpUpGsC2UBZDxhqhvdBpygm5FH9DLvqNbA3H2uJg1rnnm0sWADDS+e/i+d217PBYlmkmQNH0jqGtVbfzs3Eb7ZgjYi7FNBPj3Pirdd+DNJSJctkVPy3Yj+3rNusVA2TmIKaN0nYh8LeGcL8hDntW1btetbJWYZnbTOAjKcR5LUWuBmyIhb9+GP+uhmdOiJZ59FBrpk/BLYlFcORehS8HLUpFCkXWh+EVDHumEXzinpnQU5AW76rj5Yz42FprW1cpa9TkdF1DqOKzJcVJPwMIjeEPd/fWTMlM0OVIhmCCOHqR6QE5obDmPHzmbFLd4x4yAM8wFCoF38B7xngGuR9gibtgVaVCk4rjb/3VinadJfSNdF1VDWkdimg3sylZgKrfiTjBt5VQvJR5M9Vf4ikUEQjlWC4HavoBdkWcxIFaATfTbAUlt2EwT1A438hYPwtJmZSv6NeYUwARKlQGDEwnhQA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d/aGMdBH4KnXkB5maKcP/vhWRHmO+fxg/QzXTX3J2fl54sHWZhLcNKswh6lQ?=
 =?us-ascii?Q?yNUgn6WIW/YSpc8GvIFOUcmdML41VwMnrk9gR90iCZUeQ+IknOWaZldMuHRh?=
 =?us-ascii?Q?bqC/xSRlQbBsFxZdyEYxPIaTIazeBxe6cyOk/6HojGyFUvEFrSrymeU67RRD?=
 =?us-ascii?Q?on8o+zyfsXK1Ce1vkGrH8aHnkIikcNaSUkTg4wTdFqlqktw7qNTTuwY1BpFg?=
 =?us-ascii?Q?NCcjLHXHTsy95h6yZZKr+gfNtkBSWxKP+nQJ8AQxP8jshwAdfzWVB6cfHuVs?=
 =?us-ascii?Q?rVLaJaDe7IX5b0SUamdqAaDlbip9W/APDpquVn7s+Rnyr4RByobnsYLZuJ3e?=
 =?us-ascii?Q?gJg35sBGz2oEoXb3zesPwtFkpWN4kYnRzafsDYwTpkSFh+XmLJvq/qZp6V59?=
 =?us-ascii?Q?Mrjhqk5ncxKa64/Yb2sMipioauHYqis7IojbEgU6VaaGBUnY8MC+e5RznWig?=
 =?us-ascii?Q?1/rTew4sWhHYZ9dVpbCE5Q/KTKCeoLRWh27a5Z0ZavtEWYScev1qbB7Jc38K?=
 =?us-ascii?Q?jmXmc0QlhlVk/FWdriB3AitkL4vdyahPqAJsxc94p/rA5qKFLPF5Kxm6A1uZ?=
 =?us-ascii?Q?ZoqgmLM9Ldc+Fz8Rri36gs+D+D/hFhAUYFnk/+2MNUq5yHypG5H2hGEvH3Nm?=
 =?us-ascii?Q?iYXbOCkf6rHT+6RAHhIsM6rc0Svn6NBdW2hD3COB49/5EOHpP5SzI2GaGa4v?=
 =?us-ascii?Q?/ws93KpkMW6oa4QKvBeZv8MMHXjXqbh5HDKLCG5CzjSoj8npYXXKAvdEm3LK?=
 =?us-ascii?Q?AUjYh69T7PKEec06qej6Lu7h3bFb2eU5RrkVtB+IcVJX9C/NmepZvIaOx1c0?=
 =?us-ascii?Q?EiYK6Kkyr7CVHWAdK7CITLui6p3cGTcOmgd8Oygnug56WAbWdRNRyJtHV2m0?=
 =?us-ascii?Q?KL5xAiWXLkpKWJznBhnbP+5PtR+Fh3v+fMNaa4KWYDVJFrnljzvOgRPEVa8b?=
 =?us-ascii?Q?LomBorsH7Hok80gXRC8exJ3z0+ORhxXuiqGIuxsd+cK95xps/a71G2tRjKT5?=
 =?us-ascii?Q?+p4rkqUhKPeOWBUrvnY14dlBhj9BOHsHxAF6hQpbFbnmQqA5NcMmtF6o0BeT?=
 =?us-ascii?Q?7NxLhAFLWnOua2Sl1JVFii53kSZRkqahnVI8riaKTfudyiS3uOENqishM7dq?=
 =?us-ascii?Q?Xbcr1mcCis5j6lV3pobve3fyQtFRQl00fxPdTjXz9fwU604ZilUXS/weLBhG?=
 =?us-ascii?Q?GMEt6dBXo0iTp6ruYpLsZa7BFyJoNdlRR9YXEki7QVCxYiYLIA+jmeKIk27g?=
 =?us-ascii?Q?Zl5rLMpRS8fp0XAhI7ir0tKRsqgXYpA4C+A2VtSc4bLioFwXaNFHOB5GV6NU?=
 =?us-ascii?Q?2cOt8fqncBeW+eiQ/M0KLcLf5/VReTHjEmSUHXJTpu3GZ/U+9Bn10iUiFrlk?=
 =?us-ascii?Q?/iAxgo06lSeGijsxW2F6773Dhi1Ibc8bnWEu1bVex8Pny0EOPDgVZ0BjlC4P?=
 =?us-ascii?Q?VoJm/GspvjE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19A300E8C6374B4A9B52EF1D3E2EA82F@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a20533a-22d9-416d-ec26-08da1adfd0aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2022 10:49:40.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNXPR01MB6803
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

On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
macOS and Windows are allowed to boot on these machines. Thus we need to
disable secure boot for Linux. If we boot into Linux after disabling
secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
fail to start, with the following logs in dmesg

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

This patch prevents querying of these UEFI variables, since these Macs
seem to use a non-standard EFI hardware

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
v2 :- Reduce code size of the table.
V3 :- Close the brackets which were left open by mistake.
 .../platform_certs/keyring_handler.h          |  8 ++++
 security/integrity/platform_certs/load_uefi.c | 48 +++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/security/integrity/platform_certs/keyring_handler.h b/security=
/integrity/platform_certs/keyring_handler.h
index 2462bfa08..cd06bd607 100644
--- a/security/integrity/platform_certs/keyring_handler.h
+++ b/security/integrity/platform_certs/keyring_handler.h
@@ -30,3 +30,11 @@ efi_element_handler_t get_handler_for_db(const efi_guid_=
t *sig_type);
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
index 08b6d12f9..f246c8732 100644
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
@@ -12,6 +13,32 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
=20
+/* Apple Macs with T2 Security chip don't support these UEFI variables.
+ * The T2 chip manages the Secure Boot and does not allow Linux to boot
+ * if it is turned on. If turned off, an attempt to get certificates
+ * causes a crash, so we simply return 0 for them in each function.
+ */
+
+static const struct dmi_system_id uefi_skip_cert[] =3D {
+
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
@@ -21,12 +48,18 @@
  * is set, we should ignore the db variable also and the true return indic=
ates
  * this.
  */
+
 static __init bool uefi_check_ignore_db(void)
 {
 	efi_status_t status;
 	unsigned int db =3D 0;
 	unsigned long size =3D sizeof(db);
 	efi_guid_t guid =3D EFI_SHIM_LOCK_GUID;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	status =3D efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
 	return status =3D=3D EFI_SUCCESS;
@@ -41,6 +74,11 @@ static __init void *get_cert_list(efi_char16_t *name, ef=
i_guid_t *guid,
 	unsigned long lsize =3D 4;
 	unsigned long tmpdb[4];
 	void *db;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	*status =3D efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
 	if (*status =3D=3D EFI_NOT_FOUND)
@@ -85,6 +123,11 @@ static int __init load_moklist_certs(void)
 	unsigned long moksize;
 	efi_status_t status;
 	int rc;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	/* First try to load certs from the EFI MOKvar config table.
 	 * It's not an error if the MOKvar config table doesn't exist
@@ -138,6 +181,11 @@ static int __init load_uefi_certs(void)
 	unsigned long dbsize =3D 0, dbxsize =3D 0, mokxsize =3D 0;
 	efi_status_t status;
 	int rc =3D 0;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;
--=20
2.25.1


