Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC450257F
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350398AbiDOGVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiDOGVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:21:43 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2099.outbound.protection.outlook.com [40.92.103.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0A9AFAD6;
        Thu, 14 Apr 2022 23:19:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEbb/OOXVF5m4C5A2JHI6/KCUZcFgqksEYy88exOhs7544DGxn0P9+RqOMOjeNnfDMmS0zTTyM+hP5lZxzkiiWBacfEGLINv64K0aT3Q4F7KY/5+9f0GJXPOzCrkw/LPWQnEIxDyuN8lB8W/2o/4aLr+tX71Z0kB11fUEa11w/XMUBWz9/EUfBmW2eaZ7HXfx9jq5P+fyXQ9oOYlctr0O2grsrdK561RsvHcQ8s1irOe5xJ6stZKRW5Rvq6ENsJ8nmCm77hIt0V04LGsuhrg9eo1gZOdv5jkEImFShfOVAKwibO+1IgdI9uCwaUtp8B+AVEer27nXK+9Xl/3F3Rqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxrm0t9ycSYf3jFUUrgP5LCtQp/zF9nS1HwpQkHOExo=;
 b=WjNIcnzEKaLzPsa7SoB0YHQo3He9/LUBnb4RNtqGGbuAhXFb9LJq2yVd1Q3ALrsfHttnlb9VZGVrsUZ9OlYE4dv/FyiF3JwDM4RzV0jhIUb0Vz7KkH/+9DaHnuik8nt1ailSO2TUPWzJ4a1WVg8bAaS971htAxKnXyyD2xhbqySlGPQpiq3lw9zJXwzQOvnNApvpSH1HpwlulhUD+7W0/4JWW4SB14uiai/DOBf5UAMX8KnR1aHlY/TOmm977vLdQKxSLIScNomc2pxgfXyTYvvlv3mDS0hjhmumYQ8OaYtI0CJYxiIpXL5lTsHxAxspbSGunUFYOb3qMXCmnFmbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxrm0t9ycSYf3jFUUrgP5LCtQp/zF9nS1HwpQkHOExo=;
 b=qCeZnRCxWnz29tENe/jSiFuMc7YZkox/bIgR0kbJbMJbEZzDn710UcSBqW1y1o39mt7zAv6lvy/7p0EDsQZ8C9L4SX4PxFysB6AMIAO+rEtUiPOkcsZtlS0Xr6qCCATM3VdNZeFj02lUNLQythRCRX89zOg3T2OrG0pQJC1uuRb3vjqAaPTiL6fWihys7GqyyWQk6c1AU5J1rxXAUZGt6WRimvoVwk+vhyExj2QFzqvKSt40UTCYNOH8WZC8aaT0wcGWL5u6zWfkIfTDXg/Vecy63vRpesENxDGEIaesAkiwIBhe9ut2RJvYSU5T+k2XkO9CF0ua+ibSL9G3Gz+4Vg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR0101MB1891.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 06:19:06 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 06:19:06 +0000
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
Subject: [PATCH v6] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH v6] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYUJC2WWhNZ/FatEqYGX/Q2UQCpg==
Date:   Fri, 15 Apr 2022 06:19:06 +0000
Message-ID: <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
In-Reply-To: <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [JfD55Eogwt4Di91lH5YFIDHhWeaMwBpGTB6qrLLgptvYv+sjD1+TBRkv3xlrHuF9Eb7+5RVJ3hs=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933e9721-f406-48cd-5134-08da1ea7d899
x-ms-traffictypediagnostic: BM1PR0101MB1891:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s2DsoWbZ7ZibrvkqmICsPNVQZAUajLdZ+sDLYDaG9/UEhVUNqYZhqA2Jaj//AigSHIfUcoQdjI8IOF8x/CElQ1k8ym73TFCOMPNSK/SjIJ5YgQzFHa2Knv/7mTS315bTmd6wO5YTwAn0c5ZfjaXoUPE6bi8ujVpP/uQZb5YtEFKdhKIyxUFIabVh/qOLuBaYZn0/u6RbKAtIhOgXkWNzZgx+tu8oozlDK94WpaTDPfTTFUMOad/Q7lfLUewcWv2pQZz/cbQ7HgVd6/fE2BhB/NkahXHGrHDs4eBRObubDN6CnI2lxCxraDk6AEK50GrNzbrb1gmXky7iOUHt+w4NoE+3G4nHla6+mJPmIklVkDo1m77UCcefissIUlmZVye4Ke3ufEoZlosGtDEmmVHbG6oBVIXENrX2goJdlLylDwQxu3H0OXMQvsxJIxcL3c1ie9B+lBLAWb2Mjr0i6l7nWuGftjxwIMI/tTc5ZDNb8Oc0YdroFSCyJVer4qG49ODkfqKPq9oyALuRRI7OS7md9E1gESPfPXcKVDUiPx/g+krx34/ZPl2bO27tTPa+wUTRbC3Ape1nIybSTlNUj4mziA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W7GtNrdsoUXfATiE38SUxHsQvgUEjl8hzBEpVXdnslvJCl2GM+5L18mEqIlk?=
 =?us-ascii?Q?MNJXOurAuZfqJod3uxT4NNh9AVM5bhKpZtDXbhfpVmNCiyjL29yi/0gHke2c?=
 =?us-ascii?Q?HUBBsgkzfcHqh46c5tgHR/zTlScbJb1m4d0XA9dKbTshuShz9uSKjFmTMVUO?=
 =?us-ascii?Q?4CwxC6V/RM9i/wpsueQ0P4sELAI7yjCoGl1rQw03bx3XVfebim6qzLeKP6vd?=
 =?us-ascii?Q?SkYYjpH/LlYW7qmH93tF9oB2mFF/hlPWotKIrU2tqNzyhqDmXaekKHzeSQ8o?=
 =?us-ascii?Q?SeL7DAkgg8QYk/bfUgYRxMtcJ99TYX1J2/rivJs4JLWnhbuFsWBLIzBOV+OM?=
 =?us-ascii?Q?oY3CX5kJ3bmzRbnkW5V9Q2E3JR4skv6wwlIymbxOEKrpFWkmBzlkvphlNlDo?=
 =?us-ascii?Q?Ai29jc4EQeeD+MVHbHZP3pxSYxw5TyU13WiPYt3lixDfOXR9mHvRPocxv9J/?=
 =?us-ascii?Q?11h9WfwnLnOrVHGV+EfF0Kf60WWqP+/AKlsjwAdkWF2c+W2tKTrOIBpYLNAO?=
 =?us-ascii?Q?iPGaqTKnhiAjQIp3syNkDHQL0KMQPoObwloiYKDb+k3ylRLeJaB5zufI/sgV?=
 =?us-ascii?Q?iGoNUyhFdYGkFgDlgvHdyihEEMq3UA/C1umrV7n4nqTNm0hY0FUZ6uv833LQ?=
 =?us-ascii?Q?pTuf2MYF2taDYOcAgDvcqJXC7A3qUd6M20I684uENCWDseKExAkIbR5qwcqT?=
 =?us-ascii?Q?rkhhZiAZ4lRtuqewXxwCQPCNMBA2f9LG0Y9GRUWmCB6D1mbefL+EcspnJG8q?=
 =?us-ascii?Q?TRGdWTlPUMT/QV61c4fVwnWDCrpVZj9gUwtX6SyyTTMUB1rhRzUisc5IZzT0?=
 =?us-ascii?Q?rXN0KkqjfqKwOF+aNbYvAADBMzucR0904NgRLUZSnPlvRA7vHNw+3qE2SrgS?=
 =?us-ascii?Q?gP6XJJu25yvKiOUlyIr/YiCHEeQpxOodBU13w5qurC0snEPdMFqxOsq0eFW1?=
 =?us-ascii?Q?OWZA3hRY4ww/oWzTE0A2NYSZ/lF394SSPu0o3O+F73XBPKkl5VufCTDRDPE0?=
 =?us-ascii?Q?RmgPU0/JwxcaJvqkJXbOteVLeRuXxBo5qbigURrMRYVKkY3dfrreMgAxfhl7?=
 =?us-ascii?Q?FXax4HYQG5VJdAeua7FzuwdhUAJSjOsjKag1837lHXA6iW7P/lTcxl06XaWs?=
 =?us-ascii?Q?9toFiLHaeuyLC0GY7E/ndjTtXIjHmu36CYdtiJiadfwV1byZXxeeZuafZY0U?=
 =?us-ascii?Q?t8gYcz/Hxg/KNe3N56OtfDiYAK7B5bCFwhm2o9dmdoMzZM6HcOtuFBn/14B9?=
 =?us-ascii?Q?P0VL6v40HxgQdkZTDBi52YXHx6sE0d5u7931buM+X6YKSLZjuXq6JQH0Y8dp?=
 =?us-ascii?Q?wcI4m0GMHqq5Z0pHyJ4WV3U3C3UlLGQwdOyGiRHrY49qE16BPhtCrZNsekA1?=
 =?us-ascii?Q?FWc3onNkOmb192hfXn9Du2BF7ADjLPnrYtMNeBDPeuRIUkMa+69inUrxYJb1?=
 =?us-ascii?Q?A2SGG1EeBbdP01gNqjCU6Bd/LfGZ36lCZd/uOexzpjtC8VpL5utL2sVvlt2T?=
 =?us-ascii?Q?xcC1Wt+BgxPE7Z8r16dGziSbLPQAbG0iYKh1?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE6E2EF6AE7B674F834A6C2D19B817C6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 933e9721-f406-48cd-5134-08da1ea7d899
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 06:19:06.8175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR0101MB1891
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

This patch skips reading these UEFI variables and thus prevents the crash.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
v2 :- Reduce code size of the table.
v3 :- Close the brackets which were left open by mistake.
v4 :- Fix comment style issues, remove blank spaces and limit use of dmi_fi=
rst_match()
v4 RESEND :- Add stable to cc
v5 :- Rewrite the description
v6 :- Make description more clear
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
+ * On T2 Macs reading the reading the db and dbx efi variables to load UEF=
I
+ * Secure Boot certificates causes occurrence of a page fault in Apple's
+ * firmware and a crash disabling EFI runtime services. The following quir=
k
+ * skips reading these variables.
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
+		pr_err("Getting UEFI Secure Boot Certs is not supported on T2 Macs.\n");
+		return false;
+	}
=20
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;
--=20
2.25.1


