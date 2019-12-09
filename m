Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A130117974
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfLIWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:37 -0500
Received: from mout.web.de ([212.227.15.3]:42269 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfLIWig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931109;
        bh=bFz6YX4yAHkZbnRoHqoZxSLwKz+LEOXF3fG6Kzxcs3A=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=pVYrtWSiqWoJ5K1UWcybSpGOrTuvnqMeRd4OrwpRHYN7jqQtBZ9dmqUfHZdr8H6BH
         dJYRJyb6EXskgNg6p63URUdBqo7gX6cRvwkSyBzP6/4vnwfAEJJz4g9VQdBLMzJyqO
         yvNDNyqfQWhSwyItqq+vNUU1PelkaIyqdApaDAxI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0LxJVq-1hgKy703OU-016tjZ; Mon, 09 Dec 2019 23:38:29 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Soeren Moch <smoch@web.de>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] brcmfmac: set F2 blocksize and watermark for 4359
Date:   Mon,  9 Dec 2019 23:38:16 +0100
Message-Id: <20191209223822.27236-2-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+dzjQ0PK9kldwHz5RcI3u8wnAPujH07JS/ZQfOKkQokbZhaSCwm
 goEu3v+2WTWXhCF7e1w3A2tpARBI6qUsUZuWwztQjbDEszdS7zN2wXM08uiNW90FwUMvpC3
 NkyIPFIfVUSyFQ+qeDeb2ABhnvN/skShYq29doi8Ye3R9uFj2Dp09AeoPurw0CUThD7c653
 3Ylaf3BYSYTDNsP/1XBJQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nEnfzQbeGnw=:SJ159rY3tN+qhzjK7Oe+am
 Ytdp9wi05rk4PWR8ztDfAUDILQi4N1o+jKXtamqUZ6aslRMMeSygK7kYEWegkcqCuEjorwdaW
 Ljvd032K+ipnf6K0Fe10Vd88VvZu26N24NnSnAbm97iwkwcbkO+iedX98MxVQnMxduTNEoMw8
 DPQusTzNt2UBYRyhsjtkMiTZ2q1C58elVdeykSaUbKM/3I8COJXGI23iKUE5bfrFncx6Y+KfP
 PeFNZEMaRL23oDgOsKFwSU38sCYDMiO3O2hkJApTY4Mm8rwwrpXPBxwiIMfND9eTHra6N4wgF
 uNTqgxLSsNdbJqmPyf1AqDxm+/Ae1FpuafDxPbylDS6mo8w7APX/O1AX6XnVZq8TLcejLKP1n
 TEPaQD7JYQl4Xl+X4f1hJmEloaL4pVVxBds0kTJ6Syx21r+/LvPceXpfsuavUtu92M3damJiM
 l/71zgR+W9ADWsFb+6yicp5ndwl3KsddLXZWMzIK2SbS+2DUdcm7vejaEKzgscbNr0+e67On5
 oxbJRBbH54D/grP9KWe+18GyZ96dbTr4lMMpo6f4J108ah6H/HwOmTVygRKMfhSchmOS1o26K
 Ivyq2JixGuS5FUzbJnYkcpTOK0DwlC8n4zxjC5GwVQZKu3G4BGWoyhSVNJu/8+V5YcIT2JMqv
 kWi3vmP8L05Emdk04c327932dtI1mK459uAvSBtI7js6+n5p/qZlAD7zAAnHitkhnfBZ2TSDq
 Cg+8NMJO8fEz6k+4glw+O7xKV7JkmjYuuJDLVeJgMvZhmCE0U+bHzgL5ief5MN3IxB54pWzld
 sBUvnHjcea3aVLenGHrJgxtgZa0tXDIFclWM8iqvEbVjPImjcdzP2ycYaPniH9a0t5qlJR7J2
 /cgFLFtAjAHKiiZ0Fwsi2C841KW4cZfUN51jxwGk6SXzROMD3f2j6f02+1uTL7jt3HE7SsflA
 070EoZ6wN4RWQ5INsbi71zJqdtRO/DDkAXlBs5nAcbH52CAlEKvujcXqZ/72L8i2706n/F31p
 9biPxHiDi7sEm8WZA70ryO+R22qxZLwsUQnLzxz2go8P8N7a8iof+ATbiwJvh2BMRlEKkPo92
 bTykF5mnGh5rWpguFpUaIo9GSTY/9kSyGGzLo00qS1xO4kKFcXHsNvOU4qFm+amnTyRmQYTlb
 VYROUHgZj9b9XfoZnSSvSw409Ejz4uDLUmPBJ7HgoynIL6BAZMg63Ws6nMAXsdRKiGImgO80r
 gO37RMZr6LRRuAshZYYWFogbdNPj5qnBaDDHFpw==
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
=2D--
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
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

