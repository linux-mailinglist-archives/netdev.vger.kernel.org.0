Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CB011C0E1
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfLKXxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:46 -0500
Received: from mout.web.de ([212.227.17.11]:36427 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfLKXxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108389;
        bh=Jw3d/3FG5d2fs3pbP5cmR9tz+imTkB9FfgldNiz16/M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QHfjrJCvhmuCCnSf1F/RiTE3u7NdGsOyiro4sUDoDIQ+BV6PzAODPhHh1Cl7rbGB8
         8g2zq0CxIlQxFOZ0mVoVjj+Q1dN150ZDpr5DsCsqGUV2gw/Iy4detaBikD0SXnkeal
         jfU6VBuWfOIv7zxNJOfScJziWrGpu8ob2L2xUIF0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0Mhlmh-1iJYJC0mhf-00MwBd; Thu, 12 Dec 2019 00:53:09 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>
Cc:     Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Soeren Moch <smoch@web.de>,
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
Subject: [PATCH v2 2/9] brcmfmac: set F2 blocksize and watermark for 4359
Date:   Thu, 12 Dec 2019 00:52:46 +0100
Message-Id: <20191211235253.2539-3-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vMAckOgNBxG6cLi2IX3dVxNnAjzrN9nQcd36iOgEGjn7lSyOXK0
 nMmPQF96FpuS9n/OnUjpHNPcWxW8ctz5fO3ibNoNVUPj3EW+6zvheCwlxSOOoWs2gDf+gmY
 p4EirClUV1rcJdk7pgxNeOvTWz8mX1eiqcst5vCJFqdAHlgxEYhaMFLTEBK2i2tiRaxBzO3
 pyg4nxvbZPxpAHrGgvnZQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Jm6PikBj8do=:bhZOh8ji0Cm3PXLd8vpAhB
 c7KTXi1ITKNxCijfIlhgJKvVQDYDAgkGWFdQSKy8WVmVRRXjzTWL5dkSRcpZbYZT/kCdMcv5E
 cNSQdgYK9OoY0+QUPV9M6+5lAymFlzhjrWU0y/umHkgscJK/l68t/ge+xV3POxR16m3yKl7gd
 T0AU3Mgz18RmHQkB4gvRZQFaVjhOpjZSkEALjU6Iy7ZaupVXQdtoVYtU7YSe/9KFNOlYkj/Qe
 O3mcXMoWArV1bPPx17Q3cKaW2i6ChTMC/jQ72Yvi6YRe0EhXtioF3tmX/LSJ39ooaE4pAImRG
 ndHMqmA/IRXkgv3jlUo15fPBeexloNFrLg3B5pbHm93CtWSEHTVAcBzKAltK62RA5mMEr4+cO
 Y4BXPf/v13ZlWDcYmg1w82o7cNvdfTY8EFaOBLDjqK1jJUescVSc8NRlVyhsoJIPvUcXOzfmU
 WzR3GUagJ3/fyh7xa9+SNFjYsFJHVcQHB3nidL3DRYLpLXFYNKR/n4YJU5ijEFPDW7xkN7t1l
 DWfMyWI1bptx9yK9LIxdqp0fFTQN8cD/qhsYm8bhpwK5Pn6FRvDdGpat8Waa63I0pwwcopikT
 cAsvWGN4c1iPzgGFNE/qOtxMMrqL/l3Hls/oPoSnV4uixQnBxq/Sr5iLaFUiv2pP8z1H88nmb
 AarpNGmk52LtFUOR0qKhO+BbhVIWbXCbb5ZGHxF9GA5nDR3dcRXWmNiUvxCTUYEoU6hFIw8jQ
 8TvU7ShRQGjZP+vkv2XBVSzzui4MdrIRyLF8OZh0UgLbWB9tZY+inDhGDa9InOmK6Zn5mCzKs
 kDs4RY/KRp/OvNeOSDgnGuP3yGa06aWA08lfMkhnGYrbLdRRNvcrXLc2RjcbtD/T1WAGZdD3L
 LFYaaq+YmEHK8+AnSb8rmAbor0ynGp0bLYpo02c3kKEVKToJ4QvjbzROrOmiNYn/bhdxIn2ML
 ku8R3r/eRwZzOMVfVoAR/soNZiV2eXN5VWj5aPvRwpCKiy0Xieo30PYkIvapF8asgJ/IoD9bQ
 1ho9MkOstO/z4yfARCHWHePoYq2FaymEsO0tKpr+J5FMbsC7lPoPoVKvq3FfHUFDbWfyz/j08
 YcpsQ05Po3tDeao9xyk0cO2kZ2kA25ic2TeifPRDQow9ogTTTSYhJCrREBtQ3wljTE9g0MG0L
 9N2Rw16Oitu46gwY4aR3zUIlM6itQMAuZF1Imj1Zrbj2dk1Ha00y/U9Id/PqaUSR1JB4ifYan
 N5MNtNk3cmZwBbpmRKtsp9azFnviVwGUl/Yy3vw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Set F2 blocksize to 256 bytes and watermark to 0x40 for 4359. Also
enable and configure F1 MesBusyCtrl. It fixes DMA error while having
UDP bi-directional traffic.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
[slightly adapted for rebase on mainline linux]
Signed-off-by: Soeren Moch <smoch@web.de>
Reviewed-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
=2D--
changes in v2:
- add review tag received for v1

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
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  6 +++++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 15 +++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/d=
rivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 96fd8e2bf773..68baf0189305 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -43,6 +43,7 @@

 #define SDIO_FUNC1_BLOCKSIZE		64
 #define SDIO_FUNC2_BLOCKSIZE		512
+#define SDIO_4359_FUNC2_BLOCKSIZE	256
 /* Maximum milliseconds to wait for F2 to come up */
 #define SDIO_WAIT_F2RDY	3000

@@ -903,6 +904,7 @@ static void brcmf_sdiod_host_fixup(struct mmc_host *ho=
st)
 static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	int ret =3D 0;
+	unsigned int f2_blksz =3D SDIO_FUNC2_BLOCKSIZE;

 	sdio_claim_host(sdiodev->func1);

@@ -912,7 +914,9 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sd=
iodev)
 		sdio_release_host(sdiodev->func1);
 		goto out;
 	}
