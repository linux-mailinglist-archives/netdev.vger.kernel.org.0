Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27D44E8C8F
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 05:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiC1DYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 23:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbiC1DYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 23:24:07 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6484E3A7
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 20:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648437743; x=1679973743;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p+h1oivIR3JiGZeWs2WtlJQOxhZW0JwjvD74p9r4VO0=;
  b=dAxzTeFgJ065Fwhlq3Yq++YvnRIfvXEu/XPf6N4uRtsOxrvR5uqt8tVv
   XUyfPHU9UVmkPgDWwL773bYBwZrM8LBiH4Kupw+Tle87nCe+PhveMu1Xw
   eh5MI/dJ63qtAskmnVzJVEv710tJCgLjupteMw013ZZvJ0kLy5rSLy3Ho
   3uxBaCmY2vyJcEUwvOyAc9kJB/j3kgdkwKHJXOGSiCZkyjU3t8a4vdfhd
   WJyQhEanZZYGwwpVxtMxcMTTmBrlxpmYbylwY3uIhhmQI6F/Y2WzsgNcF
   OWtYIasARlXDyU6KwfJx3rJhVauynvyypaXZsvWPz/3aBXRK7VSX9blqb
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="308361804"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 11:22:22 +0800
IronPort-SDR: +mvhFsXihbu3lP5DPCLu/MmXkN8+6mmaCZ428wBxWnYmu0RGk8rFLVRT3xX5Xw15BUrXCy4tNH
 9S2Ejv6FsavKf9IhvgTawDIdnomWNx5M1IITfpu4UT5HvDQ8xOfd2fi6+lURFYHF1UijNmHdIp
 AtVU44VhkZXbPTuOYsO7XY3574/PPxwRkFgO5BGxQQwc2yl4PQh3N+XxdFltE4YM80vEzvYaFx
 zcut3fkQZe8Myc4qRbO6X92DtGIpbm5w/aXmhwWuRWHhlmzXH/CH0+bBkuc/YBs22yF0d5ofSB
 AhYtXv8BCOQGM+ia7msHR4Pm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 19:54:08 -0700
IronPort-SDR: D2kgff5epVwxffrfM4q4LlACf028TYfF+Vscpk8W0IiDFJPfFPT8cbAY+p4Fx8aR9GYDPUquGl
 z0iuDrMQ8e8hwEz1bJZESR1hAGECHzaoJqoOSBhLitOoXRzBsm6c8kAYE59+MLJLPNFlTd3nk9
 FhuE9dLVUPZ3YjveULCN7pu521ikBvh8n5/8okQkncNE1Gd8JCyPjq5O6O89nYwwCrGKFICxX5
 3/IRBSh0w9swroUES8F30Rqyd2fJPF7f0bHGoa4K7ngbgD/4Oa9PPQgyTga9VwwPmhy8Sf4ELJ
 8BQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 20:22:22 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRdKp3mGYz1SVp0
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 20:22:22 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:x-mailer:message-id:date:subject:to:from; s=dkim;
         t=1648437741; x=1651029742; bh=p+h1oivIR3JiGZeWs2WtlJQOxhZW0Jwj
        vD74p9r4VO0=; b=eLkMM6zCAacZyZ+sA1Wdk4MhAUUVtbXGqm0lcO6CFlpf28Wc
        ca3UOZAnqEQYSLC5ZCJEonw4BHFIuUOwNwJj0KqTfdwCCCOKQdQybKbr/olDJb/L
        pwMrY0mPZAxqMF9g5OV4+L+foExIxvk6mazL0t4vEJYkU4Fb3ub/riexoSDf9ciz
        3KlWJrlCuTyGUynpMrPgfbkKrNiuT7xjj8JebDUGhhw5r92LddKTDkZcSy723Z7r
        bGcfqbU8VPZzunYkZPbGex4JAKFalAqLA+nw+BudcKvEJgW4n4jEfOf4TpKROqJm
        4xlpiSOHCSAReHIYS+OVF5I5xNAHb9lSUqNJlA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id u20Znpo9sBMW for <netdev@vger.kernel.org>;
        Sun, 27 Mar 2022 20:22:21 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRdKn0ZL6z1Rvlx;
        Sun, 27 Mar 2022 20:22:20 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH] net: bnxt_ptp: fix compilation error
Date:   Mon, 28 Mar 2022 12:22:19 +0900
Message-Id: <20220328032219.164225-1-damien.lemoal@opensource.wdc.com>
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
the calls to ptp_find_pin() to fix this compilation error.

Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_ptp.c
index a0b321a19361..3c8fccbb9013 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -390,7 +390,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
 		/* Configure an External PPS IN */
 		pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
 				      rq->extts.index);
-		if (!on)
+		if (!on || !TSIO_PIN_VALID(pin_id))
 			break;
 		rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
 		if (rc)
@@ -403,7 +403,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp=
_info,
 		/* Configure a Periodic PPS OUT */
 		pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
 				      rq->perout.index);
-		if (!on)
+		if (!on || !TSIO_PIN_VALID(pin_id))
 			break;
=20
 		rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_OUT);
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

