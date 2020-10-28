Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB63129E077
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgJ1WEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54146 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729446AbgJ1WA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:00:59 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EA2E867945
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:43:22 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 85B1D20098;
        Wed, 28 Oct 2020 20:43:22 +0000 (UTC)
Received: from us4-mdac16-30.at1.mdlocal (unknown [10.110.49.214])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 823F8800A3;
        Wed, 28 Oct 2020 20:43:22 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 19C9F100084;
        Wed, 28 Oct 2020 20:43:22 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D67EE980053;
        Wed, 28 Oct 2020 20:43:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct
 2020 20:43:10 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/4] sfc: extend bitfield macros to 17 fields
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Message-ID: <de47abe4-0c18-ee1e-d416-4eb43420ecfd@solarflare.com>
Date:   Wed, 28 Oct 2020 20:43:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25752.003
X-TM-AS-Result: No-0.200600-8.000000-10
X-TMASE-MatchedRID: IaDj/CwBGkih9oPbMj7PPPCoOvLLtsMhS1zwNuiBtITfUZT83lbkEAid
        INLNE1czYsi/CGTOU7oH4jvnDtS/yk1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRuwihQpoXbuXF9gJ
        RKKmdMvAKVknUlWL0b0DhGWK9XcHC2ytBDd4+Mds5wZbPUYZ/6Sn8JiSKXvOO+V2K1rcdQhwKFU
        Y3f4qbH8TU638kzZn/WswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eX6svlVb6h9lw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.200600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25752.003
X-MDID: 1603917802-ginNgY3Uev56
X-PPE-DISP: 1603917802;ginNgY3Uev56
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need EFX_POPULATE_OWORD_17 for an encap TSO descriptor on EF100.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/bitfield.h | 42 +++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
index 2590cab53e54..64731eb5dd56 100644
--- a/drivers/net/ethernet/sfc/bitfield.h
+++ b/drivers/net/ethernet/sfc/bitfield.h
@@ -285,7 +285,11 @@ typedef union efx_oword {
 				 field10, value10,			\
 				 field11, value11,			\
 				 field12, value12,			\
-				 field13, value13)			\
+				 field13, value13,			\
+				 field14, value14,			\
+				 field15, value15,			\
+				 field16, value16,			\
+				 field17, value17)			\
 	(EFX_INSERT_FIELD_NATIVE((min), (max), field1, (value1)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field2, (value2)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field3, (value3)) |	\
@@ -298,7 +302,11 @@ typedef union efx_oword {
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field10, (value10)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field11, (value11)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field12, (value12)) |	\
-	 EFX_INSERT_FIELD_NATIVE((min), (max), field13, (value13)))
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field13, (value13)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field14, (value14)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field15, (value15)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field16, (value16)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field17, (value17)))
 
 #define EFX_INSERT_FIELDS64(...)				\
 	cpu_to_le64(EFX_INSERT_FIELDS_NATIVE(__VA_ARGS__))
@@ -340,7 +348,15 @@ typedef union efx_oword {
 #endif
 
 /* Populate an octword field with various numbers of arguments */
-#define EFX_POPULATE_OWORD_13 EFX_POPULATE_OWORD
+#define EFX_POPULATE_OWORD_17 EFX_POPULATE_OWORD
+#define EFX_POPULATE_OWORD_16(oword, ...) \
+	EFX_POPULATE_OWORD_17(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_OWORD_15(oword, ...) \
+	EFX_POPULATE_OWORD_16(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_OWORD_14(oword, ...) \
+	EFX_POPULATE_OWORD_15(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_OWORD_13(oword, ...) \
+	EFX_POPULATE_OWORD_14(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_OWORD_12(oword, ...) \
 	EFX_POPULATE_OWORD_13(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_OWORD_11(oword, ...) \
@@ -375,7 +391,15 @@ typedef union efx_oword {
 			     EFX_DWORD_3, 0xffffffff)
 
 /* Populate a quadword field with various numbers of arguments */
-#define EFX_POPULATE_QWORD_13 EFX_POPULATE_QWORD
+#define EFX_POPULATE_QWORD_17 EFX_POPULATE_QWORD
+#define EFX_POPULATE_QWORD_16(qword, ...) \
+	EFX_POPULATE_QWORD_17(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_QWORD_15(qword, ...) \
+	EFX_POPULATE_QWORD_16(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_QWORD_14(qword, ...) \
+	EFX_POPULATE_QWORD_15(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_QWORD_13(qword, ...) \
+	EFX_POPULATE_QWORD_14(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_QWORD_12(qword, ...) \
 	EFX_POPULATE_QWORD_13(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_QWORD_11(qword, ...) \
@@ -408,7 +432,15 @@ typedef union efx_oword {
 			     EFX_DWORD_1, 0xffffffff)
 
 /* Populate a dword field with various numbers of arguments */
-#define EFX_POPULATE_DWORD_13 EFX_POPULATE_DWORD
+#define EFX_POPULATE_DWORD_17 EFX_POPULATE_DWORD
+#define EFX_POPULATE_DWORD_16(dword, ...) \
+	EFX_POPULATE_DWORD_17(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_DWORD_15(dword, ...) \
+	EFX_POPULATE_DWORD_16(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_DWORD_14(dword, ...) \
+	EFX_POPULATE_DWORD_15(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_DWORD_13(dword, ...) \
+	EFX_POPULATE_DWORD_14(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_DWORD_12(dword, ...) \
 	EFX_POPULATE_DWORD_13(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_DWORD_11(dword, ...) \

