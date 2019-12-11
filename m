Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241DF11C0F6
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfLKXyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:54:12 -0500
Received: from mout.web.de ([217.72.192.78]:51263 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfLKXx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108395;
        bh=bqrfzn03Wk5A81+Bxtr6JafRDf0LDppSY0FopstiOWU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LrNnwQUqQrR0y8v6QbdwFWGQreRkC4UnLS5vcVMOJWqrggruA85WPRuDtsut44XCJ
         yEqnecDjdVWTJLbeEBdKSRro6bhl4HlystbX32DXbG0J+16xNcdgo0pzXbUjQ/Rumx
         VmqU5cVabbZFYa0qgNLQtUwVMzEIAshhpw5rpgtU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0M6E6g-1hmhaz0h0k-00yBkG; Thu, 12 Dec 2019 00:53:15 +0100
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
Subject: [PATCH v2 6/9] brcmfmac: add RSDB condition when setting interface combinations
Date:   Thu, 12 Dec 2019 00:52:50 +0100
Message-Id: <20191211235253.2539-7-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sObgus2FDRoa5HGMYXoHjJ8dLBCTgL7OufE2JZLV/N7PtqNDME2
 YuQXbzzDjKtPnQsO7f8f9MzJSbdmoMqCb/6c4H24QSLEbLJ8AUwZUsdhGOh3NKpytNJMIhG
 hXxgebyZByKXqYQJn7hWvI2FVd66BOnDCk39Fi8sBq+VoW4dZHw85R6jVOnpy5jpfvCvUlo
 Tx1C7zBeV/t96cuCIyhhA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l+RZ/qB1OXc=:NPKGOTlEvEQpnntq6ydHAz
 fHl0SEXZuE6K9NBqv4Lht5uPB32IkQoru8VRv4/YD+JhRqRzu+tcMxC2gZ5IB67lWwyUdySCm
 uBnJwQR+zq8SQmwMwXiVtWbbYaPtxcQ0OPwiJgkN35EtVWAdo18b1j2o3Y6eiXAgb+yTDfEO4
 QPc4Xh7ZV7/Ozn0gxYjPVXPBRJV+m5jNdO0gT+LKNmb/axMJrSIBvPmuqB+IXexqXIFAxwPhO
 DdJ49akvIGJuQq/h7m3KcOo0bUrki08Pi9KFUo6INuqAEup9RxYJZjrRH4K5fZ18kZOuiIfx7
 Jtjz0ht7DMIP7XJ0gbAdp+aFbgq9mieu/1OzKTp4r15FJLEwXbY+x+VFvN7YuMruvhAlgDN/f
 uydFFv0xu0FTYf0XcqEWIsTOrwK18uAoRBDUb36QwOqZJq3+XAFsCuy6P9Y6IWqnGE4lHlav+
 4yBD7vYaRJWj1eNLqmi8QqSLSaYQ+kNKY40IK+eiTiyjwCumX2WEdTlTpPsvD3REp6CyYJgHt
 wVKBHcBh0uGmpU+PjdLDvaLjeXLSS9NTMXZHTmywifF9gbLon8IKH2GfjUjbfpio0uItVKhOp
 +qKdcNo33fS1f+dpD7kGF0KSy1XTMgfbblzY4yDs4twfxdRxU5RWo0kGPsdf4NxT3XV7gZWMD
 76dZ6dQ0cQxRxmWS6Ebl6SXx/kNq2ih0ox1/gK6awP7WmV5bZP4XwMiRmvVLtwsKtv4BuvMWv
 0JfZf0gFBagGgAEVGPPd0nlodPWZ8OlHGbxBThsTUdS51d265/UdnYQkKigcGBPY3JnBxDis3
 UwLBb5gwrG+zDOOdAAwxZuS7qdnmFlUniQXAFFOf+/JTYJ4X8WdMX1JxCLMzSEhxlWCKELgLK
 4zcMN76iTCWG/YWMnUtvX7w4zL1r/adcNOG4vs4TTum2DsZEkwEWP3bB/b6TyaNGzQhIWwSUN
 yiQrAwsPKj06psAXb7PTg2pinbvSX3REtejpZkkJZJRtYE75gKujsDDaEkaUtXYeSH7LzBSK0
 S9XH6EFM0BNYJ3o8DS7HpcYPyi5Lt8TBZ5V70l/aHBAIHVCfvN9gqXoQQt+7nLCq68jMwQpDC
 r0JrD16e3CTTvuHUKgb4rtUf2H3PGBDRcU/BrKAV4gZPgXqqjS93FL5H7bBWm7EZOGa/K34Uk
 4B+zsViWMt89PTi2nQ0qlYivNwmqGEkMQivWWOSNzkk5qg+vpBFP7lxMoMi8XdZ+Qu3oa1zNw
 tPGbo/eu0kB/3JzBN69//WDdupLb2MjoLAududA==
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

