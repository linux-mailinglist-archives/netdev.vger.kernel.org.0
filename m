Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD964E8CA7
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 05:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbiC1Dh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 23:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiC1DhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 23:37:25 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285D525C4C
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 20:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648438545; x=1679974545;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=We8GvMMfpDS8xroDl4Pf9afZVCIdZAiTbVTz+u/+Edc=;
  b=ddvVL0yoluloduWpMQjYX1wmW5yLlnzBmGUuKLWM1x8j/i3fnFE0sEBa
   zW7capEJY+SpfljrPLVFI4foFinDprhoatvKs6i74yGr7DJN1qBNZBOoo
   WwocbSoUt5mUVMQJGZlkr4WRY7a1uWtIFQpsnNElRx0VRKMBiEHiaAvki
   hcrmATVydDyHBQ2fauuslzheXjJtKIIw+5RuLxxJPJE67Ve5mRNG65pMZ
   wFNhd99KByWiRMNZ97z1auw+jXWOrsoEqofUU8NN9M9EwvrTSbS/p2aNd
   y+TsPhwa/5zsM31LhrW8JItPGuqCmudzRDuVVq2BHwc4Pf6wVDy7Z3NUL
   A==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="300555874"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 11:35:44 +0800
IronPort-SDR: +LZZELDyFQeZ5nxjZW/tdzeFTE6w+28/9dIDCwuYWipl4Wpw6FUeZS59KCC+Jml21sQADxxJbj
 1SKYoMpOtKBLOshIoGc0/gGaMNfCxCZNDo5tt0ADFQwH+Ei9Xhcl4K4SCaQyqRhV30da/aQy35
 cdz331kKUjK4WqL2ZMlaYCJqto2gkCpXHhQZG4rRBTMWL9AlcB9QXfCMAeK44PJNiVtsPphjIH
 3NzqBSpiAo5VkU3aLIwn/WAJ1oBGfIs47p83UNe2oEElk0Qv57nd8AujUnwZeMrWX6XB3u7yjg
 cyqcyGpNf2xLzxKqHpK1Ap6r
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 20:07:30 -0700
IronPort-SDR: +R6M8fwgdpJbdNcmBpHxBu5DDBKpYDVwxuCEh6VSxQqB3mymcFaSgGRjdAoSXSPX/1njVZPRUh
 K119rYUpa5GkfIZDZfhuLe13sxEFY4AZN/VW439SrQ+RzLpSTzNsiKTKKNJDzHrLqnYCDOIl54
 bEbCqdoNT6IiNKnc+/ZA3lLmCnoSAc3BzlNFH8N03C7MY60U9hiXIip6DDL1Bn2PeXOPL1Nf5s
 t/RLe4XCDxk48vE+z1yZ7udFV4jcYE0yryD45PfDIvGg/Mwtjw8w09tU0eDdqZ/+hRR6uwYhkR
 IrQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 20:35:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRddD0y1Jz1SHwl
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 20:35:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:x-mailer:message-id:date:subject:to:from; s=dkim;
         t=1648438543; x=1651030544; bh=We8GvMMfpDS8xroDl4Pf9afZVCIdZAiT
        bVTz+u/+Edc=; b=Z7ENxKpv9cvRCledWVWeGzKnTGin2bfppozK91nm2zk+kd3C
        CCgWqIt1haGtmXX/NKYy+TSDR9SLrKn2+J06HYkqgnyyG97gE7jLJ1rRl5Hhn/EC
        uOY94Uv25gaIVV8DapMCdmplsLeTz2E1ahnCSa9wBEQZmaaOiUox5xDqsDh0iWQQ
        OGkZTg3mdBUJYsbJK0XNvZUrTWPSg/S9dckJYh0T3BYXQyBB2P9+lrNEnhhGVLE6
        n+4llQ5WFYkqFsS9zvce//YuhB3YbZ2PmmVGRQOrgUe581MpyXABHhD1yPIl5E3E
        sjChUBsGfw3iY8poNCD0xL1vzy+sXSdMBBUgGw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GZo1636MrvPP for <netdev@vger.kernel.org>;
        Sun, 27 Mar 2022 20:35:43 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRddB3PVfz1Rvlx;
        Sun, 27 Mar 2022 20:35:42 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH v2] net: bnxt_ptp: fix compilation error
Date:   Mon, 28 Mar 2022 12:35:40 +0900
Message-Id: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
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
Use the TSIO_PIN_VALID() macroin bnxt_ptp_enable() to check the result
of the calls to ptp_find_pin() in bnxt_ptp_enable() to fix this
compilation error.

Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
Changes from v1:
* No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigned
  value.

 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
--=20
2.35.1

