Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A268502E2D
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 19:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356094AbiDORF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 13:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356079AbiDORFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 13:05:24 -0400
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0189.outbound.protection.outlook.com [104.47.100.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCFC5AA6C;
        Fri, 15 Apr 2022 10:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnsHjINMiAc0IBeR4JKgcvHl9INXQ5qht0Cg7/gp6Q++RV+k7SwShepa4+oVfBGHwyX9y/eo9MXxI63ktYnYsy4Af5njCyCIB0zui9TNPccGU00arcp+LB8kGeRSp72wuPxp3T8mr+6GFrz+sraSwcDar7imcipxo0i/01RJ2IuWv+ct7tAc1MwbyaP+Eetc8rdVjf4fwAg+c/Omal3v/uRBV1NVNsnYEOCOJ2tipC1oOvVwSev+u4nN0B8ot6vvb6o+C+efPtTeiQnTk28eourbeCzqvMpiTCaOiG15J8YDZvA4PheqPeKmWRG9Cv85tVvz+SDBVG2CltAutvDKYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1KFyICb1KBU4A7oOn9tY7K4r2OyuSHdK/CPyRic/9Y=;
 b=egVu2CS/HsREkZCzYUqiP+vIuqHz8B5XdjI4z6QT5/sR+oJyjJR44ZxWBK/zdnlTZVf9vJjy0CyJ8Dr265K25FS08pMCExdI4LmbSsqKInuWBLS43uxHQfX7YrPmXAIerbmHsEivtZPI8lMnLwP8eE9j0og+EPIpTy2hazAhS2Wr9jzQRNr8JSk9ZeJdbBn1eQOSDzNMcwhHTXVxHXKiA5Pz9FxbkZagRcjMr2h3EVGrBFdhY2jVP6mwnNvMKdZ6+3Oxg6Cpzf4sK5wQIYGSuA1u9k0PyVqBMl+ijQnLD536q9LMC+isUvUbCaOHb7vn4EmSywdgJHwLwDgw4IXxvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1KFyICb1KBU4A7oOn9tY7K4r2OyuSHdK/CPyRic/9Y=;
 b=UcsN1RCiFpsI7IEf4ax3RgifTyHaENd4S/jojnyR7p8BrQq6N4d97x9Ek0yiKVlNE7/sxQROvYcT8ERh+1CyToytWGeWcEGbMq1F73Vuxu1NQqNBGVDF3nRyhc6ESy0zTc2UNJmmq57gQCc6AfbdufXSdkPMRGjcGzrCjSRuJWVpaS2VDB5Z8X13HdNmQCVnw4Jk2gVNSv3A4a/nLMFcZZ/fM/6LPZmBh5KKXvqETIx9wbIoS7pdwbzmLMnwLPjRLGVfb+Fp3bxTmw9S4ksKqNv/mBNWkYTAyHtR1kPtm6iaSEu2H8UCz5zEiBMsdHeyzZ29cX/dtUFbM38nZ+jNaw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB2881.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 17:02:46 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:02:46 +0000
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
Subject: [PATCH v7] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH v7] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYUOqhkcZ1390yh0eyOvPJZusvzg==
Date:   Fri, 15 Apr 2022 17:02:46 +0000
Message-ID: <958B8D22-F11E-4B5D-9F44-6F0626DBCB63@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
 <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
