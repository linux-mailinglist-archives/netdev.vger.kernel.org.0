Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0433CBA2A
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbhGPP5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:57:43 -0400
Received: from mout.gmx.net ([212.227.17.21]:36113 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235486AbhGPP5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 11:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626450862;
        bh=ksXNeWjE9mhpCKojHZGUGRXqHprFXeYao0Gn/NsBK8U=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=i9P02b+kqG0pOmEn2zEjkJQdcLNp67BynztKujypNcVILLZ3O6Crhk6ucIGnpUceP
         6MWHCw7leFwTBh0eV7ndUEr9Dv2lLVKbYIDCAY8Id0T0tD7KHxjoN1hGrcNvjXlx61
         jxw49BlW3t9wHw7ft6RIycbUr1m3eXnHuvxITeug=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1M7sDq-1m0aQ32sx0-005368; Fri, 16 Jul 2021 17:54:21 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Brian Norris <briannorris@chromium.org>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] rtw88: Fix out-of-bounds write
Date:   Fri, 16 Jul 2021 17:53:11 +0200
Message-Id: <20210716155311.5570-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IjyohTEALGQ+L7Bvo6QDJsF/6QSuDrYezBtLbESGF0csYR5NTV1
 NHKHPwx93NIqHuaFGJK6Xxmba5c+bblv656SSXc3jYDWfZFLcyab2HAzJWRCp7PJKTP9UkV
 BoN9LXhGadp2OgHbRROuyjQWMzZ6FMCar3G+PvQy4AZiAoV2kPxoQaC8whYpst2wHD8zzME
 gt0E/C9LBYM1vHXPh+LDg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JiOZJXCc/74=:eaIqEpLHflGIBNOan0ZdFj
 KEiyJRXY+KkmJfWFBEho7QEAYeq0e+lL1VMPwfidouDM5RYQPirB1Rg8srgbdWCyJ+nFPKWJv
 cVz871PMUU4NW4gTox5hKHvgJVqDMbORETcFOKeWRD7cTcbvEDxrAKnDqfChvQ5Z0+edjj1MG
 M3RhzAOIpouLAuG92pK/TS4IJNxPa1ScE7SumPPNfQOJXwi910yZVJswAQrm+aB8ZHSOWh/X+
 B+mJTy68igW99BfQmzCPYOzMqq6XUtWDT0mFDOCvA8xD31jU1lRaSTxut1R4zdaMLxAFc6CIu
 9prVs2ya8CBLgPdYvnW4xwBo8HZYERDZEk3QpwzWWNdrw4ClwuV5VF9dJvVzi88EKnnbEh1ZX
 nXATaRUVMuoavJa7jLaYNyXCcWJij1nR7vfJBMo7otLqHsIW81bwksxoPyCHoHOjwJnWYMFKD
 kLkOwEH/mokutu3fWlxqgXM4SG0BpSQdKGvBiIG4v2S6qV3Q+cFQmmj5xyq7oBHy2MsqH9lws
 AAMbRNgfNUzEFPrpPc6Io82oZsRD+SRlCAtxADxBweMyjtlabSvmz8MtUgIN3xp2IjQB9dz9+
 Cbml35Yqh4e8cPvjYm9GanlZD3wEGQln5YdDX8FOmzz11bxmvueXrNDTf8uvmvAD2LmPVsWuX
 5dEqwKeJebuNVRhB8voIvOJ/jQ7kWA/os+8U89J0o9rRe5c2AJWBOitNdWRBY67RQez57Bi0w
 GPxpG/yP52e7TOJm99LnJEuBoyrhqNQ3x6zl4XLlLMdUXudjIWEUxpAO4SOvt0+BZByk2y+Ll
 LdZjRA8U4tu4/bqQx0IkPVmPHWkmckeXbKaxwYBfajJYYI+yy6se621PuEx8lFi6iOE8sli0e
 IEaZILITreJux6HiLlPIdrYB7ABg//82xa7y7jQ6lBKcvV41Wrb2TiabQOViP5d3tIsyxmnyR
 Z8NwNu27xO5dTKIRfhVtWXIK9jxESuO09+EO8nKCYKz6aOUVwI+hj4pM9slW8aTxl80f1ysTK
 V0TGNuuRoSE8wjNqZnd80hlE1fB8bLNTB7wPg9Wde8z/giYFzfTU5GeYLGj3HYQMUpamTbRAE
 yd1SLkk3a3GDxYJJbnMtPCt+GEhdUHw4Ymp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
statement guarantees that len is less than or equal to GENMASK(11, 0) or
in other words that len is less than or equal to 4095. However the
rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
way it is possible an out-of-bounds write in the for statement due to
the i variable can exceed the rx_ring->buff size.

However, this overflow never happens due to the rtw_pci_init_rx_ring is
only ever called with a fixed constant of RTK_MAX_RX_DESC_NUM. But it is
better to be defensive in this case and add a new check to avoid
overflows if this function is called in a future with a value greater
than 512.

Cc: stable@vger.kernel.org
Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")
Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
Changelog v1 -> v2
- Remove the macro ARRAY_SIZE from the for loop (Pkshih, Brian Norris).
- Add a new check for the len variable (Pkshih, Brian Norris).

 drivers/net/wireless/realtek/rtw88/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirele=
ss/realtek/rtw88/pci.c
index e7d17ab8f113..53dc90276693 100644
=2D-- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -273,6 +273,11 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwde=
v,
 		return -EINVAL;
 	}

+	if (len > ARRAY_SIZE(rx_ring->buf)) {
+		rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer\n", len);
+		return -EINVAL;
+	}
+
 	head =3D dma_alloc_coherent(&pdev->dev, ring_sz, &dma, GFP_KERNEL);
 	if (!head) {
 		rtw_err(rtwdev, "failed to allocate rx ring\n");
=2D-
2.25.1

