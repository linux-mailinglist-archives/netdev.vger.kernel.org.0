Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8678D117979
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfLIWik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:40 -0500
Received: from mout.web.de ([212.227.15.3]:41699 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfLIWih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931110;
        bh=W4LHjRvuXjfeB5gbAQ5NHNwz+RRWi7P6JQFcyw+CKWc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=khXVzveH20P2mf+qyMHw4IgvDga9IyY7JbQf2QU7NLvXnBQOklOCgIupgS9cqgfIP
         QHT/ceQH/N9xRiPxHlhiE/hUlGIcg8BqlujhglMcRX0QsdGTVj5/840J0Dmr/V/265
         5U7S5DFHXaPvP5ZSPGqKMv4dF5nWgGAe3TVXnWic=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0LseoD-1hckCF1pft-012EuE; Mon, 09 Dec 2019 23:38:30 +0100
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
Subject: [PATCH 3/8] brcmfmac: fix rambase for 4359/9
Date:   Mon,  9 Dec 2019 23:38:17 +0100
Message-Id: <20191209223822.27236-3-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Yw1vY8NeKWXUDW5sWvr8IKQ9BMnrfLJRypFscSFc83drtcgl0wq
 7jPbevr3iY+DSFn1DSTOhi6WrEl6i55g9aZJC3MCnPqikfdmFozNhetJ55Eu1abQartENQr
 6wyHee8fyuRJI8hKWLT9IgthCKn5F73bdqkvtso9BFavhqUnEgMxjvXbdYxTEM+0R+Rlj8/
 vinNr3LB5dl44UpcB4fqg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S+pp4J6aXeQ=:LTO73lOC3YfAik5gAp/zLZ
 EMyGiDVAZLbSjN3P7UsqbYQVMZO1JgsEefOIh4WBEqV3wPnQYKw3fzHiYRgeMa4obtL1GI0qi
 8TxMqhzq43D2AHp5JuLNeb9UQT0s0ggYunEw05fXZxUpMV9s50cESlXqHGn1mF/9wzQhmqhFM
 kt7GzTMO0rTPpgxjtmgIrANrLmvNrYgIWBEHyT9/ai50Z84KyWPNd0N948TKq/oiQwetNi3Qd
 yY4tUajVuqJl0NvkijDtvsgbWcJwhGF86T76Kyn/0UiFa6BRJICCOGPJVcGj8JMcnWgqiohFY
 xishsKRV4fQrAvt+UrYwLt/t6s9KIZ6JsvNuCen87H4BTR5iTrLUAjqQ6adP+MpDZqEnxkNpM
 Yp0tpEIK3Wt/oXtYNPB5HQqSQqyeuLrMrvwyHDa23hx0SLKdr1ELoJEaHGd6nb2/08fStvyWq
 908B7HXzLiT3cHmM0ivZVpABtfbOVG7TP8v+CqNe9J7A3f+vZEy/sUyU40bN5eRQexxrjggB5
 FsG8snFE0AbDtdyiPP3UbvrGMcZ6Qhi3owZ2xjzXdH2QDl3vVq5Jd+RpnCfrcqUkNDSo/UeSj
 HkgVrBOsQiHq6RkAmeAEydWCIveJbqmead7oSevDeCRv9V2bmQfLbfVTJXaNzspcvsQ6OKiZ+
 YbAeI6n+M+eyA+v4BJcRJb+ZgBcV4Utv9HayEXvhJxohD5Sd2HoYwTGqvyA70sXyFPQxtbsgK
 E97mlavoXIg3NsAfWKkaSYHDQr/Y32WO4TQK58DM3u8oJP79KkmNTrWh/a5kJUlFYGbc5VLri
 VVe4TzD8WJXuwmVWXgMzAwKZMjpnB+NhK0pBeNIwSp9qfmGFI/UW6LZshrgtbXSPdha3NBeQd
 r/90rPCoUEL7ISWko1eTR4DsUqRLdKAq5llbvSZfkpv3dQ3c8hS503LGT8iP7XIiZM4xkDnBh
 TCjmOMepMa9jDThFzQncQCiMBiWR8WZ6t5ILlQj3KSgEsuY2BPIsBgAy9SwfZM+gu/+JY26K0
 20ey6zM1KcuybJx9mS1wpUgAUVcWVqEC2nLXwGxQgLCdKJwvS0lUp42rzxl2t7LDEe0fce/es
 He4NpBm5Qat4D5pBhN7iVGkpWHwY5gIA+wIrWy8XvaXATGZv69lHnZgbkNfo5mBBjBHWQ24ti
 0Gz49E1f9qozjJ6Tmf0+ax3j8RT7JQyi8PEIuqFY3qL5ZxF/GQH8jkxcg+baw8qdgTNNqFQfG
 7TZi3Y08rumLO4y4aGO8nvEQlZiO90pkGh4g7hA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer 4359 chip revisions need a different rambase address.
This fixes firmware download on such devices which fails otherwise.

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

