Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD011798A
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLIWig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:36 -0500
Received: from mout.web.de ([212.227.15.3]:51455 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfLIWif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931108;
        bh=hipcHuvDt9eDEE26o9CyI1wXasjR+ofQXYS0BLuJXas=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=rHPlgvWbhxhUejXaRk8saa7RjP1QPMIOGleFPpYq33v/HcFG/kqwrK1b02POQ1S6E
         qr05IPU6OM2m/PkPf7lBONO0ifNeO6Ph1/GUE8cOkjudKnTahwWjOIEWVAFCQiG6K3
         aupBoQeoFxvciAStVZy1y3DXGSuiR032sZCo5+Xg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0MhOpG-1iQe9J3DDG-00MaZJ; Mon, 09 Dec 2019 23:38:28 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Soeren Moch <smoch@web.de>, Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] brcmfmac: reset two D11 cores if chip has two D11 cores
Date:   Mon,  9 Dec 2019 23:38:15 +0100
Message-Id: <20191209223822.27236-1-smoch@web.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nMh6JTYQgSoTNLi0I6d+FrTc32tAPA/d8LYaIo5bLuzoFr8EVbX
 50FUXuYTk81yWWwn0OYXUMREg/zwoqjvZz943AaZtJfrWm1vedqiP+VbBuV5nCz3uopjFjc
 UglSbpTRW27/f28QeRqRe5kOzkvzn9yFr9FykLWx3vAqsWST6TQrpYzoacjrmFnXCkcMRRa
 w+tjNwWhxr4iH7OfgWlsA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KV2RewuW+xc=:kyETITqTRSM7xyFhz4LSJ2
 4bV5x0wwWvANPB7nRHyipSpS8FWhqwskj5sRxI+bwF8NKXjoUAfSDg/eXD1zCTwzG/IQQboCN
 UTMa1MQLLdd9heehcjoHlq3g/5NEnsEcZASFWBx092OG9ppgQ0f2m/fVEkTtlNIWgY8W/bkXa
 +cIq00xKeA/YRGQW1vDX4P6a6R0FKsyM6t4gA1lLgRZ04RRHYVXZBn3gvVygWJq0O7CI3mHuf
 aS2Dirsio2o51zX7Xc9c8EjC9qTloD2UCJcoSb2R7e3gnVMMa0c91jmgm+Kqmw07Mt5TzzUGv
 aX0bqThsF74uvXjLUnuq38yXw7n62T3Rh1w/dRE9+woVHb7myfHr9IQMCqFI+D4rCBN8M0deo
 k7ZaVgncBAnZVQd1gvvPcisKUitE6zuMaEkxnaxSlASKk7S1bTP+IDcC8qBAymPyYi3wg8R6P
 bocwovn9FIDVoQ0UuEC5wTszCsjkMrbF2lml5VoYDpXckSDr0yJoU9ed8whTBpOzBYmlExvZT
 TnlIkAL6qh9+1d0hYH/h13fAzJUyphfc29PvFkWcwopW5WxX4baVpriA2xtB4IJQqgwVJ/nxB
 GdXrd2bC2HAMGz4L2joWjdnVy7+iCjYUezUq+uCjuZi62mutDyJ1RpiMwI52t4e2fknnER0Kt
 FcYS7fIiN4wWDl0ASChSK3v0Zoejg5RaLMOZz5Tufj1D1PgBp+DplMpnIQB7sNrSp4VRMoFyD
 BI6Dz1POCvCJFAX8+/dvQpwuyqnPZvX5Nv9MZuKZ1rFbs4PZ9j1S/oguzAVJraplEe1QLPF2w
 hs3qRQcWDIn4svERK8SEe87RZc4BpbY1i+WEnZjovIOFzW5f0i4hxURtuNB6x3GfARikpsq13
 NQWudv2hHXohFZSIIoU8qTacMF+G6ZWmeF2QPHW5jKdzUSE7rDX3EQQbJwmbI7mBrEDB0brF9
 BtkIwKcU5dQ+oaFBV7WR4RD0dm6nEUoMdhPMuM7roCTyr+HLMuUVHo3jTsic39c41UfsgIBLS
 zC/6NeF6S1/G54v2xP6OMIo1uMhNwsfcc8TILa1+HG8KcdMPjJWaGI/VNmKwgvseI70JSU0Cs
 wwdcz+dUzxiKpcAlVpPzD8fJVWf9eQAKYV9GgP8yeOka8qDCmiHXRPFp4/gGLcHYJgX1u8xfN
 pShVwTNZ0bGCMBsn2UbNmg4XcVECgao9xdEekMlemqFGLdyXLxSh99RzfGzd6sYsRMVb1qZfD
 z3ZWlU1ilrq/EOHfJLFFccM4easMqond20lEJzQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

There are two D11 cores in RSDB chips like 4359. We have to reset two
D11 cores simutaneously before firmware download, or the firmware may
not be initialized correctly and cause "fw initialized failed" error.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
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

