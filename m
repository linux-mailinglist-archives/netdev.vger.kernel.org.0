Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21EA11797C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLIWil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:41 -0500
Received: from mout.web.de ([212.227.15.14]:60519 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfLIWij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931112;
        bh=dARkS0M+XpGAi20Nwmuqmr1ij7g26rk5Jm9XhGn3X28=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=rKUhppjksax8mD5rW9s1JbYp0YF3eo+K6piPZM/4qZSbyilg0B8RtMAhH0AUen/uC
         ANmNN1VjQS0gojRY0K+rvnJ4yFS7MfGJhpIz8q6GgXkuyaPhlZJlBpqCCHHxI29Uw3
         VQWPl1xpDRIL5Li6QyrJxcr5aWRUXj1vDW5I61ek=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0M1lTm-1hkgYf327e-00tkaz; Mon, 09 Dec 2019 23:38:32 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Soeren Moch <smoch@web.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] brcmfmac: make errors when setting roaming parameters non-fatal
Date:   Mon,  9 Dec 2019 23:38:18 +0100
Message-Id: <20191209223822.27236-4-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IOLsB7dCM+gHHuazLXyGup3WXuGYoG1k/cTEKuEIU6wPBLFsZ+M
 QGVQ/hVQoWlh8xnCp6wWbNk+oPQuTTjqv5EYmp+khV5fJBbdq+XfrqPZeJ/6cTmK/V6Glml
 28dMt7MC6UXZe1+VWf+xlY4ifW17WGTy8KbxCOv9CA6QRfFxXluuuSy5JyxD/foq0WoUMJw
 VsgqN4OorC9BbLQV1Shbg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bgraCoPhY04=:LSrbsDfEXkw9IWRh9b9qHb
 lONl0Xc7/kG2+x1QzDx9Md5rmR951HhV49eCHIpjz0Z1mdGTQ6YrJ8nt3aYISTV0kIzjPeOR+
 xz3vybYdYHdrBZwrf5IVwKgalekjEG46TVcfx9N/Bbw4IvTLbuui0FSU0z1TRqS5I58xhwLAm
 Huj64ID1WKDHl0PMczyfknq34XZWUzTMMWNPqJL4pkRGx/jW0CS24l2wwLtx1NT8LfK7boWSz
 KtNMJEepddgZp0ifO/aIDFw3e8NfSeehJxA4gBQrkX18nEvHOiPT5Non6IaYpbKuri/zFUTPd
 VZ5Uzo2Z83UvJyc8wbqawM2U4fyE+ue0r4sAClvmR+kCjFr//qyzdvEDn/TrqX55OPlTlbI8W
 oPw4D8fwdSLPjKt9toqSLOCxq4g221skrVwM0EBQ18r9KiFZD2vwh+HIayJo8Y7XeO5YbZ9QX
 iIwdTMT7mrUVThLMH9JYVFjhx8m70DKHWszIKwMYyhxbHK2zz/pBpBgaAaI69BdvYuzi+hlY5
 jira/71Cq303qUjabVPI0OQHRO2HTQLdCtmW9zw67KfWreWlj2JGyFl9QgJEp2MLhaubcSORj
 w4F8zMvkkv6rc5YBK/p1S238bCc/NZp0Jp8lpAyKd1bLz4fKP4kv9mUJkh3zyPZG/22olaKmP
 k8TGUEhSPk9KW8g30/Sh/5W9p+4s9yZhShi6fBTFVepXDnrVTYfy3H5Jk6X/9OWLwwv1EfWse
 xYLS0tMp03a46vgwTJcXmqn7f5Yfq4VJHiTcOCjJfujbWsiAhWuyHOtkOSRAPUp9lfUZR7QuO
 zo89cV4UVGN8a1OQGOHZAekEtm7Sv5yUk92Hb++rj8UAps20h7KcuBvsjBrXc92pjVGcSstYz
 ABVFg3iYZfcbChl4EOZNH6K/k+TA4JeHRl43tKdsnxQ4tE0vhT4jX4UCcDmooc01sKTfi9fay
 1E6eyokLB2uTl3DIgEZGBt312WwAOQ96PPR/1Jxu11UNoxXWEnTr/PVs/g4UN4g7zldG0bD66
 E0LD6zotzfojf1J3wM/NONdG9u81u29ZRDGGjzDudtq2gksTIgYluoq41IodyBFAcJYGV8JzO
 yhvfPFpiwE1KHT/rWRx/AKLR2jtMzODSZdKNMwczUlfP2NUYRiFI8w6Pr1vqAXKoFENsnXW19
 qrrP3OEGxouZdLW6jivzSCmvMJ4zlKp1LegG7AHMLlqnvvnoRXM1xCRPqn+amQrUNkyDb/kSp
 bOaPZy5zs0eklI6d7e37SMrwk+AzKbwBVojnNfw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

4359 dongles do not support setting roaming parameters (error -52).
Do not fail the 80211 configuration in this case.

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

