Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF23A117987
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfLIWjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:39:15 -0500
Received: from mout.web.de ([212.227.15.3]:44983 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfLIWij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931114;
        bh=pwhCYI/XZUvd1PCjnnSsB3espHwYSHG9Tey+eI79854=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bZ+QlWgZoi3c/kSudFVvxWFNcPW7p3hss+qxmf9p4CtRLBgBIF4qttCCQDt4eXYzM
         HchF9dl96S03mSr+Dp5SwjG4uSLEzBHG3rFqRlEsDow7APQ6hXRPhmndPkWAvHVgsv
         vzo1Yq+JJFSJpYY1t8sXhcoste5K4hKDhQxvkpv0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0MhOpG-1iQe9Q025K-00MaZJ; Mon, 09 Dec 2019 23:38:34 +0100
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
Subject: [PATCH 6/8] brcmfmac: add RSDB condition when setting interface combinations
Date:   Mon,  9 Dec 2019 23:38:20 +0100
Message-Id: <20191209223822.27236-6-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Ki9Ind9oIDd4Wyya3GAiQC8qQwjW/Q1A4tin9SB8ThC99hwPL3e
 hnncUekk38EIjbtIWV80GiH/Qk0X5ex6LlHeaXBl5jsL2bLNoQN8mf0E3ISUs0Njt9/AODP
 0opcuoQ8grEpP0rU+bDfi0J9xa7DAeLem7HeRBMaZxFoF8AqETsJGV5eGJBTayglu+GqWtR
 3R9cbRX0zUXPBMWKfjqQw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MfcGgLzc754=:gc/tQd7+NKr1wOVGNhtXIK
 jbcUpInQwItLTRKolJJI1JlcLBScBvvwD6iwzobbX6IWVYn1qX2zEK+KIe2iLcRsz7R2b768b
 dWmMdT6k4uJzAOztqHCwxyRLF2zgVALBfxc1mV3gMRMz7GECpD0ceWGZfsslGoiNqyiuAJ9aU
 P3reCK2XJvWDu0u8fS3f+379Tk5dTSTYtn0ZVa07CgRDPuPsIzcKl1gGTawN2bMtJW4WZOaYl
 bYSfDeV2+dVmmFa+0ydP7zLGA3l5JEzpsqwynF3aPtMH79eLK8z5JRT+NBvz0DozNLmtc/h51
 CkZGj+fYuTcsec6o/EtAvAahwgBfgNRULobb9pM4QmJHY062m+5QuBOQ/vTkA4iSu6aGrKdNF
 rNHoVvjChc8N1nJfNnF2yN0Gx3ChkiV8JbG/DiRkkBJgj3lQJmF/1d9GHxVr5w8Qa0YAlzRCC
 r2pHQ8uIBepZTxmtzImaLM6aGCjbJdmySpjnLfqMbpXTN+dNauXzl6qOHT2BwptrxeXNh7ZFT
 59KBM/VgwDNnRXCpN73KDyMcnEg/ZwNbHqjKCHfQ+7lGbLR9oNS4/lFiRx6dpBUYIiyBegitX
 REBhO4tBV9LtNUwcgNiFOLjIS52shomJgWjiScNdzgJAuhfbx9wVu1Yb0uxG6vuxQTT/tgBAK
 +9Ksm9fpZ1c/A3vzxKowvfUsoXLx6ASr4LNMTuTZGyOZZFKC590zON4kTW4H2IxZNudE+UAxZ
 +C1UIVrKXLDWlShtAhgvp00FPFWAwqqHO4oEsHTkk/zsvP+LeUfxg7BR1DgeWWuUXVpIBS2E3
 1zM1LammOitfRBlZmsY89041KtU9j3W4yyTOhS6shdUrf2bZFe5FfUibva+k2ab0jV0oI6fAF
 pWWzTjZjQozL6dfMdAWQXPeAFmUMXZUhYanoe1vnVv3j9r0fVln/y91188OymC4tta2RhR5Uw
 89RKfcV364Xj+xABIroz4Y10FaATcWr8vXapRlniS773K3CzYBs4j+igv8D+KTQhDkijdiJ5q
 oMG1hPq5c4Cv5jAlgQTEuVaT1+ZocuhKgTVGVSY7M6akAzl+88Gx42+p4TxXbaxh71eMyQLGN
 Hlu9RpCfLFDjjsiDrlXrQXgdYYP4jEOVZ37KeWiF8ZEZQU59mFkgYqXSNPxNoaK8V14ZyUouD
 c9vsvt08mUGff6kzy5fs5CHOzA1WoglJlbvyXzPadMHoxt2oOyUMko62svjo5EhgeJXuzcphK
 aCDPf0Yt57WFUFjLPCckzwCzb9kn0SIN16m+vXg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

With firmware RSDB feature
1. The maximum support interface is four.
2. The maximum difference channel is two.
3. The maximum interfaces of {station/p2p client/AP} are two.
4. The maximum interface of p2p device is one.

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
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 54 ++++++++++++++++---
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0cf13cea1dbe..9d9dc9195e9e 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6520,6 +6520,9 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] =3D {
  *	#STA <=3D 1, #AP <=3D 1, channels =3D 1, 2 total
  *	#AP <=3D 4, matching BI, channels =3D 1, 4 total
  *
+ * no p2p and rsdb:
+ *	#STA <=3D 2, #AP <=3D 2, channels =3D 2, 4 total
+ *
  * p2p, no mchan, and mbss:
  *
  *	#STA <=3D 1, #P2P-DEV <=3D 1, #{P2P-CL, P2P-GO} <=3D 1, channels =3D 1=
, 3 total
@@ -6531,6 +6534,10 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] =3D {
  *	#STA <=3D 1, #P2P-DEV <=3D 1, #{P2P-CL, P2P-GO} <=3D 1, channels =3D 2=
, 3 total
  *	#STA <=3D 1, #P2P-DEV <=3D 1, #AP <=3D 1, #P2P-CL <=3D 1, channels =3D=
 1, 4 total
  *	#AP <=3D 4, matching BI, channels =3D 1, 4 total
+ *
+ * p2p, rsdb, and no mbss:
+ *	#STA <=3D 2, #P2P-DEV <=3D 1, #{P2P-CL, P2P-GO} <=3D 2, AP <=3D 2,
+ *	 channels =3D 2, 4 total
  */
 static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
@@ -6538,13 +6545,14 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy=
, struct brcmf_if *ifp)
 	struct ieee80211_iface_limit *c0_limits =3D NULL;
 	struct ieee80211_iface_limit *p2p_limits =3D NULL;
 	struct ieee80211_iface_limit *mbss_limits =3D NULL;
