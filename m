Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F011797F
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfLIWio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:44 -0500
Received: from mout.web.de ([212.227.15.4]:59763 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfLIWin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931115;
        bh=SSeAMdCB1BI0vkLB1ST1678SOkLJZQ2JmPrRyeRBBYc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JBqoF1NY8KbCvHeRBd7aa1W4xBStxE6LbZPWng5vycoBbLoHUv0kPZyte5F+U3xQ0
         7PUCkm8ByPmlCV9mo3dNc9IDGcULYX6HMb690G92+egAEvRO80bXiRDQT0c0gMXypO
         3h+NWQhBte154UPkdf/PGY1H+pScE55xQaIyQNAM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0MEIQq-1iXt9n0pUe-00FTnj; Mon, 09 Dec 2019 23:38:35 +0100
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
Subject: [PATCH 7/8] brcmfmac: not set mbss in vif if firmware does not support MBSS
Date:   Mon,  9 Dec 2019 23:38:21 +0100
Message-Id: <20191209223822.27236-7-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6++YHmrTlcLgclZZagPILW3aNmSthZq6p58mEA5GH9f4DaqT0Rn
 p5kid7pqxc18d7WLWHprDHWEGzQXEUI3eFfXmpfrzqx5xmqA4KmM1JiUYPCKHFOf0iInnkE
 mgx38oZ9otELobLVHZkQHDP4fBwfvN+slStAWaH8JjV6+nDXp8S3omcZfMKJv+holEvA0Mj
 HSMjJjHm8pdg+zsxIWCRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PpPtRcmL2Dk=:ZxRx6iZ+89cT/TEvSSrbyC
 kdcHHvouNJ+4QThb/cU6xXEGhulP2X8j3VN3dLCmPcQ7dI/OGha7lWuBWFZsIqWAFokl+TX1w
 ns2mdTrdcbpia41YU43F3mliYwpMWqpxXqZzTtvu5/+WGnXVVm/Eq80mW//DPqL058NTsOONl
 fN1BsocRYLCBzvUpBrBTtLfaiT8nG5wIVFWDh+YyGOmFRwpp/NkkUXHtNmRTDlMvxVe1uSQcH
 zQrsjE77kY6ZKrSAgvlDRBnuVKX2YbkoNre+/POOSnC/9SCvniZJXe2W5hywoRVaEdoBakKVD
 GoZ5nwQAwYwViKKlKlKgVD4sLObmqdpqd7o8Y0in5yb7vaVMN4C2ZU7ZUHDvX83sjqnSlaHG0
 bv17Zrsro+woqoH+QXTcFtsIxUNZnV30yD5skNY5Hfu8Vqufi2iSMq9obR65C/ajyFieRESyz
 bhbUxErjqLBVA5dzq/VopQ27kcS7Z9UgHu726Oha0Gf/X94MZ1wbcFMpCvqWG7AkqvaJY6tpm
 l+X3TZ2B1LdZ8J95uWtDSxlDHXGomjv6fqIu2wnLCy9vrEYws6IsjlU9bvvLlUBFjpMIrcNGH
 lr6N3gp30ZPzhiFzgrRhnAlGm7NqhP2Rzc1wxEkbuVEBaGslr3yR494XO6rYQS/NKhHaPmUFd
 3v5VyogWCwXOreg/M/zjsXebk9cjHKGfK2BoQHRgAhnpGTj1AErMpXKNHC89GbquF8MDcBkb0
 80f5JQk+e7p1zmRHC3j2CQ75ILZz33XTqdm1kzIRC32/twPN/HwGuQa5zMGf9ZazgRrY8Ck2I
 y7m0CCY5ffQMFjteiGryoh/srNsPbDhgX2io1/dGX66XujH4FCpWUUnYNilFtYYwjE0agZAD9
 y275EANsY567Oy8k2ncmNUc7aypkCbPYPqbbAenLYMUvRvrz5ERQvrf57QZDqMHq9hUEp0yc7
 o33UsTkNgNN1u4saJG05Pfi7NzmtNpeA5QVvOg+bXWBFTWCKKTVvf40ffsiKkZID5+/B5ptP2
 9teLY7Q7Kx5+AGeYlD1zTMmMCvzP4o6ENV3BufqsBlTdgegQ82xReWvIHyvxMpFmy+7uLpecD
 N+V3hOrA4Qt6CfxjfpQHX27WQmrYztGuAeHLZ+SW4D5QVj3YDRUB36UhMSPYx/1YF+hs4fopL
 vi5nAxIYKzOE8Sot5uOgaAmDEHMsdxpo8ADy3Dpcwn22YIv/4rV3j84nImPidl1oF6PLQoScz
 D73qSg4WnqOs4thD1rKRPMHwchZ1eCgB1VgP8Bw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

With RSDB mode, FMAC and firmware are able to create 2 or more AP,
so we should not set mbss in vif structure if firmware does not
support MBSS feature.

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
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 9d9dc9195e9e..6eb3064c3721 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5363,6 +5363,7 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct br=
cmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_vif *vif_walk;
 	struct brcmf_cfg80211_vif *vif;
 	bool mbss;
+	struct brcmf_if *ifp =3D brcmf_get_ifp(cfg->pub, 0);

 	brcmf_dbg(TRACE, "allocating virtual interface (size=3D%zu)\n",
 		  sizeof(*vif));
@@ -5375,7 +5376,8 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct br=
cmf_cfg80211_info *cfg,

 	brcmf_init_prof(&vif->profile);

-	if (type =3D=3D NL80211_IFTYPE_AP) {
+	if (type =3D=3D NL80211_IFTYPE_AP &&
+	    brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) {
 		mbss =3D false;
 		list_for_each_entry(vif_walk, &cfg->vif_list, list) {
 			if (vif_walk->wdev.iftype =3D=3D NL80211_IFTYPE_AP) {
=2D-
2.17.1

