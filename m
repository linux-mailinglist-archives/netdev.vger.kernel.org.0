Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18A211C0EA
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLKXyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:54:01 -0500
Received: from mout.web.de ([212.227.17.11]:54749 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfLKXxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108397;
        bh=7pQcYbT5CQoEEaxvWi8Uu1MkcuZw52tCD3i8PVSaiP0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=I1puRLyA2WAJfJ1s8no6Dyz/jMFM+Lhw0Yx5hubaBqNqiwHsTWgCgpNOCLNtJUz3I
         6oJ7nJlRK7wbGM8oNxFcsDCeGR7ejZMiKbnFVUXtQ4ewro+e0C0/C/yABfrYPgycVx
         fp3PUyp8b1Jkp2x4M55FxOxPfxmUfBQAIXdq0Tek=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0MRCrb-1iITxr2kut-00UcEf; Thu, 12 Dec 2019 00:53:16 +0100
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
Subject: [PATCH v2 7/9] brcmfmac: not set mbss in vif if firmware does not support MBSS
Date:   Thu, 12 Dec 2019 00:52:51 +0100
Message-Id: <20191211235253.2539-8-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ydPMbbLZaxGnMRPj9cpe5yDs3Qub8wc2zlvo+FhzRwhJe6CeWja
 ZCPy1SNdvscy7jaRyoNSIbG0RsFSe4egx9rjGpNd4NoevT6JFdb0HCGhS/NAjXoMCF6AAa2
 l6pycAH9BIM/H8KcH/tuyLXVKriNd7KDDiap0vDs/ScJ/nWDZEKMQTAQ8Y5WtbY572+Bhwp
 ba2aIIocLz3hJIpxei3IQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qEBdN5KF0nw=:kNLWSGjSFVvCh01f/tAcNY
 kahsPKtuaZhGgyIZphgzN4umulzK0+fS5Le5P/s5u9RF5rt4s65qL7VnedHmG/i3QIIZWEe6h
 +osDYMfBrw1iybaSyArv9Zy0MT4YOx1Td89/Pd2lrlriCRngPupTyOtbdhARFyaybX0Fg88OJ
 6VVvQ6Y3I7znaxSmWHwWpLJmUG8jfsP0zJ1uqBrvj6FOAzEDSkeZfFAMWv+KyHao8Ji+gigVX
 +d8/rfpv/rkJdxdBuCzN712HEwZk79aWJBG6Xq98PE1ajcMla310phwE8rnNBcFrUB2qCfiMF
 eGe99wPA57fWWQTFRAD4mAr+IXbk7uQ+gCcPQgnTwXEEDk2GrdEmII4C0jpSrdNLKUI0+CL9e
 SgV9td71GBhk+qGgd7eJcionSoFe0Zi7XqzGSDDqjSDpc8Rgy7oRgPv82V8W/AsxRBVyXRhEO
 2e2Pi9H6Qe93MRW8yKNfkhg8A7vsmw25tYKO1j6myN3TS5DMQM4hhpmDRQHsECNlzWXcS3RT/
 ep6JgYFDxyw+gnyJofAjOIr3oaFUz6ZnZJQIZmFO8NQBtVVGL4MOADYbZMAWEWlpiohd0bcip
 58r+0QNJPD97PRjF9iQYc4sDZRgkMDifIcYXKT7QEUxn3Dcq0vwQDcdbX5r8i4JuLBEIkFvIT
 F1XWKbMI7hyV8ZS3HWO3LtHzmUAMFhZWEq8c3BjULmhrf1l3LEcW6uvQ/Dzh879nk5JrMvs44
 IoUJFeJg6XvgoFPGbeNM1GpzUGO9O0ibNmkWTi+gRozt/AEe8GyyD06MXFRowoCtrMDppgaFO
 OErSrflt0SmeP9utL30vMPxlB3i3xH9z8DfsmbMnTNWn/EDLEntHvFdstbvQdWXCsStEzU/VU
 LjC/hPwxJEbOCc0Ea8TXZt/wW0LZFZ4aPQDc66dNvmw/d0XhwXfwILiu/Wvv735rWvDJ4wosq
 4G+tuzIvIMcOjyyd3E3EEjxoaQVmWL60mqCAmIHJzqjOflePGVFKI8iwPIfGHfGcktM3HEfyD
 dptsq6dZd/9ieqUmruWSe8e5jFYuyzjbrkFIIUP6s8pftUBBkySVwG+gzxXoL4nQPAdQtC+qF
 uDbm+nDCX8qQ3Fh35Hjdxco14pF+z36eaWgcTlGoNtiouAYOT2tmfyquPtyM1UV3bPgCWEvHq
 xu3Sfub7wRdxohQvE2VLLnjRhqzcUI05JrvH4un3wvdSJGY5G5uWKfKgaIiuACjDY2EfR6s52
 cZ0ft2+k7BfFKOVcpPrzBN+FoITLSodCaik3LpQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

With RSDB mode, FMAC and firmware are able to create 2 or more AP,
so we should not set mbss in vif structure if firmware does not
support MBSS feature.

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

