Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC0011C0F2
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfLKXxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:25 -0500
Received: from mout.web.de ([217.72.192.78]:57387 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfLKXxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108391;
        bh=4up7UPdrXKf7f4RHv1AgVYW/yVkK9as9YFQa80qMoKU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Gu0wgLpKWDiMw/KjGhRNXZ9fgdBWNCo60e8XriKrwIng+KPeNqpb/kEhnfL61n8xU
         y5uala2/lTNOlXb13l0+YYMpnYRQXNnxT+eF5/UJuF6VzvntIVODJG/yru99dgUhdx
         grgsKlgO5zws0iRjvX+lUFlh/JJwtKWBbhs5reT0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0M5fsK-1hm9Ms2iPg-00xdVy; Thu, 12 Dec 2019 00:53:10 +0100
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
Subject: [PATCH v2 3/9] brcmfmac: fix rambase for 4359/9
Date:   Thu, 12 Dec 2019 00:52:47 +0100
Message-Id: <20191211235253.2539-4-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:J+qJb/2Nw7OkPT3SxGUR8foewlU/Godf2lJr2WJR7yAVKyzHMHD
 qqJRwEwFwDhjVM4go/USRgAOn7yIJ7hgH0ExeEB8svnzBOJMvZm9v/oljINQkZksxz9yNOA
 nZNEOx3OYiAWZsAF9XCEJRfKHyQj1eGGSJYFqKM4drCj450VoEt1a3CZfYDmSsgUY/TjIq9
 kDe/TDllVqMrz07yDQuvA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eZTTKvKqCQQ=:6Ufks9S8uTxW4FlPFgpy0Q
 71OY5XEmQ3puqHczlBr9G3y68a7jVmC4MRrtYw/khbu/oi4xTOfBxnEuLUSNqWDo5NuVfk6YQ
 WapEexeYcScN7aZ1zXFZbAu1f7Z7M4qtsmXLA6jGSufrsxzQfVP3IN1pf3GaPnizWcWf/bNIj
 O4Gh2od3tRllFMrzAJdr8VKhEJMr2Ct1LUDHAzGpmpxDF3l68Ma2mGBWlo0wvsOitYg04hQal
 mO8Eo9Rt9R1xJyzlXy/2jXuQ1/jDClhLabD+H4vfdQUJinP2q5mmcYFYQwq1EqczeTe71+v6+
 k4z9DtxSPIgIGV2ONgBvabwQz3Vw/fpTi22AkUNPF3f6FqsafoDnyMVBPfkQC99sjZ7TEAhHZ
 VUNXg92gOV7gPf8vWr8Kv6y/szKOGKrnYTDqPN2DVdrE4uSwNUTSxE/Hz11G+iAtBhVew+wH6
 I1sgG0LtAVJ+nN18k5MePHtETVFCploNouuXpHmwfChr55+hQG1KbUPh2vQdp7dvJtCiLjzGv
 kXsh0eKa3Sdv11WGjk4jads0yY5UjX9LYzYVJ+P4Kcn6i/0yhRVIYpY1b7J/QsENZy1TOr/XW
 VNiHhyOYcy7SzHKPMbtVaQF4W0V/377BbepKwymrnartfDkj9XPp/W62Hp9wG+hMKwigsg3Sb
 ifpkVeyAMdTzFM5xL+EgqNgKXkW/AsS+pa7dPhrINbc1vsd9gVCSk7pNPAh0JSGogpsic3+i8
 VKiKUU7PunL1Lpji2UjNO6nt9vgFFkPbD981hlsERwu2nxMtAfydLD6YhcP8qR5rHqB7eYeyV
 JJX3v7lJfobutiPHvkc1n9f9ePG1U0pU8LNfQ8f6CY93mp3RZEuM+wuyLDoMxncbmz7mhXStd
 ru1xsPWf+ZgsEnGCFQL+aH7X0JgJjXDPVg6x3vc0Zbr4WJw2MMqfC7qsFscAx7sqoyfMPPn06
 Nil6mLEGhUEM/W6x1H43WXV9MBqFoN6p+FWFm0N/MyfAeE+PqKqKL1CH75ZtoZ6LYDbQFFqq9
 9zSDIiIkd9pWD7Nsbr4Qu2MzWw0a0YIQXBXDh2btzsroEe34y0fvhfHrsdeeuIk8nHdlRsKx5
 cHHk+V8QTPrsRo4NowK3YbQDhTB+mNQo2qu7m7l9MWj+m5Jbm7LJyS7+jDLP4KJaDER5YPpCV
 I5QlQfPw7W77CbOXYX/IbQEl1hswoCQ0UwhOKTml+ue5HgLic42YIXpinn1+Sdh/oCLZdFPsM
 ayYpBwmhI8hqkatdtbKb/ugFIcs9ed3ldOf+M2Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer 4359 chip revisions need a different rambase address.
This fixes firmware download on such devices which fails otherwise.

Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
changes in v2: none

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
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 0b5fbe5d8270..baf72e3984fc 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -712,7 +712,6 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_pr=
iv *ci)
 	case BRCM_CC_43569_CHIP_ID:
 	case BRCM_CC_43570_CHIP_ID:
 	case BRCM_CC_4358_CHIP_ID:
-	case BRCM_CC_4359_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
 	case BRCM_CC_4371_CHIP_ID:
 		return 0x180000;
@@ -722,6 +721,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_pr=
iv *ci)
 	case BRCM_CC_4366_CHIP_ID:
 	case BRCM_CC_43664_CHIP_ID:
 		return 0x200000;
+	case BRCM_CC_4359_CHIP_ID:
+		return (ci->pub.chiprev < 9) ? 0x180000 : 0x160000;
 	case CY_CC_4373_CHIP_ID:
 		return 0x160000;
 	default:
=2D-
2.17.1