-	ret =3D sdio_set_block_size(sdiodev->func2, SDIO_FUNC2_BLOCKSIZE);
+	if (sdiodev->func2->device =3D=3D SDIO_DEVICE_ID_BROADCOM_4359)
+		f2_blksz =3D SDIO_4359_FUNC2_BLOCKSIZE;
+	ret =3D sdio_set_block_size(sdiodev->func2, f2_blksz);
 	if (ret) {
 		brcmf_err("Failed to set F2 blocksize\n");
 		sdio_release_host(sdiodev->func1);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 264ad63232f8..21e535072f3f 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -42,6 +42,8 @@
 #define DEFAULT_F2_WATERMARK    0x8
 #define CY_4373_F2_WATERMARK    0x40
 #define CY_43012_F2_WATERMARK    0x60
+#define CY_4359_F2_WATERMARK	0x40
+#define CY_4359_F1_MESBUSYCTRL	(CY_4359_F2_WATERMARK | SBSDIO_MESBUSYCTRL=
_ENAB)

 #ifdef DEBUG

@@ -4205,6 +4207,19 @@ static void brcmf_sdio_firmware_callback(struct dev=
ice *dev, int err,
 			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
 					   &err);
 			break;
+		case SDIO_DEVICE_ID_BROADCOM_4359:
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
+				  CY_4359_F2_WATERMARK);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   CY_4359_F2_WATERMARK, &err);
+			devctl =3D brcmf_sdiod_readb(sdiod, SBSDIO_DEVICE_CTL,
+						   &err);
+			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
+			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
+					   CY_4359_F1_MESBUSYCTRL, &err);
+			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
 					   DEFAULT_F2_WATERMARK, &err);
=2D-
2.17.1