In-Reply-To: <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [bQR+8ou+FdCN2ZYuxbZ6XBTpy89aIxWw4iWsDekM7fJhY4Bt6P3imwm7h67S/osJSXE6YlpYLcg=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60399964-4885-4391-1c5f-08da1f01c3de
x-ms-traffictypediagnostic: BM1PR01MB2881:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcvZBhaU7aQMZz8u1fAStDVgfRHKkPW2YIpNJkrmHWnxExUaOUaOoMg86G39WUuzat65VEBwl+1nTBzu03EbUs3mOTd2JBIhwTHZ9gxQ/beibmVibTKXg1BgqOjfido6LtgDf7GpEcSLyfP0jJdOFCvwhC4uumYkmp7piUl1EsDcW11Z4v/gKWjahp8qEZOL5W5/9tWFEceU7rJwIvsJcuHD1s9Aihui8hzPxvF1l6Kk6+/NLxHiGRqnv7topYgIYeVsl0I5pBjCPFrvHxeQyMIayxuT3EQnkydYXI1KnTabpAD2qyj97v6/+lLBavXXHO4jLFffyBWtVblKlW3wwlODzQXvU9wolS8Ckm0c9Vu6rPn3vgVsYfIdr7PmnUIS6Jmf2wdmjkwNSmwCfdN55p9nqMcwqk+egvL2a2O/kL4svBn7fkxxH2nI3gUEVvPGS1/UaED/OB1x4bQAUarvl74DaaA6l5WyEVo28OGTtWF36VsQsyA9nLKYluhlxbWeqUYeMC7p9pl9kHeuVFHAFjNhfZqAgD21YYz9T1MFndgitbveFn6ENQs+pzm8Jp7OAqVY3Wzkpzc5y2L2TAqxsg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tDqv6j1IbhNMLJ4+/ojmIRni48e4wIi7hqaf1yzeAsykjvULOeEeYoT6JWDI?=
 =?us-ascii?Q?bVoUhPeQE3m/TUvcakePpe66Si+rzYLRH6CsRnIrMdu9xg+xN+SalLsgHmat?=
 =?us-ascii?Q?GcVBhoIbhABDlpUJrTf1KMLbOOXRnro6hymj9di3q8JF0V+ucLgs3+6imR//?=
 =?us-ascii?Q?llaaBJpWkFuoVn0gTNgGeui2c8UXZBtqvxe8tY9wCbyDN2YjK/zIFcRF2Ftp?=
 =?us-ascii?Q?+QhwVgvoqJeu9k24pW0fwBYKqYvpMu5qIKMTQvoZgppTYP16fx1JMTIjP2C9?=
 =?us-ascii?Q?weKSzZtSL1z9/vg5e57/voWOny921/cj3S8ueeTsVbT9NfPvMbi+tftTII6q?=
 =?us-ascii?Q?gOaTeO5a1RJu9yL598Fep1unSzCoSi0hG7mIgEBYyVmAk5/tEbnbtOBcw27s?=
 =?us-ascii?Q?mbxVrcrO0WCKScaGJ43ff74B9zQ2rfOOXihRwMtG4NT/kOZnbifSj454pJWB?=
 =?us-ascii?Q?awupdNQNS18bFPvL1Hc9qMtD+DHGrT6aUJwTFZwT7uM1FZFfbDrpuflGI/Dr?=
 =?us-ascii?Q?Iqb9pAlwBLsXeMk4JViNt5smDwgIwODBlBJlCPipi4H2tdWht9r1a+x5DZ6n?=
 =?us-ascii?Q?5/8IA3bb1ZqG1DwBha5Fkxa1ARzs48EFN48c4/j8+Gi91XOZg+ZNTmDDc/yv?=
 =?us-ascii?Q?pZ25KtPHo0r3YNSG2ZJOG2yxZ2GdFL1ijQTmYx3WmUkRvC73q4av1F6meZYv?=
 =?us-ascii?Q?pAJB/0w/53tKkQZUQZs4ZZ3pZouV4xFvOwJWm/kX63N6Kv20rR4GcJj5GzR3?=
 =?us-ascii?Q?dOgERpTW2qSL/jmmjGrCF10mI/3RHX19XjbwBQ9OJhNeN85snfXdECtkavT4?=
 =?us-ascii?Q?P/fLEfu2kupJ7zgvLVJDGl38Yh/ERjG9nGaKgYxdcYL2T9diOi/xwWzhbryz?=
 =?us-ascii?Q?IefgQhL2RHa+s4dRgWWJd64cfhlIWpAKGczUVrmK9qWsCGeNBCo5FROVqFX3?=
 =?us-ascii?Q?aJzHAeMb2AcEud7tBPXFmNEmsPJT7oOKtDafByjQOvV/XLE9qrl36eDBLtVi?=
 =?us-ascii?Q?aL6Qcpi7xVwn4aKt2KjxaL1WUzljUEj9GArZe+uKWavy1xa7Qa6iJybJYjQF?=
 =?us-ascii?Q?2+ev/R9tCZvQuFcyw9u2MbJ4on4tPvAMp3ZZ4DxUf/OzSYcL4+rRRZmZqyet?=
 =?us-ascii?Q?LJeBzljGGSlDik9TGm25t+9B/9BYqK+WiaO2SnrGgdnGVUiCHD6jVbjQpuui?=
 =?us-ascii?Q?fV91Tiz++DqRxnhcxErdEDypqKzHop/dsATpBPh/KlaRKSqjQwwwaZXFdCEt?=
 =?us-ascii?Q?cgi4N/kbSivI+ICiw/a9DVhVs/Qt91EbSjFvX6diCEm4c/aeLd9yaeVB+SgO?=
 =?us-ascii?Q?5r0pdCWmfRvRHgc1n3aYL4ifznqPfCpfHghYPi2uZ/6kTo0GAv3Sf08Xa3VE?=
 =?us-ascii?Q?saTw9A+DqqqfnZXbJyFVXIbAlyUky91msYyXi/DaVmWyi8zKVvA/xAJ6XBts?=
 =?us-ascii?Q?/mMvFFlM2bZFTW52FAzLIQKrtP7YM8EdNSdujMj/NadnWC7FazF41aVhbPXJ?=
 =?us-ascii?Q?DJf4sWDc0WA8XzH3MH5N09rPbQnNkP3x059C?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <025EAE1DDB73B84D8A9095CD5DC40C14@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 60399964-4885-4391-1c5f-08da1f01c3de
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 17:02:46.7107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB2881
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


