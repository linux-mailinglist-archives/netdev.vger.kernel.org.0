Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F059011C0D6
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfLKXxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:30 -0500
Received: from mout.web.de ([217.72.192.78]:59813 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbfLKXx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108388;
        bh=QrCQqilrTouTgYj7yPQjXnTFJOK16++5KJ6q9dqCzuQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OZLDxo+YhfcGWOq2ZjW1XGmkZRwtMEa9B9St7EgXLEOMeHEizbtlijhXFLk/N0qoz
         1+fJdbnjKSi2k+kVhlRJ+Ddd/mmBmYMibz10dF+1OBg6WKTPhoSbiod9KOofyA948D
         emoZkjekJmVExY4VLQIVrf0OqIDqpZSxTWz1g1NQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0MRl5x-1iGpH02iS1-00SxXf; Thu, 12 Dec 2019 00:53:07 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>
Cc:     Wright Feng <wright.feng@cypress.com>, Soeren Moch <smoch@web.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] brcmfmac: reset two D11 cores if chip has two D11 cores
Date:   Thu, 12 Dec 2019 00:52:45 +0100
Message-Id: <20191211235253.2539-2-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Us4gcuk0RbKR4HQNOPkL/oiRL4tAdmkHERdAxq/8Wll6xa5unY6
 vc4ERbkOO1hBhlxdSovkzPZ9KF6ywGdKRjYa7y55CjUt/ifWRWTIps60cr3cl9ahlVyaxpL
 Nq2iiB7gOeo62Y4PROt4/1e7GCvb4gO+errOwi4IcUJX42eqY0n9VdPINUEI8dW7lXJf2ye
 Y8lk7+vzq15It0JcqoSFg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+88Ev/9dDg4=:z2IeWqdpeb4UiDzDXawSBY
 aGmsNDovtHG8mwxFuNhrq9OyZ/gUQOmAMlwyeiqOiyPVeKvbYpHS2WclK7O062I6pN8MQ9Sx1
 Lrk3EG8jTIo6Ba5x7E6hFNkE2JUhdwQ7Z1K6ymRWvLcUK3ANocVW7z3dP2ejwLfzA45hgoPi1
 F5Wokbc3wTCW/W8+HsaYOBz3Ik7EAtpcfFYqyqRrw/kCb/L9nI91b407JafIRdnt/duekI6sq
 X8mHk07N6xi3McZ/dWZUilbZtNjFx0/B7kVt5RqhTrci+V0fPZDqr8BJf9VjhzIDNFRW1PGYt
 b2HGNFBGluMKTldZNDT8phfSSIss1QfXdyMarIlZmMgXGvA/MLeQWfNQXlf6g5MFc5ve4TFnI
 QeAToxom+TMk/gj8D243yCeDGpIIdWvOvDqYhoJDlR+ibB8bpwy47rlVufYIB1yWm+iV7UlYZ
 RvcSS72+FN7QSNP4EkU0CKuSv9btbKC1tqWm2jgTeqWQAnQnCwX26MoPvjI9+vB/FFYclzVkM
 MksltDd3e6/MIHxNMPSVwHBomyucLipRt2jgMSgL8gUifILepUSLN9oDAUIudTOfMb3b1p2oM
 U5n8Z8Lh8ABCnFlb+6CG0miBqC2HrSTgvmaM2onU5MRHSCUopNuiyk83DdU9CCkgYT639e0O7
 L8XcjRvSa0TxsUu3h+0JdOu1BDpD4ZlckIvTXU+5UmEFCUokIeoRN4scySgqaINUOlAk5kB8+
 Q9BKn/9VgwWMfQYAwBdcsR/SpqdspfkCT7b5SarpkvQzHU3x7npAHgQZ2bIy37vf/d32lDufe
 dLPvVjb5ZhulNO5nTrWfe6jIvNdxBXCMR24ODnJ85EXh0RHJy1sV2j5zf8VXeh/2e7i34Gw4U
 2R4jE3mwPBIKKZp6mUa5dE1DVyCGE7Pw10cVbAe2a4c5vhd/I24f7w55RFChaNLGEhXG7J/Bq
 lRsI+1yABHbXTL28NG8zSLRboH9GN9gpfZreuzSZEPThPKv2QW9lzUs6gN3sNHYxdIs/rYpte
 nsCQ4rY5l9gAslr1HMDnnbPujEkpM3/bBS5aJ9TChVjVs/BNfDv6mCB5IJ2KCggfoIPRhQRFG
 uqCE/eToDktOZ1czy6n/wQyM3yTWFH5zu0gr54Gu5MHpHv4hx3A0M+uVM+9lzeLaHI9ore98M
 fDZU3r2s0muCJ7UC1rNn+e+zQ5ZQAPnzrQUADrdWJaJdtexNlcig2I+VuvRxnFLfTwFgXq1t9
 di3sCBWONCqTgyshjaj1kaT2cFCc/oDCh/9NYVQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

