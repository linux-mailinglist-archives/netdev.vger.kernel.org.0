Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459C33C3D4C
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhGKOUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 10:20:18 -0400
Received: from mout.gmx.net ([212.227.15.15]:53367 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhGKOUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 10:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626013037;
        bh=gAAySSNhDxt018JZrqwgBWgRjmAaw+xM2bZjBeOvBe8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WmhsX0nIsTrZAJ3+SfFp4NrsDxksIjASW3lqnqhS/wmNwY4T5iq5HqtWL9fLreuRv
         y7abROrWrrXdI2ZFLP58Yed+x15lpT9EmookQs/haOeSsCoxMtQ5US4MB3IQqr9jcX
         749cdfG9B/6zLMgpd/sp8NfzKPVxSwKSo8lIa0HA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MirjS-1lYjAP23yG-00euN0; Sun, 11 Jul 2021 16:17:17 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] rtw88: Fix out-of-bounds write
Date:   Sun, 11 Jul 2021 16:16:34 +0200
Message-Id: <20210711141634.6133-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d9l7wX1UqG1B/VBLaH5UQqglTVrJxa746JufhEGL7GZtfd6DRHo
 Kn0mAwNRBvKb9e5yxE+yUs0P0SfCV1HVTFZ285PT1hnwKTicWHGcwlwtzvzK3KweRPj1Ysg
 KWmO1vlgZSe9CccNpAy2oE8/cagJGb/t9MAp6JprJf9nhro5TRetoMbpX0sBN3Pf8MmIC7U
 aNo+2Gf0dwAO6U3JPeTIQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OZ8Mo/fZG7g=:A1uxAFUAey6P9JyvV3+fBR
 vAIJ7vxaUFdoCYjQu2sL1m7niFzfeNxmiHGcDVf0LdagmMSrDd6lzdlFeqxaJ0G7NS7mL+rwD
 aeSIIBBf8V803cFDoVKJYuy+NpbuqDfaxARtp2BdYBu7ZLpaepLlRHHnMzBO/dZ2Te5wYh6kr
 zhWYRqYeKo39KfS+a8e4WsGNKkLVhCJi9lyswxmxdcoi0oqhLNvFSFF5ZROAXTaCy/jKBwOqw
 okH/Akx0wiE6jLfXqlBS5nIBxkjSliLcTtnLH0+2BQt0XTZQEf/3PlXSjrJAvapANpxAoqHdQ
 Dzjzx6pBpXn8FJbLX1YoObajynmnDnrsT0iJp9b3yrK8PppiyyGl/04+HQDlfPNQiFMTKrYA5
 oD3cv5vVT+3YWyIU5/W5tfIVVdx1kKvITNDwmvfS+Bm8ArJcNNVHTPV6qPWY20Sik98bPHq9y
 xqjepPER58liWYgQZ9q9UHkp8JTSajcyRsLxhwz1KFNopmhijQlGduJEFglBHD7JriRhO4qIf
 YsTpvKilZvRPtcgrdToyyZHeekZCq5MO02eYcpsirj+HOZfi2vBPfLxSPCxj8ILEuW35xNq4j
 OgCYUtInDuSLVVgu2W7jUKC3oacYkyeHqYH2I0AGHx6x4jirQ+/8RJeMDU2O4q4F0OW2x91p6
 tCDt/8CoooNT0GfvwXE9txH+xSEjZPKrNew7RSAdpFFq93xEoqXlQ6QHM6imPevnT08J9e9Mu
 cY4OPxGa0Tbs580+QQ2RxZCikdfVpipQLgcK3aMuSxhJtBuH3swjcM8iZOOs2IWl1tPmoDE/8
 f/pk+6tFhDmvqP9Ob3chIHiYmuyFlxUZ2hA7iDzCJhbpoWaiVpZslTbm3Du3l7gc630h7t4VF
 PGNyj4E1ykEBZ3dj4pN6oERPE92TfjL+LlQhFlsK7pDDz+PCbsGL61dCh25Zns6s06jodqCnF
 sZ2wIlqYz35K4jBC292At3BpbhNbdoXjieJ6Q6F/U/a7f28Ljrl1njBEdwayr0EX2T96AJSpg
 UJoiCE2h1IzQTGfleZVcPCxg8M+Hx+DcDswVkX9MogTeEz3+omIpaPOaoHI0JTipUSJ7bTt2C
 sQopq4mpeVIdT/cQCA9EXHDdM2U2HWgsG2c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
statement guarantees that len is less than or equal to GENMASK(11, 0) or
in other words that len is less than or equal to 4095. However the
rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
way it is possible an out-of-bounds write in the for statement due to
the i variable can exceed the rx_ring->buff size.

Fix it using the ARRAY_SIZE macro.

Cc: stable@vger.kernel.org
Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")
Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/wireless/realtek/rtw88/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirele=
ss/realtek/rtw88/pci.c
index e7d17ab8f113..b9d8c049e776 100644
=2D-- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -280,7 +280,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev=
,
 	}
 	rx_ring->r.head =3D head;

-	for (i =3D 0; i < len; i++) {
+	for (i =3D 0; i < ARRAY_SIZE(rx_ring->buf); i++) {
 		skb =3D dev_alloc_skb(buf_sz);
 		if (!skb) {
 			allocated =3D i;
=2D-
2.25.1

