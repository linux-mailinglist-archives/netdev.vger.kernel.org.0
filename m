Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3314FE63D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345761AbiDLQr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345055AbiDLQrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:47:24 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2043.outbound.protection.outlook.com [40.92.103.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D121CFC2;
        Tue, 12 Apr 2022 09:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlWpgsUR0Hadn1B92OqBGguHRdaUhzRzWcV527eMetDnIivvLQVilnkjD9R3aN2qoXzmNUJsptCIHvlFZZ+h87WcmwQa/TQsmWWansIlAXWo/ucHZA2IgOjxkMykpc8EmqdN/gPlthGJN4j5WfETrIBmDDVNwA/C3pg7NlfPkHu3HP5HVgfY7/LXfqW+pPaiLTVhraN77RdViTplIbNusln3zyP5c8lFNYrnX2pTVQny2zkoufhFZNpBYBEaUx2uRAbYDYu+6Yq04ZaRoDlco8nW/zal2uVVJfrd/51mtCbAmOZXWvkPlVBqpFh8Q5/uB2xr+83SHfmscIhUr9mM8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5HAJsIymNmVdpWcGHWznw8P+jbjXeVNXCN325s7DF4=;
 b=fMYqy9m4dc8eDGWYcT30fVzVoYcNviMZ2ktJbl89g4PGuWMZk59JE6u16HhrBIfXX2k9SqMK4PrLLaVh56psvb8Ik+UVtR1R8dkMPvzfsMXHTDNaPpaVU7Xj7/f/xh/J2G1jjN5r6xjBGafm9itLJgJb5iurvpF5o4O4yFREiqkpwhVdx9Bri/+3/TtI2gSD+ujVBz5fRPBqqzqaQBPZCfENyrCR1WS4Q+7RrDVYfm8ZFer0P87FXI2+Ubzo9MMHzabhQ2Xnt0vYZdmCWkFd04FcvJStW1k/mtaE805+q90pazop1+O7bIsNoaB7BohMkZeSn/M/fbNHoL8mYrWJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5HAJsIymNmVdpWcGHWznw8P+jbjXeVNXCN325s7DF4=;
 b=oVw5OKFo+iVyaSJG5HecjCHRa/HdgwYxF+dfSAGxGnO0Jv9JyKx0fbJ8+vCyafQcz48XnisSJjzqwDPzWWwJfCKmA4cIB9ymzwbByVYyRfiVhwpkIoS12sScRX4wTZmmRY0NREzBzKi5twfE+QIO0yYqM6G5lm1DOQrNnZW49WbYH7VtezkScc3kmi5HJVG75mZ7TzXwn5/U3n5gN9d1N8wExxjcV4EVt8oiwuEFiQBG18zekywNfmrjt5UcgJ/NQo+RbPTQkBX2OBru9MUK+C/4Qz/RaIxg1Q1in0rRt/hpKY8LLZNZNewH5PeGGnDtdwKW0bNPkMC5TYALhhP7aw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA0PR01MB6906.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:37::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 16:44:57 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 16:44:57 +0000
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
Subject: [PATCH v4 RESEND] efi: Do not import certificates from UEFI Secure
 Boot for T2 Macs
Thread-Topic: [PATCH v4 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Index: AQHYToykrBFj4SbxpkSfp7eRtc7lVg==
Date:   Tue, 12 Apr 2022 16:44:56 +0000
Message-ID: <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
In-Reply-To: <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [BSvz8NT8+F0ZyBjpzVSsHIz/tJb4ne4S]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9633903e-b6f0-415b-a95d-08da1ca3c6fe
x-ms-traffictypediagnostic: MA0PR01MB6906:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IP2K/Xf+HGGCy2CDeLeJvFRB0eN2P2hN0hwYQJtpK8MbE6tyGthNNu3ARtesBrvzqd38FFW9tvpqVN07Srd+jmRux7PN5zdyYE5kaElOm4oxP9olyBEvCbxVF4PlspMSksHfa5xNHua5AJLrd0lWZXq6NvsFtThNFlI1XTGvln0X7fS/p1/WKN/rvYMppkrEwCKvOJdooXNWtldE083FtVpEIIgPSJNXSIuqZ+yR64x3xwDHxgBlsFr1qoDMLdCqY/4AtHMWDTkvfhfqkAVrYcSDgGTr6LtoFLvjQPZMxKpYOJX2+NXqO2ONf+7buvsINvQ8YC034RXq2mbwNSL5a+39LyDhEiImBE+ejNfDe2jyuBuOyBYTfH1A8HFNEi3V+ps0oRvhwROsCRP5Huv1yabMDZlNmFTpmD78vHcFCFAs4oAE4LAjIRsGbm75sBM2LeFdWHJBOr971pAXMoJOQVi0UZegnUWi9yRR5bvXmPhZtjEYZ7ZTu1B15Ve7bP4bxpaeKsJrUb8r2TltRwmQ2LK97ckvHIcaP0QaHLUm9ynkmHFYLTxptpjZ9o3XMfynpvNH1EwTSSwQx0vLqC6Aqg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nZZ1R1XuDYhvbBICzU+jzMsuZxT+/8aNhd4HOzcLEnigssGy26HkmZAj44gV?=
 =?us-ascii?Q?auYBqiuJgG9A2PS7UTm4Qlq+eY6C7/yM50ZrgPmUsG2z5uiVcUpmsfqkIivE?=
 =?us-ascii?Q?bi8yo6QSYvsIpntJkVplFhTdK8exeVlfDxmPoZYli5iW2gLt/ctzNcWugqKI?=
 =?us-ascii?Q?73B6ACRbi5xnmNqdaGfET2hyvqXVqH2f18fV6liBmm7RWKP0bmJVLf4w0gqt?=
 =?us-ascii?Q?TJQmzIKERJB3vwFzIj906g2Ftn8zJuKuUQ4dfS82d7sO4BBOjaj0QB+lWpLc?=
 =?us-ascii?Q?Q8COIPZDlKTyALftgJME0/Tpn81YdMikZusANdN9XFGWkd8xKAnQJUmUGA5V?=
 =?us-ascii?Q?st5ILNeBdflkTMH5eX0z6qHt7OMvKAECGyWv6Ayo2c7S/bCCsyNXxy4fQHP+?=
 =?us-ascii?Q?LZgUV0xFd+A0FmE1GxBSlLdSED6wfAmdCk928a9TWuousGy8qab7d3DD/qMB?=
 =?us-ascii?Q?fOtKOvGnqAIJi8nGoLEW/mRpx0jn0fdsVIKoZna5MbEJ8uoV6Xyfih51l87v?=
 =?us-ascii?Q?mqjIMBZczmSpWXaXhS8tY20bSQse0yCQWLrsnnOKAlXULufwIgEBU8gpfWMm?=
 =?us-ascii?Q?elK/ZzNeM8T7EdVGbL2aM901uFNVZJbIJdQqLoa6iVcApMy1bSqNO5lPkvBx?=
 =?us-ascii?Q?9CQ2zvCRfrSCRZklHeckJLVcTRTt0AfTPLzgMv9hsJHZVPUHP5plquk/xYbC?=
 =?us-ascii?Q?X1d0UhRj1bErsDwJBrl2JF0Aj66altyKSBoa68D1Qwj32skUaxXKftCpz/58?=
 =?us-ascii?Q?5cJ2Xaw4k7MtbHucZBhYny6FVDrxrJHkuItb0XpryEgi0hGOcGBCpUWKAGbu?=
 =?us-ascii?Q?lKljSv+zeNGMsRjDRtGor0tbTHmDnTqdvf3856N8q4tFUxhWLpNgTbOwuJEM?=
 =?us-ascii?Q?7ZlnHRSaxv7O6WxFGyZXP9a3ahZDREp6goYeSQqhZ2QCFpXT/Cg0FJceJmjl?=
 =?us-ascii?Q?IIj6hq1ksWg8TxpBN1EVz+DPfz5QuJ1Bc1zkg7nc0EGhPy/Dvd2E6cW8nx12?=
 =?us-ascii?Q?ZnHK3+XFa+ru8Fcup/VWIvLBnfhnlwHbTDeQAwB7JLcxmclJxy0GT8bTM0U5?=
 =?us-ascii?Q?UmugoGkSpkLw5JOgbUiQJltinNYC70wKGvedSXMomTGh2oVh6OGgWzbQLG6O?=
 =?us-ascii?Q?0TvEzLAPqAFciLtNnLIiAQQQ+23wr9ZHHXIfJN4TAFk6UuCa7bNEyLrlPJGk?=
 =?us-ascii?Q?uZ4Ogt8PI9cH1zi4E9VEF7gshFXW6Hd97GSOjXP4eDvEIHvzfMUtKnOauqtU?=
 =?us-ascii?Q?gKgV6bd+ZktNoQSjCEwrrl+0NN83N13eEz1MgzvJ9wmGSrc+WOBv7wy2usfi?=
 =?us-ascii?Q?l0jsjnPKQphFTrpi3F0t01Wf/ohSIqYqY0jdTl7qe6zWKQjESg9wQ1o+ZUae?=
 =?us-ascii?Q?6nPyAWWc2vgznm6g7oa0vzBjOsfJK5u3FrqTNOyBd9x++WMK267cWijijLdU?=
 =?us-ascii?Q?1PuQAV/DM2U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2DCE488ADB19C843A73733946B7EB064@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9633903e-b6f0-415b-a95d-08da1ca3c6fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 16:44:56.9547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0PR01MB6906
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
macOS and Windows are allowed to boot on these machines. Moreover, loading
UEFI Secure Boot certificates is not supported on these machines on Linux.
An attempt to do so causes a crash with the following logs :-

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

As a result of not being able to read or load certificates, secure boot
cannot be enabled. This patch prevents querying of these UEFI variables,
since these Macs seem to use a non-standard EFI hardware.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
v2 :- Reduce code size of the table.
v3 :- Close the brackets which were left open by mistake.
v4 :- Fix comment style issues, remove blank spaces and limit use of dmi_fi=
rst_match()
v4 RESEND :- Add stable to cc
 .../platform_certs/keyring_handler.h          |  8 +++++
 security/integrity/platform_certs/load_uefi.c | 35 +++++++++++++++++++
 2 files changed, 43 insertions(+)

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
index 5f45c3c07..c3393b2b1 100644
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
@@ -12,6 +13,33 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
=20
+/*
+ * Apple Macs with T2 Security chip seem to be using a non standard
+ * implementation of Secure Boot. For Linux to run on these machines
+ * Secure Boot needs to be turned off, since the T2 Chip manages
+ * Secure Boot and doesn't allow OS other than macOS or Windows to
+ * boot. If turned off, an attempt to get certificates causes a crash,
+ * so we simply prevent doing the same.
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
@@ -138,6 +166,13 @@ static int __init load_uefi_certs(void)
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