There are two D11 cores in RSDB chips like 4359. We have to reset two
D11 cores simutaneously before firmware download, or the firmware may
not be initialized correctly and cause "fw initialized failed" error.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Soeren Moch <smoch@web.de>
Reviewed-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
=2D--
changes in v2:
- add missing s-o-b
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
 .../broadcom/brcm80211/brcmfmac/chip.c        | 50 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  2 +-
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a795d781b4c5..0b5fbe5d8270 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -433,11 +433,25 @@ static void brcmf_chip_ai_resetcore(struct brcmf_cor=
e_priv *core, u32 prereset,
 {
 	struct brcmf_chip_priv *ci;
 	int count;
+	struct brcmf_core *d11core2 =3D NULL;
+	struct brcmf_core_priv *d11priv2 =3D NULL;

 	ci =3D core->chip;

+	/* special handle two D11 cores reset */
+	if (core->pub.id =3D=3D BCMA_CORE_80211) {
+		d11core2 =3D brcmf_chip_get_d11core(&ci->pub, 1);
+		if (d11core2) {
+			brcmf_dbg(INFO, "found two d11 cores, reset both\n");
+			d11priv2 =3D container_of(d11core2,
+						struct brcmf_core_priv, pub);
+		}
+	}
+
 	/* must disable first to work for arbitrary current core state */
 	brcmf_chip_ai_coredisable(core, prereset, reset);
+	if (d11priv2)
+		brcmf_chip_ai_coredisable(d11priv2, prereset, reset);

 	count =3D 0;
 	while (ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) &
@@ -449,9 +463,30 @@ static void brcmf_chip_ai_resetcore(struct brcmf_core=
_priv *core, u32 prereset,
 		usleep_range(40, 60);
 	}

+	if (d11priv2) {
+		count =3D 0;
+		while (ci->ops->read32(ci->ctx,
+				       d11priv2->wrapbase + BCMA_RESET_CTL) &
+				       BCMA_RESET_CTL_RESET) {
+			ci->ops->write32(ci->ctx,
+					 d11priv2->wrapbase + BCMA_RESET_CTL,
+					 0);
+			count++;
+			if (count > 50)
+				break;
+			usleep_range(40, 60);
+		}
+	}
+
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
 			 postreset | BCMA_IOCTL_CLK);
 	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
+
+	if (d11priv2) {
+		ci->ops->write32(ci->ctx, d11priv2->wrapbase + BCMA_IOCTL,
+				 postreset | BCMA_IOCTL_CLK);
+		ci->ops->read32(ci->ctx, d11priv2->wrapbase + BCMA_IOCTL);
+	}
 }

 char *brcmf_chip_name(u32 id, u32 rev, char *buf, uint len)
@@ -1109,6 +1144,21 @@ void brcmf_chip_detach(struct brcmf_chip *pub)
 	kfree(chip);
 }

+struct brcmf_core *brcmf_chip_get_d11core(struct brcmf_chip *pub, u8 unit=
)
+{
+	struct brcmf_chip_priv *chip;
+	struct brcmf_core_priv *core;
+
+	chip =3D container_of(pub, struct brcmf_chip_priv, pub);
+	list_for_each_entry(core, &chip->cores, list) {
+		if (core->pub.id =3D=3D BCMA_CORE_80211) {
+			if (unit-- =3D=3D 0)
+				return &core->pub;
+		}
+	}
+	return NULL;
+}
+
 struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *pub, u16 coreid=
)
 {
 	struct brcmf_chip_priv *chip;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index 7b00f6a59e89..8fa38658e727 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -74,6 +74,7 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
 				     const struct brcmf_buscore_ops *ops);
 void brcmf_chip_detach(struct brcmf_chip *chip);
 struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *chip, u16 corei=
d);
+struct brcmf_core *brcmf_chip_get_d11core(struct brcmf_chip *pub, u8 unit=
);
 struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *chip);
 struct brcmf_core *brcmf_chip_get_pmu(struct brcmf_chip *pub);
 bool brcmf_chip_iscoreup(struct brcmf_core *core);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index f64ce5074a55..7ac72804e285 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -78,7 +78,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fw=
names[] =3D {
 	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 };

-#define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
+#define BRCMF_PCIE_FW_UP_TIMEOUT		5000 /* msec */

 #define BRCMF_PCIE_REG_MAP_SIZE			(32 * 1024)

=2D-
2.17.1

