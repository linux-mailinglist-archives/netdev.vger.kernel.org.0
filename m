Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B90F5E32
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 10:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKIJGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 04:06:13 -0500
Received: from mout.web.de ([212.227.15.4]:60183 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfKIJGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 04:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573290365;
        bh=HJqqvOPiLrBZhZlGpdiUIZoAA6i9aylcFpOm0pxa0y4=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=Iw40WaYpq+WCmGktF6ar3LpEFcdcS+VItZXzCAJUVpmQQXMALz11LOan9VIG5M2Sv
         LMZgB6syYfvypKUU5+o01/pah7MC4SgrH3pdlX1z3t904rOpppfOJa6P0cq3OtnzeB
         sIDbS/P7wHzm1OzN+6/ZaTVHhXyzwJCZwPijPHw8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.82.67]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MCZTG-1ibePu3Pms-009NIN; Sat, 09
 Nov 2019 10:06:04 +0100
Subject: [PATCH 3/3] fsl/fman: Return directly after a failed devm_kzalloc()
 in mac_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <8ffc16a2-62cc-f948-e11b-55bae1d6aae4@web.de>
Date:   Sat, 9 Nov 2019 10:06:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eLIXJeDSxsn/QQdSB2uFUJVZ6LS8AYKedpK+I/+HDllWZmjgIqu
 MgBFt51wz25TKWTP5yGGAfPt7QWFjXSY4qx6MICNpkBW6vuVjiveWVJhw+whrVDsk9hnjWL
 pJpxX+iHNhak5SaYci5QxoKzL37Q08VcvxVh8tL5oh4kEM4YJaWtjTaEmyA5/7OvRS/WS9e
 PTsVi/3VLXDugPOJ39Ngw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZMs4svgeo8Q=:JeiHgeqUkIyjqk+cjSLHik
 P8w1zMdyPDHMLh/ysyUhA6Bgui8xDi1fvzHHS4hLT7CqoHsKxCDyGTUftVVjFJtWnF8G9hdP8
 7MVv5zvkArClvN75IP4t+rw5Y1bE+eclxqDdeExiN+XFvCJHLCxyrjlUaiCgDdsSV/s7r0T3J
 vnf7GugR2Yeamx2Uo784CtZgsTMd8k9EIAYEZTgLaYN0/LFtJaxKvg/24l/kOnSzsB8/0fkzZ
 +5BFRWI7mK14MfiFhjfaMAp5QHvoVhNYPKxcWCKmpVE8mfPReGY3dV1rxenfbWvMhG4I7iVSc
 NG/CDzMhhnIrKDNlLOnmNmnpcbMu4JHFEgP4D+MWOxReSd0QcItDUyxXglpr2zTp6jK5hfxpo
 nbAE2aiDr5EEKrKLTpwD0530AiAawqZPJwsta7PPDfelO+S20CIkx3tFsPWbr+rBNtFY06gSA
 LrPQBHhD4vn9soc0Eyl77sV2gLXlCncaKLcqWsi3chCHqEQJol/ilvMGUuRjN2DGN4hd/h9DU
 PgqUjogKdzOJKE6dM160vkuFrt2ElSCvWlr8aiwTMyq0MW7+5sKBPdePFR9zo4PGY4brSWtHt
 V5yMvqkdlTwB55BBNRUu4ex4JxfKt0t+xL6RRwb2CdDOGydkMxFH9Qa4WGesz9FkVeABFAPCR
 nyCacuqbmW8ZCUbGNEHD8CNEvXfHjRPMVBbNK7eFXCGc0iU9omYY8dauBlNwSxAzIJ73PhANo
 1rDoNORchiTFtv0KHVM+0yK/8rgiUPS4Gsmi92cMc8bI0/bi2PZfnSIKxqhcaJtiyTJKjhqtS
 KPqDVzcmzVcGvbpAECBe89UTrxhIbtDI3zuUl52TS1SWE9KDbgxQZBvFGcVvguWz31+aIRyzi
 r1XSPZMy4rq+QHN7/MtlqhxlQ/9cnOsZQYXTd34nGvnNuxH2iZS0ewzppZOkekEakibBKOZXP
 wVD+xJn3U/yR/uRP25XvXiFqUeiErCxXDgazvLTdghZGi8AfJ+YuKMO/Yy4zVcUSVl2kz1uiG
 rNhX6m4rTt2mchmqli7tzfV1whPwEHa2cu+FxhHm6lIaqsBlt55jo+2Knpmx6ZrDCW57vYoVb
 NpV6nzX35i9Ttt799i+8FACwH/o9CLZ3tP9MzaWJ2cENq2VB4HsuhixW1Bt+FDaT6q4ihdnHi
 BMf5G7D52Bd4u2VlmpfBu0eH3cIsDDKbZQDqQUrtd7RC7/LNmjfGPEFfz/05tUtp8IHUgLN8X
 geMewjKppsR6/nQM3EtaCnU0pVuC6FGtCcuCkTOZ1Cqy8wpvBIBj78oqmbyc=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Nov 2019 09:26:12 +0100

Return directly after a call of the function =E2=80=9Cdevm_kzalloc=E2=80=
=9D failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/ethernet/freescale/fman/mac.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ether=
net/freescale/fman/mac.c
index 7fbd7cc24ede..75614e2ebda3 100644
=2D-- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -614,15 +614,12 @@ static int mac_probe(struct platform_device *_of_dev=
)
 	mac_node =3D dev->of_node;

 	mac_dev =3D devm_kzalloc(dev, sizeof(*mac_dev), GFP_KERNEL);
-	if (!mac_dev) {
-		err =3D -ENOMEM;
-		goto _return;
-	}
+	if (!mac_dev)
+		return -ENOMEM;
+
 	priv =3D devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		err =3D -ENOMEM;
-		goto _return;
-	}
+	if (!priv)
+		return -ENOMEM;

 	/* Save private information */
 	mac_dev->priv =3D priv;
=2D-
2.24.0