-	bool mbss, p2p;
+	bool mbss, p2p, rsdb;
 	int i, c, n_combos;

 	mbss =3D brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS);
 	p2p =3D brcmf_feat_is_enabled(ifp, BRCMF_FEAT_P2P);
+	rsdb =3D brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RSDB);

-	n_combos =3D 1 + !!p2p + !!mbss;
+	n_combos =3D 1 + !!(p2p && !rsdb) + !!mbss;
 	combo =3D kcalloc(n_combos, sizeof(*combo), GFP_KERNEL);
 	if (!combo)
 		goto err;
@@ -6555,16 +6563,36 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy=
, struct brcmf_if *ifp)

 	c =3D 0;
 	i =3D 0;
-	c0_limits =3D kcalloc(p2p ? 3 : 2, sizeof(*c0_limits), GFP_KERNEL);
+	if (p2p && rsdb)
+		c0_limits =3D kcalloc(4, sizeof(*c0_limits), GFP_KERNEL);
+	else if (p2p)
+		c0_limits =3D kcalloc(3, sizeof(*c0_limits), GFP_KERNEL);
+	else
+		c0_limits =3D kcalloc(2, sizeof(*c0_limits), GFP_KERNEL);
 	if (!c0_limits)
 		goto err;
-	c0_limits[i].max =3D 1;
-	c0_limits[i++].types =3D BIT(NL80211_IFTYPE_STATION);
-	if (p2p) {
+	if (p2p && rsdb) {
+		combo[c].num_different_channels =3D 2;
+		wiphy->interface_modes |=3D BIT(NL80211_IFTYPE_P2P_CLIENT) |
+					  BIT(NL80211_IFTYPE_P2P_GO) |
+					  BIT(NL80211_IFTYPE_P2P_DEVICE);
+		c0_limits[i].max =3D 2;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_STATION);
+		c0_limits[i].max =3D 1;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_P2P_DEVICE);
+		c0_limits[i].max =3D 2;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				       BIT(NL80211_IFTYPE_P2P_GO);
+		c0_limits[i].max =3D 2;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_AP);
+		combo[c].max_interfaces =3D 5;
+	} else if (p2p) {
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
 			combo[c].num_different_channels =3D 2;
 		else
 			combo[c].num_different_channels =3D 1;
+		c0_limits[i].max =3D 1;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_STATION);
 		wiphy->interface_modes |=3D BIT(NL80211_IFTYPE_P2P_CLIENT) |
 					  BIT(NL80211_IFTYPE_P2P_GO) |
 					  BIT(NL80211_IFTYPE_P2P_DEVICE);
@@ -6573,16 +6601,26 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy=
, struct brcmf_if *ifp)
 		c0_limits[i].max =3D 1;
 		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				       BIT(NL80211_IFTYPE_P2P_GO);
+		combo[c].max_interfaces =3D i;
+	} else if (rsdb) {
+		combo[c].num_different_channels =3D 2;
+		c0_limits[i].max =3D 2;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_STATION);
+		c0_limits[i].max =3D 2;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_AP);
+		combo[c].max_interfaces =3D 3;
 	} else {
 		combo[c].num_different_channels =3D 1;
 		c0_limits[i].max =3D 1;
+		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_STATION);
+		c0_limits[i].max =3D 1;
 		c0_limits[i++].types =3D BIT(NL80211_IFTYPE_AP);
+		combo[c].max_interfaces =3D i;
 	}
-	combo[c].max_interfaces =3D i;
 	combo[c].n_limits =3D i;
 	combo[c].limits =3D c0_limits;

-	if (p2p) {
+	if (p2p && !rsdb) {
 		c++;
 		i =3D 0;
 		p2p_limits =3D kcalloc(4, sizeof(*p2p_limits), GFP_KERNEL);
=2D-
2.17.1

