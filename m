Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428242B0847
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgKLPTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:19:38 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55228 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbgKLPTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:19:37 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9A070200D5;
        Thu, 12 Nov 2020 15:19:36 +0000 (UTC)
Received: from us4-mdac16-41.at1.mdlocal (unknown [10.110.48.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9796E800A9;
        Thu, 12 Nov 2020 15:19:36 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2E87240075;
        Thu, 12 Nov 2020 15:19:36 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E9C31140074;
        Thu, 12 Nov 2020 15:19:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Nov
 2020 15:19:30 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/3] sfc: extend bitfield macros to 19 fields
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
Message-ID: <5ce9986a-4c5c-9ffd-e83d-e6782ff370ba@solarflare.com>
Date:   Thu, 12 Nov 2020 15:19:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25782.003
X-TM-AS-Result: No-0.095100-8.000000-10
X-TMASE-MatchedRID: C1DXOoX+qqn2up/bgDqTK7sHVDDM5xAP1JP9NndNOkUHZBaLwEXlKCzy
        bVqWyY2N0gDCkQzZ7yFil9NyRvcTnEkjllSXrjtQOX/V8P8ail1yZ8zcONpAscRB0bsfrpPInxM
        yeYT53Rk9FnBw45/tLOBI91hkK7qyEXSCqqRvu5X6beaNfw18XQves2r39oXJkz8BDdGAzndnxJ
        Bhjh8ytVZjGZPLD5W4vxF9leMhxrkaEFYXAylB9SUSM5mwacGkICQpusqRi2ejpeaEV8oRRMPIN
        hwTXBeZ
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.095100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25782.003
X-MDID: 1605194376-ZEjdgpaTKfz3
X-PPE-DISP: 1605194376;ZEjdgpaTKfz3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our TSO descriptors got even more fussy.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/bitfield.h | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
index 64731eb5dd56..1f981dfe4bdc 100644
--- a/drivers/net/ethernet/sfc/bitfield.h
+++ b/drivers/net/ethernet/sfc/bitfield.h
@@ -289,7 +289,9 @@ typedef union efx_oword {
 				 field14, value14,			\
 				 field15, value15,			\
 				 field16, value16,			\
-				 field17, value17)			\
+				 field17, value17,			\
+				 field18, value18,			\
+				 field19, value19)			\
 	(EFX_INSERT_FIELD_NATIVE((min), (max), field1, (value1)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field2, (value2)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field3, (value3)) |	\
@@ -306,7 +308,9 @@ typedef union efx_oword {
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field14, (value14)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field15, (value15)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field16, (value16)) |	\
-	 EFX_INSERT_FIELD_NATIVE((min), (max), field17, (value17)))
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field17, (value17)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field18, (value18)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field19, (value19)))
 
 #define EFX_INSERT_FIELDS64(...)				\
 	cpu_to_le64(EFX_INSERT_FIELDS_NATIVE(__VA_ARGS__))
@@ -348,7 +352,11 @@ typedef union efx_oword {
 #endif
 
 /* Populate an octword field with various numbers of arguments */
-#define EFX_POPULATE_OWORD_17 EFX_POPULATE_OWORD
+#define EFX_POPULATE_OWORD_19 EFX_POPULATE_OWORD
+#define EFX_POPULATE_OWORD_18(oword, ...) \
+	EFX_POPULATE_OWORD_19(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_OWORD_17(oword, ...) \
+	EFX_POPULATE_OWORD_18(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_OWORD_16(oword, ...) \
 	EFX_POPULATE_OWORD_17(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_OWORD_15(oword, ...) \
@@ -391,7 +399,11 @@ typedef union efx_oword {
 			     EFX_DWORD_3, 0xffffffff)
 
 /* Populate a quadword field with various numbers of arguments */
-#define EFX_POPULATE_QWORD_17 EFX_POPULATE_QWORD
+#define EFX_POPULATE_QWORD_19 EFX_POPULATE_QWORD
+#define EFX_POPULATE_QWORD_18(qword, ...) \
+	EFX_POPULATE_QWORD_19(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_QWORD_17(qword, ...) \
+	EFX_POPULATE_QWORD_18(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_QWORD_16(qword, ...) \
 	EFX_POPULATE_QWORD_17(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_QWORD_15(qword, ...) \
@@ -432,7 +444,11 @@ typedef union efx_oword {
 			     EFX_DWORD_1, 0xffffffff)
 
 /* Populate a dword field with various numbers of arguments */
-#define EFX_POPULATE_DWORD_17 EFX_POPULATE_DWORD
+#define EFX_POPULATE_DWORD_19 EFX_POPULATE_DWORD
+#define EFX_POPULATE_DWORD_18(dword, ...) \
+	EFX_POPULATE_DWORD_19(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_DWORD_17(dword, ...) \
+	EFX_POPULATE_DWORD_18(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_DWORD_16(dword, ...) \
 	EFX_POPULATE_DWORD_17(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_DWORD_15(dword, ...) \

