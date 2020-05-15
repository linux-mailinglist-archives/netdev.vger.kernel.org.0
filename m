Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983671D4DD7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgEOMiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 08:38:11 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:57319 "EHLO mx01-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgEOMiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 08:38:10 -0400
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx01-sz.bfs.de (Postfix) with ESMTPS id CA71220320;
        Fri, 15 May 2020 14:38:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1589546287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppKbetCczRPxYojNsxLooBtfmJ0vphP053kEHBki1gc=;
        b=yJV5DF337dYDB94SlXzGeeSFtM+t+kyXBFEewX47UBZfxzEcN/7vzS8ERu/uF+ARN0mir8
        1Gpd3fCY1Ju0o7q+MYxFvdiw4Mw6oUHflbXBRmo7FYG6VNIEM1JPMBxe74BaatGPQw4TCC
        UJ85rW2eVH6LNRANJs/AIsBH6Sp0rJdgZpysHOFnLg71RENfRKBb+OfJr3FLksAtbbNWH5
        isvPevS/Ruk53abXa7SPrNny9cnmxS/HBsWO+7xcOmKMWwWUMvC+qktzD0wYX7lfiy0b/o
        0DxzpYDHcWZCnvKigElYLN3kyFCWxQukGSFPu3wDmrmhdmf0EBlUVdW/HRiCyA==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1913.5; Fri, 15 May
 2020 14:38:07 +0200
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%6]) with mapi id
 15.01.1913.005; Fri, 15 May 2020 14:38:07 +0200
From:   Walter Harms <wharms@bfs.de>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH] rtlwifi: rtl8192ee: remove redundant for-loop
Thread-Topic: [PATCH] rtlwifi: rtl8192ee: remove redundant for-loop
Thread-Index: AQHWKqLOi1fXAItzAU2fpWUNjofas6ipEGuf
Date:   Fri, 15 May 2020 12:38:07 +0000
Message-ID: <73b8d798ffa048418be8443f90a79377@bfs.de>
References: <20200515102226.29819-1-colin.king@canonical.com>
In-Reply-To: <20200515102226.29819-1-colin.king@canonical.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-2.89
Authentication-Results: mx01-sz.bfs.de;
        none
X-Spamd-Result: default: False [-2.89 / 7.00];
         ARC_NA(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM(-0.00)[-0.884];
         TO_DN_EQ_ADDR_ALL(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-2.89)[99.53%]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if someone has same spare time,
this driver need a bit more love ...

SO far i can see in rtl92ee_phy_iq_calibrate:
* IQK_MATRIX_REG_NUM should be used instead 8 hardcoded.
* the for-loop in the beginning is obfuscating that it sets  simply final_c=
andidate

this can be cleaned:
      reg_e94 =3D result[final_candidate][0];
      rtlphy->reg_e94 =3D reg_e94;
      reg_e9c =3D result[final_candidate][1];
      rtlphy->reg_e9c =3D reg_e9c;

only reg_e94, reg_ea4 is used later ?

jm2c,
wh=20

________________________________________
Von: kernel-janitors-owner@vger.kernel.org <kernel-janitors-owner@vger.kern=
el.org> im Auftrag von Colin King <colin.king@canonical.com>
Gesendet: Freitag, 15. Mai 2020 12:22
An: Kalle Valo; David S . Miller; linux-wireless@vger.kernel.org; netdev@vg=
er.kernel.org
Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
Betreff: [PATCH] rtlwifi: rtl8192ee: remove redundant for-loop

From: Colin Ian King <colin.king@canonical.com>

The for-loop seems to be redundant, the assignments for indexes
0..2 are being over-written by the last index 3 in the loop. Remove
the loop and use index 3 instead.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers=
/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 6dba576aa81e..bb291b951f4d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -2866,14 +2866,12 @@ void rtl92ee_phy_iq_calibrate(struct ieee80211_hw *=
hw, bool b_recovery)
                }
        }

-       for (i =3D 0; i < 4; i++) {
-               reg_e94 =3D result[i][0];
-               reg_e9c =3D result[i][1];
-               reg_ea4 =3D result[i][2];
-               reg_eb4 =3D result[i][4];
-               reg_ebc =3D result[i][5];
-               reg_ec4 =3D result[i][6];
-       }
+       reg_e94 =3D result[3][0];
+       reg_e9c =3D result[3][1];
+       reg_ea4 =3D result[3][2];
+       reg_eb4 =3D result[3][4];
+       reg_ebc =3D result[3][5];
+       reg_ec4 =3D result[3][6];

        if (final_candidate !=3D 0xff) {
                reg_e94 =3D result[final_candidate][0];
--
2.25.1

