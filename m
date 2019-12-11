Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF611C0DB
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfLKXxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:31 -0500
Received: from mout.web.de ([212.227.17.12]:40639 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfLKXx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108392;
        bh=UNWwBy4HvMp8NS5BHLEVj6k8eNrJ1QW+53Ygqx3ikyQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fC+reDFWWXrCC1oVsGw4DQ2cGfkh72ux9rGAVkcaHPaAqvApQhggsnIfFOGYk32jb
         6EBEjgep0F9A+dEEHivoHe44RLKCJ+3fsNEZeNO0CLe+pnvi3zalkX/PDYrUan0NZG
         uuwRvwgNSI8U/goq1XXnv0LUBDjbA5OpR7WhU9Zk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0MNcV4-1idZEQ0uXy-007BYG; Thu, 12 Dec 2019 00:53:12 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>
Cc:     Soeren Moch <smoch@web.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] brcmfmac: make errors when setting roaming parameters non-fatal
Date:   Thu, 12 Dec 2019 00:52:48 +0100
Message-Id: <20191211235253.2539-5-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iWY6io2UQ6RIkm2j/nioDi8y8IvMaEyrFJN80SKzmn5lD3C51Hk
 h3/+agnrE46TIzUUZIsWNSG7+jxo/QOQNpX56dWjEcTw05Yp4UChy+Ww/3ueKnCCJ59PoZ5
 tpmmXvLM1lnsJnGCnIzDOkWqJc6SlNH4eAwRxCh7GQEMLIlOvB2HQMc4gcfS5RhSBBlLfIK
 5+/LmDbh3Gx55YpFdC45Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pNccthOUpKw=:z9QcLBPdXM4E7dbreh5KhI
 LbeK3P1yhdftZzuhI+R0FUJFoGiC4b6ano7oqYIsLK/N2nEj6o6crBfkW1A0kW4MzGvnEkkGO
 T4/Yj7rQh0lwFjY+PAHk11lU7gWKYy3dzF9ykEzUfYFPCWCLlFGsxlT1P7Qptk12Qp46FhixQ
 vQtI4x1hJB+scZ+MlFV/T1Eq26ClwCRwd2/FNm125HU+fNFXw39nDEtrEqZiARo5wMEwwYz/M
 3Z9bhcOEIftDTWukSx0LqRymqCjT14szC29OgLXyZqjNAopuF1aD1w0ArLlVpRJzrXWrjTJr/
 QAygyLWbky6ZFgyi8oiqzquFk67bVFjQn/qjswICugFTVrJGmTXUKxtPZ4OnNcWMy8tm75OLP
 z/cYpvtRR64hXUJT7Zii9IKPW8GxxwOnEf7mTJU76JTiUTHbhKPezaF2ykto81DU6Vuc9L0j9
 UyudOga5QCRSlCtyDXQTK2UWSFSC+fgRYA43fkhrdKukQIFM2Dr9f4SiuK3/x7vrS+OWi1T5f
 sW7nA8fSrOrjynGIBPd68jPqGxlpUULc47flahXzMVRPM+frWVoYjDz94MT5fRO9xbvuN9HxB
 guWKwE8k7m3dAUiFx3Y5qD2I0dULfY+WsTtedJk1d6QLAs7ie42tUVeQ0PB7+QLqu5cTftePA
 NQsl28wrGYf0XsJbsrmMxRKvc/rvLOXG/lGm0i2NZu07XRfBpinmjnUrZULzaP8mrNhurml+6
 EGv9SJZYfsvvYfSW9q671TjElYEld5L3IJlK7cQqfYdFWBKVbxfXqM+HTvU9yKAS6XFYC7QWx
 ck6BnF8QaZW9rL63mQ4qmOFqcU7jNLQ2Hmpu6cibJAakOBJVZNTYbQAVMK5K67MUz/6XcaxdB
 mIABZMCdTkF8CV9QJIp1ZHahsRIvYhonr1LhVWLRgE5f1UGO6WfLY04NkoanJIq9FwWQwE7VO
 JPMibERe+SINR2JjvQ+X2rr0xCjeWL990Z91mGxswVqExzYVmCvi0DZEfXHN7axO0PLRcNx5D
 NoGw4gxFqB4fcx4P0BcERfC5Lis0/fixa2MuA8RIQsXP7S8JReCrHqT7jLH+5FHDW5PnYsZQ+
 122BqIJ6oQuH0V8FHCqZg5cN47nQahH+zmj8WvL6tS530j81e0dCqIJZ3GP3m3iINXeHwonFZ
 hHMSM8QtDpTSGMwvSMlfczDxG13IzN4ystrcIrQGXACqC5eA8wJ4qr3UsiRxYorMxm5B5VMA3
 a2scy3jluKvcVFP3w9UQ8co1zL8aS82pC9JqSSg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

4359 dongles do not support setting roaming parameters (error -52).
Do not fail the 80211 configuration in this case.

Signed-off-by: Soeren Moch <smoch@web.de>
Acked-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
=2D--
changes in v2:
- add ack tag received for v1

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
=2D--
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5598bbd09b62..0cf13cea1dbe 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6012,19 +6012,17 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	roamtrigger[1] =3D cpu_to_le32(BRCM_BAND_ALL);
 	err =3D brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_TRIGGER,
 				     (void *)roamtrigger, sizeof(roamtrigger));
-	if (err) {
+	if (err)
 		bphy_err(drvr, "WLC_SET_ROAM_TRIGGER error (%d)\n", err);
-		goto roam_setup_done;
-	}

 	roam_delta[0] =3D cpu_to_le32(WL_ROAM_DELTA);
 	roam_delta[1] =3D cpu_to_le32(BRCM_BAND_ALL);
 	err =3D brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_DELTA,
 				     (void *)roam_delta, sizeof(roam_delta));
-	if (err) {
+	if (err)
 		bphy_err(drvr, "WLC_SET_ROAM_DELTA error (%d)\n", err);
-		goto roam_setup_done;
-	}
+
+	return 0;

 roam_setup_done:
 	return err;
=2D-
2.17.1

