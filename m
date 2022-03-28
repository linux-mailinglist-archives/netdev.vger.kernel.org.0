Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149B74E8E2C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbiC1G27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237786AbiC1G25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:28:57 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F014E3AE
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648448837; x=1679984837;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BXoVCkbweg9ELOJcOS95rUUWgqGlHBdxohNEUGD+EJ4=;
  b=Zm2bwv5bVZAHhO6Xsn+u17oBhYP64j/6wNVNA92VKR6b7WerlZiI3ODB
   nzUVu3AdYWruFn+0JZyttEHwqTcZoVoMUrgEYO8LuNIBh0hsRBNZtupwk
   8x/uJcCa0OIau4Lw275W49iAmNxmmv8yAXwsh1qB00y6jlPRM39/Q9D6D
   4Ykw2s2BnWOJamovcF7lnUgeb8jmOlMA3IFt5x+0whvnfOBqVB773hJwv
   qV1Ag8rBDhTviUaPfCaTJw+X4HYX6kTH6cpliXeqxE89oR632NfZmkuW4
   JXIM0UGXnspmiBt3pxp6TqDHF4m78kk3Q4lRai9IlRGlUUB/1pDQtUzfL
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="308373849"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 14:27:17 +0800
IronPort-SDR: //N1+1HuzDrzKX+HR9QcheVIBdqJsXq00VAcHkt2DLmbZzbh+ZmvFuFtv+BdhTiOQa45KlWHdz
 GjeN+3wxB0mXh9woiCvnGr8GCkMhwCgT4nlYIZZIWJrVfcUbUgt3lL/9Dej5KgWVEZHPpfVCaP
 38/f7hicZ6YOvTXIBw1UXU7c0XGv2GC8tWXkDmKKxQg/yx9WivrxQymiHaeyGwOFvaruxErsyg
 qL60d7KupGD+o1S22ZY7uvq6lp6MAo/5P/tipA1rr8Y6z/2+zfddqXw0+0NRshIPQb311A2N14
 5NiKvbtjY5HMzNYvheOseVIi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 22:58:10 -0700
IronPort-SDR: Ip73hvPvNl6SYHgnlsu6c1CH8saH+d9Ans52SFq6HYgqjMbziA7zRRlZ9FwG/VzoN3UZ2LhhS3
 xBhv28n/T81cl+JOx/0UEEqsRlkNXoh0b7g+wmF0bh6zr/w/leTD1u6vxEUZhY+KAapulakUJV
 e6NjzsoG+ITKOrxGVH4PoL3oKWDYD29chj7qAsygvQNUHrnVI/Tanh9jLTsr1/07r1Qj2OQ1pv
 jXLb8+aALtnZ++VLy0VBPxHKeFKMfCgi2giSbbN6l7z+4Xui4J+38mTUkThZDOVbNxbh4XVsfD
 iSI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 23:27:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRjR84Xz2z1SHwl
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:27:16 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:x-mailer:message-id:date:subject:to:from; s=dkim;
         t=1648448836; x=1651040837; bh=BXoVCkbweg9ELOJcOS95rUUWgqGlHBdx
        ohNEUGD+EJ4=; b=bWHHl59/betjqJatg32H71lG2xEL6xJS0iImS8ArFv2Ihs83
        6eo3lX8ZHJ7mEVeM0vTqQAqSAPkjO2Y3fSRqu5ec2iQ+UtDTs4OOX66qrQYp6pPz
        5S2z+bmQ26B5j7ixIBwX2tYK+xuzEdVyD2XA1rjb4tie+McTvRoH2zcdv/DzOG0r
        35uoijzr7By/HizUGrVmElBGyf49Sp1zaK1hjUTvnc05v9Xly8fJe8OhMs3+YMGQ
        tKp7EZ+U53oowrirkX56m0S+K5Zun83E3M1LGr5DpNXO/yfmE00imR7Bg6bHF1r3
        eq00WznJtjcMaevvq/28cOGPEwsjniSQoGyaFQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Acjpq515NnzV for <netdev@vger.kernel.org>;
        Sun, 27 Mar 2022 23:27:16 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRjR71fRxz1Rvlx;
        Sun, 27 Mar 2022 23:27:15 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH v3] net: bnxt_ptp: fix compilation error
Date:   Mon, 28 Mar 2022 15:27:08 +0900
Message-Id: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
CONFIG_WERROR is enabled. The following error is generated:

drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function =E2=80=98bnxt_=
ptp_enable=E2=80=99:
drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
subscript 255 is above array bounds of =E2=80=98struct pps_pin[4]=E2=80=99
[-Werror=3Darray-bounds]
  400 |  ptp->pps_info.pins[pin_id].event =3D BNXT_PPS_EVENT_EXTERNAL;
      |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:20:
drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
referencing =E2=80=98pins=E2=80=99
   75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
      |                        ^~~~
cc1: all warnings being treated as errors

This is due to the function ptp_find_pin() returning a pin ID of -1 when
a valid pin is not found and this error never being checked.
Change the TSIO_PIN_VALID() function to also check that a pin ID is not
negative and use this macro in bnxt_ptp_enable() to check the result of
the calls to ptp_find_pin() to return an error early for invalid pins.
This fixes the compilation error.

Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
Changes from v2:
* Restore the improved check in TSIO_PIN_VALID() and use this macro to
  return an error early in bnxt_ptp_enable() in case of invalid pin ID.
Changes from v1:
* No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigned
  value.

 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 +++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.c
index a0b321a19361..9c2ad5e67a5d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -382,7 +382,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
 	struct bnxt_ptp_cfg *ptp =3D container_of(ptp_info, struct bnxt_ptp_cfg=
,
 						ptp_info);
 	struct bnxt *bp =3D ptp->bp;
-	u8 pin_id;
+	int pin_id;
 	int rc;
=20
 	switch (rq->type) {
@@ -390,6 +390,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
 		/* Configure an External PPS IN */
 		pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
 				      rq->extts.index);
+		if (!TSIO_PIN_VALID(pin_id))
+			return -EOPNOTSUPP;
 		if (!on)
 			break;
 		rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
@@ -403,6 +405,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
 		/* Configure a Periodic PPS OUT */
 		pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
 				      rq->perout.index);
+		if (!TSIO_PIN_VALID(pin_id))
+			return -EOPNOTSUPP;
 		if (!on)
 			break;
=20
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.h
index 373baf45884b..530b9922608c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -31,7 +31,7 @@ struct pps_pin {
 	u8 state;
 };
=20
-#define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
+#define TSIO_PIN_VALID(pin) ((pin) >=3D 0 && (pin) < (BNXT_MAX_TSIO_PINS=
))
=20
 #define EVENT_DATA2_PPS_EVENT_TYPE(data2)				\
 	((data2) & ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE)
--=20
2.35.1

