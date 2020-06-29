Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96420D7A8
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgF2Tbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:31:33 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47086 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733177AbgF2Tba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:31:30 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 34EDF20CF8A
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:33:12 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 23762200C3;
        Mon, 29 Jun 2020 13:33:12 +0000 (UTC)
Received: from us4-mdac16-19.at1.mdlocal (unknown [10.110.49.201])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 214CE800AC;
        Mon, 29 Jun 2020 13:33:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BBCA940074;
        Mon, 29 Jun 2020 13:33:11 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 84911B8006B;
        Mon, 29 Jun 2020 13:33:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:33:07 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 03/15] sfc: extend bitfield macros up to
 POPULATE_DWORD_13
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <a432d457-6136-108c-3219-ce9a4eab5349@solarflare.com>
Date:   Mon, 29 Jun 2020 14:33:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-0.644400-8.000000-10
X-TMASE-MatchedRID: IaDj/CwBGkih9oPbMj7PPPCoOvLLtsMhS1zwNuiBtITfUZT83lbkEAid
        INLNE1czYsi/CGTOU7oH4jvnDtS/yk1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFq0d
        akSns8uxDQ6jxiGAHkTYmwFPk7aAp8sOk5pR5VoH+UJZvzAppPzxqD1MnV7qQxPXOELcIGUDojI
        xSzT2kYPQdta9/cW4LWswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eWeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.644400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437592-NRCiPBBLJU5n
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/bitfield.h | 34 ++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
index 1b59e9fe58b4..2590cab53e54 100644
--- a/drivers/net/ethernet/sfc/bitfield.h
+++ b/drivers/net/ethernet/sfc/bitfield.h
@@ -282,7 +282,10 @@ typedef union efx_oword {
 				 field7, value7,			\
 				 field8, value8,			\
 				 field9, value9,			\
-				 field10, value10)			\
+				 field10, value10,			\
+				 field11, value11,			\
+				 field12, value12,			\
+				 field13, value13)			\
 	(EFX_INSERT_FIELD_NATIVE((min), (max), field1, (value1)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field2, (value2)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field3, (value3)) |	\
@@ -292,7 +295,10 @@ typedef union efx_oword {
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field7, (value7)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field8, (value8)) |	\
 	 EFX_INSERT_FIELD_NATIVE((min), (max), field9, (value9)) |	\
-	 EFX_INSERT_FIELD_NATIVE((min), (max), field10, (value10)))
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field10, (value10)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field11, (value11)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field12, (value12)) |	\
+	 EFX_INSERT_FIELD_NATIVE((min), (max), field13, (value13)))
 
 #define EFX_INSERT_FIELDS64(...)				\
 	cpu_to_le64(EFX_INSERT_FIELDS_NATIVE(__VA_ARGS__))
@@ -334,7 +340,13 @@ typedef union efx_oword {
 #endif
 
 /* Populate an octword field with various numbers of arguments */
-#define EFX_POPULATE_OWORD_10 EFX_POPULATE_OWORD
+#define EFX_POPULATE_OWORD_13 EFX_POPULATE_OWORD
+#define EFX_POPULATE_OWORD_12(oword, ...) \
+	EFX_POPULATE_OWORD_13(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_OWORD_11(oword, ...) \
+	EFX_POPULATE_OWORD_12(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_OWORD_10(oword, ...) \
+	EFX_POPULATE_OWORD_11(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_OWORD_9(oword, ...) \
 	EFX_POPULATE_OWORD_10(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_OWORD_8(oword, ...) \
@@ -363,7 +375,13 @@ typedef union efx_oword {
 			     EFX_DWORD_3, 0xffffffff)
 
 /* Populate a quadword field with various numbers of arguments */
-#define EFX_POPULATE_QWORD_10 EFX_POPULATE_QWORD
+#define EFX_POPULATE_QWORD_13 EFX_POPULATE_QWORD
+#define EFX_POPULATE_QWORD_12(qword, ...) \
+	EFX_POPULATE_QWORD_13(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_QWORD_11(qword, ...) \
+	EFX_POPULATE_QWORD_12(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_QWORD_10(qword, ...) \
+	EFX_POPULATE_QWORD_11(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_QWORD_9(qword, ...) \
 	EFX_POPULATE_QWORD_10(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_QWORD_8(qword, ...) \
@@ -390,7 +408,13 @@ typedef union efx_oword {
 			     EFX_DWORD_1, 0xffffffff)
 
 /* Populate a dword field with various numbers of arguments */
-#define EFX_POPULATE_DWORD_10 EFX_POPULATE_DWORD
+#define EFX_POPULATE_DWORD_13 EFX_POPULATE_DWORD
+#define EFX_POPULATE_DWORD_12(dword, ...) \
+	EFX_POPULATE_DWORD_13(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_DWORD_11(dword, ...) \
+	EFX_POPULATE_DWORD_12(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFX_POPULATE_DWORD_10(dword, ...) \
+	EFX_POPULATE_DWORD_11(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_DWORD_9(dword, ...) \
 	EFX_POPULATE_DWORD_10(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
 #define EFX_POPULATE_DWORD_8(dword, ...) \

