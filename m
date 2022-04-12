Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F014FE609
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357741AbiDLQmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357805AbiDLQmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:42:49 -0400
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0188.outbound.protection.outlook.com [104.47.100.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FF44831E;
        Tue, 12 Apr 2022 09:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irljsPvjLirGU2jOVdvAw70N93AhBkmPilbI80Dpis2hesA6oPweA6AiS4rSdCE3pxgRiUIwGt/NSe0bFC44bhaxK6qF/qqtoI/eODlXCKrxjTeYf5LAxCo9/to6Pmywzsfn/AhGgaStz7w320XGLN3FQZRx2QEASYnY3tg4BjMmigiFSGSgjgXPuPt8MHXICMVubg+BpIbn8jOjtjtr8a8LA857qdojiUDbN74IKElpncqa9uDqJuPL69/BTYrjRF5KKAssiD7PcibO9Sw01wpF29e/OK+ai8bMbJKL5MsRYTQeFvSCzBFe3rEtJbnWLI6cUFEvhGQ1vFYtCmtTuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ivt0xzWCSWl/gHe44gE7S5SWRiEkySjdMJncPuEtWSI=;
 b=msuU0Fw+PMw0sfOvy+RwjSG1Ezh/EGZ1lHiAGinpt0cA5CHqsmIcCuNd8yYrk6be5LbyJ7hH9eFqXGmkYjDksN7JiJ4TVp0hst5f9o7w10VZYHJANSedMqK5GCBEuQ3FFHg2S78EZTd2tRMZ9c5JWSY2j8qhexfmVKr7jOB0kwbIoicTPK0RSQDt5aN0D0cn8xnhjMcc9H+nAhe3QzUFx+B+UZJC4doKnWHXp14qqCYoUa6rvq4Z0PX/PB47FZ2eJkVdvz/CvmapeOV4xb2u6xc/+qxXUMTXmRgaANxjSFRTRXbA5nEEfn8WEaS0ycU2LvHqEZmuRYGv8GFnYZa2vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ivt0xzWCSWl/gHe44gE7S5SWRiEkySjdMJncPuEtWSI=;
 b=j7Tc9W+W7cx6reNdnU/Ejx2/nFldA9ucZe4P7aAzleFGtOHkdMa7iK/AWy/2Fqqb83EQhj/RKnAuvc3hD2xUFmuA7J4dO6xb/EoZExDgqhW1Vop0fRbtcbkV5Goz1m566LIQwWOyWyC8cT/PKd5OGKjj23n1uDXTCzJn6AebY39rusk17y9DGOlpa3mwY5EltfnhkASs90Nd6xKplqaKT6pk/AVzxb+QmFMq0yjHX8Q7+MrRyZKfIvgcovpw76BcNRc3kHXNEJAXuvgqfjwvItdhNzJlOUBF40T5oT2XJ8AxJKgqR7/nwfMPmU/Ub/4hDiFiBLLaVgldbiS76Xgezw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA0PR01MB6906.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:37::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 16:40:23 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 16:40:23 +0000
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
Subject: [PATCH v4] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH v4] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYTowBbcLMYGtuzEagN7LaBXEsyA==
Date:   Tue, 12 Apr 2022 16:40:23 +0000
Message-ID: <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
In-Reply-To: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [y7gezmueV4Vvd9exRqlovZ158nhkjbr/]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00bf62b4-7121-4590-ccba-08da1ca323ec
x-ms-traffictypediagnostic: MA0PR01MB6906:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NTwStIfWdYsH0On3Ayh1XLjMNnYkti0g5lSE4oYTaaK+UZFsyNvxQHNK0h0755/pVHorvPmTMJj6pjiiTmZnFokZCaY6CgbcgE0eBeGcq70OZQ75v26EDS8TVPn1VPvB2OCHu2lu+Dtf23qJT6mquGgBfQjg0ZH09l96S5ELuVBBNStfu9GElI5nVd38CvbWX3EpuTH79SK3J8GhRFugZlECeQsmjesWyMtngv9WrM+EWR6ywNT5RX9cIhxbXHZHFCSGUQ5rv7yON7Dw44iXvphLbTToVAxFMj08vz6m5eRjHdqy5Dgd6n8CQ7dOvE2tZe5W7xjVQlry0r2d1PBiG3Ap8eY4Dlb8CB7iMtE5ZswjS5I7x++SQ3DOMVnbClntUKnc+/E66a1gDsxzZeSmdl5vBoZ73yr6V9xLdRJkdvJBTEzSTv4yaEWE2CynmQkCn+z0mmLtsEL7DB7gaPj6JfrVIym0OUu+WzG05Kf6Xxzmn2PVDB7QKUGpgTci50LRrYNGvQmm0EOi67UCwBrDniiQFT+f8Zp4S2IkvK8qrFO9wByCulyCbzcvunCPKkydAJPfTOuJ6lpVOix1yt7K+Q==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TSpUZr+6qtJAiweMGJqMDwVWQyAwH32CgMARQsr4I5eU/43JgSrCAQD+iRcJ?=
 =?us-ascii?Q?xWSAthz9BR/O3irmk9VCmyQFYxBl7B8FPRtmgBBUk4rIX0/zUjmNtuuSy/aG?=
 =?us-ascii?Q?Ji22R/GP7URXo3AhU+mzDEsTMVDHhaCdcZC7ldNj3/F/78crgdjrI1MyNsKV?=
 =?us-ascii?Q?/cHci87COyTV38bSpmxm443V7qK8qQ8xIgM+ja2b3z34twhXWq50Ac0ADT67?=
 =?us-ascii?Q?ify2xHEicoksn4J9y2Haz+eJQcyKZC+bTw9bfOEvW6B4ZnVcLokzm9yNnhLQ?=
 =?us-ascii?Q?aemy8hNojOIyXBi1rn0V0IxNgOmCUHntkV4cM9BC4hfeZp4RJLhfWbMjLpTK?=
 =?us-ascii?Q?oH415Vth3mdZ0zMOmVuQchVs9CnttwXXD9ITs5CqnQKo9Vv2mFXfFtaXsNF6?=
 =?us-ascii?Q?fE+lOoIspguylEV3fQWkX0LZqiHF+3DMb//F04EXDudhVEQE5eyJOWpsZFvh?=
 =?us-ascii?Q?76d2uWVYjMieY1zMmYsNZUXbpKFWSlqzlKWMVnVXyWSHhfgzOKLOlGTuwwni?=
 =?us-ascii?Q?IME/LFRxAILEF1sQNd9AqrQNvLNi+E2j2cxGPpIq12jyaHgl1TcLEnz3HiUi?=
 =?us-ascii?Q?bFbVYdgP1sW1hwKnOpCVlplw+gRDaTEHkxHl/5eKcKJEOG8gxtaFNSQXDj/R?=
 =?us-ascii?Q?Bo27YUlL2PXGQ1oi6RfFeGf6f8bCaYEEBb5uOjEkZQXtD7c4wtdPAHDfHAo6?=
 =?us-ascii?Q?IuUi0nPBXTSvqMl1/qzDcxxYjSrhwV2ZZXFtId1dgjoulWwhF/Lj2uLNmh2U?=
 =?us-ascii?Q?morxT5K+yyr9AV3+Xsc3G+M4yOkmiceL46a9S30tFj8DLS5QsZxGgyyhiIZ/?=
 =?us-ascii?Q?p44Wv3paExxm++W64LDnOfYJJ8PyzCmetTiQ9QuI2MUf/lDxAlcsT80LYUM3?=
 =?us-ascii?Q?jbzD9G9RUAiDZd1b9oF27ZAL7Sk4cX6dwCl/m11WE+5wm7flLlhOBJs0zLM0?=
 =?us-ascii?Q?GHNpXOMWzYCTwKR9AaEX6nT+4racqrUqImQYAo+gnB/hlD6dnDz1tMq/JBKA?=
 =?us-ascii?Q?8GA8p50s6IlZ6MxR8pjVnz25nEInQk8TAgPeGw8FWJ+jNKm6MelUgUS/7cOZ?=
 =?us-ascii?Q?//U/TfdzGKsjSbj0cBybjWDI3f/ODIcHp+ewl5BIFdRlIPCb7s9WipQatnzt?=
 =?us-ascii?Q?jZ9gIr8A5KSPl0NL6MZJruAPufxZLSwvPIwNH34RqJi41Ewk1qcU9ufIrpEa?=
 =?us-ascii?Q?SGSa9YkNhGArr2eOAsLcOupEdPQ7kNyGuyVOZgsPuGiDgE+7H+zl4rc65moT?=
 =?us-ascii?Q?8Kz37T85ZT3E97KZ8ddkQjarAPQa33cFyiAUYHBDS2Gqx4UBRcurlR9xEg2y?=
 =?us-ascii?Q?5Ec/2JomubJs4uQzIdigKnR9Yizf+uYJ2Q6H3nO5qogllKp9aE09K51ALB63?=
 =?us-ascii?Q?vR6Vv6d/JesGHRaW3uL+h8GOP7IH0HrLV2RGF9WpnzzFReoe4YV/+M/ggUqt?=
 =?us-ascii?Q?ndnguznvKaU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77D4DE5FC36F0C4EA59FF6E08DE91AFB@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 00bf62b4-7121-4590-ccba-08da1ca323ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 16:40:23.3690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0PR01MB6906
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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


